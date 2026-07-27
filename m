Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C73C3443
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785178743; cv=none; b=ttjLCaEMhDrfxTDcD3q2cr4ZVR22Y18XQauvKZoeWgdgy56r26T+V47JE+utiHDGg0M6K9Cb1weTWylUeKKpJqDkFbDhJ5eHFe+Q5LSp8WrApFTTKRIL7s0qht4mwhhs7eS3QbUMnLM+F05SqS+UhQWUZfLJDtQiushvbOHVSeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785178743; c=relaxed/simple;
	bh=S2IuUlohK7dHB/5TvfooD8vWK2W3gwtlbGAsEVzKL3M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L0yQ5ymrl8iVEQX3ECYOd1i50h7RJWQJjvizrUjDl47UmseLWz9t6Z4muevgwqGRy+bzYLihvLtp9i5hoUlk0SXdUAP3fQZMIyw+4KNjoBJYj3Je6Y5zrAXt8S9z4Bk+LKXfD7E/x4DOf6LrWmJUx6uYK16R98XdDWCZXM9YJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIROb6iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIROb6iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C141F000E9;
	Mon, 27 Jul 2026 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785178741;
	bh=xh5eWsNEcZyfZlbcnnWZm6DSnAKAE+tJEexib9i3Bw0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EIROb6ivTICBucGWZ8/36IOLrLfFLQK3jUWYYSX2VihIyYeMualII6qoovaSd9Rdi
	 RF9lwQSFqw3ifn8b320yyttwjSjtqQM3tswPcz836A3I0aDQhVZ9cPHL/Asx5nUWDl
	 Q0jczL/oI8N2CYoe3KTmu0QZTodxpZv+hjEanLJFZ7ZfhnN7f2Se6elAUo9FEjHmCu
	 u12OquE5sEHyBydh2ZcC7tzCJajjFfZZ/k8rjrE6vVHptz3OXnISOEQHDreJHOMBoo
	 Lz28sd9+bx09dCKepMdsrsjj+S3bn7+gxD5dlZEun4E0P6k7fkuxHMbM7fZo2bHSQD
	 PkZP2VNmy+dlQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/27] scsi-multipath: introduce basic SCSI device
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-12-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-12-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 18:59:01 +0000
Message-Id: <20260727185901.B3C141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi_mpath_unique_lun_id incorrectly accepts a 0-length LUN ID as =
a valid unique identifier.
--

--- Patch [11]: [PATCH v5 11/27] scsi-multipath: introduce basic SCSI devic=
e support ---
commit b27d35f732d009c9f3684249b66e5403b7b120c1
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: introduce basic SCSI device support

This commit introduces the scsi_mpath_device structure to hold
multipath-specific details for SCSI devices. It also adds a module
parameter to control multipath modes (on, off, always).

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> new file mode 100644
> index 0000000000000..947f3e2103e6b
> --- /dev/null
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> +static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +	int ret;
> +
> +	ret =3D scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
> +				SCSI_MPATH_DEVICE_ID_LEN);
> +	if (ret < 0)
> +		return ret;

[Severity: High]
If a SCSI device returns a 0-length designator in VPD page 83,
scsi_vpd_lun_id() will return 0. Does checking only for (ret < 0)
incorrectly accept a 0-length LUN ID as a valid unique identifier?

If multiple devices lack a unique ID and return 0, could they all be
assigned an empty string and incorrectly aggregated into the same
multipath group? This might risk routing I/Os intended for one device=20
to a completely different device.

> +
> +	return 0;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D11
