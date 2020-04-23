Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CA2C54FD0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 15:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5319E21582
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 15:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eaJRMiMp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgDWPbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 11:31:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58991 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729081AbgDWPbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 11:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587655902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zNIQh0ll+orShoex0gyZ4gPW1qdjmjrr035iiXUT4Rw=;
        b=eaJRMiMpHfY52gj+qcU+pm4YQyIzZasQw7h1Jt9S5PdsEoos5AqVnYoEZBcPBxZe+XsfyL
        N82latIpaOeJsAbP6i/O7w1KwB6rtN+sYLeSbLG7iJHxRL+dXAOyUGkMMZbAdvfAxI9I3f
        OhIehJvxx7v0GoX47/7uLwBorH3jckc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-1fMKn55HMAWFYXHWwcoRTQ-1; Thu, 23 Apr 2020 11:31:40 -0400
X-MC-Unique: 1fMKn55HMAWFYXHWwcoRTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BF9B107ACF3;
        Thu, 23 Apr 2020 15:31:39 +0000 (UTC)
Received: from [10.10.119.77] (ovpn-119-77.rdu2.redhat.com [10.10.119.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FA2C5D714;
        Thu, 23 Apr 2020 15:31:38 +0000 (UTC)
Subject: Re: [External] Re: [PATCH 1/2] iscsi-target: fix login error when
 receiving is too fast
To:     Hou Pu <houpu@bytedance.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20200415080819.27327-1-houpu@bytedance.com>
 <20200415080819.27327-2-houpu@bytedance.com>
 <54e574b1-10b4-4385-11fb-773ef152fc2c@redhat.com>
 <CAO9YExv2kWp=x+mMaWeOrYmu4c6gTu0PeBSkOwHgr7ZW9MywSg@mail.gmail.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <53fa9766-21ea-72ad-818c-61e895e919ae@redhat.com>
Date:   Thu, 23 Apr 2020 10:31:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAO9YExv2kWp=x+mMaWeOrYmu4c6gTu0PeBSkOwHgr7ZW9MywSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/20 11:24 PM, Hou Pu wrote:
>>> +     /*
>>> +      * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
>>> +      * could be trigger again after this.
>>> +      *
>>> +      * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
>>> +      * processing a login pdu. So that sk_state_chage could do login
>>
>> I think we need to drop "ing" from processing and do:
>>
>> process a login pdu, so that sk_state_chage could do login
>>
> Sure. Thanks for helping me with my language. ^-^
> Will change this in v2.
>>
> 
>>> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
>>> index 591cd9e4692c..0c2dfc81bf8b 100644
>>> --- a/include/target/iscsi/iscsi_target_core.h
>>> +++ b/include/target/iscsi/iscsi_target_core.h
>>> @@ -570,6 +570,7 @@ struct iscsi_conn {
>>>  #define LOGIN_FLAGS_CLOSED           2
>>>  #define LOGIN_FLAGS_READY            4
>>>  #define LOGIN_FLAGS_INITIAL_PDU              8
>>> +#define LOGIN_FLAGS_WRITE_ACTIVE     12
>>
>> 12 works but seems odd. The current code uses test/set/clear_bit, so we
>> want these to be:
>>
>> #define LOGIN_FLAGS_CLOSED 0
>> #define LOGIN_FLAGS_READY 1
>> #define LOGIN_FLAGS_INITIAL_PDU 2
>> #define LOGIN_FLAGS_WRITE_ACTIVE 3
>>
>> right?
>>
> Yes, it is a little odd. What about this? I also changed the order of them
> to be in sequence that happened.
> 
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -566,10 +566,11 @@ struct iscsi_conn {
>         struct socket           *sock;
>         void                    (*orig_data_ready)(struct sock *);
>         void                    (*orig_state_change)(struct sock *);
> -#define LOGIN_FLAGS_READ_ACTIVE                1
> -#define LOGIN_FLAGS_CLOSED             2
> -#define LOGIN_FLAGS_READY              4
> -#define LOGIN_FLAGS_INITIAL_PDU                8
> +#define LOGIN_FLAGS_READY              0
> +#define LOGIN_FLAGS_INITIAL_PDU                1
> +#define LOGIN_FLAGS_READ_ACTIVE                2
> +#define LOGIN_FLAGS_WRITE_ACTIVE       3
> +#define LOGIN_FLAGS_CLOSED             4
> 

Looks ok to me.

