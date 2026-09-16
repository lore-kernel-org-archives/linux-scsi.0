Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3514DD3D7
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601595; cv=none; b=jDDcydl56JJFZUCc7XGq0j58Q4iWtSJFjS3Z8u+z463R232xCVuhhkh5zahOoquaefHTicH3ASgrqBBN8cREZs0APCSqSuBRowsEYfTrJumXTZ8do9pbKYvjEkdnehQyrlSvyo78nsPlGBH31Y0jcqQOgGEOx/q5FHL/AHa/CN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601595; c=relaxed/simple;
	bh=fmhmGVsrqUNbIKtTE+PtBD4uwPgRtBnYeQ2OD+YTl6Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s5o+vqsegrAKjdx10blj4bZxtdImPYBhsdoGJNLg/1O4CEzaeTUnmxAIm/daiV8g6Er1NTM4S/z/gcEFCDbgEQfgV3QHHArCc9ODjgwfpAXqSsl8dIKFD22xJe4T0TicFopln2GBCU7MrkbXuijHrOrPT3CA/nqw6t8kiktVREU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEXgtgXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEXgtgXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50B41F000FF;
	Wed, 16 Sep 2026 23:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601594;
	bh=k3NCozxAizkPe39ZMjANnsB00EU5l+uU0vYZW1cRkAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SEXgtgXdi5FWby+cCE7wd7M4FAdOu5IoH4QJAUVLEgbhg0tolDqGCaNTELn3vxjvP
	 PKzCME3BE8XaDagUI8y0TlDh2eR4EqxaE6H8XUUeGVKw33OPr8fIMpRVTK0L0dd9fd
	 GU2tfgwL7dAZFDy1MRd0UwwYh3zCPf+2tl/nlutlPZ9gWpitx3bJrBScYbuNew67L0
	 Myd4BeGbFgcMgoZCqnx5KDMUqkV0NxiLjn5YAwR/UmPqwU3RnpJRTVDyEJV2aRQg46
	 97TxBeHl6yfxjb96kmhAEX9OHIeyCvo9XziBAJ1oUZ3qHkA9zJIw2Ess6bp0679+1i
	 X1X3MYldGv3xw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/20] scsi: ibmvfc: fix UAF and stall in NVMe LS abort
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-15-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-15-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:33:12 +0000
Message-Id: <20260916233313.E50B41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: ABA vulnerability in ls_abort due to lockless reallo=
cation
- [Medium] scsi: ibmvfc: target kref leak on H_CLOSED during abort
--

commit 2b161f932735b7864868d34990303d50d9aa8f72
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix UAF and stall in NVMe LS abort callback

This commit attempts to fix a use-after-free and a blocking stall in
ibmvfc_nvme_ls_abort() by introducing a dedicated async completion callback
and taking the host_lock around the event lookup. It also removes the
blocking wait_for_completion() call on the timeout workqueue.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 52e2621a43424..7e18b79ae4ccc 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c

[ ... ]

> @@ -202,34 +203,35 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_loc=
al_port *lport,
>  {
>  	struct ibmvfc_host *vhost =3D lport->private;
>  	struct ibmvfc_target *tgt =3D rport->private;
> -	struct ibmvfc_event *evt;
> -	union ibmvfc_iu rsp;
> +	struct ibmvfc_event *evt, *abt_evt;
>  	unsigned long flags;
> -	u16 status =3D IBMVFC_MAD_CRQ_ERROR;
> +
> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
> +
> +	/*
> +	 * If the original LS has already completed naturally, abt_evt will
> +	 * have been freed back to the pool (evt->free set to 1 under
> +	 * host_lock by ibmvfc_free_event()).  Nothing left to cancel.
> +	 */
> +	abt_evt =3D ls_abort->private;
> +	if (!abt_evt || atomic_read(&abt_evt->free)) {

[Severity: High]
Is this check vulnerable to an ABA problem?

If the original command completes and frees the event, evt->free is set to =
1.
If a new command immediately reallocates it, evt->free is set to 0. This
reallocation happens under queue->l_lock, not host_lock.

When this code acquires host_lock and checks atomic_read(&abt_evt->free), it
will read 0 and assume it is still the original command. Could this result
in aborting the new command instead, or dereferencing a stale target pointer
in ibmvfc_init_ls_abort()?

> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		return;
> +	}
> =20
>  	evt =3D ibmvfc_get_event(&vhost->crq);
> -	if (!vhost->logged_in || !evt)
> +	if (!vhost->logged_in || !evt) {
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>  		return;
> +	}
> =20
> -	spin_lock_irqsave(&vhost->host->host_lock, flags);
>  	kref_get(&tgt->kref);
> -	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
> -	ibmvfc_init_ls_abort(evt, ls_abort);
> -	evt->sync_iu =3D &rsp;
> -
> -	if (ibmvfc_send_event(evt, vhost, default_timeout))
> -		goto out;
> -
> -	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +	ibmvfc_init_event(evt, ibmvfc_nvme_ls_abort_done, IBMVFC_MAD_FORMAT);
> +	ibmvfc_init_ls_abort(evt, abt_evt);
> +	evt->tgt =3D tgt;
> =20
> -	wait_for_completion(&evt->comp);
> -	status =3D be16_to_cpu(rsp.mad_common.status);
> -	spin_lock_irqsave(&vhost->host->host_lock, flags);
> -	ibmvfc_free_event(evt);
> -out:
> +	ibmvfc_send_event(evt, vhost, default_timeout);

[Severity: Medium]
Does ignoring the return value of ibmvfc_send_event() leak the target kref?

We call kref_get(&tgt->kref) before this point and delegate the kref_put()
to the completion callback. However, if ibmvfc_send_event() returns
SCSI_MLQUEUE_HOST_BUSY (which happens when rc =3D=3D H_CLOSED), it frees the
event internally without executing the callback.

Will this cause the target structure memory to be leaked?

> +	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> -	ibmvfc_dbg(vhost, "ls_abort: cancel failed with rc=3D%x\n", status);
> -	kref_put(&tgt->kref, ibmvfc_release_tgt);
>  }
> =20
>  static void ibmvfc_nvme_done(struct ibmvfc_event *evt)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D14
