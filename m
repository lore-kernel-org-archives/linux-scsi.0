Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330D3C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 18:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiLASGH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 13:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiLASGG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 13:06:06 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47465B2772;
        Thu,  1 Dec 2022 10:06:02 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so2857809pjo.3;
        Thu, 01 Dec 2022 10:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qVK+6Kq4nzKMUbH9qhCB7m0XxdurCZ5fwk7wImCZNKU=;
        b=jpxkEUUrMozXGXuNAYjG+hNZncHHIADglofgFslEQCSHomakkLVASRkGPGdu3fTCE+
         zkDGS4AT0j7pRI+5ixZcyTHi+qonsQXZuKr7Y87K/a2rMIuHgEX/m63+eC2jlCtFxX2A
         k0Cirf6Y20s5O8Ee3AtsOa7eSQudahzKFBQEwjwf5K/q6OgEdoTZ5O7pQ8+Xp+uIPdh1
         yJVCvJRIyRIAAWt9LAbshW8g2B9XO34x/wsExUEineUeQORi+b25cGwh7YVN576OIwdd
         HFeanEGg3L0r3jtG8a14eNfnWD5ILV/x6GKBwCusrdMN0CGvq6w+VlTPZVTXxNF6S15M
         WzGw==
X-Gm-Message-State: ANoB5pllCnRdzETkrJaQzcX/ueB+42B4dnyMMWla5PhnJsGa6iJaN2xC
        I/V1BpScJO0TW3ZXrqPLMMM=
X-Google-Smtp-Source: AA0mqf5yON6iTF21v9ToNldiRX4UMXdkbeYNlxYzwMUD2LUs0hxwgAPvPXpnhTc9b58+xORLL06YFQ==
X-Received: by 2002:a17:902:f68a:b0:176:71be:cc64 with SMTP id l10-20020a170902f68a00b0017671becc64mr50293287plg.141.1669917961631;
        Thu, 01 Dec 2022 10:06:01 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:e25f:2653:dbae:e657? ([2620:15c:211:201:e25f:2653:dbae:e657])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090a2b4700b0021806f631ccsm3292919pjc.30.2022.12.01.10.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 10:05:59 -0800 (PST)
Message-ID: <fa0e6167-a893-4eb7-efff-8f378ee819e1@acm.org>
Date:   Thu, 1 Dec 2022 10:05:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 18/23] scsi: ufs: core: Add reinit_notify() callback
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
 <20221201174328.870152-19-manivannan.sadhasivam@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221201174328.870152-19-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/22 09:43, Manivannan Sadhasivam wrote:
> reinit_notify() callback can be used by the UFS controllers to perform
> changes required for UFS core reinit.

What does "UFS core" refer to in this context? Should "UFS core" perhaps 
be changed into "UFS controller phy"?

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 5cf81dff60aa..af8c95077d96 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -297,6 +297,7 @@ struct ufs_pwr_mode_info {
>    * @config_scaling_param: called to configure clock scaling parameters
>    * @program_key: program or evict an inline encryption key
>    * @event_notify: called to notify important events
> + * @reinit_notify: called to notify UFS core reinit

Please make this comment more clear. Nobody knows what "UFS core" means.

Thanks,

Bart.

