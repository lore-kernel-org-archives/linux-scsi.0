From: michaelc@cs.wisc.edu
Subject: [PATCH 3/12] attempt to complete r2t with data len greater than max burst
Date: Thu, 31 Aug 2006 18:09:26 -0400
Message-ID: <11570621791237-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:25478 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964810AbWHaXJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:23 -0400
In-Reply-To: <11570621781978-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

A couple targets like string bean and MDS, send r2ts with
a data len greater than the max burst we agreed to. We
were being strict in our enforcing of the iscsi rfc in that
code path, but there is no driver limitation that prevents
us from fullfilling the request. To allow those targets
to work we will ignore the max_burst length and send as
much data as the target asks for assuming it has consciously
decided to override its max burst length.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e07eced..668f18c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -358,8 +358,11 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 	int r2tsn = be32_to_cpu(rhdr->r2tsn);
 	int rc;
 
-	if (tcp_conn->in.datalen)
+	if (tcp_conn->in.datalen) {
+		printk(KERN_ERR "iscsi_tcp: invalid R2t with datalen %d\n",
+		       tcp_conn->in.datalen);
 		return ISCSI_ERR_DATALEN;
+	}
 
 	if (tcp_ctask->exp_r2tsn && tcp_ctask->exp_r2tsn != r2tsn)
 		return ISCSI_ERR_R2TSN;
@@ -385,15 +388,23 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 
 	r2t->exp_statsn = rhdr->statsn;
 	r2t->data_length = be32_to_cpu(rhdr->data_length);
-	if (r2t->data_length == 0 ||
-	    r2t->data_length > session->max_burst) {
+	if (r2t->data_length == 0) {
+		printk(KERN_ERR "iscsi_tcp: invalid R2T with zero data len\n");
 		spin_unlock(&session->lock);
 		return ISCSI_ERR_DATALEN;
 	}
 
+	if (r2t->data_length > session->max_burst)
+		debug_scsi("invalid R2T with data len %u and max burst %u."
+			   "Attempting to execute request.\n",
+			    r2t->data_length, session->max_burst);
+
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
 	if (r2t->data_offset + r2t->data_length > ctask->total_length) {
 		spin_unlock(&session->lock);
+		printk(KERN_ERR "iscsi_tcp: invalid R2T with data len %u at "
+		       "offset %u and total length %d\n", r2t->data_length,
+		       r2t->data_offset, ctask->total_length);
 		return ISCSI_ERR_DATALEN;
 	}
 
-- 
1.4.1.1

