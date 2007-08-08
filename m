From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 3/4] zfcp: Avoid race condition on "link up" event
Date: Wed, 8 Aug 2007 10:47:14 +0200
Message-ID: <200708081047.14300.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:55375 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbXHHIpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2007 04:45:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schmichr@de.ibm.com

From: Christoph Schmitt <schmichr@de.ibm.com>

Symptom:     zfcp receives a response to a "status read" request
	     that is no longer valid in zfcp. This leads to a
	     kernel panic, since some memory has been overwritten
	     by the response reporting.
Problem:     On receiving an "unsolicited status", zfcp issues a
	     new "status read" request. On receiving the
	     "unsolicited status" "link up", zfcp triggers an adapter
	     reopen. The new "status read" request and the reopen
	     can lead to a race where zfcp issues the request before
	     the reopen, but the hardware handles the reopen first.
Solution:    Not issue the "status read" request to avoid the race
	     condition. The adapter reopen will enqueue 16 new
	     "status read" requests anyway.

Signed-off-by: Christoph Schmitt <schmichr@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2007-08-08 10:13:39.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2007-08-08 10:14:03.000000000 +0200
@@ -33,7 +33,7 @@ static int zfcp_fsf_send_fcp_command_tas
 static int zfcp_fsf_send_fcp_command_task_management_handler(
 	struct zfcp_fsf_req *);
 static int zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_status_read_handler(struct zfcp_fsf_req *);
+static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *);
 static int zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *);
 static int zfcp_fsf_send_els_handler(struct zfcp_fsf_req *);
 static int zfcp_fsf_control_file_handler(struct zfcp_fsf_req *);
@@ -856,10 +856,10 @@ zfcp_fsf_status_read_port_closed(struct 
  *
  * returns:	
  */
-static int
+static void
 zfcp_fsf_status_read_handler(struct zfcp_fsf_req *fsf_req)
 {
-	int retval = 0;
+	int retval;
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_status_read_buffer *status_buffer =
 		(struct fsf_status_read_buffer *) fsf_req->data;
@@ -869,7 +869,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, status_buffer);
 		mempool_free(status_buffer, adapter->pool.data_status_read);
 		zfcp_fsf_req_free(fsf_req);
-		goto out;
+		return;
 	}
 
 	zfcp_hba_dbf_event_fsf_unsol("read", adapter, status_buffer);
@@ -1061,6 +1061,15 @@ zfcp_fsf_status_read_handler(struct zfcp
 	 * FIXME:
 	 * allocation failure possible? (Is this code needed?)
 	 */
+	/*
+	 * If we triggered an adapter reopen, then the reopen will also
+	 * enqueue new status read requests. Not issuing a status read
+	 * here avoids a race between the request send and the adapter
+	 * reopen.
+	 */
+	if (status_buffer->status_type == FSF_STATUS_READ_LINK_UP)
+		return;
+
 	retval = zfcp_fsf_status_read(adapter, 0);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("Failed to create unsolicited status read "
@@ -1076,8 +1085,6 @@ zfcp_fsf_status_read_handler(struct zfcp
 			zfcp_erp_adapter_reopen(adapter, 0);
 		}
 	}
- out:
-	return retval;
 }
 
 /*
