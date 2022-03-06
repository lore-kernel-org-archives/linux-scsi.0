Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53371C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 00:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiCFAgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 19:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCFAgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 19:36:12 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBF86C951
        for <linux-scsi@vger.kernel.org>; Sat,  5 Mar 2022 16:35:20 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id bc27so10565981pgb.4
        for <linux-scsi@vger.kernel.org>; Sat, 05 Mar 2022 16:35:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gQ8isKWAmDG6Rc7/+PaKJVXFq7oZ+uwGGcPZ67/K0FQ=;
        b=XFPI/YFRoNVWrXXgGEoFogz2ko28NPGqakzyVXda0xt3VlzbEe66X4UGqFMQ9vfhYl
         lgK/UFh6h5ReV9PuBezoByYdKzhOG/jj0Ua+fK65g9Rwygz8OmHwjDSdJS6f1m2JVuA2
         j9PVZZaxSUU9LJ7vPCoSyK998xphxJn0wjh5qyxxd+rqPx2QsfnPnBiLtGffAjdICWol
         iIko0lhK4JC8yWUIYWxLgxCoDpbEoIJ97wuHQ4dG15/f0iDaMQpVguTnRtNUgTlGvGTi
         j68L+iaoFEWV6DJOZvlBrpv8HQKa4JpLStJIqD2LCBUd1bXbbad4mPC8zEYykt7SFbMr
         9tQw==
X-Gm-Message-State: AOAM531NBMWv/DPBjVlNdw5+7wnBazMP6tL6PladlYP4aYOUbaHOMW1L
        OWPrxDmuzDLmjzwqJkIUDkTQOS7K8D8=
X-Google-Smtp-Source: ABdhPJycxNDxnbW+gCESHL8uj8CvgCm0oigFR7GDqNhuUs1VWEXrzS4PHBoZuUXQ80HmM9aAC6/25g==
X-Received: by 2002:a63:9d48:0:b0:378:c359:fcbf with SMTP id i69-20020a639d48000000b00378c359fcbfmr4319785pgd.371.1646526919976;
        Sat, 05 Mar 2022 16:35:19 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm10477281pfu.120.2022.03.05.16.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 16:35:19 -0800 (PST)
Message-ID: <0faa4852-bbd1-11b2-967c-768b7e02259b@acm.org>
Date:   Sat, 5 Mar 2022 16:35:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 09/14] scsi: sd: Fix discard errors during revalidate
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-10-martin.petersen@oracle.com>
 <c088db8c-19cf-182f-8d2f-e990b5a0c35c@acm.org>
 <yq15youtm4y.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq15youtm4y.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/22 19:55, Martin K. Petersen wrote:
> 
> Bart,
> 
>>> +	if (mode == SD_LBP_DEFAULT && !sdkp->provisioning_override) {
>>
>> Hmm ... is provisioning_override ever true for the SD_LBP_DEFAULT
>> mode? If not, can "&& !sdkp->provisioning_override" be left out?
> 
> The two *_override variables are used to prevent subsequent revalidates
> from clobbering the mode configured by the user.
> 
> I experimented with various approaches for this, including having a
> separate SD_LBP_ mode for revalidate, using first_scan, etc. In the end
> I felt that the boolean was the best approach to capturing the fact that
> the currently active mode was explicitly configured by the user.
> 
> Open to suggestions.

Hi Martin,

It took me a while before I realized that the purpose of the 
provisioning_override variable is to make the behavior of the 
sd_config_discard(sdkp, SD_LBP_DEFAULT) different depending on whether the 
SD_LBP_DEFAULT comes from userspace (via sysfs) or from the sd_config_discard() 
call in sd_revalidate_disk().

How about storing the mode selected by the user inside the 
provisioning_mode_store() function and using that variable inside 
sd_config_discard() instead of sdkp->provisioning_override? I think that would 
result in easier to comprehend code.

Thanks,

Bart.
