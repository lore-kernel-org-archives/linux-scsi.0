Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E03C4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 18:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4246220795
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 18:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aDQ586W+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbgJBSW4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 14:22:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgJBSW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 14:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601662974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcUTUrmBZt8SZNuGe1YLHBp9h5KkZhqwq3YUbV+dhfg=;
        b=aDQ586W+9t/qM5Ps0H/uTQCWD4Y6FIX9wSwzH84cF70cIRNqaClEgCcigqAae6JOm9KgUy
        O7uj8huy5kxFHFyJwe0CJMElmUo5mRa2Rm6H12t6rPOZwSmR0u+WJdOYsG8Iz4dbElJ+p8
        c/zAgoBMUtWE9OcRtztvWdt8GDH1CY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-smCaREX6NcOegb63RdSm4A-1; Fri, 02 Oct 2020 14:22:52 -0400
X-MC-Unique: smCaREX6NcOegb63RdSm4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36B42801FC6;
        Fri,  2 Oct 2020 18:22:51 +0000 (UTC)
Received: from [10.40.192.160] (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9F365C1DA;
        Fri,  2 Oct 2020 18:22:49 +0000 (UTC)
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list
 corruption early"
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
References: <20201002073341.12470-1-mlombard@redhat.com>
 <dc48abf2-0b54-0241-6931-e2041c5dbc40@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <6954cd7a-ef06-c118-4680-71a6d3d219af@redhat.com>
Date:   Fri, 2 Oct 2020 20:22:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <dc48abf2-0b54-0241-6931-e2041c5dbc40@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Dne 02. 10. 20 v 20:06 Mike Christie napsal(a):
> On 10/2/20 2:33 AM, Maurizio Lombardi wrote:
>> This reverts commit b0055acaedf56a2717a6e2a4b700f1959a1b60df.
>>
>> This warning is duplicated because the very same condition
>> is already checked in __iscsit_free_cmd().
>>
>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>> ---
>>  drivers/target/iscsi/iscsi_target_util.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
>> index 45ba07c6ec27..ff7830ddbd7b 100644
>> --- a/drivers/target/iscsi/iscsi_target_util.c
>> +++ b/drivers/target/iscsi/iscsi_target_util.c
>> @@ -764,8 +764,6 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>>  	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
>>  	int rc;
>>  
>> -	WARN_ON(!list_empty(&cmd->i_conn_node));
>> -
>>  	__iscsit_free_cmd(cmd, shutdown);
>>  	if (se_cmd) {
>>  		rc = transport_generic_free_cmd(se_cmd, shutdown);
>>
> 
> Maurizio, are you hitting these WARN()s?

We received a number of bug reports against RHEL7 about warnings like the following:

Feb 18 12:41:01 hostname kernel: ------------[ cut here ]------------
Feb 18 12:41:01 hostname kernel: WARNING: CPU: 1 PID: 21173 at drivers/target/iscsi/iscsi_target_util.c:720 __iscsit_free_cmd+0x26e/0x290 [iscsi_target_mod]
...
Feb 18 12:41:01 hostname kernel: CPU: 1 PID: 21173 Comm: kworker/u8:3 Kdump: loaded Not tainted 3.10.0-1062.4.1.el7.x86_64 #1
Feb 18 12:41:01 hostname kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/17/2015
Feb 18 12:41:01 hostname kernel: Workqueue: tmr-user target_tmr_work [target_core_mod]
Feb 18 12:41:01 hostname kernel: Call Trace:
Feb 18 12:41:01 hostname kernel: [<ffffffff91d78ba4>] dump_stack+0x19/0x1b
Feb 18 12:41:01 hostname kernel: [<ffffffff9169a958>] __warn+0xd8/0x100
Feb 18 12:41:01 hostname kernel: [<ffffffff9169aa9d>] warn_slowpath_null+0x1d/0x20
Feb 18 12:41:01 hostname kernel: [<ffffffffc0a6f69e>] __iscsit_free_cmd+0x26e/0x290 [iscsi_target_mod]
Feb 18 12:41:01 hostname kernel: [<ffffffffc0a70bc4>] iscsit_aborted_task+0x64/0x70 [iscsi_target_mod]
Feb 18 12:41:01 hostname kernel: [<ffffffffc0a7830a>] lio_aborted_task+0x2a/0x30 [iscsi_target_mod]
Feb 18 12:41:01 hostname kernel: [<ffffffffc09fa516>] transport_cmd_finish_abort+0x66/0xb0 [target_core_mod]
Feb 18 12:41:01 hostname kernel: [<ffffffffc09f4d92>] core_tmr_abort_task+0x102/0x180 [target_core_mod]
Feb 18 12:41:01 hostname kernel: [<ffffffffc09f7bb2>] target_tmr_work+0x152/0x170 [target_core_mod]
Feb 18 12:41:01 hostname kernel: [<ffffffff916bd1df>] process_one_work+0x17f/0x440
Feb 18 12:41:01 hostname kernel: [<ffffffff916be2f6>] worker_thread+0x126/0x3c0
Feb 18 12:41:01 hostname kernel: [<ffffffff916be1d0>] ? manage_workers.isra.26+0x2a0/0x2a0
Feb 18 12:41:01 hostname kernel: [<ffffffff916c51b1>] kthread+0xd1/0xe0
Feb 18 12:41:01 hostname kernel: [<ffffffff916c50e0>] ? insert_kthread_work+0x40/0x40
Feb 18 12:41:01 hostname kernel: [<ffffffff91d8bd37>] ret_from_fork_nospec_begin+0x21/0x21
Feb 18 12:41:01 hostname kernel: [<ffffffff916c50e0>] ? insert_kthread_work+0x40/0x40
Feb 18 12:41:01 hostname kernel: ---[ end trace ed2119501826ec7a ]---

I was discussing the matter with Bart Van Assche in private and maybe I found the bug,
this is the content of the last email I sent him:

The iscsit_release_commands_from_conn() function does the following operations:

1) locks the cmd_lock spinlock
2) Scans the list of commands and sets the CMD_T_FABRIC_STOP flag
3) Releases the cmd_lock spinlock
4) Rescans the list again and clears the i_conn_node link of each command


But what happens if an abort timer is fired between points 3 and 4?

void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
{
        spin_lock_bh(&conn->cmd_lock);
        if (!list_empty(&cmd->i_conn_node) &&
            !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
                list_del_init(&cmd->i_conn_node);
        spin_unlock_bh(&conn->cmd_lock);

        __iscsit_free_cmd(cmd, true);
}


iscsit_aborted_task() will find the cmd_lock spinlock unlocked.
will also find a non-empty i_conn_node link but with the CMD_T_FABRIC_STOP flag set. 
Therefore it will not call list_del_init(i_conn_node) and will trigger the warning in __iscsit_free_cmd().

Sounds it possible to you?
If I am right, this has been introduced by commit 064cdd2d91c2805d788876082f31cc63506f22c3

Maurizio

