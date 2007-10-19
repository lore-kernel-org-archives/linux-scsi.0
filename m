From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Fri, 19 Oct 2007 10:32:39 +0200
Message-ID: <20071019083239.D88FE18C61E@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:41551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbXJSKT2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 06:19:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


The patch enables support for 16-bit CDBs in aic7xxx and aic79xx.
aic7xxx can actually support up to 32-bit CDBs, should they ever see
the light of day.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic7xxx/aic79xx.h     |    2 ++
 drivers/scsi/aic7xxx/aic79xx_osm.c |    1 +
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index ce638aa..883f26a 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -413,6 +413,8 @@ struct target_status {
  * the sense buffer address in the SCB.  This allows
  * us to retrieve sense information without interrupting
  * the host in packetized mode.
+ * The current firmware relies on a CDB len of 16, so
+ * don't change it unless you know what you're doing.
  */
 typedef uint32_t sense_addr_t;
 #define MAX_CDB_LEN 16
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2d02040..f4e12e1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1090,6 +1090,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
 	host->max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
 	host->max_lun = AHD_NUM_LUNS;
 	host->max_channel = 0;
+	host->max_cmd_len = 16;
 	host->sg_tablesize = AHD_NSEG;
 	ahd_lock(ahd, &s);
 	ahd_set_unit(ahd, ahd_linux_unit++);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 390b0fc..d488764 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1048,6 +1048,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	host->max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
+	host->max_cmd_len = 32;
 	host->sg_tablesize = AHC_NSEG;
 	ahc_lock(ahc, &s);
 	ahc_set_unit(ahc, ahc_linux_unit++);
-- 
1.5.2.4

