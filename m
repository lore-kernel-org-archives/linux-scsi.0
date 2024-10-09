Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F8433B5
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455434; cv=none; b=BqrfhBlnqj0UHxNHpA78qg2HFwo3OB0kjGG+yP0iHzdS1H++3QUysmVZy/CeE8X5hUUxj8iTBydC+JgEPpDin4+i3vKWXpwqEF+dlWSqDnExeBHQ5i8tEhrQ7LOFSFf+bk4DFeVy0iNy/pF0d3knqhWPRAZngo7kSMSF5OdjGZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455434; c=relaxed/simple;
	bh=UA+nhOKrvPaVSedr02lSqCKSfRhowcU0PUDZ58k9fRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U6FHZB9zlLhn8YoDMp6fXthjF+H5JznQGpDNVJZmeXK4S+08NHXERafH0g6NzLIdu95x1NrN9Xk1ANRgRXeeI6vw1hMWjCoTPvTmIexTJ7+q9oZypoDsLLrSVKa3TrtqZxU2mzPLI3I1Ur7xrT7wwMD+ejqkUgS+umIsSo24dtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SGdKnp6+; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SGdKnp6+"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5389e24a4d1so7963178e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Oct 2024 23:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728455431; x=1729060231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BT61mqzWa/Vplik9tb6XjJgFQUw+Q5nF5lXcNmSEzsU=;
        b=SGdKnp6+W8ukGKnJ2epD459rmAP7VqP5mXBy18ZF/wadxzv76zaxSNX3cxHR/eAcsk
         4lzOHeXm1fOV8rVstv/fd49hxqFCmwGhtXDf1yfmrERmLjcNKehHlxTbXC3IiygMQKUn
         3S4a0IZswKwciZuJHcc2gd9Dl32ifwl2e5/etCIIRJOykrBFtZQWA9in0U5/5CczYS9M
         skKxKNgj0usG1PukLyw5SLoxGGs4lm3hIZRp9bkPvPjLUVoT5Jp4RZj32cslaNlGQrfe
         syW97ZPmz2NdsMxBMazahAbPQBd9snxzWCJw7xOKBLPc0EirBuQiphGDuxlJprTJi77L
         +xlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728455431; x=1729060231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BT61mqzWa/Vplik9tb6XjJgFQUw+Q5nF5lXcNmSEzsU=;
        b=d6wySKiyd7QozENnyolYjR7Q5c2VNbBTDmVXzrb9D1ShUd+Ou+Fef9UYXw8dncG5KP
         g5S9BnFcYb7Wz/i5MQJ7zLmZLpfMb6b8AlxYorg5p3O0LHcZWSh5v1fU3ZYn1V6QZNjw
         11S6hcCti4M6DDH2r+m84ctHbbt80s9kaxcbA95EMm9Kgk6wvBlEl7cMIRWWBGC5Tj6m
         afi2GZavMpkbUhYzgJoI+dI1oJbNMuswxIzSzwLJJpd4JnJ+/YfFd0lu1U7isEDCiJsl
         6RMYqJ9sslZ3mt/fnnL5YJ5uZCUe6sh01wFXgsIKrLVyT3x1/NcV53sOzwMFxV/1vYjG
         u9lA==
X-Forwarded-Encrypted: i=1; AJvYcCXGlJrBNuGf0ZV2am6UrISPRZH+tzGaFVuHKEil0D3/0UOGNI0AD5wn+i2sdL7y2H2csFh1dTXv/+l3@vger.kernel.org
X-Gm-Message-State: AOJu0YxtMKh4a9mPop8lQHwoo5n9YjQF1no55KHDO8oqfoa8/PvN5URx
	PMWJdkAVQ62NIj+SnJC2yyJ/cfVxsm7k4DR4y70MmlkSj4wYT37vd2B0CESG/9s=
X-Google-Smtp-Source: AGHT+IFnss7Rt8sKnZ+AYU3P80OInifkc1mksDwCq/WzXeOIAU7NW2wbqD0zcKMnC0fsN6+zzj4rmg==
X-Received: by 2002:a05:6512:1090:b0:533:455c:8a49 with SMTP id 2adb3069b0e04-539c4948d61mr642592e87.38.1728455430661;
        Tue, 08 Oct 2024 23:30:30 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8? ([2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05bd4dcsm5072933a12.49.2024.10.08.23.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 23:30:30 -0700 (PDT)
Message-ID: <ee878956-852b-4be6-b7f9-94cdea5e94dd@suse.com>
Date: Wed, 9 Oct 2024 08:30:29 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Drop starvation counter on success
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, quinn.tran@cavium.com, nab@linux-iscsi.org,
 himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux@yadro.com
References: <20241008132402.26164-1-a.kovaleva@yadro.com>
 <20241008132402.26164-2-a.kovaleva@yadro.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20241008132402.26164-2-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/8/24 15:24, Anastasia Kovaleva wrote:
> Long-lived sessions under high load can accumulate a starvation counter,
> and the current implementation does not allow this counter to be reset
> during an active session.
> 
> If HBA sends correct ATIO IOCB, then it has enough resources to process
> commands and we should not call ISP recovery.
> 
> Cc: stable@vger.kernel.org
> Fixes: ead038556f64 ("qla2xxx: Add Dual mode support in the driver")
> Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c    |  4 ++++
>   drivers/scsi/qla2xxx/qla_target.c | 11 +++++++++++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index fe98c76e9be3..5234ce0985e0 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1959,6 +1959,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
>   		ql_dbg(ql_dbg_async, vha, 0x5091, "Transceiver Removal\n");
>   		break;
>   
> +	case MBA_REJECTED_FCP_CMD:
> +		ql_dbg(ql_dbg_async, vha, 0x5092, "LS_RJT was sent. No resources to process the ELS request.\n");
> +		break;
> +
>   	default:
>   		ql_dbg(ql_dbg_async, vha, 0x5057,
>   		    "Unknown AEN:%04x %04x %04x %04x\n",
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index d7551b1443e4..bc7feef6ee79 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -6801,6 +6801,7 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
>   	struct qla_hw_data *ha = vha->hw;
>   	struct atio_from_isp *pkt;
>   	int cnt, i;
> +	unsigned long flags = 0;
>   
>   	if (!ha->flags.fw_started)
>   		return;
> @@ -6826,6 +6827,16 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
>   			qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
>   			    ha_locked, 0);
>   		} else {
> +			/*
> +			 * If we get correct ATIO, then HBA had enough memory
> +			 * to proceed without reset.
> +			 */
> +			if (!ha_locked)
> +				spin_lock_irqsave(&ha->hardware_lock, flags);
> +			vha->hw->exch_starvation = 0;
> +			if (!ha_locked)
> +				spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
>   			qlt_24xx_atio_pkt_all_vps(vha,
>   			    (struct atio_from_isp *)pkt, ha_locked);
>   		}

Why not just 'WRITE_ONCE()' and drop the spinlock?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

