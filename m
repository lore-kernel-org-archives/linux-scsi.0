Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD5136CDE9
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262199; cv=none; b=RWwxXIzNWtV+cefMfLJI7kikiNBOm7HrTBaW8xfVixFUKMRNuCBbIFefJlNv/M8CZVIhDqWs3Rte0yNlcC3Tv7D3qjug6WOpae5TDZhIQPcUktxSgBJahJdGQzKlzur6YmYL7Sz7iHaoTN3hg38i68ckDcVrvSdy8v5eLjDPjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262199; c=relaxed/simple;
	bh=WPY32WBoWMBP/pewOPtAUtsyC+lTu2u0DEP59WyCXws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbmOYNQ7zKOaG3WMlgPSMGJ0CdcwVyaPFgw4CjSO0EBaDzrLIncWc3XcqGzjgqrLaIIDAVxQQHYHN1cLP0pns/NlqlL9KEhuOkwk5lLNtUdWzcHpfb5aD7Bmy4EtAPXth/9T6IB7Lry+ea3BGigsRscTrUxbIQvVkmh2cXaEbwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T1hYRBxG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T1hYRBxG"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490ac10e337so5428345e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781262196; x=1781866996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h2H4TjibeCyFJtyeyquGazumoQc5iLH4HPTByNggrmg=;
        b=T1hYRBxGKBnkLxiexiPhRlmm12cpe+ef3CJ3PAR5bDzgXtUUoMLXT/OPpbIMbh5Ohe
         kHkieN3AFhht0T4SHTwPnxzmaoFl5Ns9DQiFIlGiYZp6p+Kg4INeCmTHFyzmyQBDfTnv
         /5zSmjoEuioaBHtLBbs9EYSDzPmEoJ3zqlE+swX6yGNoHs+j2tMbJA7OW95wb96To5OV
         hVfl7WsLK7Wclx/7E7446tnxOlhFGqdl7m8XGDHT81cVKlm5syVR9vI3qqv3p4ddy9TL
         txC9HrebSFGIFSpklRd5DPwkX5JDieKMuq8jdxg8JCWg6/NQD49G1rl+Qw4XwltiMXds
         qeUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262196; x=1781866996;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h2H4TjibeCyFJtyeyquGazumoQc5iLH4HPTByNggrmg=;
        b=VcDQpiG3Q8RaZ/SDbE6+2KLBisgiGt0AKZfP4l8KEkkLABiugLHmDvQEKoZI3wobC6
         oaF+ErDNnxdkB/ZPCKR3+IYw/VWCeG+MklCBEGFLHuwplEFgrQ67FBGlv0ddZalcnPCm
         yxVpQPmFER0M7Nq+dLIY07Zh4Zz8jxyAIgkU5T8UfSOxbxx7kxexUVO0TFfIEzra5zN1
         N8g1bcdv5zH0DAsukl2zzH9179dd/a90Mz0m3jvqeLco+oL7PQkfL3iglvWbjAfpoARv
         Za2Vd8IzMhEhZbQyOwgMkOEDQWBuX7jArsLGndXA5UyKL1KTqVkgSLkRAuMmReJanrU4
         H/zg==
X-Gm-Message-State: AOJu0YyyN7Xw6jIYS+RvEGwoIksJMcrHeMm4JquyUA6PtNJNYxrf/Yx5
	jZbXFq3rG3ZRvRgGpdFG1DyrNNaVljqaKYUUihmxVudBB/Zs6MEi3vDAiP9pNR55OUY=
X-Gm-Gg: Acq92OGlI05X8PwuXUiHUL/ntYK1Goa0fBWJh0etzw5ZX/ENPzXax/3fjpGkzXSpJNv
	TBFXW77G4nNnGDRsiFMzInkEZyHVCZp9zC6iKlZ8oNg0a0N49TLw5jaczwACd6P9TxYrEp0FL5w
	weJBNzZhLKkwrKAIy7ABNtJuU6Q/DTze20PoILTl4ljXW7wgKRyn/CFGLOEKvooZv3XKoxo39SE
	acAzda1SexEcUjBxQDNQBuhDdHH/+tBF0TLa7W9nP9psbyoBF/TX6i7cMnCQYGaTs2lHgk32xqf
	LlVOtrDT0h9CLU6najHjhw9v5+dbilTaAsLOajtgwgmLhs3Sgs5kv8t4K0t+Llxd7DitCibHTHL
	ZhLXfT9o3T0k/uYdyrMrqYTJsxP/1A79kWRZN6c1f0OnlsY2o59cYLuxhBHprksTRDrQHE7S+sF
	7htAlZIAFXCq1tSM6aRTbnef8HbvpEmeoxFChwipaD67tqNvwA6DK4Uhg+KLvxqlTxen8=
X-Received: by 2002:a05:600c:820c:b0:490:bb37:9d49 with SMTP id 5b1f17b1804b1-490ec4d535amr27373535e9.11.1781262195762;
        Fri, 12 Jun 2026 04:03:15 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c473bsm4835335f8f.28.2026.06.12.04.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:03:15 -0700 (PDT)
Message-ID: <22f676c7-4c74-4188-af2b-f369f3ad5c74@suse.com>
Date: Fri, 12 Jun 2026 13:03:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/60] scsi: qla2xxx: Remove duplicate flash memo block
 definitions
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-12-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-12-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> The qla_flash_memo_block and related structures in qla_fw29.h
> duplicate definitions already present elsewhere.  Remove the
> duplicates to avoid divergence and build warnings.
> 
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_fw29.h | 39 ---------------------------------
>   1 file changed, 39 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
> index e294b3f033db..efe1c60bee81 100644
> --- a/drivers/scsi/qla2xxx/qla_fw29.h
> +++ b/drivers/scsi/qla2xxx/qla_fw29.h
> @@ -683,43 +683,4 @@ struct vp_rpt_id_entry_24xx_ext {
>   		} f2;
>   	} u;
>   };
> -
> -struct qla_fmb_version {
> -	uint8_t major;
> -	uint8_t minor;
> -	uint8_t sub;
> -	uint8_t build;
> -};
> -
> -struct qla_fmb_upd_time {
> -	uint16_t year;
> -	uint8_t  month;
> -	uint8_t  day;
> -
> -	uint8_t  hour;
> -	uint8_t  minute;
> -	uint8_t  second;
> -	uint8_t  reserved;
> -};
> -
> -struct qla_flash_memo_block {
> -	int32_t  signature;	/* "FMBS" */
> -#define QLFC_FMB_SIG 0x464D4253
> -	uint32_t length;
> -	uint32_t version;
> -#define QLFC_FMB_VERSION 3
> -	uint32_t checksum;
> -	struct qla_fmb_version ffv_ver;
> -	struct qla_fmb_version mbi_ver;
> -	struct  {    /* offset 0x18: MBI package build time: YYYYMMDD */
> -		uint16_t year;
> -		uint8_t  month;
> -		uint8_t  day;
> -		uint8_t  reserve[4];
> -	} bld_time;
> -	uint8_t tool_id[4];
> -	struct qla_fmb_upd_time upd_time;	/* offset 0x24: flash update time stamp */
> -	struct qla_fmb_version  tool_version;	/* offset 0x2C: FW/tool version */
> -};
> -
>   #endif

So why did you define them in the first place?
Please merge it with patch #9.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
