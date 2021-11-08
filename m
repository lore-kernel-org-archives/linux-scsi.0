Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15C8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C513861130
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhKHS0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 13:26:48 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:39608 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbhKHS0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 13:26:48 -0500
Received: by mail-pl1-f169.google.com with SMTP id t21so16395064plr.6
        for <linux-scsi@vger.kernel.org>; Mon, 08 Nov 2021 10:24:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xmKukzo3xeZ4aJfo7DUHmZNhL16kR3zdJr+sfxdivk8=;
        b=1Jx27FS+bQDgkhMlbAe9Uncjsc43NTM2V5L/QQVXpTQ81TSwUN/b7h/p7Bqh0q9LMA
         RK61gpG/F0D4VbMbaP3Ew52OcCCzIpGrAtygkovixbqwLus3uNYtGF4PSNaxIojJOHB7
         rUUl4f4tjm9IQQpS3m22Th8q/0191EZ6d1KhbuIHKVpSpS9us5qWvx75OC/9yZrWdMUF
         P6SDw5HCK2hqpwue0amhiSiZxk1B28N5//1Hmf04ZNz4hKCW7Gw+qBsu/YcixuHfeSFB
         hNtoHPdNLU1iweXQo6wjYpjA+8oUv4DMUI/p4WJLVbG/JxKRBV1A+ayh7kgGOb9stvp7
         VM0w==
X-Gm-Message-State: AOAM531va7yt9H6gU4aSnuHbmwNBMfEW1HfTXVmBACc0Pn37WO/KMmBg
        WyUgPpGPwWRHRS3fXUXICnZlSKWn7/Zd9g==
X-Google-Smtp-Source: ABdhPJyfHavivo/YoB3ygo/2PefWzUHz5d0JdhQCODE0qDccEnyjq9dON4/5URMwCs7XAKGK2+1ahg==
X-Received: by 2002:a17:90b:1e44:: with SMTP id pi4mr281181pjb.245.1636395842793;
        Mon, 08 Nov 2021 10:24:02 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4ca8:59a2:ad3c:1580])
        by smtp.gmail.com with ESMTPSA id n16sm477600pfj.47.2021.11.08.10.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 10:24:01 -0800 (PST)
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
 <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
 <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
 <d3d70c8e-f260-ca2d-f4c1-2c9dd1a08c5d@acm.org>
 <3f4ef5e8-38e8-2e90-6da4-abc67aac9e4d@intel.com>
 <263538ad-51b5-4594-9951-8bcc2373da19@acm.org>
 <24399ee4-4feb-4670-ce9c-0872795c03ea@intel.com>
 <1a6fef86-9917-ddad-1845-d0406150ecb8@acm.org>
 <4895a54b-6d49-9204-e7b2-336854c83ed4@codeaurora.org>
 <c06be499-fc66-1260-400c-0458eb6de7cf@acm.org>
 <715a04b2-1791-1884-22a8-4ed8c680cfb8@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ab8fdc6a-9d84-8b0f-f9c2-eb71b5441203@acm.org>
Date:   Mon, 8 Nov 2021 10:24:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <715a04b2-1791-1884-22a8-4ed8c680cfb8@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/21 10:06 AM, Asutosh Das (asd) wrote:
> The current scaling code invokes scsi_block_request() which would block 
> incoming requests right away in prepare. So any un-issued requests 
> wouldn't be issued.
> 
> I'm not sure if this exact behavior would manifest if 
> blk_freeze_queue_start() is used and scsi_block_request() is removed.

That behavior would be preserved. The percpu_ref_tryget_live() call in 
blk_queue_enter() fails after blk_freeze_queue_start() has called 
percpu_ref_kill().

> Would blk_mq_run_hw_queues() issue any pending requests in the queue?

Yes.

> If so, then these requests would be completed in the unchanged power-mode 
> which is not what we want.

I will change the blk_freeze_queue_start() calls into 
blk_mq_quiesce_queue_nowait() calls.

Thanks,

Bart.

