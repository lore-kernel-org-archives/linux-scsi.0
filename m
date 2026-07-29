Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5CD3E765A
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 14:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336151; cv=none; b=BtIbrm5OngmInHb3eotp/mWKno9SpWs9rnQtW7mBNxj9idQ2ZMOiUcYOPbQR5uiTZZS27gK1E5fwFlzbW08O2X505d92EI6VCpherNRu3I60FQFbT3xBBh638XItMy8mXSPhA1hWlN9q6iXBuB7y5W8DtHq+8QdpSOax4+8XnUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336151; c=relaxed/simple;
	bh=fVofh+SHdKt8IsZ3+KKkaDHfaRQwNAFOaiaZOAju4Jw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=keZsRnwRpkUtT2dR4NeWg2ysw+GRZnzkICfr1uf3FWSu0lL3tmudNWR6i+3c26Iu5oP2N8zyAyg4x3SQzSEErKYoejbNtQUQ6Wwo2GKCSo/p3hERB/M77P0Skry/l54Ic5s7OR0h5nHVBC0WZ0Ri5S/euEC5edNaffpJhGGxXQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yo6dQPNu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yo6dQPNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDF21F00A3A;
	Wed, 29 Jul 2026 14:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336150;
	bh=ogkYACyjS29+sfhIPpSp0AYwfVZZzJDa5xcRoeqVsW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yo6dQPNuDjZokiMNyRpwb3dPpCwqWo3Ou8ZmtrVzypshvtllY4WZdzvwBlJs0Te0M
	 Vb+JdocD1r4CYzJNNTKptMRaid9vE68N89y1oJ6q5cZ7Ch8jhyk3WE2aqYCeNCmgxQ
	 R8g/zPiNWhrm2XplZDH9ieX3Sm6XpbyKAa6lsATQyI1+efOhHW4BOH6sbCKSplWZqZ
	 uwmW+2Bqn0m24IvTTbqH22uW9YDirSSUzQIgs5nsiOBExdtlmbmvJymi8MJuaTAuwB
	 YyoVhTDyHAEEDR5hpYNSB6HX6KQkp68arpuBqU9Qd5Veum3o0hWKEgrGSlsRoC32hS
	 p3WyUfFMy2Cbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 16/27] scsi-multipath: clear path when device is
 blocked
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-17-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-17-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 14:42:29 +0000
Message-Id: <20260729144230.4BDF21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unprotected, lockless access to `sdev->scsi_mpath_dev` in `scsi_de=
vice_block()` causes NULL pointer dereferences and Use-After-Free (UAF) bug=
s when racing with device initialization or teardown.
--

--- Patch [16]: [PATCH v6 16/27] scsi-multipath: clear path when device is =
blocked ---
commit 8f07d9f873129f9ecc9b8d3d02fee5bce667c745
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clear path when device is blocked

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index daeb3693fe559..a1ec11050090c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c

[ ... ]

> @@ -3008,6 +3009,8 @@ static void scsi_device_block(struct scsi_device *s=
dev, void *data)
>  		scsi_stop_queue(sdev);
> =20
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((err =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);

[Severity: High]
Is it safe to access sdev->scsi_mpath_dev without holding state_mutex?

When scsi_alloc_sdev() adds a new device to shost->__devices, it becomes
globally visible. Then scsi_mpath_dev_alloc() sets sdev->scsi_mpath_dev but
leaves scsi_mpath_head as NULL while issuing SCSI VPD queries.

If a concurrent error on the bus triggers scsi_device_block(), it could
read the partially initialized sdev->scsi_mpath_dev here outside of any loc=
ks.

Additionally, if scsi_mpath_dev_alloc() encounters an error and frees
sdev->scsi_mpath_dev, could reading it here cause a use-after-free?

During teardown, if __scsi_remove_device() is called concurrently with
scsi_device_block(), the teardown thread might set scsi_mpath_head to NULL.
Can this lead to a NULL pointer dereference when evaluating
scsi_mpath_dev_clear_path()?

> =20
>  	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>  		  __func__, dev_name(&sdev->sdev_gendev), state);

[ ... ]

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 0d439cac6447a..b23cd6f12c602 100644
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
Does this code dereference a NULL pointer if it races with initialization or
teardown?

If scsi_mpath_head is NULL due to the races mentioned above, deriving
mpath_head from it will calculate an invalid pointer.

> +
> +       if (mpath_clear_current_path(mpath_device))

[Severity: High]
Could calling mpath_clear_current_path() with a partially initialized
mpath_device lead to a NULL pointer dereference?

If mpath_device->mpath_head is NULL, it will trigger an immediate dereferen=
ce
in the multipath code:

lib/multipath.c:mpath_clear_current_path() {
    ...
	struct mpath_head *mpath_head =3D mpath_device->mpath_head;
    ...
		if (mpath_device =3D=3D
			rcu_access_pointer(mpath_head->current_path[node])) {
    ...
}

> +               mpath_synchronize(mpath_head);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D16
