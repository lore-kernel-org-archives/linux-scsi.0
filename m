From: Christian =?iso-8859-1?q?Borntr=E4ger?=
	<christian@borntraeger.net>
Subject: [PATCH] Add bus dependencies to two scsi drivers
Date: Wed, 4 Aug 2004 16:25:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408041625.37223.christian@borntraeger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:49392 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S266069AbUHDOZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 10:25:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Two scsi drivers do not compile on systems without ISA/PCI. Therefore=20
allyesconfig breaks on hardware like s390.=20

Signed-off-by: Christian Borntr=E4ger <linux-kernel@borntraeger.net>

diff -u -r1.36 Kconfig
--- a/drivers/scsi/Kconfig	23 Jun 2004 14:39:43 -0000	1.36
+++ b/drivers/scsi/Kconfig	4 Aug 2004 14:10:34 -0000
@@ -309,7 +309,7 @@
=20
 config SCSI_AIC7XXX_OLD
 	tristate "Adaptec AIC7xxx support (old driver)"
-	depends on SCSI
+	depends on (ISA || EISA || PCI ) && SCSI
 	help
 	  WARNING This driver is an older aic7xxx driver and is no longer
 	  under active development.  Adaptec, Inc. is writing a new driver to
@@ -578,7 +578,7 @@
=20
 config SCSI_EATA_PIO
 	tristate "EATA-PIO (old DPT PM2001, PM2012A) support"
-	depends on SCSI
+	depends on (ISA || EISA || PCI) && SCSI
 	---help---
 	  This driver supports all EATA-PIO protocol compliant SCSI Host
 	  Adapters like the DPT PM2001 and the PM2012A.  EATA-DMA compliant



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
