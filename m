From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Fri, 14 Jan 2005 17:44:57 +0000
Message-ID: <20050114174457.GL30982@parcelfarce.linux.theplanet.co.uk>
References: <01f501c4fa20$3db731d0$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2982 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261153AbVANRpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 12:45:10 -0500
Content-Disposition: inline
In-Reply-To: <01f501c4fa20$3db731d0$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@mail.acard.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James.Bottomley@SteelEye.com, Christoph Hellwig <hch@infradead.org>, Jason Wu <jason_wu@acard.com>, EdwardLian <edwardlian@mail.acard.com>, linux-scsi@vger.kernel.org

On Fri, Jan 14, 2005 at 06:03:02PM +0800, jameshsu wrote:
> We, Acard, total understand what you suggest. (including advise from
> Christoph, James B. and Alan.)
> Therefore, we modify the internal code to create this patch file from kernel
> v2.6.10.
> However, as you see this is the smallest patch files which could be
> generated. (Sorry, unable to meet your expetation)
> The reason is : this driver could supports ATP870 as well as mutiples of
> Acard's chipsets. (this includes ATP880(AEC67160) & ATP885(AEC67162)). This
> is why the patch files is huge than what you expected.
> We did not make any change for ATP870(AEC6712) on this rev.. Besides, we
> reverse following codes according to all of your suggestions. Please review
> and let me know if this is feasible.  Welcome to any of question you may
> have.
> Thanks for your help!

The change to pci.ids needs to be handled through pciids.sourceforge.net

----

I really don't like the:
+               atp_dev.ioport[0] = base_io + 0x80;
+               atp_dev.ioport[1] = base_io + 0xc0;

Just record base_io in your atp_dev.  I don't like the way this patch
turns everything into a 2-d array ... surely there has to be a better
way to do it than this?

----

+               if (dev->dev_id == ATP885_DEVID) {
+                       tmpcip += 2;
+                       outb(0x06, tmpcip);
+                       tmpcip -= 2;

would be much better written as:

		if (dev->dev_id == ATP885_DEVID)
			outb(0x06, tmpcip+2);

(hmm, this seems to be common coding style throughout the driver ...)

----

-       if (pci_set_dma_mask(dev, 0xFFFFFFFFUL)) {
-               printk(KERN_ERR "atp870u: 32bit DMA mask required but not availa
ble.\n");
-               return -EIO;
-       }
+        if (!pci_set_dma_mask(pdev, 0xFFFFFFUL)) {
+                printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
+        } else {
+                printk(KERN_ERR "atp870u: DMA mask required but not available.\
n");
+                return -EIO;
+        }

You've actually set a 24-bit DMA mask there.  Should use the symbolic
constant DMA_32BIT_MASK anyway.

----

+       { PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP885_DEVID)                   },

Please use the PCI_DEVICE_ID_ name instead

----



-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
