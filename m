Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B3C333440
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 18:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052004; cv=none; b=TjIYmBw1FNLSHeckk1Mcq7WMLzscy00TnEWjU1y2DebkXCaUBdIxW96RDLetJ9CHfjz0vdn47qfikriXTGEyQh0IqYyarRPzVQ81zHbtJZnsTSpKuG6bmJEwGBKsYMSVEWV5dmI7dex8ujFBLJu+72kdINxGBmdcw+JeGtZ2lUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052004; c=relaxed/simple;
	bh=8GzUIcTTUqSbDwH0zUtrVOtA9xPDHtxHNrFeOnZ4czI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t40l9/RKXVInCxKcyYetO+6QjKvpEnsmQhOCdNx0ToqX/ZVFLOo11ttA88gc2uALIv/UXozvJ0f/tarWgR2l0S9ngJCmxAHIOjhXISR5LGUiAqX7BwnyiihDOMw9bYU5bIVVOUPsPJTq2FOB2Zq/4dIqbSLmTCArrLI+TwkrxNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKLhnNho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKLhnNho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBAC1F000E9;
	Tue, 14 Jul 2026 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784052000;
	bh=mKQBazXQsuNVqBsB16PfqbaagfzNT3tZJKQ37nEkvmA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GKLhnNhoFQvCYDNi+K6wwzEAyuGt3ZXaRQbec6IncJAdLDvlhprJJIEnekDxLOU2K
	 cyZS7PvmaAK7ABvKVMCmkiiCfaHgC81hC9VdHRqiZnHZ/ttO0UONDdsCbuUzkAZeRw
	 nLnE/LDubAIcW9GSVBWTcto6+dzH10Dgd6qrrsRl32uv8sbd39NU3lH3Ry6npJC0gX
	 mfJ61DTDgAD8HWevVvl0EkVver2dpuQv4EsxhH7sLiOsVaqLBYU4DF/nqdS8hJwdhJ
	 ZPPSi9NrgHidXNxarY4j0FTkvo7cQZH0h/uLHq4T/J67ZlwnNW3oRk+/z9qrNkAcgY
	 koolXmmRq6B2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 51/56] scsi: qla2xxx: Initialize NVMe abort_work once
 at submission
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-52-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-52-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 17:59:58 +0000
Message-Id: <20260714175959.0BBAC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Unbalanced kref_get_unless_zero() leaks command reference when sch=
edule_work() returns false, causing an NVMe command stall.
- [High] Unconditional INIT_WORK() in qla_nvme_post_cmd() corrupts the work=
queue if a command is retried while an abort is pending.

Pre-existing issues:
- [Critical] Submission error paths clear priv->sp and directly free the SR=
B without synchronization, causing NULL pointer dereference or use-after-fr=
ee in concurrent aborts.
--

--- Patch [51]: [PATCH v4 51/56] scsi: qla2xxx: Initialize NVMe abort_work =
once at submission ---
commit 1eba88ba9a82a1024765221adbcbb078aa9fe5ca
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Initialize NVMe abort_work once at submission

This commit moves the initialization of abort_work from the abort paths to
command submission. This prevents work item corruption if multiple aborts
are issued for the same command while a work item is already queued.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 0038b6274d444..3b2f255a5d7d4 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -463,7 +463,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_po=
rt *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);
>  }

[Severity: High]
Does this change introduce a kref leak if schedule_work() returns false?

With INIT_WORK() removed, if a concurrent abort is already pending,
schedule_work() will return false. However, earlier in qla_nvme_ls_abort(),
we unconditionally increment the command reference with
kref_get_unless_zero().=20

If schedule_work() fails because the work is already queued, the worker
only executes once and drops a single reference, meaning the extra kref
is permanently leaked and the NVMe command never completes.

[ ... ]

> @@ -545,7 +545,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_p=
ort *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);
>  }

[Severity: High]
Could this also lead to the same kref leak as in qla_nvme_ls_abort()
if schedule_work() returns false?

[ ... ]

> @@ -877,6 +876,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_por=
t *lport,
> =20
>  	kref_init(&sp->cmd_kref);
>  	spin_lock_init(&priv->cmd_lock);
> +	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	sp->priv =3D priv;
>  	priv->sp =3D sp;
>  	sp->type =3D SRB_NVME_CMD;

[Severity: High]
Does calling INIT_WORK() here corrupt the workqueue if a command is retried?

If qla2x00_start_nvme_mq() fails with -EBUSY later in qla_nvme_post_cmd(),
the blk-mq layer will eventually retry the request, calling this function
again with the same priv structure.

If a concurrent transport teardown triggered an abort during the initial
failed attempt, priv->abort_work could be actively queued on the system
workqueue. Unconditionally calling INIT_WORK() again here on the retried
attempt would overwrite the list_head of an actively queued work_struct.

[Severity: Critical]
This is a pre-existing issue, but could this error path trigger a NULL
pointer dereference or use-after-free during a concurrent abort?

If qla2x00_start_nvme_mq() fails, the error handling does:

	rval =3D qla2x00_start_nvme_mq(sp);
	if (rval !=3D QLA_SUCCESS) {
		...
		sp->priv =3D NULL;
		priv->sp =3D NULL;
		qla2xxx_rel_qpair_sp(sp->qpair, sp);
	}

This runs without holding priv->cmd_lock and without checking cmd_kref.
If a concurrent abort acquires the lock and kref just before priv->sp is
cleared, it schedules qla_nvme_abort_work().

The abort worker will then read priv->sp without locking:

drivers/scsi/qla2xxx/qla_nvme.c:qla_nvme_abort_work() {
	struct nvme_private *priv =3D container_of(work, ...);
	srb_t *sp =3D priv->sp;
	fc_port_t *fcport =3D sp->fcport;
        ...
}

This means the worker might read a NULL priv->sp and dereference it, or
use the SRB after it has been freed to the mempool by qla2xxx_rel_qpair_sp(=
).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D51
