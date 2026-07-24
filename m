Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D3644E647
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917528; cv=none; b=qRCy3LZ4MNMzlWCEnNkDfn+nCT/JItv+CZjPwnsy1H2bqmA7cqUZcEdjtMEL4VhNsNPZwOQpLRA10ArYJD1kr3U4XRxB1Kdtq958cfRR2NI3kZNkeOy6Fo8GQHJs563Al2S8rXY0CHUEsrY4+6t4Dqe6pbuVtLDUw/2l7Pd97EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917528; c=relaxed/simple;
	bh=Yeu6cyoY/mosIWUKZ6npH/ZjGxIDwJndt262MNXYEqU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S7Xgybm8aWifd3hoiOggxCYOa3lmy5ELt3XtJWgO0gDVEeaYMQ4JgFX08dv7XmRFjepHyhW0BrgO3VtICVVP7bLWI5pckApYdlWvYtDBFygr6lWnKyX2K2i/swdC6ilmkyPZFjHNa63nhlMjLUobPJUJGhGIlhOxIlYZ9g24XfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFxyu6Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFxyu6Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E0A1F00A3A;
	Fri, 24 Jul 2026 18:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917526;
	bh=bV4M09wRjXFZFqHJobSmI0Nv9kai6vGUw47pAeQ2E5o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OFxyu6Up2UneMhyVSv/eeLrzkd9ylOVYGDCErxXoLr2h+r2IKf9Jo/IhHlbiy8X13
	 KC2E6BUVPhGJ+/FTTd2phRA1CEDErctJ1owr8Yw4JVZeKcTX1WXWEPEsQIbkNorNwA
	 lNyAQgd6CaFrlyhI0YdUluTf2gcNPzRRl0QkaqTPk7aP8z63SDlF2NFC/ZafV0sDE3
	 FtlXcYkj4WaUub6HHkrRSHq45YUvUH+oEtigzW2GuqOKQMmGYGwVdBehDFb8aeQTMg
	 qMbluZd7EmgjnKm/mb6DOKaGbELILb3e1KlQ7LC4viqgyoAzVATN2MxGX3c2oceqk2
	 z4Rxvkp7yNjzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 12/13] scsi: fnic: Expose NVMe transport state in
 debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-13-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-13-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:25:26 +0000
Message-Id: <20260724182526.93E0A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] The NVMe debugfs interface is registered prematurely in `fnic_prob=
e()`, creating a TOCTOU window where user space can trigger a NULL pointer =
dereference or spinlock BUG.
- [Low] If global debugfs initialization fails, the per-host NVMe debugfs d=
irectories are created directly in the shared debugfs root.

Pre-existing issues:
- [High] Missing cleanup for NVMe resources on the `fnic_probe` error path.
- [High] Unsafe list traversal in `fnic_delete_fcp_tports` due to lock drop=
ping.
--

--- Patch [12]: [PATCH v6 12/13] scsi: fnic: Expose NVMe transport state in=
 debugfs ---
commit 0912b751cd90ccad01299101d08e42c6545ed96c
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Expose NVMe transport state in debugfs

Create an NVMe debugfs directory with a per-host nvmef_info file.
Report local-port and target-port identifiers for NVMe initiator
instances, and initialize and remove the debugfs entries with the NVMe
probe and teardown paths.

> diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_de=
bugfs.c
> index 467fba29ea5f8..61f167e20574d 100644
> --- a/drivers/scsi/fnic/fnic_debugfs.c
> +++ b/drivers/scsi/fnic/fnic_debugfs.c

[ ... ]

> @@ -722,3 +744,75 @@ void fnic_stats_debugfs_remove(struct fnic *fnic)
>  	debugfs_remove(fnic->fnic_stats_debugfs_host);
>  	fnic->fnic_stats_debugfs_host =3D NULL;
>  }
> +
> +void fnic_nvmef_debugfs_init(struct fnic *fnic)
> +{
> +	char name[16];
> +
> +	snprintf(name, sizeof(name), "host%d", fnic->fnic_num);
> +
> +	fnic->fnic_nvmef_debugfs_host =3D debugfs_create_dir(name,
> +							   fnic_nvmef_debugfs_root);

[Severity: Low]
Can this create the host directory in the debugfs root instead of the fnic
subsystem directory?

If fnic_debugfs_init() fails during module load (for example, due to a memo=
ry
allocation failure), fnic_nvmef_debugfs_root will be NULL.

When debugfs_create_dir() is later called with a NULL parent, it creates the
directory directly in the global debugfs root. Should this check if
fnic_nvmef_debugfs_root is valid before creating the directory?

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 774de0b6d61c7..9b3025007075e 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c

[ ... ]

> @@ -936,6 +936,7 @@ static int fnic_probe(struct pci_dev *pdev, const str=
uct pci_device_id *ent)
>  		err =3D -EOPNOTSUPP;
>  		goto err_out_fnic_role;
>  	case VFCF_FC_NVME_INITIATOR:
> +		fnic_nvmef_debugfs_init(fnic);
>  		fnic->role =3D FNIC_ROLE_NVME_INITIATOR;
>  		dev_info(&fnic->pdev->dev, "fnic: %d is NVME initiator\n",
>  			fnic->fnic_num);

[Severity: High]
Could this expose the debugfs file before the fnic driver data is fully
initialized?

By registering the NVMe debugfs interface here, a time-of-check to
time-of-use window is created. If userspace reads the debugfs file
immediately after it is created, nvfnic_get_nvmef_info() will execute before
fnic_probe() has finished initializing fnic_lock and the tport_list.

This would cause list_for_each_entry_safe() in nvfnic_get_nvmef_info() to
operate on a zero-initialized list, leading to a NULL pointer dereference
when accessing the next pointer.

Should the debugfs initialization be moved later in the probe function, aft=
er
all locks and lists are fully initialized?

[ ... ]

> @@ -1210,6 +1211,8 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
>  err_out_fnic_alloc_vnic_res:
>  	fnic_clear_intr_mode(fnic);
>  err_out_fnic_set_intr_mode:
> +	if (IS_FNIC_NVME_INITIATOR(fnic))
> +		fnic_nvmef_debugfs_remove(fnic);
>  	if (IS_FNIC_FCP_INITIATOR(fnic))
>  		scsi_host_put(fnic->host);
>  err_out_fnic_role:

[Severity: High]
This is a pre-existing issue, but does the error handling path miss some
cleanup for NVMe resources?

If fnic_probe() fails after fnic_nvme_drv_init() succeeds, the error handli=
ng
jumps to err_out_free_stats_debugfs:

err_out_free_stats_debugfs:
    fnic_stats_debugfs_remove(fnic);
    fnic_free_ioreq_tables_mq(fnic);
    if (IS_FNIC_FCP_INITIATOR(fnic))
        scsi_remove_host(fnic->host);
err_out_nvme_drv_init:
err_out_scsi_drv_init:
    fnic_free_intr(fnic);

This path seems to miss calling mempool_destroy() for fnic->io_req_pool,
sbitmap_free() for fnic->nvfnic_tag_map, and nvme_fc_unregister_localport()=
.=20

Leaving the NVMe local port registered after freeing the fnic structure cou=
ld
lead to a use-after-free when the NVMe subsystem interacts with the dead
port.

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 874139412704b..8794360f2adfe 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c

[ ... ]

> @@ -188,6 +188,36 @@ void nvfnic_release_nvme_ioreq_buf(struct fnic_iport=
_s *iport,
>  			     fnic->io_sgl_pool[io_req->sgl_type]);
>  }
> =20
> +int nvfnic_get_nvmef_info(struct fnic *fnic, struct fnic_nvmef_info *inf=
o)
> +{

[Severity: High]
This isn't a bug introduced by this patch, but does fnic_delete_fcp_tports()
have an unsafe list traversal?

When iterating over fnic->iport.tport_list, the code uses
list_for_each_entry_safe():

fnic_fcs.c:fnic_delete_fcp_tports() {
    ...
    list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
        ...
        nvfnic_delete_tport(...)
}

However, nvfnic_delete_tport() temporarily drops the lock:

fnic_nvme.c:nvfnic_delete_tport() {
    ...
    spin_unlock_irqrestore(&fnic->fnic_lock, flags);
    ret =3D nvme_fc_unregister_remoteport(tport->nv_rport);
    ...
}

Because the lock is dropped during the iteration, concurrent threads could
acquire the lock, remove the cached next element from the list, and free it.

When nvfnic_delete_tport() returns and the loop continues, could this result
in dereferencing a stale next pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D12
