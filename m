Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FE7C2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42883206CB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfLZRiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 12:38:04 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45629 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfLZRiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 12:38:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so13122993pgk.12;
        Thu, 26 Dec 2019 09:38:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MmHJMhL/ClL96dvLO618jh4MTLRMaTH5YzPmbcG1nUg=;
        b=ZO3Rv0C50UXBL6RWaXWzq+ZCqY/T+7zZ57OVkuIz/sV8V3t3Doc0SGBdEAERdTajc4
         4h+1EMcEddkq5O66UWV0Vu/ecMfsHP906rq71gYoADeoTCL2yCnT/BuT77jd5W/PhLuF
         N8aDEdQd7otn+OIw/IalJ+bXwhfTWS5IQqorN9Y1ZaS03c0Iy9dlgNK6IV4W7SjLc5Ik
         HQdcijWvaRpO0W0k+dd+28nwby6lCtprS79qcB8/gLIkmmlCGM+Jtt9Nu1EnYhkNBrh8
         xmdlGDijR+8rn/wUdUvqdPTKQRvEPyjH6y033W4nhJMiQzgxMbrBpqaWO+5S4V6tybIU
         kMvw==
X-Gm-Message-State: APjAAAV4ugo0llhusl/Pwraw22eGGfF2EdV6YqyoB2zLFiedSDrZAJrn
        bAAfGRY4pFLjb0xxxh6u6BjI5MlnVck=
X-Google-Smtp-Source: APXvYqyascaaQ389fbn+3f8vAXtesPLJnuQSNGE9PhWj5Y6WVbwdID0iWpamDa9hSnWdFNKZeQ0HZw==
X-Received: by 2002:aa7:946c:: with SMTP id t12mr40719359pfq.137.1577381883806;
        Thu, 26 Dec 2019 09:38:03 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q193sm33834849pfc.132.2019.12.26.09.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 09:38:02 -0800 (PST)
Subject: Re: [PATCH v1 1/2] scsi: ufs: unify scsi_block_requests usage
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, pedrom.sousa@synopsys.com,
        jejb@linux.ibm.com, matthias.bgg@gmail.com
Cc:     beanhuo@micron.com, cang@codeaurora.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
 <1577192466-20762-2-git-send-email-stanley.chu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <96961682-9455-907d-753d-40c87cfc6b15@acm.org>
Date:   Thu, 26 Dec 2019 09:38:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1577192466-20762-2-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/24/19 5:01 AM, Stanley Chu wrote:
> Currently UFS driver has ufshcd_scsi_block_requests() with
> reference counter mechanism to avoid possible racing of blocking and
> unblocking requests flow. Unify all users in UFS driver to use the
> same function.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
