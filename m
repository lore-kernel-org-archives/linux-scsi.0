Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D36C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 18:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiLASoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 13:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLASoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 13:44:30 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE3B1F2EE
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 10:44:30 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id b11so2686911pjp.2
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 10:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wLQnlIqZMqnslRXpJFqXkXCTO3+9It8vDqxfladdyF0=;
        b=jkcKEWFlmNO0nOktM8GzJZDeD7jruWRmjmCSWISR5Nch0RsuIwcVEa2dnp2ZnGBzuI
         HQutP8/FlMaqPLIfYq4b8ORyOUAGfF6oe7kAxHGFFZA6NTdavCZn0eIAKGb1A/YsJTnQ
         mf1WS9uUKvsADvvwiqwmHgjXQn/r3vsfPC4oYsmwTdqweFPrxPF0oLZloNnvLm06Bogz
         x2S8uwW0Qd7qLOG/XBndwrHBAo6TjeF1pOJNRvgNroonE4QnOkjs8LXwDU9n8DDJ4dQL
         Zr3qbAR6aj2Xl+StLZdijPJtTKGWmf8xp1k79sgrTM9UXtbUWuY48wwf32UJeLqd4VzA
         Wwdw==
X-Gm-Message-State: ANoB5plTDAAQQ0vJSaRBmRnY75TArqNhQO/B9sJmmDa/gN+tjEViXka2
        WV67b99dJRLckuSwj91CW+fmRSJBbI4=
X-Google-Smtp-Source: AA0mqf5tpYt6FUVPOIYtEE84v6UUP4dv3cX8/v0ZiDJbM2u1up2UZoQaZ5RzgrzxXCHKem//7OIH1g==
X-Received: by 2002:a17:902:8c97:b0:189:13df:9dac with SMTP id t23-20020a1709028c9700b0018913df9dacmr47502011plo.34.1669920269371;
        Thu, 01 Dec 2022 10:44:29 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:e25f:2653:dbae:e657? ([2620:15c:211:201:e25f:2653:dbae:e657])
        by smtp.gmail.com with ESMTPSA id u9-20020a63d349000000b0046feb2754e5sm2828954pgi.28.2022.12.01.10.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 10:44:27 -0800 (PST)
Message-ID: <c9a68946-1015-9b9c-1023-94919d001ece@acm.org>
Date:   Thu, 1 Dec 2022 10:44:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] ufs: core: wlun suspend SSU/enter hibern8 fail
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
References: <20221201094358.20700-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221201094358.20700-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/22 01:43, peter.wang@mediatek.com wrote:
> @@ -9049,6 +9050,20 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   
>   		if (!hba->dev_info.b_rpm_dev_flush_capable) {
>   			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
> +			if ((ret) && (pm_op != UFS_SHUTDOWN_PM)) {

Please remove the superfluous parentheses from the above statement.

> +				/*
> +				 * If return err in suspend flow, IO will hang.
> +				 * Trigger error handler and break suspend for
> +				 * error recovery.
> +				 */
> +				spin_lock_irqsave(hba->host->host_lock, flags);

__ufshcd_wl_suspend() is allowed to sleep. Please change 
spin_lock_irqsave() into spin_lock_irq().

> +				hba->force_reset = true;
> +				ufshcd_schedule_eh_work(hba);
> +				spin_unlock_irqrestore(hba->host->host_lock,
> +					flags);
> +
> +				ret = -EBUSY;

Why is the value of 'ret' changed into -EBUSY? Can the above code be 
left out?

> @@ -9060,6 +9075,20 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	 */
>   	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
>   	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
> +	if ((ret) && (pm_op != UFS_SHUTDOWN_PM)) {
> +		/*
> +		 * If return err in suspend flow, IO will hang.
> +		 * Trigger error handler and break suspend for
> +		 * error recovery.
> +		 */
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->force_reset = true;
> +		ufshcd_schedule_eh_work(hba);
> +		spin_unlock_irqrestore(hba->host->host_lock,
> +			flags);
> +
> +		ret = -EBUSY;
> +	}

Same comments as above for this code block.

Thanks,

Bart.

