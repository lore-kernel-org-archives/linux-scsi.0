From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/18] [PATCH] zfcp: Only increment req_id for successfully issued requests
Date: Mon, 02 Mar 2009 13:08:58 +0100
Message-ID: <20090302121002.679280000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:46181 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747AbZCBMKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:07 -0500
Content-Disposition: inline; filename=704-zfcp-req_id.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Only increment the req_id for successfully issued requests. This
avoids some confusion when debugging issued fsf requests.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:31.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:31.000000000 +0100
@@ -735,7 +735,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 
 	req->adapter = adapter;
 	req->fsf_command = fsf_cmd;
-	req->req_id = adapter->req_no++;
+	req->req_id = adapter->req_no;
 	req->sbal_number = 1;
 	req->sbal_first = req_q->first;
 	req->sbal_last = req_q->first;
@@ -798,6 +798,7 @@ static int zfcp_fsf_req_send(struct zfcp
 	/* Don't increase for unsolicited status */
 	if (req->qtcb)
 		adapter->fsf_req_seq_no++;
+	adapter->req_no++;
 
 	return 0;
 }

