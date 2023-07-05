Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12BDEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jul 2023 21:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjGEVNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjGEVNI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 17:13:08 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE1F1700;
        Wed,  5 Jul 2023 14:13:07 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-262dc1ced40so75203a91.3;
        Wed, 05 Jul 2023 14:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688591587; x=1691183587;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+pw9J7tizwVtOdeFR5uDzJEF/Unio+AZUWRgEDGECkI=;
        b=ReNrVwvp8X3dLGy1a2qsE64Yn1cNybYmoUiWsM/Eah8WyTjm8fkgn20glUy8jG+yDf
         ImMZwOJ48RDCsAGZoCwdnWE6cYGQ8beM7KyYxEP/jc+7mVWwC/jfC6IpKGIwT4M0Q/Yg
         Aa7Y3CDbU6WAtKBCyJTD0avz8Uscsqc0CZTCk2AbABp+TYJVV9CZuqJN8lfmIKweliLJ
         pMLr8vrPJJCuPax+kFfG0a8HZI2wpP+SJsKg0cRCUzg6b5iJ89XYDt5WmYNJK1YezmrU
         0VY878LjDStSwmBOv9btpkMkwqnX1m0T3sGjn5MjactMbgZv7Qpvhd3/S56LhRIJ0SiX
         QTyA==
X-Gm-Message-State: ABy/qLZnqBCWgMssFa8qYfQ5UTVTj7DtIYVS7sbwcNHMJOnBXl8L/PeF
        Xiz2HhDjtpi/pSIwc3/kW2Y=
X-Google-Smtp-Source: APBJJlFpXev7Z0GA8KLcHxiqrghB5rDKeEVS9r9/660CkunpnocK6KMT+TGYoY7t89H/HBLV08pq2Q==
X-Received: by 2002:a17:90a:1602:b0:262:ec7f:af82 with SMTP id n2-20020a17090a160200b00262ec7faf82mr16058710pja.22.1688591586775;
        Wed, 05 Jul 2023 14:13:06 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2f70:a1a0:520:4dfc? ([2620:15c:211:201:2f70:a1a0:520:4dfc])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a7f8400b0026333ad02c1sm45914pjl.10.2023.07.05.14.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 14:13:06 -0700 (PDT)
Message-ID: <5f172788-f16b-7bb1-6338-24453995f221@acm.org>
Date:   Wed, 5 Jul 2023 14:13:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RESEND v2] ufs: core: Add support for qTimestamp attribute
Content-Language: en-US
To:     Arthur Simchaev <arthur.simchaev@wdc.com>,
        martin.petersen@oracle.com
Cc:     avri.altman@wdc.com, Avi.Shchislowski@wdc.com, beanhuo@micron.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230626103320.8737-1-arthur.simchaev@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230626103320.8737-1-arthur.simchaev@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/26/23 03:33, Arthur Simchaev wrote:
> The new qTimestamp attribute was added to UFS 4.0 spec, in order to
> synchronize timestamp between device logs and the host.The spec recommend
> to send this attribute upon device power-on Reset/HW reset or when
> switching to Active state (using SSU command). Due to this attribute,
> the attribute's max value was extended to 8 bytes. As a result,
> the new definition of struct utp_upiu_query_v4_0 was added.


Reviewed-by: Bart Van Assche <bvanassche@acm.org>
