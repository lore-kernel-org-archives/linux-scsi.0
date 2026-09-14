Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7C247A86E;
	Mon, 14 Sep 2026 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390333; cv=none; b=osma6A8j3Yy+ycmrsH4+xkJTn7Zz+mUNXo/fybpL8X3oWh8HrSOj3bXMa3OXiIZx9kxGVM8NH/PnU71c8wcF7LQsOPnlEf3HOSZ6PnkAxLTP/EAPSuiKYISa23ZZxfzowWZynh8ZjPyWP7jS88hXxIacI8cCAbcdicCpiHZEtTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390333; c=relaxed/simple;
	bh=Izg97bwUBivqLruWcsA+f3iP3W5ySd3OjfAxN+/WEDQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a5bURXN+pJlYjIP5S6xjkDBypzgvAyZnymKP3UUDl91EPjs+38J/JsXBp8p6fpaSZz3+0pMNbwG7kCZP/dsIMYmcB9atrw7+h6HwAO8LEPw9VIhgGP8tWJ72XZJ4hCoRbAujoKlBQhmKXuJKsjk4m8tFaaonItL8g6fhUJpfvTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLQ+ZkRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLQ+ZkRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917E81F000FF;
	Mon, 14 Sep 2026 12:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390331;
	bh=6HFKDlCakjHm8v3rWQyTg1AphVxGEW3ItLsq5ZzzrGo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BLQ+ZkRwJDar2F2Ldm1ri34iGMBsH5cr6Bh2SY8SGw07OnTMDuSxIckkBD2t9/A5y
	 KspiUTsIxecBQY8OlT2Qnk+CvPNA0OxLvnR9lNu35QM4foI/i1frHyUAXttD3no+Nh
	 jOLVTImXzjxfx8na4gnabjgm/Kv91hOrOmH3OSdKGglW/JKAvfJ+NxgwD/9pYDwVqK
	 NlIH3doDIIgjIrzlkm7TPcA0Xw+48NKoZZ9Eke7xaQXnkNwwWs17BlEpNDgWy60V+N
	 DP3S2O4mRWPyXOtasszxOzT4J5iIZjjIF/qjEtrQERFn3Sdio0RkydpkfrDfQhB/YA
	 nLmfXUIPatprQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 15/24] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: robh@kernel.org, olteanv@gmail.com, linux-phy@lists.infradead.org, vkoul@kernel.org, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, conor+dt@kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260914-mt8196-ufs-v12-15-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-15-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:52:10 +0000
Message-Id: <20260914125210.917E81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch removes the only setter of the UFSHCD_QUIRK_MCQ_BROKEN_RT=
C quirk, leaving dead code in the UFS core.
--

commit 82a04ad4bc4aa7f179dd5c4350001c1dceff6a56
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove mediatek,ufs-broken-rtc property

This commit removes the undocumented mediatek,ufs-broken-rtc property and
its capability wrapper. If the quirk is needed for specific MediaTek SoCs, =
it
is expected to be handled per-compatible instead.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 538009e3b1f17..8e2aeb877de83 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -1234,8 +1231,6 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>  	hba->quirks |=3D UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
> =20
>  	hba->quirks |=3D UFSHCD_QUIRK_MCQ_BROKEN_INTR;
> -	if (host->caps & UFS_MTK_CAP_MCQ_BROKEN_RTC)
> -		hba->quirks |=3D UFSHCD_QUIRK_MCQ_BROKEN_RTC;

[Severity: Low]
Does this removal leave UFSHCD_QUIRK_MCQ_BROKEN_RTC as dead code in the UFS
core?

Since no other host driver appears to set this quirk, the checks in
drivers/ufs/core/ufs-mcq.c (such as in ufshcd_mcq_sq_stop) and its definiti=
on
in include/ufs/ufshcd.h might now be unreachable:

drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_sq_stop() {
    ...
	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
		return -ETIMEDOUT;
    ...
}

Should the UFSHCD_QUIRK_MCQ_BROKEN_RTC definition and its related checks al=
so
be cleaned up from the core?

> =20
>  	hba->vps->wb_flush_threshold =3D UFS_WB_BUF_REMAIN_PERCENT(80);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D15
