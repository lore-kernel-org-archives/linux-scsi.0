Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E6EC388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA01221F1
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nRGmEFAp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731919AbgKKCQV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:16:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50652 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731557AbgKKCQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:16:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2APlq079422;
        Wed, 11 Nov 2020 02:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bGWYUtPr2Sv/wI5N41OpHo8UaDR1g2RFnMfLs9jlBIg=;
 b=nRGmEFApAkT3VKA/vout4IX9hxaRl8Aa5tgusXL+pzSKtQqTkzYg9Qfc/+1lhbz4jTjI
 Qf3xEI4gjUI4hJ5Qt80fh5PrdLGNW1EvMuAwutmWePnRcoyW9XdNshozIfnXWzNOW2oG
 Ia/TDMW4dDr0zOPUjU4P8MqAiYmo3uK+myeMGLOoRJxd6Bpl5XPb8lwhdG+3TUkkgRTA
 3f/u91qv1xMj5QJJnROke7J95PHzGpR0ics4OEQW8un/6ZysPMWbDybA5WeKiKUxS+i4
 WohK/pw1XtRVJTvBpUVCVfzKmIQLw8vclGzxS7WSggk/k2iJQpDv/q2GMtr77Nqw2Of+ nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhkxudt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:16:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2BCXq153772;
        Wed, 11 Nov 2020 02:16:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55pcs7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:16:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2GFV5029855;
        Wed, 11 Nov 2020 02:16:15 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:16:14 -0800
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
To:     Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
Date:   Tue, 10 Nov 2020 20:16:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=2 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110007
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/20 12:09 PM, Maurizio Lombardi wrote:
> 
> 
> Dne 27. 10. 20 v 21:03 Michael Christie napsal(a):
>>
>>
>>> On Oct 27, 2020, at 12:54 PM, Mike Christie <michael.christie@oracle.com> wrote:
>>>
>>> On 10/27/20 8:49 AM, Maurizio Lombardi wrote:
>>>> Hello Mike,
>>>>
>>>> Dne 22. 10. 20 v 4:42 Mike Christie napsal(a):
>>>>> If we free the cmd from the abort path, then for your conn stop plus abort race case, could we do:
>>>>>
>>>>> 1. thread1 runs iscsit_release_commands_from_conn and sets CMD_T_FABRIC_STOP.
>>>>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It then returns from the aborted_task callout and we finish target_handle_abort and do:
>>>>>
>>>>> target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd
>>>>>
>>>>> The cmd is now freed.
>>>>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs iscsit_free_cmd while accessing a command we just released.
>>>>>
>>>>>
>>>>
>>>> Thanks for the review!
>>>>
>>>> There are definitely some problems with task aborts and commands' refcounting *
>>>> but this is a different bug than the one this patch is trying to solve (a race to list_del_init());
>>>> unless you are saying that abort tasks should never be executed when the connection
>>>> is going down and we have to prevent such cases from happening at all.
>>>
>>> Yeah, I think if we prevent the race then we fix the refcount issue and your issue.
>>> Here is a patch that is only compile tested:
>>>
>>>  From 209709bcedd9a6ce6003e6bb86f3ebf547dca6af Mon Sep 17 00:00:00 2001
>>> From: Mike Christie <michael.christie@oracle.com>
>>> Date: Tue, 27 Oct 2020 12:30:53 -0500
>>> Subject: [PATCH] iscsi target: fix cmd abort vs fabric stop race
>>>
>>> The abort and cmd stop paths can race where:
>>>
>>> 1. thread1 runs iscsit_release_commands_from_conn and sets
>>> CMD_T_FABRIC_STOP.
>>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It
>>> then returns from the aborted_task callout and we finish
>>> target_handle_abort and do:
>>>
>>> target_handle_abort -> transport_cmd_check_stop_to_fabric ->
>>> lio_check_stop_free -> target_put_sess_cmd
>>>
>>> The cmd is now freed.
>>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs
>>> iscsit_free_cmd while accessing a command we just released.
>>>
>>> In __target_check_io_state we check for CMD_T_FABRIC_STOP and set the
>>> CMD_T_ABORTED if the driver is not cleaning up the cmd because of
>>> a session shutdown. However, iscsit_release_commands_from_conn only
>>> sets the CMD_T_FABRIC_STOP and does not check to see if the abort path
>>> has claimed completion ownership of the command.
>>>
>>> This adds a check in iscsit_release_commands_from_conn so only the
>>> abort or fabric stop path cleanup the command.
>>> ---
>>> drivers/target/iscsi/iscsi_target.c | 13 +++++++++++--
>>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>> index f77e5ee..85027d3 100644
>>> --- a/drivers/target/iscsi/iscsi_target.c
>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>> @@ -483,8 +483,7 @@ int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>>> void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>>> {
>>> 	spin_lock_bh(&conn->cmd_lock);
>>> -	if (!list_empty(&cmd->i_conn_node) &&
>>> -	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
>>> +	if (!list_empty(&cmd->i_conn_node))
>>> 		list_del_init(&cmd->i_conn_node);
>>> 	spin_unlock_bh(&conn->cmd_lock);
>>>
>>> @@ -4088,6 +4087,16 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>>>
>>> 		if (se_cmd->se_tfo != NULL) {
>>> 			spin_lock_irq(&se_cmd->t_state_lock);
>>> +			if (se_cmd->transport_state & CMD_T_ABORTED) {
>>> +				/*
>>> +				 * LIO's abort path owns the cleanup for this,
>>> +				 * so put it back on the list and let
>>> +				 * aborted_task handle it.
>>> +				 */
>>> +				list_add_tail(&cmd->i_conn_node,
>>> +					      &conn->conn_cmd_list);
>>
>>
>> That should have been a move from the tmp list back to the conn_cmd_list.
> 
> Nice, it looks simple and I will test it.
> I am a bit worried there could be other possible race conditions.
> 
> Example:
> 
> thread1: connection is going to be closed,
> iscsit_release_commands_from_conn() finds a command that is about
> to be aborted, re-adds it to conn_cmd_list and proceeds.
> iscsit_close_connection() decreases the conn usage count and finally calls iscsit_free_conn(conn)
> that destroys the conn structure.
> 
> thread2: iscsit_aborted_task() gets called and tries to lock the conn->cmd_lock spinlock, dereferencing
> an invalid pointer.

Hey, I tested this out and I do not think this will happen. We will get 
stuck waiting on the TMF completion for the affected cmd/cmds.

In conn_cmd_list we would have [CMD1 -> ABORT TMF]. Those cmds get moved 
to the tmp list. It might happen where CMD1's CMD_T_ABORTED bit is set, 
and iscsit_release_commands_from_conn will would put it back onto the 
conn_cmd_list. But then it will see the ABORT on the list. We will then 
wait on the ABORT in:

iscsit_release_commands_from_conn -> iscsit_free_cmd -> 
transport_generic_free_cmd.

The abort at this time would be waiting on CMD1 in 
target_put_cmd_and_wait in target_core_tmr.c. Eventually CMD1 completes, 
aborted_task is run and the cmd is released. target_release_cmd_kref 
will then do complete on abort_compl. The abort will then wake from 
target_put_cmd_and_wait and will complete. We will then return from 
transport_generic_free_cmd for the abort.

A LUN RESET should work similarly but we would be waiting on the cmds 
and aborts and then the LUN RESET would complete.
