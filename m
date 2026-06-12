Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DCC2E739C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262886; cv=none; b=XrdbvoO8KehZod7DjHAtkyZOoWDqIhWJEaHGDX/x1sH+dzex+zktKR5eAvGcasQ/QUn6UKmkzpytIjcQSaACTjakPIXoFDBEHO3K5DrKEu54Z35OiY/LEpqBOQijFV5nJWtIY0atXx92aP91SrU5kaUwlSfRJMsi5EwIrkYZWFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262886; c=relaxed/simple;
	bh=/IrHghdgsdgs5QBL00ej1dwOKgUrt2C7vILt+82YE6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SptY7kifdSvY7VzN2KsjlfLWQGItD8901cDGKUixXUpcV985KRQp6IbBT3rE9lAN9KeBfAIA8+/muXgTmxih5vteebpky+MtlsRb1Px5tkEsKEM2qDynUmT2WD9W3Y0i+4HLiPeYkN53LMOlFCiYomzuoHsWYIJMt33gR1vQqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Sh4/PVCb; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Sh4/PVCb"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso438227f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781262883; x=1781867683; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dRRtLHkQ3Os8CT53CACVrpC1AcxUFHNNrA+QQ35wfyM=;
        b=Sh4/PVCb2qoUB6fdR+H+/V+qvvjW7wWbd9ap0RU7Qqh9f8cFhPfQNt0DifNwkA/z+a
         sgayyUXqN8+nQHRz4MeTqjRx1S3z/mFtZetRwE+n3HMo1BsRgc5+xw+04/aBbJcnOKHl
         vSC26unY0FRBLRpR/c3dPQ03Pm9qEjxOTK+uFQjYCOmuB9B8BEut20PtFk01tbpBL3L2
         kQ2luexPixH2M5kyynsr7AV0RcXXf13P/NuA3hDU6sUbjxvlZWx7KMJJ+VeL6DWfXVQ5
         8P+L2RdDQPFw5Sw1pAzWx4gDYbPTw7D5VWzenTYtDKkTz3iFQTB1mcXAJs3Q6RPMIc0W
         jHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262883; x=1781867683;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dRRtLHkQ3Os8CT53CACVrpC1AcxUFHNNrA+QQ35wfyM=;
        b=rZmw+sgOWkHnQndgFRrKg/TT9PzYh3MdtGOZ1PzLX2sD+AF3f31k2E4XYsGlbTHY1u
         7a4IvhaRUwDDtAN+aQ7F3UV3Scybo1qvtHBcxPtbwfNA3Ii9vHUOsvXjBtbUp/8wMpVG
         5DgKwq3xMV6E1rL6pcNWM1nZYYjM5OJ6PS3tEo7B/TWDi+Or3+uROUeoiwj1vpKUK2Yc
         qlDFsvSjwRQz14DP7Hy67xnrNqQUEa+ddH4D6HGSCF1eJfgwKmnQEqv8hwLHFll0nlcV
         E8v+fTASux/4DkzYYauzR4Bq6dB6uybpd6V2HO32F1AsrGR5f7MvH9UHnxkm3T9pYO6A
         lqAw==
X-Gm-Message-State: AOJu0Yy1i+GBSWUEBOu2nZD3nl+ZbVfuZCjaisRu0kBfV7nFFZJJmhwn
	EIIVbRypnictWtp3uRka/3UO9/2Pyysne7qQ7vWMHec/GxrZbvjeaevkAeIFl76cgAlIv0NDNKg
	8YKyI
X-Gm-Gg: Acq92OFzRZQ+7PEKbAaI/43oakcD3+TIckz5Mx+Krh1LR2NWmAZlQsoeKs06ls+2hgm
	OGVZmu4TsHD2I8pwT1DAStRH754V9N0cYqdkq8Q4bQS5Ds1yPL6bDUsNWDMWT/xbZuNiH5PhNNx
	tPdxwb2WeGBZxBk6WAQR+zORkhfglx92j3nqkA2n7Anh5jzu3q92ObItjHG6TqaI1j+/VcJ1s5h
	yMe/7iWywd52Hki7C5zLb1Wk1K5EhtrQxcUmRxQxx8wsonD7N6U4V9UeQqqBCIBRZIyc5lM+ipv
	d4AimbbMrlTXoC551f1nEX6cllRIus9Afg9MyxwdeDq9OgEJTfDs5XMZaSzN3a0wxIJpmw/KrV2
	1NI4u9Ep/YcWHKxSZirlJzmrj/Vw4L8xACZhNHQ406B3Jz7goZaN8PxeOBQslPUfItZMhiTlIft
	qjKyP96h+BXkdqaOl+TZFdKY6Ci2aNaK4um7b55XsfszuqE62NzpjIQS90
X-Received: by 2002:a05:6000:4013:b0:460:3233:beef with SMTP id ffacd0b85a97d-4606dbb8427mr3457437f8f.43.1781262883485;
        Fri, 12 Jun 2026 04:14:43 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2e592csm4880508f8f.36.2026.06.12.04.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:14:43 -0700 (PDT)
Message-ID: <ad0f596e-8221-4145-a8d0-d15b4445b2f7@suse.com>
Date: Fri, 12 Jun 2026 13:14:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/60] scsi: qla2xxx: Skip image-set-valid attribute
 for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-15-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-15-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> The 29xx adapter does not support the QLA_IMG_SET_VALID_SUPPORT
> driver attribute.  Gate the attribute behind an IS_QLA29XX()
> check so that userspace applications querying driver capabilities
> via BSG receive accurate information.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 92a0bc6dc7bc..00e980f0cd78 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2904,11 +2904,14 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
>   static int
>   qla2x00_get_drv_attr(struct bsg_job *bsg_job)
>   {
> +	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
>   	struct qla_drv_attr drv_attr;
>   	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
> +	struct qla_hw_data *ha = vha->hw;
>   
>   	memset(&drv_attr, 0, sizeof(struct qla_drv_attr));
> -	drv_attr.ext_attributes |= QLA_IMG_SET_VALID_SUPPORT;
> +	if (!IS_QLA29XX(ha))
> +		drv_attr.ext_attributes |= QLA_IMG_SET_VALID_SUPPORT;
>   
>   
>   	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
