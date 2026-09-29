Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769A547043
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641030; cv=none; b=UyCqdqNJFx1n6rZQUfAs3M+ag/FBgCSxLhT2N2zh83q8JmpHwHb8eEHNaDObkqxAZ98vuBISlri7ECgHrqFUaGToTPcQnaBDha+xiIfLzsSOnHFmB28niTWd3L4/amCLK0GKe46p3WltznfQIwVZJwK/DFeuSIiuYtBNx32a2PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641030; c=relaxed/simple;
	bh=qrLhN5pklJsWOafweQJNmpg2FCpualjKB5NOUytSKQA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f6OV8GinYrPyWjTo4lM+tQ98y0WTggrzaS42Lh/+z3HGhJdGEoDDmogcnxLcNs9wJO4DzouSlD9lD0KlbpZiotLTqt0nJhci1OcdAQgLvAAr+29+p6NZWcPgeWFJmY/0/tWIqHTjDUJIcTj5ryVra19+QnEIAxo1sdfSwdET4Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICBxwFGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICBxwFGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06031F00898;
	Tue, 29 Sep 2026 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790641026;
	bh=CgZg2s3/F96CWq8ZomGihEWQMP87Vpy3DHMnFOYZgDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ICBxwFGJ7cBu1JeDE+62IEq49Ymd6pbq5frm6TL/Duy2EivSd8YLE65Gr7RGP2kOn
	 gp6wcAzehNg68AQGWinRGT1ubCEUy3PYvAGwk9Vgki27Bo0S5zna8NWr2mrQfbwJST
	 5oxAZPZjFR3sqIrvOFrghw6+kTDXByEtUSsz3YMNYMIjoBL4Ivy6VRN4CnzQhJdoeP
	 9k64d9gHpBNTGlyLVEnGV9IVol6nShZX3LkONq9HFzRI2Tm+n6jJA9iXGozE/Uj/s6
	 rsqvVngFiCgQOnDbu06SoMmCFfqIstmy527ISW9uswXjd8bCEOH1pj3cdKTJjAchW6
	 g+ERyGObUG1Dg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/1] scsi: lpfc: defer SCSI rport node put until
 devloss callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dai Ngo" <dai.ngo@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260929000315.2298554-1-dai.ngo@oracle.com>
References: <20260929000315.2298554-1-dai.ngo@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 00:17:06 +0000
Message-Id: <20260929001706.A06031F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: lpfc: Use-After-Free of lpfc_nodelist via TOCTOU race during=
 rport registration
- [Medium] scsi: lpfc: Memory leak of lpfc_nodelist on early return in devl=
oss callback
--

commit bc42f7384fad41065be1c1a5d5448213573acefe
Author: Dai Ngo <dai.ngo@oracle.com>

scsi: lpfc: defer SCSI rport node put until devloss callback

This patch defers dropping the SCSI rport node reference from remote-port=20
unregister time to the devloss callback to prevent a use-after-free window.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4482,6 +4488,7 @@ static void
>  lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist=
 *ndlp)
>  {
>  	struct Scsi_Host *shost =3D lpfc_shost_from_vport(vport);
> +	struct fc_rport  *old_rport =3D ndlp->rport;
>  	struct fc_rport  *rport;
>  	struct lpfc_rport_data *rdata;
[ ... ]
> @@ -4517,7 +4524,10 @@ lpfc_register_remote_port(struct lpfc_vport *vport=
, struct lpfc_nodelist *ndlp)
>  	rport->maxframe_size =3D ndlp->nlp_maxframe;
>  	rport->supported_classes =3D ndlp->nlp_class_sup;
>  	rdata =3D rport->dd_data;
> -	rdata->pnode =3D lpfc_nlp_get(ndlp);
> +	if (rport =3D=3D old_rport)
> +		rdata->pnode =3D ndlp;
> +	else
> +		rdata->pnode =3D lpfc_nlp_get(ndlp);

[Severity: High]
Can this lead to a use-after-free via a time-of-check to time-of-use race if
the remote port's devloss timer expires concurrently?

If lpfc_register_remote_port() caches old_rport locklessly before calling
fc_remote_port_add(), and the devloss worker thread concurrently executes
lpfc_dev_loss_tmo_callbk(), the callback clears the SCSI_XPT_REGD flag and
successfully drops the original node reference via lpfc_nlp_put(ndlp).

When the registering thread resumes and finishes fc_remote_port_add(), if t=
he
transport reuses the same port structure, the check (rport =3D=3D old_rport)
evaluates to true. This would leave the node tracked without acquiring a new
reference, even though the original reference was already dropped by the
devloss callback.

[ ... ]
> @@ -4577,7 +4587,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *n=
dlp)
>  			 kref_read(&ndlp->kref));
> =20
>  	fc_remote_port_delete(rport);
> -	lpfc_nlp_put(ndlp);
>  }

[Severity: Medium]
Does removing this unconditional lpfc_nlp_put() introduce a memory leak if
lpfc_dev_loss_tmo_callbk() exits early?

If a remote port drops and reconnects, obtaining a different rport structure
from the transport layer, lpfc_register_remote_port() updates ndlp->rport
to the new pointer.

Later, when the devloss timer for the old rport expires,
lpfc_dev_loss_tmo_callbk() evaluates this condition:

	/* Ignore callback for a mismatched (stale) rport */
	if (ndlp->rport !=3D rport) {
		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
			      "6788 fc rport mismatch...");
		return;
	}

Since the pointer was updated, the condition evaluates to true and the func=
tion
returns early. Because lpfc_nlp_put(ndlp) was deferred to the end of the
devloss callback, it is completely bypassed here, permanently leaking the
lpfc_nodelist object.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929000315.2298=
554-1-dai.ngo@oracle.com?part=3D1
