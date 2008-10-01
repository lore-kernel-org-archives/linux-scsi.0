From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/13] zfcp: put threshold data in hba trace
Date: Wed, 01 Oct 2008 12:42:21 +0200
Message-ID: <20081001104802.157568000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:34370 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYJAKsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:09 -0400
Content-Disposition: inline; filename=bit_error_threshold.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Now that we removed the long messages for the bit error threshold
data, put the data in the hba trace. This way, we get a short warning
for the threshold event from the hardware and have the data in the
trace for further analysis.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_dbf.h |    1 
 drivers/s390/scsi/zfcp_ext.h |    2 +
 drivers/s390/scsi/zfcp_fsf.c |    1 
 4 files changed, 50 insertions(+)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-10-01 11:08:09.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-10-01 11:09:31.000000000 +0200
@@ -318,6 +318,26 @@ void zfcp_hba_dbf_event_qdio(struct zfcp
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
+/**
+ * zfcp_hba_dbf_event_berr - trace event for bit error threshold
+ * @adapter: adapter affected by this QDIO related event
+ * @req: fsf request
+ */
+void zfcp_hba_dbf_event_berr(struct zfcp_adapter *adapter,
+			     struct zfcp_fsf_req *req)
+{
+	struct zfcp_hba_dbf_record *r = &adapter->hba_dbf_buf;
+	struct fsf_status_read_buffer *sr_buf = req->data;
+	struct fsf_bit_error_payload *err = &sr_buf->payload.bit_error;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	memset(r, 0, sizeof(*r));
+	strncpy(r->tag, "berr", ZFCP_DBF_TAG_SIZE);
+	memcpy(&r->u.berr, err, sizeof(struct fsf_bit_error_payload));
+	debug_event(adapter->hba_dbf, 0, r, sizeof(*r));
+	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+}
 static void zfcp_hba_dbf_view_response(char **p,
 				       struct zfcp_hba_dbf_record_response *r)
 {
@@ -399,6 +419,30 @@ static void zfcp_hba_dbf_view_qdio(char 
 	zfcp_dbf_out(p, "sbal_count", "0x%02x", r->sbal_count);
 }
 
+static void zfcp_hba_dbf_view_berr(char **p, struct fsf_bit_error_payload *r)
+{
+	zfcp_dbf_out(p, "link_failures", "%d", r->link_failure_error_count);
+	zfcp_dbf_out(p, "loss_of_sync_err", "%d", r->loss_of_sync_error_count);
+	zfcp_dbf_out(p, "loss_of_sig_err", "%d", r->loss_of_signal_error_count);
+	zfcp_dbf_out(p, "prim_seq_err", "%d",
+		     r->primitive_sequence_error_count);
+	zfcp_dbf_out(p, "inval_trans_word_err", "%d",
+		     r->invalid_transmission_word_error_count);
+	zfcp_dbf_out(p, "CRC_errors", "%d", r->crc_error_count);
+	zfcp_dbf_out(p, "prim_seq_event_to", "%d",
+		     r->primitive_sequence_event_timeout_count);
+	zfcp_dbf_out(p, "elast_buf_overrun_err", "%d",
+		     r->elastic_buffer_overrun_error_count);
+	zfcp_dbf_out(p, "adv_rec_buf2buf_cred", "%d",
+		     r->advertised_receive_b2b_credit);
+	zfcp_dbf_out(p, "curr_rec_buf2buf_cred", "%d",
+		     r->current_receive_b2b_credit);
+	zfcp_dbf_out(p, "adv_trans_buf2buf_cred", "%d",
+		     r->advertised_transmit_b2b_credit);
+	zfcp_dbf_out(p, "curr_trans_buf2buf_cred", "%d",
+		     r->current_transmit_b2b_credit);
+}
+
 static int zfcp_hba_dbf_view_format(debug_info_t *id, struct debug_view *view,
 				    char *out_buf, const char *in_buf)
 {
@@ -418,6 +462,8 @@ static int zfcp_hba_dbf_view_format(debu
 		zfcp_hba_dbf_view_status(&p, &r->u.status);
 	else if (strncmp(r->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_hba_dbf_view_qdio(&p, &r->u.qdio);
+	else if (strncmp(r->tag, "berr", ZFCP_DBF_TAG_SIZE) == 0)
+		zfcp_hba_dbf_view_berr(&p, &r->u.berr);
 
 	p += sprintf(p, "\n");
 	return p - out_buf;
--- a/drivers/s390/scsi/zfcp_dbf.h	2008-10-01 11:02:42.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-10-01 11:09:31.000000000 +0200
@@ -151,6 +151,7 @@ struct zfcp_hba_dbf_record {
 		struct zfcp_hba_dbf_record_response response;
 		struct zfcp_hba_dbf_record_status status;
 		struct zfcp_hba_dbf_record_qdio qdio;
+		struct fsf_bit_error_payload berr;
 	} u;
 } __attribute__ ((packed));
 
--- a/drivers/s390/scsi/zfcp_ext.h	2008-10-01 11:08:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-10-01 11:09:31.000000000 +0200
@@ -49,6 +49,8 @@ extern void zfcp_hba_dbf_event_fsf_unsol
 					 struct fsf_status_read_buffer *);
 extern void zfcp_hba_dbf_event_qdio(struct zfcp_adapter *, unsigned int, int,
 				    int);
+extern void zfcp_hba_dbf_event_berr(struct zfcp_adapter *,
+				    struct zfcp_fsf_req *);
 extern void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *);
 extern void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *);
 extern void zfcp_san_dbf_event_els_request(struct zfcp_fsf_req *);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 11:09:06.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 11:09:31.000000000 +0200
@@ -294,6 +294,7 @@ static void zfcp_fsf_status_read_handler
 		dev_warn(&adapter->ccw_device->dev,
 			 "The error threshold for checksum statistics "
 			 "has been exceeded\n");
+		zfcp_hba_dbf_event_berr(adapter, req);
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);

-- 
