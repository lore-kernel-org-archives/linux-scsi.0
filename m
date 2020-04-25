Return-Path: <SRS0=0MZD=6J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2EAC54FCB
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 17:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804B82072B
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 17:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aE6+Z1Yy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgDYRpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:45:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41883 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726190AbgDYRpJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Apr 2020 13:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587836708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJI9j2JiU8J9bz8P7Pwb+0Lrpnb3rjMTvHOSE2gQPac=;
        b=aE6+Z1YyPSQoOFf/enRFaQQwzUPfkuHVWpKpuNdu6El1i9AQDHizHUQCiAeIL7Ry1k4nLR
        MPWCBxEI6FH8gTUHJ6JHWSq9Q5fUkUu7LmD9uIlwO5L4nkfrOGJammXhs/P/+scUTqxf7L
        uMhMF+520W2olNhXQ/eSra8xs9Z+ZKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-L_QOrNUtOISoe_pHAX5_DA-1; Sat, 25 Apr 2020 13:45:04 -0400
X-MC-Unique: L_QOrNUtOISoe_pHAX5_DA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE61F18FE860;
        Sat, 25 Apr 2020 17:45:02 +0000 (UTC)
Received: from [10.10.112.80] (ovpn-112-80.rdu2.redhat.com [10.10.112.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB06A5D9CA;
        Sat, 25 Apr 2020 17:45:01 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] iscsi-target: fix login error when receiving is
 too fast
From:   Mike Christie <mchristi@redhat.com>
To:     Hou Pu <houpu@bytedance.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200424123528.17627-1-houpu@bytedance.com>
 <20200424123528.17627-2-houpu@bytedance.com>
 <cee3c624-4d43-fd4c-1436-cfc0c08a4321@redhat.com>
Message-ID: <8f3b123e-1dc3-54ba-ae6d-90e76e5702b5@redhat.com>
Date:   Sat, 25 Apr 2020 12:45:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cee3c624-4d43-fd4c-1436-cfc0c08a4321@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/20 12:01 PM, Mike Christie wrote:
> On 4/24/20 7:35 AM, Hou Pu wrote:
>> iscsi_target_sk_data_ready() could be invoked indirectly
>> by iscsi_target_do_login_rx() from workqueue like following:
>>
>> iscsi_target_do_login_rx()
>>   iscsi_target_do_login()
>>     iscsi_target_do_tx_login_io()
>>       iscsit_put_login_tx()
>>         iscsi_login_tx_data()
>>           tx_data()
>>             sock_sendmsg_nosec()
>>               tcp_sendmsg()
>>                 release_sock()
>>                   sk_backlog_rcv()
>>                     tcp_v4_do_rcv()
>>                       tcp_data_ready()
>>                         iscsi_target_sk_data_ready()
>>
>> At that time LOGIN_FLAGS_READ_ACTIVE is not cleared.
>> and iscsi_target_sk_data_ready will not read data
>> from the socket. And some iscsi initiator(i.e. libiscsi)
>> will wait forever for a reply.
>>
>> LOGIN_FLAGS_READ_ACTIVE should be cleared early just after
>> doing the receive and before writing to the socket in
>> iscsi_target_do_login_rx.
>>
>> But sad news is that LOGIN_FLAGS_READ_ACTIVE is also used
>> by sk_state_change to do login cleanup if a socket was closed
>> at login time. It is supposed to be cleared after the login
>> pdu is successfully processed and replied.
>>
>> So introduce another flag LOGIN_FLAGS_WRITE_ACTIVE to cover
>> the transmit part so that sk_state_change could work well
>> and clear LOGIN_FLAGS_READ_ACTIVE early so that sk_data_ready
>> could also work.
>>
>> While at here, use login_flags more efficient.
>>
>> Signed-off-by: Hou Pu <houpu@bytedance.com>
>> ---
>>  drivers/target/iscsi/iscsi_target_nego.c | 30 ++++++++++++++++++++++++++----
>>  include/target/iscsi/iscsi_target_core.h |  9 +++++----
>>  2 files changed, 31 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
>> index 685d771b51d4..4cfa742e61df 100644
>> --- a/drivers/target/iscsi/iscsi_target_nego.c
>> +++ b/drivers/target/iscsi/iscsi_target_nego.c
>> @@ -622,6 +622,26 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>>  	if (rc < 0)
>>  		goto err;
>>  
>> +	/*
>> +	 * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
>> +	 * could be trigger again after this.
>> +	 *
>> +	 * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
>> +	 * process a login pdu, so that sk_state_chage could do login
>> +	 * cleanup as needed if the socket is closed. If a delayed work is
>> +	 * ongoing (LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
>> +	 * sk_state_change will leave the cleanup to the delayed work or
>> +	 * it will schedule a delayed work to do cleanup.
>> +	 */
>> +	if (conn->sock) {
>> +		struct sock *sk = conn->sock->sk;
>> +
>> +		write_lock_bh(&sk->sk_callback_lock);
>> +		clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
>> +		set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
>> +		write_unlock_bh(&sk->sk_callback_lock);
>> +	}
>> +
> Hey,
> 
> I had one more question.
> 
> With the above code, I think we have a race where if we clear the bit
> above early and iscsi_target_sk_data_ready runs while
> iscsi_target_do_login_rx is still running then we could queue the work
> an extra time and get stuck. Because the bit is now not set, if
> iscsi_target_sk_data_ready runs it will end up calling
> schedule_delayed_work which will queue up the work again since the work
> is running and not pending.
> 
> If that is correct and we hit the race what happens if this was the last
> login pdu, and we are supposed to go to full feature phase next? For
> example if iscsi_target_do_login_rx runs an extra time, will we end up
> stuck waiting in iscsi_target_do_login_rx's call to:
> 
> rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
> 
> ?

Just answering my own question. It looks like we do not get stuck. But
we either get nothing on the session so the login timeout fires and we
drop the session. Or, we get a PDU and the login thread reads it in
before the normal rx thread does, but it assumes it is a login related
and we most likely drop the session due to invalid fields.

I think in iscsi_target_restore_sock_callbacks we want to do a:

cancel_delayed_work(&conn->login_work)

after we reset the callbacks and drop the sk_callback_lock lock.

