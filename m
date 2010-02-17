From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/11] zfcp: Remove duplicate assignment of req_seq_no
Date: Wed, 17 Feb 2010 11:18:55 +0100
Message-ID: <20100217102018.802311000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49691 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0BQKUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:23 -0500
Content-Disposition: inline; filename=707-zfcp-dup-assignment.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

zfcp_fsf_req_create assigns the same value twice to req_seq_no.
Remove one assignment and move the req_id and seq_no assignments to
one place.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:31.000000000 +0100
@@ -741,6 +741,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 			return ERR_PTR(-ENOMEM);
 		}
 
+		req->seq_no = adapter->fsf_req_seq_no;
 		req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
 		req->qtcb->prefix.req_id = req->req_id;
 		req->qtcb->prefix.ulp_info = 26;
@@ -748,8 +749,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 		req->qtcb->prefix.qtcb_version = FSF_QTCB_CURRENT_VERSION;
 		req->qtcb->header.req_handle = req->req_id;
 		req->qtcb->header.fsf_command = req->fsf_command;
-		req->seq_no = adapter->fsf_req_seq_no;
-		req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
 		sbale[1].addr = (void *) req->qtcb;
 		sbale[1].length = sizeof(struct fsf_qtcb);
 	}

