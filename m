Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68643BD63B
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076807; cv=none; b=LR1gT3f6YSkW7lk5BpbIR3mcTfy7Nm1iWckTGvgp3d4mFO8nS+n4IR1d0I9qyHr4KUxAomQIcwcvsmGYa3UGiKS3v1IPO9nwq/VH+g8x3IVkKN486rYOXNTprO19adNrLMvB39tFRVw0vJ4wRNMkLYdYqAW5GsgjDTNqGtQasNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076807; c=relaxed/simple;
	bh=7/qqfttO0D9ZITUuiYUzPoFWgtQAijV9whUkwQuV6RM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WnHzbqsB4+zDF1Ve/gBZA+1mjfAc8OgNW1foHjOWV0B756w0kpke12HyRrJFsXMD7uPgspn037+ysb3QivUbw818lYi94yaCQMWzz39/IjudGdI/nctbFMtQM8+q9DyNX8rXQ+qZHihOgStaXD95H56ZVPLLaLWd6/Shv1GL3FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLcKxda4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLcKxda4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568861F000E9;
	Fri,  3 Jul 2026 11:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783076805;
	bh=dyb+TJVQ53uVQJMYv+HsuMPxnR+mVqTP5prs1/XIjQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WLcKxda4ZkqcLMq7S3SaIH4r0YMt6jLhExpdPQ9l4m30bvn7SgOwZdrbh0B6HmcCc
	 JtpCW7R3MsudzlYcg6uvrd7/8t2XBKlFrCZ3g3lPz73Cc/k0TE54sPD7ouuFTKOkVE
	 uNXpwwLhPvx5SI8teuOBbmVvy1vk7EpT9EpQiU4UozrhWCoIAqaZimVFoNGAcJ+1Mt
	 v7LTSYOv/6L1sNSwTx7bh5YrKHBMa/EHgiV66vHEIKUyUi+QlNS3OCtsvDDUcn2QDY
	 XfojKj03r05RhW5hN2R8Fz4art1+DdFumyduTUqEVvWCGszjqMAdHYDbJMPe8CkzYb
	 ZCLf1bn3A7flg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/10] nvme-multipath: add nvme_mpath_is_{disabled,
 optimised}
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-5-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:06:44 +0000
Message-Id: <20260703110645.568861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch relies on missing structs, headers, and Kconfig symbols, =
causing a fatal build failure.
--

commit b4542aff5d48fe0783ce1a5c4b163d732171214c
Author: John Garry <john.g.garry@oracle.com>

nvme-multipath: add nvme_mpath_is_{disabled, optimised}

This commit adds nvme_mpath_is_disabled and nvme_mpath_is_optimized callbac=
ks
for multipath devices. It wires these up to the mpath_head_template structu=
re.

> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index e0573ca71ec60..6d3df1775dbeb 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -305,6 +305,11 @@ static bool nvme_path_is_disabled(struct nvme_ns *ns)
>  	return false;
>  }
> =20
> +static bool nvme_mpath_is_disabled(struct mpath_device *mpath_device)
> +{

[Severity: Low]
Does this patch depend on other missing patches in a series?

Compiling this change fails because struct mpath_device is an incomplete ty=
pe.
It appears other dependencies like <linux/multipath.h> or LIBMULTIPATH are
missing from the tree.

> +	return nvme_path_is_disabled(nvme_mpath_to_ns(mpath_device));
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D4
