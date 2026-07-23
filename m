Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CED44C511
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 19:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784834781; cv=none; b=l/Scwb30nno52tYo2TOQeF/DdDB0GGj8dhQZuAScbXnUmye2kY4jdrTQyG0Tq0hON42vy24upxVGVngD4yYBZV7T4mCk8F/MN6BLa9I3BykWL2QNC5XrUn/YIXqvulK739Yz2zhqIhtnKuhoORCptePmheDJls8gbEql3sLzIb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784834781; c=relaxed/simple;
	bh=lsSgJwVAAJQdD8L85eIw/aJbTekZyJZkPElGv2bJ808=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B9WV5Tg/5nI8CGu2+b1PAkWHVeEiOZJpJnmNbMs5qAlmezRbbAzbSkptJagVRExsXCy2KQIXPMxgudf5ensrwvJyWYobXdaHuQx8Zb5FRBIs5Od/s03D9ABbwE1BNCmYiPUGZLZ1S7H8Mm0TpnTF7JAIAVxsWKsL5nuOzMGG9z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3ZrhH5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3ZrhH5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8971F000E9;
	Thu, 23 Jul 2026 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784834780;
	bh=iUz6IYOfCqxlDL001FL2RfneWLubiGdkhyIwM2rr4qs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z3ZrhH5sl6VniMuIlbD/0obAIW7VrkYoOHXRnN2RCRrlBkW226a/Y/ipQKJx085tT
	 CCfJsyLFamXuC0piusSmCcZztjmGGFMR7YWB1ddBo9NoWklC+2ypGVqzk/p3oGHzj8
	 6L10d6UMeB7U46hzOUuaOye9Lo9gAYKZ2rXbLTjLihh8w+nbOMqe+kH3KduljQGcYb
	 lfEoyWb+Q+HS1Bi22vZ8zqnfBOGi/20nd/Plo/Yct2ZbXpid+fsI0jAMVdC7dg0Go2
	 QTS8UgyNvSaiPgDl5JwpyLNFT/21GwgHpSDz5VUmq8qwzOeeAYBFIpY7ZMTjuSqAt5
	 Lz7bW7AAm+3ug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 51/56] scsi: qla2xxx: Initialize NVMe abort_work once
 at submission
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-52-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-52-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 19:26:19 +0000
Message-Id: <20260723192619.EF8971F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] The patch moves INIT_WORK to the command submission paths but =
fails to order it safely against the publication of priv->sp, causing a NUL=
L pointer dereference.
- [High] Calling qla_nvme_fcp_abort or qla_nvme_ls_abort multiple times for=
 the same command leaks its kref and permanently hangs the request.

Pre-existing issues:
- [Critical] The command state (priv->sp) is exposed to concurrent abort ha=
ndlers before the spinlock (priv->cmd_lock) is initialized, leading to spin=
lock corruption.
- [Critical] In the error paths of command submission, priv->sp is cleared =
without holding cmd_lock, and the command structure is freed directly, caus=
ing a Use-After-Free.
- [High] A race condition allows qla_nvme_fcp_abort to spuriously abort a c=
ompletely different, newly submitted command due to tag reuse (ABA problem).
--

--- Patch [51]: [PATCH v6 51/56] scsi: qla2xxx: Initialize NVMe abort_work =
once at submission ---
commit 9a9f1f14cd9974710e9176cf206ade9b1d04e0e9
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Initialize NVMe abort_work once at submission

This patch moves the initialization of priv->abort_work to the command
submission path to avoid corrupting the workqueue list if an abort is
issued more than once for the same command.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 0038b6274d444..3b2f255a5d7d4 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -463,7 +463,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_po=
rt *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);
>  }

[Severity: High]
If the transport layer calls the abort functions multiple times for the same
command, is there a kref leak here?

Earlier in this function, we unconditionally increment the reference count =
via
kref_get_unless_zero(&priv->sp->cmd_kref).

Since the work item is no longer re-initialized, schedule_work() will return
false and do nothing if the work is already pending. However, the return
value is ignored and the extra kref taken is never dropped.

Since the work function qla_nvme_abort_work() only executes once and drops a
single kref, will this permanently hang the NVMe core's I/O queue by
preventing the kref from ever reaching zero?

[ ... ]

> @@ -501,6 +500,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port =
*lport,
>  	priv->sp =3D sp;
>  	kref_init(&sp->cmd_kref);
>  	spin_lock_init(&priv->cmd_lock);
> +	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	nvme =3D &sp->u.iocb_cmd;
>  	priv->fd =3D fd;

[Severity: Critical]
Could this sequence cause a panic due to an uninitialized work item?

We publish the command state with priv->sp =3D sp explicitly before INIT_WO=
RK()
executes. Because the transport allocates the private data with kzalloc(), =
the
work struct's function pointer is initially NULL.

If a concurrent error recovery thread calls qla_nvme_ls_abort() while
qla_nvme_ls_req() is executing, it can observe priv->sp !=3D NULL and call
schedule_work(&priv->abort_work).

Will this queue a work item with a NULL function pointer, causing a kernel
panic when the worker thread executes it?

[Severity: Critical]
This is a pre-existing issue, but does initializing the spinlock after
publishing priv->sp lead to lock corruption?

Similar to the work item, priv->sp is exposed to concurrent abort handlers
before spin_lock_init(&priv->cmd_lock) is called. A concurrent abort from
nvme_fc_abort_lsops can see priv->sp !=3D NULL and successfully acquire the
0-initialized lock.

If the submission thread then unconditionally resets the lock internals back
to 0 while the abort handler is inside its critical section, will it cause
memory corruption or lockdep panics when the abort handler tries to unlock =
it?

[Severity: Critical]
This is a pre-existing issue, but can the error path further down in this
function cause a use-after-free if an abort runs concurrently?

If hardware submission fails, the error path in qla_nvme_ls_req() does this:

    rval =3D qla2x00_start_sp(sp);
    if (rval !=3D QLA_SUCCESS) {
        ...
        sp->priv =3D NULL;
        priv->sp =3D NULL;
        qla2x00_rel_sp(sp);
        return rval;
    }

It sets priv->sp =3D NULL without acquiring priv->cmd_lock, bypasses kref_p=
ut(),
and immediately frees the command structure via qla2x00_rel_sp().=20

If a concurrent abort handler has already checked priv->sp !=3D NULL and
incremented the kref inside qla_nvme_ls_abort(), it is left holding a
reference to freed memory. When the queued abort_work runs, won't it invoke
abort logic on the freed command structure?

[ ... ]

> @@ -545,7 +545,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_p=
ort *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);
>  }

[Severity: High]
This is a pre-existing issue, but is qla_nvme_fcp_abort() vulnerable to a t=
ag
reuse race condition?

In the NVMe FC core, __nvme_fc_abort_op() initiates an abort without
synchronizing with the I/O completion path. If a hardware completion interr=
upt
fires and completes the request, the block layer can free and immediately r=
euse
the same tag (and thus the same fd->private memory) for a completely new
command.

When qla_nvme_fcp_abort() runs and acquires priv->cmd_lock:

    static void qla_nvme_fcp_abort(...)
    {
        ...
        spin_lock_irqsave(&priv->cmd_lock, flags);

it will see the new priv->sp. Does this cause a spurious abort of the newly
submitted, innocent command?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D51
