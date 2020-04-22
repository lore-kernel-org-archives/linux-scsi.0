Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC11C55181
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B949E20706
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:20:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEUJhBRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDVEUL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgDVEUK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 00:20:10 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AAEC061BD3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:20:10 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so421657plo.7
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JW2eNpKYuEq3jYF+Ms+xkZoI4S/Xm4L9Thu6ePp2gao=;
        b=FEUJhBRpDO4SQoyn2cKuwis5a/YXcS4cNJ6EK0wJrq7DXsmuN5k533j5xa9jhk7wy7
         wp35dCXmBPeX5oVdDSdprrVrivXBdviinB/nu/nGjDotLpTTdv7tf4HK1lDde6+UyjZS
         MpNUmsyiyPWYr85B5Y5XHfW6gZW3DGv5v7IEZBCHII6OLmAtlT4D1S7jkG0gCDkzIL9w
         Lpni0bq/zqvr2ZbLYXIqCMZEXnp0oolDMZhiIJkIVRd7W4h53g67zB2eiAaOy3/VP1Uh
         DIpxOprjvfBdsUuAWtrLnxVG4l1t1uc4HFq4avHoNsvV/kW1W2VOeLKHmLmrJHMxiyO6
         8h+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JW2eNpKYuEq3jYF+Ms+xkZoI4S/Xm4L9Thu6ePp2gao=;
        b=ToccD4bEFr4VBlDNCk12P9TzjMX+fjhfrQ2vn/GQKKF6mPO9b98JmsYVE+2+uwUIdK
         D1GUKjTaG9pIPoSsTz48fX3Hmr5bg4OLkKyNBaBj+YM8L1tKpEpaBwH1UZboBjcz7uQO
         wnpMQdMwBBXsB67YDvZisoqZfH4rTDz87FVoqZJHCJc2ZkUa9Ac6BcaFruTGg8qHlo5K
         6SKMnPrft9V+TDMYRqd2wQB/9Hq7uqaXIHc7HYdpzH2PRu1GRCiRF9/LgSVAJLfLUxp9
         pl/e8HRR+9Ogzs9/eJ2BJDudVXV33py4AKH5s4QUwHWD0Ydee7ohOzizo2Jo/K9nVz3q
         j/Cg==
X-Gm-Message-State: AGi0PubsldxxAN8O8u7kaC/lBarrhqo9mpqkdLH6cLYP6tCBAkwC0kwp
        a318tCtLoYPgOCGItrMlhP8=
X-Google-Smtp-Source: APiQypK50elLw1RYPaPRjd8+2Yh9GKfajj8xOjHZ1S8i7FTIDGYnFTNL4ZAistImE/5/MMbDqjvVZw==
X-Received: by 2002:a17:902:6ac9:: with SMTP id i9mr25721245plt.35.1587529209576;
        Tue, 21 Apr 2020 21:20:09 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i15sm3720035pgj.30.2020.04.21.21.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 21:20:08 -0700 (PDT)
Subject: Re: [PATCH v3 24/31] elx: efct: LIO backend interface routines
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, herbszt@gmx.de,
        natechancellor@gmail.com, rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-25-jsmart2021@gmail.com>
 <dc132a7c-0d82-7439-dad0-c35a6acab1f7@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <cc3a75d6-3208-f450-dfd5-eaa218b0975b@gmail.com>
Date:   Tue, 21 Apr 2020 21:20:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <dc132a7c-0d82-7439-dad0-c35a6acab1f7@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/2020 9:57 PM, Bart Van Assche wrote:
> On 2020-04-11 20:32, James Smart wrote:
>> +	return EFC_SUCCESS;
>> +}
> 
> Redefining 0 is unusual in the Linux kernel. I prefer to see "return 0;"
> instead of "return ${DRIVER_NAME}_SUCCESS;".

Well, seems we have two different opinions. Prior v2 reviews wanted a 
consistent EFC_XXX set of enums for return codes.

I think it's very odd to return 0, and EFC_xxx elsewhere.  The issue I 
have with "we all know how to interpret 0" - I don't agree.  0 doesn't 
always mean success. It's implicitly an assumption to believe 0 means 
success.

I'd like to stay with EFC_SUCCESS for consistency.

> 
...
> This is one of the most unfriendly debugfs data formats I have seen so
> far: information about all sessions is dumped into one huge debugfs
> attribute.
> 
> Is information about active sessions useful for other LIO target
> drivers? Wasn't it promised that this functionality would be moved into
> the LIO core instead of defining it for the efct driver only?

We will remove the debugfs code. We will look to utilize Mike's patches 
for session info.

> 
>> +static int efct_debugfs_session_open(struct inode *inode, struct file *filp)
>> +{
>> +	struct efct_lio_sport *sport = inode->i_private;
>> +	int size = 17 * PAGE_SIZE; /* 34 byte per session*2048 sessions */
>> +
>> +	if (!(filp->f_mode & FMODE_READ)) {
>> +		filp->private_data = sport;
>> +		return EFC_SUCCESS;
>> +	}
>> +
>> +	filp->private_data = kmalloc(size, GFP_KERNEL);
>> +	if (!filp->private_data)
>> +		return -ENOMEM;
>> +
>> +	memset(filp->private_data, 0, size);
>> +	efct_lio_tgt_session_data(sport->efct, sport->wwpn, filp->private_data,
>> +				  size);
>> +	return EFC_SUCCESS;
>> +}
> 
> kmalloc() + memset() can be changed into kzalloc().
> 
> The above code allocates 68 KB physically contiguous memory? Kernel code
> should not rely on higher order page allocations unless there is no
> other choice.
> 
> Additionally, I see that the amount of memory allocated is independent
> of the number of sessions. I think there are better approaches.

Yes. Will address it.


> 
>> +
>> +	lio_wq = create_singlethread_workqueue("efct_lio_worker");
>> +	if (!lio_wq) {
>> +		efc_log_err(efct, "workqueue create failed\n");
>> +		return -ENOMEM;
>> +	}
> 
> Is any work queued onto lio_wq that needs to be serialized against other
> work queued onto the same queue? If not, can one of the system
> workqueues be used, e.g. system_wq?
> 

We are using "lio_wq" here to call the LIO backed during creation or 
deletion of sessions. LIO api's target_remove_session/ 
target_setup_session are blocking calls so we don't want to process them 
in the interrupt thread. "lio_wq" is used for these two events only and 
this brings the serialization to session management as we create single 
threaded work queue.

-- James
