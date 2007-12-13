From: michaelc@cs.wisc.edu
Subject: [PATCH 23/24] iscsi_tcp: fix setting of r2t
Date: Thu, 13 Dec 2007 12:43:42 -0600
Message-ID: <11975714563205-git-send-email-michaelc@cs.wisc.edu>
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
 <1197571448857-git-send-email-michaelc@cs.wisc.edu>
 <11975714503562-git-send-email-michaelc@cs.wisc.edu>
 <1197571451503-git-send-email-michaelc@cs.wisc.edu>
 <1197571453148-git-send-email-michaelc@cs.wisc.edu>
 <11975714543562-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760149AbXLMSoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:20 -0500
In-Reply-To: <11975714543562-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we negotiate for X r2ts we have to use only X r2ts. We cannot
round up (we could send less though). It is ok to fail if it
is not something the driver can handle, so this patch just does
that.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index edebdf2..e5be5fd 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1774,12 +1774,12 @@ iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		sscanf(buf, "%d", &value);
-		if (session->max_r2t == roundup_pow_of_two(value))
+		if (value <= 0 || !is_power_of_2(value))
+			return -EINVAL;
+		if (session->max_r2t == value)
 			break;
 		iscsi_r2tpool_free(session);
 		iscsi_set_param(cls_conn, param, buf, buflen);
-		if (session->max_r2t & (session->max_r2t - 1))
-			session->max_r2t = roundup_pow_of_two(session->max_r2t);
 		if (iscsi_r2tpool_alloc(session))
 			return -ENOMEM;
 		break;
-- 
1.5.1.2

