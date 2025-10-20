Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D1E221FCF
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 06:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760941391; cv=none; b=tSi04wdX7t4cqMVzrH6wxhEUI3DdXPcSYRhWEccA8df1dSzHaZf+mR07HLQE1ueoXgafHYYqNhtENpK8SMhiXzpkqSLkIgf5C2rLoSulanlS44Tea+Dw5DwJNSsSNIlukp98KzmgVkcNTHFpKu7e/wDM32Gs6cW21DC1mjfvWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760941391; c=relaxed/simple;
	bh=lfH0sRIU/s981ytgYVhj3dhSIxdAPXtjSyaHDiUpZBI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=L3ey07a23PnTr3Qlbf/rBBbe9zLRjTG6FkFasC4WYGF0IOuak1hUDgq5rI3dDoSipgMu5y0iLiT17ipL7lmfUXCt09otLP2eiWXeYwpp8SZ6c6ribEfoyNKm6AHZFQAUofFtEZiW/BiBfNUDpjfl4RQywp62sW93fEgnAptl1mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pDB5Y7CD; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pDB5Y7CD"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251020061546epoutp02a1d54cc938b41803ec58f033e0ce4dc0~wHnYB1wed1527615276epoutp02d
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 06:15:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251020061546epoutp02a1d54cc938b41803ec58f033e0ce4dc0~wHnYB1wed1527615276epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760940946;
	bh=HNGkfiR8AMen/9ObMbWaxmxw3vYFihP+Bhu1xHpypOI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=pDB5Y7CD97piY8j5Zkdnn9oU2B6rh2a21nSGKp+Iv+VR5PCaMkY9qcpKSaaq63Lvx
	 tfqixp+jx6acfiX4yVFkx1thW6fHJDSb1ZmUAXnAmK1T51PM9p6tYK+zgzbblqPgjR
	 PkEnOq8TyhixjT34ZP1p8TTeOzbxN4SV1lJW5Hh0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20251020061545epcas1p1ec6e693cc719d848b3d8246f29623880~wHnXju2GZ1382713827epcas1p1s;
	Mon, 20 Oct 2025 06:15:45 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.38.196]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cqlXx6KDXz3hhTB; Mon, 20 Oct
	2025 06:15:45 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251020061545epcas1p2c494b8e57d424f1b2dfdcc9eef6e669e~wHnXCkzrL0546205462epcas1p2x;
	Mon, 20 Oct 2025 06:15:45 +0000 (GMT)
Received: from wkk-400TFA-400SFA.. (unknown [10.253.99.106]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251020061545epsmtip17d69fe1bbdc887f2d98c8fe06bade243~wHnW9l_uI0249502495epsmtip1e;
	Mon, 20 Oct 2025 06:15:45 +0000 (GMT)
From: Wonkon Kim <wkon.kim@samsung.com>
To: bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, peter.wang@mediatek.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wkon.kim@samsung.com
Subject: [PATCH 0/2] ufs: core: Initialize a value of an attribute at
 ufshcd_dme_get_attr()
Date: Mon, 20 Oct 2025 15:15:37 +0900
Message-Id: <20251020061539.28661-1-wkon.kim@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251020061545epcas1p2c494b8e57d424f1b2dfdcc9eef6e669e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251020061545epcas1p2c494b8e57d424f1b2dfdcc9eef6e669e
References: <CGME20251020061545epcas1p2c494b8e57d424f1b2dfdcc9eef6e669e@epcas1p2.samsung.com>

From: wkon-kim <wkon.kim@samsung.com>

It needs to initialize a value of an attribute at ufshcd_dme_get_attr().

Wonkon Kim(2):
  ufs: core: Initialize a value of an attribute as returned by uic cmd
  ufs: core: Declare tx_lanes witout initialization

 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.34.1

