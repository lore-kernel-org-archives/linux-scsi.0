Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153FBC00140
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Aug 2022 16:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiHXQfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiHXQfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2022 12:35:53 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6655185FCB;
        Wed, 24 Aug 2022 09:35:52 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id y4so16133492plb.2;
        Wed, 24 Aug 2022 09:35:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=jwlvGORH25WcTECUWBCGNYWqLL1KZ4/HvuRj9Nzjm8A=;
        b=xDo8P5XefoJiNy27t/WIxqogN0ZjIz7DP3duy+Wifvc/mAm4juNVvajr6H9FEdbRjk
         EiBnLz34R2UQRuI98Rrc+XTiruy0DzO71n9i7odSL4BBgfVhXuauRYgW7PQWJDsLcPiJ
         GH0PKpSvgBiYLpGLpyme8OOR6VKJcLR45NTAqOV8CBRaNjdHDqGTu45Szi6P1HqCPSUC
         ZJ89N+DfqLNu0HgcDN1s3Z4gYJRrfYWUCYBsEsy0mqT+t5ZMoD08ANQ+f8zhqXMm0tnm
         We+MctF4fDghCdJr+OEF1PeCeN/q2z6FDqcTkndoyeAGmajNU8OyYUG7OzocKMpDpODq
         NF0g==
X-Gm-Message-State: ACgBeo07w5pjBm1S0XlsxL/CNksU9X22VIpjn+7T91kW8nupTREwLSfW
        9u2rD64tUQ9JDTP6N7611yo=
X-Google-Smtp-Source: AA6agR7cFvbLgAxov4hsRdF5TM32DeU8TG8mf7muUOP37BSTlFaoEP7FCFidPWVPdhhMOjY0loaRbQ==
X-Received: by 2002:a17:902:a60c:b0:171:407d:16f8 with SMTP id u12-20020a170902a60c00b00171407d16f8mr29440776plq.58.1661358951774;
        Wed, 24 Aug 2022 09:35:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:222f:dc9c:99a3:dfb8? ([2620:15c:211:201:222f:dc9c:99a3:dfb8])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b001730cf6f839sm2905791plg.70.2022.08.24.09.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 09:35:50 -0700 (PDT)
Message-ID: <28a43c43-79d0-3331-a067-0336270c4372@acm.org>
Date:   Wed, 24 Aug 2022 09:35:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: ufs: ufsfbo: Introduce File Based Optimization
 feature
Content-Language: en-US
To:     Jiaming Li <lijiamingsofine@gmail.com>, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijiaming3 <lijiaming3@xiaomi.com>
References: <20220824084633.14428-1-lijiamingsofine@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220824084633.14428-1-lijiamingsofine@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/24/22 01:46, Jiaming Li wrote:
> +#include "../../../block/blk.h"

Without having taken a look at the rest of this patch, including a block 
driver private header file in the UFS driver is unacceptable.

> +#define FBO_INFO_MSG(fbo, msg, args...)	do { \
> +		if (fbo->fbo_debug) \
> +			pr_info("[info]%s:%d:" msg "\n", __func__, __LINE__, ##args); \
> +	} while (0)

Please use pr_debug() instead.

> +#define FBO_ERR_MSG(msg, args...) \
> +	pr_err("[err]%s:%d:" msg "\n", __func__, __LINE__, ##args)

Please use pr_err() directly and remove the function name and line 
numbers from error messages.

> +#define FBO_WARN_MSG(msg, args...) \
> +	pr_warn("[warn]%s:%d:" msg "\n", __func__, __LINE__, ##args)

Please use pr_warn directly and remove function name and line numbers 
from warning messages.

Thanks,

Bart.
