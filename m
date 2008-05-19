From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/11] zfcp: Rename sbal_curr to sbal_last.
Date: Mon, 19 May 2008 12:17:43 +0200
Message-ID: <20080519101831.125739000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:29145 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbYESKSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:34 -0400
Content-Disposition: inline; filename=zfcp_dbf_rename_sbal_curr.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

sbal_last is more appropriate, because it matches sbal_first.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c  |    4 ++--
 drivers/s390/scsi/zfcp_dbf.h  |    2 +-
 drivers/s390/scsi/zfcp_def.h  |    3 +--
 drivers/s390/scsi/zfcp_fsf.c  |   36 ++++++++++++++++++------------------
 drivers/s390/scsi/zfcp_qdio.c |   16 ++++++++--------
 5 files changed, 30 insertions(+), 31 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:33:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:35:14.000000000 +0200
@@ -97,7 +97,7 @@ struct zfcp_hba_dbf_record_response {
 	u8 fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
 	u32 fsf_req_status;
 	u8 sbal_first;
-	u8 sbal_curr;
+	u8 sbal_last;
 	u8 pool;
 	u64 erp_action;
 	union {
--- a/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:34:36.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:35:14.000000000 +0200
@@ -851,10 +851,9 @@ struct zfcp_fsf_req {
 	struct zfcp_adapter    *adapter;       /* adapter request belongs to */
 	u8		       sbal_number;    /* nr of SBALs free for use */
 	u8		       sbal_first;     /* first SBAL for this request */
+	u8		       sbal_last;      /* last SBAL for this request */
 	u8		       sbal_limit;      /* last possible SBAL for
 						  this reuest */
-	u8		       sbal_curr;      /* current SBAL during creation
-						  of request */
 	u8		       sbale_curr;     /* current SBALE during creation
 						  of request */
 	wait_queue_head_t      completion_wq;  /* can be used by a routine
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-05-19 11:34:36.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-05-19 11:35:14.000000000 +0200
@@ -415,7 +415,7 @@ zfcp_qdio_sbale_resp(struct zfcp_fsf_req
 volatile struct qdio_buffer_element *
 zfcp_qdio_sbale_curr(struct zfcp_fsf_req *fsf_req)
 {
-	return zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr,
+	return zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last,
 				   fsf_req->sbale_curr);
 }
 
@@ -443,7 +443,7 @@ zfcp_qdio_sbal_limit(struct zfcp_fsf_req
  * @fsf_req: zfcp_fsf_req to be processed
  * @sbtype: SBAL flags which have to be set in first SBALE of new SBAL
  *
- * This function changes sbal_curr, sbale_curr, sbal_number of fsf_req.
+ * This function changes sbal_last, sbale_curr, sbal_number of fsf_req.
  */
 static volatile struct qdio_buffer_element *
 zfcp_qdio_sbal_chain(struct zfcp_fsf_req *fsf_req, unsigned long sbtype)
@@ -455,16 +455,16 @@ zfcp_qdio_sbal_chain(struct zfcp_fsf_req
 	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	/* don't exceed last allowed SBAL */
-	if (fsf_req->sbal_curr == fsf_req->sbal_limit)
+	if (fsf_req->sbal_last == fsf_req->sbal_limit)
 		return NULL;
 
 	/* set chaining flag in first SBALE of current SBAL */
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale->flags |= SBAL_FLAGS0_MORE_SBALS;
 
 	/* calculate index of next SBAL */
-	fsf_req->sbal_curr++;
-	fsf_req->sbal_curr %= QDIO_MAX_BUFFERS_PER_Q;
+	fsf_req->sbal_last++;
+	fsf_req->sbal_last %= QDIO_MAX_BUFFERS_PER_Q;
 
 	/* keep this requests number of SBALs up-to-date */
 	fsf_req->sbal_number++;
@@ -523,7 +523,7 @@ static inline int
 zfcp_qdio_sbals_wipe(struct zfcp_fsf_req *fsf_req)
 {
 	return zfcp_qdio_sbals_zero(&fsf_req->adapter->request_queue,
-				    fsf_req->sbal_first, fsf_req->sbal_curr);
+				    fsf_req->sbal_first, fsf_req->sbal_last);
 }
 
 
@@ -601,7 +601,7 @@ zfcp_qdio_sbals_from_sg(struct zfcp_fsf_
 	zfcp_qdio_sbal_limit(fsf_req, max_sbals);
 
 	/* set storage-block type for current SBAL */
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale->flags |= sbtype;
 
 	/* process all segements of scatter-gather list */
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-05-19 11:31:26.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-05-19 11:35:14.000000000 +0200
@@ -726,7 +726,7 @@ zfcp_fsf_status_read(struct zfcp_adapter
 		goto failed_req_create;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_STATUS;
         sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
         fsf_req->sbale_curr = 2;
@@ -1075,7 +1075,7 @@ zfcp_fsf_abort_fcp_command(unsigned long
 			&unit->status)))
 		goto unit_blocked;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1295,7 +1295,7 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 		goto failed_req;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         if (zfcp_use_one_sbal(ct->req, ct->req_count,
                               ct->resp, ct->resp_count)){
                 /* both request buffer and response buffer
@@ -1593,7 +1593,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 		goto port_blocked;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         if (zfcp_use_one_sbal(els->req, els->req_count,
                               els->resp, els->resp_count)){
                 /* both request buffer and response buffer
@@ -1657,7 +1657,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 	fsf_req->qtcb->bottom.support.timeout = ZFCP_ELS_TIMEOUT;
 	fsf_req->data = (unsigned long) els;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 
 	zfcp_san_dbf_event_els_request(fsf_req);
 
@@ -1872,7 +1872,7 @@ zfcp_fsf_exchange_config_data(struct zfc
 		return retval;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1925,7 +1925,7 @@ zfcp_fsf_exchange_config_data_sync(struc
 		return retval;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2187,7 +2187,7 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 		return retval;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2249,7 +2249,7 @@ zfcp_fsf_exchange_port_data_sync(struct 
 	if (data)
 		fsf_req->data = (unsigned long) data;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2359,7 +2359,7 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2591,7 +2591,7 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2720,7 +2720,7 @@ zfcp_fsf_close_physical_port(struct zfcp
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2915,7 +2915,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -3230,7 +3230,7 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -3613,7 +3613,7 @@ zfcp_fsf_send_fcp_command_task_managemen
 	fsf_req->qtcb->bottom.io.fcp_cmnd_length =
 		sizeof (struct fcp_cmnd_iu) + sizeof (fcp_dl_t);
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -4238,7 +4238,7 @@ zfcp_fsf_control_file(struct zfcp_adapte
 		goto unlock_queue_lock;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 	sbale[0].flags |= direction;
 
 	bottom = &fsf_req->qtcb->bottom.support;
@@ -4590,14 +4590,14 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 	}
 	fsf_req->sbal_number = 1;
 	fsf_req->sbal_first = req_queue->free_index;
-	fsf_req->sbal_curr = req_queue->free_index;
+	fsf_req->sbal_last = req_queue->free_index;
         fsf_req->sbale_curr = 1;
 
 	if (likely(req_flags & ZFCP_REQ_AUTO_CLEANUP)) {
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
 
 	/* setup common SBALE fields */
 	sbale[0].addr = (void *) fsf_req->req_id;
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:33:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:35:14.000000000 +0200
@@ -186,7 +186,7 @@ void zfcp_hba_dbf_event_fsf_response(str
 	       fsf_status_qual, FSF_STATUS_QUALIFIER_SIZE);
 	response->fsf_req_status = fsf_req->status;
 	response->sbal_first = fsf_req->sbal_first;
-	response->sbal_curr = fsf_req->sbal_curr;
+	response->sbal_last = fsf_req->sbal_last;
 	response->pool = fsf_req->pool != NULL;
 	response->erp_action = (unsigned long)fsf_req->erp_action;
 
@@ -354,7 +354,7 @@ static void zfcp_hba_dbf_view_response(c
 		      FSF_STATUS_QUALIFIER_SIZE, 0, FSF_STATUS_QUALIFIER_SIZE);
 	zfcp_dbf_out(p, "fsf_req_status", "0x%08x", r->fsf_req_status);
 	zfcp_dbf_out(p, "sbal_first", "0x%02x", r->sbal_first);
-	zfcp_dbf_out(p, "sbal_curr", "0x%02x", r->sbal_curr);
+	zfcp_dbf_out(p, "sbal_last", "0x%02x", r->sbal_last);
 	zfcp_dbf_out(p, "pool", "0x%02x", r->pool);
 
 	switch (r->fsf_command) {

-- 
