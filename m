Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67ADFC43217
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 19:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiKITAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 14:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiKITAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 14:00:31 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CB319C1B
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 11:00:30 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id io19so17948687plb.8
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 11:00:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4OhHLibDmzh2GeUu+hTclSXHbEEuIrcVY8EKP629pQ=;
        b=XBokD+hEInW5sBiNPpaoAXhGE7Utg5AcfbAMC9Po3M1eoefnAkzcpFax1GhfWikW9W
         VTq/hniBNs2XeVB5JhHSvWtcfv0qsTV5h0l2NIGwyXoa5RHf4qTO3R0Y2bDKspy/3GMI
         C0CQJYcrDXkur4P9IEQrV5fyQTGEjy9vkGMTUhT62v6nL9WLhTftCD4pnk8U+DtXnuSi
         T7LFJ5RhbmWeI8pAuVWBfScSu+pSSa4H2jipRJtUtXejrZJhkOhYWirCLlFinv9aDmfH
         07ZBzK1PhcMvPbJO32zERICRaz+11CuEDE9hPOt8n4aDFySH6/AZO/8IcfMQ14bp5mAg
         tBsw==
X-Gm-Message-State: ACrzQf2gHOaDc01HIMPsaWRq2BmXqH+YsCTnUOADgImEh0Ka22D+MTFp
        Q8l2o62cTPhTb9t+nukqQfNLK22TTMQ=
X-Google-Smtp-Source: AMsMyM51JQkEiETNVq278MLdbp715tO235FStDKwsgjSVlVyCETndxUCp/kS1BUSrdrptA4FrO71iQ==
X-Received: by 2002:a17:90a:540e:b0:210:1e26:9422 with SMTP id z14-20020a17090a540e00b002101e269422mr61469347pjh.100.1668020430244;
        Wed, 09 Nov 2022 11:00:30 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id ev3-20020a17090aeac300b0020ab246ac79sm1535949pjb.47.2022.11.09.11.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 11:00:29 -0800 (PST)
Message-ID: <55a7a1dd-c4c3-ca43-0033-d1b4e1491b1f@acm.org>
Date:   Wed, 9 Nov 2022 11:00:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 34/35] scsi: ufs: Have scsi-ml retry start stop errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-35-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-35-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> This has scsi-ml retry errors instead of driving them itself.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/ufs/core/ufshcd.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index fbd694bc4ef9..a8415e1b8a4e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8719,6 +8719,12 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>   	struct request *req;
>   	struct scsi_cmnd *scmd;
>   	int ret;
> +	struct scsi_failure failures[] = {
> +		{
> +			.allowed = 2,
> +			.result = SCMD_FAILURE_RESULT_ANY,
> +		},
> +	};
>   
>   	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
>   				 BLK_MQ_REQ_PM);
> @@ -8730,6 +8736,7 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>   	memcpy(scmd->cmnd, cdb, scmd->cmd_len);
>   	scmd->allowed = 0/*retries*/;
>   	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
> +	scmd->failures = failures;
>   	req->timeout = 1 * HZ;
>   	req->rq_flags |= RQF_PM | RQF_QUIET;
>   
> @@ -8760,7 +8767,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>   	struct scsi_sense_hdr sshdr;
>   	struct scsi_device *sdp;
>   	unsigned long flags;
> -	int ret, retries;
> +	int ret;
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	sdp = hba->ufs_device_wlun;
> @@ -8786,15 +8793,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>   	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
>   	 * already suspended childs.
>   	 */
> -	for (retries = 3; retries > 0; --retries) {
> -		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
> -		/*
> -		 * scsi_execute() only returns a negative value if the request
> -		 * queue is dying.
> -		 */
> -		if (ret <= 0)
> -			break;
> -	}
> +	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
>   	if (ret) {
>   		sdev_printk(KERN_WARNING, sdp,
>   			    "START_STOP failed for power mode: %d, result %x\n",

ufshcd_execute_start_stop() has been introduced because scsi_execute() 
does not support setting the SCMD_FAIL_IF_RECOVERING flag. If support 
for setting the SCSI flags would be added to scsi_execute() that would 
allow to remove the ufshcd_execute_start_stop() function. I can 
implement this with a follow-up patch if you prefer that I implement 
this change.

Since I'm fine with the above changes:

Acked-by: Bart Van Assche <bvanassche@acm.org>
