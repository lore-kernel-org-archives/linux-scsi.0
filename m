From: "jameshsu" <jameshsu@mail.acard.com>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Wed, 30 Mar 2005 19:48:44 +0800
Message-ID: <014201c5351e$70385c40$6200a8c0@jameshsu>
Reply-To: "jameshsu" <jameshsu@mail.acard.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:45508 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261823AbVC3Lvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 06:51:45 -0500
Received: from Thunder.acard.com (219-80-62-20.static.tfn.net.tw [219.80.62.20])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id j2UBp8eY020316
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2005 03:51:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James.Bottomley@SteelEye.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, EdwardLian <edwardlian@mail.acard.com>, Jason Wu <jason_wu@acard.com>, Hill Wu <hillwu@acard.com>

Hello Matthew/Allen,

Few weeks  pass since we sent update driver for you to build-in in Jan 2005.
Latest,  we test Linux kernel rev 2.6.11 and found the SCSI driver not
update yet.
Is it possible to let us know anything Acard are still missing or any rules
not follow??!!
When 2.6.12 will be released?? Should we wait and submit the patch files for
v2.6.12??
Back to Jan, we promise you we will have new driver to release.
We are ready now for v2.6.10. However we would like to know if anything else
needed to be updated or modified. Therefore we will know what is next step
Acard should go.
Thanks for you help!

Best regard,

James Hsu,
Manager,Engineering Testing Dept.
ACARD TECHNOLOGY CORP. http://www.acard.com.tw
Taipei Hsien,Taiwan
6F No78,Sec 1,Kwang Fu Road,Sang Chung,
(02)8512-2290 x 2311(O),(02)8512-1524(FAX)
E-mail:jameshsu@acard.com

----- Original Message -----
From: "jameshsu" <jameshsu@mail.acard.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; <James.Bottomley@SteelEye.com>;
"Christoph Hellwig" <hch@infradead.org>; "Jason Wu" <jason_wu@acard.com>;
"EdwardLian" <edwardlian@mail.acard.com>; <linux-scsi@vger.kernel.org>
Sent: Wednesday, January 19, 2005 10:05 AM
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6


> Hi all,
>
> We are in the process to make some change to meet your expectation ASAP.
> (e.g. (1) 2-d array => 1-d array (2) meet common coding style (3) 32-bit
DMA
> mask instead (4) PCI new device entry applied (5) use the PCI_DEVICE_ID_
> name instead)
> However, this is the revision we are sure it's working.
> Therefore, if this is possible, can you patch this file for v2.6.10 this
> time.
> Within 1-2 week from now, we will submit another patch file to fix above
> syntax issues if working smoothly.
> In the mean time, we also in the process to submit the new device entry
> (ATP880[AEC67160] LVD160 1 channel  /ATP885[AEC67162] LVD160 2 channel)
> under Artop Electronics Corp.
> Thanks for your help!
>
> Best regards,
>
> James
> ----- Original Message -----
> From: "Matthew Wilcox" <matthew@wil.cx>
> To: "jameshsu" <jameshsu@mail.acard.com>
> Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; <James.Bottomley@SteelEye.com>;
> "Christoph Hellwig" <hch@infradead.org>; "Jason Wu" <jason_wu@acard.com>;
> "EdwardLian" <edwardlian@mail.acard.com>; <linux-scsi@vger.kernel.org>
> Sent: Saturday, January 15, 2005 1:44 AM
> Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
>
>
> > On Fri, Jan 14, 2005 at 06:03:02PM +0800, jameshsu wrote:
> > > We, Acard, total understand what you suggest. (including advise from
> > > Christoph, James B. and Alan.)
> > > Therefore, we modify the internal code to create this patch file from
> kernel
> > > v2.6.10.
> > > However, as you see this is the smallest patch files which could be
> > > generated. (Sorry, unable to meet your expetation)
> > > The reason is : this driver could supports ATP870 as well as mutiples
of
> > > Acard's chipsets. (this includes ATP880(AEC67160) & ATP885(AEC67162)).
> This
> > > is why the patch files is huge than what you expected.
> > > We did not make any change for ATP870(AEC6712) on this rev.. Besides,
we
> > > reverse following codes according to all of your suggestions. Please
> review
> > > and let me know if this is feasible.  Welcome to any of question you
may
> > > have.
> > > Thanks for your help!
> >
> > The change to pci.ids needs to be handled through pciids.sourceforge.net
> >
> > ----
> >
> > I really don't like the:
> > +               atp_dev.ioport[0] = base_io + 0x80;
> > +               atp_dev.ioport[1] = base_io + 0xc0;
> >
> > Just record base_io in your atp_dev.  I don't like the way this patch
> > turns everything into a 2-d array ... surely there has to be a better
> > way to do it than this?
> >
> > ----
> >
> > +               if (dev->dev_id == ATP885_DEVID) {
> > +                       tmpcip += 2;
> > +                       outb(0x06, tmpcip);
> > +                       tmpcip -= 2;
> >
> > would be much better written as:
> >
> > if (dev->dev_id == ATP885_DEVID)
> > outb(0x06, tmpcip+2);
> >
> > (hmm, this seems to be common coding style throughout the driver ...)
> >
> > ----
> >
> > -       if (pci_set_dma_mask(dev, 0xFFFFFFFFUL)) {
> > -               printk(KERN_ERR "atp870u: 32bit DMA mask required but
not
> availa
> > ble.\n");
> > -               return -EIO;
> > -       }
> > +        if (!pci_set_dma_mask(pdev, 0xFFFFFFUL)) {
> > +                printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
> > +        } else {
> > +                printk(KERN_ERR "atp870u: DMA mask required but not
> available.\
> > n");
> > +                return -EIO;
> > +        }
> >
> > You've actually set a 24-bit DMA mask there.  Should use the symbolic
> > constant DMA_32BIT_MASK anyway.
> >
> > ----
> >
> > +       { PCI_DEVICE(PCI_VENDOR_ID_ARTOP,
>               },
> >
> > Please use the PCI_DEVICE_ID_ name instead
> >
> > ----
> >
> >
> >
> > --
> > "Next the statesmen will invent cheap lies, putting the blame upon
> > the nation that is attacked, and every man will be glad of those
> > conscience-soothing falsities, and will diligently study them, and
refuse
> > to examine any refutations of them; and thus he will by and by convince
> > himself that the war is just, and will thank God for the better sleep
> > he enjoys after this process of grotesque self-deception." -- Mark Twain
> >
>

