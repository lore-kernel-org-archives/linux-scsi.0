From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] libiscsi: fix aen support
Date: Mon, 16 Oct 2006 18:09:41 -0400
Message-ID: <1161036586795-git-send-email-michaelc@cs.wisc.edu>
References: <11610365823995-git-send-email-michaelc@cs.wisc.edu> <1161036583544-git-send-email-michaelc@cs.wisc.edu> <1161036584778-git-send-email-michaelc@cs.wisc.edu> <1161036585226-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:63425 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1422900AbWJPXJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:09:39 -0400
In-Reply-To: <1161036585226-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We have been dropping the pdu. We should just send it to userspace
and let it handle it.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e3a2ec2..f5a9560 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -481,8 +481,8 @@ int __iscsi_complete_pdu(struct iscsi_co
 			break;
 		case ISCSI_OP_ASYNC_EVENT:
 			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
-			/* we need sth like iscsi_async_event_rsp() */
-			rc = ISCSI_ERR_BAD_OPCODE;
+			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
+				rc = ISCSI_ERR_CONN_FAILED;
 			break;
 		default:
 			rc = ISCSI_ERR_BAD_OPCODE;
-- 
1.4.1

