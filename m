From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic7xxx build failure
Date: Tue, 05 Feb 2008 14:27:02 -0600
Message-ID: <1202243222.3133.79.camel@localhost.localdomain>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
	 <20080205184735.GA26270@uranus.ravnborg.org>
	 <20080205200623.GA26798@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44547 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726AbYBEU1L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 15:27:11 -0500
In-Reply-To: <20080205200623.GA26798@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2008-02-05 at 21:06 +0100, Sam Ravnborg wrote:
> On Tue, Feb 05, 2008 at 07:47:35PM +0100, Sam Ravnborg wrote:
> > On Tue, Feb 05, 2008 at 07:40:24PM +0200, Adrian Bunk wrote:
> > > Commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb broke aic7xxx 
> > > compilation:
> > > 
> > > <--  snip  -->
> > > 
> > > $ make O=../out/x86-full
> > > ...
> > >   SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
> > >   SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
> > >   CC      drivers/scsi/aic7xxx/aic79xx_core.o
> > > gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
> > > gcc: no input files
> > > make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
> > > 
> > > <--  snip  -->
> > > 
> > > Next "make" run brings the same failure in 
> > > drivers/scsi/aic7xxx/aic7xxx_core.c.
> > > 
> > > With the third "make" it works.
> > > 
> > > It might compile for people with SMP systems using -j?
> > 
> > I can reproduce it and will fix it.
> Seems I was sidetracked by some wrong assumptions.
> Could you please test this fix.
> 
> Works for me but this time I will do more testing....
> 
> 	Sam
> 
> diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
> index 4c54954..6aa49e7 100644
> --- a/drivers/scsi/aic7xxx/Makefile
> +++ b/drivers/scsi/aic7xxx/Makefile
> @@ -44,8 +44,8 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
>  
>  # Dependencies for generated files need to be listed explicitly
>  
> -$(addprefix $(src)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
> -$(addprefix $(src)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
> +$(addprefix $(src)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
> +$(addprefix $(src)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h

OK, I think it's time for me to give up completely on understanding
kbuild.  To me this construction looks like you're adding source
directory prefixes to objects ... which can never be satisfied can it,
if the objectas are in the object directory?

James


