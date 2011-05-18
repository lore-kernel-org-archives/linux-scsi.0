From: vikas.chaudhary@qlogic.com
Subject: [PATCH 04/10] qla4xxx: Complete the cmd if sense_len is zero
Date: Tue, 17 May 2011 23:17:06 -0700
Message-ID: <1305699432-13225-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50941 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754246Ab1ERGXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:46 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Prasanna Mumbai <prasanna.mumbai@qlogic.com>

From: Prasanna Mumbai <prasanna.mumbai@qlogic.com>

Complete the cmd if sense length is zero. For cases where sense
data spans across multiple iocb's by FW, we need to hold on to the
I/O (ha->status_srb != NULL) till we have processed them all and
copied the sense data from internal buffer to scsi_cmd sense buffer.

Signed-off-by: Prasanna Mumbai <prasanna.mumbai@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 67d6651..0e72921 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -25,9 +25,14 @@ static void qla4xxx_copy_sense(struct scsi_qla_host *ha,
 
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	sense_len = le16_to_cpu(sts_entry->senseDataByteCnt);
-	if (sense_len == 0)
+	if (sense_len == 0) {
+		DEBUG2(ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%d:%d: %s:"
+				  " sense len 0\n", ha->host_no,
+				  cmd->device->channel, cmd->device->id,
+				  cmd->device->lun, __func__));
+		ha->status_srb = NULL;
 		return;
-
+	}
 	/* Save total available sense length,
 	 * not to exceed cmd's sense buffer size */
 	sense_len = min_t(uint16_t, sense_len, SCSI_SENSE_BUFFERSIZE);
-- 
1.7.3.2

