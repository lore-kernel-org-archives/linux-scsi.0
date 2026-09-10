Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FD647ACD5
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789040816; cv=none; b=p1idG7634v9daIqMuLiOnqI+8nCLehkI+GmY6cXXFhgOpyZBuCc2nDzcgnNjNwtmvg3+CzjnNP0Pu68t9qIkvfJ+TBm1M12DQjH1SewHlbzjMoRKWCtfd216JzOfyVQ5uKppBMS0VHd5xqCSXSlaLVk8BcD5o5C66DXqpuUO0ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789040816; c=relaxed/simple;
	bh=RlIWU7PM77KpmQ5v04ZaFdArlNO1Zv4YRi2B5HwJp/w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n62OTTzEeHvbLeg49gpLIBjCmda+AGMK19OqFRAWyWpqzqphR7EOOO6hqofjHVegTXkBcXTcNY9H7l4eIQQKfhb+odBChey/wPtMc57L7+hXXwRX8OhiIL5//8QIyetfDfYzGPkuTDewhzPiAjzE8lPqsAssfLKbNzjbmRAFrV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaonAKE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaonAKE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559B81F00898;
	Thu, 10 Sep 2026 11:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789040810;
	bh=C5V604RhqXmevZ84Bl+36mvwaxVixpUlSOLow+ktRdE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZaonAKE8CpQEZ7Pi/QQ3xv5lFHrwZnboX2b3qoWxJIxGfXoWP2LNhQoT7odXHtVD7
	 tOrJYEsIbfE/v1Z2uCkPbRdxHMb9S6zLmr75AP4KUaNBNg3+jahJMKh5vVgAYXv79U
	 9uytN0RWUNp0N8YsEG48Sj/xIVAXJaLFocZIdWQ4N606A7g1OCn5sVkNzRjSIGoh/m
	 nPvsQn+GlJYgfrY/8oERVSWxlgKnKGlGuieL2X0bHoclf4YXOva5rNRLoA1rR8/9dm
	 PA02kBNWoyf41pJj+rm4gvEVKYwB693FTKJ610flNv7v4JajjnbYhop+cv+tnG6T/0
	 MsLe03ryoe4/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qedi: Initialize callback state before
 registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260910112947.1350877-1-runyu.xiao@seu.edu.cn>
References: <20260910112947.1350877-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 11:46:49 +0000
Message-Id: <20260910114650.559B81F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The return value of kthread_run() is not checked for errors, resul=
ting in an ERR_PTR being stored and subsequently dereferenced.
- [High] The ll2_recv_thread is leaked on __qedi_probe error paths, causing=
 a task leak and a subsequent use-after-free.
- [High] Missing error check for qedi_ops->ll2->start().
- [High] Memory leak of fastpath arrays and status blocks on __qedi_probe e=
rror paths.
- [High] Asynchronous callbacks registered via qedi_ops->register_ops() can=
 execute and schedule uninitialized delayed works, leading to a kernel pani=
c.
- [High] Calling scsi_remove_host() on a host that failed scsi_add_host(), =
leading to sysfs/device_del warnings or crashes.
- [High] The iSCSI host is exposed to userspace before critical workqueues =
are allocated, allowing userspace tools to trigger NULL pointer dereference=
s.
- [High] The driver reads the DMA-updated hardware producer index (sb->pi_a=
rray) without a dma_rmb() and without le16_to_cpu().
--

commit 0c41fa3eb18f5cff0e550ef57ea439ee89ae82a1
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: qedi: Initialize callback state before registration

qedi_get_protocol_tlv_data() can be called asynchronously by QED after
qedi_ops->register_ops(). It takes stats_lock and reads ll2_mtu, but
__qedi_probe() currently registers the callback before initializing the
mutex and assigning the default MTU on the normal probe path.

Initialize the callback-visible state before registering qedi_cb_ops. Keep
the recovery path from reinitializing state because it reuses the existing
qedi context.

Fixes: 3cc5746e5ad7 ("scsi: qedi: Initialize the stats mutex lock")
Cc: stable@vger.kernel.org

Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index 227ff7bd1bdc9..f394fcbb97e7e 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2652,8 +2652,6 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
>  	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
>  	qedi_ops->common->set_name(qedi->cdev, host_buf);
> =20
> -	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
> -
>  	memset(&params, 0, sizeof(params));
>  	params.mtu =3D DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
>  	qedi->ll2_mtu =3D DEF_PATH_MTU;
> @@ -2670,6 +2668,7 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
>  		spin_lock_init(&qedi->task_idx_lock);
>  		mutex_init(&qedi->stats_lock);
>  	}
> +	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);

[Severity: High]
This is a pre-existing issue, but registering the callbacks here makes them
live before delayed works are initialized.

If an asynchronous hardware event (like a link state change or fan failure)
triggers early, it could call qedi_schedule_hw_err_handler(), which attempts
to schedule the uninitialized qedi->board_disable_work.

The delayed works are initialized much later in __qedi_probe():

	INIT_DELAYED_WORK(&qedi->recovery_work, qedi_recovery_handler);
	INIT_DELAYED_WORK(&qedi->board_disable_work, qedi_board_disable_work);

Could this early registration lead to a kernel panic if a callback fires and
schedules uninitialized work structures?

>  	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
>  	qedi_ops->ll2->start(qedi->cdev, &params);

[Severity: High]
This isn't a bug introduced by this patch, but does this code ignore the
return value from qedi_ops->ll2->start()?

Could ignoring an initialization failure here lead to unpredictable behavior
later?

[Severity: High]
This is a pre-existing issue, but right after this in __qedi_probe(), the
kthread is created:

	qedi->ll2_recv_thread =3D kthread_run(qedi_ll2_recv_thread, (void *)qedi,
					    "qedi_ll2_thread");

If kthread_run() fails due to memory pressure, it returns an ERR_PTR.
Does this code assign the ERR_PTR without using IS_ERR() to check for
failure?

If so, later in teardown or RX paths, if (qedi->ll2_recv_thread) will
evaluate to true, and passing the ERR_PTR to kthread_stop() in
__qedi_remove() or wake_up_process() in qedi_ll2_rx() could cause a panic.

[Severity: High]
This is a pre-existing issue, but if __qedi_probe() fails after successfully
creating qedi->ll2_recv_thread, it jumps to error paths:

	rc =3D qedi_ops->start(qedi->cdev, &qedi->tasks, qedi,
			     qedi_iscsi_event_cb);
	if (rc) {
		...
		goto stop_slowpath;
	}

The error path frees the qedi struct via iscsi_host_free() without stopping
the background thread. Does this leak the thread and result in a
use-after-free when the orphaned thread continues to access qedi?

[Severity: High]
This is a pre-existing issue, but when iscsi_host_add() fails in
__qedi_probe(), the code jumps to remove_host:

	if (iscsi_host_add(qedi->shost, &pdev->dev)) {
		rc =3D -ENOMEM;
		goto remove_host;
	}

The remove_host label unconditionally calls iscsi_host_remove(), which wraps
scsi_remove_host(). Can calling scsi_remove_host() on a host that failed
scsi_add_host() lead to sysfs or kobject core warnings and crashes?

[Severity: High]
This is a pre-existing issue, but iscsi_host_add() is called and exposes the
device to userspace before critical workqueues are allocated:

	if (iscsi_host_add(qedi->shost, &pdev->dev)) {
		...

And later:

	qedi->offload_thread =3D alloc_workqueue("qedi_ofld%d", ...);

Could userspace immediately respond via netlink to create an endpoint,
invoking qedi_ep_connect() which calls queue_work(qedi->offload_thread, ...=
),
resulting in a NULL pointer dereference because the workqueue isn't allocat=
ed
yet?

[Severity: High]
This isn't a bug introduced by this patch, but memory and DMA blocks are
allocated in qedi_prepare_fp() earlier in __qedi_probe():

	rc =3D qedi_prepare_fp(qedi);
	if (rc) { ... }

If a subsequent initialization step fails, the error path does not call
qedi_destroy_fp(qedi). Does this code leak the fastpath arrays and status
blocks on error paths?

[Severity: High]
This is a pre-existing issue, but the driver reads the DMA-updated hardware
producer index without a memory barrier or endianness conversion:

drivers/scsi/qedi/qedi_main.c:qedi_process_completions() {
	...
	prod_idx =3D sb->pi_array[QEDI_PROTO_CQ_PROD_IDX];
	...
}

Does reading sb->pi_array (an array of __le16 in DMA memory) directly into a
native u16 without le16_to_cpu(), and without a subsequent dma_rmb() before
fetching ring entries, lead to reading stale data on relaxed memory models =
or
broken functionality on big-endian architectures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910112947.1350=
877-1-runyu.xiao@seu.edu.cn?part=3D1
