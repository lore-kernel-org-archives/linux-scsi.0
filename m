From: "jameshsu" <jameshsu@mail.acard.com>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Wed, 19 Jan 2005 10:05:27 +0800
Message-ID: <018701c4fdcb$59a43a60$6200a8c0@jameshsu>
References: <01f501c4fa20$3db731d0$6200a8c0@jameshsu> <20050114174457.GL30982@parcelfarce.linux.theplanet.co.uk>
Reply-To: "jameshsu" <jameshsu@mail.acard.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 219-80-62-20.static.tfn.net.tw ([219.80.62.20]:6414 "EHLO
	Thunder.acard.com") by vger.kernel.org with ESMTP id S261432AbVASCBr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 21:01:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James.Bottomley@SteelEye.com, Christoph Hellwig <hch@infradead.org>, Jason Wu <jason_wu@acard.com>, EdwardLian <edwardlian@mail.acard.com>, linux-scsi@vger.kernel.org

Hi all,

We are in the process to make some change to meet your expectation ASAP.
(e.g. (1) 2-d array => 1-d array (2) meet common coding style (3) 32-bit DMA
mask instead (4) PCI new device entry applied (5) use the PCI_DEVICE_ID_
name instead)
However, this is the revision we are sure it's working.
Therefore, if this is possible, can you patch this file for v2.6.10 this
time.
Within 1-2 week from now, we will submit another patch file to fix above
syntax issues if working smoothly.
In the mean time, we also in the process to submit the new device entry
(ATP880[AEC67160] LVD160 1 channel  /ATP885[AEC67162] LVD160 2 channel)
under Artop Electronics Corp.
Thanks for your help!

Best regards,

James
----- Original Message -----
From: "Matthew Wilcox" <matthew@wil.cx>
To: "jameshsu" <jameshsu@mail.acard.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; <James.Bottomley@SteelEye.com>;
"Christoph Hellwig" <hch@infradead.org>; "Jason Wu" <jason_wu@acard.com>;
"EdwardLian" <edwardlian@mail.acard.com>; <linux-scsi@vger.kernel.org>
Sent: Saturday, January 15, 2005 1:44 AM
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6


> On Fri, Jan 14, 2005 at 06:03:02PM +0800, jameshsu wrote:
> > We, Acard, total understand what you suggest. (including advise from
> > Christoph, James B. and Alan.)
> > Therefore, we modify the internal code to create this patch file from
kernel
> > v2.6.10.
> > However, as you see this is the smallest patch files which could be
> > generated. (Sorry, unable to meet your expetation)
> > The reason is : this driver could supports ATP870 as well as mutiples of
> > Acard's chipsets. (this includes ATP880(AEC67160) & ATP885(AEC67162)).
This
> > is why the patch files is huge than what you expected.
> > We did not make any change for ATP870(AEC6712) on this rev.. Besides, we
> > reverse following codes according to all of your suggestions. Please
review
> > and let me know if this is feasible.  Welcome to any of question you may
> > have.
> > Thanks for your help!
>
> The change to pci.ids needs to be handled through pciids.sourceforge.net
>
> ----
>
> I really don't like the:
> +               atp_dev.ioport[0] = base_io + 0x80;
> +               atp_dev.ioport[1] = base_io + 0xc0;
>
> Just record base_io in your atp_dev.  I don't like the way this patch
> turns everything into a 2-d array ... surely there has to be a better
> way to do it than this?
>
> ----
>
> +               if (dev->dev_id == ATP885_DEVID) {
> +                       tmpcip += 2;
> +                       outb(0x06, tmpcip);
> +                       tmpcip -= 2;
>
> would be much better written as:
>
> if (dev->dev_id == ATP885_DEVID)
> outb(0x06, tmpcip+2);
>
> (hmm, this seems to be common coding style throughout the driver ...)
>
> ----
>
> -       if (pci_set_dma_mask(dev, 0xFFFFFFFFUL)) {
> -               printk(KERN_ERR "atp870u: 32bit DMA mask required but not
availa
> ble.\n");
> -               return -EIO;
> -       }
> +        if (!pci_set_dma_mask(pdev, 0xFFFFFFUL)) {
> +                printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
> +        } else {
> +                printk(KERN_ERR "atp870u: DMA mask required but not
available.\
> n");
> +                return -EIO;
> +        }
>
> You've actually set a 24-bit DMA mask there.  Should use the symbolic
> constant DMA_32BIT_MASK anyway.
>
> ----
>
> +       { PCI_DEVICE(PCI_VENDOR_ID_ARTOP,
              },
>
> Please use the PCI_DEVICE_ID_ name instead
>
> ----
>
>
>
> --
> "Next the statesmen will invent cheap lies, putting the blame upon
> the nation that is attacked, and every man will be glad of those
> conscience-soothing falsities, and will diligently study them, and refuse
> to examine any refutations of them; and thus he will by and by convince
> himself that the war is just, and will thank God for the better sleep
> he enjoys after this process of grotesque self-deception." -- Mark Twain
>

