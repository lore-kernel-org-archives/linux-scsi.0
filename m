Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8F6263C8F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268816; cv=none; b=jczZ1bj3htybopJTR9AFs/G+OnPE60Xw6uIBWtxPXd4gNJMEiXdA6JFZxX3SaMLGqgMuC7HLjxQNeczzJw51HeBHlFTERlvZe0mlvCKANpU2HODga+B00uwR8+rTrquf3U2qZJmBSSH2CiXDncCCzGfDhNmhQ4Ce+MzwHo6Gclg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268816; c=relaxed/simple;
	bh=+YhHsoUXdyOFTec/7IDciQKagDCI5LIQUUdTMR04wKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RXTXuJ+7wa8lnWygmCFUmr2+0jntIUkBDDct66cHA5YZ8muMYRH+/44PrrpZa+0kFsatJ74r3Uui1LJTWINwHekewdWpoPyffEZN/2UhFHxvBrbsB7HLSXUtxb8lAbPSfWf272119bvQjYnlHz4wcbUJqTVWRP9ti7gn01jGrPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GGrfCotC; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GGrfCotC"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45eec22fab7so408894f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781268813; x=1781873613; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IXJqfE5ZH+Gw15Z+kvhgosjeNvzM/ICwOFEk223rk4E=;
        b=GGrfCotCVHOhQ8TzjujUeN835pwZp+T7MfgYnf2z2/2qFt1vfH0xZUYzuDZEFtuito
         b4BFeO5EaEeRH4+eoO6mBUEbWF0MgbVAYjt+IVE6XRqgGVOrnKl8uYNCTHYjfk3cS/pt
         B92NAs+ryJUTBDzO3F28FG1HW+GJVSxebPiP4Cdd3JA9qT6iuSeJZfIPBnwMYtE0v1Hl
         jwDyVij2fL3BqJyU72XAhLIZ7Q41qzLqUABi+6SmBIPsk+2vfVPWBx9E410MjOu5sH1U
         fBpqNlhaiIYqb82xRzxOmV7gpiT0DiwQ9xBSckMbQdRlnDPk00kCAM36bvCXU3hgxesL
         oecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781268813; x=1781873613;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXJqfE5ZH+Gw15Z+kvhgosjeNvzM/ICwOFEk223rk4E=;
        b=XLjW8c7lS5VSHKjE6Sf1yJCDjNNjEUe+V6zX39sDXX3nM4N+d2LEbGWWECfj+SsZGD
         3zfjg4nOtv42HfbPep55tWkhry8N1Ti1YVTfUMC09c7uKBUjXCBBt7B5shnm3Ak9G6A5
         nZwJkpzCqpuElhr6DDq1xDWXdUoZtDzwiLKkZPKAUofumGEyInC//yoToNVXja0Qhmab
         rMg57EXQ8pXO3dpXLJ0jGFjep+52deVs2eXl6VsAGCoeUaClqHyu0RcXLCih6EjwCejv
         1fvv+038iw0taapuGnPDyWWGHD4SCJKdXB5JCY90wDxhRdaLO8pvY8kLKjWJXlEXu7yH
         8wZQ==
X-Gm-Message-State: AOJu0Yx7/HTrOSsg9nx76rMTSXrjMH+Em1uEJdg14zJfS97UkogD+nCC
	o03k7e2Eh6H0dBXRlkLiJ+zWXaYKhW5ljaU8Z4wK0VI1w/WA1ze4U8ohLj62LvGFUtY=
X-Gm-Gg: Acq92OERbG/83DERryGFtWtmAg5HP0Jsxc1R447XySG8cNRuRYoXxVDtVTjAOprDwiP
	pPJ5LeyBDQDUDLU2AM4OVxlmsxSDNpF0nNP4frKItRoFq+tz7M83z2ylGyJxSudgZ7ofVgLs6vl
	zm2xnsc8M+mmLm8UKEok9Qdmpmf1bRKnf62+JR6XKE4fr+5LU2/YNwqm2p1G7zvO6FVHEsHfWhw
	E1RCx399ZGVnMvWlAoqGJKL8v61oxqW6kQKF/hx4o+5lHi3gP4JXdwcoORLJ4aVdSOzFUgpvOrw
	ZjnZY4mPQD/8G0eJrAE+dlDgqfLBUxdwHaR3VoqET+DiFwVpoTmEYWvnUusUuOd3Aa7TusPLos4
	bLMM9Oy2aMHtjEc8RkhqMEp2V6FiKWgVw1fVvE7wyhEdJ4yqmIWfnShJyWX62zHnuWFN/pHecma
	zpzyGOXjLJdxK2A2/Q70fvDt2BYrLb/SzE7SgFEL2+jKoHn8f1dQQANdBl
X-Received: by 2002:a05:6000:430a:b0:43b:4f86:e985 with SMTP id ffacd0b85a97d-4606dbd79bamr4119587f8f.33.1781268813203;
        Fri, 12 Jun 2026 05:53:33 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0c35sm5739393f8f.22.2026.06.12.05.53.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:53:32 -0700 (PDT)
Message-ID: <824a083d-c061-4062-a2fd-50edc8f6c54c@suse.com>
Date: Fri, 12 Jun 2026 14:53:32 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 44/60] scsi: qla2xxx: Adjust feature gating in BSG
 paths for 29xx support
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-45-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-45-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> From: Manish Rangankar <mrangankar@marvell.com>
> 
> Extend qla2xxx BSG command handling to recognize QLA29xx adapters and
> align feature availability with hardware capabilities.
> 
> Allow QLA29xx in paths previously restricted to QLA27xx/28xx:
>    - Flash update capability queries (get/set)
>    - BBCR data retrieval
>    - D-port diagnostics
>    - MPI and PEP version sysfs attributes
> 
> Restrict unsupported operations on QLA29xx:
>    - Reject flash image status query (no active image tracking)
>    - Block qla28xx_validate_flash_image()
> 
> Guard the qla27xx_get_active_image() call with an explicit IS_QLA27XX
> || IS_QLA28XX check so it is not reached from adapters that lack the
> legacy active-image layout.
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c |  4 ++--
>   drivers/scsi/qla2xxx/qla_bsg.c  | 19 ++++++++++++-------
>   drivers/scsi/qla2xxx/qla_def.h  |  2 +-
>   drivers/scsi/qla2xxx/qla_fw.h   |  2 +-
>   4 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 37478af9cdec..fd3c8c207535 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1542,7 +1542,7 @@ qla2x00_mpi_version_show(struct device *dev, struct device_attribute *attr,
>   	struct qla_hw_data *ha = vha->hw;
>   
>   	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha) &&
> -	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>   		return scnprintf(buf, PAGE_SIZE, "\n");
>   
>   	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
> @@ -1770,7 +1770,7 @@ qla2x00_pep_version_show(struct device *dev, struct device_attribute *attr,
>   	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
>   	struct qla_hw_data *ha = vha->hw;
>   
> -	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>   		return scnprintf(buf, PAGE_SIZE, "\n");
>   
>   	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 00e980f0cd78..7f4558beee2c 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1900,7 +1900,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
>   	bsg_job_done(bsg_job, bsg_reply->result,
>   		     bsg_reply->reply_payload_rcv_len);
>   
> -	return rval;
> +	return 0;
>   }
>   
>   static int
> @@ -2544,7 +2544,7 @@ qla27xx_get_flash_upd_cap(struct bsg_job *bsg_job)
>   	struct qla_hw_data *ha = vha->hw;
>   	struct qla_flash_update_caps cap;
>   
> -	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha))
> +	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>   		return -EPERM;
>   
>   	memset(&cap, 0, sizeof(cap));
> @@ -2577,7 +2577,7 @@ qla27xx_set_flash_upd_cap(struct bsg_job *bsg_job)
>   	uint64_t online_fw_attr = 0;
>   	struct qla_flash_update_caps cap;
>   
> -	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>   		return -EPERM;
>   
>   	memset(&cap, 0, sizeof(cap));
> @@ -2625,7 +2625,7 @@ qla27xx_get_bbcr_data(struct bsg_job *bsg_job)
>   	uint8_t domain, area, al_pa, state;
>   	int rval;
>   
> -	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>   		return -EPERM;
>   
>   	memset(&bbcr, 0, sizeof(bbcr));
> @@ -2741,7 +2741,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
>   	struct qla_dport_diag *dd;
>   
>   	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
> -	    !IS_QLA28XX(vha->hw))
> +	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>   		return -EPERM;
>   
>   	dd = kmalloc_obj(*dd);
> @@ -2867,8 +2867,13 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
>   	struct qla_active_regions regions = { };
>   	struct active_regions active_regions = { };
>   
> -	qla27xx_get_active_image(vha, &active_regions);
> -	regions.global_image = active_regions.global;
> +	if (IS_QLA29XX(ha))
> +		return -EPERM;
> +
> +	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		qla27xx_get_active_image(vha, &active_regions);
> +		regions.global_image = active_regions.global;
> +	}
>   
>   	if (IS_QLA27XX(ha))
>   		regions.nvme_params = QLA27XX_PRIMARY_IMAGE;
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 3e2f1d8ba904..4fd2a28af7e4 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4454,7 +4454,7 @@ struct qla_hw_data {
>   #define IS_QLA27XX(ha)  (IS_QLA2071(ha) || IS_QLA2271(ha) || IS_QLA2261(ha))
>   #define IS_QLA28XX(ha)	(IS_QLA2081(ha) || IS_QLA2281(ha))
>   #define IS_QLA29XX(ha)	(IS_QLA2099(ha) || IS_QLA2299(ha) || \
> -			 IS_QLA2091(ha) || IS_QLA2291(ha))
> +				IS_QLA2091(ha) || IS_QLA2291(ha))
>   
>   #define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
>   				IS_QLA84XX(ha))
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index 050986c6217f..4d6f8b1a36d1 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -2360,7 +2360,7 @@ struct qla_fmb_upd_time {
>   
>   struct qla_flash_memo_block {
>   	__le32   signature;	/* "FMBS" */
> -#define QLFC_FMB_SIG	cpu_to_le32(0x464D4253)
> +#define QLFC_FMB_SIG	cpu_to_le32(0x53424D46)

Huh?
What happens here?
Simply exchanging a magic number for a new HBA?
And what happens with the old HBAs?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
