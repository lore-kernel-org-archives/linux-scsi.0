Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9103CC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 17:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 768376104F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 17:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhG1R5o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 13:57:44 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:41951 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1R5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 13:57:43 -0400
Received: by mail-pl1-f173.google.com with SMTP id z3so2311800plg.8;
        Wed, 28 Jul 2021 10:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EywUrwmDEYhu/C9G+WVdp4Z5iyUVek4SiiVWGHgmbts=;
        b=tRmjelcdaPFren8gQvK+8oGj6fQEKctZM8E9Opr4FmjZwzKFeB/zFm2ECgYPDpSHEV
         TwTfaK74voCOOb0DERDOUQwVSVrcXDDSsclsVYYEg+ZZXTl2X7bAStUFloiFGzS5mBVQ
         ONkL3kesqUJbWHeOw60aH8nlR7wpcxlnWjs6yWTRMu3M3Ip7JNWeGnOCCEp9KiB0dD2G
         Y2AGpBkcSRgazVTcQ2bayrsK0st2YIok18Gz7c/NC6Z2Pim6ULYy1ECczwa2k2X5alCM
         bwDTv1YAhn4VwgPJbU4ly8vUbQrJrMSvpJ5PzPD88kKpbPYRwmAgrkF2nWxt4c1mi2PI
         9GTA==
X-Gm-Message-State: AOAM5332CQiFiEJJA3y+0BiIg/s1kQlyAe0gJ24jpFWoohoZ0ycejlD6
        b6trZRTIQzSiS6pQC/158c4=
X-Google-Smtp-Source: ABdhPJyme3f78+dFR7yRDsxTQGMO9Iqmm/DCaTI/bhVxUGjkEmYy4jxfd2bMZhpDjNj610DWQ5XuyQ==
X-Received: by 2002:a17:90a:35b:: with SMTP id 27mr915718pjf.209.1627495060727;
        Wed, 28 Jul 2021 10:57:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:3328:5f8d:f6e2:85ea])
        by smtp.gmail.com with ESMTPSA id l1sm381521pjq.1.2021.07.28.10.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 10:57:39 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
To:     Vincent Palomares <paillon@google.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210728012743.1063928-1-paillon@google.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a7091f96-12a3-a244-040a-c41a7c5e3617@acm.org>
Date:   Wed, 28 Jul 2021 10:57:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728012743.1063928-1-paillon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/21 6:27 PM, Vincent Palomares wrote:
> Are there any suspend/resume dependencies for UFS drivers not tracked by
> the device parent relationship?

Not that I know of. Since I like this patch:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
