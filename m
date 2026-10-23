Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751657;
	b=ups9/0dT+h0VKOyivTBb1nmaG7l8KaN36QpCJP515PcjMGdeIFsRv02Es+8xhTDOdCHi
	 yUzQ3heUXSzWx74lhBgPKSKtGfZ/UzyW5Nc2dMTIlAzlmphyGRD9ttWm8frvGuWnlqHQX
	 +hsnmKhhyVBaWXuSrVgHV/MHOVopjJV+CEIv7S3Frl6QoFx2nm/ouvZmF8q5UtO69S9Zu
	 8xC8Bp/BtHof7axpBcdVJeMvTyoFGdaINq7zga720NDqqx9TCOP9cHkVUIZrFhBqxIMc1
	 K39lUU1t2sc/1xEEO8/I35ozP+d527vD8E3P4yDrsS2A9uwyLTfJ3Eu4E3V8+njNXQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751657;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=480ojL5B0wTxRo+Rwk7Sd8oIWh0pQRYXwICTyu0kZto=;
	b=YYy+J+ZG12onKNnRRjJuqpN4wQvKdR8XM99pN4mABPHLjEdcykuHQsRd00EQb/XMMLfA
	 n9A3I+jo0fzuYQPPfdm+i1v56UD8qnsrHs+gm/rhLIvKVm0E9pQUiEaRurz/ubBaAHJO1
	 8I/a/2oCQgqHxmuw8AbkokdGkgWlW0vyANQ5gU2lUG5j49RZYfM5Q9rNUQEfX1XqFhevt
	 nV6Y8ogl+md+h/FXfxRASNjZM36DzIN8cqCU1ztF3yo2MmtAY2Ty2vDSg6HvPTS2ZiQty
	 O5wd/NwYhQ6wA0KI4sR4WsKr4ohdJXgglPSXJrNC0bm2fQ1wucbBLz0FSdfFjwZsAgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwDrFOlz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203E0606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwDrFOlz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8121F01825;
	Fri, 23 Oct 2026 10:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792751656;
	bh=480ojL5B0wTxRo+Rwk7Sd8oIWh0pQRYXwICTyu0kZto=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lwDrFOlzo9uE4C9l51NAuV+lWcaUc5uCDS7lo/mm47JVvzk0s0ydhh4irIayhfPRM
	 xyKBf0EvzG41A2EYABg4t0jaBls6PBXR6bK7ZhZ7MmIQtG+gnFu17VBjO81AoR7+jv
	 8AWpsXjshn20uiIJjd2z/lydHECHe7/Adqgqs9p2IaMCUdBy6fKBdrCQde7XRGYCl9
	 tSev9MavigzLatDTHRpBiq1yTb/2dEAsn74hhE9yyP1mTAAo6+DHP4Xuhka5qyZNVq
	 n/oJowvlKpTwA8tuwbfJap6U+8tcdwp5O/eESnhmvuf6T3NMKxhDBzINWytGCzE13J
	 EjWdysiluVkow==
Message-ID: <sashiko-outbox-182693@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/13] scsi: qla2xxx: Fix scan state machine race and
 IRQ-unsafe sp_unmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-7-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:34:16 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: qla2xxx: incomplete scan.step race fix in qla_async_scan_sp_=
done()
- [High] scsi: qla2xxx: sp and DMA leak in qla_async_scan_sp_done() on work=
 alloc fail
--

commit e9cd982d25a90416902027b8c35c59ac8e31a64e
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Fix scan state machine race and IRQ-unsafe sp_unmap

This commit saves vha->scan.step into a local variable under work_lock in
qla_async_scan_sp_done() and defers qla24xx_sp_unmap() to process context v=
ia
QLA_EVT_UNMAP when posting scan work fails.

> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index 20b1aef455c4f..efe98609c149d 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3512,6 +3512,8 @@ static void qla2x00_find_free_fcp_nvme_slot(struct =
scsi_qla_host *vha,
>  static void qla_async_scan_sp_done(srb_t *sp, int res)
>  {
>  	struct scsi_qla_host *vha =3D sp->vha;
> +	struct qla_work_evt *e;
> +	enum scan_step step;
>  	unsigned long flags;
>  	int rc;
> =20
> @@ -3544,8 +3546,16 @@ static void qla_async_scan_sp_done(srb_t *sp, int =
res)
>  		 */
>  		rc =3D qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_FINISH);
>  		if (rc) {
> -			/* Cleanup here to prevent memory leak */
> -			qla24xx_sp_unmap(vha, sp);
> +			/* Defer sp_unmap to process context -- we are in IRQ */
> +			e =3D qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
> +			if (e) {
> +				e->u.iosb.sp =3D sp;
> +				qla2x00_post_work(vha, e);
> +			} else {
> +				ql_log(ql_log_warn, vha, 0x2029,
> +				       "%s: Failed to schedule sp_unmap, sp leaked\n",
> +				       name);
> +			}
> =20
>  			spin_lock_irqsave(&vha->work_lock, flags);
>  			vha->scan.scan_flags &=3D ~SF_SCANNING;
> @@ -3568,10 +3578,11 @@ static void qla_async_scan_sp_done(srb_t *sp, int=
 res)
>  	qla2x00_find_free_fcp_nvme_slot(vha, sp);
> =20
>  	spin_lock_irqsave(&vha->work_lock, flags);
> +	step =3D vha->scan.step;
>  	vha->scan.scan_flags &=3D ~SF_SCANNING;
>  	spin_unlock_irqrestore(&vha->work_lock, flags);
> =20
> -	switch (vha->scan.step) {
> +	switch (step) {

[Severity: High]
Does saving vha->scan.step into a local variable while clearing SF_SCANNING
between scan steps allow two fabric scans to run concurrently and corrupt
vha->scan?

In the race described by the commit message, as soon as SF_SCANNING is
cleared here in qla_async_scan_sp_done(), another CPU calling
qla_fab_scan_start() -> qla_fab_async_scan(vha, NULL) can see SF_SCANNING
clear, set SF_SCANNING, reset vha->scan.step to FAB_SCAN_START, and zero
vha->scan.l:

drivers/scsi/qla2xxx/qla_gs.c:qla_fab_async_scan() {
	spin_lock_irqsave(&vha->work_lock, flags);
	if (vha->scan.scan_flags & SF_SCANNING) {
		spin_unlock_irqrestore(&vha->work_lock, flags);
		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2012,
		    "%s: scan active for sp:%p\n", __func__, sp);
		goto done_free_sp;
	}
	vha->scan.scan_flags |=3D SF_SCANNING;
	if (!sp)
		vha->scan.step =3D FAB_SCAN_START;

	spin_unlock_irqrestore(&vha->work_lock, flags);
	...
		memset(vha->scan.l, 0, vha->scan.size);
}

With this change, qla_async_scan_sp_done() switches on the saved step and
posts QLA_EVT_SCAN_CMD or QLA_EVT_SCAN_FINISH for the first scan while the
second scan is also running:

1. If step was FAB_SCAN_GNNFT_NVME (or FAB_SCAN_GNNFT_FCP without NVMe),
   qla_fab_scan_finish() runs on the workqueue concurrently with the new
   scan, reads vha->scan.l while the new scan zeroes or overwrites it (which
   can leave online ports in QLA_FCPORT_SCAN and schedule them for deletion
   via qlt_schedule_sess_for_deletion()), and then clears SF_SCANNING at the
   out label while the second scan's SRB is in flight.

2. If step was an intermediate step, qla_fab_async_scan(vha, sp) runs with
   the first scan's non-NULL sp. If the second scan failed an allocation in
   FAB_SCAN_START (which clears SF_SCANNING while leaving vha->scan.step as
   FAB_SCAN_START), the first scan enters case FAB_SCAN_START and overwrites
   sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL), leaking the first scan's sp
   and its coherent DMA buffers ctarg.req and ctarg.rsp.

3. Conversely, if qla_fab_async_scan() is entered while SF_SCANNING is
   already set, it jumps to done_free_sp, which unconditionally clears
   SF_SCANNING:

drivers/scsi/qla2xxx/qla_gs.c:qla_fab_async_scan() {
done_free_sp:
	...
	spin_lock_irqsave(&vha->work_lock, flags);
	vha->scan.scan_flags &=3D ~SF_SCANNING;
}

   Once SF_SCANNING is cleared while an SRB is still in flight, another
   qla_fab_scan_start() call can set vha->scan.step =3D FAB_SCAN_START befo=
re
   qla_async_scan_sp_done() runs, so qla2x00_find_free_fcp_nvme_slot() (whi=
ch
   reads vha->scan.step outside work_lock) and step =3D vha->scan.step in
   qla_async_scan_sp_done() will still see FAB_SCAN_START and hit WARN_ON(1=
).

>  	case FAB_SCAN_GPNFT_FCP:
>  	case FAB_SCAN_GPNFT_NVME:
>  		rc =3D qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_CMD);
> @@ -3594,7 +3605,16 @@ static void qla_async_scan_sp_done(srb_t *sp, int =
res)
>  	}
> =20
>  	if (rc) {
> -		qla24xx_sp_unmap(vha, sp);
> +		/* Defer sp_unmap to process context -- we are in IRQ */
> +		e =3D qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
> +		if (e) {
> +			e->u.iosb.sp =3D sp;
> +			qla2x00_post_work(vha, e);
> +		} else {
> +			ql_log(ql_log_warn, vha, 0x202a,
> +			       "%s: Failed to schedule sp_unmap, sp leaked\n",
> +			       __func__);
> +		}

[Severity: High]
Can qla2x00_alloc_work(vha, QLA_EVT_UNMAP) ever succeed here or in the error
path above when qla2x00_post_next_scan_work() just failed, and does this le=
ak
sp, its DMA buffers, and its vha and qpair references during unload or vport
deletion?

Looking at qla2x00_post_next_scan_work():

drivers/scsi/qla2xxx/qla_gs.c:qla2x00_post_next_scan_work() {
	e =3D qla2x00_alloc_work(vha, cmd);
	if (!e)
		return QLA_FUNCTION_FAILED;

	e->u.iosb.sp =3D sp;

	return qla2x00_post_work(vha, e);
}

Since qla2x00_post_work() always returns QLA_SUCCESS,
qla2x00_post_next_scan_work() only fails when qla2x00_alloc_work() returns
NULL:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_alloc_work() {
	if (test_bit(UNLOADING, &vha->dpc_flags))
		return NULL;

	if (qla_vha_mark_busy(vha))
		return NULL;

	e =3D kzalloc_obj(struct qla_work_evt, GFP_ATOMIC);
	...
}

When an in-flight scan SRB is aborted during driver unload (where UNLOADING
is set before qla2x00_abort_all_cmds() invokes sp->done()) or vport deletion
(where delete_progress causes qla_vha_mark_busy() to fail),
qla2x00_post_next_scan_work() fails because qla2x00_alloc_work() returns
NULL. Calling qla2x00_alloc_work(vha, QLA_EVT_UNMAP) immediately afterwards
checks the exact same conditions and will also return NULL (and under
GFP_ATOMIC allocation failure, retries the identical allocation in the same
hard IRQ context).

When the else branch is taken, sp, sp->u.iocb_cmd.u.ctarg.req, and
sp->u.iocb_cmd.u.ctarg.rsp are leaked, and kref_put(&sp->cmd_kref,
qla2x00_sp_release) is never called, leaving vha->vref_count elevated (which
stalls qla24xx_deallocate_vp_id()) and leaving objects allocated in
srb_cachep when kmem_cache_destroy(srb_cachep) runs in qla2x00_module_exit(=
).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D6
