Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09391C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 18:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiLESn3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 13:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiLESnC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 13:43:02 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5879CF57
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 10:42:04 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so15693090pje.5
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 10:42:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PyzTPV6X9xNiTCbyGstKIWGMGMo8e5LT5ChhPCYnMlc=;
        b=zMUYq1TrKVtgok9ac8QBQfejPFzTTMt3o493cVMV7muXkBCvusdBsQy/GAEs66KAYR
         mx14erkWNz8goKYoF3rWITCixYIBk26Pv1RJnL1VPZ/bPDFRrCsL/sUvO4f6R4jWfHtQ
         MDfS+i5qQCRgxkn182ONMDMG9R6yNOEHnGJMuFxAC1SwqbUDGkgbHFYJ6qu7X6abimVB
         kSdAJ+9AJYDv/xTrnnTAuCdumOhwbaPsJBhTEkHrf997j7nB2PYVAnDOt1lbk1fER9wH
         D3VRkUI+UHp1z8EamKvewoPQFXQYYDNC6EaR1Eam84O2RBnj4TYX9Izjp5XYwP0viYnj
         EKzQ==
X-Gm-Message-State: ANoB5plK2lSLbsXhkDhr7rbiL2QmRlCnSVXnxkXZsUZp67GT9hheVqJJ
        j4hIaCA4If8imrt5oirB3NR3Jd3blc4=
X-Google-Smtp-Source: AA0mqf7YcuHB/+S/cPgfuJ0vxZsTspMf7KptxrrWaSD1oWJBYRYRq9ExUjSUrPOI7HRt0+It34rSpQ==
X-Received: by 2002:a17:902:b608:b0:189:7a8b:537d with SMTP id b8-20020a170902b60800b001897a8b537dmr44459287pls.95.1670265723486;
        Mon, 05 Dec 2022 10:42:03 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c22a:d200:1ba3:dcca? ([2620:15c:211:201:c22a:d200:1ba3:dcca])
        by smtp.gmail.com with ESMTPSA id h15-20020a056a00000f00b00574d38f4d37sm10244237pfk.45.2022.12.05.10.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 10:42:02 -0800 (PST)
Message-ID: <6785696a-cb52-5934-dbd6-28472b4cd7c6@acm.org>
Date:   Mon, 5 Dec 2022 10:41:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20221202073532.7884-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221202073532.7884-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/22 23:35, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When SSU/enter hibern8 fail in wlun suspend flow, trigger error
> handler and return busy to break the suspend.
> If not, wlun runtime pm status become error and the consumer will
> stuck in runtime suspend status.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b1f59a5fe632..a0dbf2c410b1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9049,6 +9049,19 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   
>   		if (!hba->dev_info.b_rpm_dev_flush_capable) {
>   			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
> +			if (ret && (pm_op != UFS_SHUTDOWN_PM)) {
> +				/*
> +				 * If return err in suspend flow, IO will hang.
> +				 * Trigger error handler and break suspend for
> +				 * error recovery.
> +				 */
> +				spin_lock_irq(hba->host->host_lock);
> +				hba->force_reset = true;
> +				ufshcd_schedule_eh_work(hba);
> +				spin_unlock_irq(hba->host->host_lock);
> +
> +				ret = -EBUSY;
> +			}
>   			if (ret)
>   				goto enable_scaling;
>   		}
> @@ -9060,6 +9073,19 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	 */
>   	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
>   	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
> +	if ((ret) && (pm_op != UFS_SHUTDOWN_PM)) {
> +		/*
> +		 * If return err in suspend flow, IO will hang.
> +		 * Trigger error handler and break suspend for
> +		 * error recovery.
> +		 */
> +		spin_lock_irq(hba->host->host_lock);
> +		hba->force_reset = true;
> +		ufshcd_schedule_eh_work(hba);
> +		spin_unlock_irq(hba->host->host_lock);
> +
> +		ret = -EBUSY;
> +	}
>   	if (ret)
>   		goto set_dev_active;
>   

Please follow the coding style that is used elsewhere in the kernel and
remove the superfluous parentheses from this patch. "if (ret && (pm_op !=
UFS_SHUTDOWN_PM)) {" can be changed into "if (ret && pm_op !=
UFS_SHUTDOWN_PM) {" and "if ((ret) && (pm_op != UFS_SHUTDOWN_PM)) {" can be
changed into "if ((ret) && (pm_op != UFS_SHUTDOWN_PM)) {".

Otherwise this patch looks good to me.

Thanks,

Bart.
