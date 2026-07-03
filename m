Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A1D3ACA77
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075762; cv=none; b=mEpf/vfudWV+ZhkPSmjBgUfXVQM4XLYUFST7gv33k4WGQv+j8SMvQ6P788wleXqOgrH5gT0wj4XU5I1zN3A8L+ozeB6qw3SwSzXZbvajbZ2K9z9QcbQ0HMomMAxD3tJkyTaTWxFyH/K62kOIrI8WLp/+DGHrc9SFkbWmsf0tH3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075762; c=relaxed/simple;
	bh=VNPxXkwn6wAPB4nOsAssBcKFFGanhd613MjQ/aUPKTo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Sj/7XPTyELXi46tXaeSma4eT094kGOJniKqYwZr9TnqbbHMO6JpW1DqPVWa0YuDqPp83Z1w6m33kBh+N/OkE+BITe2GzfV8qWtktxsZZLzNvhUHADOiEpIpWi6rFCr6RtY/5pVkEhOPjqxexoH1djmzOmfwyt/UCjV4bAG4w/lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLKVXeUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLKVXeUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2095C1F000E9;
	Fri,  3 Jul 2026 10:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075761;
	bh=hGBsaqb9ji6fy3bxS1fsfbyfbyBJq458moLK45gVvMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jLKVXeUN8I+Qo9ldZU2tvRpX274oDKB6pA+dstdoVum5Xq0I6zwTI1KqMnsod5r+V
	 ZCUGskE+EeaELiUk4/2CiaIMCJMS1bqj7QIovTeelu/oas2yiB6MT0Ym9yTEIMXkCG
	 4J+cFNq1gJawqHMQWr/xm5ETmZVNtWYoGxzP49MVAOtmpoPTLr6n+c8c7OWJxzxU2/
	 2Zdt+L70u05j0BMTpLw2rzIHZkJcxboJvFr/m5INM/EZQW9IP9M+nWlEkj4hO9NZjm
	 5mrwbJz+fHG9+vSvDpyo/cSozQ/7izkzFvtObElWJwwBNDHPRXIQlzWaCZ3OsS84J/
	 PXL6uDTFwwUnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/17] scsi-multipath: introduce scsi_device head
 structure
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-3-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:49:20 +0000
Message-Id: <20260703104921.2095C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Self-deadlock in scsi_mpath_find_head() due to kref_put() triggeri=
ng release while holding scsi_mpath_heads_lock.
- [High] Double-free and use-after-free of scsi_mpath_head in the error pat=
h of scsi_mpath_alloc_head().
- [High] NULL pointer dereference and invalid device_unregister() execution=
 when tearing down a failed device_add() in scsi_mpath_dev_alloc().
--

commit d7eb5e4fb506178f4a58d8aa264acf8230ebb5fa
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: introduce scsi_device head structure

This patch introduces a scsi_mpath_head structure to manage multipathing
for a scsi_device. It maintains a list of scsi_mpath_head structures
to look up matching multipathed devices by their unique ID. A new sysfs
device class is also added to manage the scsi_mpath_head device members.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index ff37cfdf2f9d1..65ee3da5cc7fc 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -88,6 +146,71 @@ static int scsi_multipath_sdev_init(struct scsi_devic=
e *sdev)
[ ... ]
> +static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
> +{
[ ... ]
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
Will this cause a double-free on the error path?

If dev_set_name() fails, put_device() is called which triggers the
scsi_mpath_head_release() callback, freeing the IDA and the structure itsel=
f.

The code then falls through to the out_free_ida label which calls ida_free()
and kfree() a second time on the already freed pointer.

> +
> +static struct scsi_mpath_head *scsi_mpath_find_head(
> +			struct scsi_mpath_device *scsi_mpath_dev)
> +{
[ ... ]
> +	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
> +		ret =3D scsi_mpath_get_head(scsi_mpath_head);
> +		if (ret)
> +			continue;
> +		if (strncmp(scsi_mpath_head->vpd_id,
> +			scsi_mpath_dev->device_id_str,
> +			SCSI_MPATH_DEVICE_ID_LEN) =3D=3D 0) {
> +
> +			return scsi_mpath_head;
> +		}
> +		scsi_mpath_put_head(scsi_mpath_head);
> +	}
> +
> +	return NULL;
> +}
[ ... ]
> @@ -116,13 +240,58 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
[ ... ]
> +	mutex_lock(&scsi_mpath_heads_lock);
> +	scsi_mpath_head =3D scsi_mpath_find_head(sdev->scsi_mpath_dev);
> +	if (scsi_mpath_head)
> +		goto found;
> +	scsi_mpath_head =3D scsi_mpath_alloc_head();
> +	if (!scsi_mpath_head) {
> +		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, dev=
ice multipathing disabled\n");
> +		mutex_unlock(&scsi_mpath_heads_lock);
> +		goto out_uninit;
> +	}
> +
> +	strscpy(scsi_mpath_head->vpd_id, sdev->scsi_mpath_dev->device_id_str,
> +			SCSI_MPATH_DEVICE_ID_LEN);
> +
> +	ret =3D device_add(&scsi_mpath_head->dev);
> +	if (ret) {
> +		mutex_unlock(&scsi_mpath_heads_lock);
> +		goto out_put_head;
> +	}
> +
> +	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
> +found:
> +	mutex_unlock(&scsi_mpath_heads_lock);
[ ... ]
> +out_put_head:
> +	scsi_mpath_put_head(scsi_mpath_head);
>  out_uninit:
>  	scsi_multipath_sdev_uninit(sdev);
>  	return ret;
>  }
[ ... ]
> +static void scsi_mpath_free_head(struct kref *ref)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +		container_of(ref, struct scsi_mpath_head, ref);
> +
[ ... ]
> +	mutex_lock(&scsi_mpath_heads_lock);
> +	list_del_init(&scsi_mpath_head->entry);
> +	mutex_unlock(&scsi_mpath_heads_lock);
> +
> +	device_unregister(&scsi_mpath_head->dev);
> +}

[Severity: High]
Could this lead to an AB-BA self-deadlock?

The scsi_mpath_dev_alloc() function acquires scsi_mpath_heads_lock before
calling scsi_mpath_find_head(). During iteration, scsi_mpath_find_head()
takes a temporary reference to each head.

If a concurrent thread drops its reference to a head just as we process it,
our scsi_mpath_put_head() call might drop the refcount to 0.

This would trigger scsi_mpath_free_head(), which unconditionally tries to
acquire scsi_mpath_heads_lock. Since the non-recursive mutex is already held
by the current thread in scsi_mpath_dev_alloc(), it appears this would free=
ze
the thread.

[Severity: High]
Is there a risk of a NULL pointer dereference and invalid device unregistra=
tion
here if device_add() fails?

If device_add() fails in scsi_mpath_dev_alloc(), we jump to out_put_head and
call scsi_mpath_put_head(). This drops the refcount to 0 and triggers this
cleanup function.

However, the scsi_mpath_head was just allocated with kzalloc and never added
to the list, so entry.next and entry.prev are NULL. Calling list_del_init()
would dereference these NULL pointers.

Furthermore, calling device_unregister() will invoke device_del() on a devi=
ce
that failed device_add(), which violates the driver core API.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D2
