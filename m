Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F3B47C108
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 22:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790721938; cv=none; b=cqIS3JCy4oLd6yOfVoaIEhB4VI2GLcGXgL30qz1PJ/LdNn10toSCOb0iMjxVy+PL6voOrLCXdbNJox2vmkM/TxipD1QCx6W+u9mfHyraXm4fy0QprOh2WCdwNOEGHu1ySWpy+2yequmQuLq+Y4/bTCJAP8nY4UwQ8EtSRP7KINY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790721938; c=relaxed/simple;
	bh=EXtRvvO8W2i9sd1p35WT1eEzWCmXINWFChHwurDpncw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kinji5NjF1+qfRYJQQfFlBgMezzBk4nucdl6aQeqyy1AP1ypWRtgYSNZWHguYGqHYmnIde3hhrPdivf8mQIWzuUw4ahODngOo7lfuitxC+FVIz6JlYSU4/ky6jKUYQNy7XfOgvNX8ZMOiHrL/aIL/T5jDnciJq2ytiMAjsUrHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjwgxTOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjwgxTOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE771F000FF;
	Tue, 29 Sep 2026 22:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790721937;
	bh=kEMqnSP72XUn0bUYlYBpPq+cTTqURhxaTYj4zhns0Js=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OjwgxTOrQCHzalWbt47Ts6YINlMGBZX8tTJap7s8u46u91DdoOO+G6tqCndd1jugq
	 AlnBzL6FjtjLeq9MhGMkjS+4wO2KWo8APX87dMoX9VRlmV2xegiRlF3ME7IKYw/LWf
	 dmxrVcY933FODtfN9OmFI+SW9e1sQKVWH4QbcOGYDbO7IUEldl1a61iZiboi2gQ3ty
	 tx6kAz/t2pPWWpMRCrHdLlRoz9aNAzkf20oQuOY3MkR5uxbZZ/+HtukEke0r4aTciF
	 uPPaEY6C0pmAO+FibO+tu2JTtZdxuan4geFe24GdikTsylGltZGgLFR4XmmUsdG9dI
	 O/nbmNmbwom4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/1] scsi: lpfc: defer SCSI rport node put until
 devloss callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dai Ngo" <dai.ngo@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260929223133.2922017-1-dai.ngo@oracle.com>
References: <20260929223133.2922017-1-dai.ngo@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 22:45:36 +0000
Message-Id: <20260929224536.DAE771F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: lpfc: memory leak of old ndlp on rport reuse
- [Medium] scsi: lpfc: data races in lockless rport association handoff
--

commit 0e3550afaa0e5fec6d02f203dc40ee6302db8e5a
Author: Dai Ngo <dai.ngo@oracle.com>

scsi: lpfc: defer SCSI rport node put until devloss callback

This commit delays dropping the SCSI rport node reference until
lpfc_dev_loss_tmo_callbk() detaches the rport from the lpfc node. It
introduces an rport association generation number to verify the node,
generation, and rport before changing association state or dropping a
reference, closing use-after-free and rport-reuse races.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -187,6 +193,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>  	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
> =20
>  		spin_lock_irqsave(&ndlp->lock, iflags);
> +		if (rdata->pnode !=3D ndlp || rdata->generation !=3D rport_gen) {

[Severity: Medium]
Does this plain read race with writers updating rdata->pnode and
rdata->generation?

The commit message mentions using READ_ONCE() / WRITE_ONCE() for the
lockless pnode handoff. While READ_ONCE() is used initially in
lpfc_dev_loss_tmo_callbk(), this read inside old_ndlp->lock is a plain
read. Since a concurrent writer for a reused rport holds a different lock
(new_ndlp->lock), this plain read races with the writer.

[ ... ]

> @@ -223,14 +237,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
[ ... ]
> -	if (ndlp->nlp_state =3D=3D NLP_STE_MAPPED_NODE)
> -		return;
> -
>  	/* Ignore callback for a mismatched (stale) rport */
>  	if (ndlp->rport !=3D rport) {

[Severity: Medium]
Could this plain read cause reader threads to observe torn stores or
out-of-order writes?

This read of ndlp->rport occurs outside the lock and races with concurrent
writers updating it. Without proper WRITE_ONCE() / READ_ONCE() pairing,
compiler optimizations can break the intended semantics.

[ ... ]

> @@ -4517,19 +4609,27 @@ lpfc_register_remote_port(struct lpfc_vport *vpor=
t, struct lpfc_nodelist *ndlp)
[ ... ]
>  	spin_lock_irqsave(&ndlp->lock, flags);
> +	/*
> +	 * A reused rport normally retains its old association reference.
> +	 * However, devloss may have completed while fc_remote_port_add()
> +	 * was running, in which case it cleared SCSI_XPT_REGD and released
> +	 * that reference. In the former case, transfer the old reference to
> +	 * the new association and release the provisional new reference.
> +	 */
> +	if (rport =3D=3D old_rport &&
> +	    (ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
> +		drop_new_scsi_ref =3D true;
> +	rdata->pnode =3D pnode;

[Severity: High]
Does this code leak the old lpfc_nodelist on rport reuse?

When a device logs out and logs back in (e.g., with a different NPort ID),
the transport's fc_remote_port_add() matches by WWPN, unblocks the
existing rport, and cancels its dev_loss_work timer.

In lpfc_register_remote_port(), rport =3D=3D old_rport evaluates to false
because old_rport is new_ndlp->rport (usually NULL), so drop_new_scsi_ref
is false. Then rdata->pnode is overwritten with the new ndlp. The old ndlp
is permanently orphaned with SCSI_XPT_REGD set. Because its devloss timer
was cancelled and its association removed, the reference taken during its
registration is permanently leaked.

> +	rdata->generation =3D ++ndlp->rport_gen;
> +	ndlp->rport =3D rport;

[Severity: Medium]
Do these plain writes race with lockless readers?

As mentioned earlier, the commit message claims to use READ_ONCE() and
WRITE_ONCE() for the lockless pnode handoff, but plain writes are used
here for rdata->pnode, rdata->generation, and ndlp->rport.

>  	ndlp->fc4_xpt_flags |=3D SCSI_XPT_REGD;
>  	spin_unlock_irqrestore(&ndlp->lock, flags);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929223133.2922=
017-1-dai.ngo@oracle.com?part=3D1
