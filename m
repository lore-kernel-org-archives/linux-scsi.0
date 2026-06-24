Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97123257844
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277909; cv=none; b=Pq4YV8lmhxjPn/V2SXiiHe6uf6BZ5cvBDWAnkFbgQziqhHcQ030y+w+VpdawQDQNZc5gtPDqJ14+9KaAmMcuqAo0GvL9LRUFNuA2Va1KOg+/phCbVekN6wE03Hj4qH+CsPDfdSLqcqOgSfNcmcqoiCykZnVmC8811FWAkxsuGhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277909; c=relaxed/simple;
	bh=OzBlYOziI9Zg9RNWIZDI9CFgU9wKrN/htWTGhraUHb0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e97qAWf0/RCh8ls3AsGPHclCA/IS+hrtBHTO0hmHV2+laOhoEms1nyhtFtgANVQZkcamejo4LG8axugfSfn2QjIOjNCt22sMZsVN816Y4b/66gfol7AqeE13WF00H7B4MjC6g345Lhx8OkiMhtPCqLPz2yUuXeSkQwF2+4oWbfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKvjKxNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKvjKxNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333941F000E9;
	Wed, 24 Jun 2026 05:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277908;
	bh=nrIji6lGrOnukXVJQ1sjE5ABB2wMpezWiFqsGDwaPcA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QKvjKxNqkQaGPov3lYUadRHkBkUkMphdafBKgH405SKhMq3uiLFeCh2Z9r/lf0qXr
	 9ltgEIglPt+sPUtXMFJl4EckN/wlB1wZGHS927lrti81nHTZZ6LTBwcnWvLQYk2wp4
	 jZ3wFeJT6ikT9/BfRWZkVUtU5RWeTSCoQ+DNcPNqJevkXON8ZIFQfV+aAHGrqKX1fr
	 DCX900FuXH2yMJJRfbFXT6qdNigLDw2XQ94Imk3a7HfGhVTQkp4RkgYBzQPqJfCwxA
	 Dr/eKa1f20k420IQv6kN459WmePDxJUXHi5A1ZueWz0gVm5k46cCMWc8lOK5n1vYil
	 cPf7ANSqhgJqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-10-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-10-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:11:47 +0000
Message-Id: <20260624051148.333941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] A race condition between NVMe-FC LS request submission and abo=
rt paths allows mod_timer to be called on an uninitialized timer.

Pre-existing issues:
- [Critical] Using the shared struct member fnic->lock_flags for spin_lock_=
irqsave leads to IRQ flag corruption.
- [High] Missing synchronous timer cancellation in LS response processing l=
eads to UAF in timer callback.
- [High] Dereferencing lsreq->private after dropping lock in nvfnic_ls_req_=
abort() causes UAF.
--

commit 6b90bcf4cce6c8a0c7e6c0e98d68dca9d9d15359
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Send NVMe LS requests through FDLS

This commit adds the FC frame wrapper for NVMe LS requests and builds LS
request frames from the NVMe-FC transport callback. It allocates OXIDs,
tracks outstanding LS requests on the target port, arms request timers,
and registers the LS request callback in the NVMe FC port template.

Closes: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@int=
el.com/

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 8374464e4fcc8..16e2f0add5ce6 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> @@ -1306,6 +1306,129 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
>  	ls_req->done(ls_req, -ETIMEDOUT);
>  }

[Severity: Critical]
This is a pre-existing issue, but does nvfnic_ls_req_timeout() use the
shared struct member fnic->lock_flags for spin_lock_irqsave()?

If spin_lock_irqsave() saves the local IRQ state into a shared variable,
and multiple CPUs attempt to acquire the lock concurrently, won't they
overwrite fnic->lock_flags with their own IRQ state?

When releasing the lock, a CPU would restore the IRQ state written by
another CPU instead of its own, potentially leading to permanent IRQ
disablement and hard lockups.

[Severity: High]
This isn't a bug introduced by this patch, but is it possible for a
timeout and an LS response to race and cause a use-after-free here?

If a concurrent completion path like nvfnic_ls_rsp_recv() completes an
LS request using timer_delete() (which is not synchronous) and then calls
lsreq->done(), the NVMe FC transport will free the lsreq memory.

If nvfnic_ls_req_timeout() is executing concurrently on another CPU, won't
it acquire the lock and dereference the already freed lsreq memory?

> +
> +/**
> + * nvfnic_ls_req_send - Send NVMe FC link service (LS) request

[ ... ]

> +	if (fdls_alloc_oxid(iport, FNIC_FRAME_TYPE_NVME_LS,
> +			&nvfnic_ls_req->oxid) =3D=3D FNIC_UNASSIGNED_OXID) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic,
> +		     "0x%x: Failed to allocate OXID to send NVME LS REQ",
> +			 iport->fcid);
> +		mempool_free(frame, fnic->frame_pool);
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		return -EAGAIN;
> +	}
> +
> +	timer_setup(&nvfnic_ls_req->ls_req_timer, nvfnic_ls_req_timeout,
> +		     0UL);

[Severity: Critical]
Is there a race condition here between the LS request submission and the
abort path?

In the NVMe-FC midlayer, __nvme_fc_send_ls_req() adds the LS request to
rport->ls_req_list before calling the ls_req callback (nvfnic_ls_req_send).

If nvme_fc_abort_lsops() executes asynchronously right after the list
insertion but before nvfnic_ls_req_send() initializes the timer here,
will it invoke nvfnic_ls_req_abort() on a request where lsreq->private
is still purely zero-initialized memory?

If so, nvfnic_ls_req_abort() would unconditionally call mod_timer() on an
uninitialized timer, which could lead to a NULL pointer dereference or
timer wheel corruption.

> +
> +	nvfnic_ls_req->fnic =3D fnic;
> +	nvfnic_ls_req->tport =3D tport;

[ ... ]

> @@ -1606,7 +1729,7 @@ nvme_fc_port_template nvfnic_port =3D {
>  	.remoteport_delete =3D nvfnic_remote_port_delete,
>  	.create_queue =3D nvfnic_create_queue,
>  	.delete_queue =3D NULL,
> -	.ls_req =3D NULL,
> +	.ls_req =3D nvfnic_ls_req_send,
>  	.ls_abort =3D nvfnic_ls_req_abort,

[Severity: High]
This is a pre-existing issue, but does dropping the lock in
nvfnic_ls_req_abort() open a window for a use-after-free?

In nvfnic_ls_req_abort(), fnic->fnic_lock is dropped to safely call
timer_delete_sync(). During this unlocked window, if a concurrent
completion path calls lsreq->done(), the transport will free the lsreq
memory.

When timer_delete_sync() returns and nvfnic_ls_req_abort() reacquires the
lock, it executes nvfnic_ls_req =3D lsreq->private. Does this blindly
dereference the freed lsreq structure?

>  	.fcp_io =3D nvfnic_fcpio_send,
>  	.fcp_abort =3D nvfnic_fcpio_abort,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D9
