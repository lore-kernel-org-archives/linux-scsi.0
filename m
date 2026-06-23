Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA44F3624C3
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180494; cv=none; b=emM+P1He6KPOG8lPpUWj/EYpoxzNQvvkpgIm1JfilGusTNgkO30lrtimOQ6IRtUNIX4xwcTd0y+n3FZVp0uUtrvc8vMpJgzTQzurjr7Hd/OmnrPZvpjpYxOztuI+PtP4pEXtAiUI/lyG2l91GfgobrDzCkTYQ4vEjDhYSbEMjPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180494; c=relaxed/simple;
	bh=kWjpZWrR3Elhd3tR1NGMfTFikvqoW29suh8SHmusNSI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YZpmOJwqhb/1TB88B2OyKcpzukc3oGmThMUmugMWEaaohhBn4/KOxVnusavevKcUkAkXS+4rg255B4szcOJkCdxisx8hUF39G5KnRiECSBE4Ut1WeaUU5SbZ4vIuBlhS4JmZ8wvCg84npW93P1srRuKUkxdKoAPj4iu0tGVB3JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8i6vJsC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8i6vJsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9F21F000E9;
	Tue, 23 Jun 2026 02:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180493;
	bh=HkIqfLl5MKaE1n6B+7KGfNv7hj5qTnkVPwtitxz3I3I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I8i6vJsCVntRGldFE/B6/RICOBKsi6cZt6TFm2qkvqfY70G4kQt/4Ce16Yr8zq7rj
	 bhEMlQMw0xtsYW35FauhdA/3ojWd/brqAZgdr0q9NxgWiglIWA8X2FJHEEirAYUPTH
	 dXF7zBwd4QPqhbNr+DDGGtuqGon5dOMWu6sS7B8fJ6oLmDPKIog2hV5UkxGoDXnzNI
	 8C8PrpxIlbPIIi3KGwXUeHOaxmP2rLfM4WwZBhlV+PlNJsfzC4uHizK1vRUQ67Ez26
	 jf5y7GNgmcN/QqGAOtK26G7i9bIUCNkNpd10s0UZ3CFRm72DusI7NeOs+mlEYm8Fsf
	 auLHU/1JkNtkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 25/29] ibmvfc: implement nvme-fc LS submission transport
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-26-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-26-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:08:12 +0000
Message-Id: <20260623020813.5C9F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The driver accesses NVMe-FC response payloads (`evt->ls_req->rspad=
dr` and `fcp_req->rspaddr`) from CPU memory while they are still mapped for=
 DMA, before the NVMe-FC core unmaps or syncs them. On architectures using =
SWIOTLB bounce buffers (like PowerPC Secure Execution), this causes the dri=
ver to read stale data and its manual payload writes to be clobbered by the=
 subsequent DMA sync.
--

commit 1915a13751880ed8af4917b3092d7cf5b63c79eb
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement nvme-fc LS submission transport callback
   =20
NVMe FC Link Service commands are required to use the ibmvfc_passthru
MAD. Initialize a pssthru mad for the target port including the DMA
addresses for the FC4_LS request and response as well as the max length
of each IU as provided in the nvmefc_ls_req struct. FC4_LS commands are
sent via the primary CRQ. Further, store the assoc_id during a create
association request as this is a required field in our vfc_cmd struct
for nvme_fcp_io commands.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 1108d11d6b2db..506135c1a34e3 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c

[ ... ]

> @@ -62,10 +62,99 @@ static void ibmvfc_nvme_delete_queue(struct nvme_fc_l=
ocal_port *lport, unsigned
>  	kfree(handle);
>  }
> =20
> +static void ibmvfc_ls_req_done(struct ibmvfc_event *evt)
> +{
> +	struct ibmvfc_target *tgt =3D evt->tgt;
> +	struct ibmvfc_passthru_mad *mad =3D &evt->xfer_iu->passthru;
> +	struct fcnvme_ls_rqst_w0 *ls_rqst;
> +	struct fcnvme_ls_cr_assoc_acc *ls_resp;
> +	u32 status =3D be16_to_cpu(mad->common.status);
> +	int rc =3D 0;
> +
> +	ls_rqst =3D (struct fcnvme_ls_rqst_w0 *)evt->ls_req->rqstaddr;
> +	ls_resp =3D (struct fcnvme_ls_cr_assoc_acc *)evt->ls_req->rspaddr;
> +
> +	switch (status) {
> +	case IBMVFC_MAD_SUCCESS:
> +		tgt_dbg(tgt, "ls_req succeeded\n");
> +		if ((ls_rqst->ls_cmd =3D=3D FCNVME_LS_CREATE_ASSOCIATION) &&
> +		    (ls_resp->hdr.w0.ls_cmd =3D=3D FCNVME_LS_ACC)) {
> +			tgt->assoc_id =3D be64_to_cpu(ls_resp->associd.association_id);

[Severity: High]
Does this code read stale data from the response buffer when bounce buffers
are active?

Since the response payload at evt->ls_req->rspaddr is mapped for DMA, and t=
he
NVMe-FC core hasn't unmapped or synced it yet, reading the association_id
here without a prior dma_sync_single_for_cpu() could result in reading stale
memory on architectures using SWIOTLB bounce buffers (like PowerPC Secure
Execution).

Additionally, does a similar issue occur in ibmvfc_nvme_done()? If the driv=
er
reads ersp->xfrd_len from rspaddr and writes to cqe->command_id before
calling fcp_req->done(), the subsequent DMA sync inside fcp_req->done()
could overwrite the manually written command_id with unmodified bounce buff=
er
memory, causing the I/O to fail.

> +			tgt_dbg(tgt, "assoc_id 0x%llx\n", tgt->assoc_id);
> +		}
> +		break;
> +	case IBMVFC_MAD_DRIVER_FAILED:
> +		break;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D25
