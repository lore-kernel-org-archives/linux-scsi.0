Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E2747CC85
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261240; cv=none; b=FQWPI8dmiyYZxiLGqbZWPPEIGii8EY8nzbwLmjE78jJRrUQrUmtcUjQgXwRw1mnihKDPLb0IwZdVMNVv3liXYRJpvudTQYnR3T3Hn/bLXMEiH64GSK5rwjXYAuYowSWaYbSmXk8msv2mQoVLTJoUpCGy5+133l8B/gfOP2htMM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261240; c=relaxed/simple;
	bh=5/rlZAWKHkiHnWuMWQYZWNkMuOCHcBVCgRYXL0TZh0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ivnlN+jg3WuQHNMZUZWhl0kkTzWWe5IibUspIzuSoghwCcBfNTaBFp6W8jpWHwvo7HGu9sTLHapGAcBNKd1ZnOeGivQzboO5qvmO62rU5/gKhiY5lAi7JxHS3/Z3xhjsDfR+8nxh24e+LOAx7iGlyApA8iHIT4zN/ofkIwymzWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZgoJswmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZgoJswmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBA31F000E9;
	Tue,  1 Sep 2026 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788261239;
	bh=qRvr5UTXG02bgZsvpm7hr0dDE6blSuRyXqtL0riAQ6E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZgoJswmgByUI8kWMEyCDtcQO640c5/8QfAdM6hB2rs4bzcBgVJqRvc1AcpAaey0Bc
	 40DeViSEyE1Hj7Z8jq6Ya3kI7fy+g1glcTe78owFtHt5SHGxmVJrnrjPYrQIN8syUu
	 ep8YgJd6r0AiEdxAMw8NMnp0c3yjeucCcZxqprUlMClC7nhY//OBNKEaO8fHb2FXBb
	 BRRxJxJRT0srUcuH8VUVNklL09PESRY0zrkossC8MBGkpnuI9qeLCgySz+Jn54RcZc
	 uhbcUpzP+PZ2KmNvPKtG+f/KYJHqx3bhNGp2RF187TuovW2hIVXFr/B4W9bEt9LXSL
	 2QqhNRT5vDW8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 19/27] scsi-multipath: provide callbacks for path
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-20-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-20-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:13:58 +0000
Message-Id: <20260901111359.0FBA31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Path routing algorithms completely ignore ALUA path priorities due=
 to reliance on a static state field.
- [High] I/Os stranded in the requeue list during path unavailability will =
hang indefinitely because ALUA state recovery does not trigger a requeue li=
st flush.
--

commit 8deb21c730fe5e2ebafeae61cfbcd392c6ab5948
Author: John Garry <linux.dev>

scsi-multipath: provide callbacks for path state

This commit provides callbacks for is_disabled, is_optimized, and
available_path for SCSI multipath devices. The callbacks rely on the
device's ALUA state and running state to dynamically determine path
availability and routing priorities.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index fd28667792472..b9f6b1eb3c883 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

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
> +
> +	return true;
> +}

[Severity: High]
When this function correctly returns true (for example, when an ALUA-managed
storage path transitions to STANDBY), incoming I/Os are deferred to the
multipath head's requeue list.

However, when the target recovers and the ALUA state changes back, is there=
 a
mechanism to wake up and flush these stranded I/Os?

The ALUA device handlers update sdev->access_state upon receiving an RTPG,
but they do not appear to notify the core multipath layer to flush the requ=
eue
list. In NVMe, this is handled by kblockd_schedule_work(&head->requeue_work)
when ANA state changes. Because sdev_state remains SDEV_RUNNING, unblock
handlers are not triggered either. Will this lead to I/Os hanging
indefinitely in the requeue list without a corresponding wake-up trigger?

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
Does the multipath core actually use this callback for path selection routi=
ng?

Looking at the core path routing algorithms in lib/multipath.c, such as
__mpath_find_path, mpath_round_robin_path, or mpath_queue_depth_path, they
appear to check the static struct field instead of invoking the callback:

lib/multipath.c:__mpath_find_path() {
    ...
    switch(mpath_device->access_state) {
    ...
}

Because mpath_device->access_state is hardcoded to MPATH_STATE_OPTIMIZED
during device allocation in scsi_multipath_sdev_init() and is not dynamical=
ly
synced with the ALUA state, won't the routing algorithms blindly place
non-optimized active paths in the same preference bucket as optimized paths?
This seems to bypass the newly introduced ALUA callbacks entirely for
queue-depth or round-robin policies.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D19
