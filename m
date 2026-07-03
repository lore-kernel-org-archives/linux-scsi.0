Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B4B38A73F
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 12:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783083424; cv=none; b=lToIaiO+dUilksdDVb1sr7slu0dbPbSbCnnrXUee6emsmdQG/r4X6fzEUqeUcqp4xVaKL/8pGkVAfQtbCRmilP6f0WgcF/uIcN3MLXrLp/yP6XARs2eKrRQzq5ntHOppq83iCkZyA1H48r9hKzQfHoESmw51RN+aDhQnrpeVZv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783083424; c=relaxed/simple;
	bh=cV7AKR+dch7gQ+DrP/Mri8+Qm8DX2sCjPOnRmwy+gXY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tq1/CbgZq7MjKXrmni76UNN0oHPYMIPL070LtuiiCTwHwTZ3QjiunehrvxorFY12dERTLt9ZLdk+U2LpcoCw789ySerbk0vesXz5VeVC89UeqcmfSUJtRcG0tsmI1BmlHpHewEU/rjnB3PJd8iQvX/deRHKIH2MeSbPlizJqghU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CAXkCA3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CAXkCA3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9604B1F000E9;
	Fri,  3 Jul 2026 12:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783083422;
	bh=bvX8RLID4M1hD+0VynKiYwgGXM0+V/YezH/VZ85CRyE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CAXkCA3/jH0hinCSue1bhymnUZGmPl8ZtFjzEtOl0/FbITmbV0mdAm08dz07m3MKZ
	 4b8onS1nquB8uirWJ1OOz2o+sj5AvYE6IV+ApT63Mt+Xp6mT7L0eGRo4n8dM/e0IUH
	 RgRRE6mAycbiRHS+fGGsvYJOwutntcA4Vi2OhPJS4BwjPdqRW3uzawddACE2sckBAu
	 /y0lleaq5eTYm822NMSzmsgs3+OUJ+zHCkDZTkOXyGM6dNL/jXE6bBhwmb8gDarxMS
	 B+Iv2F7CsXR2rreh8VRVUr1qSqryZcLKP+IcY1dUjj2gPVpxfv1ssMlDMy/rBG/yQ2
	 fE4TyQgVfdbbQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/17] scsi: sd: add mpath_queue_depth dev attribute
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-18-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-18-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 12:57:02 +0000
Message-Id: <20260703125702.9604B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] The patch calls an undeclared function `mpath_qd_iopolicy()`, =
which will cause a build failure.
- [Low] Returning 0 from a sysfs `show` callback yields an empty read (EOF)=
 instead of a proper error code.

Pre-existing issues:
- [High] Concurrent sysfs read of `mpath_queue_depth` during device teardow=
n accesses a freed `sd_mpath_disk`.
--

commit d24252fbed25782c1f5fb88edab9e008070c4b9c
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add mpath_queue_depth dev attribute

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5e0514304d81f..f6feccd557e76 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -4088,9 +4088,27 @@ static ssize_t sd_mpath_numa_nodes_show(struct dev=
ice *dev,
>  }
>  static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NUL=
L);
> =20
> +static ssize_t sd_mpath_queue_depth_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct gendisk *gd =3D dev_to_disk(dev);
> +	struct scsi_disk *sdkp =3D gd->private_data;
> +	struct scsi_device *sdev =3D sdkp->device;
> +	struct sd_mpath_disk *sd_mpath_disk =3D sdkp->sd_mpath_disk;
> +	struct scsi_mpath_head *scsi_mpath_head =3D sd_mpath_disk->scsi_mpath_h=
ead;

[Severity: High]
This is a pre-existing issue, but can this sysfs read race with device
removal and cause a use-after-free?

During device removal in sd_remove(), sd_mpath_remove() is called to drop
the reference to sd_mpath_disk (and free it when the refcount hits zero):

sd_remove() {
        ...
        if (sdp->scsi_mpath_dev)
                sd_mpath_remove(sdkp);
       =20
        scsi_autopm_get_device(sdkp->device);
       =20
        device_del(&sdkp->disk_dev);
        del_gendisk(sdkp->disk);
}

Since device_del() and del_gendisk() happen later in the removal process,
local userspace can trigger a use-after-free by reading this attribute in a
loop while the multipath device is being hot-unplugged.

> +	struct Scsi_Host *shost =3D sdev->host;
> +
> +	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))

[Severity: Critical]
Is mpath_qd_iopolicy() declared anywhere in the tree?

Compiling the kernel with CONFIG_SCSI_MULTIPATH enabled will attempt to
compile this code, but a search of the source tree indicates this function
is neither defined nor declared, which will cause the build to fail.

> +		return 0;

[Severity: Low]
Does returning 0 here result in an unexpected End-Of-File?

Returning 0 from a sysfs show callback causes the VFS to report 0 bytes
read, which userspace interpreters like cat treat as an immediate EOF,
resulting in empty output.

Should this return a standard error code like -EOPNOTSUPP instead?

> +
> +	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
> +}
> +static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, N=
ULL);
> +
>  static struct attribute *sd_mpath_dev_attrs[] =3D {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D17
