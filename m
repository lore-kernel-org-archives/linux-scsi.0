From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Feral Qlogic ISP driver up for testing
Date: 15 May 2003 12:13:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053018832.2265.81.camel@mulgrave>
References: <1053017923.2267.76.camel@mulgrave>
	<20030515180341.A30444@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-9mb1uSrxG0/DbaSbEHBb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:27396 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264137AbTEORBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 13:01:40 -0400
In-Reply-To: <20030515180341.A30444@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@digeo.com>, mjacob@feral.com


--=-9mb1uSrxG0/DbaSbEHBb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2003-05-15 at 12:03, Christoph Hellwig wrote:
> On Thu, May 15, 2003 at 11:58:41AM -0500, James Bottomley wrote:
> > I've taken Matthew Jacob's latest drop of the Feral ISP driver and put
> > it up under bitkeeper at
> > 
> > http://linux-scsi.bkbits.net/scsi-isp-2.5
> 
> Could ypu please submitt a diff for review?  Some people don't like to
> be lost in a maze of BK trees, all almost the same..

Well, it's all new files, there's not much to diff.

The tarball is here:

ftp://ftp.feral.com/pub/isp/isp_dist.tgz

(I think that corresponds to what I pulled out of the feral BK tree)
except that I flattened common, linux and firmware into a single
directory.

And the patches I did are below.

James


--=-9mb1uSrxG0/DbaSbEHBb
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.1064  -> 1.1066=20
#	drivers/scsi/isp/isp_linux.c	1.1     -> 1.2   =20
#	drivers/scsi/isp/isp_linux.h	1.1     -> 1.2   =20
#	drivers/scsi/Makefile	1.41    -> 1.42  =20
#	drivers/scsi/Kconfig	1.20    -> 1.21  =20
#	               (new)	        -> 1.1     drivers/scsi/isp/Makefile
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/05/15	jejb@raven.il.steeleye.com	1.1065
# Plumb the Feral ISP driver into the SCSI Builds
# --------------------------------------------
# 03/05/15	jejb@raven.il.steeleye.com	1.1066
# Update feral ISP driver to compile without warnings
#=20
# add #include <linux/vmalloc.h> and convert to irqreturn_t
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Thu May 15 12:12:52 2003
+++ b/drivers/scsi/Kconfig	Thu May 15 12:12:52 2003
@@ -1739,6 +1739,15 @@
=20
 #      bool 'Cyberstorm Mk III SCSI support (EXPERIMENTAL)' CONFIG_CYBERST=
ORMIII_SCSI
 #      bool 'GVP Turbo 040/060 SCSI support (EXPERIMENTAL)' CONFIG_GVP_TUR=
BO_SCSI
+
+config SCSI_FERAL_ISP
+	tristate "Feral ISP driver for 10x0/12x0/2x00"
+	depends on SCSI
+	help
+	  Feral Driver for the following qlogic ISP chips
+	  1020/1040/1080/1280/12160/2100/2200/2300
+	  If this doesn't work, there are other drivers for these chips
+	  below.
 endmenu
=20
 source "drivers/scsi/pcmcia/Kconfig"
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Thu May 15 12:12:52 2003
+++ b/drivers/scsi/Makefile	Thu May 15 12:12:52 2003
@@ -69,6 +69,7 @@
 obj-$(CONFIG_SCSI_NCR53C406A)	+=3D NCR53c406a.o
 obj-$(CONFIG_SCSI_NCR_D700)	+=3D NCR_D700.o 53c700.o
 obj-$(CONFIG_SCSI_SYM53C416)	+=3D sym53c416.o
+obj-$(CONFIG_SCSI_FERAL_ISP)	+=3D isp/
 obj-$(CONFIG_SCSI_QLOGIC_FAS)	+=3D qlogicfas.o
 obj-$(CONFIG_SCSI_QLOGIC_ISP)	+=3D qlogicisp.o=20
 obj-$(CONFIG_SCSI_QLOGIC_FC)	+=3D qlogicfc.o=20
diff -Nru a/drivers/scsi/isp/Makefile b/drivers/scsi/isp/Makefile
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/isp/Makefile	Thu May 15 12:12:52 2003
@@ -0,0 +1,5 @@
+obj-y		+=3D isp_mod.o
+
+EXTRA_CFLAGS	+=3D -Idrivers/scsi
+
+isp_mod-y	+=3D isp_pci.o isp_linux.o isp.o isp_cb_ops.o isp_target.o
diff -Nru a/drivers/scsi/isp/isp_linux.c b/drivers/scsi/isp/isp_linux.c
--- a/drivers/scsi/isp/isp_linux.c	Thu May 15 12:12:51 2003
+++ b/drivers/scsi/isp/isp_linux.c	Thu May 15 12:12:52 2003
@@ -2241,7 +2241,7 @@
     ISP_IUNLK_SOFTC(isp);
 }
=20
-void
+irqreturn_t
 isplinux_intr(int irq, void *arg, struct pt_regs *pt)
 {
     struct ispsoftc *isp =3D arg;
@@ -2253,7 +2253,7 @@
     if (ISP_READ_ISR(isp, &isr, &sema, &mbox) =3D=3D 0) {
 	isp->isp_intbogus++;
 	ISP_IUNLK_SOFTC(isp);
-	return;
+	return IRQ_NONE;
     }
     isp_intr(isp, isr, sema, mbox);
     isplinux_runwaitq(isp);
@@ -2293,6 +2293,7 @@
 	}
 	ISP_UNLK_SCSI_DONE(isp);
     }
+    return IRQ_HANDLED;
 }
=20
 static INLINE int
diff -Nru a/drivers/scsi/isp/isp_linux.h b/drivers/scsi/isp/isp_linux.h
--- a/drivers/scsi/isp/isp_linux.h	Thu May 15 12:12:52 2003
+++ b/drivers/scsi/isp/isp_linux.h	Thu May 15 12:12:52 2003
@@ -40,6 +40,8 @@
 #ifndef _ISP_LINUX_H
 #define _ISP_LINUX_H
=20
+#include <linux/vmalloc.h>
+
 #ifndef	ISP_MODULE
 #define	__NO_VERSION__
 #endif
@@ -732,7 +734,7 @@
  */
 void isplinux_timer(unsigned long);
 void isplinux_mbtimer(unsigned long);
-void isplinux_intr(int, void *, struct pt_regs *);
+irqreturn_t isplinux_intr(int, void *, struct pt_regs *);
 void isplinux_common_init(struct ispsoftc *);
 #ifdef	CONFIG_PROC_FS
 void isplinux_init_proc(struct ispsoftc *);

--=-9mb1uSrxG0/DbaSbEHBb--

