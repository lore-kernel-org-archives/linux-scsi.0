Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979A637CD32
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784827005; cv=none; b=LkY196wdNh7GAXEff1xJkif0iQWszxPnSd+wceuP9s3Eb3sUZyERDGzUJhUmfpdUDok25ZEdCYME8VLguxEH1zXgd/HZBsvw44JWHvgyf3V1IXLcjTzXwgWWaDuO5c36iNrNNWBGEZkth6p6w3OGvIp/x6YLofWcPVOpHzaniJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784827005; c=relaxed/simple;
	bh=Z1oUmhNCufa8+DlH5c0sIMB9K875I9sMIBGUUNKGtZs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j/s4p3o17DT28eUZjHpbjTEPmC0lTgEFo1W5WwNxfMRwpwZz4crt1KrGTXUcWqzU/qUso+Lk7CyJoCBhFWU67Yr9Jm/8gS4aRcKNIp+6+U/YheGbUIcIXgwj9MuAtPGsieKPYCYB4DR/8Yj2eYIbcUK4ZqNw4GRqbwI+MU/CS8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4DXdYUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4DXdYUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E49C1F000E9;
	Thu, 23 Jul 2026 17:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784827004;
	bh=u665RuM6Ulzj8x1VIcKkwM6eia4D4AlQGp/Vaku17A4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R4DXdYUNTIRE2jzWNt3kKPljt7csCjZE94SpTRSIVuvLDFuM2DmnVycc2yVlGFPof
	 PPBBqG2PmnVvPb8WXhO3gE3pUX8+t66ovAQjNdlbdTz241LqhnmrWnHrj3tkUB8XgU
	 3FGWgKKGpUdN6xW55Y9GCComPgS38BaYfCkzyW6Dt79HQzR6Ga6y2C1UVXB22BSDIR
	 87hVRsRm6q9uwViDG8s5LvAKKFQOLtsFxWK5c9ocnNP/SS52xh/to4/ToF4cFNzeVm
	 v9+Df+bRtCPFuyrqIIxNi4egDAhDn5Ple+zC/pcSJnbwpxzp3pgm7wFmVvRmMt1W+Z
	 nxWmMcusPSfJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 40/56] scsi: qla2xxx: Fix queue teardown NULL
 dma_free and bitmap locking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-41-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-41-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 17:16:43 +0000
Message-Id: <20260723171644.1E49C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Severe resource and memory leak on queue teardown due to reliance =
on a global flag and early returns on error.
--

--- Patch [40]: [PATCH v6 40/56] scsi: qla2xxx: Fix queue teardown NULL dma=
_free and bitmap locking ---
commit 4a4916d52b2174b3c6221fdaca0059abdec4d678
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

This commit addresses two bugs in the error paths of queue creation. It adds
a NULL check before calling dma_free_coherent and ensures the same lock is=
=20
held when clearing queue map entries during teardown.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index bb2521c052bf8..7072af5b42178 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -576,16 +576,17 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, str=
uct req_que *req)
>  	uint16_t que_id =3D req->id;
>  	size_t req_entry_size =3D qla_req_entry_size(ha);
> =20
> -	dma_free_coherent(&ha->pdev->dev,
> -			  (req->length + 1) * req_entry_size,
> -			  req->ring, req->dma);
> +	if (req->ring)
> +		dma_free_coherent(&ha->pdev->dev,
> +				  (req->length + 1) * req_entry_size,
> +				  req->ring, req->dma);
>  	req->ring =3D NULL;
>  	req->dma =3D 0;
>  	if (que_id) {
> +		mutex_lock(&ha->mq_lock);
>  		ha->req_q_map[que_id] =3D NULL;
> -		mutex_lock(&ha->vport_lock);
>  		clear_bit(que_id, ha->req_qid_map);
> -		mutex_unlock(&ha->vport_lock);
> +		mutex_unlock(&ha->mq_lock);
>  	}
>  	kfree(req->outstanding_cmds);
>  	kfree(req);

[Severity: High]
This is a pre-existing issue, but I noticed a potential leak related to=20
queue teardown.

In drivers/scsi/qla2xxx/qla_mid.c:qla25xx_delete_req_que(), the driver reli=
es
on a global flag and returns early on error:

if (req && vha->flags.qpairs_req_created) {
        req->options |=3D BIT_0;
        ret =3D qla25xx_init_req_que(vha, req);
        if (ret !=3D QLA_SUCCESS)
                return QLA_FUNCTION_FAILED;

        qla25xx_free_req_que(vha, req);
}

If the queue was never initialized in hardware (for example, if=20
qla2xxx_create_qpair() passes startqp=3Dfalse in target-only mode),=20
qpairs_req_created is 0. This bypasses the call to qla25xx_free_req_que()=20
entirely, silently leaking the memory and DMA rings.

Additionally, if hardware teardown fails and returns QLA_FUNCTION_FAILED,=20
this propagates up to drivers/scsi/qla2xxx/qla_init.c:qla2xxx_delete_qpair(=
):

ret =3D qla25xx_delete_req_que(vha, qpair->req);
if (ret !=3D QLA_SUCCESS)
        goto fail;

This aborts the remaining cleanup for the qpair, which abandons the respons=
e=20
queue and MSI-X handlers.

Could this sequence leave the DMA mappings and IRQ vectors permanently=20
orphaned on module unload?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D40
