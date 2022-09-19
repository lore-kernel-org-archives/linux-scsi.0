Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D12C6FA82
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 23:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiISXWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 19:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiISXWc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 19:22:32 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7060160DF
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 16:22:30 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id p18so663281plr.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 16:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6l4Vzd4L6NzXlr/XuGacG5rBmgzYeImpbTrAxLBR3z0=;
        b=HBVAdTLxeewxPZXukPr8lNdt66mg+l9q6XNEjyUnu4j2DLeMlviBXHiCitArWU0YmP
         e6omNf5S8SR1cxIvBfQuK1yPINFtmpfTzS+QI7GbYIx7b4I8UODOdrnzeblNioZ9Aa17
         bglXVW6YGa2ckuyDzrjTDdG4gHcIQ3tqZve7PlDJGiRSAmNhXKVDiJ+PU0LLnK1Ccvr+
         uis9oCLLJbgmVznqQoGTr9IzYLsh+j+lkNDBTz1J8S8ska8eceJY8JcbAxZ5howpVU2e
         WOpctVx7Uv3tw2ylmXiLDsyekW6Imuv5jCfW0c1D+DRABp5oxzWSdXOxVUp4xQiDbfnE
         yqWA==
X-Gm-Message-State: ACrzQf2JAN+gp1HYDM+xf8jZlfkcLilcXAw4F4pmBrZz4bX6XXYoDOx4
        GJAGhhDmq59Kub5xAGZwAFxmDTmOmy0=
X-Google-Smtp-Source: AMsMyM5CXCmGXR30yb8cwVUKvuUz8t0i3GyuTMvKNPUaznoPLsc/9hXD7kPU7eM7FB/lUvWLv+ePZQ==
X-Received: by 2002:a17:902:7795:b0:178:897e:16b2 with SMTP id o21-20020a170902779500b00178897e16b2mr1986764pll.153.1663629749670;
        Mon, 19 Sep 2022 16:22:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:520:42c6:2cee:67ae? ([2620:15c:211:201:520:42c6:2cee:67ae])
        by smtp.gmail.com with ESMTPSA id q8-20020a17090311c800b00177ef3246absm1606023plh.103.2022.09.19.16.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 16:22:28 -0700 (PDT)
Message-ID: <dd89017d-05a9-a517-e193-0edc0b04ae0e@acm.org>
Date:   Mon, 19 Sep 2022 16:22:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] scsi: ufs: Fix deadlocks between power management and
 error handler
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        dh0421.hwang@samsung.com, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220916184220.867535-1-bvanassche@acm.org>
 <3712590b-20cb-7d27-3017-4567f1fcddc2@intel.com>
 <913f72ad-7f6f-9067-df36-f9507359c816@acm.org>
 <c98a4226-f1be-f84b-267c-5ce4e6c387d7@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c98a4226-f1be-f84b-267c-5ce4e6c387d7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/22 10:21, Adrian Hunter wrote:
> I guess it goes unnoticed because it is very unlikely i.e. the UFS
> device would need to be suspending but not yet have claimed host_sem.
> There would not be any outstanding requests otherwise the suspend
> would not have started, so chance of errors at that point is very low.
> 
> Maybe deadlock could be sidestepped by changing:
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7256e6c43ca6..9cb04c6f8dc3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9258,7 +9261,10 @@ static int ufshcd_wl_suspend(struct device *dev)
>   	ktime_t start = ktime_get();
>   
>   	hba = shost_priv(sdev->host);
> -	down(&hba->host_sem);
> +	if (down_trylock(&hba->host_sem)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
>   
>   	if (pm_runtime_suspended(dev))
>   		goto out;

Hi Adrian,

Unfortunately I don't think that the above change would help. My 
conclusion from the logs that I analyzed is that ufshcd_wl_suspend() is 
called first and also that the error handler is invoked while 
ufshcd_wl_suspend() holds host_sem, resulting in a deadlock.

Thanks,

Bart.


