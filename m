Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF3F44BCAA
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782749797; cv=none; b=S6Y0AJ3xRsKTevhVe5Qfezlt8ya0MeR8xKStp3IcB7giLF7k4V7SUHM4FBXJL6egTlO0T68shN58qSZc9kKDfV3Yh7qmf2ssdaW9jscYDk3nE6Y5TbILDIIpyynN5fTxmMX2Jtukh6cJRAckz20bJIJ6nKAebQst2d4B7Tc6ZMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782749797; c=relaxed/simple;
	bh=rlcW7DSb/o3N7xersyrYOLTEWYGAVhb8YF3C/tjcu1I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YBf+AzuHHDEl8K8SWQ694ofsGG8Pk7fhuK5yBeBLh7zZbM9qXYA4GKyXgh/7WZwR/Lp/+cYM8QnW9MBfwwZuN07hmPS3RsGxdiiQJTj4thBAN6w6Bk3xUdOX4dUupIhHvOSUYQjPQp2Qy4Qjm78NtGlfxcahqPrpg8ygBjCs/Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FinHKI/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FinHKI/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1791F000E9;
	Mon, 29 Jun 2026 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782749796;
	bh=+M+pueJeAvWVlUMuMT40BL4xUC0SiRR0BPWc0sLAq40=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FinHKI/c/rqSou/Lhi0dT5onkgp6lNgMeuqioH+2Yee+4p7xRls1/PG13OeeQOkE/
	 tsqG31GBpoicsS9kAhZZaTgydxAAEjlbnPVRFbNiCzjVZ/0oUQRhRecfHq7FXRPFOg
	 As/BaegoJeYIY62bCvJ57yrO+Vn3/sRv63O1tYZwv+IN1jTbLSROwcWnH8D3ZZ+Vm8
	 Ze1umRjJhgZEtb7tnVGTEwaVGxBpVShGCRDj4hulUCwynR3m3PzwdrDbPWk6+PFG7y
	 wc3e2cIDqm1n5n52Qhw8LnuFWS/CC6bPmAuRvUA3YnB7+X4JJZkn/cRghKUqgwqBCM
	 VtRfXCNV4iMig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: lpfc: Add NULL check for vport in
 lpfc_dev_loss_tmo_callbk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vaibhav Nagare" <nagarevaibhav@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260629160557.586208-1-vnagare@redhat.com>
References: <20260629160557.586208-1-vnagare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 16:16:34 +0000
Message-Id: <20260629161635.5E1791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The patch causes a reference count leak for the `ndlp` node list e=
ntry and the remote port device `rport` by clearing their association point=
ers without dropping their respective references.
- [Low] The patch introduces build failures due to an undeclared variable `=
iflags` and a non-existent struct member `ndlp->lock`.

Pre-existing issues:
- [High] The patch misdiagnoses the root cause of a crash as a simple NULL =
pointer dereference and worsens an existing Use-After-Free race condition b=
y attempting to lock and read from an already-freed `ndlp` object.
--

commit 26e4dbf45e788bb3e83d872e9f277d137a11dde1
Author: Vaibhav Nagare <nagarevaibhav@gmail.com>
Subject: scsi: lpfc: Add NULL check for vport in lpfc_dev_loss_tmo_callbk

This commit attempts to fix a kernel NULL pointer dereference in
lpfc_dev_loss_tmo_callbk() when ndlp->vport is NULL during FC remote
port deletion. It adds a NULL check, logs the teardown state, clears
the node pointers, and returns early.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index bfc2442dd74a5..7c487508916e3 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -118,6 +118,22 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>  		return;
> =20
>  	vport =3D ndlp->vport;
> +	if (!vport) {
> +		/*
> +		 * Vport is NULL - this can happen during teardown when the
> +		 * vport has been destroyed but the rport final delete is
> +		 * still processing. Clear the association and return.
> +		 */
> +		pr_err("lpfc: Null vport on ndlp %p, DID x%06x rport %p\n",
> +		       ndlp, ndlp->nlp_DID, rport);

[Severity: High]
This isn't a bug introduced by this patch, but if ndlp->vport is NULL, does
that indicate the ndlp object has already been freed?

Since vport is typically set during node allocation and never legitimately
cleared, wouldn't evaluating it as NULL mean we are dealing with freed
memory? If so, does dereferencing ndlp->nlp_DID here log from already-freed
memory, exacerbating the use-after-free race condition?

> +
> +		spin_lock_irqsave(&ndlp->lock, iflags);

[Severity: Low]
Are iflags and ndlp->lock defined in this context?

Looking at lpfc_dev_loss_tmo_callbk(), iflags does not appear to be
declared. Additionally, looking at struct lpfc_nodelist, it doesn't seem to
have a lock member. Could this cause a build failure?

> +		((struct lpfc_rport_data *)rport->dd_data)->pnode =3D NULL;
> +		ndlp->rport =3D NULL;
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +		return;

[Severity: High]
Does returning here leak the references for the ndlp and rport objects?

The existing teardown code lower in this function handles unloading like
this:

    if (vport->load_flag & FC_UNLOADING) {
        put_node =3D rdata->pnode !=3D NULL;
        ...
        rdata->pnode =3D NULL;
        ndlp->rport =3D NULL;
        if (put_node)
            lpfc_nlp_put(ndlp);
        ...
    }

By clearing the association pointers here without invoking
lpfc_nlp_put(ndlp) and put_device(&rport->dev), will we permanently leak
these references?

> +	}
> +
>  	phba  =3D vport->phba;
> =20
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629160557.5862=
08-1-vnagare@redhat.com?part=3D1
