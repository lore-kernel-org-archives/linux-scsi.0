Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E205304C7
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992305; cv=none; b=okVCxSBUuC+aDGV9uOqMi3bypbrclPxlJdAFyyXv2HMgkWYb9SrCre/Ce2avXP2LnTYDqaQT+9gSeg3/8IJQWyX5qHWbqJRuCRSDifU3jCH3Ag33wCV7TW9+8x/TcMV/0Tacbp4+BWImLApBoNPyTaDpplraf1Ub9qb/lMOm2WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992305; c=relaxed/simple;
	bh=EQ1E9CtwH25S4Ik6cJJ565FX3j7npmffZgvhfw07nb0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XOJyUji634ml1rdkv8J+z61UiYSXt70E6XqYaBWEYjUJd+CbS4l/wKJGj49iOiG7bl+bF7q5Ztuv8/o6jtyHsZQ20kKXU30ngPMS3dbVNRzo8U1nc98FCxM3B5+iv3W9O0KdNSPRnMTfgxwO5gIyBoa2rv8SClsiIqSPNU+/Y0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWPuP1A/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWPuP1A/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027C01F000C4;
	Wed, 14 Oct 2026 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992304;
	bh=qsKwzWTBgydGV5OO25TR3O2nMzjMt+H+YUti1PUV6XY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fWPuP1A/hNPRfzs9WZLHG73E4e+2eWV/kWE3055FUJE9Eh6BleO59zN1Fctfods/d
	 6Nmle3M4knVOA/BGtlR9uNQa5LawyeEGlOo2HpsGDTBqalIeD+Wdtce7vgvkhSfW30
	 C3psRiqgG9sPO2ep8MKHq9RqjGa2QSvBZcqUsJnzGaCfwZpj4J0Ma5psXmAyeNW51l
	 p3EHjttieDnZLgna3YhB7jSvwf5ZWQp6J+rrk+3OIiYoxhdbOq/zzpiOkvhG4sWFSa
	 QeJaOfwy6Wg+JsZDCgivRsM3KRoNx5NcFagf1zhskVf1UshAtmhdPdCYDwIV78k8Hd
	 CHFRKkWQ+KGjg==
Message-ID: <sashiko-outbox-171480@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/6] scsi: mvumi: widen the flush cache loop counter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014151914.3632701-7-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
 <20261014151914.3632701-7-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:38:21 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] scsi: mvumi: target ID and LUN overlap causes command misrouti=
ng
--

commit 74a1c4d0f801df93a81b66efae4a7d7d5c3af7b9
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: widen the flush cache loop counter

mvumi_flush_cache() walks the targets with an unsigned char counter while
the bound it compares against, mhba->max_target_id, comes from the u16
max_devices_support field of the firmware handshake page. A controller
reporting 256 or more devices makes the counter wrap back to zero before
it ever reaches the bound, so the loop never ends. This patch gives the
counter the type of the bound to prevent this wedge.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 07cfac9276e7b..090ae79ec8c3a 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -769,8 +769,9 @@ static unsigned char mvumi_flush_cache(struct mvumi_h=
ba *mhba)
>  {
>  	struct mvumi_cmd *cmd;
>  	struct mvumi_msg_frame *frame;
> -	unsigned char device_id, retry =3D 0;
> +	unsigned char retry =3D 0;
>  	unsigned char bitcount =3D sizeof(unsigned char) * 8;
> +	unsigned short device_id;
> =20
>  	for (device_id =3D 0; device_id < mhba->max_target_id; device_id++) {
>  		if (!(mhba->target_map[device_id / bitcount] &

[Severity: Critical]
By widening the device_id counter to unsigned short, this code now allows
target IDs of 256 and higher to be processed. Does this safely interact with
the I/O submission path?

Looking at mvumi_build_frame(), the target ID and LUN are packed together
into the device_id field using a bitwise OR:

drivers/scsi/mvumi.c:mvumi_build_frame() {
    ...
	pframe->device_id =3D ((unsigned short) scmd->device->id) |
				(((unsigned short) scmd->device->lun) << 8);
    ...
}

If a target ID is 256 or greater (e.g., 0x0100), its bits will bleed into t=
he
LUN space. For example, an I/O to Target 256 LUN 0 would collide exactly wi=
th
an I/O to Target 0 LUN 1.=20

Could this lead to silent command misrouting and data corruption for
high-numbered targets newly unblocked by this patch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014151914.3632=
701-1-yhlee@isslab.korea.ac.kr?part=3D6
