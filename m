Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27FAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 18:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B568C20720
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 18:12:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NLyyVFbf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgGGSMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 14:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgGGSMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 14:12:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB457C061755
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 11:12:06 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l17so86739wmj.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dkBGZFFrCFaqqtw2dRtcsDkg6EDJqwN1Ag4JpnmvXE0=;
        b=NLyyVFbfJQcGzxnQAhzuP9IWH4cBGwOkHvRTVHy7EmlYu877w37ArkMeHogVl2ySlm
         YeADM9JYuwx9Ps6Aa9mRTMui4YBBm5XJXfOpsS+OWtvDusfwButaxMJ8F+pMTB58fTdw
         cP16lfPTR7nSBCfpR5nmCeHVQseIlH5qg8gTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dkBGZFFrCFaqqtw2dRtcsDkg6EDJqwN1Ag4JpnmvXE0=;
        b=qcOHm2wybcU33C81t1JtPGHUwb8j54LqTmTHryu669WfaJvgd3q45+PH0Rh7plJDS/
         VMExBjQOhqWRmXgeyZInfsu9TBEiB8mwTejX+o08tGk3KV9HVhggsS3rrwy48pOHdCNz
         406PN8RU3fWqhNrOT7zb/DrGgATNbQb905Sct+AejlYwukCQfdJDMKxD3rCskVd/s8UU
         Atfu0ppOB7682flvjLSONF4Iu3ZDfTELf0v7t/mIY08bW4eCoS8zVdJQvMxT46WGTzmo
         o/U0VAvuJgMuWmTXvG1Ai8/FepPxXt6B1rr/kgJVkVw2bwS+kK4TAjKXsHCB/CvczWu7
         d9gw==
X-Gm-Message-State: AOAM532vOqa14oe4C0nV56Mh/ax6jioKyrO4uz8xgQ0ci6ETdWwZ/wjS
        h0KD53z733bIBaA/aQAHE8mJzkib3Ug=
X-Google-Smtp-Source: ABdhPJx80fTYHbVtP4tLN7pHRKrDlRSW1jaNL//yM4e+PTmPZAQS/FYK//pDzT11nfP43EpwYlgB+g==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr5505804wmj.86.1594145525392;
        Tue, 07 Jul 2020 11:12:05 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id k11sm2247410wrd.23.2020.07.07.11.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 11:12:04 -0700 (PDT)
Subject: Re: linux-next: Tree for Jul 7 (scsi/lpfc/lpfc_init.c)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        dick kennedy <dick.kennedy@broadcom.com>
References: <20200707180800.549b561b@canb.auug.org.au>
 <2f85f3c4-a58b-f225-a533-86e209a4651c@infradead.org>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <7ae1c7e3-ce8d-836b-1ae7-d4d00bd8f95c@broadcom.com>
Date:   Tue, 7 Jul 2020 11:12:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2f85f3c4-a58b-f225-a533-86e209a4651c@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/7/2020 10:09 AM, Randy Dunlap wrote:
> On 7/7/20 1:08 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20200706:
>>
> on i386:
>
> when CONFIG_ACPI is not set/enabled:
>
>
> ../drivers/scsi/lpfc/lpfc_init.c:1265:15: error: implicit declaration of function 'get_cpu_idle_time'; did you mean 'get_cpu_device'? [-Werror=implicit-function-declaration]
>
>
> The cpufreq people want justification for using
> get_cpu_idle_time().  Please see
> https://lore.kernel.org/linux-scsi/20200707030943.xkocccy6qy2c3hrx@vireshk-i7/
>
>
>

The driver is using cpu utilization in order to choose between softirq 
or work queues in handling an interrupt. Less-utilized, softirq is used. 
higher utilized, work queue is used.  The utilization is checked 
periodically via a heartbeat.

-- james

