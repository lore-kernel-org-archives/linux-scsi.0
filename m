From: michaelc@cs.wisc.edu
Subject: [PATCH 18/24] iscsi_tcp: drop session when itt does not match any command
Date: Thu, 13 Dec 2007 12:43:37 -0600
Message-ID: <1197571448857-git-send-email-michaelc@cs.wisc.edu>
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
 <1197571447387-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759538AbXLMSoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:12 -0500
In-Reply-To: <1197571447387-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

A target should never send us a itt that does not match a running
task. If it does we do not really know what is coming down after the header,
unless we evaluate the hdr and do some guessing sometimes. However,
even if we know what is coming we probably do not have buffers for it or we
cannot respond (if it is a r2t for example), so just drop the session.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ecba606..65df908 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -755,11 +755,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	/* verify itt (itt encoding: age+cid+itt) */
 	rc = iscsi_verify_itt(conn, hdr, &itt);
-	if (rc == ISCSI_ERR_NO_SCSI_CMD) {
-		/* XXX: what does this do? */
-		tcp_conn->in.datalen = 0; /* force drop */
-		return 0;
-	} else if (rc)
+	if (rc)
 		return rc;
 
 	debug_tcp("opcode 0x%x ahslen %d datalen %d\n",
-- 
1.5.1.2

