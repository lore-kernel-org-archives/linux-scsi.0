Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0FEDDC5
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2026 02:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783131497; cv=none; b=SJ8zvEo75djxOmlsRSIH/CoJrOZrC/3+JOlC3ZbkKkh5Xo50sQP+O5Y6lDetezE2yYmbPUO6MgUnyxxBRsTARaKVUXiLuUQNRD3j5Te29KtSO42vwvGRtm1xZBJ6GnXV14mBoWxxoD71p9rNxfM25+lu3QqHgcp09XxdTBFZ/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783131497; c=relaxed/simple;
	bh=mYUlQ1ywTmUBeP98Ku8ftAGMvO7wS+OaXKXoEivWv4A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YjzFbPv3kPGYI1lYFVpOlPMTIKB2EGsqpquFpQQstXDr9rNBI0hkNvyKO2Tv4cV95cBvx98g1OPRJXitdZVsje97NPk7zcQuqIkchRwep9MoWEs3x/br7cYrRTNhZwbDJWCv0at+x5HHtmgPYJFrairwTGNKZ3jkfHbDfIcY3Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJxE31rT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJxE31rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1078C1F000E9;
	Sat,  4 Jul 2026 02:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783131495;
	bh=IWt/dmpzgSBUQi+u7WrI9wz6qHu2J0sqzniULaCa9Ug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WJxE31rT6qgjS6ThMogmmiKU+Hjua6PyNV7DGxzMmwksleV8Me2lKC2aixSlGh1mT
	 15Xz+VcQmAhsa6fTE+qM8n+U5q+fsxA0meUrFqgS5ClamdvltDdCxmROF1s/limBrx
	 OsX/ZgN5Yymo6l3gAmHtAs+7aOZjwCkVSPYioujnW+oqfIIy6T6tVz4a2qWTT5EV1T
	 9N9X56ysHYcJifCa2G51DtgtKestGVZfe3LcF0er/UqLhRXyoaviYPGDeB9z3Yd9g/
	 v9TQdH+1Bf5cOYTuydBiMyusjct0tDzzsmL5UYwB21VODYyVNmg++vWNx3BJHUwXcq
	 e/kHwBzj6km4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: smartpqi: drain controller workers before
 freeing controller
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260704015011.21283-1-fanwu01@zju.edu.cn>
References: <20260701142757.8447-1-fanwu01@zju.edu.cn>
 <20260704015011.21283-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 04 Jul 2026 02:18:14 +0000
Message-Id: <20260704021815.1078C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Waking up all threads on `block_requests_wait` causes a Use-After-=
Free for synchronous user threads (e.g., ioctls) because `ctrl_info` is fre=
ed without waiting for them to complete.

Pre-existing issues:
- [High] The heartbeat timer can be re-armed by the OFA quiesce worker duri=
ng teardown and is never stopped again, leading to a Use-After-Free when th=
e timer expires.
--

commit 753a17ed3e0060de6ddd2fedeade46717222e86f
Author: Fan Wu <fanwu01@zju.edu.cn>

scsi: smartpqi: drain controller workers before freeing controller

This commit addresses use-after-free bugs by draining several delayed worke=
rs
and event workers in pqi_free_ctrl_resources(). It also unblocks requests
before cancelling the event worker to prevent it from waiting indefinitely
during controller removal.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 5ec583dc2e7df..707693d2eb80a 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -8897,7 +8897,19 @@ static void pqi_free_interrupts(struct pqi_ctrl_in=
fo *ctrl_info)
> =20
>  static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
>  {
> +	/*
> +	 * Release blocked workers first.  Disable ctrl_offline_work before
> +	 * freeing IRQs because its callback can also free them.  event_work
> +	 * can requeue rescan_work, so drain event_work before cancelling
> +	 * rescan again.
> +	 */
> +	pqi_ctrl_unblock_requests(ctrl_info);

[Severity: High]
Does waking up all threads on block_requests_wait here cause a
use-after-free for synchronous user threads?

By calling pqi_ctrl_unblock_requests() (which wakes up all threads on
ctrl_info->block_requests_wait), user threads blocked in
pqi_wait_if_ctrl_blocked() during ioctl calls like
pqi_submit_raid_request_synchronous() will be unblocked.

Since there is no subsequent synchronization to wait for these threads to
finish, won't they resume execution and dereference ctrl_info after
pqi_free_ctrl_info() frees it at the end of pqi_free_ctrl_resources()?

> +	disable_work_sync(&ctrl_info->ctrl_offline_work);
>  	pqi_free_interrupts(ctrl_info);
> +	cancel_work_sync(&ctrl_info->event_work);
> +	pqi_cancel_rescan_worker(ctrl_info);
> +	cancel_work_sync(&ctrl_info->ofa_memory_alloc_work);
> +	cancel_work_sync(&ctrl_info->ofa_quiesce_work);

[Severity: High]
This isn't a bug introduced by this patch, but can the heartbeat timer be
re-armed by the OFA quiesce worker and cause a use-after-free?

When cancel_work_sync() runs, if the OFA quiesce worker is currently
executing, it can call pqi_process_soft_reset(). Under error conditions,
this can lead to pqi_ofa_ctrl_unquiesce(), which re-arms the timer via
pqi_start_heartbeat_timer().

Since the teardown path does not stop the timer again after draining the
workers, won't the timer remain armed when the controller is freed, leading
to a use-after-free when the timer fires and dereferences ctrl_info in
pqi_heartbeat_timer_handler()?

>  	if (ctrl_info->queue_memory_base)
>  		dma_free_coherent(&ctrl_info->pci_dev->dev,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260704015011.2128=
3-1-fanwu01@zju.edu.cn?part=3D1
