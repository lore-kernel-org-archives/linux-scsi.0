Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84B837F00F
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165871; cv=none; b=YNHh6EJNxiaL9czFLm3ewqDADuH80QTQPFylUTVGPGvJqFzCBvajixybeZef7rMqRwmdWKC12GyTu/OS9Eb4SflgkLlD2YVYyJ7yA7vKMibjIml9dbislAzJNcH+nURNrp7N/mv4YnlR8kP5bFHWJbaVbvFguGurdQmaHyDFyzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165871; c=relaxed/simple;
	bh=r3kAmCT3VgGRlcX0s2Weagd4nr8ZZ8QhxZyIJkH+1fE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u10BdQCYOwvZYNWW+ye29Eijclvz40y/p/O9zGpo5uti/iN08arNEP8sg6Ife0/Zmnhf9mgexAm+Gu820zlIeTMM1MxvTRpvAV03FybDWczIH7a2/m8otxpN/lvjFpi4v0MauU/J2poVjR4XqbOeDXGV44Wuqm5NCZTS21QbgTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrL4gA5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrL4gA5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526281F000E9;
	Mon, 27 Jul 2026 15:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165869;
	bh=WAFoipdDo0sVJCqxeK5bJ7+oXel+LJEbOwcP6z6CGAo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UrL4gA5xtV9cvKl9MgVG6lK/YCTrDWFComlRXpLeDz98MhN6e6a8vczrIyHZJSZrf
	 +f769jvmyZ/k0tAS/LGXWuDwmu56eTclqPwyLYY+WCks71Brc0k05izVSQW7s+55/5
	 8J99oF/YbQLVUpJuG5BsZ4+Q5Fu5YB07+EnJ2GPp/ksxGgjJHbWhaQtLOQUzBvUNDK
	 53t7MhqJeNftDEdSYnXmIdbxvGMfGbW9uDH2LweAjyY9FsOGbIU/rLsbsM0HFm2LzM
	 G9W+UMEr6+LFe7EAxlJ/C0usjcHv+w/qOobd7XUJG4HWxmLQFhnUARGRTvw0q6IZRm
	 EzUuO/dLL2I9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 19/27] scsi-multipath: provide callbacks for path
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-20-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-20-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:24:28 +0000
Message-Id: <20260727152429.526281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi-multipath fails to kick the multipath head's requeue list whe=
n underlying paths transition back to a usable state, causing pending I/Os =
to hang indefinitely.
- [High] Core path selectors ignore the newly added `.is_optimized` callbac=
k, breaking ALUA priorities for round-robin and queue-depth I/O policies.
- [High] LBA-dependent ALUA paths are incorrectly treated as disabled, lead=
ing to complete I/O failure for LBA-dependent arrays.
--

--- Patch [19]: [PATCH v5 19/27] scsi-multipath: provide callbacks for path=
 state ---
commit c99fff5c406ddb30334df26d8cb6dcc7c86e7a13
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: provide callbacks for path state

Provide callbacks for .is_disabled, .is_optimized, and .available_path.
These all use scsi_device.sdev_state and scsi_device.access_state.
Member scsi_device.access_state will be driven by ALUA.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index ec611f26d7960..d79e1b7b90051 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -314,7 +314,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *=
bio)

[ ... ]

> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	unsigned char access_state =3D READ_ONCE(sdev->access_state) &
> +					SCSI_ACCESS_STATE_MASK;
> +
> +	if (READ_ONCE(sdev->sdev_state) !=3D SDEV_RUNNING)
> +		return true;
> +
> +	if (access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL ||
> +	    access_state =3D=3D SCSI_ACCESS_STATE_ACTIVE)
> +		return false;

[Severity: High]
Does this code inadvertently exclude SCSI_ACCESS_STATE_LBA?

If a path is in SCSI_ACCESS_STATE_LBA, it is considered a valid, usable act=
ive
path by ALUA. By returning true for any state other than OPTIMAL or ACTIVE,
won't this cause complete I/O failure if all available paths are
LBA-dependent?

> +
> +	return true;
> +}

[Severity: High]
If a path's state changes to become usable again (for example, transitioning
from SDEV_QUIESCE back to SDEV_RUNNING in scsi_device_resume(), or when the
ALUA state changes to SCSI_ACCESS_STATE_OPTIMAL asynchronously), how is the
multipath head notified?

Without a corresponding transition hook in the SCSI core or ALUA handlers
to invoke mpath_schedule_requeue_work(), won't pending I/Os on the
requeue_list hang indefinitely instead of being retried?

> +
> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	unsigned char access_state =3D READ_ONCE(sdev->access_state) &
> +					SCSI_ACCESS_STATE_MASK;
> +
> +	if (READ_ONCE(sdev->sdev_state) !=3D SDEV_RUNNING)
> +		return false;
> +
> +	return access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL;
> +}

[Severity: High]
Are core path selectors actually invoking this new callback?

Looking at the core selection algorithms in lib/multipath.c, such as
__mpath_find_path() or mpath_round_robin_path(), it appears they check the
static field mpath_device->access_state instead of invoking the
is_optimized() callback.

Because scsi_multipath_sdev_init() hardcodes mpath_device->access_state to
MPATH_STATE_OPTIMIZED, won't all SCSI paths be incorrectly treated as optim=
ized
by the core logic, bypassing ALUA path weighting for round-robin and
queue-depth policies?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D19
