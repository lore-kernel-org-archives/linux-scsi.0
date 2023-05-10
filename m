Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CCFC7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 10 May 2023 21:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjEJVqh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 17:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEJVqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 17:46:36 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136F846A9;
        Wed, 10 May 2023 14:46:36 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-643912bca6fso6265644b3a.0;
        Wed, 10 May 2023 14:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683755195; x=1686347195;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=niBRvOua1tXGMYCbxaZZeNyljGsY7f5YW77LPWud2zE=;
        b=Nt4NVWblvO9A4nIkS7TxNNggKxNIQpZZtmapJphrm33xzP2Vb2oB32qhmNazj8/org
         BWxVYQiGoDHMRTWPaJNoN6RYDxg8RU0UJbRrZjec6TpSzJ8HL2wh7nd89rIu4W0P9a6t
         bPQn+rpl58rMA3JNWmKfpHBMDmtNQFBomcDI/kChdqfFMK3Dcls7UKADV5P4OHvgm9Dx
         /B55NhNW1Q7JZAk5hgsYwz5yrE4rSsNgBby88H3JIF9JWh6PZVXoZNuCInZ2wRh5aRdp
         0a8ebAVw6js1hll2HjWApa9CwHpL6FGDdVGbksw9PBwi/2Ikh2hyNQv93W1SXnZDtyv+
         Wyuw==
X-Gm-Message-State: AC+VfDzSDryxpAbgb+9Qkp5D4C2F/5uL5yuXrNKEaNxzOaDxCej47B0R
        j2d1j12y+HCMar8GBcoRuoI=
X-Google-Smtp-Source: ACHHUZ5MLGzJIsyPyeZ9PQBDB1JRZRPwtGSqAGL1SDnu/uHPJ/UcuZ0cmJXvR7qGqsDIfDk5ot0UAg==
X-Received: by 2002:a05:6a20:9188:b0:100:d061:52ca with SMTP id v8-20020a056a20918800b00100d06152camr13146462pzd.50.1683755195353;
        Wed, 10 May 2023 14:46:35 -0700 (PDT)
Received: from ?IPV6:2001:4958:15a0:30:d8b7:fa5f:6808:3db3? ([2001:4958:15a0:30:d8b7:fa5f:6808:3db3])
        by smtp.gmail.com with ESMTPSA id w25-20020aa78599000000b00649281e2f03sm228362pfn.141.2023.05.10.14.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 14:46:34 -0700 (PDT)
Message-ID: <3414fe25-b107-f11a-db14-d086233047b7@acm.org>
Date:   Wed, 10 May 2023 14:46:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v1] ufs: poll HCS.UCRDY before issuing a UIC command
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, kwangwon.min@samsung.com
References: <CGME20230509083312epcas2p375f77d18a9026f7d263750baf9c9a5bb@epcas2p3.samsung.com>
 <1683620674-160173-1-git-send-email-kwmad.kim@samsung.com>
 <991cac52-22bc-0150-4332-76ac044c5bcb@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <991cac52-22bc-0150-4332-76ac044c5bcb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/23 14:24, Bao D. Nguyen wrote:
> It looks like you are sleeping while holding the 
> spin_lock_irqsave(hba->host->host_lock, flags)
> in ufshcd_send_uic_cmd()?
Right. Please drop my Reviewed-by.

Thanks,

Bart.
