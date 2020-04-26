Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16E9C2BA1A
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 05:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C98206BF
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 05:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="DCinvYnb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgDZFt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 01:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725468AbgDZFt2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Apr 2020 01:49:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D89C061A0C
        for <linux-scsi@vger.kernel.org>; Sat, 25 Apr 2020 22:49:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k18so5580316pll.6
        for <linux-scsi@vger.kernel.org>; Sat, 25 Apr 2020 22:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=KP6Ofnp1XgVMA1KbLbxr5TpwrmdlaS1nYRp5qDFPB+U=;
        b=DCinvYnbD9+JxmyJOaueiJy0C8ZSswmpBAh66s2c6m+92jTalnBlpETvp+ofIevGG/
         csI6o91leTy4WQQ42RlRlobBjCezvwHvyDZ1cHXiyP+iBVAEte0hHE4osxSwI7qfFu8y
         FsuVpAd6c7OyRw5/tEYAJ5OL3z3/7viNGbiw8GB7bFQWy8QYKZAgJACw6tLpjmQv2rHy
         oYYANPLC8FxZq/WgwGO/61d5cT0ptbdpPUh+qgLWsbJJsgXhHOjSvMZOfrr+5HNw6bEZ
         Yq9uN7bZusJzV+mTA1kp8CDKU85VMRS/CjTwl/Do2oSZiqJKvhxVPccAbcox7Nt63H45
         hJSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KP6Ofnp1XgVMA1KbLbxr5TpwrmdlaS1nYRp5qDFPB+U=;
        b=MlE/NDWqbLMEbHHrqDCfEYy/hFlkh4nCw+RWVJaBNtx+Aq9ZyLN7lePhmYyPyKENP2
         Sw0Bqahi4Vs04S43x2QcPKF4lU/CQ1ljMEbTccvV2VYSLPdAXgFtpzKpHfb3r2Z6b5ix
         HxIufnxTiqslrlRje3/xpTskpQ3Q5O28Tj0FkS3/YgkkyPlFdNOF/wYW9QQuKvZv5q0H
         SVLCeGx7sKM0G0blfME4D/MdE24cwyy5FMrnzuNT4gUkqigbGKYRdxvsD/jQ7zoVMDTk
         /iJJ2wjRt5XjwMRoIVAA3PxOpjY1Vriu815YgetnymhmkxUrsHpKwZdDTWrh8HvcZ/+B
         OU4g==
X-Gm-Message-State: AGi0Pua82gzpN+LRSDgy1V63N79mOOwY5f9O+0cIgeCYTtE9urDfPrnw
        ePtfmnf44dZR1C5XEA9uB1p+Hv8/cE0n9A==
X-Google-Smtp-Source: APiQypJbLjAnH/Ai9iELnSC/2alwtiWOkeyTTWFf6O5aJ0p3k061+buL3NGQnYVTPDLt3XQHTA4U6w==
X-Received: by 2002:a17:90a:c786:: with SMTP id gn6mr15955585pjb.147.1587880168056;
        Sat, 25 Apr 2020 22:49:28 -0700 (PDT)
Received: from houpudeMacBook-Pro.local ([103.136.220.72])
        by smtp.gmail.com with ESMTPSA id e11sm6826173pfl.85.2020.04.25.22.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 22:49:27 -0700 (PDT)
Subject: Re: [External] Re: [PATCH v3 1/2] iscsi-target: fix login error when
 receiving is too fast
To:     Mike Christie <mchristi@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200424123528.17627-1-houpu@bytedance.com>
 <20200424123528.17627-2-houpu@bytedance.com>
 <cee3c624-4d43-fd4c-1436-cfc0c08a4321@redhat.com>
 <8f3b123e-1dc3-54ba-ae6d-90e76e5702b5@redhat.com>
From:   Hou Pu <houpu@bytedance.com>
Message-ID: <44a02338-0923-5b57-ed26-8528bf9cde70@bytedance.com>
Date:   Sun, 26 Apr 2020 13:49:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8f3b123e-1dc3-54ba-ae6d-90e76e5702b5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/4/26 1:45 上午, Mike Christie wrote:
> On 4/24/20 12:01 PM, Mike Christie wrote:
>> On 4/24/20 7:35 AM, Hou Pu wrote:
>>> iscsi_target_sk_data_ready() could be invoked indirectly
>>> by iscsi_target_do_login_rx() from workqueue like following:
>>>
>>> iscsi_target_do_login_rx()
>>>    iscsi_target_do_login()
>>>      iscsi_target_do_tx_login_io()
>>>        iscsit_put_login_tx()
>>>          iscsi_login_tx_data()
>>>            tx_data()
>>>              sock_sendmsg_nosec()
>>>                tcp_sendmsg()
>>>                  release_sock()
>>>                    sk_backlog_rcv()
>>>                      tcp_v4_do_rcv()
>>>                        tcp_data_ready()
>>>                          iscsi_target_sk_data_ready()
>>>
>>> At that time LOGIN_FLAGS_READ_ACTIVE is not cleared.
>>> and iscsi_target_sk_data_ready will not read data
>>> from the socket. And some iscsi initiator(i.e. libiscsi)
>>> will wait forever for a reply.
>>>
>>> LOGIN_FLAGS_READ_ACTIVE should be cleared early just after
>>> doing the receive and before writing to the socket in
>>> iscsi_target_do_login_rx.
>>>
>>> But sad news is that LOGIN_FLAGS_READ_ACTIVE is also used
>>> by sk_state_change to do login cleanup if a socket was closed
>>> at login time. It is supposed to be cleared after the login
>>> pdu is successfully processed and replied.
>>>
>>> So introduce another flag LOGIN_FLAGS_WRITE_ACTIVE to cover
>>> the transmit part so that sk_state_change could work well
>>> and clear LOGIN_FLAGS_READ_ACTIVE early so that sk_data_ready
>>> could also work.
>>>
>>> While at here, use login_flags more efficient.
>>>
>>> Signed-off-by: Hou Pu <houpu@bytedance.com>
>>> ---
>>>   drivers/target/iscsi/iscsi_target_nego.c | 30 ++++++++++++++++++++++++++----
>>>   include/target/iscsi/iscsi_target_core.h |  9 +++++----
>>>   2 files changed, 31 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
>>> index 685d771b51d4..4cfa742e61df 100644
>>> --- a/drivers/target/iscsi/iscsi_target_nego.c
>>> +++ b/drivers/target/iscsi/iscsi_target_nego.c
>>> @@ -622,6 +622,26 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>>>   	if (rc < 0)
>>>   		goto err;
>>>   
>>> +	/*
>>> +	 * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
>>> +	 * could be trigger again after this.
>>> +	 *
>>> +	 * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
>>> +	 * process a login pdu, so that sk_state_chage could do login
>>> +	 * cleanup as needed if the socket is closed. If a delayed work is
>>> +	 * ongoing (LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
>>> +	 * sk_state_change will leave the cleanup to the delayed work or
>>> +	 * it will schedule a delayed work to do cleanup.
>>> +	 */
>>> +	if (conn->sock) {
>>> +		struct sock *sk = conn->sock->sk;
>>> +
>>> +		write_lock_bh(&sk->sk_callback_lock);
>>> +		clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
>>> +		set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
>>> +		write_unlock_bh(&sk->sk_callback_lock);
>>> +	}
>>> +
>> Hey,
>>
>> I had one more question.
>>
>> With the above code, I think we have a race where if we clear the bit
>> above early and iscsi_target_sk_data_ready runs while
>> iscsi_target_do_login_rx is still running then we could queue the work
>> an extra time and get stuck. Because the bit is now not set, if
>> iscsi_target_sk_data_ready runs it will end up calling
>> schedule_delayed_work which will queue up the work again since the work
>> is running and not pending.

Yes. I was trying to allow queuing the delayed work early.

>>
>> If that is correct and we hit the race what happens if this was the last
>> login pdu, and we are supposed to go to full feature phase next? For
>> example if iscsi_target_do_login_rx runs an extra time, will we end up
>> stuck waiting in iscsi_target_do_login_rx's call to:
>>
>> rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
>>
>> ?

For the last login pdu, we may have race as you said. thanks for 
pointing it out.

I was trying to image a case where we can hit the race, normally it is 
case a).

a). initiator send last login pdu -> target received -> target replied

b). initiator send last login pdu -> target received -> initiator send 
something -> target replied

in case b). we will queue another delayed work which we should not.  
After the target replied

the last login pdu, conn->conn_login is freed. we might visited it in 
the delayed work.


> Just answering my own question. It looks like we do not get stuck. But
> we either get nothing on the session so the login timeout fires and we
> drop the session. Or, we get a PDU and the login thread reads it in
> before the normal rx thread does, but it assumes it is a login related
> and we most likely drop the session due to invalid fields.
>
> I think in iscsi_target_restore_sock_callbacks we want to do a:
>
> cancel_delayed_work(&conn->login_work)
>
> after we reset the callbacks and drop the sk_callback_lock lock.

I am not very sure if we could or if it is good to cancel_delayed_work 
from the work itself.

If it is ok then i am ok with it. Or in another way, I think we could 
just clear

LOGIN_FLAGS_READ_ACTIVE and set LOGIN_FLAGS_WRITE_ACTIVE

after iscsi_target_restore_sock_callbacks when finish process last login 
pdu.

What do you think?



Thanks,

Hou


>
