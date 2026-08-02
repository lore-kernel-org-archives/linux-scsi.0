Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CC72AD37
	for <linux-scsi@vger.kernel.org>; Sun,  2 Aug 2026 23:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785712568; cv=none; b=mRLhK7q4yGf3hcmIbLr+T554oOuJNZITqv7TcbBn7UWQV2BlC8pxbnsN4UWhuq/KJG94/0EsyTBQuaDyteE+pyKIDPhExFX4OK03ws15VETB7et2poJdnBhM5pqNySbjySIgdqJu9gImvlXD4PDIS1ULlRetlwq8FsIA9sy+fls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785712568; c=relaxed/simple;
	bh=gZ1J/+3G/pKh/wKEjA2dMaEb0/zRrGyT4f7RgsZll6w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kpFCYoBYTa+OrlkNdneW4epHYtgBEWqW8RsKnj3Dc6IzpsB7qGl79kDmG9GvAKBB6ScWHAFGAWbmDvBDzmPKBtmCiMJf7c2Un+ximJvSYWIIaIUs3rK7leXz/f9qisc8ofu19H8UlNZ0mhodHxmF8dm1ULyTwv62yigEzLEh0M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+nrY2p0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+nrY2p0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89011F000E9;
	Sun,  2 Aug 2026 23:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785712566;
	bh=Ga4jW7fbgmfXCmkoQVjrvSVmUTBzF6zemM+i60hRWME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j+nrY2p0bZL23A6kAc4f7546c5OV98xs8tnQ7SPekdGVC/esYQmjklQEVpI+epNuB
	 G8bE4/92OUu1Myt5EdSE0kesIix6Olbh2U/EoqUAmjGfT9n/xPdjO29TKpu6tWNGWP
	 OcKoEyGqctaAGOyu5rLz06jZaqjTQ0416Se5ioCriatsMcYrvjNE6CZrdBTi7H/FFJ
	 acIFXW0l8jYA4wEw+cMtT90c2o0p/RFbcr9rxVf7pxV8xAhRHX3ca2uYYcmetuXlLZ
	 t+b5m4oiPUdwto8waAieSN+a0TcUj/9wIbi3E/kkgR423fyRz8azRNPwDQu48ejnx4
	 +C9/672eBEwVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: qla2xxx: Cancel qpair work before freeing
 queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <dbgh9129@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260802230039.586918-1-dbgh9129@gmail.com>
References: <20260802230039.586918-1-dbgh9129@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 23:16:06 +0000
Message-Id: <20260802231606.B89011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] The patch adds `cancel_work_sync(&qpair->q_work)` before unregiste=
ring the MSI-X interrupt, leaving a race window where the active interrupt =
handler can re-queue the work, leading to a Use-After-Free when the queue p=
air is subsequently freed.

Pre-existing issues:
- [High] If deleting the request or response queue fails, `qla2xxx_delete_q=
pair()` bails out early, leaking the queue pair's software resources.
- [High] `request_irq()` is called before `INIT_WORK(&qpair->q_work, qla_do=
_work)`, allowing an early interrupt to enqueue a zero-allocated (uninitial=
ized) `work_struct`.
- [High] Software memory and DMA rings for queues are permanently leaked wh=
en `qpairs_req_created` is false.
--

--- Patch [1]: [PATCH v1] scsi: qla2xxx: Cancel qpair work before freeing q=
ueues ---
commit 6aefba2c9206876be8f5e675b0612f13ef6a77b5
Author: Yuho Choi <dbgh9129@gmail.com>

scsi: qla2xxx: Cancel qpair work before freeing queues

This commit fixes an issue where the qpair response interrupt handler could
queue work with a deleted qpair context. It does this by marking the qpair
for deletion and cancelling its work earlier in the teardown and error path=
s.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e746c9274cded..d5cd33e84720e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
[ ... ]
> @@ -10028,6 +10034,8 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vh=
a, struct qla_qpair *qpair)
>  	struct qla_hw_data *ha =3D qpair->hw;
> =20
>  	qpair->delete_in_progress =3D 1;
> +	if (qpair->hw->wq)
> +		cancel_work_sync(&qpair->q_work);

[Severity: High]
Does this leave a window where an interrupt can re-queue the work before the
interrupt is unregistered?

Because qla2xxx_msix_rsp_q() unconditionally queues the work without checki=
ng
delete_in_progress:

drivers/scsi/qla2xxx/qla_isr.c:qla2xxx_msix_rsp_q() {
    ...
    queue_work(ha->wq, &qpair->q_work);
    return IRQ_HANDLED;
}

And the interrupt isn't unregistered until later in the teardown when
qla25xx_delete_rsp_que() calls free_irq(), could a late interrupt fire right
after cancel_work_sync() and re-queue the work, leading to a use-after-free
when the qpair is eventually freed?

> =20
>  	qla_free_buf_pool(qpair);
> =20
>  	ret =3D qla25xx_delete_req_que(vha, qpair->req);
>  	if (ret !=3D QLA_SUCCESS)
>  		goto fail;

[Severity: High]
This is a pre-existing issue, but could this early bailout leak the queue
pair's software resources?

If qla25xx_delete_req_que() times out or fails (e.g., due to unresponsive
hardware) and returns QLA_FUNCTION_FAILED, it takes the goto fail path and
returns early. Will this skip freeing the remaining DMA buffers, kernel
structures, and MSI-X vectors that are typically cleaned up unconditionally
at the bottom of qla2xxx_delete_qpair()?


I also noticed a few pre-existing issues in related code:

drivers/scsi/qla2xxx/qla_mid.c:qla25xx_create_rsp_que() {
    ...
	ret =3D qla25xx_request_irq(ha, qpair, qpair->msix);
	if (ret)
		goto que_failed;

	if (startqp) {
    ...
}

[Severity: High]
This isn't a bug introduced by this patch, but can an early interrupt
trigger a panic here?

Since the interrupt is enabled by request_irq() before INIT_WORK() initiali=
zes
qpair->q_work at the end of the function, could an interrupt fire immediate=
ly
and cause the handler to enqueue a zero-allocated (uninitialized) work_stru=
ct,
leading to a NULL pointer dereference in the workqueue worker thread?


drivers/scsi/qla2xxx/qla_mid.c:qla25xx_delete_req_que() {
	...
	if (req && vha->flags.qpairs_req_created) {
		req->options |=3D BIT_0;
		ret =3D qla25xx_init_req_que(vha, req);
		if (ret !=3D QLA_SUCCESS)
			return QLA_FUNCTION_FAILED;

		qla25xx_free_req_que(vha, req);
	}

	return ret;
}

[Severity: High]
This is a pre-existing issue, but does this function permanently leak memory
when qpairs_req_created is false?

If a queue pair is created with startqp=3Dfalse, the rings are allocated but
vha->flags.qpairs_req_created remains unset. During teardown, this function
evaluates the flag to false, returns QLA_SUCCESS early, and completely skips
qla25xx_free_req_que(). Will this leak the DMA rings (req->ring) and queue
structures upon driver unbind?

The same pattern also exists in qla25xx_delete_rsp_que() when
qpairs_rsp_created is false.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802230039.5869=
18-1-dbgh9129@gmail.com?part=3D1
