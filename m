Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60B3C9EF8
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783078973; cv=none; b=Wk+5Mzt8vA7GYmmoC6LP1D5K/34xii4zid3IdbLGt/04P+dae6a4fOWqrJqbe0V1RinfI8EdMETCM7hUpNoyRb9RnOBeLgOikqPDr3Fii7ndKHysNgRuM0naAP/DVG1CXTtCUyFKIUHIHpZsvYqG5comY/7BEJrSCykIwupLEA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783078973; c=relaxed/simple;
	bh=4U+U0su/wcO97FWGnmxSXaoRQ+9qRlnf+7R7W4BYzM0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OCXMD3XZlRyjzZDwPugF04Ijn/MVLYJBt79my3xq2dtmxwiOUyn58Ps2zLyOQpJzEWX1ckWr3Q/ws9IvyXmLIaPtB1oiHthSmVpcxz8WatWMbKXrAOT/1dRk+8H/fyWpk18BYS3USOey+t53IeYAgsM1Y0gQI1c8r+tmCpMBlcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhcXdh6W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhcXdh6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6D51F000E9;
	Fri,  3 Jul 2026 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783078972;
	bh=sW21BP8CVllydjAsRHcZlrzmExDZHtdXNVKF5LfFfqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HhcXdh6WCPnil1uOw9Vgw6lyIMe+eli5Ut50S6oQP/p3ru1qNsleChpy6nvxot7Ju
	 JNp2DwMYMnj8NAbw/xgMgv2Fhc6hGPi+N1vS5QQ3Ai2d93deKUuX4Wck47bVmtwhGe
	 /GWsMjrUJuwuJSKSrh6A//hVzcVKzqkMaR3H9ujpSrlSZZ+USphMzEn8UfhZgPcBXb
	 uw3k3lUjQTDT6WGlabCxBK8mGfR4jQnRAZqMvaUjioNBsJNMZpW/vv/OF1/oaHaUBc
	 gqMJqXZRTyJHsMEYw9kuv3u+HktwDIW5LoKnNZuBjQtKtg9aynOTaGYzgwOjlvkC7O
	 UxXXkbqis779Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/10] nvme-multipath: switch to use libmultipath
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-11-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-11-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:42:51 +0000
Message-Id: <20260703114252.0C6D51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Diagnostic sysfs attribute functions incorrectly cast the head=
 disk's `private_data` to `struct nvme_ns_head *`, leading to out-of-bounds=
 reads and writes.
- [High] Unconditional clearing of NVME_NS_READY for all paths during reval=
idation.
- [High] Silent removal of BLK_FEAT_PCI_P2PDMA disables P2P DMA on multipat=
h devices.
- [High] Incorrect teardown function `mpath_put_head` used in `nvme_alloc_n=
s_head` error path instead of `mpath_head_uninit`.
--

commit 7fcfa1e0451b9e00996c66fccb6e7ea67da8b9ea
Author: John Garry <john.g.garry@oracle.com>

    nvme-multipath: switch to use libmultipath

    Now that much unused libmulipath-based code has been added, do the full
    switch over. The major change is that the multipath management is moved
    out of the nvme_ns_head structure and into the mpath_head structure.

> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 453c1f0b2dd09..476a0cd2452ce 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
[ ... ]
> @@ -3998,22 +3992,32 @@ static struct nvme_ns_head *nvme_alloc_ns_head(st=
ruct nvme_ctrl *ctrl,
>  	if (head->ids.csi) {
>  		ret =3D nvme_get_effects_log(ctrl, head->ids.csi, &head->effects);
>  		if (ret)
> -			goto out_cleanup_srcu;
> +			goto out_ida_free;
>  	} else
>  		head->effects =3D ctrl->effects;
> =20
> +	ret =3D mpath_head_init(&head->mpath_head);
> +	if (ret)
> +		goto out_ida_free;
> +
> +	head->mpath_head.drv_module =3D THIS_MODULE;
> +	head->mpath_head.disk_groups =3D nvme_ns_attr_groups;
> +	head->mpath_head.parent =3D &subsys->dev;
> +	head->mpath_head.iopolicy =3D &head->subsys->mpath_iopolicy;
> =20
>  	ret =3D nvme_mpath_alloc_disk(ctrl, head);
>  	if (ret)
> -		goto out_cleanup_srcu;
> +		goto out_mpath_head_free;
> =20
>  	list_add_tail(&head->entry, &ctrl->subsys->nsheads);
> =20
>  	kref_get(&ctrl->subsys->ref);
> =20
>  	return head;
> -out_cleanup_srcu:
> -	cleanup_srcu_struct(&head->srcu);
> -out_ida_remove:
> +
> +out_mpath_head_free:
> +	mpath_put_head(&head->mpath_head);
> +out_ida_free:
>  	ida_free(&ctrl->subsys->ns_ida, head->instance);
>  out_free_head:
>  	kfree(head);

[Severity: High]
Can this error path lead to a NULL pointer dereference or double-free?

If mpath_put_head() triggers mpdt->remove_head(), it might call
list_del_init(&head->entry) on a list that hasn't been added yet (as
list_add_tail() is called later). Should this use mpath_head_uninit() inste=
ad
to properly clean up the SRCU struct without prematurely freeing resources?

> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index b27b45c59c883..f4cf2dc2c1e43 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
[ ... ]
> -void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
> +static void nvme_mpath_revalidate_paths_cb(struct mpath_device *mpath_de=
vice)
>  {
> -	sector_t capacity =3D get_capacity(head->disk);
> -	struct nvme_ns *ns;
> -	int node;
> -	int srcu_idx;
> -
> -	srcu_idx =3D srcu_read_lock(&head->srcu);
> -	list_for_each_entry_srcu(ns, &head->list, siblings,
> -				 srcu_read_lock_held(&head->srcu)) {
> -		if (capacity !=3D get_capacity(ns->disk))
> -			clear_bit(NVME_NS_READY, &ns->flags);
> -	}
> -	srcu_read_unlock(&head->srcu, srcu_idx);
> +	clear_bit(NVME_NS_READY, &nvme_mpath_to_ns(mpath_device)->flags);
> +}

[Severity: High]
Is it correct to unconditionally clear NVME_NS_READY here?

In the previous implementation, nvme_mpath_revalidate_paths() checked if the
capacity of each path matched the head (capacity !=3D get_capacity(ns->disk=
))
before clearing the flag. Does this unconditionally disable healthy paths
during capacity revalidation?

[ ... ]
> @@ -1253,24 +661,26 @@ static ssize_t io_requeue_no_usable_path_count_sho=
w(struct device *dev,
>  {
>  	struct gendisk *disk =3D dev_to_disk(dev);
>  	struct nvme_ns_head *head =3D disk->private_data;
> +	struct mpath_head *mpath_head =3D &head->mpath_head;
> +	unsigned long val =3D
> +		atomic_long_read(&mpath_head->requeue_no_usable_path_cnt);
> =20
> -	return sysfs_emit(buf, "%lu\n",
> -		    atomic_long_read(&head->io_requeue_no_usable_path_count));
> +	return sysfs_emit(buf, "%lu\n", val);
>  }

[Severity: Critical]
For multipath disks, does disk->private_data now point to struct mpath_head
instead of struct nvme_ns_head?

If so, casting it to struct nvme_ns_head * and evaluating &head->mpath_head
will compute an address past the end of the allocated object. Could this le=
ad
to out-of-bounds reads and writes when reading or writing these sysfs
attributes?=20

This also appears to affect io_requeue_no_usable_path_count_store(),
io_fail_no_available_path_count_show(), and=20
io_fail_no_available_path_count_store() below.

[ ... ]
> +int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *h=
ead)
> +{
> +	struct queue_limits lim;
> +	int ret;
> +
> +	head->mpath_head.mpdt =3D &mpdt;
> +
> +	/*
> +	 * If "multipath_always_on" is enabled, a multipath node is added
> +	 * regardless of whether the disk is single/multi ported, and whether
> +	 * the namespace is shared or private. If "multipath_always_on" is not
> +	 * enabled, a multipath node is added only if the subsystem supports
> +	 * multiple controllers and the "multipath" option is configured. In
> +	 * either case, for private namespaces, we ensure that the NSID is
> +	 * unique.
> +	 */
> +	if (!multipath_always_on) {
> +		if (!(ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) ||
> +				!multipath)
> +			return 0;
> +	}
> +
> +	if (!nvme_is_unique_nsid(ctrl, head))
> +		return 0;
> +
> +	blk_set_stacking_limits(&lim);
> +	lim.dma_alignment =3D 3;
> +	lim.features |=3D BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
> +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;

[Severity: High]
Should BLK_FEAT_PCI_P2PDMA be included in the features bitmask here?

Previously, it was added unconditionally to the multipath head's queue limi=
ts.
Will its removal cause the block layer to reject PCI Peer-to-Peer DMA bios
submitted to the multipath node?

> +	if (head->ids.csi =3D=3D NVME_CSI_ZNS)
> +		lim.features |=3D BLK_FEAT_ZONED;
> +
> +	ret =3D mpath_alloc_head_disk(&head->mpath_head, &lim, ctrl->numa_node);
> +	if (ret)
> +		return ret;
> +
> +	sprintf(head->mpath_head.disk->disk_name, "nvme%dn%d",
> +			ctrl->subsys->instance, head->instance);
> +	nvme_tryget_ns_head(head);
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D10
