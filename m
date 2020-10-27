Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD183C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 17:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CB92076D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 17:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tA8N2EL0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822938AbgJ0RyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 13:54:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51684 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1822935AbgJ0RyS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 13:54:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RHkFbn091817;
        Tue, 27 Oct 2020 17:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lYJoIo1EWbeKRgzTxgLXG4e63rBCd69ISfitGvJGRqE=;
 b=tA8N2EL0fKFQEB1AgcE4KoVcri95QuTWLNu+JQgoOAzb7l9TSsehl6Z2Ki3NGqqosd4i
 qvDdek5mk4rB3Neqjtc8pQDB+cYfiDdKirGKAl0I2xnS8i6QfniZpKD2I05BYgkpDxI4
 x0iUetuAUNNmTOr1Bxz+AXNC8u0Z0KvaqZNwKx9/DyRck4HvyHp6sZS/b6cumHpCycLP
 lgJm2G3/fnK8XA9dacFIQUbS/SqeVtA4+BUBVzhPWApb6qCksNvw8wqwW4f/ZNKE8X58
 +gbh5Wn9lWILk+nuvgEgZ/uRTTAbc4kC3Fa7j3JRoNTPcPuvbyIU08nydnTbi631lo2u xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saunm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 17:54:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RHoSkN077251;
        Tue, 27 Oct 2020 17:54:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwumpn2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 17:54:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RHsBkg030856;
        Tue, 27 Oct 2020 17:54:11 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 10:54:11 -0700
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
Date:   Tue, 27 Oct 2020 12:54:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/20 8:49 AM, Maurizio Lombardi wrote:
> Hello Mike,
> 
> Dne 22. 10. 20 v 4:42 Mike Christie napsal(a):
>> If we free the cmd from the abort path, then for your conn stop plus abort race case, could we do:
>>
>> 1. thread1 runs iscsit_release_commands_from_conn and sets CMD_T_FABRIC_STOP.
>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It then returns from the aborted_task callout and we finish target_handle_abort and do:
>>
>> target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd
>>
>> The cmd is now freed.
>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs iscsit_free_cmd while accessing a command we just released.
>>
>>
> 
> Thanks for the review!
> 
> There are definitely some problems with task aborts and commands' refcounting *
> but this is a different bug than the one this patch is trying to solve (a race to list_del_init());
> unless you are saying that abort tasks should never be executed when the connection 
> is going down and we have to prevent such cases from happening at all.

Yeah, I think if we prevent the race then we fix the refcount issue and your issue.
Here is a patch that is only compile tested:

From 209709bcedd9a6ce6003e6bb86f3ebf547dca6af Mon Sep 17 00:00:00 2001
From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 27 Oct 2020 12:30:53 -0500
Subject: [PATCH] iscsi target: fix cmd abort vs fabric stop race

The abort and cmd stop paths can race where:

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
---
 drivers/target/iscsi/iscsi_target.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f77e5ee..85027d3 100644
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
 
@@ -4088,6 +4087,16 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
+			if (se_cmd->transport_state & CMD_T_ABORTED) {
+				/*
+				 * LIO's abort path owns the cleanup for this,
+				 * so put it back on the list and let
+				 * aborted_task handle it.
+				 */
+				list_add_tail(&cmd->i_conn_node,
+					      &conn->conn_cmd_list);
+				continue;
+			}
 			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			spin_unlock_irq(&se_cmd->t_state_lock);
 		}
-- 
1.8.3.1

