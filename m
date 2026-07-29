Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CBD369D57
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 21:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785360341; cv=none; b=frG5biGNfFdC4RDarPP2QQ8ujpvHzvPxzmBhjaXwGFz2QmiEwZKca00Nxs4pYEr+TJS8AgJlTMQ+rDmgFczuZkiLYgDLDhggC/k6gmkHixY6W+zH2/VD3Fi5tsgY5K5hE6C4nTNzZhtRv0y09RaZ2qfd0C+gVuNk69eBI7xnkpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785360341; c=relaxed/simple;
	bh=QdNdgb7yRcVs2TfC4a8PudI9v6p3j87srmbANu37r3I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QDkGDmCuQ/NSaIT9SxYylem+zfk380OPWVjvwSQoW/edJePRuIdC+jV7G/f2fY88qORxSRHDMtBMrr1Uh94TvyTaMINLY7QNlKZa0lXxH71CUDE1EzZA4qeeAFnAuXn6reqPum5BRdi/GjFQjRMLyXojcVn7D/zz9BWKkmxP1GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euzxOYpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euzxOYpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0C01F00A3E;
	Wed, 29 Jul 2026 21:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785360339;
	bh=GHy47VX+HAhQU23nlrM/zAhmBh8m4VaT2901jx35LXM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=euzxOYpvDevBQA9scfZE2kV6tT7tYFJgD7lyuO65VbpWeCww4L0b+9Uoh3MaySNBl
	 XzjSm20Lxx8951tDt1lLJm3cgggawTtwnxWvuHEO/9NWG5aXkfgA/8uol47VL+OkPI
	 OBDuT6M3ZJfL170fCXR6or9DmVPvDiAZsS1YkPsWh5LYoA+d2XD2JYXvYKpVOzK3kn
	 S8ZxGF2fbAzyMJZUV8k377Vi2T9+r0MypMy/x8pB+4FggBKbhpS1hOD545BoEB88N8
	 8y8hVep1p7PbJP09jedOCCzxVMV1zQAA6TNq3U4vCApatFBfmzdGbYHAcnVZB6i/vR
	 KDGbDaQiBiqGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/1] scsi: lpfc: Clear rport node association before
 unregister
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dai Ngo" <dai.ngo@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729210413.700187-1-dai.ngo@oracle.com>
References: <20260729210413.700187-1-dai.ngo@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 21:25:39 +0000
Message-Id: <20260729212539.8A0C01F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch introduces a memory leak of `struct lpfc_nodelist` objec=
ts by short-circuiting the driver's normal devloss teardown mechanism.
--

--- Patch [1]: [PATCH v2 1/1] scsi: lpfc: Clear rport node association befo=
re unregister ---
commit b2533138432d8556bb87be05d21267317ff588d6
Author: Dai Ngo <dai.ngo@oracle.com>

scsi: lpfc: Clear rport node association before unregister

This patch detaches the lpfc node from the rport before calling
fc_remote_port_delete() and before dropping the transport-held ndlp referen=
ce.
It clears rdata->pnode and ndlp->rport under ndlp->lock in the unregister p=
ath,
and updates the devloss callback to tolerate a NULL rport or pnode.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index c9b02d2c63054..b737f976a789e 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -157,13 +157,21 @@ void
>  lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>  {
>  	struct lpfc_nodelist *ndlp;
> +	struct lpfc_rport_data *rdata;
[ ... ]
> -	ndlp =3D ((struct lpfc_rport_data *)rport->dd_data)->pnode;
> +	if (!rport)
> +		return;
> +
> +	rdata =3D rport->dd_data;
> +	if (!rdata)
> +		return;
> +
> +	ndlp =3D READ_ONCE(rdata->pnode);
>  	if (!ndlp)
>  		return;

[Severity: High]
Does this early return lead to a leak of the struct lpfc_nodelist object?

If lpfc_unregister_remote_port() has already cleared rdata->pnode before the
devloss timer starts, this callback reads the cleared pnode, sees NULL, and
returns immediately without queueing the LPFC_EVT_DEV_LOSS event.

Because the event is never queued, the discovery state machine is never
notified via NLP_EVT_DEVICE_RM, and the initial node reference is never
dropped.

[ ... ]
> @@ -4560,8 +4569,10 @@ lpfc_register_remote_port(struct lpfc_vport *vport=
, struct lpfc_nodelist *ndlp)
>  static void
>  lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
>  {
[ ... ]
> +	spin_lock_irqsave(&ndlp->lock, iflags);
> +	rport =3D ndlp->rport;
> +	if (!rport) {
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +		return;
> +	}
> +	rdata =3D rport->dd_data;
> +	if (rdata && READ_ONCE(rdata->pnode) =3D=3D ndlp)
> +		WRITE_ONCE(rdata->pnode, NULL);

[Severity: High]
Does this prematurely disconnect the node from the rport?

If an FC cable is pulled or a target LOGO is received, the node is
unregistered and moved to the NLP_STE_NPR_NODE state. Unconditionally clear=
ing
rdata->pnode here appears to short-circuit the normal devloss teardown
mechanism by causing the early return in lpfc_dev_loss_tmo_callbk() mention=
ed
above.

> +	ndlp->rport =3D NULL;
> +	ndlp->fc4_xpt_flags &=3D ~SCSI_XPT_REGD;
> +	spin_unlock_irqrestore(&ndlp->lock, iflags);
> +
>  	fc_remote_port_delete(rport);
>  	lpfc_nlp_put(ndlp);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729210413.7001=
87-1-dai.ngo@oracle.com?part=3D1
