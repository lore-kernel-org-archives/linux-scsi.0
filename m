Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DA2C3DA7A
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Dec 2022 21:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiLaV3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Dec 2022 16:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiLaV3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Dec 2022 16:29:20 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD328FCF;
        Sat, 31 Dec 2022 13:29:19 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso29073354pjt.0;
        Sat, 31 Dec 2022 13:29:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISWRdwVih23bgfgAaCXa5whpIWz2PcBW3G4foSLvUag=;
        b=5bZgy3kwPHjApZNCeLyAu/vbX+1DzLmhqmTUAvlmQkfvnrhI7Nf3VUJiVz8mDh7kGz
         UbpzcxDZTF79w/J9F33Buhlu61HK1wisfS2qzh/B5ZIaSk0BKSJu5T9xCxfu1nqbvIXS
         sLCRm/IhXV5AEyYSWj1WeUau9s2ye7ZoobuTX3ApnE0byjesbueFKyFru1D5UgFSnZiD
         iqPjQj4kXWAy5JhZ9A5mveBBNAgqH4ujzlDP812XkLfmDKfTjpNRPP9J2LHASB8AdcrN
         h+E93i1kI15TYsKPLjSxoN8npOtY6G+BuldeYh6Sd2giSMl83W7fv9569X5n/Ug+kNHj
         Q5Kg==
X-Gm-Message-State: AFqh2kqPSUoGGm9j0o2sX/RWQJPBs4weZwPpjCDGsbxzs3B+POI0HALD
        VTj2ZzOkfQTKRnm115vcKNI=
X-Google-Smtp-Source: AMrXdXvraG9d4tzLLt+SMadNLdkPrk9+LoAN6PepE438N39jPpTDruR0LSLMxxgooeS/zwR/m27KRg==
X-Received: by 2002:a17:902:e1d4:b0:192:8b2f:38e4 with SMTP id t20-20020a170902e1d400b001928b2f38e4mr15036127pla.66.1672522159036;
        Sat, 31 Dec 2022 13:29:19 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id i14-20020a170902cf0e00b00186a2444a43sm17212453plg.27.2022.12.31.13.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Dec 2022 13:29:18 -0800 (PST)
Message-ID: <a0133561-2fd5-b962-2561-454aab7e97bb@acm.org>
Date:   Sat, 31 Dec 2022 13:29:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v5 19/23] scsi: ufs: core: Add support for reinitializing
 the UFS device
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
 <20221222141001.54849-20-manivannan.sadhasivam@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221222141001.54849-20-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/22 06:09, Manivannan Sadhasivam wrote:
> Some platforms like Qcom, requires the UFS device to be reinitialized
> after switching to maximum gear speed. So add support for that in UFS
> core by introducing a new quirk (UFSHCD_CAP_REINIT_AFTER_MAX_GEAR_SWITCH)
> and doing the reinitialization, if the quirk is enabled by the controller
> driver.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

