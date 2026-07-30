Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CBD20468E
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453551; cv=none; b=Ge65rFVOQG0TlRntQDE6H/iUL2ErdSrGHNfdIH8gaoitT9He5uNp9l9CPHir94XoqiKb/yH0K12g023wZsAri7Zh0lG+mvHf9WiBILm6utnJxie3sCfWo/a5dCOwtihTS13YlKhyb1u7q0hC+/NncxWXMpjHNyWIcwQ8tfqYnBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453551; c=relaxed/simple;
	bh=4beciaDJDnQQ4FfAquYYgz/15Yu/QNiuaqouwCEHi2c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ijj51oZ1slK3qVvQzKnC6jqhndkGR2nuEfwntgJ0d6suozcVGttnCB4gjy1E8RxXpUCfbEPP9TJDZHbaQFQW1lbP1aba5WxOmSpapspkwm6kUBb1dT4PZG5p5Q5JUrK+27Abxv9XsW8QVepDJECAytY7xlLa+znqgb6uskbyZvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJ427wcr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJ427wcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA9B1F000E9;
	Thu, 30 Jul 2026 23:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453550;
	bh=qP5uKKUWA0o7A3Yrlmsxn13eqkdvk+6bR3KUxMUtDW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LJ427wcrIq/m38lRtYCfLpb3n7bEOf7tHLz1F8HRkS/fwXtakhfacwXwu8W/XjETX
	 SPwUdCV1CfLNWjuxROdS2Rexg6MhgjxWc6nb9YFufpjAO4X/WXhJpILCKP3Uam+3w5
	 3l1E6Xicmk6fH6vFx0Y8XAm4n5O+PkzoVlgxIdeQEqwDf9CjEDE1pENqugAQFdAFmR
	 2PDyT/ZU7eOx7M76gnLpo7oLq/HoS6FMbVWpipKWGKrSGtNWJMDRFavpYPIOPXdF+T
	 qLG03mzB2lF4K+938GpyGCyohbM0qouaRSYbifVpXrYWpEXSvLMb2uvB0w6U/Y66Ee
	 pt1Jmh2CiCB+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 50/57] scsi: ufs: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <8d2008e5812018e4dfee27faf492f2cc4cf1dd10.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <8d2008e5812018e4dfee27faf492f2cc4cf1dd10.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:19:09 +0000
Message-Id: <20260730231909.8BA9B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] ufshcd_wait_for_pending_cmds() uses io_schedule_timeout() without =
setting current->state, causing a busy loop instead of sleeping.
--

--- Patch [50]: [PATCH v3 50/57] scsi: ufs: Enable lock context analysis ---
commit 8185dd4bd8104528b9c4d31b079a63ef3f632638
Author: Bart Van Assche <bvanassche@acm.org>

scsi: ufs: Enable lock context analysis

This commit annotates functions that modify the state of a synchronization
object to enable lock context analysis. It also removes struct semaphore
annotations because lock context annotations are not supported for
semaphores.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f85582287d14d..22a5f8e9af913 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1353,6 +1353,8 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_=
hba *hba,

[Severity: High]
This is a pre-existing issue, but does ufshcd_wait_for_pending_cmds()
busy loop here instead of sleeping?

Looking at ufshcd_wait_for_pending_cmds(), it calls io_schedule_timeout()
without first setting the task state to TASK_UNINTERRUPTIBLE:

drivers/ufs/core/ufshcd.c:ufshcd_wait_for_pending_cmds() {
	...
	do {
		tm_doorbell =3D ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
		tr_pending =3D ufshcd_pending_cmds(hba);
		if (!tm_doorbell && !tr_pending) {
			timeout =3D false;
			break;
		} else if (do_last_check) {
			break;
		}

		io_schedule_timeout(msecs_to_jiffies(20));
		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
		    wait_timeout_us) {
	...
}

Because the task state remains TASK_RUNNING, does the underlying
schedule_timeout() function return immediately without yielding the CPU?=20

Could this cause severe performance degradation by hogging 100% of a CPU
core and aggressively polling MMIO registers for up to 1 second during
operations like UFS hardware clock scaling?

>   * On failure, all acquired locks are released and the tagset is unquies=
ced.
>   */
>  int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
> +	__cond_acquires(0, &hba->host->scan_mutex)
> +	__cond_acquires(0, &hba->clk_scaling_lock)
>  {
>  	int ret =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D50
