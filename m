From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 25 Jan 2008 09:24:59 -0800
Message-ID: <da824cf30801250924i5e8cd5c6pe07215a4298ab8a4@mail.gmail.com>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
	 <479727D5.8060901@garzik.org>
	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:41892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYAYRZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2008 12:25:03 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id m0PHOx6a015697
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 09:24:59 -0800
Received: from rv-out-0910.google.com (rvbk15.prod.google.com [10.140.87.15])
	by zps19.corp.google.com with ESMTP id m0PHOVlJ023256
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 09:24:59 -0800
Received: by rv-out-0910.google.com with SMTP id k15so579844rvb.23
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 09:24:59 -0800 (PST)
In-Reply-To: <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

On Jan 25, 2008 8:43 AM, Ke Wei <kewei.mv@gmail.com> wrote:
> The attached is Marvell 6440 SAS/SATA driver. I will try to send email
> by git-send-email.

I know this isn't part of this patch:
 #define mr32(reg)	readl(regs + MVS_##reg)
 #define mw32(reg,val)	writel((val), regs + MVS_##reg)

But can "regs" be declared a parameter to the macro?
And the one letter difference in the name is just asking for trouble.
Better to call it "mmio_base" or something a bit longer that won't
likely collide with other stuff.

+/* offset for D2H FIS in the Received FIS List Structure */
+#define SATA_RECEIVED_D2H_FIS(reg_set) \
+	(mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)

Ditto.

+	MODE_AUTO_DET_PORT7 = (1U << 15),	/* port0 SAS/SATA autodetect */
+	MODE_AUTO_DET_PORT6 = (1U << 14),
+	MODE_AUTO_DET_PORT5 = (1U << 13),
+	MODE_AUTO_DET_PORT4 = (1U << 12),
+	MODE_AUTO_DET_PORT3 = (1U << 11),
+	MODE_AUTO_DET_PORT2 = (1U << 10),
+	MODE_AUTO_DET_PORT1 = (1U << 9),
+	MODE_AUTO_DET_PORT0 = (1U << 8),

These really aren't needed.

#define MODE_AUTO_DET_EN   (0xff << 8)    /* enable auto detect on all
8 ports */


Ditto for MODE_SAS_SATA.


+	/* Port n Attached Device Info */

Groups bits defined have a comment preceeding a group of bits (which
is a good thing). If multiple registers are being defined in one enum
declaration, can you please add either the register offset
to the comment or include the constant that defines the
offset (e.g. MVS_P0_CFG_ADDR)?

Have to stop for now...but I'm wonder how this driver ever worked
given the number of HW register bits that were changed (assuming
they were wrong before this patch). And this driver looks _alot_
better than the previous Marvell drivers I've looked at. Please keep
up the good work! :)

hth,
grant

> Changelog :
> Merged from Jeff's branch to James's branch.
>
> Signed-off-by: Ke Wei <kewei@marvell.com>
>
>
>
> On Jan 23, 2008 7:41 PM, Jeff Garzik <jeff@garzik.org> wrote:
> > Ke Wei wrote:
> > > Attachment is a patch file for 6440 driver. I will have to spend more
> > > time on setting my mail client. Yesterday I used mutt tool. But Look
> > > like the problem still exists.
> > > I fixed all issues which you mentioned , but
> >
> > The changes look good, thanks!
> >
> > In terms of engineering process, I should have been more clear:  when
> > revising your submission, you should make the revisions and then
> > regenerate your original patch.
> >
> > To use a silly example, if you needed to fix a 1-character typo in a
> > 1,000-line patch, you would need to make your revision, re-generate the
> > 1,000-line patch, and email that new patch.
> >
> > So, to move forward, please create one single patch with the latest
> > mvsas, diff'd against the 'mvsas' branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
> >
> > I will "ack" that patch (indicate my approval), and unless other
> > objections surface, James will merge your patch into the 'mvsas' branch.
> >  That will get the driver on the road to be included in 2.6.25.
> >
> >
> > >>> @@ -666,11 +970,53 @@ static int mvs_nvram_read(struct mvs_info *mvi, unsigned
> > >>> int addr,
> > >>>  err_out:
> > >>>        dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
> > >>>        return rc;
> > >>> +#else
> > >>> +       memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
> > >>> +       return 0;
> > >>> +#endif
> > >>
> > >> what happens if two adapters are used, with the same SAS address?  That
> > >> causes problems...
> > >>
> > >>
> > > Our bios can write SAS Address per port when system boot , so I think
> > > we don't need read or configure address.
> >
> > It is standard Linux policy to reduce or eliminate BIOS dependencies as
> > much as possible.
> >
> > This is because there are several common scenarios where BIOS may not
> > run, or otherwise not be available:
> >
> > * suspend/resume
> > * controller hotplug
> > * non-x86 PCI platforms such as POWER
> >
> > Thus, we need the driver to obtain these addresses -- hopefully reading
> > them from a BIOS data table somewhere, if NVRAM is not available.
> >
> > This is a highly common scenario -- obtaining unique identifying
> > information in the absence of BIOS.
> >
> >
> >
> > Similarly, we cannot rely on BIOS to perform any global reset or errata
> > workaround duties for us.  That must be coded into the driver also.
> >
> >
> > > And I reserved hexdump funciton if you don't care. Only debugging.
> >
> > It is not an important matter, but it would be nice to clean that up
> > eventually.
> >
> > Also, FWIW, we have a standard method of debug output:
> >
> >        struct pci_dev *pdev;
> >
> >        dev_dbg(&pdev->dev, KERN_INFO,
> >                "this is debug message number %d", 2);
> >
> > which will only be compiled into the driver when DEBUG is defined.
> >
> >
> > >>> +static int mvs_abort_task(struct sas_task *task)
> > >>> +{
> > >>> +       /*FIXME*/
> > >>> +       MVS_PRINTK("mvs abort task\n");
> > >>> +       return TMF_RESP_FUNC_COMPLETE;
> > >>> +}
> > >> should make an attempt to do something sane here
> > >>
> > > if entering this abort function , I think I must fix the unknown
> > > issues instead of here.  But I also will implement next.
> >
> > Ok, thanks.
> >
> >        Jeff
> >
> >
> >
> >
>
>
>
> --
> Best Regards,
> Ke Wei
>
