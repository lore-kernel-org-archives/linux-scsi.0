From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: aic7xxx build failure
Date: Tue, 5 Feb 2008 21:06:23 +0100
Message-ID: <20080205200623.GA26798@uranus.ravnborg.org>
References: <20080205174024.GE505@cs181133002.pp.htv.fi> <20080205184735.GA26270@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:60345 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760331AbYBEUGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 15:06:18 -0500
Content-Disposition: inline
In-Reply-To: <20080205184735.GA26270@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Feb 05, 2008 at 07:47:35PM +0100, Sam Ravnborg wrote:
> On Tue, Feb 05, 2008 at 07:40:24PM +0200, Adrian Bunk wrote:
> > Commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb broke aic7xxx 
> > compilation:
> > 
> > <--  snip  -->
> > 
> > $ make O=../out/x86-full
> > ...
> >   SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
> >   SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
> >   CC      drivers/scsi/aic7xxx/aic79xx_core.o
> > gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
> > gcc: no input files
> > make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Next "make" run brings the same failure in 
> > drivers/scsi/aic7xxx/aic7xxx_core.c.
> > 
> > With the third "make" it works.
> > 
> > It might compile for people with SMP systems using -j?
> 
> I can reproduce it and will fix it.
Seems I was sidetracked by some wrong assumptions.
Could you please test this fix.

Works for me but this time I will do more testing....

	Sam

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 4c54954..6aa49e7 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -44,8 +44,8 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
 
 # Dependencies for generated files need to be listed explicitly
 
-$(addprefix $(src)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
-$(addprefix $(src)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
+$(addprefix $(src)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
+$(addprefix $(src)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
 
 aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h
 aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+= $(obj)/aic7xxx_reg_print.c

