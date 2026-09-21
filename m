Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081C49AA4B;
	Mon, 21 Sep 2026 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995769; cv=none; b=lItEPrY7+hxcrrLTOnZrtPvVdvvheXnbQeB9UkB5GwT1WFhh/9nZb8xee8riDyKU9DzkMYBzeBBz4cBWkb4UsbFvy+4zEeTj5y6RA7Wl9X8aU65kbTMWTPKPtXicXVuqMKGVWmVy5dm+nvs2ul3yNZshmerDvRngDNvIuzClAyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995769; c=relaxed/simple;
	bh=a9lrDJGugDn/XEbngsUxQjCalL4q6BemMqvBoYxwI24=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XEJJGNxqVmNsEH+qiZnHKSUKQ3SLFbE7ssn7U1Xd6wvAx3+LeHbHMaJpbgXu2loEPyzvXZxWKIw4ZeuQbaZDzQljJiZYIoyFOv01vMKzHtkklFmbf42XheSolu8NdJi7uUHX8hOficskcib0jVYhso6ZDPv7TI0qiat2m3x2OKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oHo5rWTg; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oHo5rWTg"
X-UUID: b9e74dc4b5bc11f18dc8c9802ae25ab1-20260921
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=a9lrDJGugDn/XEbngsUxQjCalL4q6BemMqvBoYxwI24=;
	b=oHo5rWTgO0D8TcgUG6tMwgqBajHLA6bnp3H79Uup4526JwG7RbSJXOT5ii/P+Yv1KLa4sdJOwd+1oFpnXlFALM7LbmVz+iUVv/gY1r+VOInQ7v/D96VAJdL6W3ioT+XDcRGPkMqDRXlzvm8u0es6u6tawBwqzdvjyIAHxV85pVQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e35891af-f5fa-4f05-bf0c-89f0b962fae1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:ce651de3-72a5-4ba1-af40-18bbd6ea8ffd,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b9e74dc4b5bc11f18dc8c9802ae25ab1-20260921
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 616814811; Mon, 21 Sep 2026 21:02:40 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 21 Sep 2026 21:02:39 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 21 Sep 2026 21:02:39 +0800
Message-ID: <0a8e36f57f169b9ff75ed7a3d547a36340b98e32.camel@mediatek.com>
Subject: Re: [PATCH v2] scsi: ufs: mediatek: handle mPHY power-on failures
From: Peter Wang <peter.wang@mediatek.com>
To: Pengpeng Hou <hppiscas@163.com>
CC: <chaotian.jing@mediatek.com>, <chu.stanley@gmail.com>,
	<james.bottomley@hansenpartnership.com>, <mkp@kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
	<matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<linux-arm-kernel@lists.infradead.org>, <stanleyjhu@google.com>
Date: Mon, 21 Sep 2026 21:02:38 +0800
In-Reply-To: <20260920034953.19535-1-hppiscas@163.com>
References: <20260920034953.19535-1-hppiscas@163.com>
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

On Sun, 2026-09-20 at 11:49 +0800, Pengpeng Hou wrote:
> The MediaTek helper enables VA09 before powering on the mPHY, but
> ignores the PHY result. A failure can leave VA09 enabled and publish
> mphy_powered_on as true, so a later power-on attempt is skipped.
>=20
> Check phy_power_on(), attempt to unwind VA09 on failure, and leave
> the
> state flag unchanged. Propagate the helper result from host
> initialization as well as its existing resume caller. Keep the
> original
> PHY error if the supply rollback also fails, and report that rollback
> separately.
>=20
> The issue was found by our static-analysis tool.
>=20
> Fixes: 561e3a8726b2 ("scsi: ufs-mediatek: Fix unbalanced clock
> on/off")
> Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator
> operations")
> Assisted-by: gpt 5
> Signed-off-by: Pengpeng Hou <hppiscas@163.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
