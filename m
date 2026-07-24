Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3F2429014
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917612; cv=none; b=WYFkwuv0srbl02vTyxMPxJ5w/BD+AKps+Wkh0dBNlQww3pDkTb9vSHcp/93et+jH/LrunXa5p7ANTWG5RN8IOBdkPTWbzO3l21IyYCxt4gN61O4RmUe56oPMewxI+wCabxXFIUrb7ZOTPd/tj8P8X7PPMXc9aAEClAlPMbRVYmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917612; c=relaxed/simple;
	bh=4J4Ruy08KabeJKeI7rj4wUkfMqQ82mDvZWUp2//YL2Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c9byosAIS0Unct9EhLMXbk764Lp95HPh8scxW/FrKbK+63Z4KqVQXsWkXqpMy50ur8Keqyni7U2qBR77u/7eK+3O5mXHcNYiwOh/3OgT2OccbCrV5y8IIfzw5Baa3sZg7T9SYlUoOJDpvJTKb5XDRL+r48csLjcfZNKU9BwlH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dav591rm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dav591rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F641F000E9;
	Fri, 24 Jul 2026 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917608;
	bh=F1qCCxcDqcaR1cX+gc/2vFW8xRmTLbn1PIaSZaEnR28=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dav591rmDZtZpV4467EBq3yC6ZcZ4lQrj9Za3dU604tPLLJ8HxjTb1QdPTP0S60C2
	 h0gFZToqOW5BO6K8WdjVNOC2Lgw+hB8ZSaMWUw0mxVHHjHsOBzDbjCBhZAcr8Pv4yf
	 vzATuTBVJHu7+jxhaVmZyiuFZHZy0R/yzwYsJZxvNKftlE0AdIZpM69m9jNVh8GLih
	 9NMU5r8iH6FepOCXfDmI0CWX8mpLkPWAbnXtMjThPWvmkttaxEV8vjlQESXdzTOtWg
	 eBUKGXebKucqir3Z+DScyAHkxm7TIeudUR7Jm/zqxppMcj5TCyjx6/528SuU6seHoa
	 +J0MxViImt6UQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-11-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-11-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:26:47 +0000
Message-Id: <20260724182648.61F641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Use-after-free of `tport` in `nvfnic_ls_req_abort` due to concurre=
nt target port deletion.
- [High] Immediate reuse of an Exchange ID (OXID) on ABTS timeout risks cro=
ss-talk with delayed target responses.
--

--- Patch [10]: [PATCH v6 10/13] scsi: fnic: Abort timed-out NVMe LS reques=
ts ---
commit 39245a565a721e78c479fc226cff0b04ea8531d0
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Abort timed-out NVMe LS requests

Add an FDLS helper that sends ABTS frames for outstanding NVMe LS
requests.

Use the active LS request OXID when building the ABTS frame, send it
through the FCoE transmit path, and call it from LS timeout and abort
handling.

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 0b05dc9698be2..aa3c935d08155 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> @@ -1279,6 +1283,23 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
>  	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
>  }
> =20
> +static bool nvfnic_ls_req_cleanup(struct fnic_iport_s *iport,
> +				  struct nvmefc_ls_req *lsreq,
> +				  uint16_t oxid)
> +{
> +	struct nvfnic_ls_req *nvfnic_ls_req =3D lsreq->private;
> +
> +	if (!nvfnic_ls_req)
> +		return false;
> +
> +	lsreq->private =3D NULL;
> +	list_del(&nvfnic_ls_req->list);
> +	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);

[Severity: High]
Is it safe to immediately reuse the OXID on an ABTS timeout, or should it
be quarantined for 2 * R_A_TOV?

When an NVMe LS request's ABTS frame times out, nvfnic_ls_req_timeout()
calls nvfnic_ls_req_cleanup(), which unconditionally calls fdls_free_oxid()
and returns the OXID to the active free pool.

According to Fibre Channel specifications, if an abort times out, the OXID
must be quarantined for 2 * R_A_TOV because a slow target might still send
a delayed response to the original aborted exchange.

If the OXID is reused immediately for a new request to the same target,
could the delayed response be incorrectly matched to the new request,
causing logic errors and potential data corruption?

> +	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_COMPLETE;
> +
> +	return true;
> +}
> +

[ ... ]

> @@ -1648,10 +1675,24 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_por=
t *lport,
> =20
>  	/* Mark the state and flags */
>  	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_ABTS_PENDING;
> -	timeout =3D FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
> -	mod_timer(&nvfnic_ls_req->ls_req_timer,
> -		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
> +	oxid =3D nvfnic_ls_req->oxid;
> +
> +	ret =3D fdls_send_ls_req_abts(iport, tport, oxid);

[Severity: High]
Can this result in a use-after-free of tport if nvfnic_delete_tport() is
invoked concurrently?

If nvfnic_delete_tport() is invoked twice for the same target port (e.g.
concurrently from the port event handler and the unload/cleanup path), the
second call to nvme_fc_unregister_remoteport() will return -EINVAL since
it is already marked for deletion.

The error path in nvfnic_delete_tport() then calls
nvfnic_terminate_tport_ls_reqs(), which explicitly skips requests in the
FNIC_LS_REQ_CMD_ABTS_STARTED state, and immediately calls kfree(tport).

Concurrently, nvfnic_ls_req_abort() may be in timer_delete_sync() with the
lock dropped and the request in the ABTS_STARTED state. When
nvfnic_ls_req_abort() wakes up and reacquires the lock, it checks
lsreq->private (which was left intact by the cleanup path) and calls
fdls_send_ls_req_abts(iport, tport, oxid). This dereferences the tport that
was just freed.

> +	if (!ret) {
> +		timeout =3D FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
> +		mod_timer(&nvfnic_ls_req->ls_req_timer,
> +			  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +		return;
> +	}
> +
> +	if (!nvfnic_ls_req_cleanup(iport, lsreq, oxid)) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +		return;
> +	}
> +
>  	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +	lsreq->done(lsreq, -EAGAIN);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D10
