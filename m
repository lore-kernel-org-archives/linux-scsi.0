Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D430CC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 04:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4582463B
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 04:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKREiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 23:38:16 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36174 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgKREiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 23:38:16 -0500
Received: by mail-pg1-f193.google.com with SMTP id t21so336681pgl.3;
        Tue, 17 Nov 2020 20:38:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PL94uEPHkPgwoSTEUJTRIWLNjp6IL0BpUZlGz8omUG0=;
        b=C+98vc80BZbtjXpOu2PxS9BhsuTuF5hapx8AIAouAPD+sB+v448AwP5l86ky4aZJjz
         4z3MHklcBCG1lTTn4TvNa4Z+LCClrk9/TVaIZtDXky9y6V/4XL71x8wD8ZfBPmisaAyy
         uQDrnfudyCYsdhc0JayRKvf9UyUxqegKg09fFaLpc75tTFVdHrHWzEpeiIU582ruf2GR
         XI8wlfDRnYgespqwD/14sa35V3l10+u9HoFSNb1ZbMkcLaORtsPVI4uXeaJuGl7ZIbqf
         6wfnlXNMQWhbDWa/62juDSOGO3Coa9b0g7lh/QCJq16wnQYiANgERgB6WgatD3IxWcKl
         gS2w==
X-Gm-Message-State: AOAM532h+CbDiGx3rYzVoJbetaB5SDqXT0JKh9y5Io+5Lw0SR3P7ijmh
        +TscqKv2RL8AFbbjMSJqdeWK1GY5iP4=
X-Google-Smtp-Source: ABdhPJycdQm5sVRY0NmyvKoJHUlSfU28PhA3bdEB9g/SGEJmWN03zqCB7ZXzrkb5VHRuRkvrDp8sjw==
X-Received: by 2002:a63:e00c:: with SMTP id e12mr6376270pgh.441.1605674295582;
        Tue, 17 Nov 2020 20:38:15 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o132sm22760038pfg.100.2020.11.17.20.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 20:38:14 -0800 (PST)
Subject: Re: [PATCH RFC v1 1/1] scsi: pm: Leave runtime resume along if block
 layer PM is enabled
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1605249009-13752-1-git-send-email-cang@codeaurora.org>
 <1605249009-13752-2-git-send-email-cang@codeaurora.org>
 <97dea590-5f2e-b4e3-ac64-7c346761c523@acm.org>
 <20f447a438aa98afb18be4642c8888b3@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6d774277-b055-6924-cf2d-01e874ac3f7b@acm.org>
Date:   Tue, 17 Nov 2020 20:38:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20f447a438aa98afb18be4642c8888b3@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/20 5:42 PM, Can Guo wrote:
> Actually, I am thinking about removing all the pm_runtime_set_active()
> codes in both scsi_bus_resume_common() and scsi_dev_type_resume() - we
> don't need to forcibly set the runtime PM status to RPM_ACTIVE for either
> SCSI host/target or SCSI devices.
> 
> Whenever we access one SCSI device, either block layer or somewhere in
> the path (e.g. throgh sg IOCTL, sg_open() calls scsi_autopm_get_device())
> should runtime resume the device first, and the runtime PM framework makes
> sure device's parent (and its parent's parent and so on)gets resumed as
> well.
> Thus, the pm_runtime_set_active() seems redundant. What do you think?

Hi Can,

It is not clear to me why the pm_runtime_set_active() calls occur in the
scsi_pm.c source file since the block layer automatically activates
block devices if necessary. Maybe these calls are a leftover from a time
when runtime suspended devices were not resumed automatically by the
block layer? Anyway, I'm fine with removing these calls.

Thanks,

Bart.
