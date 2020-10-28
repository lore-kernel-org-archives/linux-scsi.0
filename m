Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66409C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 00:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061D1207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 00:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OfDBBkFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgJ2ASa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 20:18:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgJ2AS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2020 20:18:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SKSjD2142392;
        Wed, 28 Oct 2020 20:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7Koa9KoNhw1+mgKAkllxlvLAFVpJsrlEObMc3RhpvY4=;
 b=OfDBBkFmD0jSRsg5gnEwZxPvnSRMeFDRP2nzWWkIDafR1ceP4+4ftYBZ8USwwrYQPovB
 EKOB4tRbCUUCKpkkBpUBsnNwSvofldKfRQOhP3pyBzi+iIrfBjkuswumJgi0vylcJVNE
 fUzWagyLFjzjNRvtLWVmlsZP4f9vjHLOur4sndEsFb+n5YY5yjqnoT/X5R0RCFoE8lwO
 cG9epv7T09+FSTndgMWnRVybu1gEYOd0aN4FUVVgW6+cpJrue67ApuwEN8TpIBD5q+qb
 SDxu7bVukW7gw6q2WeTJMJt5hxbIzyu0/9JX/sn/Pq2s6WLV68OnSh+3Of9zDeTKC/TA 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm479cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Oct 2020 20:38:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SKUSCF040890;
        Wed, 28 Oct 2020 20:38:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1seq5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 20:37:59 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09SKbvur012373;
        Wed, 28 Oct 2020 20:37:57 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 13:37:56 -0700
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
Message-ID: <d7107857-ef7a-3c88-8146-a5e7abce5ce6@oracle.com>
Date:   Wed, 28 Oct 2020 15:37:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280127
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

Nice catch. You are right.

> 
> Possible solutions that I can think of:
> 
> - Make iscsit_release_commands_from_conn() wait for the abort task to finish

Yeah you could set a completion in there then have aborted_task do the 
complete() call maybe?

There is also the transport_cmd_check_stop_to_fabric 
t_transport_stop_comp completion and transport_wait_for_tasks pairing 
that seems close to what we want. I think we would have to change it to 
make it work for this case. Oh yeah, that is more of a brain stroming 
guess than a review type of comment :)


> or
> - abort handler could hold a reference to the conn structure so that iscsit_close_connection()
> will sleep when calling iscsit_check_conn_usage_count(conn) until abort finishes.
> 

