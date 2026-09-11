Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704B1471266
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118788; cv=none; b=Wrd46VMyT4aiySyElmrPAIc7kJiHAjdcx8gMP4/ys5+dAcvR2351wJ9KN2JmCgy2K04a0oJMOXFXG96k61qnWh70UOP5j1tjhSd+qBscO1OopcZ9FippjRMJF2cdikPNntkhtRVD0yTPTgpAhpSpUhGJ12vXq4Jnl4uKne72K6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118788; c=relaxed/simple;
	bh=qCDrCtPEKHDxGFrO9NJ/8W44FXV81IDlECQ5uG+bONo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D9/4Qvzf95PpGNbCorT/iLZe9SmxvjN7/bMs9ztGxEICb+mXiG5kO3jMHtzVFu59q8j+CVM4bM7MseOg09LhNqH4mM7GVY0xaQmOV3aivZEKNUdD7lJiFDeQKgEmk+Iut1TDOP20Jho8ug2y0ppFOvS5mVheMwZ9ENaIfwDeaH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmutEv4c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmutEv4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BE21F000FF;
	Fri, 11 Sep 2026 09:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789118787;
	bh=U5vGP87MNtJRgfUKutlP2H+8mxXP+NGS4jzlNh9R9dI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mmutEv4cmDIk1AhCKEHxM/A23+eBrYdamLof3v582YJHnY++bujqS5zPsYMaUTtqc
	 RRob4qr9uRzDSZKXgHWGR052yNW3iwvMkr0eqEI1I7grnrJfkAVicsv35BIjDeWEGb
	 fHydPNc62GLzgIeqDIxmjoz9rrtvAfOjnASds9DK4XwngVRv0n8C51RjIYKos0Bb0d
	 tuEWL1E90E31avPDQVjHKCdmSS6xMVCPO91v2FAMEXnPQ+WPLyxZ76reoipGhxR37N
	 l7D5lSFir8GLz8NGNtHHDl2BaSZQrdu6nKCMQtZ856ExclV2+mcDsc87/oWjgDbQEL
	 u6MObRWE66J4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] scsi: pm8001: free CCB resources on allocation
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Hao" <flyingpenghao@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911091011.94676-4-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
 <20260911091011.94676-4-flyingpeng@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 09:26:26 +0000
Message-Id: <20260911092626.C9BE21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Out-of-bounds array accesses and integer underflow due to unvalida=
ted device-supplied `max_out_io` limit.
--

commit 54b6fce7eebff69bdb11ab411c836b69e2bfd3d1
Author: Peng Hao <flyingpenghao@gmail.com>

scsi: pm8001: free CCB resources on allocation failure

This commit adds a common CCB cleanup helper to avoid leaking buffers
when CCB PRD allocation fails. It also moves device teardown into
pm8001_free() and removes duplicate teardown logic from the remove path.

> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 20b02e63be8c9..a747de9a3ca0a 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c

[ ... ]

> @@ -1285,8 +1313,8 @@ static int pm8001_init_ccb_tag(struct pm8001_hba_in=
fo *pm8001_ha)
>  	return 0;
> =20
>  err_out_noccb:
> -	kfree(pm8001_ha->devices);
>  err_out:
> +	pm8001_free_ccb(pm8001_ha);
>  	return -ENOMEM;
>  }

[Severity: High]
This is a pre-existing issue, but does deriving ccb_count directly from the
untrusted device configuration without a safe lower bound cause integer
underflow and out-of-bounds accesses?

Earlier in pm8001_init_ccb_tag(), the driver reads max_out_io directly
from the device's MMIO:

	max_out_io =3D pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_out_io;
	ccb_count =3D min_t(int, PM8001_MAX_CCB, max_out_io);

	shost->can_queue =3D ccb_count - PM8001_RESERVE_SLOT;

If the device provides a max_out_io value smaller than PM8001_RESERVE_SLOT,
will shost->can_queue underflow to a negative value, potentially corrupting
block layer limits?

Furthermore, since the ccb_info array is allocated based on this restricted
ccb_count, could this cause out-of-bounds memory accesses during driver
operation? For example, in pm8001_hwi.c:pm8001_work_fn(), the code
unconditionally iterates up to PM8001_MAX_CCB instead of the dynamically
allocated ccb_count:

	for (i =3D 0; ccb =3D NULL, i < PM8001_MAX_CCB; i++) {
		ccb =3D &pm8001_ha->ccb_info[i];
		if ((ccb->ccb_tag !=3D PM8001_INVALID_TAG) &&
		    (ccb->task =3D=3D t))
			break;
	}

Could an untrusted or compromised PCIe device trigger a kernel panic by
providing a small max_out_io value, causing these loops to iterate past
the bounds of pm8001_ha->ccb_info?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911091011.9467=
6-1-flyingpeng@tencent.com?part=3D3
