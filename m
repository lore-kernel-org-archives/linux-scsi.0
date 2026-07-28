Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2925330274D
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 09:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230536; cv=none; b=EDjsiG6WvFaqvVlgXYnLoo9laGj+0V7wlHoO7mTdtVE3B8xXevaKMLhqGojokGRZnTilnX+LcRu7hPok2Apn4sqC2zJaWPqRndPgoJ6HZYFqbBl7l4BGB+GXOtSWiKs6RBCEy5llQCydTpzQatjFS3TDw+RGtZCB4rbSfqe61Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230536; c=relaxed/simple;
	bh=fa7Furz+NUn5YlwvTWuiQnOVN+xr2fVDNw7kLnyROjs=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=aptUz2u7jpMDPaTBgHXD/HqZpQ2/jBsVkQWG+BWjfldn4D5uqaxQxBHxF4FpjpZURUppd1OJjOoPJ2yajcNUpnOZ+LkLfxYj4i05NSvcPaUzXbtniQEgihqz0T/TY6j4IdcxaSyCjM9vux4QdxNcsShPwxlODddQqAjZKi6sc+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EktJyiY/; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EktJyiY/"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260728092210epoutp03651010fa537300409f36945e094a59cf~GabWDIK-K1746817468epoutp03u
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 09:22:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260728092210epoutp03651010fa537300409f36945e094a59cf~GabWDIK-K1746817468epoutp03u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785230530;
	bh=ZQOT7wjfiVtLhX2So/i2X+PX/8yq13CBF/occNKt5ok=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=EktJyiY/ebZ7whKJsqoX+f6V90sDvgpOV7/iiT6KQZehHzEx2sHAymZvjixgJjhCz
	 u/lWtskhPv15DPLyy436kbUBNhMcpDsB+5dn+om/sSA0O1iV/kL7sB6WSEyn6wKARm
	 qui1QilfymU3SPRnIHq96H+GvNSWUyQ6RYmf2CZI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260728092210epcas2p3de7586a0911b4d41fc2edfc1e3fa8b57~GabVodpWU2241222412epcas2p3N;
	Tue, 28 Jul 2026 09:22:10 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.210]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h8VNK640dz6B9m5; Tue, 28 Jul
	2026 09:22:09 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v4 0/2] scsi: ufs: Add support for the aggregated read query
 opcode
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: ALIM AKHTAR <alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Jinyoung Choi <j-young.choi@samsung.com>, Dukhyun Kwon
	<d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>, Keoseong Park
	<keosung.park@samsung.com>, Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon
	Seol <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>, Yunjae
	Jo <yunjae00.jo@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
Date: Tue, 28 Jul 2026 18:22:08 +0900
X-CMS-MailID: 20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0
References: <CGME20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>

UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode (0x9),
which retrieves an aggregated data packet bundling multiple Descriptors,
Attributes and Flags in a single QUERY RESPONSE UPIU. Such a packet can be
far larger than a single descriptor, so the reserved (device management)
tag gets a dedicated UCD with an enlarged response area.

Patch 1 is a preparatory cleanup that switches the BSG query descriptor
length to unsigned types. Patch 2 adds the aggregated read support.

Changes since v3:
- Patch 1: drop the (u16) cast in min() (Bart Van Assche).
- Patch 2: reject Advanced RPMB BSG requests with more than
  UFSHCD_DEVMAN_SG_ENTRIES scatter-gather segments before dma_map_sg()
  (Sashiko AI / Bart Van Assche).

v3: https://lore.kernel.org/linux-scsi/20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4/
v2: https://lore.kernel.org/linux-scsi/20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4/

Hyeoncheol Jeong (2):
  scsi: ufs: Use unsigned types for the BSG query descriptor length
  scsi: ufs: Add support for the aggregated read query opcode

 drivers/ufs/core/ufs-mcq.c | 14 ++++--
 drivers/ufs/core/ufs_bsg.c | 49 +++++++++++--------
 drivers/ufs/core/ufshcd.c  | 98 ++++++++++++++++++++++++++++----------
 include/ufs/ufs.h          |  6 +++
 include/ufs/ufshcd.h       | 20 ++++++++
 include/ufs/ufshci.h       | 12 +++++
 6 files changed, 151 insertions(+), 48 deletions(-)

--
2.25.1
