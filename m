Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C410A1B808;
	Mon, 21 Sep 2026 00:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789951306; cv=none; b=cdddisz1LFxSzuYvI+W2oYQ5dIlMQgYPhFswxcZ3mOXJ+Pf81lIIJS9RIpS5LMybHvK7hESZXiO/RBd0rDNjBkTv9RAKYTmoqd5Jc5f3Zjo7jx4bYQ40nzjNd3Q5lepDlD4p4SVlSRUTKhcj9lBUBbARl6v/g5XlEYDrtCCP3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789951306; c=relaxed/simple;
	bh=k232noItsvsDTGc7EcQiwd/ArG5FiV1WOl9HfMmUFyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etWtJmgXSq39iScfH8+MukFzfOvvZpOM5U9rHpnkxqz05Azvot5i9UDV+hFD6SyahM4LxsPRck3HnpRWMk/ef7LBRJiIQvc6nUWViQ24lGSCkiH1j+FhWZjkegUhsPCgBDM0HQqc95Z+imeZxT+j5Eg3td+V03c47DP7CBUqZdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JUNQXOnx; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JUNQXOnx"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hp4DS1BkKzlfvpn;
	Mon, 21 Sep 2026 00:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789951289; x=1792543290; bh=T+Qb4ClbUy/JfG4PeBG+uluS
	UoqnWAEs9jVUvG/+pgY=; b=JUNQXOnx79iU7a5bJ0bMTwFaozpXS8/qQ2TKNRnZ
	vwzBSjmipPoKw+060tKcoFPmT6ViuNsVcm9AZJt+Of+0MFO85oLoI3Rf0cg1/+zU
	6F51z6ixe/3uT8ERu7WXc3FUJqVQNmN7/3GPxm7WAPd3/DcnJ8ZC0JsnO4GVoYVv
	1RSLWfOZYLhYZ6o+azdluv1nhTBsLOlOSL/ZTK9jWxO8KTbVBfTNp6jZIdtms5R1
	xuIQy+lyM69OzWiBy+883CVicL8dEIizadep6ZxHkv8J9EpP9RICGqmfoiF+WIub
	2T6FHDXnO+GMt9izFpFWP76p/bWgecTRbdoJscwDKb1/0A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lU6tRyxQKEMV; Mon, 21 Sep 2026 00:41:29 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hp4D54GLQzlfvpN;
	Mon, 21 Sep 2026 00:41:25 +0000 (UTC)
Message-ID: <fee250ea-8e0b-4320-880e-8e2627e7b103@acm.org>
Date: Sun, 20 Sep 2026 17:41:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Release command resources instead of
 force-completing
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260920143319.3659543-1-stanleyjhu@google.com>
 <20260920143319.3659543-2-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260920143319.3659543-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/26 7:33 AM, Stanley Jhu wrote:
> In ufshcd_host_reset_and_restore(), ufshcd_complete_requests(hba, true)
> couples LLD resource release (ufshcd_release_scsi_cmd()) with command
> completion (scsi_done()) right after ufshcd_hba_stop():
> 
> 1. EH-owned SCSI commands (SCMD_STATE_COMPLETE set): skipping
>     scsi_done() in ufshcd_mcq_force_compl_one() also skips
>     ufshcd_release_scsi_cmd(), leaking DMA mappings and
>     clk_gating.active_reqs whenever ufshcd_abort() fails.
> 2. Non-EH SCSI commands (!SCMD_STATE_COMPLETE): calling scsi_done()
>     right after ufshcd_hba_stop() completes them before link recovery
>     finishes.
> 
> To fix this, enforce a strict ownership boundary between LLD hardware
> resources and SCSI command completion:
> 
> - LLD resources (DMA mappings, crypto PRDT, clk_gating.active_reqs) are
>    tied to controller execution and must be released whenever the
>    hardware stops executing a command, regardless of whether SCSI EH
>    owns the command.
> - Command completion (scsi_done()) belongs exclusively to SCSI EH once
>    SCMD_STATE_COMPLETE is set. However, for commands where
>    SCMD_STATE_COMPLETE is not set, UFS cannot delegate completion to
>    SCSI EH because UFS also performs autonomous resets
>    (ufshcd_err_handler() on UIC/controller errors) outside of
>    scsi_error_handler(). Since ufshcd_hba_stop() (HCE = 0) wipes all
>    in-flight hardware transfers while SCSI EH is inactive, the driver
>    itself must requeue halted non-EH commands with DID_REQUEUE after
>    recovery finishes, or else they stall for the 30s block timeout.
> 
> Implement this in three steps:
> 
> 1. Track controller resource ownership with lrbp->in_flight so
>     ufshcd_release_scsi_cmd() is idempotent across normal completion,
>     successful task abort, and host reset teardown.
> 2. At controller stop (ufshcd_release_stopped_reqs()), release LLD
>     resources for all halted commands without calling scsi_done(), clear
>     any uncompleted reserved dev_cmd, and mark halted non-EH commands
>     with lrbp->pending_requeue.
> 3. After host and link recovery finish (ufshcd_requeue_non_eh_cmds()),
>     requeue pending commands that remain non-EH (!SCMD_STATE_COMPLETE)
>     with DID_REQUEUE while leaving EH-owned commands on shost->eh_cmd_q.
> 
> Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
> Suggested-by: Bart Van Assche <bvanassche@acm.org>

No, this is not what I suggested. Additionally, I see multiple steps in
the wrong direction.

The text above says "implement this in three steps". Hence, this patch
should have been three patches instead of one because of the "one change
per patch" rule in the Linux kernel community.

Regarding (1), why a new member variable? Why isn't rq->state
sufficient?

Regarding (3), the UFS driver is a SCSI LLD (low-level driver) and hence
should only do what is specific to the UFS driver. Completing commands
after .eh_host_reset_handler() has been called is the responsibility of
the SCSI core and should not be done by the UFS driver.

(2) seems wrong to me. The caller of ufshcd_hba_stop() should take care
of pending commands instead of ufshcd_hba_stop() itself.

>   int ufshcd_link_recovery(struct ufs_hba *hba)
>   {
>   	int ret;
> @@ -4692,6 +4721,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
>   	ufshcd_clear_eh_in_progress(hba);
>   	spin_unlock_irqrestore(&hba->host->host_lock, flags);
>   
> +	ufshcd_requeue_non_eh_cmds(hba);
> +
>   	if (ret)
>   		dev_err(hba->dev, "%s: link recovery failed, err %d",
>   			__func__, ret);

This is a behavior change that should be in a separate patch and not in
a patch for releasing command resources.

> @@ -5937,6 +5968,17 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
>   /* Release the resources allocated for processing a SCSI command. */
>   void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd)
>   {
> +	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
> +
> +	lrbp->pending_requeue = false;
> +	if (!lrbp->in_flight)
> +		return;
> +	lrbp->in_flight = false;
> +
> +	/* Device management commands do not own any of the below. */
> +	if (!ufshcd_is_scsi_cmd(cmd))
> +		return;
> +

Did you read this code before you posted it? As its name suggests,
ufshcd_release_scsi_cmd() is only called for SCSI commands. No device
management command code should be added in this function.

>   	scsi_dma_unmap(cmd);
>   	ufshcd_crypto_clear_prdt(hba, cmd);
>   	ufshcd_release(hba);
> @@ -5968,8 +6010,9 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   		if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
>   			ufshcd_update_monitor(hba, cmd);
>   		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
> -		cmd->result = ufshcd_transfer_rsp_status(hba, cmd, cqe);
> -		ufshcd_release_scsi_cmd(hba, cmd);
> +		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state))
> +			cmd->result =
> +				ufshcd_transfer_rsp_status(hba, cmd, cqe);

Why has this if-condition been added? ufshcd_compl_one_cqe() should only
be called if SCMD_STATE_COMPLETE has not yet been set.

> @@ -5981,8 +6024,17 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   			hba,
>   			ocs == OCS_SUCCESS ? UFS_QUERY_COMP : UFS_QUERY_ERR,
>   			(struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
> -		cmd->result = 0;
> +		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state))
> +			cmd->result = 0;

Same question for this new if-condition.

> @@ -7930,7 +7984,11 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
>   		return true;
>   	}
>   
> -	ufshcd_compl_one_cqe(hba, tag, NULL);
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +	if (outstanding)
> +		ufshcd_compl_one_cqe(hba, tag, NULL);
>   	return true;
>   }

Why has ufshcd_clear_lu_cmds() been modified? This function is only
called for pending commands so checking &hba->outstanding_reqs is not
necessary.

> @@ -8087,6 +8145,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   	u32 reg;
>   
>   	ufshcd_hold(hba);
> +	lrbp->pending_requeue = false;
>   
>   	if (!hba->mcq_enabled) {
>   		reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> @@ -8153,6 +8212,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   	if (hba->mcq_enabled) {
>   		/* MCQ mode. Branch off to handle abort for mcq mode */
>   		err = ufshcd_mcq_abort(cmd);
> +		if (err == SUCCESS) {
> +			struct ufs_hw_queue *hwq =
> +				ufshcd_mcq_req_to_hwq(hba, rq);
> +
> +			if (hwq) {
> +				spin_lock_irqsave(&hwq->cq_lock, flags);
> +				ufshcd_release_scsi_cmd(hba, cmd);
> +				spin_unlock_irqrestore(&hwq->cq_lock, flags);
> +			}
> +		}

This is also wrong because this change will trigger a use-after-free in
scmd_eh_abort_handler() if it decides to retry or finish a SCSI command.

> @@ -8231,13 +8365,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>   	int err;
>   
>   	/*
> -	 * Stop the host controller and complete the requests
> -	 * cleared by h/w
> +	 * Stop the host controller and release driver resources for
> +	 * requests cleared by h/w

This is wrong. The SCSI core error handler is responsible for releasing
resources. The UFS driver must not do this from its host reset handler.

Bart.
