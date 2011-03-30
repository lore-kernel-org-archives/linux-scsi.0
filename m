From: madhu.iyengar@qlogic.com
Subject: [PATCH 03/18] qla2xxx: Check for a match before attempting to set FCP-priority information.
Date: Wed, 30 Mar 2011 11:46:18 -0700
Message-ID: <1301510793-2492-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45779 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755572Ab1C3SvO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:14 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Modifying qla24xx_get_fcp_prio() to return a 'found' status
allows the driver to short circuit the 'set FCP-priority' call
and reduce the amount of noise generated in the messages file:

	scsi(5): Unable to activate fcp priority,  ret=0x102
	scsi(5): Unable to activate fcp priority,  ret=0x102

Also make qla24xx_get_fcp_prio() static.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 394d03d..f98cfac 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5508,26 +5508,26 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
  *
  * Return:
  *	non-zero (if found)
- * 	0 (if not found)
+ *	-1 (if not found)
  *
  * Context:
  * 	Kernel context
  */
-uint8_t
+static int
 qla24xx_get_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int i, entries;
 	uint8_t pid_match, wwn_match;
-	uint8_t priority;
+	int priority;
 	uint32_t pid1, pid2;
 	uint64_t wwn1, wwn2;
 	struct qla_fcp_prio_entry *pri_entry;
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!ha->fcp_prio_cfg || !ha->flags.fcp_prio_enabled)
-		return 0;
+		return -1;
 
-	priority = 0;
+	priority = -1;
 	entries = ha->fcp_prio_cfg->num_entries;
 	pri_entry = &ha->fcp_prio_cfg->entry[0];
 
@@ -5610,7 +5610,7 @@ int
 qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int ret;
-	uint8_t priority;
+	int priority;
 	uint16_t mb[5];
 
 	if (fcport->port_type != FCT_TARGET ||
@@ -5618,6 +5618,9 @@ qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 		return QLA_FUNCTION_FAILED;
 
 	priority = qla24xx_get_fcp_prio(vha, fcport);
+	if (priority < 0)
+		return QLA_FUNCTION_FAILED;
+
 	ret = qla24xx_set_fcp_prio(vha, fcport->loop_id, priority, mb);
 	if (ret == QLA_SUCCESS)
 		fcport->fcp_prio = priority;
-- 
1.6.0.2

