Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C3EC48BD1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A3EB611CD
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFKVCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:02:24 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:38516 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhFKVCW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 17:02:22 -0400
Received: by mail-pl1-f174.google.com with SMTP id 69so3439623plc.5;
        Fri, 11 Jun 2021 14:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UTbXsK93IZjyYVVcjQEim5P1dHkJ7MA+eHvxSWtW8+I=;
        b=AEqEU7p5kZwqbpprSFMxeFIR0dIuL1IDMDHIlhiepXj7r0iYamYTspsJ884Jkxn0lw
         Lh+frTbfOhlP/cqFKVPRTEenkBiPdhWOKk8w5SQuBcZnp8kgkBu5sCbJpWfQV7xLb3VW
         Ho2P92YAoP1AawuSHaRURHbCj/mCWJ9QLjroviyEWdgrsrlQtoiL3xxF1UXC92UE61Ww
         ockOJ++z9wJu8nACfwFbPXrCDjk2EHDVxJFTu/Njn2Z8F9sse9ao/EbMBUMeFUvjmcoe
         pQ/HP2suvC+xasYLJVMcz1bKj1fDyuXESTUQZmdt+oExauW6t/SAKzfdq4bMbTbxxIij
         Xx+g==
X-Gm-Message-State: AOAM531jdQu3utIiyM1qJF5jhqriWDrd54Z/u3fHhgYQnb7ncUqWtlZ+
        9b1eqgY6LcO8T5Wn2TghlG8BMFtCcQc=
X-Google-Smtp-Source: ABdhPJy92fkJqc6Vz14EEY9zeZJouNqTbvvGydMCPTa0gZDSCSwcpT+G/B//kP+yC++m/46zKmDEjw==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr4127419pjb.192.1623445223215;
        Fri, 11 Jun 2021 14:00:23 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c15sm6430143pgt.68.2021.06.11.14.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 14:00:22 -0700 (PDT)
Subject: Re: [PATCH v3 7/9] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-8-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b480d5a9-463d-9c51-8fd6-a2cff3396dc7@acm.org>
Date:   Fri, 11 Jun 2021 14:00:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-8-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/21 9:43 PM, Can Guo wrote:
> UFS error handling now is doing more than just re-probing, but also sending
> scsi cmds, e.g., for clearing UACs, and recovering runtime PM error, which
> may change runtime status of scsi devices. To protect system suspend/resume
> from being disturbed by error handling, move the host_sem from wl pm ops
> to ufshcd_suspend_prepare() and ufshcd_resume_complete().

If lock_system_sleep() and unlock_system_sleep() would be used in the
error handler, would that allow to remove host_sem?

Thanks,

Bart.
