Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914DE432BD6
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800514; cv=none; b=im8/rspAHgoGjLRfD7UiFXemIlBQszi5aSv1+IFVkeBCog26r6LkSOeNvaVCwWxR5p0ALBSwCmEd2a4zBo2EKDwSR34Gt1BH3vwGUxsQ2vRo7mbmlhQ64Z9rakNCmvTR7CU7hj9Ut5pN3fzV5kdQ5OSuxxtzpcjkZJudCW7Q0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800514; c=relaxed/simple;
	bh=4KLYdKe6G1o+pr7UaPj0ugtgEUiYlfMotgH7qIBU90c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N9P9J1XBFtHVRXrKL9aZ354gYv+GySP+sIa/vFniUylmMuH9K2O2KwIjYzoh/P9LmoMlVtv/wTg/VzosdqkOz1yZVsYH7yEKi+khNkqhY+o3RasJ3+1teiu1Dxzkf+lGt+zAa9PPyDzPzBT2y2MZAUbbjnXwDbIHpnALFHVzksY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nv1Rz2FM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nv1Rz2FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF7F1F000E9;
	Thu, 23 Jul 2026 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784800512;
	bh=k0vMh9vc53hY8OnUv35p+7xZXV18UwWnjvmAAx7DzVc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nv1Rz2FM/xmnGXXCBYRIUrzQs96h5Xdxc2SDd+27lP1vxzb8GoTOxgNpcIWoYpOWi
	 wU1/E+r+3P8ppdkpqVJ2WmTPXGT9aoEsoFUVB2Xr3o9D+Mc3MbKD0OSh8aR6KmF9ch
	 qDuFVvhOhETD4enj/r6GFp7raBUnbPYZKcMYfvm0aLBRCtSjn5uhX3e7XQYw26XELI
	 znKznMw7/Iamno5RzXpKfdhbBXKPyHeS8P6vVcHvxMwoLW1x5hm3HUcX0jOxgZ1/+x
	 dSxPtnULAM18Go2FQ7LQFyTLXBmsAiqjp1C1XwI5mTNrATseveqd44tfqVMLJX1o/K
	 pm7/pBHelztiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/28] libmultipath: Add path selection support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-4-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:55:11 +0000
Message-Id: <20260723095512.6CF7F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The round-robin path selector can enter an infinite loop (SRCU loc=
kup) if the currently selected path is removed concurrently.
- [Medium] Calling `list_is_singular()` on an SRCU-protected list introduce=
s data races and state inconsistencies.
- [Low] Missing `WRITE_ONCE()` when updating `iopolicy` causes a data race =
with lockless readers.
--

--- Patch [3]: [PATCH v4 03/28] libmultipath: Add path selection support ---
commit 84fab111a99eb088e0b8abed39b8163220a9318d
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add path selection support

Add code for path selection. NVMe ANA is abstracted into enum
mpath_access_state so that SCSI ALUA can be used. Path selection modes
round-robin, NUMA, and queue-depth are added.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 916d01a285284..20bb8cb0ea956 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> +int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy)
> +{
> +	int policy;
> +
> +	if (!str)
> +		return -EINVAL;
> +	policy =3D mpath_iopolicy_parse(str);
> +	if (policy < 0)
> +		return policy;
> +	*iopolicy =3D policy;

[Severity: Low]
Does this code need a WRITE_ONCE() for the assignment?

mpath_read_iopolicy() safely accesses this locklessly via READ_ONCE(), but
this plain store could cause a data race violating LKMM guidelines and
triggering KCSAN warnings.

> +
> +	return 0;
> +}

[ ... ]

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
> +		if (mpath_path_is_disabled(mpath_head, old))
> +			return NULL;
> +		return old;
> +	}

[Severity: Medium]
Is it safe to use list_is_singular() on an SRCU-protected list here?

list_is_singular() reads head->prev, which is a writer-only pointer in
RCU-protected lists, introducing a data race.

Additionally, if old was just concurrently unlinked leaving exactly one oth=
er
active device in the list, list_is_singular() evaluates to true. Could this
cause the function to incorrectly return the unlinked device instead of the
actual remaining device?

> +
> +	for (mpath_device =3D mpath_next_dev(mpath_head, old);
> +	    mpath_device && mpath_device !=3D old;
> +	    mpath_device =3D mpath_next_dev(mpath_head, mpath_device)) {

[Severity: High]
Can this loop become infinite if the currently selected path is removed
concurrently?

If a concurrent thread unlinks old from the list, mpath_next_dev() will nev=
er
reach mpath_device =3D=3D old to break the loop. Since old is unlinked, tra=
versal
might wrap around the circular list infinitely, causing a hard lockup within
the SRCU read-side critical section.

Unlike the NVMe equivalent nvme_round_robin_path(), which avoids this by
breaking early if it cycles back to a fallback node, this patch omits that
loop termination condition. If no other path is MPATH_STATE_OPTIMIZED, could
this run forever?

> +
> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
> +			continue;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D3
