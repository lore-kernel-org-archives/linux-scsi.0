Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E5CC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 18:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiLISrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 13:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLISrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 13:47:21 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43187A56FB
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 10:47:20 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id 65so4317695pfx.9
        for <linux-scsi@vger.kernel.org>; Fri, 09 Dec 2022 10:47:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/VOJV2UckRQE9+9bsxr3JJZNF/AXM51aRV/Czfj3Vag=;
        b=ULUQXDXWB/gGj3I4BInvCdt5DGJCUI1j9Kf8IQFSTcaELYRdGM4WFkLNeXbBlcqB0m
         aly0/93cRWLNRYC2e1ReE6h/1T88T4L/fgMCMWCrecH3owEEzn7alvKUTlKDlti0joht
         JR+7ip6dB9YTAdqCnWMHpHre+qvaup9+czwe5R4s1Z53wTVELFZtlRymKyaB80TA7DhY
         WxNxtrRyT0S24klT91rBGUSv5NkVRiUYnZv2679OduhYpTYUCIQVKcDCYZ4ctpjA+eor
         WV5D0SrbCtpxua/vRSyCprmf/IeD4lv3Ip9gvrUx+AJFPEookCmyB4jHy8VcZlapTwdy
         BbnA==
X-Gm-Message-State: ANoB5pmCOsA59LrELGGy4ZUFrWywnTKc/TO8fEikCdb+zyL9XPkFNbh1
        PlpyBf+DudcgoyGsFrWXTW0=
X-Google-Smtp-Source: AA0mqf6VDI+yStYrBEB1Xsl7QQkG028G+W5WT2hnwYBhVccTED1+1NecqKhXqVswO87Sjp/dW8Ru/A==
X-Received: by 2002:a05:6a00:1d9f:b0:576:c70c:59a3 with SMTP id z31-20020a056a001d9f00b00576c70c59a3mr6431020pfw.20.1670611639605;
        Fri, 09 Dec 2022 10:47:19 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5c4e:b71f:9cdc:e100? ([2620:15c:211:201:5c4e:b71f:9cdc:e100])
        by smtp.gmail.com with ESMTPSA id l6-20020a622506000000b00576e75e753asm1555651pfl.27.2022.12.09.10.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 10:47:18 -0800 (PST)
Message-ID: <1ec68506-971f-962d-5d38-214bc94fc132@acm.org>
Date:   Fri, 9 Dec 2022 10:47:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
 <0e69ddee-4967-ee07-b959-91d7de7b212e@oracle.com>
 <07f92000-5be9-2168-8e53-55aa706fc276@oracle.com>
 <daebe4f3-fe84-1766-ddf5-53dbc9f47c5b@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <daebe4f3-fe84-1766-ddf5-53dbc9f47c5b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 10:37, Mike Christie wrote:
> On 12/9/22 11:15 AM, Mike Christie wrote:
>> On 12/9/22 4:40 AM, John Garry wrote:
>>>>         * head injection*required*  here otherwise quiesce won't work
>>>> @@ -249,13 +238,14 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>>>>        if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
>>>>            memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
>>>>    -    if (resid)
>>>> -        *resid = scmd->resid_len;
>>>> -    if (sense && scmd->sense_len)
>>>> -        memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
>>>> -    if (sshdr)
>>>> -        scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
>>>> -                     sshdr);
>>>> +    if (args.resid)
>>>> +        *args.resid = scmd->resid_len;
>>>> +    if (args.sense && scmd->sense_len)
>>>
>>> I am not sure that you require the sense_len check as you effectively have that same check in scsi_execute_args(), which is the only caller which would have args.sense set. But I suppose __scsi_execute() is still a public API (so should still check); but, by that same token, we have no sanity check for args.sense_len value here then. Is it possible to make __scsi_execute() non-public or move/add the check for proper sense_len here? I'm being extra cautious about this, I suppose.
>> Do people want the BUILD_BUG_ON we have now or a WARN/BUG?
>>
>> If we move to a single check in __scsi_execute or some non-macro wrapper
>> around it then we have to do a WARN/BUG. We do the macro approach now
>> so we can do the BUILD_BUG_ON.
> 
> Maybe we have to switch to a WARN/BUG.
> 
> It looks like some compilers don't like:
> 
> const struct scsi_exec_args exec_args = {
> 	.sshdr = &sshdr,
> };
> 
> scsi_execute_args(.... exec_args);
> 
> and will hit the:
> 
> #define scsi_execute_args(sdev, cmd, opf, buffer, bufflen, timeout,     \
>                            retries, args)                                \
> ({                                                                      \
>          BUILD_BUG_ON(args.sense &&                                      \
>                       args.sense_len != SCSI_SENSE_BUFFERSIZE);          \
> 
> because the args's sense and sense_len are not cleared yet.

My understanding is that the __scsi_execute() macro was introduced to 
prevent that every single scsi_execute() caller would have to be 
modified. I'm fine with removing the BUILD_BUG_ON(sense_len != 
SCSI_SENSE_BUFFER_SIZE) check and replacing it with a WARN_ON_ONCE() 
statement, e.g. inside __scsi_execute().

Thanks,

Bart.


