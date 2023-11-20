Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843CAC197A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 16:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjKTQGT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 11:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbjKTQGS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 11:06:18 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79069E7;
        Mon, 20 Nov 2023 08:06:15 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1cc1ee2d8dfso40078855ad.3;
        Mon, 20 Nov 2023 08:06:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700496375; x=1701101175;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZ+qxFVgfW5BGuEHfemUGledCCSHjF9+1apkMtOgt7A=;
        b=FechNfgou7vZhZ8fz+A3Larbb3Mr8tgXX1Oz5I5dp+g+zGVnDd3lwo5OKr/qYgnDVS
         LpMQXf94L3JnZ8i2FeJEZGntE/qaO3LdjDSAptaLO+Qp1P1QVXccrE9EHVPY+j2oss8A
         P4WkcwWgbWFqhJr2Gqn8Di4IqhglIryWaSMfJg1s9TvJWDd3zaI5FdCBylvOkxjVxhRh
         TSdex6FBpgflFR2C3DUlI55IZ+JT0HZBLmzRbjbOVcRAp8LZuoC6Xfky7yOFQ9SJPzf8
         9ZYdQWztS3FaR7GBgnYp729n7e2AmnKdpZUkpsgFQ9qD5qo54S1WqAMbSc0EpQ+tceIo
         qslg==
X-Gm-Message-State: AOJu0YzLzynqExMWfneHzu+o60Fyx3AZrEMJJeRROqCnTAMnr1K073Ic
        UyBd8OrrfuDL3YvLMHLmx90=
X-Google-Smtp-Source: AGHT+IEKwYcjxy/2FOoOpNM+rxurrLukEavkbSPBxZ932+gx9dYeNlp7sawMdEJHWC8fhwdykjpd9w==
X-Received: by 2002:a17:902:7d84:b0:1ca:e491:f525 with SMTP id a4-20020a1709027d8400b001cae491f525mr8009399plm.31.1700496374679;
        Mon, 20 Nov 2023 08:06:14 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id a22-20020a1709027d9600b001bf8779e051sm6186941plm.289.2023.11.20.08.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 08:06:14 -0800 (PST)
Message-ID: <6e72b067-15a3-47e2-98c3-fdeed054dfba@acm.org>
Date:   Mon, 20 Nov 2023 08:06:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: Change scsi device boolean fields to single bit
 flags
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc:     Phillip Susi <phill@thesusis.net>
References: <20231120073522.34180-1-dlemoal@kernel.org>
 <20231120073522.34180-2-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231120073522.34180-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/23 23:35, Damien Le Moal wrote:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 10480eb582b2..1fb460dfca0c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -167,19 +167,19 @@ struct scsi_device {
>   	 * power state for system suspend/resume (suspend to RAM and
>   	 * hibernation) operations.
>   	 */
> -	bool manage_system_start_stop;
> +	unsigned manage_system_start_stop:1;
>   
>   	/*
>   	 * If true, let the high-level device driver (sd) manage the device
>   	 * power state for runtime device suspand and resume operations.
>   	 */
> -	bool manage_runtime_start_stop;
> +	unsigned manage_runtime_start_stop:1;
>   
>   	/*
>   	 * If true, let the high-level device driver (sd) manage the device
>   	 * power state for system shutdown (power off) operations.
>   	 */
> -	bool manage_shutdown;
> +	unsigned manage_shutdown:1;
>   
>   	unsigned removable:1;
>   	unsigned changed:1;	/* Data invalid due to media change */

Is there any code that modifies the above flags from different
threads simultaneously? I'm wondering whether this patch introduces
one or more race conditions related to changing these flags.

Thanks,

Bart.
