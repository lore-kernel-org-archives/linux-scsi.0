From: "Madhani, Himanshu" <himanshu.madhani@cavium.com>
Subject: [PATCH 3/5] qla2xxx: Allow MBC_GET_PORT_DATABASE to query and save the port states
Date: Wed, 11 Oct 2017 13:36:48 -0700
Message-ID: <20171011203650.23629-4-himanshu.madhani@cavium.com>
References: <20171011203650.23629-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0055.outbound.protection.outlook.com ([104.47.41.55]:64975
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751866AbdJKUhA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Oct 2017 16:37:00 -0400
In-Reply-To: <20171011203650.23629-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Duane Grigsby <duane.grigsby@cavium.com>

The MBC_GET_PORT_DATABASE command normally checks the port state
informationi. This patch allows it to save that info in the fcport
structure and ignore the check if the query flag is set.

Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  4 ++++
 drivers/scsi/qla2xxx/qla_mbx.c | 29 ++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 66d239cbbd66..f712c0cd46d6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2303,6 +2303,7 @@ typedef struct fc_port {
 	unsigned int send_els_logo:1;
 	unsigned int login_pause:1;
 	unsigned int login_succ:1;
+	unsigned int query:1;
 
 	struct work_struct nvme_del_work;
 	struct completion nvme_del_done;
@@ -2369,6 +2370,8 @@ typedef struct fc_port {
 	struct list_head gnl_entry;
 	struct work_struct del_work;
 	u8 iocb[IOCB_SIZE];
+	u8 current_login_state;
+	u8 last_login_state;
 } fc_port_t;
 
 #define QLA_FCPORT_SCAN		1
@@ -4114,6 +4117,7 @@ typedef struct scsi_qla_host {
 #define QPAIR_ONLINE_CHECK_NEEDED	27
 #define SET_ZIO_THRESHOLD_NEEDED	28
 #define DETECT_SFP_CHANGE	29
+#define N2N_LOGIN_NEEDED	30
 
 	unsigned long	pci_flags;
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7f71fd378c27..71e56877e1eb 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1822,17 +1822,32 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 
 	if (IS_FWI2_CAPABLE(ha)) {
 		uint64_t zero = 0;
+		u8 current_login_state, last_login_state;
+
 		pd24 = (struct port_database_24xx *) pd;
 
 		/* Check for logged in state. */
-		if (pd24->current_login_state != PDS_PRLI_COMPLETE &&
-		    pd24->last_login_state != PDS_PRLI_COMPLETE) {
-			ql_dbg(ql_dbg_mbx, vha, 0x1051,
-			    "Unable to verify login-state (%x/%x) for "
-			    "loop_id %x.\n", pd24->current_login_state,
-			    pd24->last_login_state, fcport->loop_id);
+		if (fcport->fc4f_nvme) {
+			current_login_state = pd24->current_login_state >> 4;
+			last_login_state = pd24->last_login_state >> 4;
+		} else {
+			current_login_state = pd24->current_login_state & 0xf;
+			last_login_state = pd24->last_login_state & 0xf;
+		}
+		fcport->current_login_state = pd24->current_login_state;
+		fcport->last_login_state = pd24->last_login_state;
+
+		/* Check for logged in state. */
+		if (current_login_state != PDS_PRLI_COMPLETE &&
+		    last_login_state != PDS_PRLI_COMPLETE) {
+			ql_dbg(ql_dbg_mbx, vha, 0x119a,
+			    "Unable to verify login-state (%x/%x) for loop_id %x.\n",
+			    current_login_state, last_login_state,
+			    fcport->loop_id);
 			rval = QLA_FUNCTION_FAILED;
-			goto gpd_error_out;
+
+			if (!fcport->query)
+				goto gpd_error_out;
 		}
 
 		if (fcport->loop_id == FC_NO_LOOP_ID ||
-- 
2.12.0
