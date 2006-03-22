From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] SCSI: link scsi_debug later (updated)
Date: Wed, 22 Mar 2006 13:47:10 -0800
Message-ID: <20060322134710.2de9e19d.rdunlap@xenotime.net>
References: <1142956795.4377.19.camel@mulgrave.il.steeleye.com>
	<20060322083647.cc0ccdd4.rdunlap@xenotime.net>
	<Pine.LNX.4.64.0603221048210.26286@g5.osdl.org>
	<1143055627.3629.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:19915 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751271AbWCVVpC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 16:45:02 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 13:44:59 -0800
In-Reply-To: <1143055627.3629.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Changing CONFIG_SCSI_DEBUG from =n or =m to =y can cause the enumeration
of the SATA devices to change.

Fix that by linking the scsi_debug driver after the SATA drivers.
Leave scsi_debug at the bottom of the list of low-level drivers so
that this problem doesn't happen again.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Douglas Gilbert <dougg@torque.net>
---
 drivers/scsi/Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2616-rc6.orig/drivers/scsi/Makefile
+++ linux-2616-rc6/drivers/scsi/Makefile
@@ -117,7 +117,6 @@ obj-$(CONFIG_SCSI_PPA)		+= ppa.o
 obj-$(CONFIG_SCSI_IMM)		+= imm.o
 obj-$(CONFIG_JAZZ_ESP)		+= NCR53C9x.o	jazz_esp.o
 obj-$(CONFIG_SUN3X_ESP)		+= NCR53C9x.o	sun3x_esp.o
-obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 obj-$(CONFIG_SCSI_FCAL)		+= fcal.o
 obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
@@ -140,6 +139,7 @@ obj-$(CONFIG_SCSI_SATA_MV)	+= libata.o s
 obj-$(CONFIG_SCSI_PDC_ADMA)	+= libata.o pdc_adma.o
 
 obj-$(CONFIG_ARM)		+= arm/
+obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
 obj-$(CONFIG_CHR_DEV_ST)	+= st.o
 obj-$(CONFIG_CHR_DEV_OSST)	+= osst.o



---
