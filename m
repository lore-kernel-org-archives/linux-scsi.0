Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38849C43462
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 16:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 185A661183
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 16:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhENQRQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 12:17:16 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41686 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbhENQRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 12:17:15 -0400
Received: by mail-pg1-f176.google.com with SMTP id t30so3104623pgl.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 09:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NUlgQqhkJTMJ7G+g7x0B55IFAd7gBKvmwdKHeHteeCk=;
        b=QugawDDIdok8u6bp4Q0VM9sbZiZuNIP5fYm7u982ZNTO4api+N8pQGu9EbUU5Q9VtJ
         Ehb1BbLRUhBnyQC0eTT3ZuzN5Bbonr7p0I7vJy0aR5zrnDN1nEzov3YXJpdLyJ5e0pjq
         oNlVLVTmSXLjxIwRx2VZH4P77XnFMpV1mstM6MQqyBCrhP9NnwJ1pSYn1j1X7OKceYvF
         eJkKl6t92NU7x9GSoW8xgIQ+QrTm/l3utMNOQeHHu/weC76YrbScfiFfHjKOpDfYNQch
         JBDbIgtQl+U2qeat/MCovWJ0fwJiwvzyM0U3oYRqhQwZoZTXCBMpT2feKRWzZ+Z4lGq2
         Yitw==
X-Gm-Message-State: AOAM532LIV7M4CxVVBpUL58ZJRrKNs0E7Z7o7pGVzMOwATR3miFwhr//
        shEPb7TAR74ix7Me9wn9XwQ=
X-Google-Smtp-Source: ABdhPJxU3rAG9j/NJWWBkOdMN2oXOPgpGSNys3I3i58BJnvFd/kbZXHO+OgT2fwUcCX3kd77Zcm01g==
X-Received: by 2002:a63:5b08:: with SMTP id p8mr1030711pgb.193.1621008962645;
        Fri, 14 May 2021 09:16:02 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:e40c:c579:7cd8:c046? ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id b17sm4465415pgb.71.2021.05.14.09.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 09:16:01 -0700 (PDT)
Subject: Re: [PATCH] ufs: Fix handling of active power mode in
 ufshcd_suspend()
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
References: <20210512195721.8157-1-bvanassche@acm.org>
 <7e4e33158be2e5bfc8260c47202b45d9@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d710992a-8cd1-4c84-94fc-235127d344d4@acm.org>
Date:   Fri, 14 May 2021 09:15:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <7e4e33158be2e5bfc8260c47202b45d9@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 6:35 PM, Can Guo wrote:
> The change is unnecessary, ufshcd_suspend() is indeed keeping link alive
> even if
> we are disabling clocks. In __ufshcd_setup_clocks(), we have checks on
> clock sources
> so that we leave certain clock sources ON if the link is alive. And we
> have many
> of our customers tested the case rpm/spm_lvl == 0, it is working well.
> Please check
> below changes:
> 
> https://lore.kernel.org/patchwork/patch/1345336/
> https://lore.kernel.org/patchwork/patch/1345337/
> 
> With this change, after suspend (rpm/spm_lvl == 0), leaving clock gating
> running is risky:
> 1. clock gating may run into concurrency with resume.
> 2. In ufshcd_resume(), we also have a ufshcd_release(), it will cause
> unbalanced usage of clock gating.
> 
> And it seems quite opposite from what you want - you want to keep link
> alive but you are leaving clock gating enabled, then when clock gating
> kicks start, it will put the link into hibern8, but not keep link alive.

Hi Can,

Thank you for the detailed feedback. I will drop this patch.

Bart.
