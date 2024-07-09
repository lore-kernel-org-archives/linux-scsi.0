Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996561E898
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 05:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720501626; cv=none; b=V8WgjQ/ZxqmNuZyEBZ0b07AkuvVVaEuHQ3KJfVuOYcvLj46oVSLriX3iMBcCrTklA9eMMRTXPAbQ5XMniiF8dFf3hAL20GYz0v4VHS64A7E4V9+KedYNQsj5bRVgxlSRcGVOas1BN/al9CrggBzJJk+3HfyYQxS0pq2N/8ESKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720501626; c=relaxed/simple;
	bh=WlQLX9yAd7Fn7mEQmC84c770523wWgnDollHcyUclX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eqis1luXa9GJL8WymsbOsxLYZYyYvTDHajPiUem3oVxFfl7WX3zxIPtmLO0/BdfiiSqNdNUNn4ZTqvLySEgJmxzXgvz5i5cXH4VmUqy5WSJouE63dw8cIke3kCwbOUEWEq5T2JC5Je5McUsOU/s3AGdgDIM1bgm+W9R5aHfg/v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DIKxj1P/; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DIKxj1P/"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-765590154b4so2197407a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 22:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720501624; x=1721106424; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Omn+7FEEAke55E353gl4NpjOUY6Yb+aN0igMIaM2c2w=;
        b=DIKxj1P/D8XT34RcxEW/yBoUkFmAz912b0rwjaS1FmJ8Qd+GGnruearM15AkmpN35I
         6MaitlPGCrfBlkn7jTP34tECeQyirlPVYfrERljGE8SYvOpmYhRo178AaYeA4QFfaN5O
         RFe/4WWMGghMSinwZOfaSvOBANZfUojFdGqrjkIT3BpRdcVHQBM5ltXfNiG16zEMRfrg
         njUkarH5CXGQd1fbghoMun18kLgK7xtb18/nQqXrqGj5KF2WdLiDSkAXrwn19+qTl9BW
         cMNri7gCDxuDG02QQg8quda3epdpLuCZ9PZZtC8pAmmJeRcsEDXVIMD39DIxgBrzm8qd
         BhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720501624; x=1721106424;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Omn+7FEEAke55E353gl4NpjOUY6Yb+aN0igMIaM2c2w=;
        b=uFPhTownYufz7T/pTrKt59/JpLAsv/2mAi5g7MlqxZpl2XcPaXbGzgUsIP+AbMrtPM
         GrB+FByrwyws/dFZ96r1uJns6dQGDXJa8RB5pTWLb6JjzHzens7X2P3uJ5XpMBqEDpqu
         oUiccAjHTg2jytzhqo31B6SIRBZpFrhkJfun0yuk/wOZqLCUZOfJoyixQOuFQl59SDUs
         uNV8B0ADxBbW42XVvEP1Q/j1hrCFXWc6klWpNLAV+YqPvVLGMmEcn8Mryjzc1xkhxTn4
         WMSK4KkiX/yQLzkMgg7yD26oqrQrnhfTe97IzPZochaydXqpBbSz4+kAucCYM09hpQRo
         QP0g==
X-Forwarded-Encrypted: i=1; AJvYcCVgMQQmguqq7sPzgWi27970g+uNnlzvGvnVhHoOtdJ/rf9SesZzBMgG7r/OJWE0k/m5ZhFdi1MPHEuZi1pQLlfDOLT1TgZrcx/bsg==
X-Gm-Message-State: AOJu0YyAAYawMkZ3mmuK+wGrHnXAOcPd6Pd6wsqhY6f1bYIcm964XxWc
	oGAcrglUwc2U7bvKgBq9o3S2FQ5Hqd9srUsuyFnzoL4qIyQMVQd67dntxkQOKG4pk4BcgjDB6mw
	=
X-Google-Smtp-Source: AGHT+IEaQdHTSlHgKpwz8p7kSLB4FmS1niYjRGM2oFLS2VJf7iyrtdHk0L2b6KYygh7Iyo3j+7Kwlw==
X-Received: by 2002:a05:6a20:c992:b0:1c0:eba5:e192 with SMTP id adf61e73a8af0-1c2982345bdmr1487200637.27.1720501623651;
        Mon, 08 Jul 2024 22:07:03 -0700 (PDT)
Received: from thinkpad ([117.193.209.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a2bedbsm7081625ad.101.2024.07.08.22.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 22:07:03 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:36:49 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v5 06/10] scsi: ufs: Inline is_mcq_enabled()
Message-ID: <20240709050649.GB3820@thinkpad>
References: <20240708211716.2827751-1-bvanassche@acm.org>
 <20240708211716.2827751-7-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240708211716.2827751-7-bvanassche@acm.org>

On Mon, Jul 08, 2024 at 02:16:01PM -0700, Bart Van Assche wrote:
> Improve code readability by inlining is_mcq_enabled().
> 
> Cc: Peter Wang <peter.wang@mediatek.com>
> Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c       | 28 ++++++++++++++--------------
>  drivers/ufs/host/ufs-mediatek.c |  6 +++---
>  include/ufs/ufshcd.h            |  5 -----
>  3 files changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3d452aa923dc..255d55e15b73 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -453,7 +453,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
>  
>  	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
>  
>  		hwq_id = hwq->id;
> @@ -2302,7 +2302,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
>  	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>  		ufshcd_start_monitor(hba, lrbp);
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		int utrd_size = sizeof(struct utp_transfer_req_desc);
>  		struct utp_transfer_req_desc *src = lrbp->utr_descriptor_ptr;
>  		struct utp_transfer_req_desc *dest;
> @@ -3001,7 +3001,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> -	if (is_mcq_enabled(hba))
> +	if (hba->mcq_enabled)
>  		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
>  
>  	ufshcd_send_command(hba, tag, hwq);
> @@ -3060,7 +3060,7 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
>  	unsigned long flags;
>  	int err;
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		/*
>  		 * MCQ mode. Clean up the MCQ resources similar to
>  		 * what the ufshcd_utrl_clear() does for SDB mode.
> @@ -3170,7 +3170,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
>  			__func__, lrbp->task_tag);
>  
>  		/* MCQ mode */
> -		if (is_mcq_enabled(hba)) {
> +		if (hba->mcq_enabled) {
>  			/* successfully cleared the command, retry if needed */
>  			if (ufshcd_clear_cmd(hba, lrbp->task_tag) == 0)
>  				err = -EAGAIN;
> @@ -5561,7 +5561,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
>  	u32 tr_doorbell;
>  	struct ufs_hw_queue *hwq;
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		hwq = &hba->uhq[queue_num];
>  
>  		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
> @@ -6202,7 +6202,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>  /* Complete requests that have door-bell cleared */
>  static void ufshcd_complete_requests(struct ufs_hba *hba, bool force_compl)
>  {
> -	if (is_mcq_enabled(hba))
> +	if (hba->mcq_enabled)
>  		ufshcd_mcq_compl_pending_transfer(hba, force_compl);
>  	else
>  		ufshcd_transfer_req_compl(hba);
> @@ -6459,7 +6459,7 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
>  		*ret ? "failed" : "succeeded");
>  
>  	/* Release cmd in MCQ mode if abort succeeds */
> -	if (is_mcq_enabled(hba) && (*ret == 0)) {
> +	if (hba->mcq_enabled && (*ret == 0)) {
>  		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
>  		spin_lock_irqsave(&hwq->cq_lock, flags);
>  		if (ufshcd_cmd_inflight(lrbp->cmd))
> @@ -7390,7 +7390,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		for (pos = 0; pos < hba->nutrs; pos++) {
>  			lrbp = &hba->lrb[pos];
>  			if (ufshcd_cmd_inflight(lrbp->cmd) &&
> @@ -7486,7 +7486,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>  			 */
>  			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
>  				__func__, tag);
> -			if (is_mcq_enabled(hba)) {
> +			if (hba->mcq_enabled) {
>  				/* MCQ mode */
>  				if (ufshcd_cmd_inflight(lrbp->cmd)) {
>  					/* sleep for max. 200us same delay as in SDB mode */
> @@ -7564,7 +7564,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  
>  	ufshcd_hold(hba);
>  
> -	if (!is_mcq_enabled(hba)) {
> +	if (!hba->mcq_enabled) {
>  		reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  		if (!test_bit(tag, &hba->outstanding_reqs)) {
>  			/* If command is already aborted/completed, return FAILED. */
> @@ -7597,7 +7597,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	}
>  	hba->req_abort_count++;
>  
> -	if (!is_mcq_enabled(hba) && !(reg & (1 << tag))) {
> +	if (!hba->mcq_enabled && !(reg & (1 << tag))) {
>  		/* only execute this code in single doorbell mode */
>  		dev_err(hba->dev,
>  		"%s: cmd was completed, but without a notifying intr, tag = %d",
> @@ -7624,7 +7624,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto release;
>  	}
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		/* MCQ mode. Branch off to handle abort for mcq mode */
>  		err = ufshcd_mcq_abort(cmd);
>  		goto release;
> @@ -8733,7 +8733,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  	ufshcd_set_link_active(hba);
>  
>  	/* Reconfigure MCQ upon reset */
> -	if (is_mcq_enabled(hba) && !init_dev_params)
> +	if (hba->mcq_enabled && !init_dev_params)
>  		ufshcd_config_mcq(hba);
>  
>  	/* Verify device initialization by sending NOP OUT UPIU */
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index c7a0ab9b1f59..02c9064284e1 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -693,7 +693,7 @@ static void ufs_mtk_mcq_disable_irq(struct ufs_hba *hba)
>  	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>  	u32 irq, i;
>  
> -	if (!is_mcq_enabled(hba))
> +	if (!hba->mcq_enabled)
>  		return;
>  
>  	if (host->mcq_nr_intr == 0)
> @@ -711,7 +711,7 @@ static void ufs_mtk_mcq_enable_irq(struct ufs_hba *hba)
>  	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>  	u32 irq, i;
>  
> -	if (!is_mcq_enabled(hba))
> +	if (!hba->mcq_enabled)
>  		return;
>  
>  	if (host->mcq_nr_intr == 0)
> @@ -1308,7 +1308,7 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
>  	if (err)
>  		return err;
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		ufs_mtk_config_mcq(hba, false);
>  		ufshcd_mcq_make_queues_operational(hba);
>  		ufshcd_mcq_config_mac(hba, hba->nutrs);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 42d1bd2120ea..3eaa8bc7eaea 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1133,11 +1133,6 @@ struct ufs_hw_queue {
>  
>  #define MCQ_QCFG_SIZE		0x40
>  
> -static inline bool is_mcq_enabled(struct ufs_hba *hba)
> -{
> -	return hba->mcq_enabled;
> -}
> -
>  static inline unsigned int ufshcd_mcq_opr_offset(struct ufs_hba *hba,
>  		enum ufshcd_mcq_opr opr, int idx)
>  {

-- 
மணிவண்ணன் சதாசிவம்
