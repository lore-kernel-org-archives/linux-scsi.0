From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] aic94xx: fix typos and update verison number
Date: Tue, 16 Jan 2007 15:36:12 -0800
Message-ID: <1168990573.16470.29.camel@alexisLabtop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59064 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbXAPXgR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jan 2007 18:36:17 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0GNaF93030376
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 18:36:15 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0GNaFrA275418
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 18:36:15 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0GNaF0O005287
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 18:36:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: djwong@us.ibm.com

fix typos and bump version number

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Alexis Bruemmer <alexisb@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 drivers/scsi/aic94xx/aic94xx_sds.c  |   10 +++++-----
 drivers/scsi/scsi_transport_sas.c   |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index f391585..2a8e309 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -38,7 +38,7 @@ #include "aic94xx_hwi.h"
 #include "aic94xx_seq.h"
 
 /* The format is "version.release.patchlevel" */
-#define ASD_DRIVER_VERSION "1.0.3"
+#define ASD_DRIVER_VERSION "1.0.2"
 
 static int use_msi = 0;
 module_param_named(use_msi, use_msi, int, S_IRUGO);
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index e5a0ec3..5b0932f 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -427,7 +427,7 @@ struct asd_manuf_sec {
 
 struct asd_manuf_phy_desc {
 	u8    state;         /* low 4 bits */
-#define MS_PHY_STATE_ENABLEABLE 0
+#define MS_PHY_STATE_ENABLED    0
 #define MS_PHY_STATE_REPORTED   1
 #define MS_PHY_STATE_HIDDEN     2
 	u8    phy_id;
@@ -756,11 +756,11 @@ static void *asd_find_ll_by_id(void * co
  *
  * HIDDEN phys do not count in the total count.  REPORTED phys cannot
  * be enabled but are reported and counted towards the total.
- * ENEBLEABLE phys are enabled by default and count towards the total.
+ * ENABLED phys are enabled by default and count towards the total.
  * The absolute total phy number is ASD_MAX_PHYS.  hw_prof->num_phys
  * merely specifies the number of phys the host adapter decided to
  * report.  E.g., it is possible for phys 0, 1 and 2 to be HIDDEN,
- * phys 3, 4 and 5 to be REPORTED and phys 6 and 7 to be ENEBLEABLE.
+ * phys 3, 4 and 5 to be REPORTED and phys 6 and 7 to be ENABLED.
  * In this case ASD_MAX_PHYS is 8, hw_prof->num_phys is 5, and only 2
  * are actually enabled (enabled by default, max number of phys
  * enableable in this case).
@@ -816,8 +816,8 @@ static int asd_ms_get_phy_params(struct 
 			asd_ha->hw_prof.enabled_phys &= ~(1 << i);
 			rep_phys++;
 			continue;
-		case MS_PHY_STATE_ENABLEABLE:
-			ASD_DPRINTK("ms: phy%d: ENEBLEABLE\n", i);
+		case MS_PHY_STATE_ENABLED:
+			ASD_DPRINTK("ms: phy%d: ENABLED\n", i);
 			asd_ha->hw_prof.enabled_phys |= (1 << i);
 			en_phys++;
 			break;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f4a7a9e..0fcd332 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1761,7 +1761,7 @@ static void __exit sas_transport_exit(vo
 }
 
 MODULE_AUTHOR("Christoph Hellwig");
-MODULE_DESCRIPTION("SAS Transphy Attributes");
+MODULE_DESCRIPTION("SAS Transport Attributes");
 MODULE_LICENSE("GPL");
 
 module_init(sas_transport_init);

