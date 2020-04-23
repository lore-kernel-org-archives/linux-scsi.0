Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBE0C55185
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49E8C2074F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:39:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQG8Rg4x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDWBji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWBjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 21:39:37 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACECC03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:39:37 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mq3so1732482pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gh6eYdrYZPf8HuLijZNfDEPVh+hwJbP7m02aNI4hOWo=;
        b=IQG8Rg4xtovDLGl6H1O+luYTg2trzTl7qjWJG8DwOSwcVs/hteK6vBhtKFk6vtsDqa
         4fBM6Mkt3i1OlbAjjvw0wvwhYPDWh6ubm2R3YOFgvi6NBNYgG+2Lu9DoY1csu79xBjh8
         myIpo9Fp4mCPWXT0nAQtcHdNyeIvkKQpSKC0IGCxu6ITgyeJRi3pX5Y6Y/wwpU1yF+QI
         X/LUw4kemwh8GboW0267ZsAexKGNWxRGZ2I7PzrLBNefRmzo6fLtveSinufw4z7kndH2
         +j5ANGqY1GalSL5RUZF6JnEfKhdvoFLNjZg9zD6F38YjqPuN7BToEgdki0gtuTta+E3t
         4igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gh6eYdrYZPf8HuLijZNfDEPVh+hwJbP7m02aNI4hOWo=;
        b=LK+YggfKJfmZ3zX78zcXmmOdrgCQJ5kl8WGZJJXDjySDhWwuk/6dUSd4VLWp2zAF+4
         Pdt6tMt1elGlK5xu9mc8Wlo8fdEqS3dZcUM8bn3QfrhvlFKF52O9yzcapIZLJOCDjhPg
         KOctKxqM94r9TzPVmOTKufOt6mfxUR7Lq5vYg26jGU8C5pqy2oCSbdRxRdJqX/UbYXGa
         nypV4hRqX/QQ7aB47pfdOrj5dDBRoNoDY3aGq8bfpEw6Y5U8nnX76iXa6BFMsPFwnONQ
         7lC7RXazs4U7vjPnBP7o1A6UPRvQLuWCfAaicOZxKyrnxSyKf3wKdmciHwh9isMlEfxC
         ezAA==
X-Gm-Message-State: AGi0PuZQAuWQquIjcKiHk8TfD5nH7Q9efd0oE+y5HLkiaRvvjzm+Wg1b
        b5JM9oAOmmi3Gfa7hYLzsjA=
X-Google-Smtp-Source: APiQypKOfo0glUrpD+TTJU3LjfSnHoTy8I1zWPZDFgISJr5Xbmuk15CPF0rbnB2WhN0Hss+UUyFgLA==
X-Received: by 2002:a17:90a:cb86:: with SMTP id a6mr1626362pju.127.1587605977298;
        Wed, 22 Apr 2020 18:39:37 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r189sm506807pgr.31.2020.04.22.18.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 18:39:36 -0700 (PDT)
Subject: Re: [PATCH v3 24/31] elx: efct: LIO backend interface routines
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, herbszt@gmx.de,
        natechancellor@gmail.com, rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-25-jsmart2021@gmail.com>
 <dc132a7c-0d82-7439-dad0-c35a6acab1f7@acm.org>
 <cc3a75d6-3208-f450-dfd5-eaa218b0975b@gmail.com>
 <cb3e17a5-7005-5e04-89a9-40c0a16b2dfa@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <a0fb3539-489c-b075-f305-e7ccd013acdd@gmail.com>
Date:   Wed, 22 Apr 2020 18:39:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cb3e17a5-7005-5e04-89a9-40c0a16b2dfa@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/2020 10:09 PM, Bart Van Assche wrote:
> On 4/21/20 9:20 PM, James Smart wrote:
>> On 4/11/2020 9:57 PM, Bart Van Assche wrote:
>>> On 2020-04-11 20:32, James Smart wrote:
>>>> +
>>>> +    lio_wq = create_singlethread_workqueue("efct_lio_worker");
>>>> +    if (!lio_wq) {
>>>> +        efc_log_err(efct, "workqueue create failed\n");
>>>> +        return -ENOMEM;
>>>> +    }
>>>
>>> Is any work queued onto lio_wq that needs to be serialized against other
>>> work queued onto the same queue? If not, can one of the system
>>> workqueues be used, e.g. system_wq?
>>>
>>
>> We are using "lio_wq" here to call the LIO backed during creation or 
>> deletion of sessions. LIO api's target_remove_session/ 
>> target_setup_session are blocking calls so we don't want to process 
>> them in the interrupt thread. "lio_wq" is used for these two events 
>> only and this brings the serialization to session management as we 
>> create single threaded work queue.
> 
> Hi James,
> 
> I think the above is very useful information. How about adding that 
> information as a comment above the definition of "lio_wq"?
> 
> Thanks,
> 
> Bart.
> 

yep - we will. Thanks

-- james

