From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/11] zfcp: Remove field sbal_last from trace record.
Date: Mon, 19 May 2008 12:17:41 +0200
Message-ID: <20080519101829.463099000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:54340 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYESKSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:32 -0400
Content-Disposition: inline; filename=zfcp_dbf_remove_sbal_last.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This field is not needed, because it designates an index with a fix offset
from sbal_first. It's name is confusing anyway.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |    2 --
 drivers/s390/scsi/zfcp_dbf.h |    1 -
 2 files changed, 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:28:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:33:54.000000000 +0200
@@ -187,7 +187,6 @@ void zfcp_hba_dbf_event_fsf_response(str
 	response->fsf_req_status = fsf_req->status;
 	response->sbal_first = fsf_req->sbal_first;
 	response->sbal_curr = fsf_req->sbal_curr;
-	response->sbal_last = fsf_req->sbal_last;
 	response->pool = fsf_req->pool != NULL;
 	response->erp_action = (unsigned long)fsf_req->erp_action;
 
@@ -356,7 +355,6 @@ static void zfcp_hba_dbf_view_response(c
 	zfcp_dbf_out(p, "fsf_req_status", "0x%08x", r->fsf_req_status);
 	zfcp_dbf_out(p, "sbal_first", "0x%02x", r->sbal_first);
 	zfcp_dbf_out(p, "sbal_curr", "0x%02x", r->sbal_curr);
-	zfcp_dbf_out(p, "sbal_last", "0x%02x", r->sbal_last);
 	zfcp_dbf_out(p, "pool", "0x%02x", r->pool);
 
 	switch (r->fsf_command) {
--- a/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:33:54.000000000 +0200
@@ -98,7 +98,6 @@ struct zfcp_hba_dbf_record_response {
 	u32 fsf_req_status;
 	u8 sbal_first;
 	u8 sbal_curr;
-	u8 sbal_last;
 	u8 pool;
 	u64 erp_action;
 	union {

-- 
