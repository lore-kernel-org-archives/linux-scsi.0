Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC00CC25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 09:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjAWJxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 04:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjAWJxu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 04:53:50 -0500
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E39F13D40;
        Mon, 23 Jan 2023 01:53:32 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id t5so10233706wrq.1;
        Mon, 23 Jan 2023 01:53:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6JYVP5UJcizzi1H6/48N1XjKd/TMyIsL1AmgxjGjX+w=;
        b=VuV6F3rGSNRhRJ9JH/hGR+MPl4FsKgIHW6DKlX9400SmiT99qDUBK/EYPagj68di+d
         LGo05BtmKVTDenBU8GAXc3NpYlTz/pzQo5JttFLcilN2c1Jnsdn3osim2P46q5RUZgDK
         ReB/xYEXE9C9knSB5J1oBkJTTZip86vbtY46w5/vLIQqLYNjmtReqiCo5c5cLKwxPJsb
         rM4RV/RQtmQsBlTkHUHat4gpNhUFSKyTjxkkjN2/QNU6//lOgQSedtvWfHVNpkvITQv3
         C5fYuYP/siVwBf8XKvBN67R7MucU4GVgtqyt+ucAW85P0gvlh3wXX3JPF2/TROPdXdsG
         o6qA==
X-Gm-Message-State: AFqh2ko67aantrujCzC8cE6xlMpaa/LNpdkKxumagzo9kJnhnZFas5bQ
        W58WryGebs5XH2M2QpeVzTXMNyV1FCs=
X-Google-Smtp-Source: AMrXdXvkn/jw3Dy718Xq0mzNlcFFfgt/UonFj8SNC19fSy1mbaDpWcXhnIJAC8H3SbreamB9vESATg==
X-Received: by 2002:a05:6000:a03:b0:2b9:9e7b:be6b with SMTP id co3-20020a0560000a0300b002b99e7bbe6bmr22627714wrb.45.1674467610954;
        Mon, 23 Jan 2023 01:53:30 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id k3-20020a5d6e83000000b00289bdda07b7sm4015112wrz.92.2023.01.23.01.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 01:53:30 -0800 (PST)
Message-ID: <d2629836-78f0-ddc6-c654-80a14d16eec1@grimberg.me>
Date:   Mon, 23 Jan 2023 11:53:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 09/13] scsi: target: iscsit: Fix isert disconnect
 handling during login
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <20230112030832.110143-10-michael.christie@oracle.com>
 <20230113140816.GA31614@yadro.com>
 <e21571bf-2244-7b12-9765-f3ebe3a024ad@oracle.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <e21571bf-2244-7b12-9765-f3ebe3a024ad@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 1/18/23 04:14, Mike Christie wrote:
> On 1/13/23 08:08, Dmitry Bogdanov wrote:
>> On Wed, Jan 11, 2023 at 09:08:28PM -0600, Mike Christie wrote:
>>>
>>> If we get a disconnect event while logging in we can end up in a state
>>> where will never be able to relogin. This happens when:
>>>
>>> 1. login thread has put us into TARG_CONN_STATE_IN_LOGIN
>>> 2. isert then does
>>>
>>> isert_disconnected_handler -> iscsit_cause_connection_reinstatement
>>>
>>> which sets the conn connection_reinstatement flag. Nothing else happens
>>> because we are only in IN_LOGIN. The tx/rx threads are not running yet
>>> so we can't start recovery from those contexts at this time.
>>>
>>> 3. The login thread finishes processing the login pdu and thinks login is
>>> done. It sets us into TARG_CONN_STATE_LOGGED_IN/TARG_SESS_STATE_LOGGED_IN.
>>> This starts the rx/tx threads.
>>>
>>> 4. The initiator thought it disconnected the connection at 2, and has
>>> since sent a new connect which is now handled. This leads us to eventually
>>> run:
>>>
>>> iscsi_check_for_session_reinstatement-> iscsit_stop_session ->
>>> iscsit_cause_connection_reinstatement
>>>
>>> iscsit_stop_session sees the old conn and does
>>> iscsit_cause_connection_reinstatement which sees connection_reinstatement
>>> is set so it just returns instead of trying to kill the tx/rx threads
>>> which would have caused recovery to start.
>>>
>>> 5. iscsit_stop_session then waits on session_wait_comp which will never
>>> happen since we didn't kill the tx/rx threads.
>>>
>>> This has the iscsit login code check if a fabric driver ran
>>> iscsit_cause_connection_reinstatement during the login process similar
>>> to how we check for the sk state for tcp based iscsit. This will prevent
>>> us from getting into 3 and creating a ghost session.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>   drivers/target/iscsi/iscsi_target_nego.c | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
>>> index ff49c8f3fe24..2dd81752d4c9 100644
>>> --- a/drivers/target/iscsi/iscsi_target_nego.c
>>> +++ b/drivers/target/iscsi/iscsi_target_nego.c
>>> @@ -350,6 +350,16 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
>>>                                              ISCSI_LOGIN_STATUS_NO_RESOURCES);
>>>                          return -1;
>>>                  }
>>> +
>>> +               /*
>>> +                * isert doesn't know the iscsit state and uses
>>> +                * iscsit_cause_connection_reinstatement as a generic error
>>> +                * notification system. It may call it before we are in FFP.
>>> +                * Handle this now in case it signaled a failure before the
>>> +                * rx/tx threads were up and could start recovery.
>>> +                */
>>> +               if (atomic_read(&conn->connection_reinstatement))
>>> +                       goto err;
>>
>> Why only for login->login_complete case? In other case the session will
>> not hang? Will it be droppped on login timeout or something else?
> 
> It will not hang. If you hit an error with isert before we think we can go into
> FFP then the login timeout currently cleans up the conn and session.
> 
>>
>> May be the root cause is point 2 itself - calling iscsit_cause_connection_reinstatement
>> in not ISER_CONN_FULL_FEATURE state where there are no TX_RX threads?
>> I mean that was a misuse of iscsit_cause_connection_reinstatement?
> 
> Let me drop this patch for now. After writing the response above about normally it just
> times out, and thinking about your question here I think to really fix this we want to
> fully integrate isert login into iscsit.
> 
> The root problem is that isert login is not integrated into iscsit, so there is really
> no error handling. iscsit_cause_connection_reinstatement was supposed to do it, but it
> doesn't do anything.
> 
> So we need to separate the LOGIN_FLAGS_CLOSED tests and setting from the iscsi_target_sk*
> code. Add a helper to set that bit and do some state checks, and make the checks generic
> in the login code (not tied to having a socket). Convert iscsit and isert to use the new
> helper. Then handle the LOGIN_FLAGS_READ_ACTIVE/LOGIN_FLAGS_WRITE_ACTIVE and login_work
> stuff. Then review cxgb?
> 
> I'll do that later after fixing the command cleanup stuff in this patchsdet and the
> other patchsets I have outstanding.

Perhaps the fix is as simple as checking the iscsi state to be also 
full-featured and if not, do a simple error handling within
iser_disconnected_handler?
