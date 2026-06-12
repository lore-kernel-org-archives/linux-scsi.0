Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A8C38B146
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269929; cv=none; b=F62+zvNCMjOrKLIG+TD0mdc0L3YUowmDUzhS1VzGrn8HIGswTFbLC9owWh3fnmW+b21iq8WzUHwp4ok598UGGCF2bpFwbO9fXOe+H1/N89MdxDOzRaoihKO3mPEoI+MJriCztGmToAY5OYxy5yh/m569TLnu6/5vOh8uJjhz1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269929; c=relaxed/simple;
	bh=AXhJqOFz9EfjQaN6LU2V7Pj2bNqQX2JTYYgukOYILvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQp+xrY/qxZrvd9atmOQhLalDCrwKiSadQaoze/s5m3lW3y63i3rz6BQGNwzO4cKHXiRDY7lnIuPeTiqGm8gGwhmXz24yDxzanWd+A7Zi1DiBXj2W+k+sfQhP+F4TbdbJ4YTzTnA5tT3n6VOXs29ShugQ+vc2A7FAu3AZA8hlNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e7KvNZLj; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e7KvNZLj"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45eec22fab7so418667f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269927; x=1781874727; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KX5FBN4eCc12VCsmlB7URlhY3W1BfVYMO0/LexVWx7w=;
        b=e7KvNZLjudtn7wztfbwiG4YxuhCTJyszmEnTa2sTq/nmPIlZ5I8gX5jH4W/PMv31aw
         s9bPkPWc15v70SC4St2qbUo/kj/vQXOCim9TdRQ4OuUA51G+xihIJVAjZdeS5fNGZhwR
         JmDvy/DwbcMFP328dhpCRUhAy9SqLPwLriyc8uLJbZFvvOMtTXC+gXsPOvrzclMAHFhA
         Y2k5F1fgNqNtTQl5le2r1KORocIm966/6dSlbG6kDWi77LJsSzlWoWeJDYqQ9vHR/gIR
         f0asnHZJCyMhBTA15TNEMPPCfLeoGTaYyg74nZ40G6IiXvojn6ANRXVbXEwlI+BhrlYg
         UapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269927; x=1781874727;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KX5FBN4eCc12VCsmlB7URlhY3W1BfVYMO0/LexVWx7w=;
        b=rS4PCzticaA4JVCG2YVTMvbNGwBKk4Y1PFg5zNzCf/0q1bBJD3VwSP+4jx5It06nQS
         NQIJ2R9jR8e0V6UQIHxNK57h0wDw66tWKvWN3FtVWWwvCKcQ9q/2Kr+CzvQo52KFGeKu
         UsMdbgz4Y+sH4H0PtqypTFG75kTZhiMX1CcZR/dVpoSi0QJvwGDG3oMdhaSof9gVhi7a
         3EEWkfaVfPJ5+ByapNXNEP9jLphvadoD0a6g3Yfwog0sz6atoamxw6kmhr7RoX4hsKJw
         FRZ6IpSccaEcch8F8E+pLf6bHRhMoOptrXpM9WTTbHExnbjk7APUKr/kjqIRs9AFra0n
         RNqQ==
X-Gm-Message-State: AOJu0YwQUHtFipVRIsJJyFKmlqprcI+gt6brzrsowwv96R4KdOGRakWr
	7iXu17xQ22RMe9XQO7mcGm6XpmHG3lG4LnRNg3Rx2KrH1BXGtHpDfF4lt3onNaeCxqM=
X-Gm-Gg: Acq92OHLAuhnGFr+TRWGM9ZDZRGgUxVAV1mpW3m8fO2wiBjguCYHu81uGip5uZH0k4K
	btMLpTNjEWng7ZELsAdJIfT+QBDs6uoqsJIb3XRdrdOfRMry9VuN5zqvCR1NjJf3su+RSLM9XUv
	FpuSLCxoxYDmLDyKAU0Q4tAHsWNW8lew2ogcsRYxEcs0Mr1uCFdccSZF8JJ9bYd3rcoq4Wg919T
	n7ou8UenFXe+iXDnBigtPHqyeEN/b9iAdm38mFTHVHi1oReOm0GNUBAyxap2FEeEBiG+O37+tbn
	ye/ATGofVrdTrlJEBblEPNLI0bJC/kSW0pVGz6Ddb38qMPtFe+rQHIxhprtt9t5GP/OhPnTklic
	p9gvc/w44Z7mfJovyN1LVeq41ihfsSnlnfG9bifefhGMq1SEQiU6zb6pJLth9U1URJKBVUJX232
	eutZZlMRK6rw2POspdcsMbiRC2Vlj5/spa6gC2RlnlAWqabG0TEq3/2VQn+xZSQv9ZpNc=
X-Received: by 2002:a05:6000:288e:b0:460:ff2:63e5 with SMTP id ffacd0b85a97d-4606db99da6mr4802232f8f.18.1781269926765;
        Fri, 12 Jun 2026 06:12:06 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f263950sm5868175f8f.7.2026.06.12.06.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:12:06 -0700 (PDT)
Message-ID: <a61b4c9d-ff5d-45e2-b3f8-7e9cc92fab8a@suse.com>
Date: Fri, 12 Jun 2026 15:12:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 58/60] scsi: qla2xxx: Zero dport diagnostics buffer to
 avoid info leak
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-59-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-59-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
> buffer with kmalloc_obj() (non-zeroing) and, on success, copies the
> full sizeof(*dd) back to user space via sg_copy_from_buffer(). The
> inbound sg_copy_to_buffer() only fills as many bytes as the user
> request payload provides, and qla26xx_dport_diagnostics() zeroes only
> dd->buf. The options and unused[] fields are therefore copied out
> uninitialized, leaking kernel heap contents to user space.
> 
> Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().
> 
> Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 7f4558beee2c..b57c55964f9e 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2744,7 +2744,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
>   	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>   		return -EPERM;
>   
> -	dd = kmalloc_obj(*dd);
> +	dd = kzalloc_obj(*dd);
>   	if (!dd) {
>   		ql_log(ql_log_warn, vha, 0x70db,
>   		    "Failed to allocate memory for dport.\n");

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
