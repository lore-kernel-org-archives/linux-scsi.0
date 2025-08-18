Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C718A263F49
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 04:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755492308; cv=none; b=Ie7LdTXe/b1c9xitVBqD44f/LbIZUTh3IRvzVT7z+MOlPb6oXBud3BwirroeQz90fLseFxZtH4+ICD3D0sFnvxAidK+q9/KRdTdqypEWvLIZfJgclYvPtbctnYZ+7uW1iQAMES34vqFMK2sWyekQ16Mq06F5AHAGPH4AHf7OsnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755492308; c=relaxed/simple;
	bh=DRCAhp3rYLP0JzJGeCCRdhoZ4VHZzQUTtR9AnEAnOJ4=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=D3v+lZbHhVPmCVgL8keECbZoZiMNdVAq3LsLWeHIc0fXJfzW0syXULSY9tvTRYRMhJsGuot3NrAR8Y5r1Kr+BKd65eKpmIfFj5M/qGthmzfWYrpfNyLqiAbqhOU+109egwNFt0fxEF5RuAweZb9Le4Rz/clQ5VmzhUMGuXf2iW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=t0UpTZsp; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t0UpTZsp"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250818044503epoutp0285f67313ce42b5908de80d53cb213474~cwvL3cWi52404024040epoutp02V
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 04:45:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250818044503epoutp0285f67313ce42b5908de80d53cb213474~cwvL3cWi52404024040epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755492303;
	bh=DRCAhp3rYLP0JzJGeCCRdhoZ4VHZzQUTtR9AnEAnOJ4=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=t0UpTZspREa4QIu8nBSgswBZ9myLr6ngC5wlAKJO9AgsyLhX1j2p+sAcq1gvM3w7L
	 EmKDtjSo271ejcoVFCjj48c8bEUmicHQNYaG3HYhBfA9n6Ac2J5iAKZQstJyxYCvcU
	 p36f9dWxRsTbwoeN9FQBZJXHa4GNdLHZ4v0z38W0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20250818044502epcas2p1583cb94e933d0253acf1d26b0298ac34~cwvLKW6iT1332913329epcas2p1r;
	Mon, 18 Aug 2025 04:45:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4c50WL5QTGz6B9m6; Mon, 18 Aug
	2025 04:45:02 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH] ufs: core: Only collect timestamps if the monitoring
 functionality is enabled
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Can Guo
	<cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter <adrian.hunter@intel.com>,
	Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20250815160049.473550-1-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01755492302739.JavaMail.epsvc@epcpadp1new>
Date: Mon, 18 Aug 2025 11:36:32 +0900
X-CMS-MailID: 20250818023632epcms2p80b5dce104f1d1caa1b2f9c68f347c00a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250815160114epcas2p43832aa1b9ad0b0efb98ec59f5b568c96
References: <20250815160049.473550-1-bvanassche@acm.org>
	<CGME20250815160114epcas2p43832aa1b9ad0b0efb98ec59f5b568c96@epcms2p8>

Hi Bart,

> Every ktime_get() call in the hot path has a measurable impact on IOPS. H=
ence,
> only collect timestamps if the monitoring functionality is enabled.
>=20
> See also commit 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance
> monitor sysfs nodes"; v5.14).
>=20
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Daejun Park <daejun7.park@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/ufs/core/ufshcd.c 16 ++++++++++------
> 1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 714d9966431e..027dc0355ae6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2357,10 +2357,12 @@ void ufshcd_send_command(struct ufs_hba *hba, uns=
igned int task_tag,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ufshcd_lrb *lrbp =3D &hba->lrb[t=
ask_tag];
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0lrbp->issue_time_stamp =3D ktime_get();
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0lrbp->issue_time_stamp_local_clock =3D local=
_clock();
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0lrbp->compl_time_stamp =3D ktime_set(0, 0);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0lrbp->compl_time_stamp_local_clock =3D 0;

How about modifying ufshcd_compl_one_cqe() to skip updating compl_time_stam=
p?

Thanks,

Daejun
