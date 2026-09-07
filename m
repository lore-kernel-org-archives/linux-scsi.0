Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6993E409273
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 11:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788779368; cv=none; b=E2LhOscPXEQJXjHHyHK1z/AxlIji1JOvSSonxd8W/eN9DfxYWJttCvO/AtX9YKTIuQbehXkoq/QOng2GZqPem0T3kSBfruMnal3UoMkI2OLACOWfU3ZAiv6d9eEIXuBiGa3024Pf0BXcoyXzg1fqVZaTjCrFtvFQtqKSq6HzTcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788779368; c=relaxed/simple;
	bh=PQpjTZP1Td1TFRWWrUuDZUuPTkMx3zsfHR8gUAPge4M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H94Qyv+W4YxICuosmbNkS0VI6L/dCgOF9gmN8mqmnS9Y4tGI4BEiZKtAj/MyPDP7N67ClrSa7yHlKLCVyX3mS2s2Bym4eAzcZ1GdBYNeYXOyPacFmOroUrN4pRnSGmv4nodv217KruZnn0hzBLkRgl+yGBbLgecsIRngack0zlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oy8j6a+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oy8j6a+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4271F00A3A;
	Mon,  7 Sep 2026 11:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788779367;
	bh=HV35jB809QiFfm8YAI6duO09g9x5JxSZZ0jUQ7zaFA4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oy8j6a+Fzhgmzi1CX8ich0Cf1wcoXEQcyQOXlK842JJpEDEGRs69H7lzZC+H5FLsZ
	 YhMKPnl9s78nnnQep8ptzDZUgMIOLHF4RsHMVACaq64/qzIj0jJF8xKCx7G4xP5uaY
	 iYsxS4Dyk47EoKU/7o4tji+IbAgBVCH4lIvqRPh0X2U4u4S+al8yuA5qIEr2PrzUeQ
	 B9vkFC/MYPI3BTs25TfezeEpWF3UwP7JyiDxvSCZICOAK+GOtaAbwTG/El02miIC2L
	 WNxsBFubksktV2/RQ8qT+64D/4o+TyaV0Y/gmt8XpEgIYMr9ZusMOZWalnNDBwLJ+K
	 Dqj3RbHSt1i6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 03/27] libmultipath: Add path selection support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-4-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 11:09:26 +0000
Message-Id: <20260907110926.ED4271F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Infinite loop in `mpath_round_robin_path()` if the current round-r=
obin path is concurrently removed from the device list, causing an SRCU dea=
dlock.
- [High] `mpath_round_robin_path` fast-path incorrectly returns an unlinked=
 path, breaking failover.
- [Medium] Calling `list_is_singular()` on an RCU-protected list without ho=
lding the update lock causes a data race on `head->prev`.
- [Medium] Path selection functions bypass the `.is_optimized` callback, vi=
olating the API contract and causing inconsistent path evaluation.
- [Low] Missing bounds check on iopolicy index in `mpath_get_iopolicy`.

Pre-existing issues:
- [Medium] `mpath_device_set_live()` silently swallows setup failures, leav=
ing the driver unaware of the aborted initialization.
--

commit 59f56cbf3b60a1ec3a1336f453b4cd772a005e7b
Author: John Garry <john.garry@linux.dev>

libmultipath: Add path selection support

This commit adds path selection support to libmultipath, providing
round-robin, NUMA, and queue-depth selection modes similar to NVMe. It also
abstracts NVMe ANA into enum mpath_access_state to allow SCSI ALUA usage
and introduces iopolicy management functions.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 574868ce53381..3541357d07f8d 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -7,8 +7,245 @@

[ ... ]

> +int mpath_get_iopolicy(char *buf, int iopolicy)
> +{
> +	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
> +}

[Severity: Low]
Does this code overflow mpath_iopolicy_names[] if a caller provides an
uninitialized or out-of-bounds iopolicy value?

[ ... ]

> +static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_h=
ead,
> +					int node)
> +{
> +	int found_distance =3D INT_MAX, fallback_distance =3D INT_MAX, distance;
> +	struct mpath_device *found =3D NULL, *fallback =3D NULL, *mpath_device;
> +
> +	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
> +		srcu_read_lock_held(&mpath_head->srcu)) {
> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
> +			continue;

[ ... ]

> +		switch(mpath_device->access_state) {
> +		case MPATH_STATE_OPTIMIZED:

[Severity: Medium]
Does this code bypass the driver's dynamic state evaluation by accessing
access_state directly instead of invoking the provided
mpath_path_is_optimized() callback wrapper?

If a driver like SCSI ALUA dynamically changes state, this will read
stale data.

> +		    if (distance < found_distance) {
> +			    found_distance =3D distance;
> +			    found =3D mpath_device;
> +		    }
> +		    break;

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

[Severity: Medium]
Calling list_is_singular() on an RCU-protected list without holding the
update lock causes a data race on head->prev. In RCU-protected lists,
only next pointers are safely updated for lockless readers.

[Severity: High]
Does this fast-path blindly return old without verifying if it is actually
the element present in the singular list?

If the previously cached old path was concurrently removed from dev_list
and exactly one valid path remains, list_is_singular() evaluates to true,
causing the function to incorrectly return the unlinked path instead of
the remaining valid path.

> +		if (mpath_path_is_disabled(mpath_head, old))
> +			return NULL;
> +		return old;
> +	}
> +
> +	for (mpath_device =3D mpath_next_dev(mpath_head, old);
> +	    mpath_device && mpath_device !=3D old;
> +	    mpath_device =3D mpath_next_dev(mpath_head, mpath_device)) {

[Severity: High]
Can this loop spin infinitely if old is concurrently removed from the
RCU-protected list?

The loop relies on reaching old again to terminate. If a concurrent writer
unlinks old using list_del_rcu(), it is removed from the circular list but
its next pointer remains intact. mpath_next_dev() follows old->next into
the remaining list elements, wrapping around and circling the remaining
elements indefinitely without ever evaluating mpath_device =3D=3D old.

If all remaining paths are non-optimized or disabled, the loop never hits
the break condition, spinning forever under the SRCU read lock and stalling
any writer.

> +
> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
> +			continue;
> +		if (mpath_device->access_state =3D=3D MPATH_STATE_OPTIMIZED) {

[Severity: Medium]
Similar to __mpath_find_path(), does this bypass the driver's dynamic state
evaluation by accessing access_state directly rather than calling the
mpath_path_is_optimized() callback wrapper?

> +			found =3D mpath_device;
> +			goto out;
> +		}
> +		if (mpath_device->access_state =3D=3D MPATH_STATE_NONOPTIMIZED)
> +			found =3D mpath_device;
> +	}

[ ... ]

> @@ -133,6 +371,19 @@ void mpath_device_set_live(struct mpath_device *mpat=
h_device)
>  		}
>  		queue_work(mpath_wq, &mpath_head->partition_scan_work);
>  	}

[Severity: Medium]
This is a pre-existing issue, but does mpath_device_set_live() silently
swallow setup failures earlier in this function?

If device_add_disk() fails, for example due to memory exhaustion, the
function clears the MPATH_HEAD_DISK_LIVE flag and returns early, masking
the failure from the caller and leaving the driver unaware of the aborted
initialization.

> +
> +	mutex_lock(&mpath_head->lock);
> +	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
> +		int node, srcu_idx;
> +
> +		srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +		for_each_online_node(node)
> +			__mpath_find_path(mpath_head, node);
> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	}
> +	mutex_unlock(&mpath_head->lock);
> +
> +	mpath_synchronize(mpath_head);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D3
