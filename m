Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD4117A309
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165349; cv=none; b=qTr8CTdDvJFbsgMtGioZ2C9SHLoY1SvyLlAeOxT3FPlEcPrQ5S4EDzjBWNLzwtiDWieelUnx+0yPHuVD4gNZlpI5f2PEm5djHySa+wAOcpP2Wpwpq0XjxJ6hHe0jT1QSi91BADoHnwi3CmgfZW6+V6A/o5IggHLPvxC0xqnclQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165349; c=relaxed/simple;
	bh=DtmsvtFakXdF7WqOKCV5vTZSDTvoRyzT+xdQNigF8zU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KZGJHtZ1ZK1UkzyZMWBLVCOktyqIJ7LpblRty4fy/EeZME6GQEWSRxJdZjPfCy8G06u1NToIcXp3m98xQ2W/9wBPGCwsVCNjmbcXG+uS+J/fWeBt8/iubTQ07QhW3zQ0TrVk0QUz2d+86l5vuNuiSF6PKtN7SSGI3zKAyZgFvUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hy1HnAj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hy1HnAj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF75D1F000E9;
	Mon, 27 Jul 2026 15:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165347;
	bh=Tuf++sUusF7VfpNQGSWHAlHI0UunXjHcE6k1RMnHSUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hy1HnAj49wKPwJ5Tkxlbjc81pUvPMJKY7HqtqQbFm4suEpLoEMyhHETQRPOq3faQG
	 BExBplNQGWBzrWbHfGiJTyHW3X/6eTka9WO+ntGBI7AtJGSL3AZHi2AaPcuY3p65dn
	 WDhvp+sKm1+nwG9g9LKDkP89udFUAyAEAhmXSjq7kwShoB6ZfYY8o21u95lzzci0k6
	 +0BMxOGN8fxTYZVJGQOFydqZvkriXb1VSTbDZ7aKVSA47zgxBEHOQAmWRBnJzP4FNV
	 TQcI25kjkXXrVqmCGB7dVN9tRykyThikt2Lg1tZDuZsHGNUjU7H74VutdocAkB0gcn
	 6Usnx7GI6BfuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/27] scsi-multipath: introduce scsi_device head
 structure
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-13-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-13-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:15:47 +0000
Message-Id: <20260727151547.AF75D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The `smpdt` (mpath_head_template) is defined without implementing =
logically required callbacks, which will lead to a NULL pointer dereference.
- [High] scsi_mpath_unique_lun_id treats a 0-length Unique LUN ID as succes=
s, leading to unintended grouping of devices with empty IDs.
- [Low] The function `scsi_multipath_sysfs_group_visible` and the macro inv=
ocation `DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)` are defin=
ed but never used.
--

--- Patch [12]: [PATCH v5 12/27] scsi-multipath: introduce scsi_device head=
 structure ---
commit 0296ab446bccfc5a00926fcca72b8b18f69d4e30
Author: John Garry <john.garry@linux.dev>
Subject: scsi-multipath: introduce scsi_device head structure

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.
A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 947f3e2103e6b..5d19ab6a89eb5 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -70,6 +74,55 @@ static int scsi_mpath_unique_lun_id(struct scsi_device=
 *sdev)

[Severity: High]
Does this function mistakenly treat a 0-length Unique LUN ID as success?

Looking at scsi_mpath_unique_lun_id() in drivers/scsi/scsi_multipath.c:

	ret =3D scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
				SCSI_MPATH_DEVICE_ID_LEN);
	if (ret < 0)
		return ret;

If a SCSI device responds with a valid VPD page 0x83 but a 0-length SCSI na=
me
string, scsi_vpd_lun_id() returns 0. Since this code only checks if (ret < =
0),
it will accept 0 as success.

This could cause the multipath subsystem to incorrectly group distinct devi=
ces
with empty IDs together, as strncmp("", "", 256) will match, routing I/O
intended for one disk to another entirely separate disk.

>  	return 0;
>  }
> =20
> +static void scsi_mpath_head_release(struct device *dev)
[ ... ]
> +static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
> +{
> +	return true;
> +}
> +DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)

[Severity: Low]
Are this function and macro invocation needed?

They appear to be defined but never used to gate an attribute group in this
patch.

> +
> +static const struct attribute_group *scsi_mpath_device_groups[] =3D {
[ ... ]
> @@ -89,6 +142,74 @@ static int scsi_multipath_sdev_init(struct scsi_devic=
e *sdev)
>  	return 0;
>  }
> =20
> +static struct mpath_head_template smpdt =3D {
> +};

[Severity: High]
Can this empty template cause a NULL pointer dereference?

Because smpdt is defined as an empty struct, all its function pointers are
NULL. The multipath core unconditionally invokes template callbacks (such as
is_disabled and is_optimized) without checking for NULL.

When a multipath SCSI device is configured and processed, invoking these
callbacks could trigger a kernel panic.

> +
> +static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head;
[ ... ]
> +	if (mpath_head_init(&scsi_mpath_head->mpath_head))
> +		goto out_free;
> +	scsi_mpath_head->mpath_head.mpdt =3D &smpdt;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D12
