Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA29537CD45
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781267819; cv=none; b=ToOn+iiadRh+zwWO8CV4OD8w6lnfVxNHbPYJ3M2EQr2RZwK/YRSb0u7KYycFXvRURMb4VQ0ayY+JrvtjhEYQmeoyoma231QnoS7+YcD6PWaqVPQcR2xIl6mZQ/+M7dNK2WYHVTcrjogndq+cfCSKVtBOuTCIBT6HrZrF0G25Aj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781267819; c=relaxed/simple;
	bh=Srz3T+iePUOCZtTB5OfhfNKyD5krbvN6QpvufKqbFWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JixqbF6SBf19RrZxSVdCaT7Ojh5EFnzQG0Wr71G4cCPXfthsIhhmJgiCLCiyr22SOIzkxJInmBc4GWKZ1fjk7bHKNE5vYbrG8qXSUZvcDQcEcQ7rcu+V+zalvwdGqh4kGaoarUd1QpNwwgulJwDphT31IBLMmH83xrSYM9Mu5sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LPAf+GL+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LPAf+GL+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so9743215e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781267816; x=1781872616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NDPuOhtRKoc2o9gALOwF5IkxVxSv2Vi6j0K7JaoKQPQ=;
        b=LPAf+GL+dYpD5WXBDeOlvitR1VSO9glUhQwcFeia3/nLOV/yzdks8nUt0XllkJIqQ+
         7y09uKfKDZonqpDSHBd0OdyiZT6IjbvpjjWlK4dp46ajgwwbS+zoD0VkWq6IgAQMS4FJ
         RopLBPPKd75gkwxAsicQ7kVGhhE+Lx/vPzkNQx//xVOuEx16ccouNrPnjXCXEB8eBPgN
         jlfr8xO41jRAHVfmlBmEKlgFviVFeEHoEQZphSJM1UKm7ZvqWzAqPHJWPQL2y2onwfT5
         Jj0tiJmgr+eCxeylvxnQG57oQfC9eQdb+JrdE8jxcqm9ufIu4+CrzWBgIFEo8grWPMzG
         OtUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781267816; x=1781872616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NDPuOhtRKoc2o9gALOwF5IkxVxSv2Vi6j0K7JaoKQPQ=;
        b=AFgI3rvO4EVJj5H81sTDlcCY8s9m5+JYcr+v+IrIj480D8zV0yGzWZIyLRbQ1Ba68t
         5poWyFKWBCuFMPanavqTRWZp1FX7Kj6lFU3hHMdgIDzs0UyC9yIhKniOJEf6hSjFyqPV
         b5YdEGgECiK3I3NAkz4vNzqqXhMWP6FSA358hmOeHN6y7p8Oi/fEw3asqDqdmF8dpyiH
         PtusCFjbNb2Ycm2COk8YnwfNAU3+6tWgVp/FLzU6murXrZwPfGQNsgVYth4uaeZ9Jbf0
         24dwv+kfJAq5GGvRI+6DEPYR47+pUvmbuXt5jc9AMJ9xisgvJfEJw7AKuhdvc5LJFgD6
         HeMA==
X-Gm-Message-State: AOJu0YwwU/6i4JHuGiPsY5YvEStusAnkukw533C6t4T/jRo5BNIzoI+e
	JqtEV2Dc5g4C+qMBcUwcXFXsx+NmnoOmhliwzNhSxZURZLocVqJitmfU6oaDbx9Qaew=
X-Gm-Gg: Acq92OHP9t9shW55OdHLzlTQEo/kfXSfQcK8Wv8+w0fITTgdG/iZemyO5yI9zZJ2q4K
	dLN8hU7grRW4rmIb2GGfdsDgnmGB2Pk+cq6+MxXEHdu4wSG6ExL38igQxPu2d0PtKTUqDOyjMUo
	8742Yf3E4OQu9lucIb7HrcW8QH3GKMZjEzCvMn3o8l0bi/LFrxKun5D/rcOISVhSnLBcWfhwOQC
	7R/YRVXCr71SUdp4Ss7IPZqzDEA2BaXyqy+nJ29/kEecQMCk4R7VZOwJP7OG+0indW8FTl20WvZ
	lCsM5dt8HRx9QKk5DDfFq/wr0Tj4rrtnhDZa8KXM1cQgH/F3j1zkwndIgpW0A7/U2u6Sx9ron8k
	VGAatnYCEYfdqTgZItMlGp+Iwud+pLWG8aAOkUthXpMsvOUp6QdODSD2An0QoMy/eJcwkaY5/vk
	bbOTvONLF0i0Q216yGLgVn6C83KOgbn/zi4YQy5xkeNiXcSZA6q2GeqPzL
X-Received: by 2002:a05:600c:2941:b0:490:b780:13f7 with SMTP id 5b1f17b1804b1-490ec50b526mr25887365e9.23.1781267816014;
        Fri, 12 Jun 2026 05:36:56 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7db56asm80279995e9.7.2026.06.12.05.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:36:55 -0700 (PDT)
Message-ID: <8341e3e4-433c-4d3c-8af8-8c9177a271a0@suse.com>
Date: Fri, 12 Jun 2026 14:36:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 34/60] scsi: qla2xxx: Add 29xx extended logio IOCB
 support
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-35-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-35-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> The 29xx series uses a wider IOCB stride (128 bytes vs 64 bytes).
> The logio_entry_24xx_ext layout extends logio_entry_24xx with a
> wider vp_index field (__le16 vs u8) while keeping all other
> read-side fields (comp_status, io_parameter[0..10], entry_status)
> at identical offsets and widths.
> 
> Update the logio IOCB builder functions (qla24xx_login_iocb,
> qla24xx_logout_iocb, qla24xx_prli_iocb, qla24xx_prlo_iocb,
> qla24xx_adisc_iocb) to accept a void pointer and dispatch the
> vp_index write through IS_QLA29XX(), using an inline cast to the
> extended layout at the single write site.
> 
> In the completion handler qla24xx_logio_entry(), accept a void
> pointer and read through a single logio_entry_24xx view since all
> accessed fields sit at the same offsets in both layouts.  Use the
> qla_req_entry_size() helper for the dump buffer size.
> 
> In qla24xx_login_fabric() and qla24xx_fabric_logout(), allocate
> through a void pointer from the DMA pool and dispatch vp_index
> via the same inline-cast pattern.
> 
> Add a BUILD_BUG_ON for logio_entry_24xx_ext to enforce the 128-byte
> size invariant at compile time.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_iocb.c | 48 ++++++++++++++++++++++++++-------
>   drivers/scsi/qla2xxx/qla_isr.c  | 41 ++++++++++++++++------------
>   drivers/scsi/qla2xxx/qla_mbx.c  | 35 ++++++++++++++++--------
>   drivers/scsi/qla2xxx/qla_os.c   |  1 +
>   4 files changed, 87 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 45d6837100ad..d0d3a56affdc 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2488,8 +2488,9 @@ qla2x00_alloc_iocbs(struct scsi_qla_host *vha, srb_t *sp)
>   }
>   
>   static void
> -qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
> +qla24xx_prli_iocb(srb_t *sp, void *pkt)
>   {
> +	struct logio_entry_24xx *logio = pkt;
>   	struct srb_iocb *lio = &sp->u.iocb_cmd;
>   
>   	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
> @@ -2516,12 +2517,17 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
>   	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
>   	logio->port_id[1] = sp->fcport->d_id.b.area;
>   	logio->port_id[2] = sp->fcport->d_id.b.domain;
> -	logio->vp_index = sp->vha->vp_idx;
> +	if (IS_QLA29XX(sp->vha->hw))
> +		((struct logio_entry_24xx_ext *)pkt)->vp_index =
> +		    cpu_to_le16(sp->vha->vp_idx);
> +	else
> +		logio->vp_index = sp->vha->vp_idx;
>   }
>   

This really cries out for a helper; the same code snippet is used 
throughout the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
