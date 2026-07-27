Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364CD41D10E
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164618; cv=none; b=BMNO2tqq8dewptOt2zRFI6z3fAKsU2N2BmpZsiCJ+GkhI+MmPzprmr+K7Jh62QDoEKyAF3tQ0oqgB6hhc71J15oReOi2GyXSKN8FQUXmgst9a3lcuz9wdGlTY/RnwYPoMpaYrybRxGcBK/xRz+jCt7Ef/TCygU+01PihfEut6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164618; c=relaxed/simple;
	bh=5DQTxdHX8+kUrwaHwng78m0i3843kbMHvs85OInTMeI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=elYQFUxNm5xqHdIqgQXkJE1WkS62HSJOcAqnv0Ty9lJP4Ke6kbpJL7Jp2nQQ3mA4b2w5CUd5B+8l6dccVyEnZ+HiGgGnJ4CF/MthKOb0JPiittKGTC4ncNiFq/j3Hv1QNMZDJ6jxGO4Hz8uc0UUi+voVEZ/8dXgh8JXSYLpEs8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWOhrmi4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWOhrmi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89441F000E9;
	Mon, 27 Jul 2026 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164616;
	bh=EKk2sxIifaHxcVSoltpvT9PF3DmNJJS5+2WwoAbsU/Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KWOhrmi46lu37LlGibv60ZxTDFhpCR8A7dZRxZRMqovhTNkp+JDa/x1fHwsUcG4Ge
	 2wWQeDUYHuKUtQ0x9LrKSU5TJNi64Sur49b4fj9wlvp4hSVY/S9S4GK3peJom1iR1e
	 qPV712pDNou1cpfWGqxUaB4hLu9HsVb9yKM924znULMUG1IYHv2JKW7dXj6EswYtXu
	 eSNPjgPqbPgqnr2V5OaN9h2GmssHDMCGOrnuP6wHwZus1cWhrgEI5k6Ojerbc0dqtq
	 z61ebDiwPqSVaQY14z6cBwvIgZ6HuSTN/c4+nisXxZfjZ9gHDbZrQkfFUMYz5oPwu1
	 ZE3tFAerFMxSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/27] libmultipath: Add support for mpath_device
 management
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-6-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:03:36 +0000
Message-Id: <20260727150336.A89441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] `mpath_delete_device()` calls `mpath_synchronize()` without firs=
t removing the device from `current_path`, risking a use-after-free if call=
ers rely on it for full synchronization.
--

--- Patch [5]: [PATCH v5 05/27] libmultipath: Add support for mpath_device =
management ---
commit 036ecbe8e851ac2a476516f8e8a72ff07e94750c
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add support for mpath_device management

This commit adds support to add or remove an mpath_device as a path.
It introduces equivalents to NVMe mpath functions like clearing, adding,
and removing sysfs links, as well as revalidating paths.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index db5f83ebe5d7f..f70049b6cede9 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> +bool mpath_delete_device(struct mpath_device *mpath_device)
> +{
> +	bool empty;
> +
> +	mutex_lock(&mpath_device->mpath_head->lock);
> +	list_del_rcu(&mpath_device->siblings);
> +	empty =3D list_empty(&mpath_device->mpath_head->dev_list);
> +	mutex_unlock(&mpath_device->mpath_head->lock);
> +
> +	mpath_synchronize(mpath_device->mpath_head);

[Severity: Medium]
Does this code leave the device accessible to new RCU readers via the
current_path array?

By calling mpath_synchronize() here without first removing the device from
current_path (for example, by calling mpath_clear_current_path() before
synchronization), new RCU readers could still find and access the device.
If callers assume mpath_delete_device() provides full synchronization and
subsequently free the device, could this lead to a use-after-free?

> +
> +	return empty;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D5
