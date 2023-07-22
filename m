Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BFDEB64DC
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jul 2023 15:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjGVP1Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jul 2023 11:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjGVP1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2023 11:27:23 -0400
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DBD2715;
        Sat, 22 Jul 2023 08:27:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 02B57C0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690039640; bh=+ULBQ2jumOvl9MkTs5AMHFnH5HiSB89dUHToVqz0vjU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=zb+sBS/QxtvhvGyzRRFS4alchLKG0yc8OWBJVKIc8JGgFWM6x9t6U1oJ7iywbYwbj
         ga6xQ8eVw8miqtImxYuVk4xF0m6dUiNQiBw3vad/ZNBR3elmwegE36TXDnkuRF5nk3
         INmOHFEdX1dLJjmcdmM86P58N7DLKQEZ+ykcs5IL5h8alcLbVWNBfQLycYmWsF8ctJ
         GWzbQxoTIeHb3KplSsHvqMuMik4180Otz+xCtD0UvPBRs83o5IiDLdOqgJO2evpMxS
         HF3NSLSWgZqyYQP2TFr8TChsU40BqROW6URqgTawg3qF5nSuD9eq1OH7qVlYu36B6R
         k6leaeCYlfUsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690039640; bh=+ULBQ2jumOvl9MkTs5AMHFnH5HiSB89dUHToVqz0vjU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=eSSpgWtSjZ7qS7asF2Cxz8UyjnuFgtTGiQ+YPl2jsbAkThuvmU+5df+JEmECYMC5o
         k3stlhzAQtt8MqmoE3+BII4sEgZdMs9sIbxljyL4mv4dUgHLato458AzjlVEpRwZX8
         PWJEVluUBD5PT6b0T+5GG7zF6/NhtiBc62s/bReJyXBRIR1fbEiX3UAHKzY3qQDKCk
         upyr6+rZJqCnMpTzM4rOOmiYepwXuZqQYh3Q7xeOOvamWfebFz3ewqyqEJCqMMjsjD
         ddz5EYJUBDhBwbPdKaQKGs6Eh2DUnTTEPrVVTznB/s3Mo6LnAbghJxA7PJx47xwftn
         n0FCihJVhW+Fg==
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH 1/2] scsi: target: iscsi: Fix buffer overflow in lio_target_nacl_info_show
Date:   Sat, 22 Jul 2023 18:26:37 +0300
Message-ID: <20230722152657.168859-2-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230722152657.168859-1-k.shelekhin@yadro.com>
References: <20230722152657.168859-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function lio_target_nacl_info_show uses sprintf in a loop to print
details for every iSCSI connection in a session without checking for the
buffer length. With enough iSCSI connections it's possible to overflow
the buffer provided by configfs and corrupt the memory.

This patch replaces sprintf with sysfs_emit_at that checks for buffer
boundries itself.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 54 ++++++++++----------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5d0f51822414..c142a67dc7cc 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -533,102 +533,102 @@ static ssize_t lio_target_nacl_info_show(struct config_item *item, char *page)
 	spin_lock_bh(&se_nacl->nacl_sess_lock);
 	se_sess = se_nacl->nacl_sess;
 	if (!se_sess) {
-		rb += sprintf(page+rb, "No active iSCSI Session for Initiator"
+		rb += sysfs_emit_at(page, rb, "No active iSCSI Session for Initiator"
 			" Endpoint: %s\n", se_nacl->initiatorname);
 	} else {
 		sess = se_sess->fabric_sess_ptr;
 
-		rb += sprintf(page+rb, "InitiatorName: %s\n",
+		rb += sysfs_emit_at(page, rb, "InitiatorName: %s\n",
 			sess->sess_ops->InitiatorName);
-		rb += sprintf(page+rb, "InitiatorAlias: %s\n",
+		rb += sysfs_emit_at(page, rb, "InitiatorAlias: %s\n",
 			sess->sess_ops->InitiatorAlias);
 
-		rb += sprintf(page+rb,
+		rb += sysfs_emit_at(page, rb,
 			      "LIO Session ID: %u   ISID: 0x%6ph  TSIH: %hu  ",
 			      sess->sid, sess->isid, sess->tsih);
-		rb += sprintf(page+rb, "SessionType: %s\n",
+		rb += sysfs_emit_at(page, rb, "SessionType: %s\n",
 				(sess->sess_ops->SessionType) ?
 				"Discovery" : "Normal");
-		rb += sprintf(page+rb, "Session State: ");
+		rb += sysfs_emit_at(page, rb, "Session State: ");
 		switch (sess->session_state) {
 		case TARG_SESS_STATE_FREE:
-			rb += sprintf(page+rb, "TARG_SESS_FREE\n");
+			rb += sysfs_emit_at(page, rb, "TARG_SESS_FREE\n");
 			break;
 		case TARG_SESS_STATE_ACTIVE:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_ACTIVE\n");
+			rb += sysfs_emit_at(page, rb, "TARG_SESS_STATE_ACTIVE\n");
 			break;
 		case TARG_SESS_STATE_LOGGED_IN:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_LOGGED_IN\n");
+			rb += sysfs_emit_at(page, rb, "TARG_SESS_STATE_LOGGED_IN\n");
 			break;
 		case TARG_SESS_STATE_FAILED:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_FAILED\n");
+			rb += sysfs_emit_at(page, rb, "TARG_SESS_STATE_FAILED\n");
 			break;
 		case TARG_SESS_STATE_IN_CONTINUE:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_IN_CONTINUE\n");
+			rb += sysfs_emit_at(page, rb, "TARG_SESS_STATE_IN_CONTINUE\n");
 			break;
 		default:
-			rb += sprintf(page+rb, "ERROR: Unknown Session"
+			rb += sysfs_emit_at(page, rb, "ERROR: Unknown Session"
 					" State!\n");
 			break;
 		}
 
-		rb += sprintf(page+rb, "---------------------[iSCSI Session"
+		rb += sysfs_emit_at(page, rb, "---------------------[iSCSI Session"
 				" Values]-----------------------\n");
-		rb += sprintf(page+rb, "  CmdSN/WR  :  CmdSN/WC  :  ExpCmdSN"
+		rb += sysfs_emit_at(page, rb, "  CmdSN/WR  :  CmdSN/WC  :  ExpCmdSN"
 				"  :  MaxCmdSN  :     ITT    :     TTT\n");
 		max_cmd_sn = (u32) atomic_read(&sess->max_cmd_sn);
-		rb += sprintf(page+rb, " 0x%08x   0x%08x   0x%08x   0x%08x"
+		rb += sysfs_emit_at(page, rb, " 0x%08x   0x%08x   0x%08x   0x%08x"
 				"   0x%08x   0x%08x\n",
 			sess->cmdsn_window,
 			(max_cmd_sn - sess->exp_cmd_sn) + 1,
 			sess->exp_cmd_sn, max_cmd_sn,
 			sess->init_task_tag, sess->targ_xfer_tag);
-		rb += sprintf(page+rb, "----------------------[iSCSI"
+		rb += sysfs_emit_at(page, rb, "----------------------[iSCSI"
 				" Connections]-------------------------\n");
 
 		spin_lock(&sess->conn_lock);
 		list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
-			rb += sprintf(page+rb, "CID: %hu  Connection"
+			rb += sysfs_emit_at(page, rb, "CID: %hu  Connection"
 					" State: ", conn->cid);
 			switch (conn->conn_state) {
 			case TARG_CONN_STATE_FREE:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"TARG_CONN_STATE_FREE\n");
 				break;
 			case TARG_CONN_STATE_XPT_UP:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"TARG_CONN_STATE_XPT_UP\n");
 				break;
 			case TARG_CONN_STATE_IN_LOGIN:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"TARG_CONN_STATE_IN_LOGIN\n");
 				break;
 			case TARG_CONN_STATE_LOGGED_IN:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"TARG_CONN_STATE_LOGGED_IN\n");
 				break;
 			case TARG_CONN_STATE_IN_LOGOUT:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"TARG_CONN_STATE_IN_LOGOUT\n");
 				break;
 			case TARG_CONN_STATE_LOGOUT_REQUESTED:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"TARG_CONN_STATE_LOGOUT_REQUESTED\n");
 				break;
 			case TARG_CONN_STATE_CLEANUP_WAIT:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"TARG_CONN_STATE_CLEANUP_WAIT\n");
 				break;
 			default:
-				rb += sprintf(page+rb,
+				rb += sysfs_emit_at(page, rb,
 					"ERROR: Unknown Connection State!\n");
 				break;
 			}
 
-			rb += sprintf(page+rb, "   Address %pISc %s", &conn->login_sockaddr,
+			rb += sysfs_emit_at(page, rb, "   Address %pISc %s", &conn->login_sockaddr,
 				(conn->network_transport == ISCSI_TCP) ?
 				"TCP" : "SCTP");
-			rb += sprintf(page+rb, "  StatSN: 0x%08x\n",
+			rb += sysfs_emit_at(page, rb, "  StatSN: 0x%08x\n",
 				conn->stat_sn);
 		}
 		spin_unlock(&sess->conn_lock);
-- 
2.41.0

