Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C59DC6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 20:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjC2UrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjC2UrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 16:47:13 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838D0448D
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:47:12 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id iw3so16112541plb.6
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680122832;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BNnjqFq47OKyG2LCZtN0y6GwuxCrTxQ23BaJuG9I48I=;
        b=te5JemoCYEhoNC0pe2cex2xCa2wSkbBNT0w5WcrqOO+0ebEMaWY+ZVn14Bf3Ca5+Eh
         E3Z2lwbLE+KDKZtamsitdcj2Yv3fPI3UhZ8DR4LLxDf0YjngZACOS8VJednt89szjoOI
         xW5E+gdO5CFb0ayLaJya9+eVesWu44+alq/Lbj/wyV51LklE7EDBxhrlkc3ONu8zHi9H
         /D6CoQZHieCxwf4iU+GaMBfwfsL+jCFSLqHI6GQnEWhIepfYshwqrYbkYJ7iSicrez9Q
         aBbNRuOnDF4hj62mT6i+fma5PnDP0tEfYV+0LJtOZz1qf5PxOS+ToRFEKrJfpIziMPQs
         MgyQ==
X-Gm-Message-State: AO0yUKVydXmcx2HuOKAPWwkSJVwL1WXoLlT3aF+tdNeLIYGfJouPYB02
        O1QNeeZp55Q98TPOxa0RQlo=
X-Google-Smtp-Source: AK7set9RuM/kjqzucgbJOGY6yeH+UL3RH71RJ4+99WZ4kRFABDqddOPb0EyHXjhm7BV+0IEqq/qY3w==
X-Received: by 2002:a05:6a21:86a9:b0:d9:3257:f2b3 with SMTP id ox41-20020a056a2186a900b000d93257f2b3mr17175293pzb.40.1680122831783;
        Wed, 29 Mar 2023 13:47:11 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:c058:cec1:e4c9:184e? ([2620:15c:211:201:c058:cec1:e4c9:184e])
        by smtp.gmail.com with ESMTPSA id j36-20020a635524000000b00502f1540c4asm21846765pgb.81.2023.03.29.13.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 13:47:11 -0700 (PDT)
Message-ID: <16c79431-0a04-6d07-9965-b3af400b8329@acm.org>
Date:   Wed, 29 Mar 2023 13:47:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1 0/5] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <cover.1680083571.git.quic_nguyenb@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cover.1680083571.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/23 03:01, Bao D. Nguyen wrote:
> This patch series enable support for ufshcd_abort() and error handler in MCQ mode.
> The first 3 patches are for supporting ufshcd_abort().
> The 4th and 5th patches are for supporting error handler.

Is this perhaps a resend of v1? Last time this series was posted it had 
version number 3.

Thanks,

Bart.
