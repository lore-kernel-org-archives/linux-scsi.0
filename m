From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: aic7xxx build failure
Date: Tue, 5 Feb 2008 21:56:16 +0100
Message-ID: <20080205205616.GA27404@uranus.ravnborg.org>
References: <20080205174024.GE505@cs181133002.pp.htv.fi> <20080205184735.GA26270@uranus.ravnborg.org> <20080205200623.GA26798@uranus.ravnborg.org> <1202243222.3133.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761988AbYBEU4Y@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1202243222.3133.79.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > index 4c54954..6aa49e7 100644
> > --- a/drivers/scsi/aic7xxx/Makefile
> > +++ b/drivers/scsi/aic7xxx/Makefile
> > @@ -44,8 +44,8 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
> >  
> >  # Dependencies for generated files need to be listed explicitly
> >  
> > -$(addprefix $(src)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
> > -$(addprefix $(src)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
> > +$(addprefix $(src)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
> > +$(addprefix $(src)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
> 
> OK, I think it's time for me to give up completely on understanding
> kbuild.  To me this construction looks like you're adding source
> directory prefixes to objects ... which can never be satisfied can it,
> if the objectas are in the object directory?
Or maybe I'm just so damn tired that I should sleep instead of trying to fix
this Makefile for 117 time.
You are right that it should read:

-$(addprefix $(src)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
-$(addprefix $(src)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
+$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
+$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h

But for now the distinction between src and obj is purely for documentation
as they have the same value - also when O= is used.
So it should work anyway.

If you use M=... (or SUBDIRS=...) I think it matters but this
is not the case for this in-tree driver in normal usage situations.

I will test some more tomorrow and if feedback from Adrian is positive I
will submit the hopefully last update to this Makefile to Linus.
[I need to test if it can generate the files using the aicasm tool for instance).

	Sam
