Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3080CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 16:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F4D6137C
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 16:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhJTQW4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 12:22:56 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35620 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhJTQWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 12:22:55 -0400
Received: by mail-pl1-f177.google.com with SMTP id b14so6719207plg.2;
        Wed, 20 Oct 2021 09:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gwe26f0uHWIb2EXdInAVFnC6YqpmWPztL4pxXFY1l3U=;
        b=qISUkfRYRJknnfi5EgeOJ/6tEV+E6ONhjjuhFVr/N+Qs7zJkuR0JPpqkxlcoN2MrEs
         Y1uKBfX1I6F8rsIuTR30tMhuebxtYtrz+x8DdlpcjLsexuGYYk41mlb2Vh+CFPh+2SSX
         tO0WQZpnGoO/kg1378SNYjdJyxVfYyXGs+IYa02wBPhPyddRl9F6BCIdCkPc+6/sxvAq
         PkGSyoLjsWJmE3dTv4DNYo2+gUwutPquG04I7m4vokUj8I314xNwhHydS/se/Lrbs+Bo
         262bkknHFGnFNPhkv4RRxDnBndsAojqCG7ikREzyb4kwAcl/GVpNnsAfEPN5Oh4WzlZ6
         KZBQ==
X-Gm-Message-State: AOAM530pv8LTxmBuRmwer7dq5gC3Z6bjM06eHAjjVDM/+caIyDsMWWJ0
        Sb67l7WNxgY4CoLCdsD+Cqk=
X-Google-Smtp-Source: ABdhPJyEHckUpU0nwxgmZB4AB9ndVrztFwIvco7PdY9QNueuXNfrbakZmY6HxBtPnsG5EZRyd1RPuw==
X-Received: by 2002:a17:90a:a08d:: with SMTP id r13mr8287840pjp.191.1634746840441;
        Wed, 20 Oct 2021 09:20:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id d12sm2557920pgf.19.2021.10.20.09.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 09:20:39 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: fix memory leak due to probe
 defer
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     draviv@codeaurora.org, sthumma@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org
References: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <22209a52-c113-270f-3102-bdf95910f841@acm.org>
Date:   Wed, 20 Oct 2021 09:20:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/21 2:22 AM, Srinivas Kandagatla wrote:
> UFS drivers that probe defer will endup leaking memory allocated for
> clk and regulator names via kstrdup because the structure that is
> holding this memory is allocated via devm_* variants which will be
> freed during probe defer but the names are never freed.
> 
> Use same devm_* variant of kstrdup to free the memory allocated to
> name when driver probe defers.
> 
> Kmemleak found around 11 leaks on Qualcomm Dragon Board RB5:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
