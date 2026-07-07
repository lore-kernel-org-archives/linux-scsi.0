Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E0F19D065
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407619; cv=none; b=USTl2wdoc83E7Ppst67sVplBh95Tvp8Wp7/sYV0Kt4Pec+zm4modW6ZLAf7xdPXgFCPiA3GJ7k4tBqlhhDvEpChhIaFFEYT7UyY4+b+UVlhcZM4qgtQJoCKrYGkSN8oj93UgrXxuI6cUBKzLhtiFMPHuXc+9/OZE5X/Y4zikHnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407619; c=relaxed/simple;
	bh=dMRtXnstWBgoaWrMn8bpV06yquO6w/SdesPyoPEdxFo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I30tGP9yY/1aA7ZnLywyuoFJ/Z9YeV6QRTLVhaZZ2xycN7qgasf9p4jLLrITTT+8GKCI8IB9Ap6nCVBNSx6MOo1eWGLuNkN4CUcLQ8qEmMvQnbVVI5CIc7sRJ7GoKHsVWSi/lM3f0hBoOS7o9G/2GG2GEKsHEuHG3nxa2rWfZNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKIr2Y87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKIr2Y87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBD01F000E9;
	Tue,  7 Jul 2026 07:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407617;
	bh=ffIZiasyEAmdy4RN+62h++wighXMvfQm4FyPCVo3Xkg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hKIr2Y876wnm2Njt4JwHMYBakfQHT7d1BMI4TBpZyY83v3snenA7glo53QBX9P6gj
	 vgRQ5IvlNFsgbGOphK44Y08nCEnC54RmK1T8dnD18GPVwhmBjmItb1s0Lq2oWHtfcY
	 iYYbUj86cIm9ftMiYOpbGZ1Ff45dpy3Tw1hZRjVFzPhT5ZaTg0+e0GWbj67N+V7ccF
	 zWckLqown9FhrcH8jsgo3lf7z1PeYY7iwloE3vZtESXLpxO3DsK7yjWOa2cMXymYt0
	 jVSEVde4crQRrHEnXc93Uffryr3oLL1JnQ9oWukYg5rJ4u73sQBVdAbEJeUdbY4WOK
	 J4TRmm9Q/MkPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 51/88] scsi: qla2xxx: Initialize NVMe abort_work once
 at submission
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-52-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-52-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:00:16 +0000
Message-Id: <20260707070017.2FBD01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Moving INIT_WORK to command submission introduces workqueue list c=
orruption on the error path if an abort was concurrently scheduled.

Pre-existing issues:
- [Critical] The error path in qla_nvme_post_cmd and qla_nvme_ls_req uncond=
itionally frees `sp` and nullifies `priv->sp` without lock protection, bypa=
ssing `cmd_kref`.
- [High] Data race and missing memory barrier when initializing priv->abort=
_work, priv->sp, and priv->cmd_lock.
--

--- Patch [51]: [PATCH v3 51/88] scsi: qla2xxx: Initialize NVMe abort_work =
once at submission ---
commit b03391e97f40b451e572a2e6302f81908aa69bdd
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Initialize NVMe abort_work once at submission

This patch moves the initialization of priv->abort_work from the abort
handlers to the command submission paths. This is intended to prevent
corrupting the workqueue list by reinitializing an already pending
work item if an abort is issued more than once for the same command.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 0038b6274d444..3b2f255a5d7d4 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c

[ ... ]

> @@ -501,6 +500,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port =
*lport,
>  	priv->sp =3D sp;
>  	kref_init(&sp->cmd_kref);
>  	spin_lock_init(&priv->cmd_lock);
> +	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	nvme =3D &sp->u.iocb_cmd;

[Severity: High]
This is a pre-existing issue, but is the initialization of priv->abort_work,
priv->sp, and priv->cmd_lock safe from concurrent aborts?

Because the NVMe FC transport can start the block layer timer before
calling command submission, a timeout can trigger a concurrent
qla_nvme_ls_abort() while this code is running.

Without memory barriers, a concurrent abort thread might observe
priv->sp !=3D NULL before the spinlock or work struct are fully initialized
in memory. Could this lead to locking an uninitialized spinlock or
scheduling a partially initialized work struct?

[Severity: High]
If a concurrent abort schedules abort_work while this submission is
executing, and the submission subsequently fails, does this lead to a
use-after-free?

If the submission fails, the transport layer synchronously receives an
error and frees the request buffer. If abort_work was already queued
by a concurrent abort, won't this free the work struct while it is
still pending on the system workqueue?

[ ... ]

> @@ -877,6 +876,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_por=
t *lport,
> =20
>  	kref_init(&sp->cmd_kref);
>  	spin_lock_init(&priv->cmd_lock);
> +	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	sp->priv =3D priv;
>  	priv->sp =3D sp;

[Severity: High]
If a concurrent abort schedules abort_work while this FCP submission is
executing, and the submission subsequently fails, could this cause
workqueue corruption?

If the transport layer receives an error, the block layer retries the
request using the exact same priv structure. This causes INIT_WORK()
to execute again. Will reinitializing this queued work item reset its
list pointers and corrupt the workqueue linked list?

[Severity: Critical]
This is a pre-existing issue, but does the error path in this function
(and similarly in qla_nvme_ls_req) safely handle a concurrent abort?

If qla2x00_start_nvme_mq() fails, the error path nullifies pointers and
frees the structure:

drivers/scsi/qla2xxx/qla_nvme.c:qla_nvme_post_cmd() {
    ...
    rval =3D qla2x00_start_nvme_mq(sp);
    if (rval !=3D QLA_SUCCESS) {
        ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x212d,
            "qla2x00_start_nvme_mq failed =3D %d\n", rval);
        sp->priv =3D NULL;
        priv->sp =3D NULL;
        qla2xxx_rel_qpair_sp(sp->qpair, sp);
    }
    ...
}

If a concurrent abort already executed, cmd_kref is elevated and
abort_work is scheduled. This error path locklessly sets priv->sp =3D NULL
and unconditionally frees sp back to the mempool, bypassing the reference
held by the pending abort_work.

When qla_nvme_abort_work() later executes, won't it either read the
nullified priv->sp or operate on the freed sp structure, causing a
use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D51
