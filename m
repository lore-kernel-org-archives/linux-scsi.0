From: Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>
Subject: Re: [TRIVIAL] aic7xxx_Makefile fix
Date: Mon, 16 Dec 2002 15:30:03 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212161527350.21707-100000@chaos.physics.uiowa.edu>
References: <20021216210038.2142D2C273@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021216210038.2142D2C273@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org

On Mon, 16 Dec 2002, Rusty Trivial Russell wrote:

> From:  junio@siamese.dyndns.org
> 
>   Patch against 2.4.19.  If you are in a (good) habit of making
>   all the upstream sources read-only before starting your build,
>   generation of the firmware code fails because it tries to write
>   into read-only files.  This bites only in configurations where
>   CONFIG_AIC7XXX_BUILD_FIRMWARE is set to 'y'. 
>   
> 
> --- trivial-2.4.21-pre1/drivers/scsi/aic7xxx/Makefile.orig	2002-12-16 17:22:40.000000000 +1100
> +++ trivial-2.4.21-pre1/drivers/scsi/aic7xxx/Makefile	2002-12-16 17:22:40.000000000 +1100
> @@ -39,6 +39,7 @@
>  $(obj-aic7xxx): aic7xxx_reg.h
>  
>  aic7xxx_seq.h aic7xxx_reg.h: aic7xxx.seq aic7xxx.reg aicasm/aicasm
> +	rm -f aic7xxx_seq.h aic7xxx_reg.h
>  	aicasm/aicasm -I. -r aic7xxx_reg.h -o aic7xxx_seq.h aic7xxx.seq
>  endif

This is 2.4, so I don't feel authorative for that ;) Anyhow, this is not a
right fix (it's fixed properly in 2.5). Overwriting shipped files should
never happen, the "rm" may fix the symptoms for some cases, but SCS as
e.g. bitkeeper will generally not be happy with that kind of behavior.

--Kai


