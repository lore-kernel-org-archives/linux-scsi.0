Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383E3C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 242D3613D8
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFCRsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 13:48:52 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:50931 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhFCRsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 13:48:51 -0400
Received: by mail-pj1-f50.google.com with SMTP id i22so4118914pju.0;
        Thu, 03 Jun 2021 10:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PorLmBEDgCcEnMLX9QH3/eFp+6hUEaS76Y9d4Jw4RaA=;
        b=lVHa1toMT5sPhRzcYWuFgHx1ojKXXQLCHhmsSrEfXdtZZEEJX6pbdXwBUDL2DrYbMA
         +LqEyDV4K4php0RN2qENQCf1uldgZ0EXmUYK9Utu2dE4LFYQKra1WWou3YXwZA8IrLJQ
         KQyb9TWuztUSCMRx+jfBO5F3o1wjpDxCaXaM7b5qOkAXhpQz/jvmY2sIUIukSJgPQgvk
         1xNoxe2+Q26UHEBNakTvIB/UACgj4daLEqwC5Q/UF9/BPOdpzzKsfcBTyMpKmxKcT1cP
         GflVgqkRQf/6QJHUjxgk8m4SiVXpxF3Av1nZzKadpBlKPnYfTuSM07BjwmPG+AIDaV7L
         fvAQ==
X-Gm-Message-State: AOAM532IIRxUWPrYU5EUbmrgMmD1ke0Wut8lm3FpkvAfYZIcJZSahcja
        miOwqcubTLk2m6yDMqYwIRA=
X-Google-Smtp-Source: ABdhPJzO9k/0hVi1AasdVZjfyTYDNMMZeJmd25fR+IH54mauv5B+1lruEw8K6LZa4AU/QltMM4rjDg==
X-Received: by 2002:a17:902:e551:b029:103:c082:ba with SMTP id n17-20020a170902e551b0290103c08200bamr248352plf.3.1622742426585;
        Thu, 03 Jun 2021 10:47:06 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k13sm2782215pfh.68.2021.06.03.10.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 10:47:05 -0700 (PDT)
Subject: Re: [PATCH v35 0/4] scsi: ufs: Add Host Performance Booster Support
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
References: <CGME20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
 <20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
 <YLkToPuEUa1waK6f@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <56e3d6b4-19bb-5d64-5b38-32036bdb23e7@acm.org>
Date:   Thu, 3 Jun 2021 10:47:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YLkToPuEUa1waK6f@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 10:38 AM, Greg KH wrote:
> On Mon, May 24, 2021 at 05:43:45PM +0900, Daejun Park wrote:
>> Changelog:
>>
>> v34 -> v35
>> 1. Addressed Bart's comments (type casting)
>> 2. Rebase 5.14 scsi-queue
> 
> This looks semi-sane.  What's preventing this from being merged?  It's a
> ratified spec, and there is hardware out there that has it, so Linux
> should support it, right?

HPB has been standardized considerable time ago and multiple UFS vendors
have implemented HPB support. This patch series has been changed
considerably since its first version. To me this patch series looks
ready for merging.

Thanks,

Bart.
