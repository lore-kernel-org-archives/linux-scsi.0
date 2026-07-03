Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ABE2FFF81
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783082612; cv=none; b=XDHmNnXZhsVsVSlQEpbqniihq7IW2ZKt7DQsQaqGtSlC1bRs9tI/O8skgGXzAUAHSVFZJjy/RTwQIQbNtRdjerSgwJTE+BPb1MLKWD6abA7ZInuO76mbOkS1APRCmhvweklwARXC4D1O5zpHbxTlKs+jo+Ble1nNq57LuKUbiwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783082612; c=relaxed/simple;
	bh=N2r0Kqm8XcayRuQFJp4+WFi6LqIsrEJ6dFQ3Jv0KMC4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I3DKdAr32kjlvz6g9w7obXnAcNBMgYGGGX2KE54/drf4hasBZMxVtcU8U/DP8B4sSfjlijrNWJkx17MLWDWcBs4zJRX0yCx6FyXtEjkbx82pW5JV8WhMcchMYIwiFjpm4Vg171EAWc5CdfYpwqE/X3PExKmUFlsJDtZwXd8vvME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvqqxG12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvqqxG12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6476A1F000E9;
	Fri,  3 Jul 2026 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783082610;
	bh=5QhaG8RWqoNX6C2ogPUCjl96ecnpIAZYCi9Jzn0t8XQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jvqqxG12qQjyQgS9bJcuT/X6R5il8sizWJwmM2b2r1nqJ4MGw0EDzGVAmRH1dc/NX
	 p2aceXoboM845XGTBzLp9xzU8uPiQFVDVYKeuiJyOh7E+E8qW82vxuNiedHxSTRirg
	 iqOXmARnSiO7E9xPrvFUCXloXyHS3C3g8/xbgP4sK0qo/CCkZjDLKdzRWQ8XIxLKit
	 of0nAws9H471HkbIgWccYB8tDOL+EjXSuLKRWNgPkMq09IH81nv3aepncdKtC42n7b
	 ASFIdT7AT8dwpDXhRQOh3Yyf34p1imqTrz2xxFC0asYsq1Etdcy0mDNSoZ2OvYeXUT
	 ykTA/tJwrNhjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/17] scsi: sd: add mpath_dev file
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-16-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-16-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 12:43:29 +0000
Message-Id: <20260703124330.6476A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Concurrent sysfs read of `mpath_dev` can trigger a Use-After-Free =
of `sd_mpath_disk` during device removal.
--

commit 96501c42f9a149bd257256a80ef8d931781b2efe
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add mpath_dev file

This commit adds a mpath_dev sysfs file to allow looking up the multipath
disk from the per-path gendisk directory.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a9a29e50f5eec..0c77466f8291a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -4059,6 +4059,52 @@ static int sd_mpath_revalidate_head(struct scsi_di=
sk *sdkp)
> =20
>  	return ret;
>  }
> +
> +static ssize_t sd_mpath_dev_show(struct device *dev,
> +			struct device_attribute *attr, char *page)
> +{
> +	struct gendisk *gd =3D dev_to_disk(dev);
> +	struct scsi_disk *sdkp =3D gd->private_data;
> +	struct sd_mpath_disk *sd_mpath_disk =3D sdkp->sd_mpath_disk;
> +	struct scsi_mpath_head *scsi_mpath_head =3D sd_mpath_disk->scsi_mpath_h=
ead;

[Severity: High]
Can reading this sysfs attribute concurrently with device removal trigger a
use-after-free of sdkp->sd_mpath_disk?

During device teardown, sd_remove() calls sd_mpath_remove() before calling
del_gendisk(). This frees the multipath structures, but the mpath_dev sysfs
attribute (which is tied to the gendisk) remains active and accessible until
del_gendisk() finally tears it down.

If a user continuously reads this attribute during hot-unplug or module
removal, it appears we could blindly dereference the freed sd_mpath_disk
pointer here.

> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +	struct gendisk *disk =3D mpath_head->disk;
> +	struct device *disk_dev =3D disk_to_dev(disk);
> +
> +	return print_dev_t(page, disk_dev->devt);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D15
