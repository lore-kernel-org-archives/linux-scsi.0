From: michaelc@cs.wisc.edu
Subject: [PATCH 23/23] iscsi_tcp: fix setting of r2t
Date: Tue,  4 Dec 2007 18:42:37 -0600
Message-ID: <11968153901001-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
 <11968153812001-git-send-email-michaelc@cs.wisc.edu>
 <1196815382808-git-send-email-michaelc@cs.wisc.edu>
 <11968153831244-git-send-email-michaelc@cs.wisc.edu>
 <11968153842186-git-send-email-michaelc@cs.wisc.edu>
 <11968153853971-git-send-email-michaelc@cs.wisc.edu>
 <1196815386656-git-send-email-michaelc@cs.wisc.edu>
 <11968153873372-git-send-email-michaelc@cs.wisc.edu>
 <11968153871693-git-send-email-michaelc@cs.wisc.edu>
 <11968153883385-git-send-email-michaelc@cs.wisc.edu>
 <1196815389832-git-send-email-michaelc@cs.wisc.edu>
 <11968153894148-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXLEAnP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:15 -0500
In-Reply-To: <11968153894148-git-send-email-michaelc@cs.wisc.edu>
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

