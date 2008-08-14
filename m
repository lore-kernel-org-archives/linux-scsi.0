From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/8] qla2xxx: Reference proper ha during SBR handling.
Date: Wed, 13 Aug 2008 21:37:00 -0700
Message-ID: <1218688622-71361-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20080814043632.GL61889@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:58080 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYHNEhN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:37:13 -0400
In-Reply-To: <20080814043632.GL61889@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The executing-HA of an SRB can be referenced from the sp->fcport.
Use this correct value while processing status-continuation data
and abort processing.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    7 ++++---
 drivers/scsi/qla2xxx/qla_os.c  |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d6a1a66..45a3b93 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -879,11 +879,12 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 	sp->request_sense_ptr += sense_len;
 	sp->request_sense_length -= sense_len;
 	if (sp->request_sense_length != 0)
-		sp->ha->status_srb = sp;
+		sp->fcport->ha->status_srb = sp;
 
 	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
-	    "cmd=%p pid=%ld\n", __func__, sp->ha->host_no, cp->device->channel,
-	    cp->device->id, cp->device->lun, cp, cp->serial_number));
+	    "cmd=%p pid=%ld\n", __func__, sp->fcport->ha->host_no,
+	    cp->device->channel, cp->device->id, cp->device->lun, cp,
+	    cp->serial_number));
 	if (sense_len)
 		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
 		    CMD_ACTUAL_SNSLEN(cp)));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c2092ad..e0880ad 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -780,7 +780,8 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha, unsigned int t,
 		sp = pha->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
-		if (ha->vp_idx != sp->ha->vp_idx)
+
+		if (ha->vp_idx != sp->fcport->ha->vp_idx)
 			continue;
 		match = 0;
 		switch (type) {
-- 
1.6.0.rc2.22.g71b9

