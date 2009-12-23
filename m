From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [scsi] linux-2.6.32.1 drivers/message/fusion/mptsas.c:106:
 sorry, unimplemented: inlining failed in call to 'mptsas_set_rphy': function
 body not available
Date: Wed, 23 Dec 2009 17:15:32 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93D49895@inbmail01.lsi.com>
References: <alpine.LNX.2.01.0912181032500.9874@filesrv1.baby-dragons.com>
 <alpine.LNX.2.01.0912181213060.9874@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60069 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752015AbZLWLpo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2009 06:45:44 -0500
In-Reply-To: <alpine.LNX.2.01.0912181213060.9874@filesrv1.baby-dragons.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>


Mr. James,

I tried reproducing things here; I found your fix is valid.

Your proposed solution is well understood.
I will submit this patch to upstream.

Thanks for adding my name in MAINTAINER list. It should be done well before by me.

- Kashyap

> -----Original Message-----
> From: Mr. James W. Laferriere [mailto:babydr@baby-dragons.com]
> Sent: Saturday, December 19, 2009 2:45 AM
> To: Moore, Eric; Desai, Kashyap
> Cc: Linux Scsi maillist
> Subject: Re: [scsi] linux-2.6.32.1 drivers/message/fusion/mptsas.c:106:
> sorry, unimplemented: inlining failed in call to 'mptsas_set_rphy':
> function body not available
> 
>  	Hello Eric & Kashyap,
> 
> On Fri, 18 Dec 2009, Mr. James W. Laferriere wrote:
> > 	Hello Eric & Kashyap,  I see the maintainers file (& may not have
> > been updated) still shows you as the maintainer .  	I've added Kashyap
> to
> > the to list as well .
> > 	I and Paul E. McKenney have just ran thru a simular 'inline'ing
> > difficulty with the new RCU implementation in 2.6.32.1 .
> >
> >
> > 	error snippit ...
> >
> >  gcc -Wp,-MD,drivers/message/fusion/.mptsas.o.d  -nostdinc -isystem
> > /usr/lib/gcc/i486-slackware-linux/3.4.6/include -Iinclude
> > -I/usr/src/linux-2.6.32.1/arch/x86/include -include
> include/linux/autoconf.h
> > -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
> > -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
> > -Wno-format-security -fno-delete-null-pointer-checks -O2 -m32 -msoft-
> float
> > -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2
> > -fno-unit-at-a-time -march=i686 -ffreestanding -DCONFIG_AS_CFI=1 -pipe
> > -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -
> mno-sse2
> > -mno-3dnow -fno-omit-frame-pointer -fno-optimize-sibling-calls -g
> > -Wdeclaration-after-statement   -D"KBUILD_STR(s)=#s"
> > -D"KBUILD_BASENAME=KBUILD_STR(mptsas)"  -
> D"KBUILD_MODNAME=KBUILD_STR(mptsas)"
> > -c -o drivers/message/fusion/mptsas.o drivers/message/fusion/mptsas.c
> > drivers/message/fusion/mptsas.c: In function `mptsas_port_delete':
> > drivers/message/fusion/mptsas.c:106: sorry, unimplemented: inlining
> failed in
> > call to 'mptsas_set_rphy': function body not available
> > drivers/message/fusion/mptsas.c:462: sorry, unimplemented: called from
> here
> > make[3]: *** [drivers/message/fusion/mptsas.o] Error 1
> > make[2]: *** [drivers/message/fusion] Error 2
> > make[1]: *** [drivers/message] Error 2
> > make: *** [drivers] Error 2
> 
>  	Fyi ,  The following patch cures the compile time error .
> 
> 
> # diff -u drivers/message/fusion/mptsas.c.orig
> drivers/message/fusion/mptsas.c
> --- drivers/message/fusion/mptsas.c.orig        2009-12-18
> 21:07:31.000000000 +0000
> +++ drivers/message/fusion/mptsas.c     2009-12-18 20:30:14.000000000
> +0000
> @@ -102,7 +102,7 @@
>   static void mptsas_send_ir2_event(struct fw_event_work *fw_event);
>   static void mptsas_parse_device_info(struct sas_identify *identify,
>                  struct mptsas_devinfo *device_info);
> -static inline void mptsas_set_rphy(MPT_ADAPTER *ioc,
> +static void mptsas_set_rphy(MPT_ADAPTER *ioc,
>                  struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy);
>   static struct mptsas_phyinfo   *mptsas_find_phyinfo_by_sas_address
>                  (MPT_ADAPTER *ioc, u64 sas_address);
> 
> 
>  		Hth ,  JimL
> --
> +------------------------------------------------------------------+
> | James   W.   Laferriere | System    Techniques | Give me VMS     |
> | Network&System Engineer | 3237     Holden Road |  Give me Linux  |
> | babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
> +------------------------------------------------------------------+
