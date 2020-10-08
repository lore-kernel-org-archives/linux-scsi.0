Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED7DC43467
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 09:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9BFD217BA
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 09:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggbUbdgQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgJHJmR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 05:42:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgJHJmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 05:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602150136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n08sbLQEgAGOV+EhfSz0zTl8I0PesDu7LkvwUQryo00=;
        b=ggbUbdgQwu1NmIgjV82hW2YTKxjM14sOCRkz5go2g1uREk9u4jJSEFHeW5O2blNpBU1dfL
        Q2wVIxfvckIWCoI6uP5a+kOMA7H4M9+XnKeT23NI0MGNnXKdMPmIInwSDUDWF4y2Xa0HNx
        HnXhAyQUt+qBp4mxeUTDFHGQ8keL790=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-xtHLEFHyN3G9ousukWaJ8A-1; Thu, 08 Oct 2020 05:42:12 -0400
X-MC-Unique: xtHLEFHyN3G9ousukWaJ8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F412E1084C88;
        Thu,  8 Oct 2020 09:42:10 +0000 (UTC)
Received: from [10.35.206.132] (unknown [10.35.206.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 323D276647;
        Thu,  8 Oct 2020 09:42:08 +0000 (UTC)
Subject: Re: [PATCH 1/2] target: iscsi: prevent a race condition in
 iscsit_unmap_cmd()
To:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        michael.christie@oracle.com
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-2-mlombard@redhat.com>
 <1bff131d-d451-2597-7751-fac0269a6e37@acm.org>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <4a6adf2d-4526-b408-4460-ad86f4c402fb@redhat.com>
Date:   Thu, 8 Oct 2020 11:42:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1bff131d-d451-2597-7751-fac0269a6e37@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Dne 08. 10. 20 v 4:15 Bart Van Assche napsal(a):
> On 2020-10-07 07:53, Maurizio Lombardi wrote:
>> A potential race condition may occur in iscsit_unmap_cmd() if the
>> __iscsit_free_cmd() function is called by two different threads.
>>
>> This patch adds a spinlock to serialize the calls to
>> iscsit_unmap_cmd()
>>
>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>> ---
>>  drivers/target/iscsi/iscsi_target_login.c | 1 +
>>  drivers/target/iscsi/iscsi_target_util.c  | 5 ++++-
>>  include/target/iscsi/iscsi_target_core.h  | 1 +
>>  3 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
>> index 893d1b406c29..e16ceee87bba 100644
>> --- a/drivers/target/iscsi/iscsi_target_login.c
>> +++ b/drivers/target/iscsi/iscsi_target_login.c
>> @@ -1110,6 +1110,7 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
>>  	spin_lock_init(&conn->nopin_timer_lock);
>>  	spin_lock_init(&conn->response_queue_lock);
>>  	spin_lock_init(&conn->state_lock);
>> +	spin_lock_init(&conn->unmap_cmd_lock);
>>  
>>  	timer_setup(&conn->nopin_response_timer,
>>  		    iscsit_handle_nopin_response_timeout, 0);
>> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
>> index 45ba07c6ec27..3082f5bde9fa 100644
>> --- a/drivers/target/iscsi/iscsi_target_util.c
>> +++ b/drivers/target/iscsi/iscsi_target_util.c
>> @@ -755,8 +755,11 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
>>  		iscsit_remove_cmd_from_response_queue(cmd, conn);
>>  	}
>>  
>> -	if (conn && conn->conn_transport->iscsit_unmap_cmd)
>> +	if (conn && conn->conn_transport->iscsit_unmap_cmd) {
>> +		spin_lock(&conn->unmap_cmd_lock);
>>  		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
>> +		spin_unlock(&conn->unmap_cmd_lock);
>> +	}
>>  }
> 
> This looks weird to me. Shouldn't the iSCSI target code make sure that
> __iscsit_free_cmd() is called once per command instead of allowing concurrent
> calls of that function and serializing iscsit_unmap_cmd() calls?

__iscsit_free_cmd() doesn't actually "free" the command.
If you look at the code, you will notice that the only thing that it does is to stop some timers,
remove the command from the immediate and response queues and call the unmap callback.

In some cases, the iscsit_free_cmd() calls __iscsit_free_cmd() twice
against the same command (yes, it's safe).

It should also be safe to execute __iscsit_free_cmd() even after a concurrent call to
iscsit_free_cmd() has been completed because the abort timer holds a
reference against the command.
Additionally, all the functions called by __iscsit_free_cmd() are thread-safe, with
the exception of the unmap callback that may crash the kernel if the cxgbit offload driver is used.

Maurizio

