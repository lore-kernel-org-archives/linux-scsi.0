Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C5536A377
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 22:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781304349; cv=none; b=j68Poaey0kLKP1knc9K641zWifW9PLtIsF0njgDb2tGyueldxa9bsF8QQtX2Rgfk5tXAKqDZrrvgLRmgYpUaYu1J3dNMThoXRTnqhIMHwyEll41uKjkDyWK7fgELdXc4E/iyw36NPHLLWBRNEw2hn8SQJt2y9rwPz/+d9VU/9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781304349; c=relaxed/simple;
	bh=hFu8oiOa8eCNaBZQZzKhSOn17n7bkr5rlUtce5uifPk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HZyvpI/JFBaYPiOYEweff2xrvZmGEEBkh/QKmmuPm1BSpdxpKb4PFgXDMOEZP3U3hFK2LL/SAuCuXPoolOsBd6v8fvsca9NxQjxfsWrz7JBfUBYu4JKcWs/b4iFv2gDyGvlWr8rLkrRgak+DgZ5goHQLddSE3wvI1QzUPl7S6pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSzZx4Rc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSzZx4Rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823EB1F000E9;
	Fri, 12 Jun 2026 22:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781304347;
	bh=JMPfXggp2OgfiUhR07nF4j81tb0Zcewgt8JYnqxT9Ok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SSzZx4RcNHOauuWSfdBD3JifcnePxGkw3rTfWdIr+ufueBXwgmeG90KWnSlHUOuEk
	 q2To8omi6TjDdx/dh3zUXBkOSjvCqbbOBe/c/PphyXZJiJh8Sh4u1XnZdLqdHNMEDu
	 Wo6igU2aGwshOUZ2EgkTGXkFxTHcf44ehkBNCFgXfmoASeAIfvbvNE2oHXlViJpiZK
	 EBGT/lzN8i083EuVW9ZH1ZgkLDGibZwG+ADIig8uDXWYre+kl0z5EA6e78cg28LU0X
	 UvD39foppiZl/4gIS4CpVoOSYnWcpYfEUVtgLxsF5mDeyRqlOdAvuHBDkj9efIjM9e
	 GG8zoR6FfaxDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-10-kartilak@cisco.com>
References: <20260612180918.8554-10-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 22:45:47 +0000
Message-Id: <20260612224547.823EB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] FORTIFY_SOURCE panic in nvfnic_ls_req_send due to embedding ke=
rnel API struct in on-wire frame format.
- [High] Use-After-Free and double completion race on the error path of nvf=
nic_ls_req_send().
- [High] Data race on fnic->tx_queue in fdls_send_fcoe_frame() due to dropp=
ed fnic_lock.

Pre-existing issues:
- [High] AB-BA Deadlock between nvfnic_ls_rsp_recv() and the timer callback.
- [High] Unsafe usage of shared struct member fnic->lock_flags in spin_lock=
_irqsave() causes IRQ state clobbering.
--

commit e7a906f62bc9306d2818dc39a38472594580ceda
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Send NVMe LS requests through FDLS

This commit adds the FC frame wrapper for NVMe LS requests and builds
LS request frames from the NVMe-FC transport callback. It allocates
OXIDs, tracks outstanding LS requests on the target port, arms
request timers, and registers the LS request callback in the NVMe FC
port template.

Link: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@intel=
.com/

> diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
> --- a/drivers/scsi/fnic/fdls_fc.h
> +++ b/drivers/scsi/fnic/fdls_fc.h
> @@ -251,6 +254,11 @@ struct fc_std_logo {
>  	struct fc_els_logo els;
>  } __packed;
> =20
> +struct fc_std_ls_req {
> +	struct fc_frame_header fchdr;
> +	struct nvmefc_ls_req ls_req;
> +};
> +

[Severity: Critical]
Does this struct incorrectly embed the host API driver structure into the
on-wire frame format?

struct nvmefc_ls_req is a host API structure containing kernel pointers and
DMA addresses, not an on-wire format.=20

Because the destination pointer in nvfnic_ls_req_send() is later typed as
this kernel struct, fortify bounds checking strictly limits the copy to the
struct size (around 64 bytes).=20

When sending larger NVMe LS requests, won't this cause a guaranteed fatal
buffer overflow panic (__fortify_memcpy_chk) on every attempt to send a
larger request?

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c

[ ... ]

> @@ -1290,6 +1290,132 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
>  	ls_req->done(ls_req, -ETIMEDOUT);
>  }
> =20

[Severity: High]
This is a pre-existing issue, but does nvfnic_ls_req_timeout() cause an
AB-BA deadlock with nvfnic_ls_rsp_recv()?

In nvfnic_ls_rsp_recv(), timer_delete_sync() is called while fnic->fnic_lock
is held.

If nvfnic_ls_req_timeout() unconditionally attempts to acquire the same
fnic->fnic_lock, won't it spin indefinitely if the timer expires
concurrently on another CPU, while timer_delete_sync() spins waiting for
the callback to finish?

[Severity: High]
This is a pre-existing issue, but does the use of the globally shared
fnic->lock_flags in spin_lock_irqsave() within nvfnic_ls_req_timeout()
cause IRQ state clobbering?

spin_lock_irqsave() expects a local stack variable to save the CPU's current
IRQ state.=20

If multiple CPUs execute spin_lock_irqsave() concurrently using this shared
member, they will overwrite each other's saved interrupt state. Won't this
cause spin_unlock_irqrestore() to restore an incorrect state, leading to
system lockups?

> +int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,

[ ... ]

> +	pls_req =3D (struct nvmefc_ls_req *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET=
 +
> +					sizeof(struct fc_frame_header));
> +	memcpy(pls_req, ls_req->rqstaddr, ls_req->rqstlen);

[Severity: Critical]
Is this memcpy execution vulnerable to a fortify bounds checking panic?

As mentioned above, pls_req is cast to the smaller struct nvmefc_ls_req
pointer. Since fortify strictly bounds the copy to the struct size, sending
larger requests (like Create Association at 116 bytes) will exceed this size
and trigger a panic.

> +	list_add_tail(&nvfnic_ls_req->list, &tport->ls_req_list);
> +	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_PENDING;
> +	timeout =3D FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
> +	mod_timer(&nvfnic_ls_req->ls_req_timer,
> +		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	ret =3D fnic_send_fcoe_frame(iport, frame, frame_size);

[Severity: High]
Can dropping fnic_lock here lead to list corruption on fnic->tx_queue?

If fnic is in a transitional state, fnic_send_fcoe_frame() delegates to
fdls_send_fcoe_frame(), which queues the frame directly onto fnic->tx_queue
using list_add_tail().=20

Since the lock was explicitly dropped before the call, won't concurrent
accesses to fnic->tx_queue from other threads (like discovery) cause
unprotected list modifications?

> +	if (ret) {
> +		timer_delete_sync(&nvfnic_ls_req->ls_req_timer);
> +		spin_lock_irqsave(&fnic->fnic_lock, flags);
> +		list_del(&nvfnic_ls_req->list);

[Severity: High]
Does this error path trigger a use-after-free and double completion race?

When mod_timer() is called earlier, ownership of the request transfers to
the timer. If fnic_send_fcoe_frame() is delayed or preempted, the timer
may expire on another CPU. This fully executes nvfnic_ls_req_timeout()
and allows the NVMe midlayer to free the memory backing ls_req and
nvfnic_ls_req.

If fnic_send_fcoe_frame() subsequently returns an error, won't this error
path blindly access the already freed nvfnic_ls_req to call
timer_delete_sync() and list_del(), resulting in a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D9
