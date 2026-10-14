Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7960D47F786
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015980; cv=none; b=T+YkNp7/2yiIx0e2vt1Qs8aN7GrC4N2BRoHxO2sWzsxtGDCv/DFRTPoNHMdYIwD5PE1UwPlm/osdaO61LU03lVWE2HBIbpm9v5koaKWaQOgDxKxvHYbN9WayUvGGDK/3ptsV0Xz+lWJ+erjv16mas2T/vJGeV2oPP4BFmGOtx8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015980; c=relaxed/simple;
	bh=84Mpe3PU9Tv8A2VnzGQMnN0voazjMgo0OZjotfcuDAk=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=Xta5q42FhsfkMD5AOX3xF1yo+rHdk+CfUJf4HQ4WoPCkjVhJREqr+vfkRyGagAvYFLjrPU+kESkrCp6lXokvy1v5Tb8VtCo+1NBC2c+Dl50KWxeY/3UdXiOfhsZlIrjWnUVm7Dxeu7SNHZXd8eLOinXP7S5kP6cdWaRMjvXZ2As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BINH/de9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BINH/de9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2981F000C4;
	Wed, 14 Oct 2026 22:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792015976;
	bh=JbusAKmedERjfnfJ7r7fqDyBnjpuQ2xs9UilVN/sEBY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=BINH/de9/KavY1Ka0Chex/lW9ac2EFDcNEULYP7p4tyU8Y+RR4948FQ5bX5Mefcco
	 fZ7y4JuUWjcnJSx3z6+LKO4p/edRmrZHUhpLY8J87lNnFZvT7p+ZaNJ9YSzRYS9t95
	 TDi16TQ8HzLq3MIE/nv0nqdGtJ4V4tq7IJ1rZX7fvOl9z4eGo/bUNFFeIwoKcU+Jsk
	 krAnJUbQKleUmlFFUiRZbu0eU94slH0LisOpH+0b5Bspaj2wG5XtjaT/Iwdhs8nhG/
	 LUHaY3i1HQqZKzvdAF7P4fhsoe+bniFVsS0aodqEl/5S2lzh2BGheIerzD5U/eVOeC
	 IcGYTz+Hfkm5A==
Message-ID: <sashiko-outbox-171947@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/5] scsi: core: Protect INQUIRY sysfs attributes
 with mutex
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261014220014.94330-2-brian@purestorage.com>
References: <20261014220014.94330-1-brian@purestorage.com>
 <20261014220014.94330-2-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:12:56 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: sysfs modalias and uevent missing inquiry_mutex protection
--

commit 81f6a8643e20a98783acfb264a3488a0b0ad95ac
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Protect INQUIRY sysfs attributes with mutex
   =20
All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
rev, cdl_supported, and the binary inquiry attribute) read data that
can be updated during device rescan. These reads must be protected
against concurrent updates.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index fe54792ed69e4..a20707f6f1ac7 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -638,21 +638,30 @@ sdev_show_##field (struct device *dev, struct devic=
e_attribute *attr,	\
> =20
>  /*
>   * sdev_rd_attr: macro to create a function and attribute variable for a
> - * read only field.
> + * read-only field. inquiry_mutex protects INQUIRY-derived fields against
> + * concurrent updates during device rescan.
>   */
>  #define sdev_rd_attr(field, format_string)				\
> -	sdev_show_function(field, format_string)			\
> -static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
> +static ssize_t								\
> +sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
> +		  char *buf)						\
> +{									\
> +	struct scsi_device *sdev =3D to_scsi_device(dev);			\
> +									\
> +	guard(mutex)(&sdev->inquiry_mutex);				\
> +	return sysfs_emit(buf, format_string, sdev->field);		\
> +}									\
> +static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
> =20
>  /*
>   * Create the actual show/store functions and data structures.
>   */
> -sdev_rd_attr (type, "%d\n");
> -sdev_rd_attr (scsi_level, "%d\n");
> -sdev_rd_attr (vendor, "%.8s\n");
> -sdev_rd_attr (model, "%.16s\n");
> -sdev_rd_attr (rev, "%.4s\n");
> -sdev_rd_attr (cdl_supported, "%d\n");
> +sdev_rd_attr(type, "%d\n");

[Severity: Medium]
The commit states all INQUIRY-derived sysfs attributes, including type, must
be protected by inquiry_mutex against concurrent updates.

However, shouldn't sdev_show_modalias() and scsi_bus_uevent() also be updat=
ed?
They both read sdev->type locklessly to construct the modalias string:

drivers/scsi/scsi_sysfs.c:sdev_show_modalias() {
    ...
    sdev =3D to_scsi_device(dev);
    return snprintf (buf, 20, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
}

drivers/scsi/scsi_sysfs.c:scsi_bus_uevent() {
    ...
    sdev =3D to_scsi_device(dev);
    add_uevent_var(env, "MODALIAS=3D" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
    ...
}

Can concurrent device rescans cause these functions to read an inconsistent
or transient sdev->type?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014220014.9433=
0-1-brian@purestorage.com?part=3D1
