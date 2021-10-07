Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB134C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929A861075
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbhJGV5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:57:42 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:39637 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhJGV5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:57:42 -0400
Received: by mail-pl1-f171.google.com with SMTP id c4so4839154pls.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NcSNKTW0wuHUlJtA8QqBp99/CEuDVTvVYWQQYN5Eztw=;
        b=l+pOcVqveAkfxyZfciRqdQWqdob5lbkOiBMDrWZX+18OY2RvluS/EN4om0rGpr/xdo
         TCL3Vv1VX7NToRS5vOcWn34uK1JqaWRelcX6bbe2iPE1cIEd1Male9TN/S2zdFbPAcVq
         bKvecIeQ8eJgd80oC7iIEVaG3ik3WEp/SdwMN0LXgMCLX4Z3WsYFwrfq5xQsUV/dh3vZ
         vs7mS7d5CjI3x7KgBLIKxptJyOmgR5/xb81Fk0CfWXGMljL4wbEsE74JoB70RqbX/9OR
         9n2uL2X520ZU0IUtbJazKnRnRHgBpBVqF84fEkPvqbF1pKmubm8RPoQpVVcODzYBOUuT
         xX8w==
X-Gm-Message-State: AOAM533bSAwhRbqdqUzLPXVJiR2efDHPEhhDDgz4W+ugNNNuEFK3SB2a
        fGL/pHjprmvEDHJBfTszMcnUkzrpuZC+SQ==
X-Google-Smtp-Source: ABdhPJy9FxMj6YB6alfq3PKY18vo1u3SVC4ejWS6cowRZQU+QuLtOjcrpw4j+U1FjaVf4jj59+P1kg==
X-Received: by 2002:a17:903:1c6:b0:13f:2b8:afe8 with SMTP id e6-20020a17090301c600b0013f02b8afe8mr6070539plh.81.1633643746959;
        Thu, 07 Oct 2021 14:55:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id d138sm366108pfd.74.2021.10.07.14.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 14:55:46 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: core: Fix synchronization between
 scsi_unjam_host() and ufshcd_queuecommand()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211006114031.245731-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <87a189c5-00d1-6467-3e39-87b0528c4409@acm.org>
Date:   Thu, 7 Oct 2021 14:55:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006114031.245731-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/21 4:40 AM, Adrian Hunter wrote:
> The SCSI error handler calls scsi_unjam_host() which can call the queue
> function ufshcd_queuecommand() indirectly. The error handler changes the
> state to UFSHCD_STATE_RESET while running, but error interrupts that
> happen while the error handler is running could change the state to
> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL which would allow requests to go
> through ufshcd_queuecommand() even though the error handler is running.
> Block that hole by checking whether the error handler is in progress.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f34227add27d..df28e1444eff 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2688,7 +2688,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	switch (hba->ufshcd_state) {
>   	case UFSHCD_STATE_OPERATIONAL:
> +		break;
>   	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
> +		if (ufshcd_eh_in_progress(hba)) {
> +			err = SCSI_MLQUEUE_HOST_BUSY;
> +			goto out;
> +		}
>   		break;
>   	case UFSHCD_STATE_EH_SCHEDULED_FATAL:

Please add a comment in ufshcd_queuecommand() that explains why the new 
code returns SCSI_MLQUEUE_HOST_BUSY.

Thanks,

Bart.
