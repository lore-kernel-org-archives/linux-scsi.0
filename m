Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AB5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 03:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9DD610E8
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 03:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhJ2EBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 00:01:51 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:44784 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhJ2EBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 00:01:50 -0400
Received: by mail-pl1-f182.google.com with SMTP id t11so5927658plq.11;
        Thu, 28 Oct 2021 20:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fRsqMyqFA/Ida725QXt6PG10Z1CmiaMzp5jYp0DjGUQ=;
        b=Yft7I9yesiZVV9bd6Kv0lWMyLepfD4ass9DGbIYkzpYczXLeYYgrSGfPidp6YmBxsy
         R3IvfDTpQfH+SEOuh9H1XHH6zRCysPbs41vv7IkxZZqwkokM12/pYeCAz9XZtCYyhZMo
         CbPlhZEzaHrRFIZPr0++K9KvEQ7OoC5FTcaiuvVHfAIvonZJOMmjlb8ABen4+OS/3fRs
         b09s4dTOp21ygBtaCEvz1VEY2sUTvWbbTIGrjld8N0WBTKlAHiuY9m2UDPlD13Fq38rf
         FNHUb9r+zk0dh/KQWORecPkheIbOG+qVSlLXH44vB0SsyOfGeq53P3NMUPgz0FWB2a9q
         AJdQ==
X-Gm-Message-State: AOAM533g+83jzpg+P1SOp9V7XhtzbE2Syh7ICk/lsiBhI5CM7IEgbXvk
        +KLJL5Hmu9mmTOxC6NvfGEY=
X-Google-Smtp-Source: ABdhPJyzp8/GBpwxAO5nZ7fUu+tWNNNqjNHsvW9hR4QVN/6JSKuYgEuqjdPLBYCEZbGh9Ff8kcrSFA==
X-Received: by 2002:a17:90b:1bd2:: with SMTP id oa18mr17070282pjb.164.1635479962233;
        Thu, 28 Oct 2021 20:59:22 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:ec77:6dc4:1736:618f? ([2601:647:4000:d7:ec77:6dc4:1736:618f])
        by smtp.gmail.com with ESMTPSA id o13sm5642340pfu.90.2021.10.28.20.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 20:59:21 -0700 (PDT)
Message-ID: <8288a615-1cca-9c24-f38c-549478ba55ad@acm.org>
Date:   Thu, 28 Oct 2021 20:59:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: ufs: fix unmet dependency on RESET_CONTROLLER for
 RESET_TI_SYSCON
Content-Language: en-US
To:     Julian Braha <julianbraha@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        rdunlap@infradead.org, daejun7.park@samsung.com
Cc:     fazilyildiran@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028203535.7771-1-julianbraha@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211028203535.7771-1-julianbraha@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/21 13:35, Julian Braha wrote:
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index b2521b830be7..0427f8277a5d 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -115,6 +115,7 @@ config SCSI_UFS_MEDIATEK
>   	tristate "Mediatek specific hooks to UFS controller platform driver"
>   	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
>   	select PHY_MTK_UFS
> +  select RESET_CONTROLLER
>   	select RESET_TI_SYSCON
>   	help
>   	  This selects the Mediatek specific additions to UFSHCD platform driver.

Please keep the indentation consistent.

Thanks,

Bart.


