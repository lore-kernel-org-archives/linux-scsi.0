From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [TRIVIAL] aic7xxx_Makefile fix
Date: Tue, 17 Dec 2002 10:12:20 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216233429.53E752C2B4@lists.samba.org>
References: <Pine.LNX.4.44.0212161527350.21707-100000@chaos.physics.uiowa.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-reply-to: Your message of "Mon, 16 Dec 2002 15:30:03 MDT."
             <Pine.LNX.4.44.0212161527350.21707-100000@chaos.physics.uiowa.edu>
List-Id: linux-scsi@vger.kernel.org
To: Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>
Cc: junio@siamese.dyndns.org, linux-scsi@vger.kernel.org

In message <Pine.LNX.4.44.0212161527350.21707-100000@chaos.physics.uiowa.edu> y
ou write:
> On Mon, 16 Dec 2002, Rusty Trivial Russell wrote:
> 
> > From:  junio@siamese.dyndns.org
> > 
> >   Patch against 2.4.19.  If you are in a (good) habit of making
> >   all the upstream sources read-only before starting your build,
> >   generation of the firmware code fails because it tries to write
> >   into read-only files.  This bites only in configurations where
> >   CONFIG_AIC7XXX_BUILD_FIRMWARE is set to 'y'. 
> >   
> > 
> > --- trivial-2.4.21-pre1/drivers/scsi/aic7xxx/Makefile.orig	2002-12-16 17:22:40.000000000 +1100
> > +++ trivial-2.4.21-pre1/drivers/scsi/aic7xxx/Makefile	2002-12-16 17:22:40.000000000 +1100
> > @@ -39,6 +39,7 @@
> >  $(obj-aic7xxx): aic7xxx_reg.h
> >  
> >  aic7xxx_seq.h aic7xxx_reg.h: aic7xxx.seq aic7xxx.reg aicasm/aicasm
> > +	rm -f aic7xxx_seq.h aic7xxx_reg.h
> >  	aicasm/aicasm -I. -r aic7xxx_reg.h -o aic7xxx_seq.h aic7xxx.seq
> >  endif
> 
> This is 2.4, so I don't feel authorative for that ;) Anyhow, this is not a
> right fix (it's fixed properly in 2.5). Overwriting shipped files should
> never happen, the "rm" may fix the symptoms for some cases, but SCS as
> e.g. bitkeeper will generally not be happy with that kind of behavior.

Thanks Kai, I've closed it pending someone doing a backport from 2.5.

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
