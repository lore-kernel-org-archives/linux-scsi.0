Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8269A35E1B1
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264354; cv=none; b=EDQ85fEhOm+xVZHBlcxrHzhAE+HebpVmWrBaktHeuzJ+UO/gUjfGBAWXNaQVEi+KikVFUQPvEkO+9gB7laly7u1Pn/1QLN8ojl7gZj/rKn7ZTGKPuFhG1oqvAPCYJJMQJICzKWsrrDX2kzWw7Mwq+jl+ks336wuBtQuCbZiZ6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264354; c=relaxed/simple;
	bh=l0cteBQ/yCvud/LLLFfqmfo094+UvFsx4K5FXaDVSq4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AjhZf/nc0yL8X5+a91VV7GOcXh4FBv9IjZGA/iJbcphxi4mMzXUfAPkR3mVvZU+GhgotPR5mIzWqBRgyJLN7FcJsq8FKXXe3UECCQbzykGBg22Vr8PgXrgcrmiWVspjtk7LtMOw6BKqtGQjdYg/IEMvoz7lIVESsTz5NZQWR/a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJFSqgJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJFSqgJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009791F000E9;
	Fri, 12 Jun 2026 11:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781264353;
	bh=5LHcQR7v9RvzhchcstheQn5magY0ER8KJvx5wcW0V44=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XJFSqgJAy1yfBbJFCMv6ZvnKK4+ceb4V9II5k8huIUB5o36XhjO0NLdC8C1ZixBkS
	 VH/tpcyEMbJ40h9U8BL0gHiRvT+nVssXoEyi9lACmXvIt0SrBs5SP7Oann1y535TyQ
	 AiFP4mxq31KoWGceHsPfdXVjw4L5nH2TAeOS3/yegUZwBDBVR/osR/rhaAqy7JjZRJ
	 9S/WSYaUWNAWNVs98WRLuYEzhxBXwjdofD0Sfh1sUuFjc7zUfoxFxu17qAADRkBtOe
	 tglV7QQsIZKn4eP0yQF63SmUudFnbwr6emBqK8d1u84OQWhxKS71vCO14LRHa38Dfg
	 DKxCrF9vklI4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 57/60] scsi: qla2xxx: Hold qpair lock when sending
 NVMe LS reject
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-58-njavali@marvell.com>
References: <20260612095333.1666592-58-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:39:12 +0000
Message-Id: <20260612113913.009791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing `list_del()` before `kfree()` on the error path of `qla_nv=
me_xmt_ls_rsp()` causes use-after-free list corruption.
- [High] Concurrent and unsynchronized operations on the `fcport->unsol_ctx=
_head` linked list.
- [High] `qla_nvme_ls_reject_iocb()` unconditionally writes to the hardware=
 doorbell even when the firmware is not started or the device is offline.
--

commit d9117eaeb87a4e4531b8933ba8f285e5c93c354a
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

This commit addresses an issue where qla_nvme_ls_reject_iocb() is called
without holding the producer lock from two paths, which can corrupt the ring
producer state. It takes the qp_lock_ptr around the two unlocked callers and
documents the helper as caller-locked.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 3b2f255a5d7d4..8dc6df6c2e1c5 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -374,6 +374,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_p=
ort *lport,
>  	srb_t *sp;
>  	int rval =3D QLA_FUNCTION_FAILED;
>  	uint8_t cnt =3D 0;
> +	unsigned long flags;
> =20
>  	if (!fcport || fcport->deleted)
>  		goto out;

[ ... ]

> @@ -440,7 +441,9 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_p=
ort *lport,
>  	a.vp_idx =3D vha->vp_idx;
>  	a.nport_handle =3D uctx->nport_handle;
>  	a.xchg_address =3D uctx->exchange_address;
> +	spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
>  	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
> +	spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);

[Severity: High]
This isn't a bug introduced by this patch, but does the call to
qla_nvme_ls_reject_iocb() here write to the hardware doorbell even when the
firmware is not started?

If qla_nvme_xmt_ls_rsp() bails out early because !ha->flags.fw_started, it
jumps to the out label and executes qla_nvme_ls_reject_iocb(). Inside that
function, qla2x00_start_iocbs() unconditionally writes to the doorbell ring.

Could accessing MMIO registers when the firmware is stopped or in reset lead
to PCIe bus errors or adapter hangs?

>  	kfree(uctx);

[Severity: High]
This is a pre-existing issue, but does this error path leave a dangling
pointer in the unsol_ctx_head list?

If uctx was previously linked into fcport->unsol_ctx_head (such as in
qla2xxx_process_purls_iocb()), freeing it here without first calling
list_del(&uctx->elem) leaves the freed memory in the list.

Will the next operation on this list access freed memory and cause list
corruption?

>  	return rval;
>  }

[ ... ]

> @@ -1299,6 +1306,7 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha=
, struct purex_item *item)
>  {
>  	struct qla_nvme_unsol_ctx *uctx =3D item->purls_context;
>  	struct qla_nvme_lsrjt_pt_arg a;
> +	unsigned long flags;
>  	int ret =3D 1;
> =20
>  #if (IS_ENABLED(CONFIG_NVME_FC))
> @@ -1311,7 +1319,9 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha=
, struct purex_item *item)
>  		a.vp_idx =3D vha->vp_idx;
>  		a.nport_handle =3D uctx->nport_handle;
>  		a.xchg_address =3D uctx->exchange_address;
> +		spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr, flags);
>  		qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);
> +		spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr, flags);
>  		list_del(&uctx->elem);

[Severity: High]
This isn't a bug introduced by this patch, but does this list deletion race
with other contexts?

This list_del(&uctx->elem) is executed in a workqueue context without
acquiring any locks to protect the list. Since elements are added to the li=
st
in qla2xxx_process_purls_iocb() while holding a per-queue hardware response
lock, could concurrent unsynchronized operations corrupt the list pointers?

>  		kfree(uctx);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D57
