From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 06/17] scsi: fix section mismatch in aic94xx
Date: Mon, 31 Mar 2008 09:46:16 -0500
Message-ID: <1206974776.3192.5.camel@localhost.localdomain>
References: <200803282148.m2SLma9o012231@imap1.linux-foundation.org>
	 <1206900305.4224.78.camel@localhost.localdomain>
	 <20080330184456.GA19733@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54211 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759470AbYCaOqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 10:46:22 -0400
In-Reply-To: <20080330184456.GA19733@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, gilbert_wu@adaptec.com

On Sun, 2008-03-30 at 20:44 +0200, Sam Ravnborg wrote: 
> On Sun, Mar 30, 2008 at 01:05:04PM -0500, James Bottomley wrote:
> > On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > > From: Sam Ravnborg <sam@ravnborg.org>
> > > 
> > > Fix following warnings:
> > > WARNING: vmlinux.o(.data+0x17aa88): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
> > > WARNING: vmlinux.o(.data+0x17aa98): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
> > > WARNING: vmlinux.o(.data+0x17aaa8): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9405_setup()
> > > 
> > > asd_pcidev_data is only used by __devinit asd_pci_probe.  So mark is const and
> > > annotate it __devinitconst to fix the warnings.
> > > 
> > > [akpm@linux-foundation.org: fix warning]
> > > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > > Cc: Gilbert Wu <gilbert_wu@adaptec.com>
> > > Cc: James Bottomley <James.Bottomley@SteelEye.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > > 
> > >  drivers/scsi/aic94xx/aic94xx_init.c |    6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff -puN drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx drivers/scsi/aic94xx/aic94xx_init.c
> > > --- a/drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx
> > > +++ a/drivers/scsi/aic94xx/aic94xx_init.c
> > > @@ -529,10 +529,10 @@ static void asd_remove_dev_attrs(struct 
> > >  /* The first entry, 0, is used for dynamic ids, the rest for devices
> > >   * we know about.
> > >   */
> > > -static struct asd_pcidev_struct {
> > > +static const struct asd_pcidev_struct {
> > >  	const char * name;
> > >  	int (*setup)(struct asd_ha_struct *asd_ha);
> > > -} asd_pcidev_data[] = {
> > > +} asd_pcidev_data[] __devinitconst = {
> > >  	/* Id 0 is used for dynamic ids. */
> > >  	{ .name  = "Adaptec AIC-94xx SAS/SATA Host Adapter",
> > >  	  .setup = asd_aic9410_setup
> > 
> > If your tools say this patch is correct, then the tools are wrong.
> > 
> > This patch actually takes something that's functionally correct but your
> > tools can't see it and transforms it to something that's actually
> > functionally wrong ... and the tool should spot that.
> > 
> > the problem is the contents of the .name field ... they can't live in
> > the devinit rodata section because we actually take a pointer to it (as
> > asd_ha->name and later ha->sas_ha_name) in asd_pci_probe() that lives
> > the entire lifetime of the driver and is used.  derefing it will trigger
> > a bug after the __devinit section is discarded in the non hotplug case.
> asd_pcidev_dada[].name is dereferenced only in the above mentioned function.
> The string is used in other places - correct. But this patch does
> not try to move the defined string anywhere only the data member
> holding the pointer to the string.
> 
> Take a look at the content of .rodata.str1.1 to see the string
> being contained there.

So none of the strings we use in init sections are actually placed into
init data?  I had thought that was one of the things that got fixed in
the quest for page savings, especially as we have quite a few of
them ...

In that case this is OK ... however, assuming you're planning to fix the
non discarded init strings problem, won't this fix become wrong at that
point?

James


