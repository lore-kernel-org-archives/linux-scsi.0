Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8AA439F89
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076693; cv=none; b=b5p9hWuls/GkHVMsXFLn/keXzEQVZqhePIeVYqDqdUdfasDocp3Ki+4zcMo9BGZUVxakNuUXAERGcgaHVt/FFr1FQAlUbIZZ3sVzUCTR7TF0fmT9F7rpF9mEl7a4fmu3i4EW42G3iN5vFdkBU7W9PUTt5urX/zVzbs7v+aYjmwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076693; c=relaxed/simple;
	bh=Dz5XDj7bIjTXU65Z/UuUqyPVcybVIqOC9mZ+tafVBS4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iKQa2Mv/MWsjSevMVRFb0fzEiMAfmQiecbI0ORoX7hWKYaTazQbK/aHTFaJORlX6Eszz7AVZcmnDtGwXucxzzUOdU6klPGP21py2VpszNQbFop74UGnp0FpM7Dnh1aUjVO7qh0JnFrei7xPymz+2yc04eLkaRSP3xrzpyjO1SBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZ5nFWnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZ5nFWnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A541F000E9;
	Tue, 18 Aug 2026 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076691;
	bh=4nxZFjkLJilVZpHR19/UTXBOfJP8n45JUu8nDziPE8Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GZ5nFWnhmLhtFew29vg5pvWXTrkeZ60R0TkvI5BlGitHIwR03RSUtUPEBvtcNCFSi
	 oYHsqt2d8+zMCTEe7zOt2HR2+8rUFl827thqOmwIIWXZaoRtOgZuREwiY8A4/HT6ag
	 FBf6Pmjg5P5lINTvptFfh2nci4JVYh9HMo9XJC4SBiJgJUjYKSi0OTdoIz1VQ8/b9G
	 m77I/sOEcyjl8eWME/XjTLEwqV5fBC0xCdr78y3QGZG1c7Q8lt5sXA8mcCNXz0fqBB
	 KoVVWAEgHwSFhkn5mhdMffKP+m1MI5FC/WI8SK1VA8WSJbfEfMBE/1/bLDjd41B+bR
	 WpFqLPFJzoGCQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/17] mpi3mr: Fix I/O block counter leak on admin
 request post failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-4-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-4-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:11:31 +0000
Message-Id: <20260818181131.B7A541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Dereferencing `stgt_priv` on the error and timeout/completion =
paths leads to a Use-After-Free if the SCSI target is concurrently removed.
--

--- Patch [3]: [PATCH 03/17] mpi3mr: Fix I/O block counter leak on admin re=
quest post failure ---
commit 1533f8fc86e8eb7e7a5042ad5aab564671eb7b8c
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix I/O block counter leak on admin request post failure

This commit addresses an issue where the per-device I/O block counter is not
decremented if posting a task management request fails. It lowers the count=
er
on the failure path to prevent I/O from remaining blocked.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 1cd1c38dcd565..a4fe10a05cb3a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2782,6 +2782,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job)
>  		dprint_bsg_err(mrioc,
>  		    "%s: posting bsg request is failed\n", __func__);
>  		rval =3D -EAGAIN;
> +		if (block_io && stgt_priv)
> +			atomic_dec(&stgt_priv->block_io);

[Severity: Critical]
This is a pre-existing issue, but does this add another path that can trigg=
er
a use-after-free if the SCSI target is concurrently removed?

Looking at mpi3mr_bsg_process_mpt_cmds(), stgt_priv is fetched from
tgtdev->starget->hostdata, but the tgtdev reference is immediately dropped
before posting the bsg request:

	if (block_io) {
		tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
		if (tgtdev) {
			if (tgtdev->starget && tgtdev->starget->hostdata) {
				stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
				    tgtdev->starget->hostdata;
				atomic_inc(&stgt_priv->block_io);
			}
			mpi3mr_tgtdev_put(tgtdev);
		}
	}

Because there are no references or locks held, if the device is concurrently
removed (e.g., via hot-unplug), the SCSI midlayer can invoke
mpi3mr_target_destroy(), which unconditionally frees the hostdata memory:

mpi3mr_target_destroy() {
	...
	kfree(starget->hostdata);
	...
}

Since the original completion path also dereferences stgt_priv after sleepi=
ng
in wait_for_completion_timeout(), both the timeout/completion path and this
newly added error path seem to potentially call
atomic_dec(&stgt_priv->block_io) on freed memory.

>  		goto out_unlock;
>  	}
>  	wait_for_completion_timeout(&mrioc->bsg_cmds.done,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D3
