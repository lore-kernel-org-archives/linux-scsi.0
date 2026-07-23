Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5796429CD5
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800719; cv=none; b=o/XQw0SD84fcxjVS29+s5CNyRkKhvm4W6ap6aDUQpTw0/GCG+6RmMZZYd+b8hWqLNidUuPXuuew4LyDeosw6uvwgu7yLrj7uKqhZNqN/HY6hb+zIkZkz9R1ks6N+Z01/kox7afxzYAn8+mUUUK+crvVQek1TmX9IednZWmRwh/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800719; c=relaxed/simple;
	bh=iYhKu/S9OJP0mzm/E1l2J9T4Wb6wn1naOHdyJAqnsM8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EoheuJ7Dbvqo1Ic41fCmPxhfL74V2e01EKLI0niArhxqimd8eulKTmOxrTotxiSRWsqkLJoNZ1K33depYrK8/A+5/TWm8jngrl/tVY0dahv2HVParPQvZp/IQEvhkgVAEkGYlsNsolZYqfeE5KaMx8VhYn5l6gOwJTIhrjMmGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdg/mv7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdg/mv7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326961F000E9;
	Thu, 23 Jul 2026 09:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784800718;
	bh=LcFmjUa2fzU72TR+13CfJfz1RP8l1BN9b4Xp4zYUlt0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bdg/mv7UwrL1/Z8Jvep5gxqB/oVEZ123iycx7W5Cf4Cq4rxYnci9LoRXto+Xf42q+
	 HNgy40tE9rpvSZ4Ctq1vPxfafYkdMt8jzDoDqjK7+Iq9hx7+fpy6/rzQOKJkJc9o3B
	 Ksf24aDxO8cS9KHZTrJkJs1rbOwk8TdVzi3Ok3quviaDJMjNwsdQ4IGzKqUlrTjZJv
	 vqyn0rbmtTnDzVlyExKL5O5CIRmdujgDpcZg8ZBImHsUxPyeJHLqtmIVylrskTnXwv
	 VjPRQEHW4q6nqo10z9YgnXlhdVG5YOE41iNstnyGwAdqBKMR/ulRhPs5R+FoJ0p09M
	 a8Xva8vsegUOg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/28] libmultipath: Add support for mpath_device
 management
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-6-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:58:32 +0000
Message-Id: <20260723095834.326961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mpath_delete_device fails to clear the device from the current_pat=
h array before calling mpath_synchronize, guaranteeing an RCU Use-After-Fre=
e.
- [Low] Duplicate function declaration of `mpath_synchronize`.
--

--- Patch [5]: [PATCH v4 05/28] libmultipath: Add support for mpath_device =
management ---
commit 729c9713b67dacb1c3c3c943a84db42ae105702d
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add support for mpath_device management

Add support to add or remove a mpath_device as a path. This implements
functionality similar to NVMe equivalents for path management.

> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> index 57d13eb1450cd..6915c2a979642 100644
> --- a/include/linux/multipath.h
> +++ b/include/linux/multipath.h
[ ... ]
> @@ -89,6 +92,17 @@ static inline enum mpath_iopolicy_e mpath_read_iopolic=
y(
>  void mpath_synchronize(struct mpath_head *mpath_head);
>  int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
>  int mpath_get_iopolicy(char *buf, int iopolicy);
> +bool mpath_clear_current_path(struct mpath_device *mpath_device);
> +void mpath_synchronize(struct mpath_head *mpath_head);

[Severity: Low]
This isn't a bug, but should we remove this duplicate declaration of
mpath_synchronize() since it is already declared just a few lines above?

> +int mpath_add_device(struct mpath_device *mpath_device,
[ ... ]
> diff --git a/lib/multipath.c b/lib/multipath.c
> index 448d879abb354..20c633ad7e1df 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
[ ... ]
> @@ -50,6 +50,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
[ ... ]
> +bool mpath_delete_device(struct mpath_device *mpath_device)
> +{
> +	bool empty;
> +
> +	mutex_lock(&mpath_device->mpath_head->lock);
> +	list_del_rcu(&mpath_device->siblings);
> +	empty =3D list_empty(&mpath_device->mpath_head->dev_list);
> +	mutex_unlock(&mpath_device->mpath_head->lock);
> +
> +	mpath_synchronize(mpath_device->mpath_head);

[Severity: High]
Does this leave a dangling pointer in the current_path array that could
lead to a use-after-free?

Since the deleted device isn't cleared from mpath_head->current_path[],
new I/O submissions starting after mpath_synchronize() returns could still
read the device from current_path and use it after it's been freed.

If a caller tries to avoid this by calling mpath_clear_current_path()
before mpath_delete_device(), concurrent I/O could potentially re-select
the device from dev_list and place it back into current_path before the
deletion acquires the list lock.

Should mpath_clear_current_path() be called here, exactly between
list_del_rcu() and mpath_synchronize()?

> +
> +	return empty;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D5
