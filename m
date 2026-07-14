Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3787E2356C6
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990257; cv=none; b=Wf6hEYhSHZwgf1C9OS/HJqqppae4P0qCoWQyGFHI05aTsj8tKakPIkl/4KipCabgrBuUKmL0a240HPsa0jLxOj7jNSW+vjGOUdo+uT/8+L1bVHF/TkoMjnw/iowlGzSpKtsQBvvw31Iun7dHoOozNZ3ukME2xl9E/z3zW670yr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990257; c=relaxed/simple;
	bh=WwYrZ7Iv6siAocVU/31Vlov+KtwgcYZQj7kiSbaR+q0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V/LqiTqjdVGitXElLw4bfMkNC8fPqQJzjZEQx6FVj6tpVIo2CRx7H/waG/kVf2OkyCqxKUfq58cVTmLz/jecQmi47ymGnHk/d2kPEVVegZMps1kSgW4Ny4CMo1LjJwUzHa8Jq4WYuWnYKE+6De4/Px7MS9/vwTLrKoegixfnIe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nz8ePWGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nz8ePWGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EE61F000E9;
	Tue, 14 Jul 2026 00:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990255;
	bh=KwRsQRvAhrg/nGw5pbcQonHCPdFs92LpLdjiZOHU5gQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nz8ePWGHNbY6ezuXaoHxqjVUnPptz5W1NuphmgIwrTMB68Lfo6pU+bYVOH8bINb0g
	 GZ+if1bzazMrTW3n/u2ui3lATXa6Jc030xed4QHvDk1F+Sk7V5a32TfWlra6QMmXWE
	 bN/m9SVG82erGJD0sjXX9YEQNUSZp4Nf6oBFPKiV0lq6DJl0iHNtVNBHCRXNVrEyJd
	 nPuJpQdFDRNzcgQz8kDA1VvJOcpzS2oHWWskHobNQAFuFtsm1OsMuDz2Yd9MeBeGiK
	 pIjrn5bmP+vdgD3VL6WzBwlrXsPJtQC5YfdowLixf9x5UKU+N2mpKO4EQsDoFrp0Y5
	 S1CQqFLl50AEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/14] lpfc: Fix ndlp use-after-free during repeated
 RSCN and rediscovery sequence
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-7-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-7-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:50:55 +0000
Message-Id: <20260714005055.A6EE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Race condition between `lpfc_unregister_remote_port` and `lpfc_dev=
_loss_tmo_callbk` leading to double-put and Use-After-Free.
- [High] Unbounded reference count leak for NVMe Target (NVMET) nodes durin=
g repeated RSCN rediscovery.
- [Medium] Lockless check in `lpfc_nlp_unreg_node` introduces a TOCTOU race=
 leading to double unregistration.
--

--- Patch [6]: [PATCH v3 06/14] lpfc: Fix ndlp use-after-free during repeat=
ed RSCN and rediscovery sequence ---
commit a4e515a68e8dcd0a05052708ad0dbafb1627b3e9
Author: Justin Tee <justintee8345@gmail.com>
Subject: lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery=
 sequence

This commit refactors lpfc_fc4_xpt_flags to use separate flags for SCSI
and NVME registrations. It adds wait flags to track unregister requests
during device loss and transport callbacks.

[ ... ]
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
[ ... ]
> @@ -4562,6 +4556,7 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *n=
dlp)
>  {
>  	struct fc_rport *rport =3D ndlp->rport;
>  	struct lpfc_vport *vport =3D ndlp->vport;
> +	unsigned long flags;
> =20
>  	if (vport->cfg_enable_fc4_type =3D=3D LPFC_ENABLE_NVME)
>  		return;
> @@ -4577,6 +4572,11 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *=
ndlp)
>  			 kref_read(&ndlp->kref));
> =20
>  	fc_remote_port_delete(rport);
> +
> +	/* Flag unreg pending and reference released */
> +	spin_lock_irqsave(&ndlp->lock, flags);
> +	ndlp->fc4_xpt_flags |=3D SCSI_XPT_UNREG_WAIT;
> +	spin_unlock_irqrestore(&ndlp->lock, flags);
>  	lpfc_nlp_put(ndlp);
>  }

[Severity: High]
Can this sequence cause a double-put of the ndlp structure if the transport
callback races with this function?

Because SCSI_XPT_UNREG_WAIT is set after fc_remote_port_delete() is called,
the queued dev_loss_work task can execute asynchronously before the lock is
acquired here to set the wait flag.

If the transport callback wins the race, lpfc_dev_loss_tmo_callbk() will re=
ad
!(ndlp->fc4_xpt_flags & SCSI_XPT_UNREG_WAIT) as true, clear SCSI_XPT_REGD,
and call lpfc_nlp_put(). When lpfc_unregister_remote_port() resumes, it sets
the wait flag and unconditionally calls lpfc_nlp_put() again, which could
trigger a use-after-free.

[ ... ]
> @@ -4623,7 +4623,9 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct =
lpfc_nodelist *ndlp)
>  	lpfc_check_nlp_post_devloss(vport, ndlp);
> =20
>  	spin_lock_irqsave(&ndlp->lock, iflags);
> -	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
> +	if ((ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
> +	    !(ndlp->fc4_xpt_flags & (SCSI_XPT_UNREG_WAIT |
> +				     NVME_XPT_UNREG_WAIT))) {
>  		/* Already registered with backend, trigger rescan */
>  		spin_unlock_irqrestore(&ndlp->lock, iflags);

[Severity: High]
Does this code leak an ndlp reference for NVMe targets during repeated RSCN
rediscovery events?

In an NVMe target setup (nvmet_support !=3D 0), neither SCSI_XPT_REGD nor
NVME_XPT_REGD is ever set. Instead, the code falls through to the target
handling block at the end of lpfc_nlp_reg_node():

        } else {
                /* Just take an NDLP ref count since the
                 * target does not register rports.
                 */
                lpfc_nlp_get(ndlp);
        }

Without a registration flag set, every subsequent call to lpfc_nlp_reg_node=
()
during repeated RSCNs will bypass this early return check, falling through =
to
execute lpfc_nlp_get() again and permanently leaking a reference each time.

[ ... ]
> @@ -4678,7 +4675,7 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struc=
t lpfc_nodelist *ndlp)
>  	unsigned long iflags;
> =20
>  	spin_lock_irqsave(&ndlp->lock, iflags);
> -	if (!(ndlp->fc4_xpt_flags & NLP_XPT_REGD)) {
> +	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
>  		spin_unlock_irqrestore(&ndlp->lock, iflags);
[ ... ]
>  	}
> -
> -	ndlp->fc4_xpt_flags &=3D ~NLP_XPT_REGD;
>  	spin_unlock_irqrestore(&ndlp->lock, iflags);
> =20
>  	if (ndlp->rport &&
> -	    ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
> +	    ((ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | SCSI_XPT_UNREG_WAIT)) =3D=
=3D
> +	     SCSI_XPT_REGD)) {
>  		vport->phba->nport_event_cnt++;
>  		lpfc_unregister_remote_port(ndlp);

[Severity: Medium]
Could this lockless check introduce a time-of-check to time-of-use race?

The original code cleared NLP_XPT_REGD inside the ndlp->lock critical
section. By replacing it with a lockless check of the flag combination outs=
ide
the lock, two concurrent threads entering lpfc_nlp_unreg_node() could both
read the state as SCSI_XPT_REGD without SCSI_XPT_UNREG_WAIT.

If that happens, both threads would proceed to call
lpfc_unregister_remote_port(ndlp), leading to a double unregistration and
potential double-put of the ndlp structure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D6
