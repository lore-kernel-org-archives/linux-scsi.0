From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] qla1280: fix section mismatch warnings
Date: Thu, 25 May 2006 15:08:26 -0700
Message-ID: <20060525150826.ef38aa1b.rdunlap@xenotime.net>
References: <20060525103932.ca36a587.rdunlap@xenotime.net>
	<20060525144633.706ab79e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:20969 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030466AbWEYWFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 18:05:53 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 15:05:51 -0700
In-Reply-To: <20060525144633.706ab79e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: ismail@pardus.org.tr, linux-scsi@vger.kernel.org, james.bottomley@steeleye.com, jes@trained-monkey.org

On Thu, 25 May 2006 14:46:33 -0700 Andrew Morton wrote:

> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
> >
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Fix section mismatch warnings:
> > WARNING: drivers/scsi/qla1280.o - Section mismatch: reference to
> > .init.data: from .text between 'qla1280_get_token' (at offset 0x2a16)
> > and 'qla1280_probe_one'
> > WARNING: drivers/scsi/qla1280.o - Section mismatch: reference to
> > .init.data: from .text between 'qla1280_get_token' (at offset 0x2a3c)
> > and 'qla1280_probe_one'
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  drivers/scsi/qla1280.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-2617-rc5.orig/drivers/scsi/qla1280.c
> > +++ linux-2617-rc5/drivers/scsi/qla1280.c
> > @@ -456,7 +456,7 @@ static void qla1280_remove_one(struct pc
> >   *  QLogic Driver Support Function Prototypes.
> >   */
> >  static void qla1280_done(struct scsi_qla_host *);
> > -static int qla1280_get_token(char *);
> > +static int qla1280_get_token(char *) __init;
> 
> We don't normally put section tags on declarations.  So I dropped this hunk
> - unless you see a need for it?
> 
> >  static int qla1280_setup(char *s) __init;
> 
> OK, for consistency.   But let's not be consistent with inconsistent stuff ;)

Right. :)

> >  /*
> > @@ -4234,7 +4234,7 @@ qla1280_setup(char *s)
> >  }
> >  
> >  
> > -static int
> > +static int __init
> >  qla1280_get_token(char *str)
> >  {
> >  	char *sep;
> 
> And that's not really a bugfix - it's just a save-a-bit-of-memory fix.

Yes, that's accurate.  

I'll start noting severity levels...

---
~Randy
