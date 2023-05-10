Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A34C77B7C
	for <linux-scsi@archiver.kernel.org>; Wed, 10 May 2023 20:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjEJUFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 16:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEJUFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 16:05:13 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB294214;
        Wed, 10 May 2023 13:05:12 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-24e16918323so5382559a91.2;
        Wed, 10 May 2023 13:05:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683749112; x=1686341112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JI4LwvKM5+Xgz5dAdUGOizqLHGpbVCwyYyAwDCTs06o=;
        b=EvUa/2utcvV6rrtuDHS74jULqEE+jjMDZL8E6Ntk3RFGfBYDt+UdWL+TMY9bUjzMmX
         0We7dBJ+xPjERs6ZPl1MCOtPzHqt3L/aldrw28jM1M1GsMWeR2Dz1cHC6g6fxRYy9J4r
         S2orml43XVJhXkguOhgObyioVJEj7b9bWJlo60i7VTAo1HDzlwhYqr8jV/JOAEHje54b
         /v04CrjpA9livkNiPIeFzKvZNkcfamSZoWKpwMBN7NawzEvjiv9A474TQ+pRYu0JIAKJ
         hhgtIA0YadiEv9nDC9Huw5uLlZj3ukvr9Dlf7SGDMTS3BoST6YnBx6A51Xz+gFV0YUEE
         nf8w==
X-Gm-Message-State: AC+VfDylo3tkel8zVFzDqRCQMhibuTz5DA21tYu7tTxMCxKGfQXZSbbr
        m7gdLazxe9UNwu7BV10pTjA=
X-Google-Smtp-Source: ACHHUZ4/47itR7Tir8ZXsdlJexoDaX4FouunjoYVgeF7nl41ZKWG77ZNE4zjJqvJyyjBGuxpJH3uHA==
X-Received: by 2002:a17:90a:4a0a:b0:250:6730:a364 with SMTP id e10-20020a17090a4a0a00b002506730a364mr13803643pjh.3.1683749111922;
        Wed, 10 May 2023 13:05:11 -0700 (PDT)
Received: from ?IPV6:2001:4958:15a0:30:7dec:e5e7:f25d:e7e9? ([2001:4958:15a0:30:7dec:e5e7:f25d:e7e9])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090a318800b00246f9725ffcsm274358pjb.33.2023.05.10.13.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 13:05:11 -0700 (PDT)
Message-ID: <60542301-e77f-ad26-e249-29d42f446d74@acm.org>
Date:   Wed, 10 May 2023 13:05:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2] ufs: poll pmc until another pa request is completed
Content-Language: en-US
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com,
        kwangwon.min@samsung.com, junwoo80.lee@samsung.com
References: <CGME20230425012857epcas2p45eaa3f5f87de424bbf951b22653b3e70@epcas2p4.samsung.com>
 <1682385635-43601-1-git-send-email-kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1682385635-43601-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/23 18:20, Kiwoong Kim wrote:
> @@ -4138,6 +4141,61 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
>   
> +static int __ufshcd_poll_uic_pwr(struct ufs_hba *hba, struct uic_command *cmd,
> +		struct completion *cnf)

What does the name "cnf" mean? To me it seems to be a weird name for a 
completion function pointer.

> +{
> +	unsigned long flags;
> +	int ret;
> +	ktime_t timeout;
> +	u32 mode = cmd->argument3;

Is my understanding correct that __ufshcd_send_uic_cmd() does not modify 
cmd->argument3? If so, why does this function copy cmd->argument3 and 
re-assign cmd->argument3?

> +	timeout = ktime_add_ms(ktime_get(), UIC_PA_RDY_TIMEOUT);

"deadline" is probably a better name for this variable than "timeout". 
Additionally, please consider using jiffies since I think that the 
accuracy of the jiffies counter is sufficient in this context.

> +	do {
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->active_uic_cmd = NULL;

Is my understanding correct that it is guaranteed that 
hba->active_uic_cmd is NULL here? If so, what is the purpose of the 
above statement?

> +		ret = __ufshcd_send_uic_cmd(hba, cmd, true);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		if (ret) {
> +			dev_err(hba->dev,
> +				"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
> +				cmd->command, cmd->argument3, ret);
> +			goto out;
> +		}
> +
> +		/* This value is heuristic */
> +		if (!wait_for_completion_timeout(&cmd->done,
> +		    msecs_to_jiffies(5))) {

Please align msecs_to_jiffies(5) with the first argument ("&cmd->done").

> +			ret = -ETIMEDOUT;
> +			dev_err(hba->dev,
> +				"pwr ctrl cmd 0x%x with mode 0x%x timeout\n",
> +				cmd->command, cmd->argument3);
> +			if (cmd->cmd_active)
> +				goto out;
> +
> +			dev_info(hba->dev, "%s: pwr ctrl cmd has already been completed\n", __func__);
> +		}
> +
> +		/* retry for only busy cases */

Please fix the word order in the above comment (for only -> only for)

Thanks,

Bart.
