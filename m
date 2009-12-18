From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [scsi] linux-2.6.32.1 drivers/message/fusion/mptsas.c:106: sorry,
 unimplemented: inlining failed in call to 'mptsas_set_rphy': function body
 not available
Date: Fri, 18 Dec 2009 12:14:31 -0900 (AKST)
Message-ID: <alpine.LNX.2.01.0912181213060.9874@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912181032500.9874@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.baby-dragons.com ([64.62.236.141]:37085 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683AbZLRVOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2009 16:14:37 -0500
In-Reply-To: <alpine.LNX.2.01.0912181032500.9874@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

 	Hello Eric & Kashyap,

On Fri, 18 Dec 2009, Mr. James W. Laferriere wrote:
> 	Hello Eric & Kashyap,  I see the maintainers file (& may not have 
> been updated) still shows you as the maintainer .  	I've added Kashyap to 
> the to list as well .
> 	I and Paul E. McKenney have just ran thru a simular 'inline'ing 
> difficulty with the new RCU implementation in 2.6.32.1 .
>
>
> 	error snippit ...
>
>  gcc -Wp,-MD,drivers/message/fusion/.mptsas.o.d  -nostdinc -isystem 
> /usr/lib/gcc/i486-slackware-linux/3.4.6/include -Iinclude 
> -I/usr/src/linux-2.6.32.1/arch/x86/include -include include/linux/autoconf.h 
> -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs 
> -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration 
> -Wno-format-security -fno-delete-null-pointer-checks -O2 -m32 -msoft-float 
> -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2 
> -fno-unit-at-a-time -march=i686 -ffreestanding -DCONFIG_AS_CFI=1 -pipe 
> -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 
> -mno-3dnow -fno-omit-frame-pointer -fno-optimize-sibling-calls -g 
> -Wdeclaration-after-statement   -D"KBUILD_STR(s)=#s" 
> -D"KBUILD_BASENAME=KBUILD_STR(mptsas)"  -D"KBUILD_MODNAME=KBUILD_STR(mptsas)" 
> -c -o drivers/message/fusion/mptsas.o drivers/message/fusion/mptsas.c
> drivers/message/fusion/mptsas.c: In function `mptsas_port_delete':
> drivers/message/fusion/mptsas.c:106: sorry, unimplemented: inlining failed in 
> call to 'mptsas_set_rphy': function body not available
> drivers/message/fusion/mptsas.c:462: sorry, unimplemented: called from here
> make[3]: *** [drivers/message/fusion/mptsas.o] Error 1
> make[2]: *** [drivers/message/fusion] Error 2
> make[1]: *** [drivers/message] Error 2
> make: *** [drivers] Error 2

 	Fyi ,  The following patch cures the compile time error .


# diff -u drivers/message/fusion/mptsas.c.orig drivers/message/fusion/mptsas.c
--- drivers/message/fusion/mptsas.c.orig        2009-12-18 21:07:31.000000000 +0000
+++ drivers/message/fusion/mptsas.c     2009-12-18 20:30:14.000000000 +0000
@@ -102,7 +102,7 @@
  static void mptsas_send_ir2_event(struct fw_event_work *fw_event);
  static void mptsas_parse_device_info(struct sas_identify *identify,
                 struct mptsas_devinfo *device_info);
-static inline void mptsas_set_rphy(MPT_ADAPTER *ioc,
+static void mptsas_set_rphy(MPT_ADAPTER *ioc,
                 struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy);
  static struct mptsas_phyinfo   *mptsas_find_phyinfo_by_sas_address
                 (MPT_ADAPTER *ioc, u64 sas_address);


 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
