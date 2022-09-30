Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ACDC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 18:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiI3SDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 14:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiI3SDj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 14:03:39 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9182EF00
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 11:03:38 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id n7so4632653plp.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 11:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=2+mzbhvqZnLiIL0rsZBbVI6WNe7oCAy1vCOfbMfVx8I=;
        b=4vNQxPwaWVqH/Cf9LeveSc8sxgRyp593jv1Ob9k9WadSj4U7d9NRSv2tWi6zrWy/W8
         IWLjEKTrqkZJK2k9CYg3/Wb/5MMjP8e24pkP6wYMAStmMBhCj1HQmG8nfFTtfKq/OCwl
         aN9NeColBeVF7ZjAiIxAODrK904vhp+v+FgfRMC+pnTAZaMR+mdNbWY+iAc2gD1+rwxd
         M7VO25LJ0kb/yg0g/gqjGgzShDZScSZniuNkB0k1+LWzC+mR5+vENphZNZ+MRaYA6ZIc
         XQf1BdTijx0+OHnPlFp+wKwo+PTnrTAJSX8Pk5YzI/Oe6UD1/Y7k1PaapGh02XU9Lkus
         fObg==
X-Gm-Message-State: ACrzQf32grumgeGejQGmEaiC+wzi7qWNyLYh+BVaxL1Hnl2HN0J8xjkZ
        3Lm71eqwYjemA9z1mTNay5tqLgHQMuo=
X-Google-Smtp-Source: AMsMyM4EOM0lDLNYUuegkJN04DEZNjxhBdNJuYXLYVSxC/O2188lWGQ6uCpyBBolfuqZpuFoJU6X3A==
X-Received: by 2002:a17:90b:3a85:b0:203:2044:c26 with SMTP id om5-20020a17090b3a8500b0020320440c26mr11113300pjb.109.1664561018260;
        Fri, 30 Sep 2022 11:03:38 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id t17-20020a170902e85100b00177f82f0789sm2196868plg.198.2022.09.30.11.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 11:03:37 -0700 (PDT)
Message-ID: <255256a9-127d-1842-f5bb-3338c89a2f8d@acm.org>
Date:   Fri, 30 Sep 2022 11:03:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 17/35] scsi: ufshcd: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-18-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220929025407.119804-18-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 19:53, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/ufs/core/ufshcd.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index a202d7d5240d..fdea6809ec5c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8781,8 +8781,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>   		remaining = deadline - jiffies;
>   		if (remaining <= 0)
>   			break;
> -		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> -				   remaining / HZ, 0, 0, RQF_PM, NULL);
> +		ret = scsi_exec_req(((struct scsi_exec_args) {
> +					.sdev = sdp,
> +					.cmd = cmd,
> +					.data_dir = DMA_NONE,
> +					.sshdr = &sshdr,
> +					.timeout = remaining / HZ,
> +					.req_flags = RQF_PM }));
>   		if (!scsi_status_is_check_condition(ret) ||
>   				!scsi_sense_valid(&sshdr) ||
>   				sshdr.sense_key != UNIT_ATTENTION)

Acked-by: Bart Van Assche <bvanassche@acm.org>
