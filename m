Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24D9490C1E
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 11:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781748; cv=none; b=ASjrrXWzIaWS9hV/WsLQR5Sx8foWz/7cz0V+CLIk/eBspW7i0WPYKqDMrgdtYiG0EkXBzG9hh8e5B2R4Sgjvb+Qb/FlMPFgr7Y470DiGmVLNV+ATWY50ma66LU4UJGQeABog779HQuvXTLTTDvL0sDtidSdeQnt8pshz3FCFB8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781748; c=relaxed/simple;
	bh=pkuTnnB1v0HJSZnPasjcPYLnT39JZlY4iJQ8JDoRMEA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OZVPTOD7eSqNgJFAW0YJPA/tR2hHF81Bhl/rp4AdGvenL89YzZhPw0EtH8/jF5cdadgckyflqIEFU/T4ICKYGYGpLnCjBkKaDg7cJ+U4yH+H4YEhGQHRk/hHL/FCOB7dBH+p2EV4OJ2udBVcD3yimU8zqqfNRN1BYBj1i3ADl3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEsxL3Ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEsxL3Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC7C1F00A3A;
	Mon,  7 Sep 2026 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781746;
	bh=PY3lu4FE/7wLJe4FABa5LBLuY00x80IXssdmRFf3VdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eEsxL3LdAOFNjMdQOGQAEiJgbiJFzCKkH7uih7sowYw2gfRkQ+bgnqZPiSZsJ3JzZ
	 erMO5OztrKgfBojh5Avz86id3V7I70VXf4vvXyX20/DFZsr6c7IFBJW6ZGy111VQOa
	 zUYweRJ8rnOE5s0rFxhHbzJAlIzQKc8HKVNVhu1yg2zT/AIVnQRs8ZNWnVFYEXP+1W
	 Ks3WCpcU0CiSPmCP4onoh9itgRUP7j79+c7yARvmHhBzn/FeOWNIWya5VG+/pDKgt5
	 d7CJdV2cxD1FqU9dt6Z6Owf3GEhh5jxv08UFq17HSaH5D47FQ16PvvLTEhnTuFUGCJ
	 Tycl8xZdv79Rg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 16/27] scsi-multipath: clear path when device is
 blocked
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-17-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-17-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 11:49:05 +0000
Message-Id: <20260907114906.3EC7C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Lockless and unrefcounted access to `sdev->scsi_mpath_dev` in `scs=
i_device_block()` leads to Use-After-Free and Null Pointer Dereferences dur=
ing concurrent device initialization or removal.
--

commit 352c419b223cf3635501b6ef6ac4632a3b017a6d
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clear path when device is blocked

This commit adds scsi_mpath_dev_clear_path() and calls it from
scsi_device_block() when a device path becomes blocked.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 48aab0df30b76..56200a7f5c748 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -3009,6 +3010,8 @@ static void scsi_device_block(struct scsi_device *s=
dev, void *data)
>  		scsi_stop_queue(sdev);
> =20
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((err =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);

[Severity: High]
Can this lockless access to sdev->scsi_mpath_dev lead to a use-after-free
during concurrent device removal?

If __scsi_remove_device() drops the reference and clears scsi_mpath_head,
and scsi_device_block() races with it, it drops state_mutex and then reads
sdev->scsi_mpath_dev locklessly. Could it proceed to call
scsi_mpath_dev_clear_path() and dereference freed pointers?

> =20
>  	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>  		  __func__, dev_name(&sdev->sdev_gendev), state);
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 68fe50f62158c..b16fe6a55fa73 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -238,6 +238,16 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +       struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_devi=
ce;
> +       struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_=
mpath_head;
> +       struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;

[Severity: High]
Are these pointers safe to dereference during concurrent device
initialization?

When scsi_mpath_dev_alloc() calls scsi_multipath_sdev_init(), it assigns
sdev->scsi_mpath_dev early, before fully initializing the pointers.

If a concurrent scsi_target_block() transitions the device to SDEV_BLOCK,
could it call scsi_mpath_dev_clear_path() and dereference an uninitialized
or null scsi_mpath_head here, resulting in a crash?

> +
> +       if (mpath_clear_current_path(mpath_device))
> +               mpath_synchronize(mpath_head);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D16
