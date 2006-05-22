From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 5/8] zfcp: print bit error threshold data human readable
Date: Mon, 22 May 2006 18:21:28 +0200
Message-ID: <20060522162128.GA25264@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:36330 "EHLO
	mtagate6.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750825AbWEVQYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:24:01 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGO0Tr078106
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:24:00 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGP12o132716
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:25:01 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGNx6k022451
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:24:00 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Ralph Wuerthner <rwuerthn@de.ibm.com>

From: Ralph Wuerthner <rwuerthn@de.ibm.com>

zfcp: print bit error threshold data human readable

Replace hex dump of bit error threshold data by log message showing
bit error threshold data human readable.

Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com> 

---

38781d494e0e9fcd3df99971f8e6d85b191b0c21
 drivers/s390/scsi/zfcp_fsf.c |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

38781d494e0e9fcd3df99971f8e6d85b191b0c21
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 83b68e3..55785ac 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -866,6 +866,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_status_read_buffer *status_buffer =
 		(struct fsf_status_read_buffer *) fsf_req->data;
+	struct fsf_bit_error_payload *fsf_bit_error;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, status_buffer);
@@ -892,10 +893,37 @@ zfcp_fsf_status_read_handler(struct zfcp
 		break;
 
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		ZFCP_LOG_NORMAL("Bit error threshold data received:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-			      (char *) status_buffer,
-			      sizeof (struct fsf_status_read_buffer));
+		fsf_bit_error = (struct fsf_bit_error_payload *)
+			status_buffer->payload;
+		ZFCP_LOG_NORMAL("Warning: bit error threshold data "
+		    "received (adapter %s, "
+		    "link failures = %i, loss of sync errors = %i, "
+		    "loss of signal errors = %i, "
+		    "primitive sequence errors = %i, "
+		    "invalid transmission word errors = %i, "
+		    "CRC errors = %i)\n",
+		    zfcp_get_busid_by_adapter(adapter),
+		    fsf_bit_error->link_failure_error_count,
+		    fsf_bit_error->loss_of_sync_error_count,
+		    fsf_bit_error->loss_of_signal_error_count,
+		    fsf_bit_error->primitive_sequence_error_count,
+		    fsf_bit_error->invalid_transmission_word_error_count,
+		    fsf_bit_error->crc_error_count);
+		ZFCP_LOG_INFO("Additional bit error threshold data "
+		    "(adapter %s, "
+		    "primitive sequence event time-outs = %i, "
+		    "elastic buffer overrun errors = %i, "
+		    "advertised receive buffer-to-buffer credit = %i, "
+		    "current receice buffer-to-buffer credit = %i, "
+		    "advertised transmit buffer-to-buffer credit = %i, "
+		    "current transmit buffer-to-buffer credit = %i)\n",
+		    zfcp_get_busid_by_adapter(adapter),
+		    fsf_bit_error->primitive_sequence_event_timeout_count,
+		    fsf_bit_error->elastic_buffer_overrun_error_count,
+		    fsf_bit_error->advertised_receive_b2b_credit,
+		    fsf_bit_error->current_receive_b2b_credit,
+		    fsf_bit_error->advertised_transmit_b2b_credit,
+		    fsf_bit_error->current_transmit_b2b_credit);
 		break;
 
 	case FSF_STATUS_READ_LINK_DOWN:
-- 
1.3.3.gd5e3d

