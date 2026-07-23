Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B56308F3E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 19:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784835395; cv=none; b=NxHwzFDZPhBHtJe/+XQsV0uP3UIDKWYFlGDv5VWj9fa1Po56uvJDlxit113hlunqgRate6Fd/agmgl2SCWSHObv55UwtVcauZSsrQ7biN0KQJfHjjv7eNxRE1ala3mmSVrb3+jFeS2bpxTvORrmZCR+/WZrxMfLa1uU/sP5GM8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784835395; c=relaxed/simple;
	bh=S8QlmF9qg+RpsK4oRhIZWAfT3bDg9odF6qHz1hgM5E4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GdP0SgR9jGTmuUvq94eOU7qzkhAGoL3WZWMBFa1znn81D6s0MED6M4rvAeOvmPbYBNW1nXu5iVqIEIxBDPZOsC+OeElZOFyyKHHWTHTE9DgLoQnzp7nqYGFrlDzg6/vF34uVctIOZul/xXuh+tQxhFK5hggXQ3Kbap7c2S+pGvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3u/hz9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3u/hz9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C1B1F000E9;
	Thu, 23 Jul 2026 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784835393;
	bh=UoGZ+F6psbDT/sEUDigOy9sAy712208nTNs1ndkFwWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S3u/hz9Ah9yBs2qUyurE8agsLXcIR9dA694WFBaBxeQac4e09azKMZPtUkr7scg8X
	 nhGqkjcV47aytxUrwo/n7YM84LjzkLovMXrftIBllV//2+DJNmyM61vz//4db85GvU
	 c4PMaqRrpsQlImy0jN1oAUpSD0rDHqOZL8g+yKzqbb37pc9lTo6qilW9YY9S4MeuxA
	 ygc+MZHGXKnoALSnqpbdsuhTNZYchmO0ora/E+MZK05Of31ak2KTMStxQ0ko8VXrGB
	 eI2qtV7h8e5SXM+iYTOaDtp+bBDJcdYzRQD9NXIo55BSNkOqtC/2fzPYix+zBcWkaf
	 X/KViDx3ZZ4nQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 52/56] scsi: qla2xxx: Hold qpair lock when sending
 NVMe LS reject
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-53-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-53-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 19:36:33 +0000
Message-Id: <20260723193633.79C1B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] This problem wasn't introduced by this patch, but the error pa=
th of qla_nvme_xmt_ls_rsp() frees 'uctx' without removing it from the 'fcpo=
rt->unsol_ctx_head' list, causing a Use-After-Free list corruption.
- [Critical] This problem wasn't introduced by this patch, but concurrent l=
ockless accesses to the doubly-linked list 'fcport->unsol_ctx_head' cause d=
ata races and list corruption.
--

--- Patch [52]: [PATCH v6 52/56] scsi: qla2xxx: Hold qpair lock when sendin=
g NVMe LS reject ---
commit 26608c7972504e04bce429e36cbbdc786b32af3b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

This commit fixes an issue where qla_nvme_ls_reject_iocb() is called without
holding the hardware lock in error paths and the DPC context. It takes
the qp_lock_ptr lock around the two unlocked callers to prevent concurrent =
I/O
submission from corrupting the ring producer state.

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
>  	kfree(uctx);

[Severity: Critical]
This isn't a bug introduced by this patch, but on the error path of
qla_nvme_xmt_ls_rsp(), does freeing uctx without removing it from the
fcport->unsol_ctx_head list leave a dangling pointer?

When an unsolicited request arrives, uctx is allocated and added to the
unsol_ctx_head list. If this error path is taken, kfree(uctx) runs but miss=
es
the list_del(&uctx->elem) step, which could corrupt the list and lead to a
use-after-free when the next unsolicited request arrives and calls
list_add_tail().

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

[Severity: Critical]
This is a pre-existing issue, but is it safe to call list_del(&uctx->elem)
locklessly here?

It looks like list_add_tail() in qla2xxx_process_purls_iocb() modifies this
shared fcport->unsol_ctx_head list, and list_del() is also called locklessl=
y in
qla_nvme_release_lsrsp_cmd_kref().

Could concurrent unsolicited LS requests being processed by the DPC thread
and workqueues race on this doubly-linked list, causing list corruption?

>  		kfree(uctx);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D52
