From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 1/3] fnic:NoFIP solicitation frame in NONFIP mode and changed  IO Throttle count
Date: Fri, 18 Apr 2014 12:28:17 -0700
Message-ID: <1397849299-10029-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-3.cisco.com ([173.36.130.14]:9921 "EHLO
	mtv-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaDRTmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2014 15:42:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Narsimhulu Musini <nmusini@cisco.com>, Anantha Tungarakodi <atungara@cisco.com>

This patch contains following three minor fixes.

1) During Probe, fnic was sending FIP solicitation in Non FIP mode which is not
   expected, setting the internal fip state to Non FIP mode explicitly, avoids
   sending FIP frame.

2) When target goes offline, all outstanding IOs belong to the target will be
   terminated by driver, If the termination count is high, then it influences
   firmware responsiveness. To improve the responsiveness, default IO throttle
   count is reduced to 256.

3) Accessing Virtual Fabric Id (vfid) and fc_map of Fibre-Channel Forwarder(FCF)
   is invalid in fnic driver when Clear Virtual Link(CVL) is received prior to
   receiving flogi reject from switch. As CVL clears all FCFs.

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Anantha Tungarakodi <atungara@cisco.com>
---
 drivers/scsi/fnic/fnic.h      | 3 ++-
 drivers/scsi/fnic/fnic_fcs.c  | 5 -----
 drivers/scsi/fnic/fnic_main.c | 3 ++-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 528d43b..ce88951 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -46,7 +46,8 @@
 #define DESC_CLEAN_LOW_WATERMARK 8
 #define FNIC_UCSM_DFLT_THROTTLE_CNT_BLD	16 /* UCSM default throttle count */
 #define FNIC_MIN_IO_REQ			256 /* Min IO throttle count */
-#define FNIC_MAX_IO_REQ		2048 /* scsi_cmnd tag map entries */
+#define FNIC_MAX_IO_REQ		1024 /* scsi_cmnd tag map entries */
+#define FNIC_DFLT_IO_REQ        256 /* Default scsi_cmnd tag map entries */
 #define	FNIC_IO_LOCKS		64 /* IO locks: power of 2 */
 #define FNIC_DFLT_QUEUE_DEPTH	32
 #define	FNIC_STATS_RATE_LIMIT	4 /* limit rate at which stats are pulled up */
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 1671325..1711cd5 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -267,11 +267,6 @@ static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
 
 	if (desc->fip_dtype == FIP_DT_FLOGI) {
 
-		shost_printk(KERN_DEBUG, lport->host,
-			  " FIP TYPE FLOGI: fab name:%llx "
-			  "vfid:%d map:%x\n",
-			  fip->sel_fcf->fabric_name, fip->sel_fcf->vfid,
-			  fip->sel_fcf->fc_map);
 		if (dlen < sizeof(*els) + sizeof(*fh) + 1)
 			return 0;
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 33e4ec2..05657da 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -111,7 +111,7 @@ static struct scsi_host_template fnic_host_template = {
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
-	.can_queue = FNIC_MAX_IO_REQ,
+	.can_queue = FNIC_DFLT_IO_REQ,
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0xffff,
@@ -773,6 +773,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		shost_printk(KERN_INFO, fnic->lport->host,
 			     "firmware uses non-FIP mode\n");
 		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_NON_FIP);
+		fnic->ctlr.state = FIP_ST_NON_FIP;
 	}
 	fnic->state = FNIC_IN_FC_MODE;
 
-- 
1.8.5.4

