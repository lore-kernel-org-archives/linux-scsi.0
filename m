Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E412C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 16:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D0F660F9B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 16:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhIMQKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:10:44 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:43930 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344663AbhIMQKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 12:10:43 -0400
Received: by mail-pf1-f173.google.com with SMTP id f65so9301194pfb.10;
        Mon, 13 Sep 2021 09:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dSc5kQvSxq7QFQ+RxIMy3SGF+ywXK3wh1dZKmtJ3CBQ=;
        b=PG1B7gYD27iIVZoZXo3vNphtY9ootwq1mLSRXtLK2enX1SAbJuZXWS1VNhO+kUOukc
         HVacX7mYNCdOBAb439M4rPMTfIXIxHZbfqiw2vG8hP97IPo/x+kF7W5jVLZUVg2KwFjZ
         kQfeopRJ3+nGaSB9Pkc02iC4cH3D7ttLK8CLy3pZGuTPk+kNXMy0+X+rAQq/tcGhE61j
         HF6pDWat/7vwJTMCFp2q1OUwo6AelThGvTv2dEYMIVeWGyluhdGAawDaSsoh5k5F3+7m
         LjDucUPzC5KjV3nCNVm8pBHI8hhId8pZW1KcxWzAHX/x5/dRSniS1urnA8jznDzFdQcL
         N5BQ==
X-Gm-Message-State: AOAM532ShHppoHC5hkkyXVTAEtx9xRzQyEHtMSJlAoS3HDXLTMhQ89Bv
        cGIAX77IMF22XDVFqpvSEao=
X-Google-Smtp-Source: ABdhPJzWynS+yAvMBvKG4tLvB+cSO2Wvgidxbb75XUDQm2K9/0pHJpnoILgqru/J0gl/P5KUbmguzw==
X-Received: by 2002:a63:f946:: with SMTP id q6mr11840373pgk.42.1631549366800;
        Mon, 13 Sep 2021 09:09:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6765:113f:d2d7:def9])
        by smtp.gmail.com with ESMTPSA id f2sm8579152pga.60.2021.09.13.09.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:09:26 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] scsi: ufs: introduce vendor isr
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <CGME20210913081148epcas2p21c23ca6a745f40083ee7d6e7da4d7c00@epcas2p2.samsung.com>
 <cover.1631519695.git.kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fbdd02bc-01ab-c5b3-9355-3ebe04601b04@acm.org>
Date:   Mon, 13 Sep 2021 09:09:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <cover.1631519695.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 12:55 AM, Kiwoong Kim wrote:
> This patch is to activate some interrupt sources
> that aren't defined in UFSHCI specifications. Those
> purpose could be error handling, workaround or whatever.
> 
> Kiwoong Kim (3):
>    scsi: ufs: introduce vendor isr
>    scsi: ufs: introduce force requeue
>    scsi: ufs: ufs-exynos: implement exynos isr
> 
>   drivers/scsi/ufs/ufs-exynos.c | 84 ++++++++++++++++++++++++++++++++++++-------
>   drivers/scsi/ufs/ufshcd.c     | 22 ++++++++++--
>   drivers/scsi/ufs/ufshcd.h     |  2 ++
>   3 files changed, 93 insertions(+), 15 deletions(-)

The UFS protocol is standardized. Your employer has a representative in the
UFS standardization committee. Please work with that representative to
standardize this feature instead of adding non-standard extensions to the UFS
driver.

Thanks,

Bart.


