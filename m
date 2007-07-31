From: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi hotplug model
Date: Tue, 31 Jul 2007 18:18:03 +0300
Message-ID: <ec7f7ee70707310818i5fa7ec45x120e483988aefba8@mail.gmail.com>
References: <20070731125510.GN21219@parisc-linux.org>
	 <1185892945.3468.9.camel@localhost.localdomain>
	 <20070731145227.GP21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:11393 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761258AbXGaPSF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 11:18:05 -0400
Received: by el-out-1112.google.com with SMTP id j27so278840elf
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 08:18:04 -0700 (PDT)
In-Reply-To: <20070731145227.GP21219@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On 7/31/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Jul 31, 2007 at 09:42:25AM -0500, James Bottomley wrote:
> > Rather than changing this in every 53c700 based driver, shouldn't it
> > just be added to NCR_700_release()?
>
> > > diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> > > index 85f2394..27acef4 100644
> > > --- a/drivers/scsi/aha152x.c
> > > +++ b/drivers/scsi/aha152x.c
> > > @@ -907,6 +907,7 @@ void aha152x_release(struct Scsi_Host *shpnt)
> > >     if(!shpnt)
> > >             return;
> > >
> > > +   scsi_remove_host(shpnt);
> > >     if (shpnt->irq)
> > >             free_irq(shpnt->irq, shpnt);
> >
> > and this one needs to go via Boaz ... he's currently rewriting this
> > driver.
>
> OK.
>

It applies cleanly. I have not touched this area of code.
But maybe it's related to Randy's last problem of device
driver not unloading do to ref-count = 2. so please
wait a bit with this patch and we'll test it

And Thanks maybe it's the problem we where looking
for

Boaz
