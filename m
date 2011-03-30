From: madhu.iyengar@qlogic.com
Subject: [PATCH 01/18] qla2xxx: Display PortID information during FCP command-status handling.
Date: Wed, 30 Mar 2011 11:46:16 -0700
Message-ID: <1301510793-2492-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45773 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755550Ab1C3SvN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:13 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

To provide a clearer translation of the command-status origin in
relation to the midlayer's standard SCSI nexus.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d17ed9a..5bb4d58 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1794,12 +1794,13 @@ out:
 	if (logit)
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "scsi(%ld:%d:%d) FCP command status: 0x%x-0x%x (0x%x) "
-		    "oxid=0x%x cdb=%02x%02x%02x len=0x%x "
+		    "portid=%02x%02x%02x oxid=0x%x cdb=%02x%02x%02x len=0x%x "
 		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x\n", vha->host_no,
 		    cp->device->id, cp->device->lun, comp_status, scsi_status,
-		    cp->result, ox_id, cp->cmnd[0],
-		    cp->cmnd[1], cp->cmnd[2], scsi_bufflen(cp), rsp_info_len,
-		    resid_len, fw_resid_len));
+		    cp->result, fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa, ox_id, cp->cmnd[0], cp->cmnd[1],
+		    cp->cmnd[2], scsi_bufflen(cp), rsp_info_len, resid_len,
+		    fw_resid_len));
 
 	if (rsp->status_srb == NULL)
 		qla2x00_sp_compl(ha, sp);
-- 
1.6.0.2

