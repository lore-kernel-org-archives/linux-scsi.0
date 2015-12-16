From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 13/17] lpfc: Fix external loopback failure.
Date: Wed, 16 Dec 2015 18:12:04 -0500
Message-ID: <5671efc4.p0ZuEBo3q81E+gY3%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33365 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbbLPXMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:23 -0500
Received: by mail-pa0-f45.google.com with SMTP id ur14so30974264pab.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:23 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id w65sm3056975pfa.18.2015.12.16.15.12.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix external loopback failure.

Rx sequence reassembly was incorrect.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e504d51..b4bff35 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14849,10 +14849,12 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 	struct lpfc_dmabuf *h_buf;
 	struct hbq_dmabuf *seq_dmabuf = NULL;
 	struct hbq_dmabuf *temp_dmabuf = NULL;
+	uint8_t	found = 0;
 
 	INIT_LIST_HEAD(&dmabuf->dbuf.list);
 	dmabuf->time_stamp = jiffies;
 	new_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+
 	/* Use the hdr_buf to find the sequence that this frame belongs to */
 	list_for_each_entry(h_buf, &vport->rcv_buffer_list, list) {
 		temp_hdr = (struct fc_frame_header *)h_buf->virt;
@@ -14892,7 +14894,8 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 		return seq_dmabuf;
 	}
 	/* find the correct place in the sequence to insert this frame */
-	list_for_each_entry_reverse(d_buf, &seq_dmabuf->dbuf.list, list) {
+	d_buf = list_entry(seq_dmabuf->dbuf.list.prev, typeof(*d_buf), list);
+	while (!found) {
 		temp_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 		temp_hdr = (struct fc_frame_header *)temp_dmabuf->hbuf.virt;
 		/*
@@ -14902,9 +14905,17 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 		if (be16_to_cpu(new_hdr->fh_seq_cnt) >
 			be16_to_cpu(temp_hdr->fh_seq_cnt)) {
 			list_add(&dmabuf->dbuf.list, &temp_dmabuf->dbuf.list);
-			return seq_dmabuf;
+			found = 1;
+			break;
 		}
+
+		if (&d_buf->list == &seq_dmabuf->dbuf.list)
+			break;
+		d_buf = list_entry(d_buf->list.prev, typeof(*d_buf), list);
 	}
+
+	if (found)
+		return seq_dmabuf;
 	return NULL;
 }
 
-- 
1.7.11.7

