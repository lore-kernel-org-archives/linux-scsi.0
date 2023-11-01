Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E7DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Nov 2023 16:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbjKAQnM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Nov 2023 12:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjKAQnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2023 12:43:12 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11627FD
        for <linux-scsi@vger.kernel.org>; Wed,  1 Nov 2023 09:43:10 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1cc5fa0e4d5so26107815ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Nov 2023 09:43:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698856989; x=1699461789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hPOQZlvw3BcSSpnrd8wYwg53cDvrgl5nUa5TR1/nNZg=;
        b=airuE2NAV3fEese1XSgaauK8nnSdLO3pWEvgSctMDn945UJ7ZeyD+lrctUJuw7fcLs
         /VM1/u5HD2Ut8uMU1QYDGjuZtnEaMGPv66rToeKnL+SDHZaQHbK4OOnSfZTWdvkHgH5/
         8UR0OBFtgCqT1lpkxHRXNdIh8rYniPR9ihoIBvpLkM+Fsv2rFpPdY9LfoOg7PlFi+MuK
         8rVlxOIud7lMu9jJRw0wffZHbWnEf+14c+2lRuxgDA+vzrTtMDorQuPIyIYSYe3leAv5
         gR1ZGiiqabrX00pGN+8ejOWRiEUXp2+cHAi8K24prPrNgkd3oxUduCE+lOyWlMGbap3R
         /6zw==
X-Gm-Message-State: AOJu0YwUie6TMglOMBjUYhxinI/Eh6/m0BUQqeoofBzHwVUpryCm0IGp
        vJy9Nr0xsDY0rSbtSbb3ovQ=
X-Google-Smtp-Source: AGHT+IG+aiAAzhVO22whKed840rK787QYvtevzR+4cgYsZV8I5mZUJqxEcpulhL6Lg1zTSM4vxzQjA==
X-Received: by 2002:a17:902:d4cf:b0:1c5:ec97:1718 with SMTP id o15-20020a170902d4cf00b001c5ec971718mr20583344plg.6.1698856989343;
        Wed, 01 Nov 2023 09:43:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2312:f48f:8e12:6623? ([2620:15c:211:201:2312:f48f:8e12:6623])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902e74a00b001cc32261bdfsm1546433plf.38.2023.11.01.09.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Nov 2023 09:43:09 -0700 (PDT)
Message-ID: <f1be8bb5-7fac-45b3-a428-d5ba9b1ec260@acm.org>
Date:   Wed, 1 Nov 2023 09:43:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Add compl_time_stamp_local_clock
 assignment
Content-Language: en-US
To:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        quic_asutoshd@quicinc.com
Cc:     linux-scsi@vger.kernel.org, orsonzhai@gmail.com,
        yuelin.tang@unisoc.com, zhenxiong.lai@unisoc.com,
        zhang.lyra@gmail.com, zhewang116@gmail.com
References: <20231101071420.29238-1-zhe.wang1@unisoc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231101071420.29238-1-zhe.wang1@unisoc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 11/1/23 00:14, Zhe Wang wrote:
> The compl_time_stamp_local_clock assignment seems to have been
> accidentally deleted in the previous patch, so it needs to be added
> again for debugging needs.
> 
> Fixes: c30d8d010b5e ("scsi: ufs: core: Prepare for completion in MCQ")
> Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8382e8cfa414..b35977fa931f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5388,6 +5388,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   
>   	lrbp = &hba->lrb[task_tag];
>   	lrbp->compl_time_stamp = ktime_get();
> +	lrbp->compl_time_stamp_local_clock = local_clock();
>   	cmd = lrbp->cmd;
>   	if (cmd) {
>   		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))

Is anyone using the data tracked in compl_time_stamp /
compl_time_stamp_local_clock? I'm wondering whether the code for
tracking command duration can be removed. Otherwise the above patch 
looks fine to me.

Thanks,

Bart.
