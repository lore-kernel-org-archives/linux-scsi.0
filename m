From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/5] multipath-tools: document how to add devices that need special flags in the SCSI subsystem
Date: Tue, 16 Aug 2016 14:38:49 +0200
Message-ID: <1471351133-7892-1-git-send-email-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34968 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbcHPMji (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2016 08:39:38 -0400
Received: by mail-wm0-f68.google.com with SMTP id i5so16219644wmg.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2016 05:39:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

Full flags list at include/scsi/scsi_devinfo.h

Arrays controllers included currently:

 {"3PARdata", "VV", NULL, BLIST_REPORTLUN2},

 {"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 {"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},
 {"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 {"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 {"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 {"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512},

 {"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},

 {"DGC", "RAID", NULL, BLIST_SPARSELUN},
 {"DGC", "DISK", NULL, BLIST_SPARSELUN},					<-- mising VDISK ??
 {"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 {"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

 {"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

 {"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
 {"HP", "OPEN-", "*", BLIST_REPORTLUN2},

 {"HITACHI", "DF400", "*", BLIST_REPORTLUN2},
 {"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
 {"HP", "DF400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 {"HP", "DF500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 {"HP", "DF600", "*", BLIST_SPARSELUN | BLIST_LARGELUN},			<-- bug, also apply: 627511e3e

 {"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

 {"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},				<-- ontap

 {"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},				<-- rdac!!

 {"SGI", "TP9100", "*", BLIST_REPORTLUN2},

 {"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},

 {"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 {"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 {"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 {"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1bc6f2c..4e1740a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -22,6 +22,9 @@
  *
  * Devices with a proprietary handler must also be included in
  * the kernel side. Currently at drivers/scsi/scsi_dh.c
+ *
+ * Moreover, if a device needs a special treatment by the SCSI
+ * subsystem it should be included in drivers/scsi/scsi_devinfo.c
  */
 static struct hwentry default_hw[] = {
 	/*
-- 
2.7.4

