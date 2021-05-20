Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBB9C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFDD4610A8
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhETP6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 11:58:34 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:36698 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbhETP6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 11:58:34 -0400
Received: by mail-pl1-f181.google.com with SMTP id a7so635454plh.3;
        Thu, 20 May 2021 08:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2vLKUCUl6wp/GTGPV2fbyHeEZRtpw5v8jh184+8Feqk=;
        b=ejohwwI0bSuHBC+CGtje4QYNuz0BfHXyOrQU49f4kC5kOpsN7ChVV/cNiR9epYJviw
         3k2qM3EymP5YofFXsV7h+W+w20tPMbmSErkcsCEGW8YwiwrfCFSzAYQqm7V1ohTUz3cZ
         Hmh+utijVbjObOr1iYl7TZK8371SwsSgcpT1zcKjGI76b8hBtHjiwzoK4wTjITu3yG0A
         3MwUmxOb5QFhQj8aKbDudUbEF44/Avq7O0xcbe+14s6PPGG4uOLiSAK/gUYsA1SsGGjH
         Ktgv9qP+NMMRoXfwvalWNU+4dm437HdB9lOrMFH3fiClkNztR9pAud7ypK0/A4vEjSr7
         Nrxw==
X-Gm-Message-State: AOAM533hR9lD56B+Qq7GlGf1uUIRltY7+tvT8u/E5mBtYELAUNA3DaS9
        7fN30jiFo5rtzEL58QcfE3Q=
X-Google-Smtp-Source: ABdhPJzKLnysp9N7c+yihPBbToOshMvtS4oe7+X9UF5JCqZwFtOLyhkdSK6zkgqWiGmZM/DQFNzoow==
X-Received: by 2002:a17:902:a388:b029:ef:8970:2825 with SMTP id x8-20020a170902a388b02900ef89702825mr6608186pla.77.1621526232214;
        Thu, 20 May 2021 08:57:12 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9549:3d1e:fcc5:81d1? ([2601:647:4000:d7:9549:3d1e:fcc5:81d1])
        by smtp.gmail.com with ESMTPSA id 23sm1771492pfn.192.2021.05.20.08.57.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 08:57:11 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <988856ad-8e89-97e4-f8fe-54c1ca1b4a93@acm.org>
Date:   Thu, 20 May 2021 08:57:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/21 7:31 AM, John Garry wrote:
> Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
> exceed Shost.can_queue.
> 
> The sdev initial value comes from shost cmd_per_lun.
> 
> However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
> initial sdev queue depth greater than can_queue.
> 
> Such an issue was reported in [0], which caused a hang. That has since
> been fixed in commit fc09acb7de31 ("scsi: scsi_debug: Fix cmd_per_lun,
> set to max_queue").
> 
> Stop this possibly happening for other drivers by capping
> shost.cmd_per_lun at shost.can_queue.
> 
> [0] https://lore.kernel.org/linux-scsi/YHaez6iN2HHYxYOh@T590/
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
> Earlier patch was in https://lore.kernel.org/linux-scsi/1618848384-204144-1-git-send-email-john.garry@huawei.com/
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index ba72bd4202a2..624e2582c3df 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -220,6 +220,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  		goto fail;
>  	}
>  
> +	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
> +				   shost->can_queue);
> +
>  	error = scsi_init_sense_cache(shost);
>  	if (error)
>  		goto fail;


In SCSI header files a mix of int, short and unsigned int is used for
cmd_per_lun and can_queue. How about changing the types of these two
member variables in include/scsi/*h into u16?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>



