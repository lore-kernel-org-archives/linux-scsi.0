From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] libiscsi: update nop stats
Date: Thu, 14 Jun 2012 23:15:46 -0500
Message-ID: <1339733747-14731-3-git-send-email-michaelc@cs.wisc.edu>
References: <1339733747-14731-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2FOFFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2012 01:05:40 -0400
In-Reply-To: <1339733747-14731-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The nop tx/rx counters were not getting updated.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    7 ++++++-
 include/scsi/libiscsi.h |    2 ++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5b4adc4..d134b40 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -978,6 +978,7 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 		conn->ping_task = task;
 		conn->last_ping = jiffies;
 	}
+	conn->noptx_pdus++;
 
 	return 0;
 }
@@ -1146,6 +1147,8 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		switch(opcode) {
 		case ISCSI_OP_NOOP_IN:
+			conn->noprx_pdus++;
+
 			if (datalen) {
 				rc = ISCSI_ERR_PROTO;
 				break;
@@ -1184,11 +1187,13 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		 * LLD handles R2Ts if they need to.
 		 */
 		return 0;
+	case ISCSI_OP_NOOP_IN:
+		conn->noprx_pdus++;
+		/* fall through */
 	case ISCSI_OP_LOGOUT_RSP:
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
-	case ISCSI_OP_NOOP_IN:
 		task = iscsi_itt_to_task(conn, hdr->itt);
 		if (!task)
 			return ISCSI_ERR_BAD_ITT;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 6e33386..b9ffcc5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -221,6 +221,8 @@ struct iscsi_conn {
 	uint32_t		scsirsp_pdus_cnt;
 	uint32_t		datain_pdus_cnt;
 	uint32_t		r2t_pdus_cnt;
+	uint32_t		noptx_pdus;
+	uint32_t		noprx_pdus;
 	uint32_t		tmfcmd_pdus_cnt;
 	int32_t			tmfrsp_pdus_cnt;
 
-- 
1.7.7.6

