Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADC3C4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 20:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiLDUCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 15:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiLDUCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 15:02:44 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E1B6374
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2022 12:02:42 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bj12so23221444ejb.13
        for <linux-scsi@vger.kernel.org>; Sun, 04 Dec 2022 12:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iKviG0l7TUDz37Qqdid8G/FA6WnhkvY6eNdb5QDsL34=;
        b=axNMmq1WXroii/XhJ4xM3ajgD0ifzuAwqYgUr9atJDe02FLz7wapj+u7PgG4rBs8Ko
         13Y+R0EGC1mrdTjvW0Caaj044p8zUPFsE5zRnlHsgp6QG7NZqQlypfM4r3otR4urLAAH
         98OmqCBJVRQVOu7/GqdOZ0h+ZlxhFlZfuwJqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iKviG0l7TUDz37Qqdid8G/FA6WnhkvY6eNdb5QDsL34=;
        b=YamzyYRVHkPvjxP8gDVv09+EIQ6Wc5fqmvPDQHHxRaEWefbFyFytBKckPx3YHaeobl
         62X3HHI72xR0k8WyHiwqHITkt5mLgpwX5pwe5n45d3nanQnTUsLrF/pfLKUcG2OTQ415
         KvKiIXWWFPBOyMv9J2YhYGimp7dfECeQ01lJ/xtPPrMBkH6UcfM6U5mcSQEg4vZDMHRx
         KhXE8mlcJyhDFyU9hApIqx3Y1xs3UK8nnf+P5La1kP+Y+V6EIcJ5OaDZHlVfWO0mmD/G
         9MhgrwGZB1shISfz27nGBTF/zwFxvRof0d7MyLsSiDmidhucSzNTn+slirH/rTjF7l7v
         pmZw==
X-Gm-Message-State: ANoB5pnN48nhbXfMxwJJ2rnOSlse3fAiL1bbkM+uKMKx/VUsOJgbmviP
        sQMeT+eJUwh+21NsEGWYRg6EHUOlsRjX5iN3mf/qhg==
X-Google-Smtp-Source: AA0mqf4+NKcRQLFYvmgnlKpsVsDkUIBi/wj0qkGYtGxQl5MMPw8cMu9zqWCLywEvdB/EGoTRXoExZA0rBnq25guVhT4=
X-Received: by 2002:a17:906:c18c:b0:7b2:8a6e:c569 with SMTP id
 g12-20020a170906c18c00b007b28a6ec569mr68273173ejz.582.1670184160925; Sun, 04
 Dec 2022 12:02:40 -0800 (PST)
MIME-Version: 1.0
References: <20221101142410.31463-1-peter.wang@mediatek.com>
 <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com> <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
 <CAONX=-e1NA--3taTmfbUV+hR_LOSqvBqz_=1mPmYZWaKGGR=ig@mail.gmail.com> <c92655563231dd79ed6d4287d7d5bad4de142a18.camel@mediatek.com>
In-Reply-To: <c92655563231dd79ed6d4287d7d5bad4de142a18.camel@mediatek.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Mon, 5 Dec 2022 07:02:29 +1100
Message-ID: <CAONX=-d1Hiif9WFuGVQaMr7iUFxOpOSE7bkJriTrqh-Pvtdq0A@mail.gmail.com>
Subject: Re: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
To:     =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
Cc:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?UTF-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> May I have a question, which dievce you use in this failure scenario?
> I think it is same issue due to SSU fail, and wlun devcie pm enter
> error state. So the cunsomer(scsi lu device) is block in suspend state
> and connot resume to reduce pm_only lead to IO hang.
>
> Thanks.
> BR
> Peter

I don't think it is device specific. I am pretty sure it is the same
problem, for it traces to the same origin and your patch fixes the
issue (though with a lot of log spam which is a bit unfortunate, but
we can live with that)

--Daniil
