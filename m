Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E79378824
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 13:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812013; cv=none; b=Wd6smQOEx3bAihsA6m8cM0oS0nSStfVTb5/PTBeWjMHozXgbaempHxyPXnHaCUEFgW8XwjCYsT6NL6rLVMKbfEsHP9YyIhYJdFOYyP/2tiq5Tsl0tfozEZ94nYf2x1OwbrJitNMBB2rMscmjA5lOUE0/X4QZNlqnz0PwC+uYPDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812013; c=relaxed/simple;
	bh=eL2IKWnHE3Q6yOdHuS3QPCxnIJHJZD4Qj4xticrvVW0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AB03PaMFie8mw58bdCqMJpDyEXw6fG28aXhdasz4ZXvNzXcB7UW02j4pY69orUKb91P5PWD4a7LT/4dLIdyEj7z+r2h62jzjA1pldjBl/dexkqwGyrxX0BjDgalcPCQFp3D/JtSh6xrP/+ajAc8ILZn7cJaEzHpUKOKYNv+q4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVUSOBKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVUSOBKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FD31F000E9;
	Thu, 23 Jul 2026 13:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784812001;
	bh=NyhU5/O1h59zbNheksl4nJrnVIGfZQfyHzQAEXe0an4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GVUSOBKwjOsXA7Z1l2BMlYxBQgF1DVA95MtmYaObKoHB4FJS1/reALTrEJLUHxhjw
	 xz/uKJ7QKcmjkSEorI2ZbT5bKmskC/77Qbi9o19+M4zaUmGKFpQ6mbvM6pu3xcvMyv
	 VQ1fOWGTVJv4CmSZpTBIOOkX/+YnClP0X1oaLgMwE2Uo0pcNwwlSYwWcN8vQekDKv6
	 TdcKKA5hUTYExAOk6DujSubf9I3noLQESMzVW+WdTxakGZJT0iJPI6+nT/j92I9e0X
	 0C7Plwn8qnvXfnxgRsdP43N3PYUt20Z9yHXs5FpD7NHMJKH/FgRB2f57VXgQSi7U/7
	 rf8UBaFrMKA1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 13:06:41 +0000
Message-Id: <20260723130641.92FD31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Calling blk_mq_quiesce_tagset() before acquiring the clk_scaling_l=
ock write semaphore introduces an ABBA deadlock with device management comm=
ands.
--

--- Patch [1]: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/=
O quiesce for clock scaling" ---
commit d454cd4e623d4ff192ea3b557d6b1e8c27de2a9a
Author: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Revert "scsi: ufs: core: Remove unnecessary block I/O quiesce for clock sca=
ling"

This commit reverts a previous change to restore the block I/O quiesce
during clock scaling preparation. It is intended to fix UFS failures
during clock scaling on Qcom platforms.

Closes: https://lore.kernel.org/linux-scsi/al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 79331c2bd38de..1a5a851d43b28 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -1445,7 +1445,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u=
32 target_gear, bool scale_up
>   *
>   * Return: 0 upon success; -EBUSY upon timeout.
>   */
> -static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
> +static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout=
_us)
>  {
>  	int ret =3D 0;
>  	/*
> @@ -1453,13 +1453,16 @@ static int ufshcd_clock_scaling_prepare(struct uf=
s_hba *hba)
>  	 * clock scaling is in progress
>  	 */
>  	mutex_lock(&hba->host->scan_mutex);
> +	blk_mq_quiesce_tagset(&hba->host->tag_set);
>  	mutex_lock(&hba->wb_mutex);
>  	down_write(&hba->clk_scaling_lock);

[Severity: High]
Could this sequencing introduce a deadlock between clock scaling and
device management commands?

If a device management command starts first, it acquires the read lock in
ufshcd_dev_man_lock():

ufshcd_dev_man_lock()
    down_read(&hba->clk_scaling_lock);

If the devfreq scaling worker then calls ufshcd_clock_scaling_prepare(),
it will quiesce the block queue and block waiting for the write lock:

ufshcd_clock_scaling_prepare()
    blk_mq_quiesce_tagset(&hba->host->tag_set);
    down_write(&hba->clk_scaling_lock);

When the device management thread proceeds to execute its request via
ufshcd_issue_dev_cmd() calling blk_execute_rq(), the request gets queued but
will not dispatch because the queue is quiesced.=20

Since blk_execute_rq() blocks indefinitely and the block layer timeout
doesn't track requests that haven't dispatched yet, won't this result in
both threads hanging permanently?

> -	if (!hba->clk_scaling.is_allowed) {
> +	if (!hba->clk_scaling.is_allowed ||
> +	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
>  		ret =3D -EBUSY;
>  		up_write(&hba->clk_scaling_lock);
>  		mutex_unlock(&hba->wb_mutex);
> +		blk_mq_unquiesce_tagset(&hba->host->tag_set);
>  		mutex_unlock(&hba->host->scan_mutex);
>  		goto out;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723124733.3417=
89-1-manivannan.sadhasivam@oss.qualcomm.com?part=3D1
