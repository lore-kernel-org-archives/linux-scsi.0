From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/11] zfcp: Remove some sparse warnings
Date: Mon, 19 May 2008 12:17:40 +0200
Message-ID: <20080519101828.544246000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:35949 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYESKSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:31 -0400
Content-Disposition: inline; filename=sparse-warnings.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Remove some sparse warnings by telling sparse that zfcp_req_create
acquires the lock for the request queue.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_ext.h	2008-05-19 11:28:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-05-19 11:33:24.000000000 +0200
@@ -94,7 +94,8 @@ extern void zfcp_fsf_req_dismiss_all(str
 extern int  zfcp_fsf_status_read(struct zfcp_adapter *, int);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
 extern int zfcp_fsf_req_create(struct zfcp_adapter *, u32, int, mempool_t *,
-			       unsigned long *, struct zfcp_fsf_req **);
+			       unsigned long *, struct zfcp_fsf_req **)
+	__acquires(adapter->request_queue.queue_lock);
 extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,
 			    struct zfcp_erp_action *);
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);

-- 
