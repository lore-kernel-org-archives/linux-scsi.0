From: giridhar.malavali@qlogic.com
Subject: [PATCH 7/9] qla2xxx: Properly re-register FC4/FDMI after physical and logical link disruptions.
Date: Tue, 13 Oct 2009 15:16:51 -0700
Message-ID: <1255472213-472-8-git-send-email-giridhar.malavali@qlogic.com>
References: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49707 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1761548AbZJMWY7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:59 -0400
In-Reply-To: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code would not register FC4 nor FDMI information after a
logical tear-down of an VFC link.  Code now triggers registration
date during processing of a 'Report ID Acquisition IOCB', which
is submitted after a FLOGI or FDISC completes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    1 -
 drivers/scsi/qla2xxx/qla_mbx.c  |   11 ++++++++---
 drivers/scsi/qla2xxx/qla_mid.c  |    2 --
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c8b24b6..b74924b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -277,7 +277,6 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->marker_needed = 0;
 	ha->isp_abort_cnt = 0;
 	ha->beacon_blink_led = 0;
-	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 
 	set_bit(0, ha->req_qid_map);
 	set_bit(0, ha->rsp_qid_map);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 791f792..05d595d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2782,8 +2782,10 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		    vp_idx, MSB(stat),
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]));
-		if (vp_idx == 0)
-			return;
+
+		vp = vha;
+		if (vp_idx == 0 && (MSB(stat) != 1))
+			goto reg_needed;
 
 		if (MSB(stat) == 1) {
 			DEBUG2(printk("scsi(%ld): Could not acquire ID for "
@@ -2806,8 +2808,11 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		 * response queue. Handle it in dpc context.
 		 */
 		set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
-		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
+reg_needed:
+		set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
+		set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
+		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 42b799a..11c7f37 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -382,8 +382,6 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
 
 	vha->dpc_flags = 0L;
-	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
-	set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
 
 	/*
 	 * To fix the issue of processing a parent's RSCN for the vport before
-- 
1.6.2.rc1.30.gd43c

