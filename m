From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/11] zfcp: Add information about interrupt to trace.
Date: Mon, 19 May 2008 12:17:44 +0200
Message-ID: <20080519101831.952569000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:25061 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbYESKSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:35 -0400
Content-Disposition: inline; filename=zfcp_dbf_add_inbound_sbal_index.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Store the index of the buffer in the inbound queue used to report
request completion in trace record for request coompletion.
This piece of information allows to better compare qdio and zfcp traces.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c  |    2 ++
 drivers/s390/scsi/zfcp_dbf.h  |    1 +
 drivers/s390/scsi/zfcp_def.h  |    1 +
 drivers/s390/scsi/zfcp_qdio.c |    5 +++--
 4 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:35:14.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:35:46.000000000 +0200
@@ -187,6 +187,7 @@ void zfcp_hba_dbf_event_fsf_response(str
 	response->fsf_req_status = fsf_req->status;
 	response->sbal_first = fsf_req->sbal_first;
 	response->sbal_last = fsf_req->sbal_last;
+	response->sbal_response = fsf_req->sbal_response;
 	response->pool = fsf_req->pool != NULL;
 	response->erp_action = (unsigned long)fsf_req->erp_action;
 
@@ -355,6 +356,7 @@ static void zfcp_hba_dbf_view_response(c
 	zfcp_dbf_out(p, "fsf_req_status", "0x%08x", r->fsf_req_status);
 	zfcp_dbf_out(p, "sbal_first", "0x%02x", r->sbal_first);
 	zfcp_dbf_out(p, "sbal_last", "0x%02x", r->sbal_last);
+	zfcp_dbf_out(p, "sbal_response", "0x%02x", r->sbal_response);
 	zfcp_dbf_out(p, "pool", "0x%02x", r->pool);
 
 	switch (r->fsf_command) {
--- a/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:35:14.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:35:46.000000000 +0200
@@ -98,6 +98,7 @@ struct zfcp_hba_dbf_record_response {
 	u32 fsf_req_status;
 	u8 sbal_first;
 	u8 sbal_last;
+	u8 sbal_response;
 	u8 pool;
 	u64 erp_action;
 	union {
--- a/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:35:14.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:35:46.000000000 +0200
@@ -856,6 +856,7 @@ struct zfcp_fsf_req {
 						  this reuest */
 	u8		       sbale_curr;     /* current SBALE during creation
 						  of request */
+	u8			sbal_response;	/* SBAL used in interrupt */
 	wait_queue_head_t      completion_wq;  /* can be used by a routine
 						  to wait for completion */
 	volatile u32	       status;	       /* status of this request */
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-05-19 11:35:14.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-05-19 11:35:46.000000000 +0200
@@ -235,7 +235,7 @@ zfcp_qdio_request_handler(struct ccw_dev
  * zfcp_qdio_reqid_check - checks for valid reqids.
  */
 static void zfcp_qdio_reqid_check(struct zfcp_adapter *adapter,
-				  unsigned long req_id)
+				  unsigned long req_id, int sbal)
 {
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags;
@@ -255,6 +255,7 @@ static void zfcp_qdio_reqid_check(struct
 	atomic_dec(&adapter->reqs_active);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
+	fsf_req->sbal_response = sbal;
 	/* finish the FSF request */
 	zfcp_fsf_req_complete(fsf_req);
 }
@@ -321,7 +322,7 @@ zfcp_qdio_response_handler(struct ccw_de
 			/* look for QDIO request identifiers in SB */
 			buffere = &buffer->element[buffere_index];
 			zfcp_qdio_reqid_check(adapter,
-					      (unsigned long) buffere->addr);
+					      (unsigned long) buffere->addr, i);
 
 			/*
 			 * A single used SBALE per inbound SBALE has been

-- 
