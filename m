Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6FC49DB8E;
	Mon, 21 Sep 2026 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996876; cv=none; b=h78h+1HymqQPazfidaPV6HaImNlJzGLtED+HxSe6mBnt5hLiEtyC/fTd7NXTOOYCyChhV7MkWH7RqeP+0WCXJGW/aZRzfFB+6ezms3wSYI4jtfrucNfLQZo1Kg9EyLkq2931SWq03AcuuGZsBqA3ppqxlg+f1rcSu5ZyUwBo0JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996876; c=relaxed/simple;
	bh=DMmrU7374bXu7rpn27MZ+FOc1NoZqY19Bvh/QjgStqo=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aZbtJhITeBsH8utQkHFQDuk7YeCMEoUpzhV2jSqq9+76f7iL7SShUplpIxobZl69qBY7X1anlmAP3zSlKho40CZiQtw/k16trpiYH3c3Q8e7qs21dhEaZIrID6V4YtqcpZ8v17Ho+ZDoGbBdnTKwl/8G4YwPX12SJy8A35u/uis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DV1UxTr0; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DV1UxTr0"
X-UUID: 4a7dc5fab5bf11f1b1788b6acf885367-20260921
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=DMmrU7374bXu7rpn27MZ+FOc1NoZqY19Bvh/QjgStqo=;
	b=DV1UxTr03H8GCBIx3mQ+Vw3MVf1aGm4xa8AcR977qfxTfiORCJIvDDSMOkBNzgb9LyYt1R9rZmCkUrKyn1pfc5Zn1aMd6O9wWH9BBSBSkNyLm1HJelv5qmKZOmUHJFNaDJSanFctwTQek1wbaSD8VHaJx7fJlKkJD9cFLVxu76Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:0cbcca74-5cdf-4efb-ae70-ddfb28c89eef,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:0afd9728-9ebf-4787-bb42-3cd26eee85aa,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4a7dc5fab5bf11f1b1788b6acf885367-20260921
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1480194666; Mon, 21 Sep 2026 21:21:01 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 21 Sep 2026 21:21:00 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 21 Sep 2026 21:21:00 +0800
Message-ID: <21231fed9487b88316da067d9a7f6fbb812e7f98.camel@mediatek.com>
Subject: Re: [PATCH v1] scsi: ufs: core: Hold a clock reference across the
 probe
From: Peter Wang <peter.wang@mediatek.com>
To: Naomi Chu <naomi.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<mkp@kernel.org>, <avri.altman@sandisk.com>, <alim.akhtar@samsung.com>,
	<James.Bottomley@HansenPartnership.com>, <bvanassche@acm.org>
CC: <wsd_upstream@mediatek.com>, <alice.chao@mediatek.com>,
	<chun-hung.wu@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <ed.tsai@mediatek.com>
Date: Mon, 21 Sep 2026 21:21:00 +0800
In-Reply-To: <20260909091045.1134956-1-naomi.chu@mediatek.com>
References: <20260909091045.1134956-1-naomi.chu@mediatek.com>
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

On Wed, 2026-09-09 at 17:10 +0800, Naomi Chu wrote:
> Clock gating becomes possible as soon as ufshcd_init_clk_gating() has
> run, and from that point on the probe keeps accessing host registers
> without ever taking a clock reference. This has been safe only
> because
> of the state check in __ufshcd_release(): gate_work is not queued
> unless hba->ufshcd_state is UFSHCD_STATE_OPERATIONAL, and the
> promotion
> to that state used to happen after the last register access of the
> probe, at the end of ufshcd_probe_hba().
>=20
> That is fragile: it only works while the promotion happens after the
> register accesses. Commit a390e6677f41 ("scsi: ufs: core: Expand the
> ufshcd_device_init(hba, true) call") changed that ordering by moving
> the promotion into ufshcd_init(), which schedules ufshcd_async_scan()
> afterwards. ufshcd_probe_hba() therefore now runs with the state
> already promoted, and it accesses host registers without holding a
> clock reference:
>=20
> =C2=A0- on hosts with UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH it calls
> =C2=A0=C2=A0 ufshcd_hba_stop() and ufshcd_hba_enable() before
> =C2=A0=C2=A0 ufshcd_device_init() sets the state back to UFSHCD_STATE_RES=
ET,
> and
> =C2=A0=C2=A0 both read REG_CONTROLLER_ENABLE, so gated clocks stall there
> instead
> =C2=A0=C2=A0 of just losing a write.
> =C2=A0- it ends with an ufshcd_configure_auto_hibern8() write, which its
> =C2=A0=C2=A0 other callers do take a clock reference for.
>=20
> Take a clock reference as soon as clock gating has been initialised
> and
> keep it until the probe is over. It then does not matter who drops a
> clock reference while the probe is running, and the register accesses
> of the probe no longer depend on hba->ufshcd_state. The reference is
> dropped by ufshcd_async_scan() once the scan has finished, or by the
> new out_release label if the probe fails after it was taken.
>=20
> Fixes: a390e6677f41 ("scsi: ufs: core: Expand the
> ufshcd_device_init(hba, true) call")
> Signed-off-by: Naomi Chu <naomi.chu@mediatek.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
