Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBDC369208
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 15:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339209; cv=none; b=AQhczwUVGfpmRslZbqf5rJt+U6dVlAO5JiWDQddozWYFJPvApIjiyKVIy09IYLdXukHucRXVn58cxMDNRelcocBIbsCHKRT5XbSd01jv9+Sw5JdrCiS/YHiKvVltbgfrTZfdRCeWHqfsnWeElYpPtoOF+OtZ3uINW31aXZ7cFhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339209; c=relaxed/simple;
	bh=bVgtZvK0x3MZq6RII+W7FEpTdK+YO7Se13v3tktQpqU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=co/aslhLrj3u/Wl3Inq0h8sCz7zgtGx2s7n+UV/ELdSxDNWZASfKuxT6glMoSgZClNbTQk7ThAXzwFBP7PDl86d5A2b9RxtW1FXm8CjcK3cwH0jWKbV4tRFjmWkYNMUaJvCCZKXxXYKWzZDS+lRRLOtz1P2hw22Bssz4kG7Izss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTgPjTFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTgPjTFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53021F000E9;
	Wed, 29 Jul 2026 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785339206;
	bh=4scRXjJfDtC/+MYllU6FeaAehR932L9srJLFSBeTWOw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bTgPjTFq3E7SeKGOnttlbd34/x0w+oGEN6c5Dmc0UP4FtXNhjhLQee496Cq2u4lOC
	 +H1b/gi+UvK3GPQLmcxcZUbJyfmHiDyUgObEXl+EHNJK1uUYTGW8bQzYqnCnitZnVT
	 9GUtwu3yfTACwjcN9BDKyiLIQgt09oqTdzkyEEZUlvRjhhvokUCc2NtKYbadlqb1F8
	 6MlnCyHZ22RXQ8jEKTqPOCC3w8H8RyJaPw0rCKV+FUP9iLxH6z7gUtxgOTs3mFq36f
	 TXSC7nFHcn1xIMqfPLy3+Vkf7l+rGje6CDCCVuvij/Guoz187FZUFkMoPUIGc9awg0
	 ky00IFKwweC+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] scsi: lpfc: Clear rport association before
 unregistering it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dai Ngo" <dai.ngo@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729151836.568056-1-dai.ngo@oracle.com>
References: <20260729151836.568056-1-dai.ngo@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 15:33:25 +0000
Message-Id: <20260729153325.D53021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Unconditionally clearing `rdata->pnode` breaks the devloss timeout=
 state machine, leading to permanent `lpfc_nodelist` memory leaks for SCSI =
targets.

Pre-existing issues:
- [High] A TOCTOU race condition from lockless checks of `ndlp->rport` lead=
s to a NULL pointer dereference of `rport->dd_data` in `lpfc_unregister_rem=
ote_port()`.
- [High] The patch attempts to fix a Use-After-Free (UAF) by clearing `rdat=
a->pnode` under `ndlp->lock`, but leaves a TOCTOU race window because the r=
ead side in `lpfc_dev_loss_tmo_callbk()` is completely lockless.
--

--- Patch [1]: [PATCH 1/1] scsi: lpfc: Clear rport association before unreg=
istering it ---
commit 97fd261025f15460afb6d81b854ab25279c37bc0
Author: Dai Ngo <dai.ngo@oracle.com>

scsi: lpfc: Clear rport association before unregistering it

System crashed when a Fibre Channel cable is removed from an Emulex/Broadcom
lpfc HBA. This crash occurs after the lpfc Link Down event, after dm-multip=
ath
fails paths, and when the FC remote ports time out and are removed. This pa=
tch
clears rdata->pnode and ndlp->rport under ndlp->lock before calling
fc_remote_port_delete() to prevent stale rport-to-node references.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index c9b02d2c63054..a4e9a60ec162b 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
[ ... ]
> @@ -4576,6 +4578,14 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *=
ndlp)
>  			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags,
>  			 kref_read(&ndlp->kref));
> =20
> +	rdata =3D rport->dd_data;

[Severity: High]
This is a pre-existing issue, but won't this cause a NULL pointer dereferen=
ce
if rport is NULL?

Looking at lpfc_nlp_unreg_node() in drivers/scsi/lpfc/lpfc_hbadisc.c,
ndlp->rport is checked outside of ndlp->lock:

    if (ndlp->rport &&
        ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {

If a concurrent lpfc_dev_loss_tmo_callbk() acquires ndlp->lock and sets
ndlp->rport to NULL, lpfc_unregister_remote_port() will initialize its local
rport variable to NULL, leading to a crash here when dereferencing
rport->dd_data.

> +	spin_lock_irqsave(&ndlp->lock, iflags);
> +	if (rdata && rdata->pnode =3D=3D ndlp)
> +		rdata->pnode =3D NULL;

[Severity: High]
Does unconditionally clearing rdata->pnode here break the devloss timeout
state machine and cause a permanent node leak?

Before this patch, fc_remote_port_delete() starts the SCSI transport's
devloss timer, which eventually calls lpfc_dev_loss_tmo_callbk(). That call=
back
relies on rdata->pnode to locate the ndlp and queue an LPFC_EVT_DEV_LOSS ev=
ent,
which drops the initial node reference.

By setting rdata->pnode to NULL before deleting the rport, won't
lpfc_dev_loss_tmo_callbk() in drivers/scsi/lpfc/lpfc_hbadisc.c always see
a NULL pointer and return immediately:

    ndlp =3D ((struct lpfc_rport_data *)rport->dd_data)->pnode;
    if (!ndlp)
        return;

And thus never drop the initial reference, leaking the lpfc_nodelist memory?

[Severity: High]
This isn't a bug introduced by this patch, but does clearing rdata->pnode
under ndlp->lock actually prevent the use-after-free race in the devloss
callback?

The devloss callback in drivers/scsi/lpfc/lpfc_hbadisc.c reads the pointer
locklessly and doesn't take a reference:

    ndlp =3D ((struct lpfc_rport_data *)rport->dd_data)->pnode;

If lpfc_dev_loss_tmo_callbk() reads ndlp and then is preempted, a concurrent
lpfc_unregister_remote_port() could clear rdata->pnode and call
lpfc_nlp_put(ndlp), freeing the node. When the callback resumes, it would
access ndlp->vport and attempt to acquire ndlp->lock on a freed object.

> +	ndlp->rport =3D NULL;
> +	ndlp->fc4_xpt_flags &=3D ~SCSI_XPT_REGD;
> +	spin_unlock_irqrestore(&ndlp->lock, iflags);
> +
>  	fc_remote_port_delete(rport);
>  	lpfc_nlp_put(ndlp);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729151836.5680=
56-1-dai.ngo@oracle.com?part=3D1
