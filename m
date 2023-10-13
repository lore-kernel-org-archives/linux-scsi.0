Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F90FCDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 16:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjJMQZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 12:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjJMQZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 12:25:09 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD26BA9
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 09:25:06 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6c4bf619b57so1446358a34.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 09:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697214306; x=1697819106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p1UPZMSkgkIyz+Vra1Gma2AD0nnQUamicNB8T2Fp4Ik=;
        b=VUJRRtZA4HNWnSaUsD62zcjiikP7DXEYQCO/29c4Y44NjFYi1z4yBevJRYoz8wDhYf
         meCEtn5SvhCZVQuo5oivaDE27yl0d1/TRWW0bj5SFmrAPNa+ehdRyMjXDNmoWOIuhRHq
         yYzibMfdxyGA5i/HXfmEAMSFvQq9by7VjKA+gTahbQWmhV6UaI9Dq/6lFMS80DpS0V+K
         JfHz+vJEVoKcaWE3Yznk7xgFlMQ8hOs6jrS57CjcXquZGARR5DqNfI8jWFoNBa1bGR4Q
         9T2NFqBqBVrZAm1AsgoU8H6gUPss5cFX3hRFdhRMz2c/XlGJw0MzT/BAfvWrjuAmGc8V
         RE5w==
X-Gm-Message-State: AOJu0YwutI6rOFFBTynPxgGU4+hKaO+iauFvAa8ObhFwzLOTAhnb4tIG
        1DIyZiFcw/zl8/OMGK+gcH4=
X-Google-Smtp-Source: AGHT+IE8q9T0QFZWQdEfbvIJy8QqOvoNnNJ/2tOQ1A2x9Asl91CGy/lxD72TnZBes+dsnajzXAC6JQ==
X-Received: by 2002:a9d:7d8a:0:b0:6bc:65ad:1b08 with SMTP id j10-20020a9d7d8a000000b006bc65ad1b08mr26718029otn.28.1697214305886;
        Fri, 13 Oct 2023 09:25:05 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id o4-20020aa79784000000b006934a1c69f8sm2520692pfp.24.2023.10.13.09.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Oct 2023 09:25:05 -0700 (PDT)
Message-ID: <cc40e03a-1e43-4659-8579-1b9d22d7c34a@acm.org>
Date:   Fri, 13 Oct 2023 09:25:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
Content-Language: en-US
To:     =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?UTF-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?UTF-8?B?TGluIEd1aSAo5qGC5p6X?= =?UTF-8?Q?=29?= 
        <Lin.Gui@mediatek.com>,
        =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
References: <20230831130826.5592-1-peter.wang@mediatek.com>
 <20230831130826.5592-3-peter.wang@mediatek.com>
 <5afd3b643d75cd3a65adba84b2d31ef355e58abe.camel@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5afd3b643d75cd3a65adba84b2d31ef355e58abe.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/23 02:42, Peter Wang (王信友) wrote:
> This patch still need your review.

Hi Peter,

Although I can see that patch 2/3 made it to lore.kernel.org, I did not receive
that patch in my mailbox. This probably was caused by an issue by the mailserver
I'm using. I will download the emails I'm missing from lore.kernel.org and review
these patches.

Thanks,

Bart.

