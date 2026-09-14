Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ECC39A803
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375131; cv=none; b=c/IRSv0q5HLqiPQqWb2mui7HmKzK1xOYnX6VqhOU/rHjTzQk6iM04H0bjk45Zlql7RlCd1rIceteCvGf8x8b2FPKH/F96vgRAigPOm4RkFpkkjSjbg/DupQHMJpvxMTdwIkfROu4305iFdt+ffmmu1fO7GNTDjqH4hpU+mSGMk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375131; c=relaxed/simple;
	bh=X8/s6aSmrogL3Vlf90YuTtTdLS9XMrzzdluA6ZKQqBo=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=Q+Ho4OGnbQr+L+jE10hfN97tqNwJRgQBlN88QNubz4+eCeqb43K4SgmtTADSQ16b7hIe0rLqJYSLbAuMGigWmvHYxlVVRVB0StNqrkxfg4PXvzu7BEFvy+I/IJTd1qn3wXmzMxKh2Dv3JaRUOAhbwuPR16N+HEl3/JaogiLrQJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NnVzRTZT; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NnVzRTZT"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260914083840epoutp011f71ffad26232dc501535dfd697de645~VIzEOkP933159631596epoutp01G
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 08:38:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260914083840epoutp011f71ffad26232dc501535dfd697de645~VIzEOkP933159631596epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789375120;
	bh=JtytV7zHdS16M6Nuepa/yJ0RtTM6dYTLMDxDFnaoKvw=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=NnVzRTZTDoiZ8Zp8oJCcz80ADihSAt+XibFhrVTB9eSvs9vi3V+iZTO3oTVRV/80Z
	 znICWJL7FaCVhBid9/I8TKGsbPQnCA2cmQrd59R29oRFa43KJy5Z58voDpUtK/mEhk
	 2qTqay6Jq1xoia0n36qjU4MdQBwd5xNQ2MS18ack=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260914083839epcas2p2af9767b3705492f29ed0e909f9619831~VIzDpyjIf1228112281epcas2p2Q;
	Mon, 14 Sep 2026 08:38:39 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.211]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4hjz7z2bTWz6B9mG; Mon, 14 Sep
	2026 08:38:39 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH 0/2] scsi: ufs: batch device-init reads with UFS 5.0
 aggregated read
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260914083838epcms2p1336cbd08ce6ed192eeed9adbad365a93@epcms2p1>
Date: Mon, 14 Sep 2026 17:38:38 +0900
X-CMS-MailID: 20260914083838epcms2p1336cbd08ce6ed192eeed9adbad365a93
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260914083838epcms2p1336cbd08ce6ed192eeed9adbad365a93
References: <CGME20260914083838epcms2p1336cbd08ce6ed192eeed9adbad365a93@epcms2p1>

UFS 5.0 adds the AGGREGATED READ query (opcode 0x9): one QUERY RESPONSE
UPIU returns many descriptors, attributes and flags as a chain of typed
groups.

Patch 1 adds the opcode, the request mask, the group header and the reply
plumbing. Patch 2 uses it during device init: a single aggregated read
replaces the per-item queries for the attributes, flags and ID strings,
falling back to individual queries on older devices or a rejected opcode.

No functional change for pre-5.0 devices.

Hyeoncheol Jeong (2):
  scsi: ufs: Add the aggregated read query opcode and its reply format
  scsi: ufs: Serve the device init reads from one aggregated read

 drivers/ufs/core/ufshcd.c | 365 +++++++++++++++++++++++++++++++++++---
 include/ufs/ufs.h         |  46 +++++
 include/ufs/ufshcd.h      |  11 ++
 3 files changed, 402 insertions(+), 20 deletions(-)

-- 
2.25.1

