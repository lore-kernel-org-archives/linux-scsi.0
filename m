Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4768178CEE
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011799; cv=none; b=CriH6QUUH9BTBuDuHoLvvJbg3p92M+phTP+CQaoJMxFDmUjRPdMbr3ZmvIck094eoba8w0SceSA6P92KfYdmXtIqW92cBYyMlx97g3h4TmEO4IRlhX/XU+scTn46MlvWXAf2czXScOOab2HtqYwwwmlNQmWMBoyaBhvQnqDMo38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011799; c=relaxed/simple;
	bh=lGOZptKMT6hqeYhYiZa6CcSWg0qhnZUGnJtgCJa2/4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Am0hUwNc38wVwkPi29yU418IUdCIh2P9b+2zlNJuzrk/6bkCldrTxoQX4goy/VtpbMl0HyJB1qmTYkM7UnPSHpYxLY8yVJK5/8Y8eVBK7ln0IdWRsHK4scR2llXyx9+eeqDQpXiG1B5lSapeiAr/JdUNOm4TTHlWtLUpIruNefA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wPXkoxZp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wPXkoxZp"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f9e2affc8cso33867105ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jul 2024 06:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720011797; x=1720616597; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fJXV9tMkrP1RDlcaXvs7Y1MbET5oggImz97UisEWE9I=;
        b=wPXkoxZpQ75jANX/HpO2JtF4MMdSY8oJx+NZosJD3HJDqIMcHpOImOFtlRvEYsmLK1
         GApUJiihGqPO8QssiMaXiKQXKMD1PoJBiexUetCO1yFyoc+RfCJof2pt51ZULMpSgQJV
         FRjHsWk8X500GxDwGLuWMKZcExdZeev5Ww4O13lz0+ENtL1CPDw+EBAGDDbe5JzOh8pI
         ifzIJkclzAIEJay1m7+H15vUOquBFD1+zKpvDNjbI0oZeBOUXeEyCKcCSG4+M3HXzWW0
         PQ3NsZ+8/4JeD61lOPD08RYbXPVSqFcABqqu+C1UlheMDPPs8kQ5Sy/qFGssZnk8hrkU
         l6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720011797; x=1720616597;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJXV9tMkrP1RDlcaXvs7Y1MbET5oggImz97UisEWE9I=;
        b=h+zi5BHFFdcr/SN5u477dYIeE7Yk57fkGAZ9Pj7F8U2VUk+N3kCnEYdpTFZDNvA71o
         JxH8mhXWPeZfncCQHhdQBIeHFLrP8O4usyfeJ2+oIrgo0dg0KO+dYghRoRWcFtX2kpWw
         e/zmFgsTi4IpqTCRHmjrQ9tybQLK0rof0PmPn2UkYj/iEk3yYpvakl2KBpWCzy8IBkM+
         P/zNobdRJrXzOJjxBn2hNCqabjVp8Vjd8TXl+i4h71p87HImunzTkJFio0vAFY4AcieP
         n0pSGk1b0UzssFIvXrkEL+TRXBhlDMJJrycLu7ChyEeZaH9Xe2GVwIo3kSnZUJB/TOBj
         hejA==
X-Forwarded-Encrypted: i=1; AJvYcCUZdghAvc53eqVQKk/7fK92PgYwsepGrGnjIxHy6LEkC9+UUoX8H3ShVUsFAJrdqnzBpIoB9JsYRW2nRkRBDIdwfSGyHBQWsxenkw==
X-Gm-Message-State: AOJu0YyUJt68jO/gEpkwdoaxK1gfbYpd3l+ufG7mdcpRxKU/fjqqmkTX
	Vfkpd7SiF19x0OQXRRTbwWVJYSdiis0nxprZLJF08CKu5632mbYHLWBFAB1hpJM1dBY5fUwTEAE
	=
X-Google-Smtp-Source: AGHT+IGjY4x09+V3vnjwStPXSUAoMG3AaxLQgpRleeaR34kk3Qx9Lf0Kt2A/dD0XxE65hriIsJg2kg==
X-Received: by 2002:a17:902:d48a:b0:1f7:3314:524a with SMTP id d9443c01a7336-1fadbc73d86mr83899085ad.6.1720011796085;
        Wed, 03 Jul 2024 06:03:16 -0700 (PDT)
Received: from thinkpad ([220.158.156.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1569d28sm103211115ad.230.2024.07.03.06.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 06:03:15 -0700 (PDT)
Date: Wed, 3 Jul 2024 18:33:09 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 6/9] scsi: ufs: Inline is_mcq_enabled()
Message-ID: <20240703130309.GC3498@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-7-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240702204020.2489324-7-bvanassche@acm.org>

On Tue, Jul 02, 2024 at 01:39:14PM -0700, Bart Van Assche wrote:
> Improve code readability by inlining is_mcq_enabled().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 28 ++++++++++++++--------------
>  include/ufs/ufshcd.h      |  5 -----
>  2 files changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 178b0abaeb30..4c138f42a802 100644
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
> @@ -2301,7 +2301,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
>  	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>  		ufshcd_start_monitor(hba, lrbp);
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		int utrd_size = sizeof(struct utp_transfer_req_desc);
>  		struct utp_transfer_req_desc *src = lrbp->utr_descriptor_ptr;
>  		struct utp_transfer_req_desc *dest;
> @@ -3000,7 +3000,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> -	if (is_mcq_enabled(hba))
> +	if (hba->mcq_enabled)
>  		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
>  
>  	ufshcd_send_command(hba, tag, hwq);
> @@ -3059,7 +3059,7 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
>  	unsigned long flags;
>  	int err;
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		/*
>  		 * MCQ mode. Clean up the MCQ resources similar to
>  		 * what the ufshcd_utrl_clear() does for SDB mode.
> @@ -3169,7 +3169,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
>  			__func__, lrbp->task_tag);
>  
>  		/* MCQ mode */
> -		if (is_mcq_enabled(hba)) {
> +		if (hba->mcq_enabled) {
>  			/* successfully cleared the command, retry if needed */
>  			if (ufshcd_clear_cmd(hba, lrbp->task_tag) == 0)
>  				err = -EAGAIN;
> @@ -5560,7 +5560,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
>  	u32 tr_doorbell;
>  	struct ufs_hw_queue *hwq;
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		hwq = &hba->uhq[queue_num];
>  
>  		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
> @@ -6201,7 +6201,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>  /* Complete requests that have door-bell cleared */
>  static void ufshcd_complete_requests(struct ufs_hba *hba, bool force_compl)
>  {
> -	if (is_mcq_enabled(hba))
> +	if (hba->mcq_enabled)
>  		ufshcd_mcq_compl_pending_transfer(hba, force_compl);
>  	else
>  		ufshcd_transfer_req_compl(hba);
> @@ -6458,7 +6458,7 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
>  		*ret ? "failed" : "succeeded");
>  
>  	/* Release cmd in MCQ mode if abort succeeds */
> -	if (is_mcq_enabled(hba) && (*ret == 0)) {
> +	if (hba->mcq_enabled && (*ret == 0)) {
>  		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
>  		spin_lock_irqsave(&hwq->cq_lock, flags);
>  		if (ufshcd_cmd_inflight(lrbp->cmd))
> @@ -7389,7 +7389,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		for (pos = 0; pos < hba->nutrs; pos++) {
>  			lrbp = &hba->lrb[pos];
>  			if (ufshcd_cmd_inflight(lrbp->cmd) &&
> @@ -7485,7 +7485,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>  			 */
>  			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
>  				__func__, tag);
> -			if (is_mcq_enabled(hba)) {
> +			if (hba->mcq_enabled) {
>  				/* MCQ mode */
>  				if (ufshcd_cmd_inflight(lrbp->cmd)) {
>  					/* sleep for max. 200us same delay as in SDB mode */
> @@ -7563,7 +7563,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  
>  	ufshcd_hold(hba);
>  
> -	if (!is_mcq_enabled(hba)) {
> +	if (!hba->mcq_enabled) {
>  		reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  		if (!test_bit(tag, &hba->outstanding_reqs)) {
>  			/* If command is already aborted/completed, return FAILED. */
> @@ -7596,7 +7596,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	}
>  	hba->req_abort_count++;
>  
> -	if (!is_mcq_enabled(hba) && !(reg & (1 << tag))) {
> +	if (!hba->mcq_enabled && !(reg & (1 << tag))) {
>  		/* only execute this code in single doorbell mode */
>  		dev_err(hba->dev,
>  		"%s: cmd was completed, but without a notifying intr, tag = %d",
> @@ -7623,7 +7623,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto release;
>  	}
>  
> -	if (is_mcq_enabled(hba)) {
> +	if (hba->mcq_enabled) {
>  		/* MCQ mode. Branch off to handle abort for mcq mode */
>  		err = ufshcd_mcq_abort(cmd);
>  		goto release;
> @@ -8732,7 +8732,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  	ufshcd_set_link_active(hba);
>  
>  	/* Reconfigure MCQ upon reset */
> -	if (is_mcq_enabled(hba) && !init_dev_params)
> +	if (hba->mcq_enabled && !init_dev_params)
>  		ufshcd_config_mcq(hba);
>  
>  	/* Verify device initialization by sending NOP OUT UPIU */
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index d4d63507d090..c0e28a512b3c 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1132,11 +1132,6 @@ struct ufs_hw_queue {
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
