From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/15] zfcp: Avoid referencing freed memory in req send
Date: Fri, 17 Apr 2009 15:08:01 +0200
Message-ID: <20090417131121.958042000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:52929 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760913AbZDQNMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:12:13 -0400
Content-Disposition: inline; filename=700-zfcp-reference-after-free.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin@linux.vnet.ibm.com>

Avoid referencing a fsf request after sending it in fcp_fsf_req_send,
it might have already completed and deallocated.

Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:22.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:25.000000000 +0200
@@ -766,8 +766,9 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	unsigned long flags;
-	int idx;
+	unsigned long	     flags;
+	int		     idx;
+	int		     with_qtcb = (req->qtcb != NULL);
 
 	/* put allocated FSF request into hash table */
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
@@ -789,7 +790,7 @@ static int zfcp_fsf_req_send(struct zfcp
 	}
 
 	/* Don't increase for unsolicited status */
-	if (req->qtcb)
+	if (with_qtcb)
 		adapter->fsf_req_seq_no++;
 	adapter->req_no++;
 

