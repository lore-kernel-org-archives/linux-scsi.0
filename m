Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A105C7EE2F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 18:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbjFLSVX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 14:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbjFLSVW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 14:21:22 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D70E8;
        Mon, 12 Jun 2023 11:21:20 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b3db8f3d94so5356785ad.1;
        Mon, 12 Jun 2023 11:21:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686594080; x=1689186080;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyzQ4No+RLHAAwpMFK+EQR9jGsjSskvb0lQK3qnBq3I=;
        b=Rbae0nQ/+rpdPuzMGkNqkjjjeY4G8TDjp7oSMJcj66xh0nXvVGCf4r8COENWWLwtXZ
         0kZdNe5v+8HqSqaM6Fd5m1UUKbXnwPxHZstzBZfjnZfwuisYHzxvpC4G1ZhDySp75oiO
         Mjtmlt36apusvONontwSDfqWXt72ALShkMoKO0k/OUJ9Y1aDFuhcVCQikMOS2d1DtYaM
         PyNZPKNsBMjw+yfWOmzjsNYH+cAyx4nSzWNBenN5wCrXkqn5qts3H1IV8k3dtihWM/nA
         7TKUlEtxUl2uSTNF1BjXCB3siz2GR4378PQw+eMGJIqfpmRIPonm2ZiE4Jwu/rFcmhFC
         NIwg==
X-Gm-Message-State: AC+VfDzxG2a/Tx7ADeMSeak/hj7mSnGnKaJk2FTmA6MHy1xIZx8SDBgk
        M+rpjYdd2XBrhswc5Xu/6nE=
X-Google-Smtp-Source: ACHHUZ5f1pwszXT8WGp5oaVWVOxSV8LVVfMZf+xdKVWYKDccl8WDS4ykz/YwarTJqGK36Ica7qINeg==
X-Received: by 2002:a17:902:c401:b0:1b1:753a:49ce with SMTP id k1-20020a170902c40100b001b1753a49cemr8867704plk.53.1686594079956;
        Mon, 12 Jun 2023 11:21:19 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id d6-20020a170903230600b001ae57277a87sm8558051plh.255.2023.06.12.11.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:21:19 -0700 (PDT)
Message-ID: <dbdadc45-0566-3a6c-be16-ab8f1f5c7a6a@acm.org>
Date:   Mon, 12 Jun 2023 11:21:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v4] scsi: ufs: wb: Add explicit flush_threshold sysfs
 attribute
Content-Language: en-US
To:     Lu Hongfei <luhongfei@vivo.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" 
        <linux-scsi@vger.kernel.org>
Cc:     opensource.kernel@vivo.com
References: <20230609091113.22531-1-luhongfei@vivo.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230609091113.22531-1-luhongfei@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/23 02:11, Lu Hongfei wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/wb_flush_threshold
> +What:		/sys/bus/platform/devices/*.ufs/wb_flush_threshold
> +Date:		June 2023
> +Contact:	Lu Hongfei <luhongfei@vivo.com>
> +Description:	wb_flush_threshold is a percentage that represents the threshold for flush WB.
> +		When avail_wb_buff < wb_flush_threshold, the dev will flush WB when entered H8.
> +		When avail_wb_buff >= wb_flush_threshold, it is not necessary.

"Percentage" suggests a number in the range 0..100 while the valid range is 0..10.
Please fix this.

Thanks,

Bart.
