Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BE4C55179
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4174D246C5
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SdUu6nlN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbgJ1WKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730532AbgJ1WKg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 18:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603923034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DeXZH2CM/0JL0dV2e8UQ5dRCc4s7qSC0e1ICk1+6Htw=;
        b=SdUu6nlNKXHLM6639ZdXo64xKhqxa+dYKy9d3pF7SUn5jP/0BxMif9wmm4lo6qWK2OAKgZ
        uCxFMZTE64NhBIRMxMRFZLXisG7Xbofjsyg0aPQygl2RKT7oWMudRAFnL1ZrwpCB0szsgB
        qOf7JSQhJFMrXw809k4DfWDpnDZekdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-Pl_IbCEiNHyU9M9lSXt-Ug-1; Wed, 28 Oct 2020 13:09:53 -0400
X-MC-Unique: Pl_IbCEiNHyU9M9lSXt-Ug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F94F1016CE8;
        Wed, 28 Oct 2020 17:09:52 +0000 (UTC)
Received: from [10.35.206.112] (unknown [10.35.206.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42C812C31E;
        Wed, 28 Oct 2020 17:09:49 +0000 (UTC)
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
To:     Michael Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
Date:   Wed, 28 Oct 2020 18:09:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Dne 27. 10. 20 v 21:03 Michael Christie napsal(a):
> 
> 
>> On Oct 27, 2020, at 12:54 PM, Mike Christie <michael.christie@oracle.com> wrote:
>>
>> On 10/27/20 8:49 AM, Maurizio Lombardi wrote:
>>> Hello Mike,
>>>
>>> Dne 22. 10. 20 v 4:42 Mike Christie napsal(a):
>>>> If we free the cmd from the abort path, then for your conn stop plus abort race case, could we do:
>>>>
>>>> 1. thread1 runs iscsit_release_commands_from_conn and sets CMD_T_FABRIC_STOP.
>>>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It then returns from the aborted_task callout and we finish target_handle_abort and do:
>>>>
>>>> target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd
>>>>
>>>> The cmd is now freed.
>>>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs iscsit_free_cmd while accessing a command we just released.
>>>>
>>>>
>>>
>>> Thanks for the review!
>>>
>>> There are definitely some problems with task aborts and commands' refcounting *
>>> but this is a different bug than the one this patch is trying to solve (a race to list_del_init());
>>> unless you are saying that abort tasks should never be executed when the connection 
>>> is going down and we have to prevent such cases from happening at all.
>>
>> Yeah, I think if we prevent the race then we fix the refcount issue and your issue.
>> Here is a patch that is only compile tested:
>>
>> From 209709bcedd9a6ce6003e6bb86f3ebf547dca6af Mon Sep 17 00:00:00 2001
>> From: Mike Christie <michael.christie@oracle.com>
>> Date: Tue, 27 Oct 2020 12:30:53 -0500
>> Subject: [PATCH] iscsi target: fix cmd abort vs fabric stop race
>>
>> The abort and cmd stop paths can race where:
>>
>> 1. thread1 runs iscsit_release_commands_from_conn and sets
>> CMD_T_FABRIC_STOP.
>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It
>> then returns from the aborted_task callout and we finish
>> target_handle_abort and do:
>>
>> target_handle_abort -> transport_cmd_check_stop_to_fabric ->
>> lio_check_stop_free -> target_put_sess_cmd
>>
>> The cmd is now freed.
>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs
>> iscsit_free_cmd while accessing a command we just released.
>>
>> In __target_check_io_state we check for CMD_T_FABRIC_STOP and set the
>> CMD_T_ABORTED if the driver is not cleaning up the cmd because of
>> a session shutdown. However, iscsit_release_commands_from_conn only
>> sets the CMD_T_FABRIC_STOP and does not check to see if the abort path
>> has claimed completion ownership of the command.
>>
>> This adds a check in iscsit_release_commands_from_conn so only the
>> abort or fabric stop path cleanup the command.
>> ---
>> drivers/target/iscsi/iscsi_target.c | 13 +++++++++++--
>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index f77e5ee..85027d3 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -483,8 +483,7 @@ int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>> void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>> {
>> 	spin_lock_bh(&conn->cmd_lock);
>> -	if (!list_empty(&cmd->i_conn_node) &&
>> -	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
>> +	if (!list_empty(&cmd->i_conn_node))
>> 		list_del_init(&cmd->i_conn_node);
>> 	spin_unlock_bh(&conn->cmd_lock);
>>
>> @@ -4088,6 +4087,16 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>>
>> 		if (se_cmd->se_tfo != NULL) {
>> 			spin_lock_irq(&se_cmd->t_state_lock);
>> +			if (se_cmd->transport_state & CMD_T_ABORTED) {
>> +				/*
>> +				 * LIO's abort path owns the cleanup for this,
>> +				 * so put it back on the list and let
>> +				 * aborted_task handle it.
>> +				 */
>> +				list_add_tail(&cmd->i_conn_node,
>> +					      &conn->conn_cmd_list);
> 
> 
> That should have been a move from the tmp list back to the conn_cmd_list.

Nice, it looks simple and I will test it.
I am a bit worried there could be other possible race conditions.

Example: 

thread1: connection is going to be closed,
iscsit_release_commands_from_conn() finds a command that is about
to be aborted, re-adds it to conn_cmd_list and proceeds.
iscsit_close_connection() decreases the conn usage count and finally calls iscsit_free_conn(conn)
that destroys the conn structure.

thread2: iscsit_aborted_task() gets called and tries to lock the conn->cmd_lock spinlock, dereferencing
an invalid pointer.

Possible solutions that I can think of:

- Make iscsit_release_commands_from_conn() wait for the abort task to finish
or
- abort handler could hold a reference to the conn structure so that iscsit_close_connection()
will sleep when calling iscsit_check_conn_usage_count(conn) until abort finishes.


Maurizio

