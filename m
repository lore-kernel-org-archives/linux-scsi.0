Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A5B16D304;
	Fri, 31 May 2024 20:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186521; cv=none; b=P5hVyiVJEi4JVxSEjoBUwEyd6FVA9HTpcT4W8dwQlOdzbRbtbjJQAMOrs8qeEl3EFR6zX62gLtSppHIOSBzrSWh0/0b8ATMUJWK9d/qDDvvwslcWVMgHkvrtTItjY0aUCdUIWpAdHBirX6Ohs4ejgBqqqNt0jweR/IFiwNi/VK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186521; c=relaxed/simple;
	bh=d6aGW+pIDFiapL3UW/sPgZqq4PujkHfCSTQjOBLWN2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1DmLTntO0ItnmW/PZFvLSlKh8WM4pJDYHYM52DeBkMmLFGaeGJSaAHHIaP05oQpr9dI+fV8v8USjLqav/aC8Xqgtk2NOOKHpiYrPKWYbe/ZI4l1kRZkfrOXGOnjXSSMZUVEO9BkWfo+YPYk0r11ZociFtdPCmgtd7Dgb0fjCyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1GMMFMCX; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1GMMFMCX"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VrZ9f20bMz6Cnk9T;
	Fri, 31 May 2024 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717186513; x=1719778514; bh=2Y3Pe3+LfI0xR2unWHqUImjm
	wshLFsOW5x2A6pIes50=; b=1GMMFMCXT+P9gnOBuPFYb2L/TYRRoLPVo8Jl4aRr
	vAt/X1sBc9d3yR53LfY5Kw0ECcW0o3VFr3sFYBaR7ewoDWPscSq1J5thociLR8QP
	/sSaIgZXNMpxwBPC4xkIDQp7nxwYQvLOecWNE67tOxUH9Rb6G2VwLVHrnI1nhDB7
	TjdLdAyrf3E79PtOi/mLrKQYS3doa/r65h1Fy7dDs0ln6PtiLvMC43bBrAr0GHg7
	mSeulHIcyY96E6Zz2cr1x4XG108rhvaDx2X8FYGO3DVT8TSYwPIKP5RRGAtbkVG1
	FHSuOWGGbDbu2xMCNRbdeQDGstSL0MPR974MLIEJIFmk+Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rkVFpO69MbnZ; Fri, 31 May 2024 20:15:13 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VrZ9X43HRz6Cnk9F;
	Fri, 31 May 2024 20:15:12 +0000 (UTC)
Message-ID: <d3d2d848-e70c-462b-bbb2-f5a2308646fd@acm.org>
Date: Fri, 31 May 2024 13:15:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ufs: mcq: Add ufshcd_mcq_queue_cfg_addr helper
To: Minwoo Im <minwoo.im@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
 <CGME20240531104947epcas2p1cd477921c1cd307d84f9ffc25b2c08a8@epcas2p1.samsung.com>
 <20240531103821.1583934-2-minwoo.im@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240531103821.1583934-2-minwoo.im@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/24 03:38, Minwoo Im wrote:
> This helper returns an offset address of MCQ queue configuration
> registers.  This is a prep patch for the following patch.
> 
> Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
> ---
>   drivers/ufs/core/ufs-mcq.c | 14 ++++++++++++++
>   include/ufs/ufshcd.h       |  1 +
>   2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 52210c4c20dc..46faa54aea94 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -18,6 +18,7 @@
>   #include <linux/iopoll.h>
>   
>   #define MAX_QUEUE_SUP GENMASK(7, 0)
> +#define QCFGPTR GENMASK(23, 16)
>   #define UFS_MCQ_MIN_RW_QUEUES 2
>   #define UFS_MCQ_MIN_READ_QUEUES 0
>   #define UFS_MCQ_MIN_POLL_QUEUES 0
> @@ -116,6 +117,19 @@ struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
>   	return &hba->uhq[hwq];
>   }
>   
> +/**
> + * ufshcd_mcq_queue_cfg_addr - get an start address of the MCQ Queue Config
> + * Registers.
> + * @hba: per adapter instance
> + *
> + * Return: Start address of MCQ Queue Config Registers in HCI
> + */
> +unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba)
> +{
> +	return FIELD_GET(QCFGPTR, hba->mcq_capabilities) * 0x200;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
> +
>   /**
>    * ufshcd_mcq_decide_queue_depth - decide the queue depth
>    * @hba: per adapter instance
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index df68fb1d4f3f..9e0581115b34 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1278,6 +1278,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
>   void ufshcd_hba_stop(struct ufs_hba *hba);
>   void ufshcd_schedule_eh_work(struct ufs_hba *hba);
>   void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds);
> +unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba);
>   u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
>   void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
>   unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,

New functions should not be introduced as a separate patch but instead should
be introduced in the first patch that adds a caller to the new function.

Thanks,

Bart.
