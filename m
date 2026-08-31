Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD233F65EC
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 12:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788178723; cv=none; b=uZz73WuQsBCTqHlv7AUyCKkzyiaZZGZGPbNUmAYduR18zP/utFb59ioOA2LbG1G31iCQN6m54CAE1/6SUQv5N88YzH0HD2ikaVRZhR9NlidhSmHQ0w/jOyPo+G4DZZPYipxHK7rFP0I/jmNQb6vnPnsiSegBR3vU3Yo5r8D8N+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788178723; c=relaxed/simple;
	bh=1NwFoGmZAhyUBRSEJyAwSn60+fsGFc8GmiDgQetVRQ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CQK51Apx24CpbpH2gKrO2px1Fg8vN5p1CoqPxUEn01Ro63+Ccv1YjIQ69GyTmsw2lOb7yA+HdPeQrHBx9kcNogbG5izsvmUSb2oyXPReYPUMp/O8d0SFGk/caLothFc9dOcs4FkFjjrAk8zasl7eAWNop4SS8+wJLlDMUguBJd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F20bylTk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F20bylTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57B11F000E9;
	Mon, 31 Aug 2026 12:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788178722;
	bh=cIV0+cRRR6GL2yHmx+SVTZbODrYRdaXjwsIXiilZrOg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F20bylTkHUUyJak8HkYz02LSUu2R50HRhzplkkhsbBvNUKwjezpfWBG0449fBSjO5
	 Blvlg0zJMEV5YmzOSm5C4NAWWeHX0Ktr6NbgywmS9xST3hWI1cCu3rzubKftrVBuFq
	 iUtIWBRQdyAlvqR4BdrPJdtnVieryKH8dBdimc8Kw997UVqWE/iCxDniuUJfyBIryA
	 deYK9AumxyixZp6KSDF7x+mE9GBFMG7YaztDwPTl7KpdQqCiEF3IaC0f2yUt574ceH
	 io4jIfx4z4BNeU/fZZX/QGgzDUEab3PJ/JvSfD+sR5yJqhmsVR4UC9DhJhHvo3UWYZ
	 50/W9gWvQpOxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: fix use-after-free on tgt_dev->starget
 during target device refresh/update
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831120047.14690-1-loberman@redhat.com>
References: <20260831120047.14690-1-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 12:18:41 +0000
Message-Id: <20260831121841.D57B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch fixes the unprotected check-then-use window for `tgtdev-=
>starget` in `mpi3mr_refresh_tgtdevs()` and `mpi3mr_devinfochg_evt_bh()`, b=
ut identical vulnerable patterns remain in other functions like `mpi3mr_rem=
ove_tgtdev_from_host()`, `mpi3mr_update_tgtdev()`, and various event/BSG ha=
ndlers.
- [High] Unprotected traversal of `mrioc->tgtdev_list` without holding `tgt=
dev_lock` can lead to list corruption and crashes due to concurrent inserti=
ons.
- [High] An AB-BA lock inversion exists between `mrioc->tgtdev_lock` and th=
e SCSI host lock (`shost->host_lock`).
--

commit 22ac835bdc4964e1608be9181c0e9ec7c639df2b
Author: Laurence Oberman <loberman@redhat.com>

scsi: mpi3mr: fix use-after-free on tgt_dev->starget during target device r=
efresh/update

This commit addresses a check-then-use window against the SCSI core's target
teardown path in mpi3mr_refresh_tgtdevs() and mpi3mr_devinfochg_evt_bh(). It
protects reads of tgt_dev->starget by acquiring tgtdev_lock and pinning the
target's device with get_device(), closing a TOCTOU race condition that cou=
ld
lead to a NULL pointer dereference.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index f80a21ec161b6..0f73804487188 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1094,10 +1094,13 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_=
ioc *mrioc)
>  {
>  	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
>  	struct mpi3mr_stgt_priv_data *tgt_priv;
> +	struct scsi_target *starget;
> +	unsigned long flags;
> =20
>  	dprint_reset(mrioc, "refresh target devices: check for removals\n");
>  	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
>  	    list) {

[Severity: High]
This is a pre-existing issue, but does iterating over mrioc->tgtdev_list
without holding tgtdev_lock risk list corruption?

If the top-half event handler (mpi3mr_os_handle_events()) receives a
device addition event concurrently, it can call mpi3mr_create_tgtdev(),
which mutates the list using list_add_tail() inside
mpi3mr_tgtdev_add_to_list() while holding the lock. The lockless reader
here will race with the writer.

The same unprotected traversal appears again on the third loop in
mpi3mr_refresh_tgtdevs() and in mpi3mr_invalidate_devhandles().

> +		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
>  		if (((tgtdev->dev_handle =3D=3D MPI3MR_INVALID_DEV_HANDLE) ||
>  		     tgtdev->is_hidden) &&
>  		     tgtdev->host_exposed && tgtdev->starget &&

[ ... ]

> @@ -1127,15 +1131,25 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_=
ioc *mrioc)
>  	tgtdev =3D NULL;
>  	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
>  		if ((tgtdev->dev_handle !=3D MPI3MR_INVALID_DEV_HANDLE) &&
> -		    !tgtdev->is_hidden) {
> -			if (!tgtdev->host_exposed)
> +				!tgtdev->is_hidden) {
> +			if (!tgtdev->host_exposed) {
>  				mpi3mr_report_tgtdev_to_host(mrioc,
> -							     tgtdev->perst_id);
> -			else if (tgtdev->starget)
> -				starget_for_each_device(tgtdev->starget,
> -							(void *)tgtdev, mpi3mr_update_sdev);
> -	}
> +				     tgtdev->perst_id);
> +				continue;
> +			}
> +			spin_lock_irqsave(&mrioc->tgtdev_lock, flags);

[Severity: High]
This is a pre-existing issue, but does acquiring tgtdev_lock here
create a lock inversion against shost->host_lock?

In mpi3mr_set_qd_for_all_vd_in_tg(), the driver acquires
mrioc->tgtdev_lock and then calls starget_for_each_device(), which
acquires shost->host_lock via __scsi_iterate_devices().

Concurrently, a target teardown (e.g., via sysfs or EH) acquires
shost->host_lock before calling the driver's ->target_destroy callback
(mpi3mr_target_destroy()). That callback then attempts to acquire
mrioc->tgtdev_lock, creating a potential AB-BA deadlock.

> +			starget =3D tgtdev->starget;
> +			if (starget)
> +				get_device(&starget->dev);
> +			spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);

[Severity: High]
This isn't a bug introduced by this patch, but while this change fixes
the unprotected check-then-use window for tgtdev->starget in this function,
are there identical vulnerable patterns remaining elsewhere?

For example, mpi3mr_remove_tgtdev_from_host() reads tgtdev->starget
and tgtdev->starget->hostdata locklessly:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_remove_tgtdev_from_host() {
    ...
    if (tgtdev->starget && tgtdev->starget->hostdata) {
        tgt_priv =3D tgtdev->starget->hostdata;
    ...
}

Similar unprotected reads occur in mpi3mr_update_tgtdev(),
mpi3mr_invalidate_devhandles(), mpi3mr_pcietopochg_evt_th(), and
mpi3mr_bsg_process_mpt_cmds(). Can concurrent target teardowns
trigger use-after-free conditions in these locations as well?

> +			if (starget) {
> +				starget_for_each_device(starget, (void *)tgtdev,
> +							mpi3mr_update_sdev);
> +				put_device(&starget->dev);
> +			}
> +		}
>  	}
> +	dprint_reset(mrioc, "refresh target devices: done\n");
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831120047.1469=
0-1-loberman@redhat.com?part=3D1
