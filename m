Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE92403E8C
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786571089; cv=none; b=pAhIXye8PROiSqYu/qkWbi9n8FAnoxijUU71wAJ799IRkBV0DAGu4TNQv0+RNbzWHh9fPuj4eHyIsHR/LqVlvMP9+s/giaXdBZPr0ONcMgwIpksRZ1UVuq2jA9tI6izP4F4zhmI55bMkIwNejC0/sxM5+ysvFcZi/H0rr5a6iqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786571089; c=relaxed/simple;
	bh=0/5OTywT52mSMVhhLsqf7TvPWnyQNVrupo6tnv4FjjY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=urCClzm7hmMB3fKuQfqjGUY2rpAAJH92aMGB7tnssOz2Rdh6AHpM6czlIQlGYcr/8cmPjFIf8he9DanGrmr9npuArkYym9GTZ9nJqgBVYb25YaWz75TR19yMSRnkJ34Rips3ZEYPrG6iwBeSE3uekzjJucoPCdKDXigGAnY5Tho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkDUIRV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkDUIRV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA421F000E9;
	Wed, 12 Aug 2026 21:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786571087;
	bh=28pDWBlYYalKzBxwIAXW+NR/ewyQtl7iYZdtSq3eENo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZkDUIRV59nc5+9uM0DISo1k/VcZF+DFjVHmrSJYjD2ku88tef4UhIGMRzUPa9NvmY
	 +qSuwY8A2nJX31tJpjhyje0WUMIy/3Y5GkIRwq76F2wTug8TGBBfeMxuIzU2x1FdoZ
	 QaMsd6iEOvlwB+Mo3W+Esk1S13+h0FZDJXYJV2uo/3qFvNNZUTcOa56JoeP1eAlnBK
	 rOOxIk13ype/V4148SRqJ5y518d024BqnAjHAruIBuE4fQHA9mOgamq2aNs8lbRv/z
	 S0XcVs5nhxTNYPIi0LBn/YiBISuQykSrURS8k3313eGDIXR0x4uhv+l3bMjWrRKeGS
	 +NWinlyhbGoVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] ufs: core: Do not forcibly complete SCSI
 commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <c31da15ae9aa15d891ff69fd342294f9bf687480.1786569828.git.bvanassche@acm.org>
References: <cover.1786569828.git.bvanassche@acm.org>
 <c31da15ae9aa15d891ff69fd342294f9bf687480.1786569828.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 21:44:47 +0000
Message-Id: <20260812214447.9CA421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Removing explicit SCSI command completion in MCQ error handler str=
ands commands, causing 30s I/O stalls and resource leaks.

Pre-existing issues:
- [Critical] Reading the CQ tail pointer when the host is disabled can retu=
rn 0xFFFFFFFF, causing an out-of-bounds array access and kernel panic.
- [High] Redundant queue polling causes O(N*M) complexity under spinlock an=
d floods the console with errors.
--

--- Patch [2]: [PATCH v2 2/2] ufs: core: Do not forcibly complete SCSI comm=
ands ---
commit bd53d1703220f927f3a5c88813e22aa95471d9d4
Author: Bart Van Assche <bvanassche@acm.org>
Subject: ufs: core: Do not forcibly complete SCSI commands

This commit prevents the UFS error handler from explicitly completing SCSI=
=20
commands, delegating the decision to the SCSI core error handler. It removes
the explicit scsi_done() call from the MCQ error handling path.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 63ca6d489be02..8e82fa6882021 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6020,28 +6020,13 @@ static int ufshcd_poll(struct Scsi_Host *shost, u=
nsigned int queue_num)
> =20
>  static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
>  {
[ ... ]
> -	if (blk_mq_is_reserved_rq(rq) || !hwq)
> -		return true;
> -
> -	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
> -
> -	/*
> -	 * For those cmds of which the cqes are not present in the cq, complete
> -	 * them explicitly.
> -	 */
> -	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
> -		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
> -			set_host_byte(cmd, DID_REQUEUE);
> -			ufshcd_release_scsi_cmd(hba, cmd);
> -			scsi_done(cmd);
> -		}
> -	}
> +	if (hwq)
> +		ufshcd_mcq_compl_all_cqes_lock(hba, hwq);

[Severity: High]
This isn't a bug introduced by this patch, but does calling
ufshcd_mcq_compl_all_cqes_lock() here cause an O(N*M) loop under spinlock?

Since this function is invoked by blk_mq_tagset_busy_iter() for every busy
request, it appears we scan the entire hardware queue (M slots) for every o=
ne
of the N busy requests.

Furthermore, ufshcd_mcq_compl_all_cqes_lock() unconditionally iterates
max_entries times:

drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_compl_all_cqes_lock() {
    ...
    while (entries > 0) {
        ufshcd_mcq_process_cqe(hba, hwq);
        ufshcd_mcq_inc_cq_head_slot(hwq);
        entries--;
    }
    ...
}

Inside ufshcd_mcq_process_cqe(), empty slots log "Abnormal CQ entry!".
Will this flood the console with N * M error messages, potentially causing
hard lockup warnings when interrupts are disabled for so long?

[Severity: Critical]
This is also a pre-existing issue, but is it safe to read the CQ tail point=
er
here when the host might be disabled or disconnected?

In ufshcd_mcq_compl_all_cqes_lock(), the tail pointer is read from MMIO:

drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_compl_all_cqes_lock() {
    ...
    ufshcd_mcq_update_cq_tail_slot(hwq);
    hwq->cq_head_slot =3D hwq->cq_tail_slot;
    ...
}

If the bus is inaccessible (e.g. surprise removal or PCIe master abort),
the register read might return 0xFFFFFFFF. Does this assign an out-of-bounds
index to cq_head_slot, which would then be dereferenced by ufshcd_mcq_cur_c=
qe()
on the next iteration of the tagset iterator, leading to a kernel panic?

> =20
>  	return true;

[Severity: High]
By removing the explicit completion and ufshcd_release_scsi_cmd() here, do
these commands get stranded in flight?

If the host controller was reset, these commands will have no CQE and will
remain stuck until the block layer timer expires (typically 30 seconds),
causing a severe I/O stall.

When SCSI EH eventually aborts them, ufshcd_mcq_abort() returns SUCCESS
without calling ufshcd_release_scsi_cmd():

drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_abort() {
    ...
    return SUCCESS;
}

Does this result in permanent leakage of crypto PRDTs and clock scaling busy
counts?

The commit message states this aligns MCQ with legacy mode, but doesn't
legacy mode implicitly complete all commands during a reset because the
doorbell register reads as 0, tricking ufshcd_transfer_req_compl() into
completing them all?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1786569828.gi=
t.bvanassche@acm.org?part=3D2
