Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807ED466B75
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324801; cv=none; b=Fs7w4OUJ40CukkEvIFP28eH80Grk9FDm3g+J2AtxMQzicjx7cjy6pe3wJowZqVLR1Az4sintxkYNQ2k7HzkhuBFBuGGYc0erEvoLD972jLKBGLabT+xkJlEgKD44YvjMsg5FADf2FxiJGgUXGqy7HiXz0kuLswVxsnjCH8C1KI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324801; c=relaxed/simple;
	bh=daurZA0adHZV63g+DsLYK1FvXBAz7cPp25/CGaZR//U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j3cIQzaqg3PiM7juMmBPdKswyZH9kFZjCW/glDJxZlRm0iaZh4zG9s+BIg2nToObzB+/v1wkdHGKm44h61ofYbfSaF+6j3BhSC0Swyr+ywBrLQIek5OdrVfscZtuK3TYVFn0CgEgCU1M0PeZ2WfUTnRxUlBpEk40w49KzmaaZ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rywu4hRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rywu4hRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FBD1F000E9;
	Wed, 29 Jul 2026 11:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785324800;
	bh=8FKqqWIU81r1eQBRzhOZ+3SUHLA4lV2vSFR+dt29KKg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rywu4hRg4xPQsU64EkPAn88szdmPIQDlnTB8f8WG+JSpKTYrzylSQqv2LaNpyVM22
	 8CWHQN9VbGaKwgF7U8dXNh6lNQijD6Qh7DL8TLuTjhWBGikt00ufhxShdCXou5VPZ1
	 r5auMov2OpuwIUF1CXHRsuvVSDh1T8UblgtnSe0e2xQhmcHL08btbZIdaMoAucirT5
	 1ydwD8XE0TNvJXBrQtlv2GdsDO/OJjXyVAwUkvnSVG5aoOArYzwFw5kMNEni2ZpuiE
	 ISRsbzymZ7N8vAQTwpY4pFypLw5561OOnrnNxtrPSJKvzOahFbvqP/WgtRyhRfXEFI
	 x8qCEeiCd3wMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/27] libmultipath: Add path selection support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-4-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:33:19 +0000
Message-Id: <20260729113319.E1FBD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Round-robin path selection behaves as reverse round-robin for non-=
optimized paths due to a missing loop break.
- [High] Unsafe and logically flawed use of `list_is_singular` on an RCU-pr=
otected list routes I/O to a removed device.

Pre-existing issues:
- [High] mpath_head_uninit() blocks indefinitely waiting for user-space to =
close the block device.
--

--- Patch [3]: [PATCH v6 03/27] libmultipath: Add path selection support ---
commit 70a41be1b0a598af8cbd34732b889f79118d17ac
Author: John Garry <john.garry@linux.dev>

libmultipath: Add path selection support

This commit adds code for path selection support in libmultipath. It abstra=
cts
NVMe ANA into mpath_access_state to allow SCSI ALUA usage and adds round-ro=
bin,
NUMA, and queue-depth selection modes. It also introduces functions to set =
and
get the default I/O policy.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 1cf20b0f62d07..26714116023a3 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -7,8 +7,245 @@
> +static struct mpath_device *mpath_round_robin_path(
> +				struct mpath_head *mpath_head)
> +{
> +	struct mpath_device *mpath_device, *found =3D NULL;
> +	int node =3D numa_node_id();
> +	enum mpath_access_state access_state_old;
> +	struct mpath_device *old =3D
> +			srcu_dereference(mpath_head->current_path[node],
> +				&mpath_head->srcu);
> +
> +	if (unlikely(!old))
> +		return __mpath_find_path(mpath_head, node);
> +
> +	if (list_is_singular(&mpath_head->dev_list)) {

[Severity: High]
Does using list_is_singular() here on an SRCU-protected list introduce a da=
ta
race on head->prev?

Additionally, if old is concurrently removed and exactly one other active
device remains in the list, list_is_singular() evaluates to true. Will this
cause the function to return the unlinked old path instead of the valid
active path?

> +		if (mpath_path_is_disabled(mpath_head, old))
> +			return NULL;
> +		return old;
> +	}
> +
> +	for (mpath_device =3D mpath_next_dev(mpath_head, old);
> +	    mpath_device && mpath_device !=3D old;
> +	    mpath_device =3D mpath_next_dev(mpath_head, mpath_device)) {
> +
> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
> +			continue;
> +		if (mpath_device->access_state =3D=3D MPATH_STATE_OPTIMIZED) {
> +			found =3D mpath_device;
> +			goto out;
> +		}
> +		if (mpath_device->access_state =3D=3D MPATH_STATE_NONOPTIMIZED)
> +			found =3D mpath_device;

[Severity: High]
For the MPATH_STATE_NONOPTIMIZED case, found is overwritten unconditionally.
Because there is no loop break or check like if (!found), will this
evaluate multiple non-optimized paths and incorrectly select the last
available one rather than the next available one?

> +	}

[ ... ]

[Severity: High]
This is a pre-existing issue, but I noticed a potential problem during
teardown in mpath_head_uninit():

lib/multipath.c:mpath_head_uninit() {
        ...
        if (!refcount_dec_and_test(refcount))
                wait_var_event(refcount, !refcount_read(refcount));
}

Since a reference is taken for every user-space open, can wait_var_event()
block indefinitely if a user process holds the device open while the
driver is unbound or the device is hot-unplugged?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D3
