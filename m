Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF662EA173
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263002; cv=none; b=hnLIIaWrUeIXmid75bEoH5nNkUkmaYx96gFwBHhigdeDgemPqSOXjl+2pDj2HpC6OXPkri0g8WZPaBlkquHc1RA0BrS4eUHN9+2Q9xVOqNObJ8UKxknEyMio0nyfNopu+tKrQ6IaZU38AHm/J9+jRsObRJygvZOnaBtX+VjaH30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263002; c=relaxed/simple;
	bh=nVCydS5xgvvrshnJOHj0rCdoekgeoQ5un0gjFZ8FPjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jfuJR5zfaY02AMnis3XY2bXL8V3BQ6ezw0V2gSgPqVKNAMnMYYPoOBpD97Uo3aYYeDQm0h+2P5hyJdTjpS/MjzT+0J07tslmxeucG0KKrfCD5GQCHcTK9yKwQC54qyemUrOkZh0pmUUQSN3PSIms7+lmVTPMvdGbTuwJswIM6Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QAdtvCaE; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QAdtvCaE"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-491b390f9e9so1758095e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263000; x=1781867800; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kvpWhcnaBRhifpLWAZqMnNgp9C2UYNhPSO/KyWXo6NQ=;
        b=QAdtvCaE4ybsTKiILBcz/zq9KpprgwmNDPP2pGNvWtBXfJgH+ccH2f3JWATRJVHzj2
         CTF6Kv0ZwJdefwHQdsVfUhbnVN1wftSOQllB9xF9s7c7Y4UgK7eRxSKzAdpOVMZCRqWh
         0PrmUq7BcVHLEjWh4E+EKmiMUkCloVSIsTIbGhMQerJL28lW9a32VaDkSFLuWqGh0Jar
         ikDHpFL+Pmkr6jBSUCz2zw6ycDEqfPwjmQr3d5MTiPf2s3BUGn8Vdgzzpq2aSPzSuxeX
         AOkimZQRv1znfoNOKyWC1GnW8rOvwYzZn3byPT9nSszxBXW8IAna7WpfWihK5auR2IUo
         h45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263000; x=1781867800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kvpWhcnaBRhifpLWAZqMnNgp9C2UYNhPSO/KyWXo6NQ=;
        b=oBPEJeUcMUGSAnaO6dFFF43cwvj1An3PpCM8eRUkRnM3NFZU8auxkoueHuHxlt+cic
         GcXolYsnmS7k1CFRnG8qzpZCZcUB4aUkmACM8UYrqOke3JN0p12OR/GUQxj6Z/YOC6O3
         6LuSlGJAShpXi7AYVR98xOGr3jKJNkKKJcK8J/OIPt3Z4MLHoKszCFvlRqDpZRF+X1GN
         HJREYcz2uDouUOsCEz+uPwwcAZo4XdgQpkp+Qh7AzKDgUPxrR3RywS3CXsPX+/C/rZU9
         0yIkWElyOCABYCDM/pk9rMJMr+oWgqx0gTESaCHlRU86zmd9DjCWyp/B0sSmgLZRnDL9
         1hKA==
X-Gm-Message-State: AOJu0YyizGicRrJQrYpT4xDytTwzu+HANr/R/4CAPPyUJslXOcFfXUIk
	dIdBDwPWjbNqDqsgzf3DQLl08/i8M97+obk3A/dJ9lrhhJTNJi0U3v92kh2+HM0STG0t9kDeBcO
	Pf94e
X-Gm-Gg: Acq92OHQjGJ+1ugnhPUkjVzn2OAIN5NXXbge9VB3lXe3nBRT4p2K3cE5xSBy0QoY4iN
	3NSraL40rMIIV9AXbaf7L8BLYTurn9XRYDcdW4LKrkDSGrhGHlHKgiEW6PNZx5HbEXYRiaKLDk7
	1PpNxMUUfUGT7XKgpotisVtkrIwEnm0om3dBTRf5q2w2r3AUg9/89wL+WEmI+0UYOCEHX8ncJZ7
	NjBPJ02dtMitB/clQFAxvKFKnS7e8Z+sard6Rz7cc7Kz5GgVuxxXxTQZXmNLOs5ltzxGdITe7km
	n5vICrifr7nxfNeW/P5ZD2hqieZYDMIMhnuoFNoNwlOGI0MVBQaB5nqsvzry8NRPXBJOTBLulvi
	grIBMI2lzDMwIJTqPKks57jjIIWcj8xzDxkt3TOoU++1AoKzlZy3n46qYH40m8ueiHvvDnTHAHa
	NxlLM5CJkh5ENJRKGlJY6fxzHbGExQKWulTlE8dPhzDzsp/isiL9WQnAoa
X-Received: by 2002:a05:600c:1f88:b0:490:9df1:f0cf with SMTP id 5b1f17b1804b1-490ec4a15e0mr32315415e9.2.1781262999673;
        Fri, 12 Jun 2026 04:16:39 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c0d360sm161133865e9.0.2026.06.12.04.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:16:39 -0700 (PDT)
Message-ID: <c418cb12-0736-430f-bbfd-eb0c513ab5a1@suse.com>
Date: Fri, 12 Jun 2026 13:16:38 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/60] scsi: qla2xxx: Enable get_fw_version mailbox for
 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-17-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-17-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> The serdes_version and several firmware capability fields were not
> populated for 29xx because the get_fw_version mailbox path
> excluded it from the 27xx/28xx checks.  Add IS_QLA29XX() to
> the relevant conditionals so that firmware version, EDIF, and
> serdes information are correctly retrieved on 29xx adapters.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 2 +-
>   drivers/scsi/qla2xxx/qla_mbx.c  | 8 ++++----
>   2 files changed, 5 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
