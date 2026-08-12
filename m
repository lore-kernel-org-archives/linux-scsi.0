Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D804E4B04B7
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559735; cv=none; b=ZjjxF4hKmN/uFDxj5r9/H/usbw8x91TMqRTGOCxKtmKYCNMm+a6TQnzAQOdKyzBRaPpZ02NxuWo/6GTXJ4MoRiHX8hs+/lkHZdEUZShKzUNiJQcv5EfPfPOEr2pK1acKbWKau1F4iDYj5ztfa79tFgGC/Xeip4a2ExqsLSl8fBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559735; c=relaxed/simple;
	bh=uZRnCE2H/r/NlgeQBca91GptJ3sEIbnKoT0P0SZopR8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r+UWjzM8n+pTLfVaA4G+tWLnY4y24ojhYjImwjQ1aphFrKcs1j8x1pgOgqB79Wbf+4k5hjoiudvrwiDtrZk+J2ytkka+MIg2vKbTYJHzb5hRVK30r4vbTtxsGJGAzYCe2c/FMa7YQsVhvrOfq1fwKJipgDCOF2k/eEpHeFXzN0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8wiEVKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8wiEVKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423061F00A3A;
	Wed, 12 Aug 2026 18:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559733;
	bh=kmYBi3zhNw29wgYKScdNNM3Qg6n8BFjcbdZ7zOgFfzk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P8wiEVKoGUhWfQFSFtWgiBPBpyQeWknCZ1FJ1vKnTq+q9AKwKLoOD1IRr712axfP/
	 9MX1qRnyVxno4kZBbRRvj2+aoQikpj+NpfquTsy6+OGVKfFJJSqq9ACww7SuvNJsxY
	 xQrfPH8v7U5598VMRNbIuyuPyVp2lGD9CZC8h8nGPuXccITNS8XkZc1NMNG/JruGy/
	 ARwBVY8G1W1T+O2ue05YnOu+oZDgeX5NcYuXaClwgHzcQKgtEy96tJIR7RaUHHa9G7
	 DGi265tzzUsAcq+yEh71HZbt/V51PdDs+gTqmpayJ3IJ9dpNRb9pfwYXOTiath9N6g
	 jA//vY4Ag+53Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/13] scsi: lpfc: enable FPIN notification for NVMe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-12-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-12-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:35:32 +0000
Message-Id: <20260812183533.423061F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] Logging Formatting Defect: Error message is improperly split across=
 two consecutive `dev_info()` calls.

Pre-existing issues:
- [High] Concurrency / Use-After-Free: Lockless access to `ndlp->nrport` an=
d `nrport->remoteport` can lead to a Use-After-Free due to concurrent unreg=
istration.
--

--- Patch [11]: [PATCH 11/13] scsi: lpfc: enable FPIN notification for NVMe=
 ---
commit 6d41021b653095acd49d1f7828d07c1405835a16
Author: Jesse Taube <jtaubepe@redhat.com>

scsi: lpfc: enable FPIN notification for NVMe

Implement set_rport_marginal callback using nvme_fc_set_remoteport_fpin() to
enable FPIN notifications for NVMe.

> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index f4e8164b94abb..d54899cceed99 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c

[ ... ]

> @@ -7134,6 +7134,30 @@ lpfc_set_rport_loss_tmo(struct fc_rport *rport, ui=
nt32_t timeout)
>  #endif
>  }
> =20
> +static void
> +lpfc_set_rport_marginal(struct fc_rport *rport, bool marginal)
> +{
> +	struct lpfc_rport_data *rdata =3D rport->dd_data;
> +	struct lpfc_nodelist *ndlp =3D rdata->pnode;
> +	struct lpfc_nvme_rport *nrport =3D NULL;
> +
> +	/* Break early if NVME_FC is not enabled */
> +	if (!IS_ENABLED(CONFIG_NVME_FC))
> +		return;
> +
> +	if (!ndlp) {
> +		dev_info(&rport->dev, "Cannot find remote node to ");
> +		dev_info(&rport->dev, "set rport marginal, port_id x%x\n",
> +			 rport->port_id);

[Severity: Low]
Does this code format the output correctly?

Because dev_info() prepends the device name and KERN_INFO to every
invocation, splitting the message across two calls without a newline on the
first will cause the prefix to be injected in the middle of the sentence in
the kernel log.

> +		return;
> +	}
> +
> +	nrport =3D lpfc_ndlp_get_nrport(ndlp);
> +
> +	if (nrport && nrport->remoteport)
> +		nvme_fc_set_remoteport_fpin(nrport->remoteport, marginal);

[Severity: High]
This is a pre-existing issue, but does this lockless retrieval of nrport via
lpfc_ndlp_get_nrport() safely protect against concurrent unregistration?

The macro performs a lockless double-fetch of ndlp->nrport without acquiring
ndlp->lock:

drivers/scsi/lpfc/lpfc_nvme.h:
#define lpfc_ndlp_get_nrport(ndlp)				\
	((!ndlp->nrport || (ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT))\
	? NULL : ndlp->nrport)

If a concurrent remote port loss triggers lpfc_nvme_unregister_port(), it
could free the NVMe remote port memory before setting ndlp->nrport =3D NULL.

Could this code then read a dangling pointer and pass nrport->remoteport
to nvme_fc_set_remoteport_fpin(), resulting in a Use-After-Free?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D11
