Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC06148CD41
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332809; cv=none; b=TMui5y8+dhEuqHYcFVaKFmB53CLu3k9T1Q7owQsSnK/QTHG7ZhqtsP5KRDaNZxVj4mloMcaLqr8iZzezLFWvwzrEF0jdeNLTOq4u1gNQhvbOA/15TOtbYWyPAep77B6czeMrAEuawPuVIvuabETb/U51mwObsx/mXFVIkqL6Uzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332809; c=relaxed/simple;
	bh=/MIyhcc4d+Wgbx0CIkvYdDE1vWWeQ4Eg1LVOKQsjmd4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VCrkNYMeFCKKgbIkFmv0DcxCzaTPXnrdVlzwAy+9asAeX1mvn1MNpcibB8QkquzwutQuBOzWBLn2og6v783z/xF715Ew4ijqPyvfx3I/JmbeI/bl8QsL5puX2n6v/pTKEr+f3/ZJljBN7veDO4Na+rZ/PkKast3asSoyKpaev54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJ7DHqSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJ7DHqSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECAD1F000E9;
	Wed, 29 Jul 2026 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785332805;
	bh=JnhhjM9o21Jm0r/bifHf3gwpun9lllfOnwFDziNr8Lc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fJ7DHqSY2eCb3P5pJHVRqI8uecMkr5nY5t2mkcKTJYwfHxHlXnkDn7yk/lqFVtxKV
	 zmE8gcSRbz6zksOOFZAWpCIdUFe2Eu5Nc4T4Ky03BPQhNfrSERkANyA/eXT57itlby
	 mvguy2ByFdv00+s2tBre8QXWgy90ZdrGCeQqLaFsxe/UdxQKbD65GfmXE0o8buP38V
	 iihkh2ksoOkDLpgg56dMxjBuWSC+ufi5sdNbLq+U5o0r8w55L4jl9USNtp+XICiEYg
	 oU5nBu3pgR+Qr912HdSXUVOSF7FWQeCgYDmrzdrP1Cgj468Y/i/cyu4Gd2JSm9pGZQ
	 bLGighH/NoPUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 12/27] scsi-multipath: introduce scsi_device head
 structure
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-13-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-13-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 13:46:44 +0000
Message-Id: <20260729134645.0ECAD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The struct `mpath_head_template smpdt` is defined completely empty=
, lacking logically required callbacks, leading to NULL pointer dereference=
s.
- [Medium] The patch omits the logic to create sysfs links to member `scsi_=
device`'s, contradicting the stated commit message.
- [Low] The function `scsi_multipath_sysfs_group_visible` and the macro `DE=
FINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)` generate unused stat=
ic code, causing a `-Wunused-function` warning.
--

--- Patch [12]: [PATCH v6 12/27] scsi-multipath: introduce scsi_device head=
 structure ---
commit 41b0248171de9edac7171ac10282e0c5b3f1056c
Author: John Garry <john.garry@linux.dev>

scsi-multipath: introduce scsi_device head structure

Introduce a scsi_mpath_head structure to manage multipathing for a
scsi_device. A list of scsi_mpath_head structures is managed to lookup for
matching multipathed scsi_device's.

> The sysfs device folder will have links to the scsi_device's so, it will
> be possible to lookup the member scsi_device's.

[Severity: Medium]
I notice the patch doesn't seem to contain the code to create these sysfs l=
inks
to the member scsi_device structures. Is this implementation missing, or is=
 it
planned for a future patch?

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 5559e2e8d64a8..30a2d01be8aaf 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> +static const struct attribute_group scsi_mpath_device_attrs_group =3D {
> +	.attrs =3D scsi_mpath_device_attrs,
> +};
> +
> +static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
> +{
> +	return true;
> +}
> +DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)

[Severity: Low]
Is this function and macro used anywhere in this patch?=20

It looks like DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE generates a static function=
=20
that isn't assigned to any attribute_group.is_visible callback, which might=
=20
cause a unused-function compiler warning.

> +
> +static const struct attribute_group *scsi_mpath_device_groups[] =3D {
> +	&scsi_mpath_device_attrs_group,
> +	NULL
> +};

[ ... ]

>  static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>  {
>  	struct Scsi_Host *shost =3D sdev->host;
> @@ -91,6 +144,74 @@ static int scsi_multipath_sdev_init(struct scsi_devic=
e *sdev)
>  	return 0;
>  }
> =20
> +static struct mpath_head_template smpdt =3D {
> +};

[Severity: High]
Will this cause a null pointer dereference when the generic multipath core
attempts to evaluate I/O paths?=20

Since smpdt is defined completely empty without any callback assignments,=20
function pointers like mpath_head->mpdt->is_disabled will be null when=20
dereferenced by the framework.

> +
> +static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D12
