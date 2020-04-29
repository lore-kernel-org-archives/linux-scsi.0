Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA4FC83003
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 06:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E834520757
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 06:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="Bnuz/SV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2G7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 02:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgD2G7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 02:59:19 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E569DC03C1AD
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 23:59:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f15so511452plr.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 23:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JzJdKWCCeu6/SAjK8bbpobyYaX5bHaH5XgqKXROnyBo=;
        b=Bnuz/SV4Fu2GX8u0xqcGZpgSM/WusNHTFDhUhsZ77hRdeyQqD0WF+op/4oYmLLEe/e
         9j/bj/dmMOEikkfP0TYf9WZ/DTsyQ858S1ZUGBrytad5ixZac1COD8m5ykiDo5HiR3py
         zp+QmlNVwA0bPVDJIbPrIy0yCIFa3iRUxlclkdbSw7LBp14cRruus3LGgABqIy/hxWH9
         UN0GbT9uNh2tuVChHI3O/ccVlq4/xPmgABSNlulnV+Uh4Jq3OC/5LofBdBvj0HoctJoN
         8inzMsAT4oB87o2U25bf61LKUVdICTL1g3gH1yZgyS+QO8eZvzxpr7IZj7LZFiSU48Xd
         YIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzJdKWCCeu6/SAjK8bbpobyYaX5bHaH5XgqKXROnyBo=;
        b=o2eKAejPRUDrOHSMYZnPZdiaHRMTdfjxRpGh225qEHsPCge3khQtdri8exbrcdjWwQ
         +I1VSljbYUvtXraQ29pZow/Bqigx4/VSA/CfdkQEsd/AOmferCdtecclLMNrc2pASMlP
         i4F+rQ0UT2zW4ASkA8oqqSkr4dEyK7WEkOyceqALSSYyLne+/op75isNPOx8s0ctbHjA
         fQImNawQAYTSw6tSeNcjlkSMhi6sZSTZCTAKkoR/URlgp+eiUJ7ZtIjkT+evLdekFKRx
         2bfwF4DPmAkicMR/Uash7emxrMySCS/CEOnobV5KKVIY/MFl9a3V6bBz1zVzH0WkYmWd
         cAkA==
X-Gm-Message-State: AGi0PuZVtl+/FZgQzf+RKNA/xDgWrnXbyzTcfSIXhhjmCivGQ6fA/tZs
        x3i19IA664sQaNDAymogF6gZPg==
X-Google-Smtp-Source: APiQypLIkAPUF0WjH7LGHJsIXc3WhOhrAKd95ZDqSRRoV5YqF1ZOMaGIA8h2m4Op6F3KO5ngxbHewg==
X-Received: by 2002:a17:90a:2170:: with SMTP id a103mr1435201pje.181.1588143557174;
        Tue, 28 Apr 2020 23:59:17 -0700 (PDT)
Received: from houpudeMacBook-Pro.local ([103.136.220.73])
        by smtp.gmail.com with ESMTPSA id m18sm1384786pjl.14.2020.04.28.23.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 23:59:16 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] iscsi-target: fix login error when receiving is
 too fast
To:     Mike Christie <mchristi@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200424123528.17627-1-houpu@bytedance.com>
 <20200424123528.17627-2-houpu@bytedance.com>
 <cee3c624-4d43-fd4c-1436-cfc0c08a4321@redhat.com>
 <8f3b123e-1dc3-54ba-ae6d-90e76e5702b5@redhat.com>
 <44a02338-0923-5b57-ed26-8528bf9cde70@bytedance.com>
 <ef4dce23-dca8-c75a-0e18-c4bb49fe503a@bytedance.com>
 <f8e06fd6-d2d5-b237-7d32-86ee3277e85f@redhat.com>
From:   Hou Pu <houpu@bytedance.com>
Message-ID: <bdaaa620-ff31-baee-9a3e-d6eeccc160a9@bytedance.com>
Date:   Wed, 29 Apr 2020 14:59:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f8e06fd6-d2d5-b237-7d32-86ee3277e85f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/4/29 1:50 上午, Mike Christie wrote:
> On 4/26/20 1:09 AM, Hou Pu wrote:
>>
>>>>>> +     */
>>>>>> +    if (conn->sock) {
>>>>>> +        struct sock *sk = conn->sock->sk;
>>>>>> +
>>>>>> +        write_lock_bh(&sk->sk_callback_lock);
>>>>>> +        clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
>>>>>> +        set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
>>>>>> +        write_unlock_bh(&sk->sk_callback_lock);
>>>>>> +    }
>>>>>> +
>>>>> Hey,
>>>>>
>>>>> I had one more question.
>>>>>
>>>>> With the above code, I think we have a race where if we clear the bit
>>>>> above early and iscsi_target_sk_data_ready runs while
>>>>> iscsi_target_do_login_rx is still running then we could queue the work
>>>>> an extra time and get stuck. Because the bit is now not set, if
>>>>> iscsi_target_sk_data_ready runs it will end up calling
>>>>> schedule_delayed_work which will queue up the work again since the work
>>>>> is running and not pending.
>>>
>>> Yes. I was trying to allow queuing the delayed work early.
>>>
>>>>>
>>>>> If that is correct and we hit the race what happens if this was the
>>>>> last
>>>>> login pdu, and we are supposed to go to full feature phase next? For
>>>>> example if iscsi_target_do_login_rx runs an extra time, will we end up
>>>>> stuck waiting in iscsi_target_do_login_rx's call to:
>>>>>
>>>>> rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
>>>>>
>>>>> ?
>>>
>>> For the last login pdu, we may have race as you said. thanks for
>>> pointing it out.
>>>
>>> I was trying to image a case where we can hit the race, normally it is
>>> case a).
>>>
>>> a). initiator send last login pdu -> target received -> target replied
>>>
>>> b). initiator send last login pdu -> target received -> initiator send
>>> something -> target replied
>>>
>>> in case b). we will queue another delayed work which we should not.
>>> After the target replied
>>>
>>> the last login pdu, conn->conn_login is freed. we might visited it in
>>> the delayed wo>>
>>>
>>>> Just answering my own question. It looks like we do not get stuck. But
>>>> we either get nothing on the session so the login timeout fires and we
>>>> drop the session. Or, we get a PDU and the login thread reads it in
>>>> before the normal rx thread does, but it assumes it is a login related
>>>> and we most likely drop the session due to invalid fields.
>>>>
>>>> I think in iscsi_target_restore_sock_callbacks we want to do a:
>>>>
>>>> cancel_delayed_work(&conn->login_work)
>>>>
>>>> after we reset the callbacks and drop the sk_callback_lock lock.
>>>
>>> I am not very sure if we could or if it is good to cancel_delayed_work
>>> from the work itself.
>>>
>>> If it is ok then i am ok with it. Or in another way, I think we could
>>> just clear
>>>
>>> LOGIN_FLAGS_READ_ACTIVE and set LOGIN_FLAGS_WRITE_ACTIVE
>>>
>>> after iscsi_target_restore_sock_callbacks when finish process last
>>> login pdu.
>>
>> That would look like (in iscsi_target_do_tx_login_io):
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_nego.c
>> b/drivers/target/iscsi/iscsi_target_nego.c
>> index 685d771b51d4..4d0658731382 100644
>> --- a/drivers/target/iscsi/iscsi_target_nego.c
>> +++ b/drivers/target/iscsi/iscsi_target_nego.c
>> @@ -328,6 +328,28 @@ static int iscsi_target_do_tx_login_io(struct
>> iscsi_conn *conn, struct iscsi_log
>>          u32 padding = 0;
>>          struct iscsi_login_rsp *login_rsp;
>>
>> +       /*
>> +        * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
>> +        * could be trigger again after this.
>> +        *
>> +        * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
>> +        * process a login pdu, so that sk_state_chage could do login
>> +        * cleanup as needed if the socket is closed. If a delayed work is
>> +        * ongoing (LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
>> +        * sk_state_change will leave the cleanup to the delayed work or
>> +        * it will schedule a delayed work to do cleanup.
>> +        */
>> +       if (conn->sock) {
>> +               struct sock *sk = conn->sock->sk;
>> +
>> +               write_lock_bh(&sk->sk_callback_lock);
>> +               if (!test_bit(LOGIN_FLAGS_INITIAL_PDU,
>> &conn->login_flags)) {
>> +                       clear_bit(LOGIN_FLAGS_READ_ACTIVE,
>> &conn->login_flags);
>> +                       set_bit(LOGIN_FLAGS_WRITE_ACTIVE,
>> &conn->login_flags);
>> +               }
>> +               write_unlock_bh(&sk->sk_callback_lock);
>> +       }
> 
> You lost me. I didn't understand this part. Would you still be doing the
> above bit manipulation in iscsi_target_do_login_rx too?

By moving this chunk here(from iscsi_target_do_login_rx to 
iscsi_target_do_tx_login_io), we have already
restore sock callbacks(like below in iscsi_target_do_login),
So clearing READ_ACTIVE would not cause another delayed
work being scheduled.

So I think we would not have the race you pointed out
for last login pdu.

[code snippet

iscsi_target_do_login()
...
login->login_complete = 1;
iscsi_target_restore_sock_callbacks(conn);
if (iscsi_target_do_tx_login_io(conn,
                           login) < 0)

...
]



> 
> Is the above code then to handle when
> iscsi_target_start_negotiation->iscsi_target_do_login->iscsi_target_do_tx_login_io
> runs?
> 
> I was thinking when you mentioned the final login PDU you were going to
> do something when you detect login->login_complete is true.
> 

Even if we move above chunk here, I realize that we
could still theoretically have problem.

For login pdus which is not initial or last login pdus,
after enable scheduling delayed work by clearing READ_ACTIVE.
It is possible to queue a delayed work. (i.e. a out of order
initiator could send pdus at any time).
In case we received such out of order pdu, we need
to cancel them when we have an error and later
doing the clean up.

I will try to solve this and resend these patches.
Maybe it's better to cancel_delayed_work() in
iscsi_target_do_login_rx.

I might not express myself very clear. Please
see next version of these patch.


> This code is not my expertise area, so I might just not be understanding
> something simple about how it all works.

Your comments make sense and are helpful for me. Thanks.
> 

Thanks,
Hou
