From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: 2.4.25pre6 and qlogic pcmcia driver
Date: Thu, 22 Jan 2004 15:18:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122151824.3b874be9.rddunlap@osdl.org>
References: <200401180355.01190.arekm@pld-linux.org>
	<Pine.LNX.4.58L.0401201400490.14726@logos.cnet>
	<20040120101121.5ce95f97.rddunlap@osdl.org>
	<200401210232.44118.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:26295 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266477AbUAVXWz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 18:22:55 -0500
In-Reply-To: <200401210232.44118.arekm@pld-linux.org>
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>, dledford@redhat.com
Cc: marcelo.tosatti@cyclades.com, linux-scsi@vger.kernel.org, andersen@codepoet.org, fischer@norbit.de

(moved to linux-scsi)

On Wed, 21 Jan 2004 02:32:43 +0100 Arkadiusz Miskiewicz <arekm@pld-linu=
x.org> wrote:

| Dnia wto 20. stycznia 2004 19:11, Randy.Dunlap napisa=B3:
| > On Tue, 20 Jan 2004 14:01:54 -0200 (BRST) Marcelo Tosatti <marcelo.=
tosatti@cyclades.com> wrote:
| > | Same here, 2.4.24 does not show this behaviour.
| > |
| > | I can't find the guilty modification in 2.4.25-pre.
| >
| > Same problem with aha152x pcmcia being built as a module.
| >
| > I also don't see any changes that would be causing this...
| >
| > It's clear that this problem should be detected, since
| > scsi/qlogicfas.c and scsi/pcmcia/qlogic_stub.c both
| > #include <linux/init.h>, so both of them define the module
| > init and cleanup functions.  I don't see how this worked
| > in the past, unless it was due to some tools that missed
| > detecting the duplicated functions.
| This change causes whole problem:
|=20
| diff -Naur -p -X /home/marcelo/lib/dontdiff linux-2.4.24/include/linu=
x/spinlock.h linux-2.4.25-pre6/include/linux/spinlock.h
| --- linux-2.4.24/include/linux/spinlock.h       2002-11-28 23:53:15.0=
00000000 +0000
| +++ linux-2.4.25-pre6/include/linux/spinlock.h  2004-01-16 12:20:45.0=
00000000 +0000
| @@ -3,6 +3,8 @@
|=20
|  #include <linux/config.h>
|=20
| +#include <asm/system.h>
| +
[snip]

| The problem is because in 2.4.25pre6 we have
| MODULE defined and
| drivers/scsi/qlogicfas.c -> #include <linux/module.h>
| include/linux/moduleh -> #include <linux/spinlock.h>
| include/linux/spinlock.h -> #include <asm/system.h>
| include/asm/system.h -> #include <linux/init.h>
| as MODULE is defined then wrong functions are taken (we want these fo=
r undefined MODULE to be taken later)
| then back in drivers/scsi/qlogicfas.c
|=20
| #ifdef PCMCIA
| #undef MODULE
| #endif
|=20
| and again #include <linux/init.h> this time with MODULE undefined

Thanks for finding/isolating that one...  wow.

Is reverting that change to include/linux/spinlock.h a possibility?

If not, here's a patch that fixes 3 SCSI PCMCIA modules so that they
will build in 2.4.25-pre6.  Not tested....

Is it OK Not to include scsi_module.c for these PCMCIA modules?
That's where the problem comes, and they don't use those functions
AFAICT.

Comments?

--
~Randy
kernel-janitors project:  http://janitor.kernelnewbies.org/


description:	repair scsi/pcmcia modules so that they can build
		by only including scsi_module.c for non-PCMCIA builds;
		qlogicfas:  fix parameter type to scsi_unregister();

patch_name:	scsi_pcmcia_modules.patch
product_versions: linux-2425-pre6
maintainer:	Doug Ledford et al (dledford@redhat.com)
		Juergen Fischer <fischer@norbit.de> (aha152x)

diffstat:=3D
 drivers/scsi/aha152x.c   |   10 ++++++----
 drivers/scsi/fdomain.c   |    2 ++
 drivers/scsi/qlogicfas.c |   12 +++++++-----
 3 files changed, 15 insertions(+), 9 deletions(-)


diff -Naurp ./drivers/scsi/qlogicfas.c~pcmc_module ./drivers/scsi/qlogi=
cfas.c
--- ./drivers/scsi/qlogicfas.c~pcmc_module	2003-06-13 07:51:36.00000000=
0 -0700
+++ ./drivers/scsi/qlogicfas.c	2004-01-22 15:09:51.000000000 -0800
@@ -111,10 +111,6 @@
=20
 #include <linux/module.h>
=20
-#ifdef PCMCIA
-#undef MODULE
-#endif=20
-
 #include <linux/blk.h>	/* to get disk capacity */
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -131,6 +127,10 @@
 #include "qlogicfas.h"
 #include <linux/stat.h>
=20
+#ifdef PCMCIA
+#undef MODULE
+#endif=20
+
 /*----------------------------------------------------------------*/
 /* driver state info, local to driver */
 static int	    qbase;	/* Port */
@@ -647,7 +647,7 @@ host->proc_name =3D  "qlogicfas";
 	if(request_irq(qlirq, do_ql_ihandl, SA_SHIRQ, "qlogicfas", hreg) < 0)
 #endif=09
 	{
-		scsi_unregister(host);
+		scsi_unregister(hreg);
 		goto err_release_mem;
 	}
 #endif
@@ -717,7 +717,9 @@ const char	*qlogicfas_info(struct Scsi_H
 }
 MODULE_LICENSE("GPL");
=20
+#ifndef PCMCIA
 /* Eventually this will go into an include file, but this will be late=
r */
 static Scsi_Host_Template driver_template =3D QLOGICFAS;
 #include "scsi_module.c"
+#endif
=20
diff -Naurp ./drivers/scsi/aha152x.c~pcmc_module ./drivers/scsi/aha152x=
=2Ec
--- ./drivers/scsi/aha152x.c~pcmc_module	2003-08-25 04:44:42.000000000 =
-0700
+++ ./drivers/scsi/aha152x.c	2004-01-22 14:50:37.000000000 -0800
@@ -222,10 +222,6 @@
=20
 #include <linux/module.h>
=20
-#if defined(PCMCIA)
-#undef MODULE
-#endif
-
 #include <linux/sched.h>
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -254,6 +250,10 @@
=20
 #include <scsi/scsicam.h>
=20
+#if defined(PCMCIA)
+#undef MODULE
+#endif
+
 /* DEFINES */
=20
 /* For PCMCIA cards, always use AUTOCONF */
@@ -3951,7 +3951,9 @@ int aha152x_proc_info(char *buffer, char
 	return thislength < length ? thislength : length;
 }
=20
+#ifndef PCMCIA
 /* Eventually this will go into an include file, but this will be late=
r */
 static Scsi_Host_Template driver_template =3D AHA152X;
=20
 #include "scsi_module.c"
+#endif
diff -Naurp ./drivers/scsi/fdomain.c~pcmc_module ./drivers/scsi/fdomain=
=2Ec
--- ./drivers/scsi/fdomain.c~pcmc_module	2002-11-28 15:53:14.000000000 =
-0800
+++ ./drivers/scsi/fdomain.c	2004-01-22 14:53:56.000000000 -0800
@@ -2046,7 +2046,9 @@ int fdomain_16x0_release(struct Scsi_Hos
=20
 MODULE_LICENSE("GPL");
=20
+#ifndef PCMCIA
 /* Eventually this will go into an include file, but this will be late=
r */
 static Scsi_Host_Template driver_template =3D FDOMAIN_16X0;
=20
 #include "scsi_module.c"
+#endif
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
