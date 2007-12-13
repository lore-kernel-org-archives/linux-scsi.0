From: michaelc@cs.wisc.edu
Subject: [PATCH 17/24] iscsi_tcp: stop leaking r2t_info's when the incoming R2T is bad
Date: Thu, 13 Dec 2007 12:43:36 -0600
Message-ID: <1197571447387-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
 <119757143673-git-send-email-michaelc@cs.wisc.edu>
 <11975714363904-git-send-email-michaelc@cs.wisc.edu>
 <11975714372848-git-send-email-michaelc@cs.wisc.edu>
 <11975714382641-git-send-email-michaelc@cs.wisc.edu>
 <11975714404116-git-send-email-michaelc@cs.wisc.edu>
 <11975714413336-git-send-email-michaelc@cs.wisc.edu>
 <1197571442630-git-send-email-michaelc@cs.wisc.edu>
 <11975714441250-git-send-email-michaelc@cs.wisc.edu>
 <1197571445685-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628AbXLMSoj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:39 -0500
In-Reply-To: <1197571445685-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Olaf Kirch <olaf.kirch@oracle.com>

From: Mike Christie <michaelc@cs.wisc.edu>

from olaf.kirch@oracle.com:

iscsi_r2t_rsp checks the incoming R2T for sanity, and if it
thinks it's fishy, it will drop it silently. In this case, we
leaked an r2t_info object. If we do this often enough, we run
into a BUG_ON some time later.

Removed r2t wrappers and update patch by Mike Christie

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7212fe9..ecba606 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -658,6 +658,8 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	r2t->data_length = be32_to_cpu(rhdr->data_length);
 	if (r2t->data_length == 0) {
 		printk(KERN_ERR "iscsi_tcp: invalid R2T with zero data len\n");
+		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*));
 		spin_unlock(&session->lock);
 		return ISCSI_ERR_DATALEN;
 	}
@@ -669,10 +671,12 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
 	if (r2t->data_offset + r2t->data_length > scsi_bufflen(ctask->sc)) {
-		spin_unlock(&session->lock);
 		printk(KERN_ERR "iscsi_tcp: invalid R2T with data len %u at "
 		       "offset %u and total length %d\n", r2t->data_length,
 		       r2t->data_offset, scsi_bufflen(ctask->sc));
+		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*));
+		spin_unlock(&session->lock);
 		return ISCSI_ERR_DATALEN;
 	}
 
-- 
1.5.1.2

