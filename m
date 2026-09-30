Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492163B4EAC
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 05:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790747108; cv=none; b=cfcslT1Bcasql/6GSH2eK4jrBk2qTMMqj5WxmX0xR98rjgh/97C0Zf5xDDW5JcLutKwTyU5479xxEVt8Bdm5LglR8bXzFXur7mmIfTFn7mvn1sM5bUWfp6q3RUP6ctKj1U42BME39IKwVa+5Tu/DF4/DJmbUkCLoK50OeeJHblc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790747108; c=relaxed/simple;
	bh=bDfwVhCGhtV1v5j74Ct11DYRMo2xgvgHkiLDWkr6sr8=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=JotjZFd5pdK66vju3zw1+8NIAdNKPS85bwruuryW2H4yG/JBHW4CTcYWIOuiv8QVwkXG8XjFU6inOEloVja5VjJGt32lUh9o96OpEkjg1ndcd6pN9Wml9x06n4XtG07Nz1k5bYG+yPWjZAd1sG3YStDSnTMqWU6xkygyTqT+m6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HIO5h5Y/; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HIO5h5Y/"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260930054502epoutp023ae4b0f7e4237adff85279f7c8b23207~aAwCaffeP0106801068epoutp02R
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 05:45:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260930054502epoutp023ae4b0f7e4237adff85279f7c8b23207~aAwCaffeP0106801068epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790747103;
	bh=3jzsdyLtHQ5MZolOYlY3x6jVlWVSyruCr4hTcRaZm8g=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=HIO5h5Y/ov1GZtgSXsanbmgbt1R3EeNwk3qne8OaroY0/GAh76rAXjeXb0DZcHSZW
	 Q/rvce92rP2c/1Wp1zn8vo5Uep6GVYhssTHZXEAnQZn+AIDfiMrBguh8rS4I65f8pY
	 hFW0Kh6iTSLFNrPSBZFVbH9spwwAZ3PPwMXvQ9KY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260930054502epcas2p2bfdf130bae7923a6be66a6392f6f3bee~aAwB7mA2Q0152701527epcas2p22;
	Wed, 30 Sep 2026 05:45:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hvkXG2rzvz6B9mN; Wed, 30 Sep
	2026 05:45:02 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v2 0/2] scsi: ufs: batch device-init reads with UFS 5.0
 aggregated read
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>, Hyeoncheol Jeong
	<hyenc.jeong@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1860250540.01790747102385.JavaMail.epsvc@epcpadp1new>
Date: Wed, 30 Sep 2026 14:02:01 +0900
X-CMS-MailID: 20260930050201epcms2p13ab67182445b0555acc8d27b927cda86
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260930050201epcms2p13ab67182445b0555acc8d27b927cda86
References: <CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>

UFS 5.0 adds the AGGREGATED READ query (opcode 0x9): one QUERY RESPONSE
UPIU returns many descriptors, attributes and flags as a chain of typed
groups.

Patch 1 adds the opcode, the request mask, the group header and the reply
plumbing. Patch 2 uses it during device init: a single aggregated read
replaces the per-item queries for the attributes, flags and ID strings,
falling back to individual queries on older devices or a rejected opcode.

No functional change for pre-5.0 devices.

Motivation: on a Qualcomm SM8850 platform with a Samsung UFS 5.0 device,
timing raw UPIU queries over BSG (100 iterations) shows that replacing the
device-init read burst with a single aggregated read reduces the query
time by 75-78% (min 75.3%, avg 76.4%, max 78.5%).

(That setup batched 8 init reads; on current mainline this series batches
the 6 device-init reads that remain individual queries.)

Changes since v1:
- Rename UFS_AGG_TYPE_UNIT_DESC to UFS_AGG_TYPE_UNIT_RPMB_DESC (Peter Wang)
- Add UFS_AGG_GROUP_RESERVED = 0x00 (Peter Wang)
- Rename hdr_off/next_off to group_off/next_group_off (Peter Wang)
- Rebased onto v7.3-rc5

Hyeoncheol Jeong (2):
  scsi: ufs: Add the aggregated read query opcode and its reply format
  scsi: ufs: Serve the device init reads from one aggregated read

 drivers/ufs/core/ufshcd.c | 364 +++++++++++++++++++++++++++++++++++---
 include/ufs/ufs.h         |  47 +++++
 include/ufs/ufshcd.h      |  11 ++
 3 files changed, 402 insertions(+), 20 deletions(-)

--
2.25.1

