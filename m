Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199FC3C9886
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076665; cv=none; b=JLKp6BkvhiMR1xfYHcPF/+Ka1pWddV5kynO4NQfzNvqzlb9noCBUuFyqZ0mHNh/gd5rGhlRj1CGoEksDrqydgNwm+Ah1nCzQsX2XnAsrivCQUFvPno6LRBChVELdNE6gbuiiHW8bgYwMCX6jl56SjWdPAJ9Ix677hHx01yYeogw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076665; c=relaxed/simple;
	bh=Lh+TN5fZQFC7Nt3ycZ65nPn6trjAnlFaoQ9PAGX0ljc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=huI4NMrism/vA4cfXHYogmfsvHTF8505CS7jEqC/wrvPTjdYpChrgNo3z2DMQ6XJt7mPzd86cAkcKrH37z5P/cXsAP6Vz84peDIUntxarlzXvpHVjQD5u9G8EVN1jXvvkAoPZrMy5OAF7oIaVbdPf5pTibmpqjNZWETnToyleTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekt1H7V8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekt1H7V8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A480E1F000E9;
	Fri,  3 Jul 2026 11:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783076663;
	bh=UNbg9l43cddvZV0jVX1LEgnOu27p4ujR3UtYBc3WbjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ekt1H7V8lYkJ679wqunxJ0/2Z3Crp8z8vrJWpHsTdERkar0vRlxjT3bhdRMxTBDsl
	 1u8gJGa8ZWFNbEDlEuJXkrGkSg1oyH0tQz1iF3Avj7l5+A40HCKWZkGLnwPo0qaDYa
	 jSJ7xMm9gTC0R0sML4tjtsZivGHuoDQoUgdmFrLOoBxeeM/wD4nqPfmJA7PvxtGrj/
	 /9+O+RD0RilBj+Nwfm2b7tacl4LqWMMVFBaznUHKG+D+XznpQ0ENnvt8woDVm5WMCy
	 HAz0hPKmeYotg0BmG1SnIvWiDktkH0CtZ4RCeorLw7HWUY+1yW5UBENRuaN88Wz+ch
	 eyLa3c2Pg1ndg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/17] scsi-multipath: provide sysfs link from to
 scsi_device
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-4-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:04:23 +0000
Message-Id: <20260703110423.A480E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Double free and use-after-free of `scsi_mpath_head` on `dev_set_na=
me()` error path.
- [High] NULL pointer dereference from uninitialized `list_head` on `device=
_add()` error path.
--

commit d7eb5e4fb506178f4a58d8aa264acf8230ebb5fa
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: introduce scsi_device head structure

This commit introduces the scsi_mpath_head structure to manage multipathing
for SCSI devices. It adds a list to look up matching multipathed SCSI devic=
es
using their unique IDs and creates a new scsi_mpath_device_class for managi=
ng
the head devices.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index ff37cfdf2f9d1..65ee3da5cc7fc 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -88,6 +146,71 @@ static int scsi_multipath_sdev_init(struct scsi_devic=
e *sdev)
[ ... ]
> +static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head;
> +	int ret;
> +
> +	scsi_mpath_head =3D kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
> +	if (!scsi_mpath_head)
> +		return NULL;
[ ... ]
> +	device_initialize(&scsi_mpath_head->dev);
> +	scsi_mpath_head->dev.class =3D &scsi_mpath_device_class;
> +	ret =3D dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
> +				scsi_mpath_head->index);
> +	if (ret) {
> +		put_device(&scsi_mpath_head->dev);
> +		goto out_free_ida;
> +	}
> +
> +	return scsi_mpath_head;
> +
> +out_free_ida:
> +	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
> +out_put_head:
> +	mpath_put_head(&scsi_mpath_head->mpath_head);
> +out_free:
> +	kfree(scsi_mpath_head);
> +	return NULL;
> +}

[Severity: High]
Does this error path cause a use-after-free and double free?

If dev_set_name() fails, put_device() drops the kobject refcount to zero,
which triggers scsi_mpath_head_release() to free the IDA index and kfree
the scsi_mpath_head structure.

When the code falls through to out_free_ida, it attempts to free the index
again using the already-freed pointer, and finally calls kfree() a second
time.

> @@ -96,6 +219,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_dev=
ice *sdev)
[ ... ]
>  int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>  {
> +	struct scsi_mpath_head *scsi_mpath_head;
>  	int ret;
[ ... ]
> +	ret =3D device_add(&scsi_mpath_head->dev);
> +	if (ret) {
> +		mutex_unlock(&scsi_mpath_heads_lock);
> +		goto out_put_head;
> +	}
> +
> +	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
> +found:
> +	mutex_unlock(&scsi_mpath_heads_lock);
> +	ret =3D ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
> +	if (ret < 0)
> +		goto out_put_head;
> +	sdev->scsi_mpath_dev->index =3D ret;
> +
> +	sdev->scsi_mpath_dev->scsi_mpath_head =3D scsi_mpath_head;
> +	return 0;
> +out_put_head:
> +	scsi_mpath_put_head(scsi_mpath_head);
>  out_uninit:
>  	scsi_multipath_sdev_uninit(sdev);
>  	return ret;
>  }

> @@ -133,13 +302,47 @@ void scsi_mpath_dev_release(struct scsi_device *sde=
v)
[ ... ]
> +static void scsi_mpath_free_head(struct kref *ref)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +		container_of(ref, struct scsi_mpath_head, ref);
> +
> +	/*
> +	 * If we race with scsi_mpath_find_head(), then that function may
> +	 * find this scsi_mpath_head in the heads list; however we would fail
> +	 * to take a reference to this scsi_mpath_head and continue the search.
> +	 * As such, it is safe to call device_unregister (and free
> +	 * scsi_mpath_head) after we delete this head from the list.
> +	 */
> +	mutex_lock(&scsi_mpath_heads_lock);
> +	list_del_init(&scsi_mpath_head->entry);
> +	mutex_unlock(&scsi_mpath_heads_lock);
> +
> +	device_unregister(&scsi_mpath_head->dev);
> +}

[Severity: High]
Can this list_del_init() and device_unregister() crash if called from the
device_add() error path in scsi_mpath_dev_alloc()?

If device_add() fails, scsi_mpath_put_head() is called, which eventually
invokes this cleanup function. However, because device_add() failed before
list_add_tail() was called, and the list head was never initialized on the
kzalloc-ed structure, the list pointers are NULL. This would cause a NULL
pointer dereference in list_del_init().

Additionally, device_unregister() expects the device to have been
successfully added, which isn't the case on this error path.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D3
