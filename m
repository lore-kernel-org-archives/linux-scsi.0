Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8E14F7CB2
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 10:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071623; cv=none; b=q5xD6xHnBp+cMZ83f6kZgyVlE9IR2XjnR5EAUUIStpnEHQbyz5vqio47/URwDs77wiqmTLibZAhv4lTnMj1rz72p7W8E5dN3+Zs78NSnkcf+45/guS9IIra7BCypy3OwMYclzHplO0itXWu51H9VzhJx6pQfyXLFrI940vCGNzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071623; c=relaxed/simple;
	bh=85S4rWiem6CyLieZW1eyWV3CVYhRqDyl1639/63dg8I=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eOGzhUf9Qq5fA0PGkta3YpMitlk+JdLi3vtr0f8tC1jzKXLqAis05Y/YC/II3dwyKgSmglPVqER5VsYMa56G0cMXLCny4LSU3fdJsvT85rL3up9fo2gShIb9Ozt4nuvhu5kYdYFF85YFnJugXeVb8YKDvHaC+2gK/BUQpRjQJ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=M1e1hN6y; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M1e1hN6y"
X-UUID: 5688663ab66d11f18dc8c9802ae25ab1-20260922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=85S4rWiem6CyLieZW1eyWV3CVYhRqDyl1639/63dg8I=;
	b=M1e1hN6yDjag6hNjIl/iINHhx96n3PIXaLJOEVu+7Xk+E1bQC7mK0XgpwZzZvsostzlAF1i3AWaYq/8vf5/PSh8bM6Q+kC76YrWVJjK4Lwm1pFbOaSkhQVdrhdmnTed6fFXaWtpaPqmKku17HtBFErG6HyQ4xCEl+r096nhq7g0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f3281e91-02d2-4924-a511-59befa8e15e3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:c921737b-7b77-4551-8947-5a8501e21a8c,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5688663ab66d11f18dc8c9802ae25ab1-20260922
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 996763831; Tue, 22 Sep 2026 18:06:54 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 22 Sep 2026 18:06:53 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 22 Sep 2026 18:06:53 +0800
Message-ID: <0fc34494c4d37c1ab15db32d021d3f96869bab78.camel@mediatek.com>
Subject: Re: [PATCH v2 0/2] ufs: fix POST_CHANGE pairing and AHIT race
 condition
From: chun-hung.wu <chun-hung.wu@mediatek.com>
To: <peter.wang@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <avri.altman@sandisk.com>,
	<alim.akhtar@samsung.com>, <bvanassche@acm.org>, <santosh.sy@samsung.com>,
	<h.vinayak@samsung.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Date: Tue, 22 Sep 2026 18:06:53 +0800
In-Reply-To: <20260914085148.136429-1-peter.wang@mediatek.com>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
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

On Mon, 2026-09-14 at 16:49 +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Patch 1 fixes a bug where POST_CHANGE was skipped on a failed gear
> switch, leaving the host in an inconsistent state if resources
> acquired
> in PRE_CHANGE were never released.
>=20
> Patch 2 fixes a race between the sysfs AHIT update path and the
> MediaTek host driver's power mode change path. A mutex and depth
> counter are introduced to serialize AHIT register access and ensure
> AHIT is correctly restored after the last disabler completes.
>=20
> The two patches are related: patch 1 guarantees POST_CHANGE is always
> called, ensuring the depth counter introduced in patch 2 is always
> properly decremented.
>=20
> Peter Wang (2):
> =C2=A0 ufs: always notify POST_CHANGE even on gear switch failure
> =C2=A0 ufs: serialize AHIT register access between sysfs and host driver
>=20
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 22 =
+++++++++++++++++++---
> =C2=A0drivers/ufs/host/ufs-exynos.c=C2=A0=C2=A0 |=C2=A0 4 +++-
> =C2=A0drivers/ufs/host/ufs-mediatek.c | 16 ++++++++++++----
> =C2=A0drivers/ufs/host/ufshcd-pci.c=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0include/ufs/ufshcd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 8 ++++++++
> =C2=A05 files changed, 44 insertions(+), 9 deletions(-)
>=20

Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
