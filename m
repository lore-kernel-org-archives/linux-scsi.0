Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4C23C4B9A
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783077865; cv=none; b=dHjkgCz5VoVg+iaw3krMS8hNc3/ncTymMQi8Wxa5O9V1VVxcd+kF052GZbS8oeC974WdweIoWJ9leG1XyywLjHxMToY78Mnrm6/AHE96q5DTQmmC1pb0Y/CkHtxONQnrjEYnunigLfHzC8YcJKbS5n/ry+AcH4HzobnG3bI+HIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783077865; c=relaxed/simple;
	bh=gE/eeyAVSjk2jv7S9O1Qhw7JqAdIMY6Wre4NtOHXCis=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z+VxdFPF5C/tpoIGJVwUVtv+bWybNRLV8obdG8PetReZXjcQBTKhdUAT0bMAfh9ygmbBfGrzHUUMH3XFLwoa4nIwU/e8/myr42vRl/QncHj21z3pSF+jkK31hh+tFGzVb0fMggQjoO0TzGfRPX9rb3A3ZhscdLVyo6PSTbCAC/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ktkaww7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ktkaww7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA6C1F00A3A;
	Fri,  3 Jul 2026 11:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783077853;
	bh=05gaHz7kPxULeJSGTbbta0VzMza3djvUptkenFJgUhE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ktkaww7agO8R2AsbfwxryFAii8UyZ/ha4JhjzUHJMETTuSbePodlBQ1z6R4qmuobF
	 GZHBiOpOktgMMZ/7w4nJcDZWRSno4viDG8IfaqdprlSKk78Xwq7VYLoGAV68KMQDAf
	 3kkR1VoIOFgwwNUorirGUR3RzfDDVFNsT5I+c87XSzOwxgNPMnZ4F9nG5OhhS9hvyg
	 X/SLi8eNHbO6w2PTlzdo9abNnDwQMWX4JmKeyK49X7oXzyw8MOOxHnMIu1zbuUpk8C
	 NqLugu4eHJh9zUMOAlHZVR0tjhnQFlVJIlIh+9NIJNVt/Y5HsdqCeb+p3SK7TuGCF/
	 4+I0V7VPIt4dw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/10] nvme-multipath: add nvme_{add,delete}_ns()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-9-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:24:13 +0000
Message-Id: <20260703112413.9EA6C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] The function `nvme_add_ns()` unconditionally accesses `ns->ctrl->nr=
_active`, which is conditionally compiled, causing a build failure when `CO=
NFIG_NVME_MULTIPATH` is disabled.
- [Low] The patch introduces calls to undeclared functions (`mpath_add_devi=
ce`, `mpath_delete_device`), causing a hard compilation failure.
--

commit 6769aa1dce3bd34edd5c71bc4aa5c9950e9c148a
Author: John Garry <john.g.garry@oracle.com>

nvme-multipath: add nvme_{add,delete}_ns()

This commit adds wrapper functions to call into the mpath_add_device and
mpath_delete_device APIs. The per-NS gendisk pointer is utilized as the
mpath_device disk pointer for libmultipath references.

> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h

[ ... ]

> @@ -1041,6 +1041,18 @@ extern const struct block_device_operations nvme_b=
dev_ops;
> =20
>  void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl);
>  struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
> +
> +static inline void nvme_add_ns(struct nvme_ns *ns)
> +{
> +	mpath_add_device(&ns->mpath_device, &ns->head->mpath_head,
> +		ns->disk, ns->ctrl->numa_node, &ns->ctrl->nr_active);

[Severity: Low]
Will this cause a build failure when CONFIG_NVME_MULTIPATH is disabled?
Looking at struct nvme_ctrl, the nr_active field is conditionally compiled,
but nvme_add_ns accesses it unconditionally.

Also, are mpath_add_device and mpath_delete_device declared in a header
that is included here? It appears these functions might be undeclared,
which would result in implicit declaration errors during the build.

> +}
> +
> +static inline bool nvme_delete_ns(struct nvme_ns *ns)
> +{
> +	return mpath_delete_device(&ns->mpath_device);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D8
