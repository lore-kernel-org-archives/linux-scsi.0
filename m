Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579151;
	b=hl9cMpCVfYHFbYOTbEnLQCJDMPqRZt4jXLQu2iXskZHr7rurE5agV1k9OTGiK4rRtRTQ
	 SkN+cK45iOE7LP9d5UZvc5VmE8QxQ4W6e68C13yDbTeNfrMc8HiiSQ36b8+87adtUea2t
	 RdJaieewUWCtM558kCUOOV97bHjtgsr4LhT5b0N8c88yU1mnbXRmczMGXmwHQTD8IPD3i
	 mdOIF8AXrg6/AqOVLv8tqU8zDVrc91spRNdaVDGpHjVcdjTHjSq61BzLfpMHEVp6GxTji
	 rk7AYgI+KLUiFRiHfNHLNHAtrAqD/7U2ivhVCQjeJ5leGY3a3MvSpjBTkD2wxue2G4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579151;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DAJs8SbSznXvXx6JME2YNbUILjTQdjGxuDK6iQ696QY=;
	b=Kh4JC7mi71Pqj5g71rqi+TS8YXk6kcWaEMLOFnSJWsoHdu980kASOjkiXAkbxpATQzBn
	 WU5lJ3/9yyd4gZJH1tV06gJBSZW2yUqEAwJKqI/KJP92qu67qkcQpIdb/VE3Qb+1IdyF6
	 edMhW3trrZcrcEM2WqUPdEMbuzU0YsSzZf+wq6w7iR8g6+KOewshosolATxURt4r71BGA
	 /J6HhEd+VSlLGlv5RNBqRm+lhnFbJEmTc5PVVntGB5gpFf+K6jIz0Xg61qXO+Cilpn1XE
	 ySZUMoSNf9RB1Ex8I5lTAd0WuiIAGN6oCL+Ttnif5k854hh7qOk3kVGxXdB46a/fkvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L19IYMsn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC989606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L19IYMsn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5661F000C9;
	Wed, 21 Oct 2026 10:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579150;
	bh=DAJs8SbSznXvXx6JME2YNbUILjTQdjGxuDK6iQ696QY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L19IYMsnueZTSqsQjqeFaizGl5nHQI6fTFouCEwblz3ZQyrEtPUeJa1f7trEOYqU/
	 LT+/l62ImbDB15FdGAifgo80zKWrzsKMvwBaYoRH+w5RJ6Zh77gnBpHBkE2cufKDox
	 6GQI4/G57YrN166dL8wpNsm35a7lFV+8M71CNZIM+pk4raYc6apOLvQBqwHez17YYd
	 t3VG+LysFaE/mcZgHpr389tbbRCSajIck2ou9XpBEttppcmEbOHi6cHSzKtuhdNAnF
	 6CzKKLcm90KGZCkepaWmgyP2Ns038u5/HtsIYuq+RJ5Yr53o7fiJYb6st1ozV0c0dy
	 gcCMlBfsLceTA==
Message-ID: <sashiko-outbox-180109@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/14] scsi: qla2xxx: Fix scan state machine race and
 IRQ-unsafe sp_unmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-7-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:39:09 +0000
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
- [High] scsi: qla2xxx: guaranteed sp leak in qla_async_scan_sp_done() erro=
r fallback
- [High] scsi: qla2xxx: concurrent fabric scan race in qla_async_scan_sp_do=
ne()
--

commit 09d92e8e08f8450625f401b0bf5a39748ef889db
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Fix scan state machine race and IRQ-unsafe sp_unmap

This commit updates qla_async_scan_sp_done() to snapshot vha->scan.step und=
er
vha->work_lock before switching on it, and replaces direct qla24xx_sp_unmap=
()
calls in IRQ context with QLA_EVT_UNMAP work events when posting scan work
fails.

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

[Severity: High]
Can qla2x00_alloc_work(vha, QLA_EVT_UNMAP) ever succeed when
qla2x00_post_next_scan_work() has just failed, both here in the if (res)
branch and in the if (rc) fallback at the bottom of qla_async_scan_sp_done(=
)?

Looking at qla2x00_post_next_scan_work() in drivers/scsi/qla2xxx/qla_gs.c:

    static int qla2x00_post_next_scan_work(struct scsi_qla_host *vha,
        srb_t *sp, int cmd)
    {
            struct qla_work_evt *e;

            e =3D qla2x00_alloc_work(vha, cmd);
            if (!e)
                    return QLA_FUNCTION_FAILED;

            e->u.iosb.sp =3D sp;

            return qla2x00_post_work(vha, e);
    }

Since qla2x00_post_work() unconditionally returns QLA_SUCCESS,
qla2x00_post_next_scan_work() only fails when qla2x00_alloc_work() returns
NULL.

In drivers/scsi/qla2xxx/qla_os.c, qla2x00_alloc_work() checks conditions th=
at
do not depend on the work event type:

    struct qla_work_evt *
    qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
    {
            struct qla_work_evt *e;

            if (test_bit(UNLOADING, &vha->dpc_flags))
                    return NULL;

            if (qla_vha_mark_busy(vha))
                    return NULL;

            e =3D kzalloc_obj(struct qla_work_evt, GFP_ATOMIC);
            if (!e) {
                    QLA_VHA_MARK_NOT_BUSY(vha);
                    return NULL;
            }
            ...
    }

During PCI removal (qla2x00_remove_one()), shutdown (qla2x00_shutdown()), or
vport deletion (qla24xx_vport_delete() in drivers/scsi/qla2xxx/qla_attr.c),
UNLOADING or vha->flags.delete_progress =3D 1 is set before in-flight comma=
nds
are aborted via:

    qla2x00_abort_isp_cleanup() / qla2x00_abort_all_cmds()
      -> qla2x00_abort_srb()
        -> sp->done()
          -> qla_async_scan_sp_done()

When qla2x00_post_next_scan_work() fails in these teardown paths, calling
qla2x00_alloc_work(vha, QLA_EVT_UNMAP) immediately afterward hits the exact
same UNLOADING or delete_progress check and deterministically returns NULL
(and under GFP_ATOMIC memory pressure in IRQ context, retries the identical
allocation that just failed).

Won't this leak sp (from srb_mempool / srb_cachep), its coherent DMA buffers
(sp->u.iocb_cmd.u.ctarg.req and sp->u.iocb_cmd.u.ctarg.rsp), qpair->ref_cou=
nt,
and vha->vref_count, causing qla24xx_deallocate_vp_id() to stall for its fu=
ll
10-second timeout on vha->vref_count during vport deletion and triggering a
slab cache teardown warning in kmem_cache_destroy(srb_cachep) on module
unload?

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
>  	case FAB_SCAN_GPNFT_FCP:
>  	case FAB_SCAN_GPNFT_NVME:
>  		rc =3D qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_CMD);

[Severity: High]
If another CPU starts a new scan as soon as SF_SCANNING is cleared here,
does switching on the saved step allow two fabric scans to run concurrently
and corrupt vha->scan?

A fabric scan is a multi-step sequence (FAB_SCAN_START -> FAB_SCAN_GPNFT_FCP
-> FAB_SCAN_GNNFT_FCP -> FAB_SCAN_GPNFT_NVME -> FAB_SCAN_GNNFT_NVME ->
qla_fab_scan_finish()) that reuses a single sp and populates the shared arr=
ay
vha->scan.l across steps.

When qla_async_scan_sp_done() clears SF_SCANNING and releases vha->work_loc=
k,
a concurrent qla_fab_scan_start() -> qla_fab_async_scan(vha, NULL) on anoth=
er
CPU can observe SF_SCANNING clear, set SF_SCANNING, reset vha->scan.step to
FAB_SCAN_START, and zero vha->scan.l:

    drivers/scsi/qla2xxx/qla_gs.c:qla_fab_async_scan() {
            spin_lock_irqsave(&vha->work_lock, flags);
            if (vha->scan.scan_flags & SF_SCANNING) {
                    spin_unlock_irqrestore(&vha->work_lock, flags);
                    ...
                    goto done_free_sp;
            }
            vha->scan.scan_flags |=3D SF_SCANNING;
            if (!sp)
                    vha->scan.step =3D FAB_SCAN_START;

            spin_unlock_irqrestore(&vha->work_lock, flags);
    }

Because qla_async_scan_sp_done() now continues using the saved step instead
of aborting, the first scan queues QLA_EVT_SCAN_FINISH or QLA_EVT_SCAN_CMD
while the second scan is active:

1. If the first scan queues QLA_EVT_SCAN_FINISH, qla_fab_scan_finish() runs
   without checking SF_SCANNING while the new scan zeroes and repopulates
   vha->scan.l. Can this cause qla_fab_scan_finish() to treat existing
   FCS_ONLINE ports as missing from vha->scan.l and schedule active sessions
   for deletion via qlt_schedule_sess_for_deletion(), before clearing
   SF_SCANNING at out: while the second scan's sp is still in flight?

2. If the first scan queues QLA_EVT_SCAN_CMD (calling qla_fab_async_scan(vh=
a,
   sp) with sp !=3D NULL), if the second scan holds SF_SCANNING, the first =
scan
   jumps to done_free_sp:, which frees the first sp and unconditionally
   clears SF_SCANNING while the second scan is in flight:

    done_free_sp:
            if (sp)
                    qla24xx_sp_unmap(vha, sp);
            spin_lock_irqsave(&vha->work_lock, flags);
            vha->scan.scan_flags &=3D ~SF_SCANNING;

   Alternatively, if the second scan failed allocation in FAB_SCAN_START (so
   SF_SCANNING is clear and vha->scan.step is FAB_SCAN_START), the first sc=
an
   enters case FAB_SCAN_START: with sp !=3D NULL and overwrites sp =3D
   qla2x00_get_sp(), leaking the passed-in sp and its DMA buffers.

3. In addition, qla2x00_find_free_fcp_nvme_slot(vha, sp) is called just
   before spin_lock_irqsave(&vha->work_lock, flags) and reads vha->scan.step
   without holding vha->work_lock. Since any concurrent
   qla_fab_async_scan(vha, NULL) that sees SF_SCANNING set jumps to
   done_free_sp: and clears SF_SCANNING, another scan can still start and
   overwrite vha->scan.step to FAB_SCAN_START before
   qla2x00_find_free_fcp_nvme_slot() or qla_async_scan_sp_done() reads it.

Should SF_SCANNING remain set across the entire multi-step scan until
qla_fab_scan_finish() completes (or the scan aborts), without clearing
SF_SCANNING in done_free_sp: when bailing out on an already-active scan?

[ ... ]

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
>  		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
>  		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
>  		return;

This is the second qla2x00_alloc_work(vha, QLA_EVT_UNMAP) fallback mentioned
above that will fail for the same reason as qla2x00_post_next_scan_work() a=
nd
leak sp.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D6
