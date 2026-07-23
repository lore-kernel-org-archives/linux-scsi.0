Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC55427F84
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799396; cv=none; b=RO0nvA0kHkdeMZ6gc1LyrS3yljbgPbqlEjRYJ9aoTf5v9Idd7IFif0J1w6N8nWHp0J+4OYnUOxbJ7soXAzN1UnUkTSGOj0bcpc1H+Dv5nCd++QYW/7gyBV2ApaZ5IvfJjhSi4P5tfG+SMZx9hN/7y3dGF3Qd53fEOiCtfV8oxyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799396; c=relaxed/simple;
	bh=zRqvCGwBiLEZAtu5bBQgm52DrlrSB0ib+rOhJ4SvaqA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Nociiv449tW+fCkJ7OjOlGcsySj6eWGKcyzkEQwJsEZqNEVcs6rF+pZOJ5wLaqlRQ7goE2D774XeRV3PxkdvLmvgoC9A6X8plCzaJbGdXyvMEzUMuwKZnA5YG3FLostJiX9+NoMgRbRSXIxPVeAd0m7DYwBIagxOwFt+uItIJ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPgnk3Fa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPgnk3Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9375F1F000E9;
	Thu, 23 Jul 2026 09:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784799393;
	bh=l0pCfr4GOrGUMgoj25m29fRSpesFHN+COyjqsg3ga8o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UPgnk3Fa8TM7HAG/D/Ewgt3+awDM4a2Ac9i18mLSXWFncREM0V8NFMEyqnIZ/xJgw
	 FLjmiVktNeYppzGDYXpQs10MoxxmEdibJ53bkxC4i+J5f+BpwItyslWw0KRQ0OBV2b
	 dteICa06giVOU/oAmh/IFdk/PpIXBSLy5c+4SLVuBVVj4JrCt1I6taazQBMeJkhfhR
	 V09ridUYqU+fUOoJrEGYPcvA6j3flMMOQjFfsn/OAUIf3mRQJ2BL+uG9kK0C52KS3o
	 sOOYk03MfcQqiRaU5RkbKl+nFK2XqYrySbgYdBqf1SK0TUlR9QEsDRUqQo9Fg8Qo21
	 1bM4NQXTp13GQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 16/56] scsi: qla2xxx: Enable get_adapter_id mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-17-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-17-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:36:33 +0000
Message-Id: <20260723093633.9375F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Userspace access to Buffer-to-Buffer Credit (BBCR) data on QLA29=
XX adapters is blocked by a missing whitelist check in qla27xx_get_bbcr_dat=
a().
--

--- Patch [16]: [PATCH v6 16/56] scsi: qla2xxx: Enable get_adapter_id mailb=
ox for 29xx ---
commit 9877d8e47534a68c96e077863320b75953d374f1
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
   =20
Add IS_QLA29XX() alongside the existing 27xx/28xx checks in
qla2x00_get_adapter_id() so that the additional mailbox
registers (buffer-to-buffer credit, SCM/EDC status) are read
on 29xx adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 52d70b61654c7..3fc08120fdf11 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
[ ... ]
> @@ -1827,7 +1827,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16=
_t *id, uint8_t *al_pa,
>  			}
>  		}
> =20
> -		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
> +		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))=
 {
>  			vha->bbcr =3D mcp->mb[15];

[Severity: Medium]
Will userspace be able to access the BBCR data read here for 29xx adapters?

Looking at qla27xx_get_bbcr_data() in drivers/scsi/qla2xxx/qla_bsg.c, the
BSG ioctl handler explicitly rejects adapters that are not 27xx or 28xx:

	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
		return -EPERM;

Should IS_QLA29XX(ha) be added to this check as well, so that the newly
read BBCR data isn't blocked from being retrieved by userspace querying
QL_VND_GET_BBCR_DATA?

>  			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {
>  				ql_log(ql_log_info, vha, 0x11a4,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D16
