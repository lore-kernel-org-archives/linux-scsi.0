Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A374BC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 703AE6140F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhEYQmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 12:42:09 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:37882 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhEYQmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 12:42:08 -0400
Received: by mail-pf1-f178.google.com with SMTP id q67so6991408pfb.4;
        Tue, 25 May 2021 09:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6kZjbGQduH1O16Py6H5dph2xaDYJhSr3BHluI3PjlOA=;
        b=QHcUQCDgZ+6bYQJlLahxOJHBGDJCoNAtj612tuFwLx4CWota6Srq2SLb1UZ24vpIM1
         hEI2vEuh6LUG/Dg8ge4TtUwaVRtsvpvwDueKC5tXmbGVnPHr2JP7D3OXTTZaBxHVxjl4
         jKmI1InCtK0oTb8gI4jJujzXawej6qSOT3s1TFaF/rMApG+YGYO6zWx7PKmWUuTyFVeL
         QnpxKLbsROJWcd8Qc+PxUmEovnkTCQ1hMVYuY6raXGoPuqK5dXnKZhj7wm97oFCiSS4s
         iFX3me0gRAiHMd19tVGBZm6ByL24/1Ggq84BtST85uJyN1WXOLDThOJFytCzDd7W7cY2
         7oLQ==
X-Gm-Message-State: AOAM532yoW0XVUxrmEIK+RD6EWBDrItF5kdXLldTpbmGnmmT5BgCMndJ
        6DOO8HWNCHWmxWaJHVDwUUs=
X-Google-Smtp-Source: ABdhPJwUxMVTVripchYVIdxI3dqkr1pmOUf575UZmWTQuIyVLkEdUNT5IcevXy/8DJy9E0iX+RFPzw==
X-Received: by 2002:a65:6156:: with SMTP id o22mr19679020pgv.71.1621960837224;
        Tue, 25 May 2021 09:40:37 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i16sm12897203pji.30.2021.05.25.09.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 09:40:36 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <41a08b3e-122d-4f1a-abbd-4b5730f880b2@acm.org>
 <0cfbf580e340073ff972be493a59dbe7@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c254b5bf-62ea-4edf-f600-db6789c747b1@acm.org>
Date:   Tue, 25 May 2021 09:40:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <0cfbf580e340073ff972be493a59dbe7@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 6:40 PM, Can Guo wrote:
> Agree with all above, and what you ask is right what we are doing in
> the 3rd change - get rid of host lock on dispatch and completion
> paths.
> 
> I agree with using dedicated spin locks for dedicated purposes in
> UFS driver, e.g., clk gating has its own gating_lock and clk scaling
> has its own scaling_lock. But this specific series is only for
> improving performance. We will take your comments into consideration
> and address it in future.
Thanks!

Bart.
