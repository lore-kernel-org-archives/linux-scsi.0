Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF743C2788
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 10:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774520528; cv=none; b=CFZlYhxq+74w+xjMAS7QLqn4v3otri5rxvPuHFjNalWwnls1LYm6V/y/NXjBXQG4SMdymxxeschLsVYu71TslM1rsJGB5DS5ZEEz+GUfhl5INVWFNuM0weD1mMMTA9uIYS5Zi8zH8HULKzF1ylIBQHKsI6r8Y46Tz+h72/FelhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774520528; c=relaxed/simple;
	bh=yWJJHGcngwPN4+RVtPJ26r3Ckr8t9Mu7+S4sz2QGBFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QNX6650L1FENJagnJV9Md+OtzLvdkQGlOdB5ise/MdeZ5XjWCQECWnu2nvJ6/ruZcry7sHxlHAFsVVPbDI2BoKhChnzF2sj10LuXbYS8q45pRpadcJprwyrNQMRzlL/DdT83agDJCLlA6rs0qFU/QjacRvt/4SXQo+VGJxiP3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IR7gpfOq; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IR7gpfOq"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a279ce9475so1657006e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 03:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774520524; x=1775125324; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aOi7siJvaPXuTjEqZzeQ2/x1I4b8gKg3wCzNt6pddBI=;
        b=IR7gpfOqXniTwdcABIgX2bfANPrEugGM+H3+4W8Rebz/aFtkt5Tc9staIX5AlJ2bx0
         pPBgecn7Hm3XiYULqt40kVVDT1APtSAUdS3P1aal/7WFT+NnEWR3C2pBPDXhSNvSkEgD
         09z3PBxynGrHn0ywYvrEwTaDtlKDakpn9ZjPObqn6NChFcA8q5wO7Lgv52H30ZWRzStv
         QgD+hkvC4ACWjUv2o4bhwKRl2EDTTAcsYX0NY0y45BJNk9ckj6kyuhr2Up3+VJD1InwT
         C0QxJ2NbakJD+06X2GhqEEn3EI2gVYUXoh/5pN3mFmcEO1DfzlhupYGauODm/oNLxCVG
         BQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774520524; x=1775125324;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOi7siJvaPXuTjEqZzeQ2/x1I4b8gKg3wCzNt6pddBI=;
        b=RAkh8Z4lSMWSZh3NbS0ZCOacPMvICL55nI+mYDjRH9Ce2AdhwHrqETc11yPB75BcSM
         7fSLVnZHSAmdAVU4AWI7j8x+l4GjfN3JDziRE66jV9tw9emMLhgr8mK5gwO9/SnckMJt
         k5aX5T6M3l07Hhq0MZCH3PD9gKcmhGpwuFgjJ8vNJOsN1rVNlWzEZJP0b4y2KZeo7u54
         4T+lIiSXvdq82Wcrm3RSFAunAglSDSY+28I5HA+2AHzs9iN/8u+ynuJ8uSPH9VGhXuuj
         5RPmhyricbkJ688+wQugIERHMl6MNfmopSzmLt2K6t1SACnoEeuMdVjN40/oKVL4Dhks
         JuvA==
X-Forwarded-Encrypted: i=1; AJvYcCUqx46Wd17oh9fsvkyeoLu6JIy0ikGmq6UDu9mO6HiI1e9Jz9UL+jJz+ASJzzU0fVxQQ+KvegmcZ93J@vger.kernel.org
X-Gm-Message-State: AOJu0YzbawLtC6oFopPctB86OxwnuoUG8P0TYq/Ay7vuvrIdyGeZy2Ur
	KN4LANWMPunIX8m2ATZ6G7b1cE+/17NezfEbhM7y3YvD+0wA4p+O1WmsivmskdqYKXQ=
X-Gm-Gg: ATEYQzwUMve+v/OspETiPlkmzoCR+K5yZQK60hlH69vhOybodVee2kbjw4CLGc5PHfZ
	IzPnrqs+5FcY9d+4x/sa3QLiasWAm0QFIEmRGJkUq6iIHjhfarDyOdEuU/L5Rt/KC7TaC4GekTE
	uZnOloUv1T5lQxeKqAu8fvFuG2pLmAbAzgevMnUtmW/dKivV5Q1qL44aS8nTGkV11S53wpDkwzf
	3aiXAauCl1UI30BgPUyxQESo9fAsvXyBDCGhIrpJru4q6+CGBI8XP9iNY+XmK/bXX8TdaJXEQEu
	M3ARP1mFtd+sQX+lAK5KaQaTcXjA79Gu6bhV+TXbnxnK07g6AWqt7xfY2GLq2ZcOCoOKwj3cBZ8
	3T3W3TX0hfQQq3EcImokydUxu/13m0i6DI8rWvn8f0dAcqcf/opShz+Gr0fEmljhTlKMVJPYPOD
	v7vGunaL9EPG1x0CihFoY1GoSW62Te94lP3R+zr5fKPe8Q6CN+DorJ6w1U
X-Received: by 2002:a05:6512:2386:b0:5a1:2efb:7d49 with SMTP id 2adb3069b0e04-5a2a505da5emr487353e87.10.1774520523588;
        Thu, 26 Mar 2026 03:22:03 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2a063ee78sm488097e87.2.2026.03.26.03.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 03:22:02 -0700 (PDT)
Message-ID: <e5a8a8a0-9e1e-44c1-9db5-5ee6b8ba867f@suse.com>
Date: Thu, 26 Mar 2026 11:22:01 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: scsi_dh_alua: use the device timeout rather than
 a constant
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: Krishna Kant <krishna.kant@purestorage.com>,
 Riya Savla <rsavla@purestorage.com>
References: <20260325151515.18688-1-brian@purestorage.com>
 <20260325151515.18688-2-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260325151515.18688-2-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/25/26 16:15, Brian Bunker wrote:
> Instead of using a constant for timeouts, use the timeout of the SCSI
> device itself. There are reasons why someone might want to extend
> the SCSI timeout and having the constant out of sync can lead to
> early timeouts.
> 
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Riya Savla <rsavla@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index efb08b9b145a..a4ee67109548 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -143,7 +143,7 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
>   	put_unaligned_be32(bufflen, &cdb[6]);
>   
>   	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
> -				ALUA_FAILOVER_TIMEOUT * HZ,
> +				READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
>   				ALUA_FAILOVER_RETRIES, &exec_args);
>   }
>   
> @@ -178,7 +178,7 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
>   	put_unaligned_be32(stpg_len, &cdb[6]);
>   
>   	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
> -				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
> +				stpg_len, READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
>   				ALUA_FAILOVER_RETRIES, &exec_args);
>   }
>   
> @@ -512,7 +512,7 @@ static int alua_tur(struct scsi_device *sdev)
>   	struct scsi_sense_hdr sense_hdr;
>   	int retval;
>   
> -	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
> +	retval = scsi_test_unit_ready(sdev, READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
>   				      ALUA_FAILOVER_RETRIES, &sense_hdr);
>   	if ((sense_hdr.sense_key == NOT_READY ||
>   	     sense_hdr.sense_key == UNIT_ATTENTION) &&
> @@ -552,7 +552,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   	valid_states_old = pg->valid_states;
>   
>   	if (!pg->expiry) {
> -		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
> +		unsigned long transition_tmo = min(READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
> +						   (unsigned long)U8_MAX * HZ);
>   
>   		if (pg->transition_tmo)
>   			transition_tmo = pg->transition_tmo * HZ;
> @@ -664,7 +665,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
>   		pg->transition_tmo = buff[5];
>   	else
> -		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
> +		pg->transition_tmo = min((READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ) / HZ,
> +					 (unsigned long)U8_MAX);
>   
>   	if (orig_transition_tmo != pg->transition_tmo) {
>   		sdev_printk(KERN_INFO, sdev,

Weelll ... The transition timeout is _vastly_ different from the device 
command timeout. While the latter tends to be rather small (ie in the 
seconds range), the former can take _really_ long time.
Ask you competitors, they regularly require tens of _minuntes_ here.

Having is settable is a good idea, but not to the command timeout.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
