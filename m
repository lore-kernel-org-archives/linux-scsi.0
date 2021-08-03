Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362E9C4338F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 18:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04EFA61050
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 18:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhHCStV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 14:49:21 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:40862 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhHCStV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 14:49:21 -0400
Received: by mail-pl1-f177.google.com with SMTP id c16so158476plh.7
        for <linux-scsi@vger.kernel.org>; Tue, 03 Aug 2021 11:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zHkfgYI2cETb9XEOzI7SWa4JaICpv8jwfx07tHvyu6E=;
        b=Upu/wN1fGq7mYRgFyW7p6JBkqEFxjuiHfQggnsdBBc5MlEGuZfZw3anDUpQJ0UcSN8
         YG+Zt3+8JzyNp7PTVDi53fzyTrZRLXAAOOuKU7x7W+oF3zTKVPLQfDcawJkUtrCSwH5a
         QATMVjOmw2TT29T+/Vs5D4CJSdlFI1OpucqU0x2/KSp8Sta2ntJIHn5aFwiKM4JcIeyt
         wQXN0MBRPBCKt1mo3FnD2pQ/bdeUJ1E4hzKw6we8/rf/SXvd7nvULAxRArBniT7jjCsD
         5Y7UISAOibYca04OZoo8X5TiGX02sKcRlntHXXTipg8lIiPgCVCrOJMl6hevi0ArywPD
         hYDg==
X-Gm-Message-State: AOAM530yd86vQGj3v8s+Ysy1ZUAtbTcSZZnWno05uXAZrH9Tnst1FTt8
        mI7uhxV2RPf45ZquBZJOJ4s=
X-Google-Smtp-Source: ABdhPJySM5yFIAignX3Rj5wXXaYMCwXmnHVsvVLPnKkKDxHsQUnJIIsUuGEx5EydxeUigAL4CfG+LQ==
X-Received: by 2002:a62:6103:0:b029:396:f515:94bf with SMTP id v3-20020a6261030000b0290396f51594bfmr23608728pfb.4.1628016548621;
        Tue, 03 Aug 2021 11:49:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:f630:1578:90bf:ff92])
        by smtp.gmail.com with ESMTPSA id t9sm19646474pgc.81.2021.08.03.11.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 11:49:07 -0700 (PDT)
Subject: Re: [PATCH v3 11/18] scsi: ufs: Revert "Utilize Transfer Request List
 Completion Notification Register"
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-12-bvanassche@acm.org>
 <779aae9841331229e29fd3be23de55cec776af16.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e42d41ca-5dcf-4492-c170-8e69aff82b09@acm.org>
Date:   Tue, 3 Aug 2021 11:49:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <779aae9841331229e29fd3be23de55cec776af16.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/21 8:24 AM, Bean Huo wrote:
> I did the comparison test on my platform, it is very difficult to get a
> very clear and fair result between two changes. but lamely speaking, on
> the small chunk size read/write, your changes wins. but on the big
> chunk size, It is not very clear, the gap between the two changes can
> be ignored.
> 
> Tested-by: Bean Huo <beanhuo@micron.com>

Thanks for having tested this patch :-)

Bart.

