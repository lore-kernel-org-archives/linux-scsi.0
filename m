Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1A633F8B2
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261179; cv=none; b=gEFYmoin/XOv/dxTMX80djYoW5XJgjtWJhkCJ87gCYfE8MX0RGfX/09kjb6kXyGhydAQaxDObolGF8sPyQHccIYFNmJurMvGk8T4OC31GpxJdKunbDdckgweJIlp7PQHlPrgNiC3SV2PUv8pDFa7PpjjwbPLjLPFTg/bAUSQPZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261179; c=relaxed/simple;
	bh=xGVboixLhSHeuGLiaqF8ZCv+Ge5hGiYqvjyqKSGC2y8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UhZNP88xyQL2GSzGAu11ndbZFMb46keXhUF8fYLvMMFuMl5UsJ+k9LDUaKy1iIrCAWiV/c/Wd8VdtbTC5YKcfGYglJ8MeNoB7rAwK2/YYIIEw0s8MyT3F6cSk6+LE+7Gkpi9e3egN4FiYb63N0wkZc2YKUrUrYNr8q8HtHxuW38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWdRcy/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWdRcy/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9381F000E9;
	Tue,  1 Sep 2026 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788261178;
	bh=ggujpnDY4WeVxDnJTf8ufwsc1VlHmFs15zGGwkQTrrs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IWdRcy/d3XZP2IP5pNxT6ZCxxG1CsCA3wBqwCzBQVC/bF4d+cEbfAycLpZdPF4SbQ
	 9kU0C8vgiuW55DipZEHulQAKar1kTk4fJnN0j6nSsoCeu62BwWakqiiGQdMa3vWoCS
	 sx9iknaIygHABRTLq/K4H39G2buw5xTbv41N67XahXIWU7biYL27xKUNBZ2pzdwXFZ
	 pr6m46mSQJKOM2QecUH5g2nQFV0+2M9i/WpIdWprvZoF306jz6Uti/R1pnKYrLB4kD
	 5AtcimKLWXuyCoKO8Pz1C+pDbGvmJfehKniA18+OpV7DkfbBeASGN7tPiCv7eT7Xg2
	 uMM7s4xaQ0MoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 17/27] scsi-multipath: revalidate paths upon device
 unblock
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-18-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-18-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:12:57 +0000
Message-Id: <20260901111258.4F9381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unsynchronized access to `sdev->scsi_mpath_dev` in `scsi_internal_=
device_unblock()` races with device initialization, leading to a NULL point=
er dereference or Use-After-Free.
--

commit 9827c5b37e1215c845ce584c07c0fadae92e797b
Author: John Garry <john.garry@linux.dev>

scsi-multipath: revalidate paths upon device unblock

This commit revalidates paths when a scsi_device is unblocked. It clears
any paths and requeues queued bios as part of the revalidation process.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f02b3a50e20cd..189263ce56624 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3093,6 +3093,8 @@ static int scsi_internal_device_unblock(struct scsi=
_device *sdev,
>  	mutex_lock(&sdev->state_mutex);
>  	ret =3D scsi_internal_device_unblock_nowait(sdev, new_state);
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((ret =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);

[Severity: High]
Does this lockless access to sdev->scsi_mpath_dev race with device
initialization?

If a transport unblock event occurs concurrently with hardware discovery,
scsi_internal_device_unblock() might read sdev->scsi_mpath_dev while it is
being initialized.

For instance, scsi_multipath_sdev_init() publishes the pointer before
initialization is fully complete:

drivers/scsi/scsi_multipath.c:scsi_multipath_sdev_init() {
    ...
    scsi_mpath_dev->sdev =3D sdev;
    sdev->scsi_mpath_dev =3D scsi_mpath_dev;
    ...
}

Could calling scsi_mpath_revalidate_paths() here lead to a NULL pointer
dereference when it attempts to access an uninitialized scsi_mpath_head?

Additionally, if initialization fails and the structure is freed in the err=
or
path, could this result in a use-after-free?

> =20
>  	return ret;
>  }

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D17
