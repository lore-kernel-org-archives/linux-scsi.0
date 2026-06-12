Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB263AA4EA
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266611; cv=none; b=O5s7zCldPYKF55LbBHjM1Wt2ou/GG0hbUYkuBlC+ovo87m8AFyrJGwqarHIeUIc042yjAUsTcJnR/FffA1/JTTa1u0WDQd+DqCni6GRe26N//PDlSPzPDM0aru0s330ko8sKZP/JYt8O7tkMdBr9FhVgxo10iKGgoMCJ0U5v8Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266611; c=relaxed/simple;
	bh=LcjPqLgZqrD/SjmZNNvGDTTOQlGN5hAVIrSRrPSrKJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZF68wucmqx+KCyh0Tnm3BzVhBA0F8+6HwS10lRNkz4QDeP6nIWLMfWJvjzsdyX9EQSCT2fe3V1ojdwB5sFZNMAiEaipYfiLHceXRWuNy0KUCTK8SMzDNRZUjhng1KspYLAsa9ByceFqS7s9DP6bN98ktivDyiI7u3WnlezAH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vr6YDeIn; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vr6YDeIn"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490e1904089so7713855e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781266603; x=1781871403; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9s8ci8sD+PafYwNMJJl3OuxCWC1xI+Y0tY8HWlVjeEQ=;
        b=Vr6YDeInOm/TQ/+zl2CLj92sMdI8+9we9gcmx7Sz7WYQwMENUpC2rCURiBw7LZ2tN8
         0J6qKZWe9Ku+KlaUrVHHVlWM1YW1StMvNJXEKUJYkMRKUquUCYpOOt9Vm9pdHCHyzJo7
         f0dyJKCbO0ALbcqi1i4lBJfLaexYbDBGaJHxExS7qOVbelsLsvOMKFeMq7iVHjbFdKG4
         7oSVPIvjmFtO6TDg52tKRHAkZxs2dHOXzEU6JK1cdNYmy37lI+2zVNojRXpfBnNwkJuA
         sMGj2okwcMn1xclDorK0LCUpfuWuFgxhU88ZVKAarHM2XHIhwBngEp4V2BhxRJRkzvkj
         dwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781266603; x=1781871403;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9s8ci8sD+PafYwNMJJl3OuxCWC1xI+Y0tY8HWlVjeEQ=;
        b=JVzeRdaGWbHm3kBCsuxkJkhoXCV9ndchQQPTYDcVvaM6QDXhVHWXJne/MbQGOou/5e
         6hzmD2ltE8YnuqxCHGTzyFBmRCj/LOikzImg77sonzVc4hknJyx5pi8B9FPWhcgll+v/
         Ih+Cnyd0mFxfozPeggMLstn7iKj7v/b9jrZMdoqBEvgE9cT/MXvu8U+5hNC1gCKqHKxX
         xcYEv88HOIM1TJvDpBCzOuVyxT8rrb6NkmB9RSoT8lJQNS2G/YMwsAjx29ps2HpkZXNg
         TRvNftxTGP4jEXlGg7ZhtiXc9qPCG8Zv+a/W8SOBC2/oSlgDeWozNkDOJl7ei3DFUCUP
         +KLw==
X-Gm-Message-State: AOJu0YzhCH3v2eGTPHOtPPO0uYT8UOuq2Nm10jOIrOquyD789x6C3UZ+
	16p/J+/7OGB+pLy+e9o+0rVH7DucnlKdURpkMOKrgVMTPfmSEN3Q1cA4z/cUupsACTKaqxjMwSI
	g6h1j
X-Gm-Gg: Acq92OHRvKhzcVdXSEaxTrpz7pAHPWAgbXA6blAe0gBBhm8GHXzCmDxHFUyJrGxjkYR
	jPg9mZO3Q5xcadCUU0l9qtrd5nKBzrW0e7ftepLAUhL8byW59+3Mk33FlSB7H8/nLfvtuN8c3bT
	3LUPB11/fIiUzTGZJO5wON/xpiVv4F1gJLboQTPeUR9JriiobZ6fN5F9xrkOteeD9VUWAHwnfOH
	/q6jtTdMgsaKTQkQYKsTI2FtZ5fbDE/JVFjYLEwPQe5XFxVoz7gkaOUpbIDRpV6G7GcSqnkbIFP
	23AZ5yhAeSotIHcZvMgzaNI74qVII5bdJRpcfXaJXINyM3/yJ+PdDEFYdIWUtoB+8oKdrvvhvn8
	/+oB4q7rIGPNk06Fw5AlugvUM+RzEf5JCWYPFRmFcDUXytxPkOdgjXS3K/g8pB0D+G6IBeeXdBO
	yZl0JN6M2B9VkHAWDw9Pl+VGGMdtuJ/SvtKT/DioknOj9SzqlcHhVYqFmU
X-Received: by 2002:a05:600c:354f:b0:490:d354:d151 with SMTP id 5b1f17b1804b1-490ec4fe7aamr32663455e9.18.1781266602908;
        Fri, 12 Jun 2026 05:16:42 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c512sm35810285e9.2.2026.06.12.05.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:16:42 -0700 (PDT)
Message-ID: <41c86a86-506d-4700-bfa9-2866dd7733c9@suse.com>
Date: Fri, 12 Jun 2026 14:16:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 31/60] scsi: qla2xxx: Enhance purex_entry handling for
 29xx series
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-32-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-32-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Update function signatures and internal logic across qla_edif.c,
> qla_isr.c, and qla_os.c to accept a generic pointer for packet data and
> differentiate between standard purex_entry_24xx and the extended
> purex_entry_24xx_ext structures based on IS_QLA29XX().
> 
> This ensures proper initialization and processing of command and response
> data for both 64-byte and 128-byte PUREX IOCBs across all ELS paths
> including auth_els, RDP, copy_std_pkt, copy_multiple_pkt, consume_iocb,
> and copy_purex_to_buffer.
> 
> Where the two layouts overlap at byte-identical offsets (entry_count,
> frame_size, nport_handle, rx_xchg_addr, ox_id, status_flags,
> trunc_frame_size, s_id, d_id, els_frame_payload base, and
> response_t::signature), use a single struct purex_entry_24xx * view to
> avoid duplicating read paths.  Branch only where field encoding differs:
> vp_idx (u8 at offset 6 in 24xx vs __le16 at offsets 6-7 in 29xx) and
> els_frame_payload[] array length (20 vs 84 bytes, handled via a
> sizeof_field()-based payload_size local).
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  |  3 +-
>   drivers/scsi/qla2xxx/qla_edif.c | 68 +++++++++++++++++-------
>   drivers/scsi/qla2xxx/qla_isr.c  | 94 ++++++++++++++++++++++++++-------
>   drivers/scsi/qla2xxx/qla_os.c   | 24 +++++++--
>   4 files changed, 145 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 0bbe2bae7101..3e2f1d8ba904 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -5000,6 +5000,7 @@ struct active_regions {
>   #define QLA_SET_DATA_RATE_LR	2 /* Set speed and initiate LR */
>   
>   #define QLA_DEFAULT_PAYLOAD_SIZE	64
> +#define QLA_MAX_IOCB_SIZE		128
>   /*
>    * This item might be allocated with a size > sizeof(struct purex_item).
>    * The "size" variable gives the size of the payload (which
> @@ -5014,7 +5015,7 @@ struct purex_item {
>   	atomic_t in_use;
>   	uint16_t size;
>   	struct {
> -		uint8_t iocb[64];
> +		u8 iocb[QLA_MAX_IOCB_SIZE];
>   	} iocb;
>   };
>   
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index b05f8e0b705e..f8bc248e5d18 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2534,7 +2534,7 @@ qla24xx_sa_replace_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb)
>   
>   void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
>   {
> -	struct purex_entry_24xx *p = *pkt;
> +	struct qla_hw_data *ha = vha->hw;
>   	struct enode		*ptr;
>   	int		sid;
>   	u16 totlen;
> @@ -2544,26 +2544,58 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
>   	struct fc_port *fcport;
>   	struct qla_els_pt_arg a;
>   	be_id_t beid;
> +	__le16 nport_handle;
> +	__le32 rx_xchg_addr;
> +	__le16 ox_id;
> +	__le16 frame_size, status_flags, trunc_frame_size;
> +	uint8_t s_id[3], d_id[3];
> +	uint8_t vp_idx;
>   
>   	memset(&a, 0, sizeof(a));
>   
> +	/*
> +	 * purex_entry_24xx_ext (29xx) overlays purex_entry_24xx for every
> +	 * field touched here -- nport_handle, rx_xchg_addr, ox_id, frame_size,
> +	 * status_flags, trunc_frame_size, s_id[3], d_id[3] -- with only
> +	 * vp_idx differing in width (u8 at offset 6 vs __le16 at offsets 6-7,
> +	 * with reserved2 at offset 7 in the 24xx layout). So all reads but
> +	 * vp_idx go through a single struct purex_entry_24xx * view.
> +	 */
> +	{
> +		struct purex_entry_24xx *p = *pkt;
> +
> +		nport_handle = p->nport_handle;
> +		rx_xchg_addr = p->rx_xchg_addr;
> +		ox_id = p->ox_id;
> +		frame_size = p->frame_size;
> +		status_flags = p->status_flags;
> +		trunc_frame_size = p->trunc_frame_size;
> +		memcpy(s_id, p->s_id, sizeof(s_id));
> +		memcpy(d_id, p->d_id, sizeof(d_id));
> +		if (IS_QLA29XX(ha))
> +			vp_idx = le16_to_cpu(((struct purex_entry_24xx_ext *)
> +					      *pkt)->vp_idx);
> +		else
> +			vp_idx = p->vp_idx;
> +	}
> +

And these braces are here ... why?

Please drop them.

Otherwise looks okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
