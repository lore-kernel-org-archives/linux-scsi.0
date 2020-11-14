Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B747C4742C
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 01:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500982225D
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 01:46:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NpRNcpwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgKNBq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:46:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41734 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKNBq0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2020 20:46:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1e4G5145860;
        Sat, 14 Nov 2020 01:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=/2m2gO1LRsM80qE10O6GutROnzRvFFHi4jXaKj1ylkM=;
 b=NpRNcpwUD6983ogwRPuS0LhMBYV+57ocpOg7s0lCbgN4gzZBs9d7L3o/nidNokZIBxV7
 9Kf0NutI4kQGytos5vlKFZMmc9cfv7bz3VEcg37NRW9pxw8JbzS08blfqZyUT5Q3Cgvq
 kdZAGRmIMmOnVnnH0E5aUKm/IHlkdn+6xHb3uWl4PSHd1Ao0qmoC0QAnkRAJJBDB9Ode
 NA9pcn6KAQNn+bDID7BpjqvBmQeFdk3ZJhs0/48X2PRDwfq0wqVeIDRM51UdXm76J/5x
 7UEaFpM+CiLPQAjlAN7mdJSUH5s75gdI3cBusEGjRtw3+YmhPlvIVh0Li3D2imWnzk9p vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rag2g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 01:46:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1jPrh065709;
        Sat, 14 Nov 2020 01:46:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34t598sb9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 01:46:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AE1kNgq008263;
        Sat, 14 Nov 2020 01:46:23 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 17:46:23 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, mlombard@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH] iscsi target: fix cmd abort fabric stop race
Date:   Fri, 13 Nov 2020 19:46:18 -0600
Message-Id: <1605318378-9269-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=2 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=2 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140008
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Maurizio Lombardi <mlombard@redhat.com> found a race where the abort
and cmd stop paths can race as follows:

1. thread1 runs iscsit_release_commands_from_conn and sets
CMD_T_FABRIC_STOP.
2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It
then returns from the aborted_task callout and we finish
target_handle_abort and do:

target_handle_abort -> transport_cmd_check_stop_to_fabric ->
lio_check_stop_free -> target_put_sess_cmd

The cmd is now freed.
3. thread1 now finishes iscsit_release_commands_from_conn and runs
iscsit_free_cmd while accessing a command we just released.

In __target_check_io_state we check for CMD_T_FABRIC_STOP and set the
CMD_T_ABORTED if the driver is not cleaning up the cmd because of
a session shutdown. However, iscsit_release_commands_from_conn only
sets the CMD_T_FABRIC_STOP and does not check to see if the abort path
has claimed completion ownership of the command.

This adds a check in iscsit_release_commands_from_conn so only the
abort or fabric stop path cleanup the command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>

---
 drivers/target/iscsi/iscsi_target.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f77e5ee..518fac4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -483,8 +483,7 @@ int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	spin_lock_bh(&conn->cmd_lock);
-	if (!list_empty(&cmd->i_conn_node) &&
-	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
+	if (!list_empty(&cmd->i_conn_node))
 		list_del_init(&cmd->i_conn_node);
 	spin_unlock_bh(&conn->cmd_lock);
 
@@ -4083,12 +4082,22 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 	spin_lock_bh(&conn->cmd_lock);
 	list_splice_init(&conn->conn_cmd_list, &tmp_list);
 
-	list_for_each_entry(cmd, &tmp_list, i_conn_node) {
+	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_list, i_conn_node) {
 		struct se_cmd *se_cmd = &cmd->se_cmd;
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
+			if (se_cmd->transport_state & CMD_T_ABORTED) {
+				/*
+				 * LIO's abort path owns the cleanup for this,
+				 * so put it back on the list and let
+				 * aborted_task handle it.
+				 */
+				list_move_tail(&cmd->i_conn_node,
+					       &conn->conn_cmd_list);
+			} else {
+				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
+			}
 			spin_unlock_irq(&se_cmd->t_state_lock);
 		}
 	}
-- 
1.8.3.1

