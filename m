Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D09FE7E657
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 18:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbjIZS02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 14:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbjIZS0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 14:26:25 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551FF139
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 11:26:14 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1c5db4925f9so67848825ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 11:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695752774; x=1696357574;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xl1U0WnWv7CVK/dI95lm23Xs7owtUtSpF/m8xxdGys4=;
        b=AS95kqj9riR4FE2e3fp0xDgVvD+MqXfGBms5Rs2wjGA8cZYgZyEfalBaiJQHVz+nGS
         SoZ0JxlY2Sw+s4nhV0hzlOJvUr4qKHGs+ermWc70NZlth5LTkc0NI/6MT4jVRMnD1IVT
         ADkFgUveXUnehwwN5PmyeG/UtrVwcE+BUJo1HizxGD4ppykwyJPjNZomF0PDiOyhQoTt
         DUGvnYKciO9lloiTUtqkEl6MUaA9VMu18qf4ZtVmf9wp22fvJRX0aRazV4GV1G73qBSu
         0Wp13LusjHj4AETRSr2W6pNwSy1gnyAfu7XW1wMzhI4V3g4wERyq+Qv+9oJrxmJaMYbY
         0W9Q==
X-Gm-Message-State: AOJu0YzeY6AgEh4nRlvqYlMt1aQbenoD2Aamz9hWM30aQeaZEuadUUOW
        kr6PtsJqPgnII78d7uA7ggU=
X-Google-Smtp-Source: AGHT+IHYrJdQUDHx73OhSRD/F+JxB8wOjiVoxbN8uwCENvyv7D/uar47pmna4KdPc3Yjpg2msFVYrg==
X-Received: by 2002:a17:902:d490:b0:1b8:a67f:1c15 with SMTP id c16-20020a170902d49000b001b8a67f1c15mr5965201plg.25.1695752773586;
        Tue, 26 Sep 2023 11:26:13 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a80d:6f65:53d4:d1bf? ([2620:15c:211:201:a80d:6f65:53d4:d1bf])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001b531e8a000sm11312541plh.157.2023.09.26.11.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 11:26:13 -0700 (PDT)
Message-ID: <b89fbc92-987a-4a08-95a3-060b26393097@acm.org>
Date:   Tue, 26 Sep 2023 11:26:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ufs: core: wlun send SSU timeout recovery
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
References: <20230922090925.16339-1-peter.wang@mediatek.com>
 <10bf17cf-8a92-469b-bc5c-1f0dba0ed5ed@acm.org>
 <39e0a8b6d6f235dfa7dd36a4436c9eac5ab5210e.camel@mediatek.com>
 <98f256e3-72f7-48cf-8d25-58781d7051fa@acm.org>
 <93ea4b18ddb010547d3170c73403b3e9985795f4.camel@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <93ea4b18ddb010547d3170c73403b3e9985795f4.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/23 03:23, Peter Wang (王信友) wrote:
> Yes, but ufshcd_err_handler will wait runtime pm resume to actvie if
> concurrently run with runtime suspend or resume.
> (ufshcd_err_handler -> ufshcd_err_handling_prepare ->
> ufshcd_rpm_get_sync)
> So, if runtime suspend or resume send SSU timeout, scsi error handler
> stuck at this function and deadlock happen.
> The ideas is, if runtime pm flow get error, do ufshcd_link_recovery is
> enough.

Thank you for having provided this clarification.

Bart.

