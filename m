Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0527A5B21A
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782601; cv=none; b=i/56fwkL7K+leqwdpN/gHJp9AUdSZwCCslBr23PvxRXG5RifnYLxl06b4SviyB+fw6jxRyjA1hFGd0rgzvuM9/wepVHRiENJtca8wjz8tIl19gDtBFoWLJHB2QPvObiMB9EbWMec1wEw5mHAOoKoDc4IT9Q+1Fe4sUx7EzakSj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782601; c=relaxed/simple;
	bh=fViXrMuLBoxTGzQVsEgKneQhJc/SHbtAlYliT8tncrk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J3dxlW1qMU2MBYjcWdH/s6LWs+YFUhseMpzvuFBBj8PN3KWPgHfXDH89x68yYzItYpF//iASAUI5/izbEmzVpEEEJbfngi5v0vNOw6skYs0sgE8WV+RTs61salfWyoc6mLmbfnN9+4W1qFZHyC9d0M/HHk6lHlN0Stghyp+mvf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gsLchuhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gsLchuhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678721F00A3A;
	Mon,  7 Sep 2026 12:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788782599;
	bh=/afiyoo+gJGvB6QcrFoEkYXLZ71KYNBwy1R08hQMl6M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gsLchuhvKtoohs+JfCuT4MzHaK2QlmhGysk9vDgAAyq90BH6/sQxjrYO0TUHp0l0b
	 jhoiTSaOI+1kb8f/N+i6p0g9cwXOxfTRXctpy4h5gs1jChQdV+7895D0o/zXPX/epG
	 6f2TYKWFx6Uj7n3jjp4dHTHXGMoVbaR41uboeQ6pEb8pf90PZc3zwx2Kmkk6/RTyZp
	 gqVv9FmxtW1Wkc7UM5dYkQnqs7ksfelWCMGtfFrMwql6vc6/O5BYALRIJkCbMXRQ8b
	 XEjnNTHolcyXMQSsE4+LFEGOHkDSVo4f9kDUWQafy25vq6pYEg3zLeZCRRfRcY8wBg
	 PNUdsRva6TOcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 19/27] scsi-multipath: provide callbacks for path
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-20-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-20-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 12:03:18 +0000
Message-Id: <20260907120319.678721F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi_mpath_available_path() erroneously returns true for ALUA unav=
ailable/offline states, leading to infinite I/O requeuing.
--

commit 4cf5187795e3a1d7ac00b1645759bf9140204feb
Author: John Garry <john.garry@linux.dev>

scsi-multipath: provide callbacks for path state

This patch provides callbacks for .is_disabled, .is_optimized, and
.available_path. These use scsi_device.sdev_state and access_state, which
will be driven by ALUA.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 12200664ed676..4055b86c83a03 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -306,7 +306,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *=
bio)
[ ... ]
> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	enum scsi_device_state sdev_state =3D READ_ONCE(sdev->sdev_state);
> +
> +	if (sdev_state =3D=3D SDEV_RUNNING || sdev_state =3D=3D SDEV_QUIESCE ||
> +	    sdev_state =3D=3D SDEV_BLOCK || sdev_state =3D=3D SDEV_CREATED_BLOC=
K)
> +		return true;
> +
> +	return false;
> +}

[Severity: High]
Does this logic bypass queue_if_no_path limits when devices are in ALUA
offline or unavailable states?

Since this only checks sdev_state, if all paths transition to an ALUA
offline or unavailable state but remain physically connected (SDEV_RUNNING),
would this function still return true?

If it returns true for ALUA offline paths, could mpath_bdev_submit_bio()
indefinitely queue I/O in the requeue_list, ignoring the user's
configuration for timeout and failure?

Should this function also check sdev->access_state to prevent treating
paths as available when they are in ALUA states that can never serve I/O?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D19
