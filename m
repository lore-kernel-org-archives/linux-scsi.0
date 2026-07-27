Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E841D10E
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164612; cv=none; b=ufhnp2pejv4kOK4U75SmPgokLe8Nc0/zn5U7TzTPqJXUFQOxZDyzgwu96/WaEdHcMK2NfxzlU9f3demCT57XjnkmofCLx0qL+zYzHjvY1oxDktuMfky5xE60/AQ7V3eKlywzuigy1d2zRM4UNgK6/Gxf3rYXSczkuJ85wLlFakw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164612; c=relaxed/simple;
	bh=E7D8q6sYC0eqQdl+EAGELiSzDgA/v2ph5e6P/paD6r4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OJphs9xPG3Ss3RpoWUAx6c87f4l+ulR9nkq6WNhsWdI8AfU/KN2a7y+jBr0KkOJzefzVpG7AJRhgKjZgTfYV6TlWsvCHgiZM6Z6S5GJyrVD8tOWBKIRwGBdZcDsoAcsWKX2Yy+c/dUx1eybvYknakQYE6d+IhfezPu/s34w4Yig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ik1nIOij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ik1nIOij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95341F000E9;
	Mon, 27 Jul 2026 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164611;
	bh=EJPNfXBoif+GqtDewX/bfgIy8uF2qrH7pAA3wssCKZQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ik1nIOij2dyzdTNUSOUq2UBephpX5EIfA2IdhIXh16X4hYA72f/uTtd6dwLz6FEFT
	 NtOaT4gJc79MQCc5ZnqmExJFGlHolg5pqho0QHY1RalhsKoeTfNUp/qBMJIYEWOnD/
	 Nnaxo6TYc4B7bPVDxPmRSsAw8TirLTrKtWuM4CBtkTjj2r13Ah6EqzMNJn2PDKYLga
	 gSxpzAjmmSwCz/nh8q4sEj9OK3unoOkjTOFtS2MXxsRhRr4DSPjgYgz9C6vFFPCmIM
	 r2cu374sUUfoMsMZaXHci5O+b2aM8YPejZ9Lnj8jmWBX8bUwGytg3D8iY22q0uClah
	 wxYdF08Mf0fow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/27] libmultipath: Add sysfs helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-8-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:03:30 +0000
Message-Id: <20260727150330.E95341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mpath_alloc_head_disk leaves mpath_head->disk set to an ERR_PTR on=
 blk_alloc_disk failure, leading to a crash in mpath_put_disk.
- [Medium] Updating the multipath iopolicy via mpath_iopolicy_store() does =
not clear the existing current_path arrays, resulting in stale path selecti=
on.
--

--- Patch [7]: [PATCH v5 07/27] libmultipath: Add sysfs helpers ---
commit fdada4b0515eb9327fe00efd638199926cadf8fd
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add sysfs helpers

Add helpers for driver sysfs code for the following functionality:
- get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
- show device path per NUMA node
- "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
- device groups attribute array, similar to nvme_ns_attr_groups but not
  containing NVMe members.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index ede06e5e901c8..c78d46a446cf3 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> +bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *b=
uf)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
> +		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
> +			mpath_iopolicy_update(iopolicy, i);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}

[Severity: Medium]
When updating the multipath iopolicy via mpath_iopolicy_store(), does this
leave stale paths in the current_path arrays?

If the policy is changed (e.g., from round-robin to NUMA), the policy enum =
is
updated but the cached current_path is not cleared. When mpath_numa_path()
subsequently executes, it reads the stale current_path. As long as the stale
path is MPATH_STATE_OPTIMIZED, the NUMA selector might accept it without ev=
er
evaluating node_distance to find the true optimal NUMA path:

lib/multipath.c:mpath_numa_path()
    mpath_device =3D srcu_dereference(mpath_head->current_path[node],
                                    &mpath_head->srcu);
    if (unlikely(!mpath_device))
        return __mpath_find_path(mpath_head, node);
    if (unlikely(mpath_path_is_disabled(mpath_head, mpath_device)))
        return __mpath_find_path(mpath_head, node);
    if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
        return __mpath_find_path(mpath_head, node);
    return mpath_device;

Outside of the diff provided in this patch, there is another issue in the
broader multipath code to consider.

[Severity: High]
If blk_alloc_disk() fails in mpath_alloc_head_disk() (e.g., due to ENOMEM),
mpath_head->disk is assigned an ERR_PTR but is not reset to NULL before
returning the error:

lib/multipath.c:mpath_alloc_head_disk()
    mpath_head->disk =3D blk_alloc_disk(lim, numa_node);
    if (IS_ERR(mpath_head->disk))
        return PTR_ERR(mpath_head->disk);

If the caller handles this failure by invoking mpath_put_disk(), the cleanup
function assumes any non-NULL value is valid and calls put_disk() on the
ERR_PTR, which could lead to a crash:

lib/multipath.c:mpath_put_disk()
    if (!mpath_head->disk)
        return;

    /* make sure all pending bios are cleaned up */
    kblockd_schedule_work(&mpath_head->requeue_work);
    flush_work(&mpath_head->requeue_work);
    flush_work(&mpath_head->partition_scan_work);
    put_disk(mpath_head->disk);

Should mpath_head->disk be set to NULL on the blk_alloc_disk() error path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D7
