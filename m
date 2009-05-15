From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/9] zfcp: Use correct req_id for traces
Date: Fri, 15 May 2009 13:18:14 +0200
Message-ID: <20090515112221.368308000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:38843 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=700-zfcp-trace-req_id.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The zfcp traces used the fsf_req address in place of the req_id.
Change this to save the correct req_id.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-05-15 12:56:08.000000000 +0200
@@ -163,7 +163,7 @@ void zfcp_hba_dbf_event_fsf_response(str
 	}
 
 	response->fsf_command = fsf_req->fsf_command;
-	response->fsf_reqid = (unsigned long)fsf_req;
+	response->fsf_reqid = fsf_req->req_id;
 	response->fsf_seqno = fsf_req->seq_no;
 	response->fsf_issued = fsf_req->issued;
 	response->fsf_prot_status = qtcb->prefix.prot_status;
@@ -737,7 +737,7 @@ void zfcp_san_dbf_event_ct_request(struc
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "octc", ZFCP_DBF_TAG_SIZE);
-	r->fsf_reqid = (unsigned long)fsf_req;
+	r->fsf_reqid = fsf_req->req_id;
 	r->fsf_seqno = fsf_req->seq_no;
 	r->s_id = fc_host_port_id(adapter->scsi_host);
 	r->d_id = wka_port->d_id;
@@ -773,7 +773,7 @@ void zfcp_san_dbf_event_ct_response(stru
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "rctc", ZFCP_DBF_TAG_SIZE);
-	r->fsf_reqid = (unsigned long)fsf_req;
+	r->fsf_reqid = fsf_req->req_id;
 	r->fsf_seqno = fsf_req->seq_no;
 	r->s_id = wka_port->d_id;
 	r->d_id = fc_host_port_id(adapter->scsi_host);
@@ -803,7 +803,7 @@ static void zfcp_san_dbf_event_els(const
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
-	rec->fsf_reqid = (unsigned long)fsf_req;
+	rec->fsf_reqid = fsf_req->req_id;
 	rec->fsf_seqno = fsf_req->seq_no;
 	rec->s_id = s_id;
 	rec->d_id = d_id;
@@ -965,7 +965,7 @@ static void zfcp_scsi_dbf_event(const ch
 						      ZFCP_DBF_SCSI_FCP_SNS_INFO);
 				}
 
-				rec->fsf_reqid = (unsigned long)fsf_req;
+				rec->fsf_reqid = fsf_req->req_id;
 				rec->fsf_seqno = fsf_req->seq_no;
 				rec->fsf_issued = fsf_req->issued;
 			}

