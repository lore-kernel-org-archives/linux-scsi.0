From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v3 08/10] be2iscsi: Check size before copying ASYNC handle
Date: Fri, 24 Mar 2017 14:11:47 +0530
Message-ID: <1490344909-29541-9-git-send-email-jitendra.bhivare@broadcom.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:34530 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754953AbdCXImc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 04:42:32 -0400
Received: by mail-qt0-f172.google.com with SMTP id n21so5450419qta.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 01:42:31 -0700 (PDT)
In-Reply-To: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Data in buffers are gathered into a single buffer before giving to
iSCSI layer. Though less likely to have payload more than 8K in
ASYNC PDU, the data length is provide by FW and check is missing
for overrun.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ee1f1c4..4b668c4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1611,6 +1611,10 @@ beiscsi_hdl_fwd_pdu(struct beiscsi_conn *beiscsi_conn,
 			dlen = pasync_handle->buffer_len;
 			continue;
 		}
+		if (!pasync_handle->buffer_len ||
+		    (dlen + pasync_handle->buffer_len) >
+		    pasync_ctx->async_data.buffer_size)
+			break;
 		memcpy(pdata + dlen, pasync_handle->pbuffer,
 		       pasync_handle->buffer_len);
 		dlen += pasync_handle->buffer_len;
@@ -1619,8 +1623,9 @@ beiscsi_hdl_fwd_pdu(struct beiscsi_conn *beiscsi_conn,
 	if (!plast_handle->is_final) {
 		/* last handle should have final PDU notification from FW */
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_ISCSI,
-			    "BM_%d : cid %u %p fwd async PDU with last handle missing - HL%u:DN%u:DR%u\n",
+			    "BM_%d : cid %u %p fwd async PDU opcode %x with last handle missing - HL%u:DN%u:DR%u\n",
 			    beiscsi_conn->beiscsi_conn_cid, plast_handle,
+			    AMAP_GET_BITS(struct amap_pdu_base, opcode, phdr),
 			    pasync_ctx->async_entry[cri].wq.hdr_len,
 			    pasync_ctx->async_entry[cri].wq.bytes_needed,
 			    pasync_ctx->async_entry[cri].wq.bytes_received);
-- 
2.7.4
