Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B85B4AA033;
	Mon, 19 Oct 2026 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792406804; cv=none; b=A4JTygeK3lllGMwdEqIRD3Nudmr1jupXma03lwI5YPOyFrp0YDkDf+O3eaKlbGzjRt25itXSE40uMv6o8bC/SpPywKaF68g3htfnM9Ik3DxHAFEVTdavg4ZkY5c5amgkSdOawxLQX+TdfI2LuLXbIXmwM6vWYintthtqMpvnGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792406804; c=relaxed/simple;
	bh=v9hN0A8v08b17DVuo8+TNcKTWdv0a+uo2yFMOkDVRCI=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KKxhlJMFRpE2yOI/zu8P7Ti1qfywQ9vCoDeESiVpgeI9290eNn+gZfjs66B+nQ2SeV8ToA2D+VmqwLq5q13Q5h7/XcBRYUPXqCOj1df0nlgaUpRHO0ohVRgTsAG7BNhTk1hCP7iwnPx9HD7bW4DhPYwCPZl/ntRqQgUzQg5f3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KuZKpwqJ; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KuZKpwqJ"
X-UUID: 54c71a74cbaa11f1b1788b6acf885367-20261019
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=v9hN0A8v08b17DVuo8+TNcKTWdv0a+uo2yFMOkDVRCI=;
	b=KuZKpwqJg5W0SLJWF1CLePl2X4wlmdvL5ijOskpIU6mpqAueKCj+xyjduEJ9ukaxyVyvzYrLqQQlKjNYjyJjsrAKjzUmjV3Wg/ogUr7JjpsmCd8yxvVmsoLBBKCZPJU4qDZi+2a7Xl4LnA6yZIqWAmB8LLmpJ1CvXJc2dEUAXg4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:d89370bd-90c8-41cc-989b-d24dbc365bce,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:ef32d7de-9ead-4216-888d-582ad3e48a93,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 54c71a74cbaa11f1b1788b6acf885367-20261019
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 144132532; Mon, 19 Oct 2026 18:46:25 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 19 Oct 2026 18:46:23 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 19 Oct 2026 18:46:23 +0800
Message-ID: <6d48b76c0df0db18e43ae637ab1fd79b48dc643d.camel@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix a deadlock between clock scaling
 and device commands
From: Peter Wang <peter.wang@mediatek.com>
To: Joonhoe Kim <26rote@gmail.com>, <James.Bottomley@HansenPartnership.com>,
	<mkp@kernel.org>
CC: <alim.akhtar@samsung.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
	<stanleyjhu@google.com>, <can.guo@oss.qualcomm.com>, <mani@kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Mon, 19 Oct 2026 18:46:23 +0800
In-Reply-To: <20261016124608.46-1-26rote@gmail.com>
References: <20261016124608.46-1-26rote@gmail.com>
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

On Fri, 2026-10-16 at 21:46 +0900, Joonhoe Kim wrote
> Since commit 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()"), device management commands go through
> blk_execute_rq() on the pseudo SCSI device, which shares the tagset
> with the logical units, while ufshcd_dev_man_lock() holds
> clk_scaling_lock for reading.
>=20
> ufshcd_clock_scaling_prepare() and ufshcd_pause_command_processing()
> quiesce the tagset before taking clk_scaling_lock for writing. A
> device
> management command holding the lock for reading at that point is
> never
> dispatched and never times out, so the writer waits forever with all
> logical units quiesced. On a Lenovo Legion Tab Y700 Gen 5 this ended
> in
> a hung task panic.
>=20
> Take clk_scaling_lock before quiescing the tagset, and in
> ufshcd_clock_scaling_prepare() also wb_mutex, which is always taken
> before clk_scaling_lock. Release them in the reverse order. Commit
> b52d695d0620 ("scsi: ufs: core: Keep internal commands dispatchable
> during error handling") fixed the same problem in the error handler.
>=20
> Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()")
> Fixes: dc5dcac53278 ("scsi: ufs: core: Add helpers to pause and
> resume command processing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joonhoe Kim <26rote@gmail.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

