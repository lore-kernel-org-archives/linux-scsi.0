Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53936C6FA8F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 20:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbjH3UEI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 16:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240241AbjH3UD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 16:03:56 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0904251550
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 12:44:34 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c1ff5b741cso194865ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 12:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693424606; x=1694029406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7GpDWXjt97ECSFVXng+31f5cy+/s0jhYwD4ACEqG5Q0=;
        b=lUguMu9/gOh5zoByrSiodmaqzn+eyZF3K8AA9YlQssL5BzIOLfNY+kEGBzlNgSQYJ4
         Ih1//TuSugSP60IZQFoFGlpSeHZChEieGr3xcLclFkYv+Ia4wziS9bw6rgCZfXPQGGdO
         jcWWCxPJCq2ZoKyyRE2UoNWzGIhpLkvtYfRbLtREkcbqGfW/JpBR1BkYYY+Dnjp7a4gS
         InlGqWgP+JEdS9O/5/Gmxdpvf4zbqIAS/01ezK/AUjEmI6lMC434VtC56PDr+vmIqycN
         eYhTHGupEgxyx/AekIkUGjn5Q+RWOjd9KGINwfCUFsAf5kOIaL6o0uup4N1mdfhsNle0
         fZvg==
X-Gm-Message-State: AOJu0Yy9O5ULH+cqAXYbx0nA/29uItc3lUoK31tpCJWV3Q6WYXakAciE
        NkEc/daK29njXCpds+bq8D8=
X-Google-Smtp-Source: AGHT+IHahRuD5OROFWtT3YiHqTTv9IwkQK2/Yrp6PejQKzKB4OlP1bvL8YrgOT3dru6EWV3llnHLPQ==
X-Received: by 2002:a17:902:d505:b0:1b8:971c:b7b7 with SMTP id b5-20020a170902d50500b001b8971cb7b7mr3730445plg.56.1693424606385;
        Wed, 30 Aug 2023 12:43:26 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090274c400b001b891259eddsm11427279plt.197.2023.08.30.12.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 12:43:25 -0700 (PDT)
Message-ID: <822010a3-aeb1-4ef1-a2fa-ea100c33b3f2@acm.org>
Date:   Wed, 30 Aug 2023 12:43:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
Content-Language: en-US
To:     =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        =?UTF-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
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
References: <20230823092948.22734-1-peter.wang@mediatek.com>
 <20230823092948.22734-3-peter.wang@mediatek.com>
 <468fb5a4-32d5-42a7-b00f-115044954125@acm.org>
 <3d3ef797414961e2eb6bc9d6dbfd45a32e7381eb.camel@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3d3ef797414961e2eb6bc9d6dbfd45a32e7381eb.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/29/23 20:00, Peter Wang (王信友) wrote:
> Second __ufshcd_suspend_clkscaling is called from ufs wl suspend, which no on-going cmd.
> 
> So, it should be not a problem. (cmd finish suspend clock scaling racing with new cmd start busy)

This patch inlines one of the two __ufshcd_suspend_clkscaling() calls.
I think it would be better if both calls are inlined.

Thanks,

Bart.
