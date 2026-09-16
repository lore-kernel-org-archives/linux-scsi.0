Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E124A7CA1
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600919; cv=none; b=NYkcptXzrmghjKXYJcx0o4bQUP6ugXH8A6gvutZUKHQQgxON2ai86VEtnrzB+9tax5NkzmGOQs3vnasfvIC5tPzkRy3n1V3A5tGiRPwm9e6Zt3svN8KOc582lkcb2ql0SkPvyxCyYuogK3vAAmvbFC+iSgnDusUHmw47NhOUWYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600919; c=relaxed/simple;
	bh=3cFC7B6asiReNnZGxEv61BqOatKwbKA16CYApydeKLA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MYs8gDnabuVwT/F8WHv2UA0iT7I40tDVnAfz7UL3r74839Eetspt7f6NfIQZh96SWXe0T9r/cZUYoxg9UGWE/2ojOwjAH1n3O030eY1WyWj66d93e/58D2LgsIbsNuAjx8zHNNUArUfS/yzl1mIlF3cMyDKMe6xmP41L6nxYBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvnPtVQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvnPtVQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35761F000FF;
	Wed, 16 Sep 2026 23:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789600917;
	bh=3h70KfW3VAjRKIG9HzUr29ksOGCX/9pTXGKa9qI6ZXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JvnPtVQ6ZV/b6EPK0VU+swOvkRQoMNxMFEXTb/QNvphfv2UrkcmkSaOcJGIYgH5//
	 BEwMeGMwp2rllJoZnL4fi974ASOLZxU2JHC56do/YmBvDkVVwfYzsiGsMnyywAP9ls
	 PYZOU1lKxpOKZsTh+lFFHcTb2Cu14VaFeJR46Unp7GAHf8iRwu4atxtt0jF8Xt5nd/
	 w6voETbYF8XjY5yTICuyq9nskjFHfjLmembBuwEuoKEfFSAoLNSSVwv/cXFNMHvTR6
	 F6jkb9Jhsw9opDoL8gXlgtVkjpMYUzIwLsALkQ/41ZAwvXDqwTaLRnFZeVkWgSplZ1
	 xoO83QkG7NXHw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/20] scsi: ibmvfc: fix trace logging for NVMe FCP
 commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-3-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:21:57 +0000
Message-Id: <20260916232157.A35761F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: trace corruption due to uninitialized ring buffer =
fields
- [Medium] scsi: ibmvfc: incorrect xfer_len logged for NVMe commands
--

commit 1aea7045df7aa168a5c3d098c49f569b870a3fa5
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix trace logging for NVMe FCP commands
   =20
This commit fixes trace logging for NVMe FCP commands in ibmvfc_trc_start()
and ibmvfc_trc_end(). It adds gating on evt->cmnd and evt->fcp_req to preve=
nt
reading SCSI-specific fields from an NVMe IU, which was producing garbage
trace entries.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index aa7ae81df41b1..6c243b2a84d7a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -257,11 +257,16 @@ static void ibmvfc_trc_start(struct ibmvfc_event *e=
vt)
> =20
>  	switch (entry->fmt) {
>  	case IBMVFC_CMD_FORMAT:
> -		entry->op_code =3D iu->cdb[0];
>  		entry->scsi_id =3D be64_to_cpu(vfc_cmd->tgt_scsi_id);
> -		entry->lun =3D scsilun_to_int(&iu->lun);
> -		entry->tmf_flags =3D iu->tmf_flags;
> -		entry->u.start.xfer_len =3D be32_to_cpu(iu->xfer_len);
> +		if (evt->cmnd) {
> +			entry->op_code =3D iu->cdb[0];
> +			entry->lun =3D scsilun_to_int(&iu->lun);
> +			entry->tmf_flags =3D iu->tmf_flags;
> +			entry->u.start.xfer_len =3D be32_to_cpu(iu->xfer_len);
> +		} else if (evt->fcp_req) {
> +			entry->op_code =3D vfc_cmd->v3nvme.iu.sqe.common.opcode;
> +			entry->u.start.xfer_len =3D be32_to_cpu(vfc_cmd->payload_len);

[Severity: Medium]
Does this regression log the command frame size instead of the intended data
transfer length for NVMe commands? It appears to be using
vfc_cmd->payload_len (initialized from fcp_req->cmdlen) rather than
fcp_req->payload_length.

[Severity: Medium]
Could this regression leak stale data from previous trace events in the
vhost->trace ring buffer? Since the ring buffer fields are not zeroed before
reuse, NVMe commands will bypass setting entry->lun and entry->tmf_flags
without clearing them.

Additionally, TMF and NVMe LS commands have neither evt->cmnd nor
evt->fcp_req, bypassing this logic entirely and skipping initialization of
all these fields in ibmvfc_trc_start().

> +		}
>  		break;
>  	case IBMVFC_MAD_FORMAT:

[ ... ]

> @@ -294,15 +299,19 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
> =20
>  	switch (entry->fmt) {
>  	case IBMVFC_CMD_FORMAT:
> -		entry->op_code =3D iu->cdb[0];
>  		entry->scsi_id =3D be64_to_cpu(vfc_cmd->tgt_scsi_id);
> -		entry->lun =3D scsilun_to_int(&iu->lun);
> -		entry->tmf_flags =3D iu->tmf_flags;
>  		entry->u.end.status =3D be16_to_cpu(vfc_cmd->status);
>  		entry->u.end.error =3D be16_to_cpu(vfc_cmd->error);
> -		entry->u.end.fcp_rsp_flags =3D rsp->flags;
> -		entry->u.end.rsp_code =3D rsp->data.info.rsp_code;
> -		entry->u.end.scsi_status =3D rsp->scsi_status;
> +		if (evt->cmnd) {
> +			entry->op_code =3D iu->cdb[0];
> +			entry->lun =3D scsilun_to_int(&iu->lun);
> +			entry->tmf_flags =3D iu->tmf_flags;
> +			entry->u.end.fcp_rsp_flags =3D rsp->flags;
> +			entry->u.end.rsp_code =3D rsp->data.info.rsp_code;
> +			entry->u.end.scsi_status =3D rsp->scsi_status;
> +		} else if (evt->fcp_req) {
> +			entry->op_code =3D vfc_cmd->v3nvme.iu.sqe.common.opcode;

[Severity: Medium]
Does the same regression apply here during event completion tracing? It loo=
ks
like completion response fields could contain stale trace data for TMF, LS,
and NVMe FCP commands in ibmvfc_trc_end() since they are skipped without
being zeroed.

> +		}
>  		break;
>  	case IBMVFC_MAD_FORMAT:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D2
