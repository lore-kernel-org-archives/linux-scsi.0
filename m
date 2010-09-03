From: madhu.iyengar@qlogic.com
Subject: [PATCH 09/10] qla2xxx: Increase SG table size to support large IO size per scsi command.
Date: Fri,  3 Sep 2010 15:20:56 -0700
Message-ID: <1283552457-4497-10-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39335 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753577Ab0ICW06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:58 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

The sg table size is increased from 128 to 1024 to support multiple sg lists
and number of sg elements per scsi command.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 ++
 drivers/scsi/qla2xxx/qla_os.c  |   12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 12592cf..e1d3ad4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3009,6 +3009,8 @@ typedef struct scsi_qla_host {
 
 #define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
 
+#define QLA_SG_ALL	1024
+
 enum nexus_wait_type {
 	WAIT_HOST = 0,
 	WAIT_TARGET,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dc495a3..c8ef4ee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2141,8 +2141,16 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		base_vha->mgmt_svr_loop_id = MANAGEMENT_SERVER +
 						base_vha->vp_idx;
-	if (IS_QLA2100(ha))
-		host->sg_tablesize = 32;
+
+	/* Set the SG table size based on ISP type */
+	if (!IS_FWI2_CAPABLE(ha)) {
+		if (IS_QLA2100(ha))
+			host->sg_tablesize = 32;
+	} else {
+		if (!IS_QLA82XX(ha))
+			host->sg_tablesize = QLA_SG_ALL;
+	}
+
 	host->max_id = max_id;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
-- 
1.6.0.2

