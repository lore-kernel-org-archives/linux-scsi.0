Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEAD4772A6
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 11:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788780822; cv=none; b=Kl8zmDyhhH1fUo2hoBA6aR9cMavykj1CdJ9gev40OlTX84KkUK8WGFFvHHrjzjrzBqHuUJ6Vxr/m9D7PHtfb+z8tt78LTpNKhVHQwskbog6AzdvMCY8scSeC4DLC8cRBD7q0qD7jAjK0H2IOuR0VHXhkk07509VWgHK60joFeAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788780822; c=relaxed/simple;
	bh=kNCxP1j0NWym3TJK34o7OufncqFb72ad9p67GpOW3EA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UVYACxOaFWopS6pd/5DvcqnDZXDBl+wzXievqCbPsXJHyW9AsZLRPD9xwOhY9pDFc1vyFeBp7W73hBTY6VBED22RLq0LUbGuITXrPa9icKUEhguFs8w2vtlnyPHpUCHrEKcES2sOPS8CjYGBz+DO0LNKEMukizeRS3lwqAGvxZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0bie3AC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0bie3AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395EA1F00A3A;
	Mon,  7 Sep 2026 11:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780821;
	bh=nlrfEfgJ4lOL2tSAP3WUBUbkEUaPYHqsgdDEmPshKYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V0bie3ACLptQrGTxEdVYrvW92G5CyjFxyY7WDq3/rbzza5ObaHWeBh0JsLX0tLOji
	 O8HQlSFrPsUYU9ydCEGum1kzJOsCLa0RvCECuk9cxMVvWhqDZl8fiPsHVUCC+V3A6X
	 B1keGwI5PR6vRXPnn1vZptfJ1nHRenVd/IDm8bToe7Zxa23bZa2vPT7mZoF2rSgsc6
	 y7MFG/1VrhPwAOljCe3QkfRzlYlqt/bPTHgjXi+CgURkhNC6rXIh615uNHtyoMa4vK
	 d7KBDdCcvR1RipiyPE9itDhwugj5jD5h9AVJzj0pAPQuHKO+PlBTrSOtNwOeuFlMu9
	 VBBPselO8ey5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 11/27] scsi-multipath: introduce basic SCSI device
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-12-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-12-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 11:33:40 +0000
Message-Id: <20260907113341.395EA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi_mpath_unique_lun_id ignores string truncation of the unique=
 LUN ID, risking incorrect multipath grouping.
--

commit 1346e25fe4922ff0f78a31848664daccf7121f0f
Author: John Garry <john.garry@linux.dev>

scsi-multipath: introduce basic SCSI device support

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details. A module param
is introduced to enable multipath. SCSI multipath will only be
available when supported and unique ID is available in VPD page 83.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> new file mode 100644
> index 0000000000000..5559e2e8d64a8
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
> +	else if (ret =3D=3D 0)
> +		return -EINVAL;
> +
> +	return 0;

[Severity: Medium]
Can the LUN ID be silently truncated here without returning an error?

Similar to snprintf, scsi_vpd_lun_id returns the number of bytes that would
have been written. If a device provides a pathological T10 Vendor ID that
causes the expanded string to exceed SCSI_MPATH_DEVICE_ID_LEN (256 bytes),
the string in the buffer is truncated but the returned length will be
greater than or equal to SCSI_MPATH_DEVICE_ID_LEN.

Because any positive value of ret results in returning 0, a truncated ID
will be treated as a success. If the unique identifier portion of the ID is
pushed past the 255th byte, multiple distinct LUNs might share the exact sa=
me
255-character prefix and be incorrectly grouped together by
scsi_mpath_find_head.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D11
