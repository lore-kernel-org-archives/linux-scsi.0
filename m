Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E124C042D
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336869; cv=none; b=MGkrXfiFNMOxuyNlXk4IvUDXJos/boDm0zhmFcP7D6Bjxx6MaCKggWiXZK3H6Yr8RowsQTrZ3UPHSWUUvI5r6KspBgBsuupPocLskycfZv34EAZrpYKYfCuNxjr8GGmNaOAsfkM2uwij+CqnrZW4+8EuiL246GiWe3eFTCExPjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336869; c=relaxed/simple;
	bh=p7SPjLGvPK/vzxHtDMKtawyN4MFMQxpYs1vq9JPNEto=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AERKOXbvMJIh+QjhUUHmptydhWf+JZ4RpXr0tW/7GlmLIBKuTUxFSTKAjVdDFcLvRxVuhQ3UDBrE59idk+Fbo0cr8VuIPQ6yOy8NGBU74kstLpJZufl2xAwnrxlRa2vQLhH+BVSIrFqTsV9l80Eui43jdwD2z96EnGMo8GvduFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLmHDsLU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLmHDsLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E481F000E9;
	Wed, 29 Jul 2026 14:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336864;
	bh=v/BEWQDBpcHi09CWUuOcv6F9MYBtNb27r41G1juMddY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WLmHDsLUtG6RsK8QpJhVwh4fgIqZxLx9w9X/fMFRMZzF0GswIV9YVvOMy+l9fJY6Q
	 jd8SluElWhAamMSI2P1V0H9WfdWXIhqRvqwWsDdwHl4VVvwVtMIqBE/gCevYzTR1yC
	 zUcTl0GdFS2BlTJsqdUWMo0D7tcpIuJUGjgj323x14XDENw68WDeLhfJyNEt3dZ3mS
	 h0I+QkHgd1F4HuGdbtd94YZqWh7iNuUmBu0bNwfoyp/V+Fh2PYfJ9Y/4o0fW+PBdKJ
	 7/nYNF4oH94TVjJzhCeWUtRUZJJXC8aBkTesgpbNx49jrV5KwNz6iDvXjjhRW8LF0r
	 ODFdmFqqvLEPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 17/27] scsi-multipath: revalidate paths upon device
 unblock
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-18-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-18-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 14:54:23 +0000
Message-Id: <20260729145423.D8E481F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Calling `scsi_mpath_revalidate_paths()` outside `sdev->state_mutex=
` without a NULL check leads to TOCTOU races with device removal or allocat=
ion, causing a NULL pointer dereference.
- [High] Direct callers of `scsi_internal_device_unblock_nowait` bypass pat=
h revalidation, which can leave queued bios indefinitely stalled.

Pre-existing issues:
- [High] The patch calls `mpath_revalidate_paths()`, which schedules `reque=
ue_work` on a background workqueue, but the teardown path fails to cancel t=
his work, leading to a Use-After-Free.
--

--- Patch [17]: [PATCH v6 17/27] scsi-multipath: revalidate paths upon devi=
ce unblock ---
commit 6253cb1fc352f4ec6d0d42ac99c1827b35592ff4
Author: John Garry <john.garry@linux.dev>

scsi-multipath: revalidate paths upon device unblock

When a scsi_device is unblocked, we need revalidate paths which means that
we clear paths and requeue any queued bios.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a1ec11050090c..6a2d7dbfbe8c3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3092,6 +3092,8 @@ static int scsi_internal_device_unblock(struct scsi=
_device *sdev,
>  	mutex_lock(&sdev->state_mutex);
>  	ret =3D scsi_internal_device_unblock_nowait(sdev, new_state);
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((ret =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);

[Severity: High]
Is it safe to access sdev->scsi_mpath_dev and call scsi_mpath_revalidate_pa=
ths()
outside of sdev->state_mutex?

It seems that concurrently, __scsi_remove_device() could nullify
scsi_mpath_dev->scsi_mpath_head. A similar race might exist during device
initialization before the head is populated.

When scsi_mpath_revalidate_paths() is then called, it blindly computes the
offset to &scsi_mpath_head->mpath_head, which could lead to a NULL pointer
dereference.

[Severity: High]
Does placing this hook in the wrapper bypass path revalidation for some dri=
vers?

Low-level drivers like mpt3sas and scsi_transport_srp call the core API
scsi_internal_device_unblock_nowait() directly. Since the revalidation is
only added to the scsi_internal_device_unblock() wrapper, won't devices man=
aged
by those drivers miss path revalidation when unblocked, potentially leaving
queued bios permanently stalled?

> =20
>  	return ret;
>  }
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index b23cd6f12c602..12750621a7fc0 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -238,6 +238,14 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_de=
v)
> +{
> +       struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_=
mpath_head;
> +       struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +       mpath_revalidate_paths(mpath_head);

[Severity: High]
This is a pre-existing issue, but by introducing this new asynchronous trig=
ger,
could we run into a use-after-free during device removal?

Calling mpath_revalidate_paths() queues mpath_head->requeue_work. If the de=
vice
is subsequently removed, the teardown path in scsi_mpath_head_release() fre=
es
scsi_mpath_head via kfree():

drivers/scsi/scsi_multipath.c:scsi_mpath_head_release() {
    ...
    mpath_head_uninit(mpath_head);
    kfree(scsi_mpath_head);
}

Because cancel_work_sync(&mpath_head->requeue_work) is missing from the tea=
rdown
logic, could the pending work execute on a freed mpath_head structure?

> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D17
