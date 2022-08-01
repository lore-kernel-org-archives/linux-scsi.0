Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF899C19F2B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 16:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiHAQnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 12:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiHAQni (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 12:43:38 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692F93E757
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 09:43:36 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id pm17so5618217pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2022 09:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=bdLt9Pv7yaEIwuMqlRgYlWgDDk3PKBNe2wyPJ/gdfyE=;
        b=j5FPCXXg6QCfMuTH/LUFYnBZvtJPCRywPEXFs8jUQaHx7nwla66RmDkx1L01tfjgLX
         nYvOGYFNvXfUk0h0y6hsOYQVejLTmpQrT/8XevpFf3/cWQwj5yzl6wDtbgJGfVrWgqGv
         /miKxXAggoNLg/pyrA7FXYzfA7XYL6BsHkn/8DaB3YdtI0+ydP9wm2CQJd/5rYrT3mfi
         y9CJbjKvAs728t44/V1ZAlJOjOdckiqohnbbslTcp6xRQh7Q5XKaq22F6uJ8+uR17ElN
         pyrhQPJXQAHUMB24nGRJQjRgxcvU0Ku/9IrHDm129ExoZxONqBMeIFg1IOwzEph3PhhI
         fH3A==
X-Gm-Message-State: ACgBeo1kbgD6gcP4SqMcAycFEomgvEC7twc7C/0W0xhwa56GxvZaNRyM
        24STeVG0h5TLS3UtcYJMSCs=
X-Google-Smtp-Source: AA6agR7dI3xrYpst3diC8fGBS6AVX4M64xuY5D7YgOgDwJJGMRpLygpa9TmB96S0008GC7sJanv0hw==
X-Received: by 2002:a17:90a:e7cd:b0:1f0:2304:f579 with SMTP id kb13-20020a17090ae7cd00b001f02304f579mr20218306pjb.212.1659372214957;
        Mon, 01 Aug 2022 09:43:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6496:b2a7:616f:954d? ([2620:15c:211:201:6496:b2a7:616f:954d])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902f64500b0016cd74e5f87sm9790048plg.240.2022.08.01.09.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 09:43:34 -0700 (PDT)
Message-ID: <dadc85ee-1252-38e8-a34f-3d1935f16b29@acm.org>
Date:   Mon, 1 Aug 2022 09:43:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock
 scaling
Content-Language: en-US
To:     Asutosh Das <asutoshd@codeaurora.org>
Cc:     Peter Wang <peter.wang@mediatek.com>, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
References: <20220728071637.22364-1-peter.wang@mediatek.com>
 <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org>
 <ca760b93-e6e9-abea-f2b2-dbb0c592690b@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ca760b93-e6e9-abea-f2b2-dbb0c592690b@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/22 07:30, Peter Wang wrote:
> Or, do you think we can direct remove ufshcd_wb_toggle in clock scaling 
> and only let sysfs to control wb behavior?

I think it's worth asking the people who introduced this feature whether 
it can be removed.

Hi Asutosh,

Commit 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support") 
introduced the following code in ufshcd_devfreq_scale():

+       /* Enable Write Booster if we have scaled up else disable it */
+       up_write(&hba->clk_scaling_lock);
+       ufshcd_wb_ctrl(hba, scale_up);
+       down_write(&hba->clk_scaling_lock);

Would you mind if the code for enabling/disabling the WriteBooster is 
removed again from ufshcd_devfreq_scale() and that a new mechanism is 
introduced for controlling the WriteBooster mechanism?

Thanks,

Bart.
