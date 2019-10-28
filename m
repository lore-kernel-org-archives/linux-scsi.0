Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589DDCA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 18:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E96120717
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 18:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391136AbfJ1ScB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:32:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36344 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387407AbfJ1ScB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 14:32:01 -0400
Received: by mail-pg1-f194.google.com with SMTP id j22so1436249pgh.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2019 11:31:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3DmiAj9QVXXHkx/wEoVuxYRMXAh+RROS1QX3culjYsg=;
        b=SYzaZx7RaW98F2jkLsisXvNd+m48uIh71dbm49w8x2Xr4ZlwYL+CDfIgX3e8iygU4X
         QoEeZgl/rTMWWwspCvvUvRWmyoiDKvY5yMog3N/HFhUg8xNW3tpPAsWFTwjOrGrQTc5j
         wL2mKCPiiC2RYk1GK+dylgmwwRG+7Ak8c+thXYfM6KiYz8/c2rn18tYNcr3D1dkHu4RL
         Seaygs78VD/e5Foi7BV6lMD09VicfH9ZKKnyBvxvoDh0uHy1OgMnWyLmRhWcik2QhbHI
         tDuCBgKHRRycjMMXER9Il/Kew5+GFToOYk5G/vF0SSrbn58ii93ULf8aYrBHWeWYzXxo
         hQXg==
X-Gm-Message-State: APjAAAUsyCLWm2Pjn+VwVEAQSvB7l57rhWels6otxQ5JxFEpBYbNwywo
        rysvyelbBZaDWtpji2VfFyc=
X-Google-Smtp-Source: APXvYqzqFrBZ8BpOoo+/UVSUl9vShZStnqHSgV3novncfNmAgAkAfAaOf18oqR48xsSxr1Yr58xGqA==
X-Received: by 2002:a63:595:: with SMTP id 143mr14100936pgf.45.1572287518761;
        Mon, 28 Oct 2019 11:31:58 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l23sm207378pjy.12.2019.10.28.11.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 11:31:57 -0700 (PDT)
Subject: Re: [PATCH 24/32] elx: efct: LIO backend interface routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        Mike Christie <mchristi@redhat.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-25-jsmart2021@gmail.com>
 <5eae53c2-daee-f1f3-8586-e92fd61a5544@acm.org>
 <2120064f-cc31-e759-9b49-9acc73d7ef91@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5d62ab63-8a7f-2e2f-6b92-80cb3d252b55@acm.org>
Date:   Mon, 28 Oct 2019 11:31:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2120064f-cc31-e759-9b49-9acc73d7ef91@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/19 10:49 AM, James Smart wrote:
>> On 10/24/2019 3:27 PM, Bart Van Assche wrote:
>>> +static const struct file_operations efct_debugfs_session_fops = {
>>> +    .owner        = THIS_MODULE,
>>> +    .open        = efct_debugfs_session_open,
>>> +    .release    = efct_debugfs_session_close,
>>> +    .read        = efct_debugfs_session_read,
>>> +    .write        = efct_debugfs_session_write,
>>> +    .llseek        = default_llseek,
>>> +};
>>> +
>>> +static const struct file_operations efct_npiv_debugfs_session_fops = {
>>> +    .owner        = THIS_MODULE,
>>> +    .open        = efct_npiv_debugfs_session_open,
>>> +    .release    = efct_debugfs_session_close,
>>> +    .read        = efct_debugfs_session_read,
>>> +    .write        = efct_debugfs_session_write,
>>> +    .llseek        = default_llseek,
>>> +};
>>
>> Since the information that is exported through debugfs (logged in 
>> initiators) is information that is also useful for other target 
>> drivers, I think this functionality should be implemented in the 
>> target core instead of in this target driver.
> 
> Can you expand further on what you'd like to see and the format of the 
> data to be displayed ?

(+Mike)

Mike, can you comment on the status of your patch "target: add session 
dir in configfs" (https://patchwork.kernel.org/patch/10525321/)?

Thanks,

Bart.
