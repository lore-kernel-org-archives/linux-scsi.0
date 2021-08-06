Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71CCC4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 22:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE12161179
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 22:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbhHFWNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 18:13:00 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:39794 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhHFWNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 18:13:00 -0400
Received: by mail-pj1-f42.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so15838608pjn.4;
        Fri, 06 Aug 2021 15:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6HRtuA39Az3shzqSL/ACCUU5ZgIfTtFc9KrRUNMmSP4=;
        b=dR0lZ+7ooWetMcKxWb99/s7oUghRVaXSOLEtRg9R7YSknwbXbbDi4ecVXz/EHlnkVf
         IHqzi+LYhJgBnRpA20ZQfg8awX535CeviTaWBz4IJmrFScb+rvd6BN7mWYi9QsUIhvPl
         CGwoc9WWMlyo5gmPqQyPD8isrLGNG3Adj8aCmsUVpZpIA1YfZ9Bn7X/+E/uQPEX/gc8+
         1JVo7vz+jKZ2hjflpraZpaCnhEcmlGBkh2VC8AOWY07V1eryrOceH3A2YFIuq3EfEtYX
         Hv9JfwgUy9FnRS3ZKO8pfueHHEeeJgYv6N6u+hDWnlyGJlZttUlNvC340qPujGs+vNog
         d/mQ==
X-Gm-Message-State: AOAM5315r1hU5ddVWT7+EBVMSxnk4pGbuOD3PukmiiAHqOXkd9cua5yL
        XIK9WwttmV4+WE7+a8CQb6aBJP+CnCI0+HId
X-Google-Smtp-Source: ABdhPJxqqw23/WJD2xpyIGP6m110WAwWM2tiap/cmyMtoOaPY4n5iapk4141156XtFjGgtsqkQ2O8g==
X-Received: by 2002:a63:2fc2:: with SMTP id v185mr116386pgv.71.1628287962249;
        Fri, 06 Aug 2021 15:12:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:1655:15af:599e:3de1])
        by smtp.gmail.com with ESMTPSA id p8sm11362530pfw.35.2021.08.06.15.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 15:12:41 -0700 (PDT)
Subject: Re: [PATCH][next] scsi: ufs: Fix unsigned int compared with less than
 zero
To:     Colin King <colin.king@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210806144301.19864-1-colin.king@canonical.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e9e4dcf0-f42d-a4c6-0be8-5c7cb84c91ea@acm.org>
Date:   Fri, 6 Aug 2021 15:12:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806144301.19864-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 7:43 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable tag is currently and unsigned int and is being compared to
> less than zero, this check is always false. Fix this by making tag
> an int.
> 
> Addresses-Coverity: ("Macro compares unsigned to 0")
> Fixes: 4728ab4a8e64 ("scsi: ufs: Remove ufshcd_valid_tag()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 47a5085f16a9..21378682cb4f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6976,7 +6976,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   {
>   	struct Scsi_Host *host = cmd->device->host;
>   	struct ufs_hba *hba = shost_priv(host);
> -	unsigned int tag = cmd->request->tag;
> +	int tag = cmd->request->tag;
>   	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
>   	unsigned long flags;
>   	int err = FAILED;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks!

Bart.
