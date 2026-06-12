Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC5535F199
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781305075; cv=none; b=qHAblH9pI5C3PZZ22zsPrdgL/U/SLo1Etkl4K+Uv9Thlfu8Bgiz/PqF0GI5/9UqIODtxnmNs8toXSslj6nkUJx47Hoe6p2qOQ0XBgN6ncVTJls7LOW6WeMigRCCvxc8P0U62xR9oh0lSXjTI3+Zccl2wJ1CrE8Kbvu8c9A9e8dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781305075; c=relaxed/simple;
	bh=z/skgqawrwAKv7N37XeJpKpKqCk0JQ1RpK92H4/52SI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SErUlYh7K5JXp6TNOVRhIb1IRrEeJ47jCxkSw3dtzhefI6rTdkCmA0T3TdkvPymR0/VsV1pkqH5qQ3VbxjoYLZyS0pznWcy2g4O2a9y2RJdh8HZZBbrJ+4S3kGchAPVtxQqGL/RsoT4IXAr0cFw+OEfvCA+P74XMdPvE3Qk+ANA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1hLZ9bW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1hLZ9bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3524B1F000E9;
	Fri, 12 Jun 2026 22:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781305074;
	bh=LXYW19VWxjFjeCrF2NOVTGpgRQA9e3bvFdQVtgOhjAQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X1hLZ9bWt2VSCKUXiWgJ111UrdyMOQC2hAN+Cj1Ji5src7IJku1Y8ufqo0HDBA+St
	 yBJh39eMhmuymzkukLwSmEaGA2cHf2T1xqwpGr+ggvxmj+o/R3rjVr9ymBMvRp0Yv4
	 6Ik1PZ5oTSU20b0QPqAy6cB81w8/7VO6uM8R3IXE6x4GE6o+Mq6YLojje8749/p1zg
	 JsVxCUgxt2QGPcGGVC8lVP9bKI8F54C/g2kcnPFpHd+bDJxz8CLSJb29XLWWmlLl9y
	 qaixnlpthAZmYOhG1Zce+/56riVj2VrgZwSe/8rjISluftaE1Mq4AnLYUVIq4pVJ5v
	 4ipFLaztajilw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-11-kartilak@cisco.com>
References: <20260612180918.8554-11-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 22:57:53 +0000
Message-Id: <20260612225754.3524B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] Dropping fnic_lock before network transmission and accessing t=
he NVMe LS request on failure leads to Use-After-Free and double completion=
s.

Pre-existing issues:
- [High] Calling timer_delete_sync() while holding fnic->fnic_lock causes a=
n ABBA deadlock with the timer callback.
- [High] Dropping a spinlock inside list_for_each_entry_safe invalidates th=
e 'next' pointer.
- [High] Saving spin_lock_irqsave interrupt state into a shared struct memb=
er corrupts interrupt state.
--

commit af4855e82320c32dd587460223ab9977658df024
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Abort timed-out NVMe LS requests

Add an FDLS helper that sends ABTS frames for outstanding NVMe LS
requests. Use the active LS request OXID when building the ABTS frame,
send it through the FCoE transmit path, and call it from LS timeout
and abort handling.

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 014660725373b..9cc8f0baf09cb 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c

[ ... ]

> @@ -1232,6 +1236,23 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
>  	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
>  }

[Severity: High]
This is a pre-existing issue, but does calling timer_delete_sync while
holding fnic->fnic_lock in nvfnic_ls_rsp_recv cause an ABBA deadlock?

If the timer callback unconditionally requests fnic_lock, waiting for the
timer to complete while holding the lock will deadlock:

nvfnic_ls_rsp_recv()
    spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
    ...
    timer_delete_sync(&nvfnic_ls_req->ls_req_timer);

[ ... ]

> @@ -1274,6 +1294,19 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
>  		FNIC_NVME_DBG(KERN_ERR, fnic,
>  			      "tport: 0x%x lsreq: 0x%x sending abort\n",
>  			      tport->fcid, nvfnic_ls_req->oxid);
> +		nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_ABTS_PENDING;
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +
> +		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) =3D=3D 0)=
 {
> +			timeout =3D FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
> +			mod_timer(&nvfnic_ls_req->ls_req_timer,
> +				  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
> +			return;
> +		}
> +		FNIC_NVME_DBG(KERN_ERR, fnic,
> +			      "tport: 0x%x lsreq: 0x%x cannot send abort\n",
> +			      tport->fcid, oxid);
> +		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);

[Severity: High]
This is a pre-existing issue, but does saving the interrupt state into the
shared fnic->lock_flags struct member risk corrupting CPU IRQ states
during spinlock contention?

Using a global variable for IRQ state instead of a local stack variable
can lead to corruption when the lock is contended.

[ ... ]

> @@ -1579,10 +1607,25 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_por=
t *lport,
> =20
>  	/* Mark the state and flags */
>  	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_ABTS_PENDING;
> +	oxid =3D nvfnic_ls_req->oxid;
>  	timeout =3D FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
>  	mod_timer(&nvfnic_ls_req->ls_req_timer,
>  		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
>  	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +
> +	ret =3D fdls_send_ls_req_abts(iport, tport, oxid);
> +	if (!ret)
> +		return;
> +
> +	timer_delete_sync(&nvfnic_ls_req->ls_req_timer);

[Severity: Critical]
Can dropping fnic_lock before network transmission and then accessing
nvfnic_ls_req after transmission failure lead to a use-after-free and
double completions?

Since memory ownership is transferred to the timer when mod_timer is
called, the timer could fire while the lock is dropped. This could free
nvfnic_ls_req before we reach timer_delete_sync.

[ ... ]

[Severity: High]
This is a pre-existing issue, but does dropping the spinlock inside
list_for_each_entry_safe invalidate the next pointer?

In drivers/scsi/fnic/fnic_nvme.c:nvfnic_cleanup_tport_io():

list_for_each_entry_safe(nvfnic_ls_req, next, &(tport->ls_req_list), list)

If fnic_lock is dropped inside this loop, concurrent modifications to the
list can invalidate the next pointer, leading to a use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D10
