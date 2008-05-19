From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/11] zfcp: Rename sbal_last.
Date: Mon, 19 May 2008 12:17:42 +0200
Message-ID: <20080519101830.223670000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:25087 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYESKTG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:19:06 -0400
Content-Disposition: inline; filename=zfcp_rename_sbal_last.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

sbal_last is confusing, as it is not the last one actually used,
but just a limit. sbal_limit is a better name.

Signed-off-by: Martin Peschke <mp3@de.ibm.com> 
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h  |    2 +-
 drivers/s390/scsi/zfcp_qdio.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:28:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:34:36.000000000 +0200
@@ -851,7 +851,7 @@ struct zfcp_fsf_req {
 	struct zfcp_adapter    *adapter;       /* adapter request belongs to */
 	u8		       sbal_number;    /* nr of SBALs free for use */
 	u8		       sbal_first;     /* first SBAL for this request */
-	u8		       sbal_last;      /* last possible SBAL for
+	u8		       sbal_limit;      /* last possible SBAL for
 						  this reuest */
 	u8		       sbal_curr;      /* current SBAL during creation
 						  of request */
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-05-19 11:34:36.000000000 +0200
@@ -432,9 +432,9 @@ zfcp_qdio_sbal_limit(struct zfcp_fsf_req
 {
 	int count = atomic_read(&fsf_req->adapter->request_queue.free_count);
 	count = min(count, max_sbals);
-	fsf_req->sbal_last  = fsf_req->sbal_first;
-	fsf_req->sbal_last += (count - 1);
-	fsf_req->sbal_last %= QDIO_MAX_BUFFERS_PER_Q;
+	fsf_req->sbal_limit  = fsf_req->sbal_first;
+	fsf_req->sbal_limit += (count - 1);
+	fsf_req->sbal_limit %= QDIO_MAX_BUFFERS_PER_Q;
 }
 
 /**
@@ -455,7 +455,7 @@ zfcp_qdio_sbal_chain(struct zfcp_fsf_req
 	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	/* don't exceed last allowed SBAL */
-	if (fsf_req->sbal_curr == fsf_req->sbal_last)
+	if (fsf_req->sbal_curr == fsf_req->sbal_limit)
 		return NULL;
 
 	/* set chaining flag in first SBALE of current SBAL */

-- 
