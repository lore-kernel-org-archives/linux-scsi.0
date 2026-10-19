Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC890415B6A;
	Mon, 19 Oct 2026 10:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792406867; cv=none; b=M0ruv1ww9S9Ta441eB5AvupTdds3DH5NV++TVVTSLKCctxz8ZeqT6CIESNCwlREJtgagcpoKuauv8uXqfz2j032jlYDx/Gy+ibxrFzASjqjE/4mbj8dVZ4uO/TCxT4rE/p48dhY8CAoiJp2d5wg7C0pTSeEOxX8oLMGxMIRTbdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792406867; c=relaxed/simple;
	bh=gf1ptB8tveW2jkk+8XlGwprCN3LnmBizJ2++NERBZGU=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pviVFaYZH3ZMDhfq5mC7sbQgy5NG3Pt5iYQI96sAl/mAmUl80EcG6L9Rqnc7d3l5ezqUNLItg0JIlACAuI+3nuxxudpYjmVXYiHI+mLxgoalixXuHp1gNH/RlKI1iwOyVEiHRL9MjSVJJ5eHbKfDpY2QG+Mz4tt5BU/dG5BG4Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=r6nTo0pZ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="r6nTo0pZ"
X-UUID: 77723ee6cbaa11f18dc8c9802ae25ab1-20261019
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=gf1ptB8tveW2jkk+8XlGwprCN3LnmBizJ2++NERBZGU=;
	b=r6nTo0pZExVI41HpVV3+EyJY0S3HP5B+7rJkuPF7/el+M/UW/KwdEK2pdgMJnzHbFDfA78U23mGPmwuYaQIt/euMTN2qcBzQ67BFmHwMD3fTjDwC8rHrag/qgzUjqAZ6aIKIl5i/etmFW6A0HzlTfcWENr2pCkhEskykqmk1CoI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:e06a19b7-fc10-485e-b159-8a2e7514e52b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:d634d7de-9ead-4216-888d-582ad3e48a93,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 77723ee6cbaa11f18dc8c9802ae25ab1-20261019
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 622037216; Mon, 19 Oct 2026 18:47:23 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 19 Oct 2026 18:47:22 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 19 Oct 2026 18:47:22 +0800
Message-ID: <6e1a9434c3242d03dffc917596bdc67c0545d6ac.camel@mediatek.com>
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Bart
 Van Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Bean
 Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Mon, 19 Oct 2026 18:47:22 +0800
In-Reply-To: <20261017084403.875420-1-stanleyjhu@google.com>
References: <20261017084403.875420-1-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MTK: N

On Sat, 2026-10-17 at 16:43 +0800, Stanley Jhu wrote:
> In Single Doorbell (SDB) mode, ufshcd_clear_lu_cmds() clears a
> transfer
> request slot in the controller and completes the request without
> claiming its bit in hba->outstanding_reqs. A subsequent ufshcd_poll()
> call sees the stale bit with its doorbell bit cleared and completes
> the
> request a second time, causing a double DMA unmap.
>=20
> Patch 1 adds __ufshcd_clear_outstanding_reqs() and
> ufshcd_clear_outstanding_reqs() to share the bit-claim logic across
> ufshcd_poll() and ufshcd_abort() with no functional change. Patch 2
> uses
> the new helper in ufshcd_clear_lu_cmds() to fix the SDB double
> completion. Patch 3 uses the new helper in ufshcd_eh_timed_out(). It
> is
> a follow-on cleanup and is not needed for the fix. Patch 4 removes a
> WARN_ONCE() whose condition is always false.
>=20
> This series is based on mkp/for-next (db8b4d2bf2d3).
>=20
> Tested on QEMU ARM64 UFS in SDB and MCQ modes across LU reset, polled
> and interrupt I/O, and task abort without double completion or DMA
> unmap warnings.
>=20
> Changes since v1:
> - Add a helper for clearing hba->outstanding_reqs and use it in
> =C2=A0 ufshcd_poll(), ufshcd_abort(), and ufshcd_clear_lu_cmds()
> =C2=A0 (Bart Van Assche).
> - Convert ufshcd_eh_timed_out() to use the new helper in patch 3.
> - Remove an always-false WARN_ONCE() in patch 4.
> - Link to v1:
> https://lore.kernel.org/r/20261016085403.1711740-1-stanleyjhu@google.com
> =C2=A0
>=20
> Stanley Jhu (4):
> =C2=A0 scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
> =C2=A0 scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
> =C2=A0 scsi: ufs: core: Use ufshcd_clear_outstanding_reqs() in
> =C2=A0=C2=A0=C2=A0 ufshcd_eh_timed_out()
> =C2=A0 scsi: ufs: core: Remove an always-false WARN_ONCE()
>=20
> =C2=A0drivers/ufs/core/ufshcd.c | 55 +++++++++++++++++++++++++-----------=
-
> --
> =C2=A01 file changed, 35 insertions(+), 20 deletions(-)
>=20
>=20
> base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de

For the series:
Reviewed-by: Peter Wang <peter.wang@mediatek.com>


