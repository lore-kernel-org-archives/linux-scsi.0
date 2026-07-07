Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C4E13D53C
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409924; cv=none; b=Txcu7NKIjEQiHOaiTIWaZoOAoSAI3UqZhTXNDbINmfIJoMRFBBbxwR9d/YcicASDITd1+X3m2ed7h7oRmJj4cWxuzwJi1R41wpFxdiIoq7RNT08yLaYK9STkfpnIw5fnF80rafl3Eqd9PuMdLS8vfPHR7ZeUi1AlCvFNR+tXCb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409924; c=relaxed/simple;
	bh=uAJ72TZCjNrJi6rt6VCy1/xMOOQ3m6mC0mSgfX0Mwx4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IOLSe1YYIPAzvCij9PT2TShHfYFJvvmS/7UV10XbMCE+BfXGtB82ZF07xY31jytXvWKf3Js/SB9fzL5bphVFHN0IaMczi0/TV2LAYAXx28AnUC7lo4fErDxPPbYqjvUdiBcJgixiW2VNf8hdfcpVLpZLsVvrfNM743K8GPfr2i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TaEGcyfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TaEGcyfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577961F000E9;
	Tue,  7 Jul 2026 07:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409922;
	bh=Ny8B1f1QS/dAynkazBjLkBYsoFXFGINzP9iBnqMxDrM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TaEGcyfxt3HZIx6X2RxvGA3EMidHrmPUFf/JQ/Bqkc9WM1OafdMaVQCjkgeHMGvRs
	 fezLx1C90AAh9ssgg6E3PuZ6+mETtrr2erb4DTRCvGQvjI4EiDwdWKVHWwWoEyUSN0
	 cpYCzssb1gjxNKWGC9RIcni1zqC+LdZZN4xCrzFnYxrTAqZBQ5+lKYCdkK/ieyZ046
	 zaqHpzpQHXJFrj3vDy04b03UfFpaRvZLLGsYYI2O7RqBBvpSbHfpyMhosrZOcAIq02
	 6z68XANc0B6E7mzssjo3Ym37G9JnB3iHPbc/7kL3VUbR8Vi2H2gdyoM3lfRIwrWN7X
	 3S8K+2csSM4iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 82/88] scsi: qla2xxx: Serialize NVMe unsol ctx list
 with a per-fcport lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-83-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-83-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:38:41 +0000
Message-Id: <20260707073842.577961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `unsol_ctx_head` list is functionally write-only and never t=
raversed, making the list and the newly added `unsol_ctx_lock` dead state t=
hat should be removed instead of synchronized.
--

--- Patch [82]: [PATCH v3 82/88] scsi: qla2xxx: Serialize NVMe unsol ctx li=
st with a per-fcport lock ---
commit f8ccd94b18e0f83a1d0b27da47b7d2c7baf3e9c0
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock

This commit introduces a per-fcport spinlock to serialize accesses to
the unsol_ctx_head list. It adds the lock to protect list_add_tail and
list_del operations from concurrent accesses in different contexts.

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index bb4305f6a364c..afbd056148bd5 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
[ ... ]
> @@ -2645,6 +2645,8 @@ typedef struct fc_port {
>  	struct list_head list;
>  	struct scsi_qla_host *vha;
>  	struct list_head unsol_ctx_head;
> +	/* Serializes unsol_ctx_head against ISR, DPC and NVMe transport. */
> +	spinlock_t unsol_ctx_lock;

[Severity: Medium]
Is the unsol_ctx_head list ever actually read or traversed anywhere in the
codebase? Looking through the driver, it appears this list might be=20
functionally write-only. If the list is dead state, would it be better
to completely remove unsol_ctx_head and uctx->elem rather than adding a
spinlock to protect them?

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 36b742f73abf3..beccece1e7d92 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
[ ... ]
> @@ -1439,7 +1446,9 @@ void qla2xxx_process_purls_iocb(void **pkt, struct =
rsp_que **rsp)
>  	uctx->ox_id =3D p->ox_id;
>  	qla_rport->uctx =3D uctx;
>  	INIT_LIST_HEAD(&uctx->elem);
> +	spin_lock_irqsave(&fcport->unsol_ctx_lock, flags);
>  	list_add_tail(&uctx->elem, &fcport->unsol_ctx_head);
> +	spin_unlock_irqrestore(&fcport->unsol_ctx_lock, flags);
>  	item->purls_context =3D (void *)uctx;

[Severity: Medium]
Does taking this new spinlock in the hot path to add an element to an=20
unused list introduce unnecessary synchronization overhead? If the list
is never traversed, could we avoid this performance penalty by removing
the list operations entirely instead of serializing it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D82
