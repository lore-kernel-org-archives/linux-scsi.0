From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/11] zfcp: Add qtcb dump to hba debug trace
Date: Thu, 27 Mar 2008 14:21:58 +0100
Message-ID: <20080327133025.388911000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57786 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342AbYC0Na2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:28 -0400
Content-Disposition: inline; filename=zfcp_hba_dbf_qtcb_trace.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This patch adds per request hardware debugging data to the trace
record which is written per request. It's a replacement for some sad
kernel message based debugging code. Considering the amount of trace
data, printk() is not suitable for this stuff. Writing binary traces
is more efficient. In addition we got all information in one place.

The QTCB trace data is only dumped for requests other than SCSI
requests.  Otherwise we would flood the trace ring buffer. We are
mostly interested in non-SCSI, recovery related requests here anyway.

This patch also works around a known hardware bug. It truncates QTCB
traces so that we do not save unused areas of the hardware trace.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:54:38.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:55:46.000000000 +0100
@@ -179,6 +179,9 @@ void zfcp_hba_dbf_event_fsf_response(str
 		   (fsf_req->fsf_command == FSF_QTCB_OPEN_LUN)) {
 		strncpy(rec->tag2, "open", ZFCP_DBF_TAG_SIZE);
 		level = 4;
+	} else if (qtcb->header.log_length) {
+		strncpy(rec->tag2, "qtcb", ZFCP_DBF_TAG_SIZE);
+		level = 5;
 	} else {
 		strncpy(rec->tag2, "norm", ZFCP_DBF_TAG_SIZE);
 		level = 6;
@@ -250,6 +253,17 @@ void zfcp_hba_dbf_event_fsf_response(str
 
 	debug_event(adapter->hba_dbf, level,
 		    rec, sizeof(struct zfcp_hba_dbf_record));
+
+	/* have fcp channel microcode fixed to use as little as possible */
+	if (fsf_req->fsf_command != FSF_QTCB_FCP_CMND) {
+		/* adjust length skipping trailing zeros */
+		char *buf = (char *)qtcb + qtcb->header.log_start;
+		int len = qtcb->header.log_length;
+		for (; len && !buf[len - 1]; len--);
+		zfcp_dbf_hexdump(adapter->hba_dbf, rec, sizeof(*rec), level,
+				 buf, len);
+	}
+
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 

-- 
