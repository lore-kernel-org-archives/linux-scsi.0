Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4999D3BE17D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801818; cv=none; b=EtEmJnufhYTUEEfzO3j0OCAJt9sYh10LiXGBknB963pqPatoVpsLlLAyTJ0GL7RI1DhUmYx3BxbhWno1K49oZpYEfAMUVSicbzJ/WpdpzOdHT51rGeOsYOFRC3dtrK9fVW8B2Ymqv+Aa7vn6jvLNdyS1DZbHFvHOw5UtDhzXEzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801818; c=relaxed/simple;
	bh=vD3FjZTw65Xit4FohWnU693wLlz7q5n65SMD9G12WjE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u2fu/L5wQ6HevFXo62hxM4nq2JQjyIqr+KX+d0a+YAP68p0EkfMeJ9RVCn9XKMzcr4VHXBsAyJJVwrE+oGQfTO1VaW2JW8KAbjycTY/DpjLrOTRcuV0KPlpXAMUPQMqahpDLMBkxZgWEKT2a2lsmw5jyYtB8Ke49unNnWIezAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbhHUdvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbhHUdvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50091F000E9;
	Thu, 23 Jul 2026 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801817;
	bh=x2PNG66q9qA8wHkHZlzqcotUTXHlsIVoDfNF2+4vjP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bbhHUdviE5KBR98JTAn/0+tLiez7pgtxOogvdv1PmgDtoT8cUwt7T9z/y5Bg0j2lj
	 wtXhgdSdVdhPjYKSUXo/nHh6YPu23jYuZfexCsKxFWYE2WTuWjdZQ8YbOTnI6/GKWl
	 ReDG+oH1DvekffTK0frnECTuFfzyO89C5m6wYKutfPWoZqxVUz5sKc41xoZxf6TX7j
	 PKzxcp9UpR3iQK6Bfd9QKpRN8iYzitPSfPmH0ipnP80mjhFRvnkcAsF1CiW3YQNLZw
	 0w54zw607yoMTCiUe1mTK1VmJpQnJM38KAIdYFj2iNdzP/WT2zAgE1gpMLFFNrtFLu
	 8kx1nS7dolY1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 13/28] scsi-multipath: introduce scsi_device head
 structure
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-14-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-14-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:16:56 +0000
Message-Id: <20260723101656.C50091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] `scsi_mpath_find_head()` prematurely aborts list search on dying h=
eads, leading to split multipath topologies.
- [High] Double removal in `scsi_mpath_remove_device()` triggers a NULL poi=
nter dereference.
- [High] Premature teardown of `scsi_mpath_head` causes a Use-After-Free on=
 inflight bios.
- [Medium] The sysfs attribute `vpd_id` is exposed to userspace before it i=
s initialized.
--

--- Patch [13]: [PATCH v4 13/28] scsi-multipath: introduce scsi_device head=
 structure ---
commit 11c848a95f46ee71e21d42eee402d581f96c8055
Author: John Garry <john.garry@linux.dev>

scsi-multipath: introduce scsi_device head structure

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index b9b58a3641aa2..609f8009e4ac3 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> @@ -89,6 +141,71 @@ static int scsi_multipath_sdev_init(struct scsi_devic=
e *sdev)
> +static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
> +{

[ ... ]

> +	ret =3D device_add(&scsi_mpath_head->dev);
> +	if (ret) {
> +		put_device(&scsi_mpath_head->dev);
> +		return NULL;
> +	}
> +

[Severity: Medium]
Will calling device_add() here expose an uninitialized vpd_id string to
userspace when the uevent is fired?

The vpd_id is only populated later in scsi_mpath_dev_alloc() via strscpy().
Could a concurrently executing udev rule read an empty string before the
string has been properly set?

> +	return scsi_mpath_head;
> +
> +out_uninit_head:
> +	mpath_head_uninit(&scsi_mpath_head->mpath_head);
> +out_free:
> +	kfree(scsi_mpath_head);
> +	return NULL;
> +}
> +
> +static struct scsi_mpath_head *scsi_mpath_find_head(
> +			struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head;
> +
> +	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
> +		if (strncmp(scsi_mpath_head->vpd_id,
> +			scsi_mpath_dev->device_id_str,
> +			SCSI_MPATH_DEVICE_ID_LEN) =3D=3D 0) {
> +			if (scsi_mpath_get_head(scsi_mpath_head))
> +				return NULL;

[Severity: High]
If scsi_mpath_get_head() fails (for example, if the head is dying), does
returning NULL here prematurely abort the list search? Should this be a
continue statement so we don't skip over a valid head further down the
list?

> +			return scsi_mpath_head;
> +		}
> +	}
> +
> +	return NULL;
> +}

[ ... ]

> @@ -133,13 +290,47 @@ void scsi_mpath_dev_release(struct scsi_device *sde=
v)
> +void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_mpath_=
head;
> +
> +	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
> +
> +	scsi_mpath_remove_head(scsi_mpath_dev);
> +}
> +
>  void scsi_mpath_dev_release(struct scsi_device *sdev)
>  {
>  	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> =20
> +	if (scsi_mpath_dev)
> +		scsi_mpath_remove_device(scsi_mpath_dev);

[Severity: High]
Is it possible for this to trigger a NULL pointer dereference if the
multipath device has already been detached?

In __scsi_remove_device(), we call scsi_mpath_remove_device() which sets
scsi_mpath_dev->scsi_mpath_head =3D NULL:

__scsi_remove_device()
    scsi_mpath_remove_device(sdev->scsi_mpath_dev)
        scsi_mpath_remove_head()
            scsi_mpath_dev->scsi_mpath_head =3D NULL;

When the device release callback runs later, it will call
scsi_mpath_remove_device() again because scsi_mpath_dev is still non-NULL,
leading to a crash when dereferencing scsi_mpath_head.

>  	scsi_multipath_sdev_uninit(sdev);
>  }

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 2f80d703ce640..d6bbaf424bd4a 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1501,6 +1501,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	} else
>  		put_device(&sdev->sdev_dev);
> =20
> +	if (sdev->scsi_mpath_dev)
> +		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
> +

[Severity: High]
Could tearing down the multipath head here trigger a use-after-free for
inflight bios?

If this is the last path, the scsi_mpath_head could be unregistered and
freed before the request queue is drained in blk_mq_destroy_queue() later
in this function. When an inflight bio completes, its end_io callback might
try to access the freed head.

Should the multipath head removal happen after the queue is drained?

>  	/*
>  	 * Stop accepting new requests and wait until all queuecommand() and
>  	 * scsi_run_queue() invocations have finished before tearing down the

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D13
