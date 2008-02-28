From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/4] qla2xxx: Correct usage of inconsistent timeout values while issuing ELS commands.
Date: Thu, 28 Feb 2008 14:06:11 -0800
Message-ID: <1204236372-19080-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080228220509.GE18083@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21364 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbYB1WG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 17:06:26 -0500
In-Reply-To: <20080228220509.GE18083@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The original code would incorrectly hardcode ELS timeout values
rather than using the traditional '2 * r_a_tov' value.  In some
cases, the hardcoded values would be larger than the
mailbox-command-timeout and result in a needless BIG_HAMMER (ISP
reset), the typical recovery mechanism employed in such cases.

The second defect in the original code was in the assignment of
the default 'ha->r_a_tov' to twice the traditional value.
Correct this by setting the value to 10 seconds.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   |   10 +++++-----
 drivers/scsi/qla2xxx/qla_init.c |    8 ++++----
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 6226d88..c180876 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -39,7 +39,7 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
 	ms_pkt->entry_count = 1;
 	SET_TARGET_ID(ha, ms_pkt->loop_id, SIMPLE_NAME_SERVER);
 	ms_pkt->control_flags = __constant_cpu_to_le16(CF_READ | CF_HEAD_TAG);
-	ms_pkt->timeout = __constant_cpu_to_le16(25);
+	ms_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ms_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
 	ms_pkt->total_dsd_count = __constant_cpu_to_le16(2);
 	ms_pkt->rsp_bytecount = cpu_to_le32(rsp_size);
@@ -75,7 +75,7 @@ qla24xx_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
 	ct_pkt->entry_type = CT_IOCB_TYPE;
 	ct_pkt->entry_count = 1;
 	ct_pkt->nport_handle = __constant_cpu_to_le16(NPH_SNS);
-	ct_pkt->timeout = __constant_cpu_to_le16(25);
+	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
@@ -1144,7 +1144,7 @@ qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
 	ms_pkt->entry_count = 1;
 	SET_TARGET_ID(ha, ms_pkt->loop_id, ha->mgmt_svr_loop_id);
 	ms_pkt->control_flags = __constant_cpu_to_le16(CF_READ | CF_HEAD_TAG);
-	ms_pkt->timeout = __constant_cpu_to_le16(59);
+	ms_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ms_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
 	ms_pkt->total_dsd_count = __constant_cpu_to_le16(2);
 	ms_pkt->rsp_bytecount = cpu_to_le32(rsp_size);
@@ -1181,7 +1181,7 @@ qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
 	ct_pkt->entry_type = CT_IOCB_TYPE;
 	ct_pkt->entry_count = 1;
 	ct_pkt->nport_handle = cpu_to_le16(ha->mgmt_svr_loop_id);
-	ct_pkt->timeout = __constant_cpu_to_le16(59);
+	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
@@ -1761,7 +1761,7 @@ qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *ha, uint32_t req_size,
 	ct_pkt->entry_type = CT_IOCB_TYPE;
 	ct_pkt->entry_count = 1;
 	ct_pkt->nport_handle = cpu_to_le16(ha->mgmt_svr_loop_id);
-	ct_pkt->timeout = __constant_cpu_to_le16(59);
+	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4897663..364be7d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1733,8 +1733,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 	ha->login_timeout = nv->login_timeout;
 	icb->login_timeout = nv->login_timeout;
 
-	/* Set minimum RATOV to 200 tenths of a second. */
-	ha->r_a_tov = 200;
+	/* Set minimum RATOV to 100 tenths of a second. */
+	ha->r_a_tov = 100;
 
 	ha->loop_reset_delay = nv->reset_delay;
 
@@ -3645,8 +3645,8 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
 	icb->login_timeout = cpu_to_le16(nv->login_timeout);
 
-	/* Set minimum RATOV to 200 tenths of a second. */
-	ha->r_a_tov = 200;
+	/* Set minimum RATOV to 100 tenths of a second. */
+	ha->r_a_tov = 100;
 
 	ha->loop_reset_delay = nv->reset_delay;
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 99d29ff..bb10358 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2206,7 +2206,7 @@ qla24xx_abort_target(fc_port_t *fcport)
 	tsk->p.tsk.entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->p.tsk.entry_count = 1;
 	tsk->p.tsk.nport_handle = cpu_to_le16(fcport->loop_id);
-	tsk->p.tsk.timeout = __constant_cpu_to_le16(25);
+	tsk->p.tsk.timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->p.tsk.control_flags = __constant_cpu_to_le32(TCF_TARGET_RESET);
 	tsk->p.tsk.port_id[0] = fcport->d_id.b.al_pa;
 	tsk->p.tsk.port_id[1] = fcport->d_id.b.area;
-- 
1.5.4.3.230.g2db511

