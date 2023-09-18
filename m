Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC17CD13D2
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjIRQRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjIRQRl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:17:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0847D1997
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:03:01 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-68fac346f6aso4260503b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052528; x=1695657328;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NiSTaTd3OYgJAeKHG13E9l3sLX2n80jn9tb+CPaNnb8=;
        b=RwxGVgzIe9CR4wxHF+SEHuaym+1rA7f1GRRLc+jsjp4nRagPBjZiE0/bxwUGwFmTgm
         ZOzoDmzdok4n57kLCpwtxOR3vROxCIuUL8DnqIoB2rmyrNApsCEB+gyNDKD7EQbld9Mt
         f7PrfGoI/OaI5ntZU/veA9y7Pql9vszITxeEK3uweHFhCHNNBTC3TyCaFTndB4GhCl0P
         rn3OVwSvawuoP9ByezqGQT09gEarO3Zc3NpyRAuQCHI86x5IAyZcFEaqTt6tTj+RChTH
         FRhN+fk50HyE/IrTaXfstbPHYL9v8GRxl0yMf8ydGmlfQ4RJzBQ/nFeGrjw2Aj9hVrjd
         OMsA==
X-Gm-Message-State: AOJu0YzFE1zbYvPapXV5SRhA5me//RpoRyYZX0Sd4BWMWgR8CNqnDJVu
        EINEhvqaUQHhwhobyCVYaCw=
X-Google-Smtp-Source: AGHT+IH0CvmtChKcNYlg7JPgMJJoEQx4TvMmBxeyGMgPwXhQ9izpJdLOYqAWbrdF0xsGtOhQiUch/g==
X-Received: by 2002:a05:6a00:2446:b0:68e:236a:93d9 with SMTP id d6-20020a056a00244600b0068e236a93d9mr9076055pfj.17.1695052528046;
        Mon, 18 Sep 2023 08:55:28 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:33e7:1437:5d00:8e3b? ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id n53-20020a056a000d7500b00690b8961bf4sm372909pfv.146.2023.09.18.08.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 08:55:27 -0700 (PDT)
Message-ID: <61f69028-b028-42d2-9f8a-bd70692994c1@acm.org>
Date:   Mon, 18 Sep 2023 08:55:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: hosts: check result of scsi_host_set_state() in
 scsi_add_host_with_dma()
Content-Language: en-US
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <812c97ce-9b41-400a-9eb9-ddeef0156bbe@omp.ru>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <812c97ce-9b41-400a-9eb9-ddeef0156bbe@omp.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/23 13:48, Sergey Shtylyov wrote:
> --- scsi.orig/drivers/scsi/hosts.c
> +++ scsi/drivers/scsi/hosts.c
> @@ -272,7 +272,10 @@ int scsi_add_host_with_dma(struct Scsi_H
>   	if (error)
>   		goto out_disable_runtime_pm;
>   
> -	scsi_host_set_state(shost, SHOST_RUNNING);
> +	error = scsi_host_set_state(shost, SHOST_RUNNING);
> +	if (error)
> +		goto out_disable_runtime_pm;
> +
>   	get_device(shost->shost_gendev.parent);
>   
>   	device_enable_async_suspend(&shost->shost_dev);

The scsi_host_set_state(shost, SHOST_RUNNING) call shouldn't fail. 
Hence, I think that adding error handling for the failure case will 
confuse anyone who is reading that code.

Thanks,

Bart.
