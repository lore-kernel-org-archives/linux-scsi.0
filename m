Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0283A1BE
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 18:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6d98ce84e18so4701811b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 10:01:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704996064; x=1705600864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=etPhYEpjrfPMPX4Spi266ti+YyS5E37YvEEcNHdMkkg=;
        b=rwQuNbhEY++83l8YMc/ph5H/7fQ2mnlRzleg4AVaZcHxFXtPJ980Y2P8wkrz/4Uzig
         hKbmNVFE2a0z7AwgHPCVuMiXNdWFWNIwpkAwq6cExsmicLw9jFLDIXidqnIrRv0G6mQ0
         dDrtlh2eNuzKjEAO+lv8g3KStBgNsydb2I05DaERSz9oX1KsktQQ5+XJAmrKweYkXlkp
         7Kkyo7Qr7h51N/nZYTxSmemhz19JOvniWATvxzcc9MlW6iO+l4Czn2lA46yhy0ZnLEut
         PEtfHzU4cm9eNd5XxrTIW5TiT/BzgoKfO7Dt8JkZ8T3TunF14s2+fMUk8u2fd9s33j+C
         wxIQ==
X-Gm-Message-State: AOJu0YxmPU8dsfxY8AOBblrlJaR4LL8GW79CaH+QRbJqqco0Z3Lq4Qlh
	O1v0BgHRGZyoYo5pRXHCUkI=
X-Google-Smtp-Source: AGHT+IFoE6gOXkxUhvogfx6oBcvRj+iWF585sycdoWkfZAeeJZqnrIjclfvVIwNta8yEqwZzj9I2mw==
X-Received: by 2002:a62:d408:0:b0:6da:d8d5:bd4e with SMTP id a8-20020a62d408000000b006dad8d5bd4emr95318pfh.49.1704996063881;
        Thu, 11 Jan 2024 10:01:03 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2b84:6ee3:e813:3d8d? ([2620:0:1000:8411:2b84:6ee3:e813:3d8d])
        by smtp.gmail.com with ESMTPSA id c25-20020a62e819000000b006ce71af841bsm1470045pfi.4.2024.01.11.10.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 10:01:02 -0800 (PST)
Message-ID: <2cb2844d-86f4-4b72-b841-ba70ef799a55@acm.org>
Date: Thu, 11 Jan 2024 10:01:00 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Kick the requeue list after inserting when
 flushing
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Kevin Locke <kevin@kevinlocke.name>,
 linux-scsi@vger.kernel.org
References: <20240111120533.3612509-1-cassel@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240111120533.3612509-1-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/11/24 04:05, Niklas Cassel wrote:
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1223d34c04da..d983f4a0e9f1 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2196,15 +2196,18 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
>   	struct scsi_cmnd *scmd, *next;
>   
>   	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
> +		struct scsi_device *sdev = scmd->device;
> +
>   		list_del_init(&scmd->eh_entry);
> -		if (scsi_device_online(scmd->device) &&
> -		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
> -			scsi_eh_should_retry_cmd(scmd)) {
> +		if (scsi_device_online(sdev) && !scsi_noretry_cmd(scmd) &&
> +		    scsi_cmd_retry_allowed(scmd) &&
> +		    scsi_eh_should_retry_cmd(scmd)) {
>   			SCSI_LOG_ERROR_RECOVERY(3,
>   				scmd_printk(KERN_INFO, scmd,
>   					     "%s: flush retry cmd\n",
>   					     current->comm));
>   				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> +				blk_mq_kick_requeue_list(sdev->request_queue);
>   		} else {
>   			/*
>   			 * If just we got sense for the device (called

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
