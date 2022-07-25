Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573EAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 16:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbiGYQ4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiGYQ4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 12:56:46 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88533DF46
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 09:56:44 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d10so10961707pfd.9
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 09:56:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SZKUjV+JDq3t/cI0vRgnal2s16ZXLXlEnj1n19QibKA=;
        b=Oo7GIGY/nV75Exbw9sHh4lLYdrXDmBnOB2qBoX90fkjqtQwl/1XZhXzu7JqW/8zSYn
         GviP3ggL8xDaR43kP8ooNduHpaU4sDBpxa6unOKUp+vDQWyiEbc317TBv/mMoT32yqgx
         bGo8Em2KTiZzRcgs70otH1lqJNilLCHs+gwAILkSP/YPTaGuoa1C0wbC3ewPId4B3UC9
         fGXyO4rosPFsX+vLsVQmEvfkkHN2cOr3ymqbF7iuxr8UsZU8iJrVABIH/T+XDPEdzihr
         S+T8fTXzbdzh6sdQPF1QY5vre2wsHk7Zz+2JBw+o9hUysAfXF4Oonq1V4DZewbLYuWBN
         hOfQ==
X-Gm-Message-State: AJIora9OJthHrdXMlHbJlKJFPDP+InNhv9zqmKMcz5uPWBf+L81aE/Zt
        +mq6Zf8fkNj0lBT1Zq95nyaKDaUjr20=
X-Google-Smtp-Source: AGRyM1vPygkhuB+jI5F6MNLnqLJsgiXyyQLz9iNoFDiWlv7lCgR/mXSwyVe+zup1azDMgpR353agFw==
X-Received: by 2002:a63:5cf:0:b0:419:ecc3:6fbc with SMTP id 198-20020a6305cf000000b00419ecc36fbcmr11796189pgf.192.1658768203830;
        Mon, 25 Jul 2022 09:56:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:54bc:1b55:1813:e7a8? ([2620:15c:211:201:54bc:1b55:1813:e7a8])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090264c100b0016d2e8c2228sm9366935pli.238.2022.07.25.09.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 09:56:43 -0700 (PDT)
Message-ID: <bde55edf-8009-863d-b96d-8d3d937444e9@acm.org>
Date:   Mon, 25 Jul 2022 09:56:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] ufs: core: fix lockdep warning of clk_scaling_lock
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220725043000.5086-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220725043000.5086-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/24/22 21:30, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> There have a lockdep warning like below in current flow.
> kworker/u16:0:  Possible unsafe locking scenario:
> 
> kworker/u16:0:        CPU0                    CPU1
> kworker/u16:0:        ----                    ----
> kworker/u16:0:   lock(&hba->clk_scaling_lock);
> kworker/u16:0:                                lock(&hba->dev_cmd.lock);
> kworker/u16:0:                                lock(&hba->clk_scaling_lock);
> kworker/u16:0:   lock(&hba->dev_cmd.lock);
> kworker/u16:0:
> 
> Before this patch clk_scaling_lock was held in reader mode during the ufshcd_wb_toggle() call.
> With this patch applied clk_scaling_lock is not held while ufshcd_wb_toggle() is called.
> 
> This is safe because ufshcd_wb_toggle will held clk_scaling_lock in reader mode "again" in flow
> ufshcd_wb_toggle -> __ufshcd_wb_toggle -> ufshcd_query_flag_retry -> ufshcd_query_flag ->
> ufshcd_exec_dev_cmd -> down_read(&hba->clk_scaling_lock);
> The protect should enough and make sure clock is not change while send command.

Since this is a bug fix, please add a Fixes: tag.

>   out_unprepare:
> -	ufshcd_clock_scaling_unprepare(hba, is_writelock);
> +	ufshcd_clock_scaling_unprepare(hba);
> +
> +	/* Enable Write Booster if we have scaled up else disable it */
> +	if (wb_toggle)
> +		ufshcd_wb_toggle(hba, scale_up);
> +
>   	return ret;
>   }

Can the above patch can have the following unwanted effect?
* ufshcd_devfreq_scale() calls ufshcd_clock_scaling_unprepare().
* Clock scaling to a lower frequency happens.
* ufshcd_wb_toggle() enables the write booster.

Shouldn't the above ufshcd_wb_toggle() call be surrounded by down_read() 
and up_read() calls in addition to a check whether the WriteBooster 
really should be enabled instead of using 'scale_up'?

Thanks,

Bart.


