Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B035C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 14:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E8122EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 14:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391730AbhAZOZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 09:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391724AbhAZN0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 08:26:22 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2528C061A29;
        Tue, 26 Jan 2021 05:25:30 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d13so4013426plg.0;
        Tue, 26 Jan 2021 05:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=hJpx0sAUwwTFVj7mi1u3wPShyqbE8agveuBzNbpt04c=;
        b=VUVw7SCR7FSAHmjqsGnuI2BZNY6fiwd1M2tIyoOUO2UT32Fc7Y22aaLUmbOeuP35mb
         P6kk217DvEtf/E81MGXRCzjJbie0rCIO6fqmdJsXry3+lwVOXKfo7lr3gPrzIDi2Ln1K
         6LCJxe8VD7LnOqT4FhIIZwaCHa4JvUibRtqXmH6KScWXlnzhVEqSprFM+gbnxD9WJV7i
         oED+4CUVzJHJ6zLIdYB4I6gl7a3BYC5d0G99y7Ncf7PRfrsqGYbY4OB2y14Q2RA16uuV
         hnnTtSyNzwAQCfUSCuZi/Gtve4erGUqPFLbl5Mg7KMqc3oGn83PFdhxJ6fWfwIaIOl28
         IOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hJpx0sAUwwTFVj7mi1u3wPShyqbE8agveuBzNbpt04c=;
        b=kMZz+lLQbQxO/u2u0xTKAvzIdf0I5hsyz3VzD2jM9ZpuXveq0dr2A/zuY6C7s8P2D4
         ub//9cgYic06FS1/lxEn1RpKrJ1Gk5I2TeVgu0mlhHl33/Wc0D9WkyKTC/wZsr6RnJX6
         oc82J45UXV8YfyC2bi0CT9jw45J+F2KHYGNOn4TIc+AibYQI6XR/nXS9GnGEgX5x/Zxk
         zQdEXpnke6WWTxlSzs8vUXTvsyPRGZpeExhFfdVgqZgeZYEORtGg0FZ9nMH1wlUSytlx
         CA8LqdCiMeklBCDRrORR7icEZSy1Rjr4wavIjkIuzzRJ9+PQhV1I37ye4/t2noqmcuHt
         mZpg==
X-Gm-Message-State: AOAM533GSbV6BI3yhMLRpEA3CNGUHVEBHcTz+on32p7QbAxqWJFRhvTK
        98hVB+CFgJgHVYE/QoXQ6uBy0SIpfkA=
X-Google-Smtp-Source: ABdhPJx6cCSvPh7H5Xm88DxJ8Yl0KyQ+k+xeKWqvcP0d9k5AZwCfxwEo3yvsuTu1r3Xbcn+4eErslw==
X-Received: by 2002:a17:90a:ad48:: with SMTP id w8mr6306010pjv.48.1611667530301;
        Tue, 26 Jan 2021 05:25:30 -0800 (PST)
Received: from [10.230.128.89] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id r5sm18752031pfl.165.2021.01.26.05.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 05:25:29 -0800 (PST)
Subject: Re: [PATCH v1] scsi: lpfc: Add auto select on IRQ_POLL
To:     Tong Zhang <ztong0001@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210126000554.309858-1-ztong0001@gmail.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <8e4e3e25-e69f-56ee-bff6-4fbf68262b38@gmail.com>
Date:   Tue, 26 Jan 2021 05:25:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126000554.309858-1-ztong0001@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/2021 4:05 PM, Tong Zhang wrote:
> lpfc depends on irq_poll library, but it is not selected automatically.
> When irq_poll is not selected, compiling it can run into following error
>
> ERROR: modpost: "irq_poll_init" [drivers/scsi/lpfc/lpfc.ko] undefined!
> ERROR: modpost: "irq_poll_sched" [drivers/scsi/lpfc/lpfc.ko] undefined!
> ERROR: modpost: "irq_poll_complete" [drivers/scsi/lpfc/lpfc.ko] undefined!
>
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>   drivers/scsi/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 701b61ec76ee..c79ac0731b13 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1159,6 +1159,7 @@ config SCSI_LPFC
>   	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
>   	depends on NVME_FC || NVME_FC=n
>   	select CRC_T10DIF
> +	select IRQ_POLL
>   	help
>             This lpfc driver supports the Emulex LightPulse
>             Family of Fibre Channel PCI host adapters.

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

