Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6819FC4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 20:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DB61613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 20:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhEYUQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 16:16:55 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40461 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhEYUQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 16:16:55 -0400
Received: by mail-pf1-f176.google.com with SMTP id x188so24478939pfd.7;
        Tue, 25 May 2021 13:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xjyrkNstyxFQKqfWq5lLR6k4iAnQVrfBsjAIBO8yIB4=;
        b=h9YHkV6kGGk1GaqC+Cxy1CSAdAvBrTGG9j51ppv2LFv+FZY/4MZbKru37XhLseBSbU
         qvy5H/GZ05pknq/GQRPVhVRxClRJo0u4gMFt/fWTGAwcQMMROHj/qRUnTnC7Zu5oba4/
         dDJ+ZsECfPkYU03nnBpPMahdiNjVLHdLLf1Y8oRR8T3VaUJD9S5rgbZ4h929uj1Eq1dM
         ti1FWis1gA0kYIg2kzE3KzL2Xc22xi2obexlUZZO/yokSIJfmzrf/cE+5cvU3zz2vnNv
         x0MNd7o2MOCIF6Mr0Iy7ad1FKDHkLa+g5lKC3QOEqGtkhX7xP2C7Hc2Rq0yfbpEsH2O7
         vaxg==
X-Gm-Message-State: AOAM531sNSlhUDQFL+AjSr1w/PhIK1apRnxEkav1tGv60ohwh+Y2syst
        6KwmpwjNqhYqMqObChbMOccV5UD5cQw=
X-Google-Smtp-Source: ABdhPJyelylIzUHjSXaLGdhQplZRKDRMl5sCwADV8hpM5I8BV+pXeZNAAJrgE4AkDRStnCQSqmRABA==
X-Received: by 2002:a63:7c57:: with SMTP id l23mr20576646pgn.429.1621973724162;
        Tue, 25 May 2021 13:15:24 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z22sm14862499pfa.157.2021.05.25.13.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 13:15:23 -0700 (PDT)
Subject: Re: [PATCH v1 1/3] scsi: ufs: Let UPIU completion trace print RSP
 UPIU
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210523211409.210304-1-huobean@gmail.com>
 <20210523211409.210304-2-huobean@gmail.com>
 <628c0050-e3e2-033c-8a25-6fc04d4d5657@acm.org>
 <f285211d2b8ef2c9c3c01974c91b7b7439b0fd0b.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c1ea61e7-d269-28da-a2f9-8b59abe787c8@acm.org>
Date:   Tue, 25 May 2021 13:15:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <f285211d2b8ef2c9c3c01974c91b7b7439b0fd0b.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/21 12:28 PM, Bean Huo wrote:
> If this is problem, I can change the code, let them more readable.
> 
> how do you think?

A long explanation was needed to show that the patch is correct. I think
this shows that the code is confusing :-) Hence please use the struct
utp_upiu_rsp type when interpreting a pointer as a response.

Thanks,

Bart.
