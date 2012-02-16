From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] qla2xxx: Set disable_target_scan=1 when initiator-mode is disabled
Date: Thu, 16 Feb 2012 06:47:13 +0000
Message-ID: <1329374833-7086-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: target-devel <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Ben Lairson <ben.lairson@4bright.com>, Roland Dreier <roland@purestorage.com>, Arun Easi <arun.easi@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch sets fc_function_template->disable_target_scan=1 with
qla2xxx_transport_functions + qla2xxx_transport_vport_functions during
qla2x00_module_init() when qla_target.c init code is explictly asking
to disable initiator-mode for all ports with QLA2XXX_INI_MODE_DISABLED.

This fixes a bug where a FC fabric LOOP UP event causes an initiator-mode
LUN SCAN to occur via scsi_transport_fc.:fc_scsi_scan_rport() ->
scsi_scan_target() before tcm_qla2xxx ports are configured -> enabled
to run in target-mode.

This ends up causing SCSI layer timeouts during normal tcm_qla2xxx port
setup w/ ISP reset, so go ahead and explictly set disable_target_scan=1
during init to prevent this from occuring.

Reported-by: Ben Lairson <ben.lairson@4bright.com>
Cc: Ben Lairson <ben.lairson@4bright.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_os.c     |    8 ++++++++
 drivers/scsi/qla2xxx/qla_target.c |    6 ++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3db960b..8b08bec 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4405,6 +4405,14 @@ qla2x00_module_init(void)
 	if (ret < 0) {
 		kmem_cache_destroy(srb_cachep);
 		return ret;
+	} else if (ret > 0) {
+		/*
+		 * If initiator mode is explictly disabled by qla_tgt_init(),
+		 * prevent scsi_transport_fc.c:fc_scsi_scan_rport() from
+		 * performing scsi_scan_target() during LOOP UP event.
+		 */
+		qla2xxx_transport_functions.disable_target_scan = 1;
+		qla2xxx_transport_vport_functions.disable_target_scan = 1;
 	}
 
 	/* Derive version string. */
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ac203ef..9282014 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4753,8 +4753,10 @@ int __init qla_tgt_init(void)
 		ret = -ENOMEM;
 		goto out_cmd_mempool;
 	}
-
-	return 0;
+	/*
+	 * Return 1 to signal that initiator-mode is being disabled
+	 */
+	return (ql2x_ini_mode == QLA2XXX_INI_MODE_DISABLED) ? 1 : 0;
 
 out_cmd_mempool:
 	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
-- 
1.7.2.5
