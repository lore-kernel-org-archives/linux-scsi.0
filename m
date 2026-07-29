Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0010945518D
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339813; cv=none; b=UqRR95QDGPD137mXRGrKf3EusEkJZ4se/a+bc/F2KtILTeFk8YYk5M7imHwo7WgHRgdwvBOZrK0XkpdHI5yKoZyCHielBVGvdjFF20OT1x6vcV0kOCJct2AkYBdQcpOPC4GJnvsxSQtPksRX12o4VkgM/MxuKFZEcVf/nTieRNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339813; c=relaxed/simple;
	bh=05tY6bjDu6M2kyMVI8lo/K8w+rvcKPfgTDvTiUVpBjw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n/2bXSzsxUlHh8Q4xaZSRaZy95U5/Bc0cNmdIV41rB59BpYrQvvXJ8Bj7708tjs9X20oJ4NrLVSLagUvn30ktuuhSw1oOth9O4/harknfNKWE5Eyd8ZE9KyFPjoD038EB09lodnQ9dCZxPS5sOnBIHdDOwKcjOWWpPcoUWJO0LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1KJlqFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1KJlqFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA411F000E9;
	Wed, 29 Jul 2026 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785339811;
	bh=QFX8ERtK3R3BNOL4hydipzs0bdXweHVZeUwuiyLG/N0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P1KJlqFybj2yEm4JpWQOLH/Smomspc9+VDPvSzUF3Z884XQToJcX1fV8aARlKAic2
	 396Dw+2SYZXoPRFDVn9CXIdtrASV7hAEpsDYBsDrsZIO8F8rBKwCdvSlq0XHmt2pOE
	 BpC426ebOKw2qcnUd4jnDqa2PbX4UudfSZrmJLEiO0Z1aqCr21KtpIHMdf65fK2lI0
	 5ZtWnlU1pxcKJU8P8FSSNvLvmBbEtsfmZ7dntBh/Hcspmbb/YlcAbw9G915leqdG8R
	 1ybWqCsW4r//RFITW66TIi5ch+XGwP98L6UZ6KLthwE9lRvil8TllK8lrVYdvm4gr5
	 6Euij5CappXLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 19/27] scsi-multipath: provide callbacks for path
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-20-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-20-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 15:43:31 +0000
Message-Id: <20260729154331.6FA411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

New issues:
- [High] `scsi_mpath_is_disabled()` returns true for STANDBY paths, prevent=
ing I/O and deadlocking implicit ALUA failovers.
- [High] Bios placed on the `requeue_list` during an ALUA state change are =
permanently stalled due to missing notification hooks.
- [High] ALUA path prioritization is broken because routing policies check =
a static struct field instead of the new `.is_optimized` callback.
- [High] `scsi_mpath_available_path` ignores ALUA offline state, causing in=
definite I/O hangs instead of failing.
- [High] LBA-dependent paths are incorrectly flagged as disabled, preventin=
g I/O.
- [High] SDEV_CREATED state is omitted from available paths, causing premat=
ure I/O failures.
- [High] I/O submitted during device quiesce (e.g., system suspend) will ha=
ng indefinitely because the requeue list is never flushed upon resume.

Pre-existing issues:
- [High] Missing cancellation of background `requeue_work` task before tear=
ing down and freeing the `scsi_mpath_head` object.
--

--- Patch [19]: [PATCH v6 19/27] scsi-multipath: provide callbacks for path=
 state ---
commit a79ca9463c83fa5a5480f800bdc6d5f3fef27829
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: provide callbacks for path state

This commit provides callbacks for .is_disabled, .is_optimized, and
.available_path. These callbacks use the scsi_device's sdev_state
and access_state, which will be driven by ALUA.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
> +{

[ ... ]

> +	if (access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL ||
> +	    access_state =3D=3D SCSI_ACCESS_STATE_ACTIVE)
> +		return false;
> +
> +	return true;
> +}

[Severity: High]
Will this return true for STANDBY paths?

If implicit ALUA relies on sending I/O to a STANDBY path to transition it
to ACTIVE via a Unit Attention, marking it disabled might prevent the core
from routing any I/O to it, potentially deadlocking the failover.

[Severity: High]
Does this also need to allow SCSI_ACCESS_STATE_LBA?

SPC-4 defines LBA-dependent states as active and capable of processing I/O
commands. Should this state also be permitted here to avoid stalling I/O
on storage arrays that rely on it?

> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
> +{

[ ... ]

> +	if (sdev_state =3D=3D SDEV_RUNNING || sdev_state =3D=3D SDEV_QUIESCE ||
> +	    sdev_state =3D=3D SDEV_BLOCK || sdev_state =3D=3D SDEV_CREATED_BLOC=
K)
> +		return true;
> +
> +	return false;
> +}

[Severity: High]
Should SDEV_CREATED be included here?

During SCSI device probing, the device state is SDEV_CREATED and the core
SCSI layer permits I/O operations like INQUIRY. If SDEV_CREATED is omitted
here, could valid I/O be incorrectly failed as unavailable during device
scanning?

[Severity: High]
By allowing SDEV_QUIESCE here, bios will be placed on the requeue list.

When the device is later unquiesced during a system resume,
scsi_device_resume() sets the state back to SDEV_RUNNING, but it does not
seem to trigger scsi_mpath_revalidate_paths() or schedule requeue_work.

Will bios queued during suspend remain stuck on the list indefinitely?

[Severity: High]
This function only checks sdev_state.

If an ALUA path transitions to SCSI_ACCESS_STATE_OFFLINE, sdev_state remains
SDEV_RUNNING, which causes this callback to return true.

Could this cause the block layer to endlessly requeue the I/O, believing
the path is temporarily unavailable, rather than failing it immediately
for being permanently offline?

>  static struct mpath_head_template smpdt =3D {
> +	.is_disabled =3D scsi_mpath_is_disabled,
> +	.is_optimized =3D scsi_mpath_is_optimized,
> +	.available_path =3D scsi_mpath_available_path,
>  	.clone_bio =3D scsi_mpath_clone_bio,
>  };

[Severity: High]
How does this integration handle ALUA state changes for requeued I/O?

When no active paths are found, bios are placed on the requeue list:

lib/multipath.c:mpath_bdev_submit_bio()
    spin_lock_irq(&mpath_head->requeue_lock);
    bio_list_add(&mpath_head->requeue_list, bio);
    spin_unlock_irq(&mpath_head->requeue_lock);

When scsi_dh_alua.c handles an ALUA state change, does it notify
scsi-multipath to schedule the requeue work? If not, could these bios
remain permanently stalled?

[Severity: High]
Are the routing algorithms in lib/multipath.c actually using this new
.is_optimized callback?

lib/multipath.c:__mpath_find_path()
    switch(mpath_device->access_state) {
    case MPATH_STATE_OPTIMIZED:

It appears the path finder checks the statically initialized access_state
field instead of invoking the new callback. Will this cause all active
paths to be incorrectly treated as optimized, bypassing path prioritization?

[Severity: High]
This is a pre-existing issue, but I noticed a potential use-after-free
during device removal in scsi_mpath_head_release():

drivers/scsi/scsi_multipath.c:scsi_mpath_head_release()
static void scsi_mpath_head_release(struct device *dev)
{
    ...
    mpath_head_uninit(mpath_head);
    kfree(scsi_mpath_head);
}

Since scsi_mpath_revalidate_paths() asynchronously schedules the
requeue_work task, if the device is removed and the refcount drops to zero,
the structure is freed without calling cancel_work_sync().

Could this allow pending work to execute on the freed scsi_mpath_head
pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D19
