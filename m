Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B717741C6A
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166137; cv=none; b=VX0F2mgzdQazk4vV6BPFhdMLBgaGCXLPI3WBpT3tcNWMAwgKliCOllJ3ijT9bhlclAIQo7wFss6e4tn0FUk0FAvXMf1Do9e2kcOsfKeJFD/qiAHqce5KUHDz5M/uC1eePLETKe082kLolhH4DyyEwQ8tsGOYdcKHYJSqiu72Mm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166137; c=relaxed/simple;
	bh=USMnnU46AGyoiKJ2c/R+m0wcdG3aS4oyL/jW4T7+7wQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AMDWPpSyFwYP4KWexOG3Hqe7GZpuvVxhdcc5+2w2uWc073ijodwmZlIxcRo96mqWWAGuFTqUqqPSsf2aGkBTuHKEWAmowjHehPL8hkpB6R0umFJHZM9OJnt0moXkedKqKXJRu4e2KtG6gbXVVApX9Y5bvqW3Q/0s4tPhoAYi4iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/Be3tpi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/Be3tpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3854F1F000E9;
	Mon, 27 Jul 2026 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785166136;
	bh=+JuxIaBC8V+jMAEbVhjXKie7/I90MNNuUXAM3Njaw6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D/Be3tpiCWTaWXNqGVvOfmPYD6nh0Vijw6HI9p8v83IuJ5LCLPKs942Dpk97FmxLU
	 PQn2GUHXeA/C+ifeDrcfnfhYRl3we/C60iqdiSlRp3HUwysqsSpJRiluOSBr2u9wN2
	 jcWZLZe4KT0OpM/Rnym1IpDuNigpeYiPUYPvKQOIPksUQG+eR9l000GVFCidutMftd
	 9oL1Xt0BhhyjB/R6xP7+CIsJtKj1PNuskVaOOEQvxu8lpON6cV9JsHyPbk2CSrkb7v
	 bnjLxQuLw5IVUUP57uJRicEoAlhfOSLBfHhG6HzlC5FeyTo2nXWE0kb9gjKUuREy6z
	 q8XgrAmq3KlIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 27/27] scsi: sd: add mpath_queue_depth dev attribute
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-28-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-28-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:28:55 +0000
Message-Id: <20260727152856.3854F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The sysfs show function `sd_mpath_queue_depth_show` returns 0 wh=
en the iopolicy is not QD, causing reads to return EOF (0 bytes).
--

--- Patch [27]: [PATCH v5 27/27] scsi: sd: add mpath_queue_depth dev attrib=
ute ---
commit a1c72efbc115f45170fc3510049d2e925ee24a95
Author: John Garry <john.garry@linux.dev>

scsi: sd: add mpath_queue_depth dev attribute

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6b6aef361ae22..fbf9da686f25d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4159,9 +4159,28 @@ static ssize_t sd_mpath_numa_nodes_show(struct dev=
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
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +				scsi_mpath_dev->scsi_mpath_head;
> +	struct Scsi_Host *shost =3D sdev->host;
> +
> +	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
> +		return 0;

[Severity: Medium]
Should this return a standard negative error code like -EOPNOTSUPP instead =
of 0?

Returning 0 from a sysfs show callback means zero bytes were written to the
output buffer, causing user-space reads to receive an immediate EOF and see=
 a
completely empty file instead of parsing an integer or receiving an error.

> +
> +	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D27
