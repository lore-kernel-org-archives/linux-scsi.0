Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902951A9F87
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784862499; cv=none; b=iU8z2LOW81JvftjNwiqHdPJBYs/QRv60Wwmgwi+zINNgfWDQq2aHz+NMyFve2BbmMtBEAOipZtL/YJrFgyOQvW2aj+4lofMTJRi9tCdBjXkzG+tU2rzy+UafYreKuzSZEDdwq+7WToGK9v36DmNAkEr9uIvvMYsIVxijt86pQTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784862499; c=relaxed/simple;
	bh=Xm5p8uG5+9JjTiZkEQxC1X91synNajmwGnQS4RPWbug=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=an7z1v2gGRzX6LnUr/g8uyyhGpktFXq89izE7+fA6M/VHRjCp5JmIpiiib0sB554yAFRA7MVr2aOe2LsOPu5Vdj2cp1dm0BIqD3PTy/PnCojk9MTiRyarz8CuhoaPLf7UB7EAHDoJID4/K0ziETJNWZpZDMW7oITCov+qOhYw9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IsB5h6G/; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IsB5h6G/"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260724030814epoutp03b4b20e89ac3625d2036806e5a4e64e35~FGvtXOQkC2917729177epoutp03x
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:08:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260724030814epoutp03b4b20e89ac3625d2036806e5a4e64e35~FGvtXOQkC2917729177epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784862494;
	bh=DN+coMvw1TzVjuKBS2Wa/+SeTmtJpG9VdhZkGP+2R+0=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=IsB5h6G/3FrcZgUf3a3O2EtuExT6md64HYzN6+MlkO59wKVj66FbdBAvMYkCRu9mb
	 oK3s0JPJ50UrwEn6hr4QTkNDrv30hR6mRctQ59Xd1xslR5sHsMKY/gIf67/B5zd58S
	 IPsllzgAkzytL5X2NDdUSOPYTZ+mI/5nBrbaspBY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20260724030813epcas2p4bf32d70b94f08eb60741abf186b30b39~FGvs6OpG40840508405epcas2p4K;
	Fri, 24 Jul 2026 03:08:13 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.210]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h5tGj36Ppz6B9m6; Fri, 24 Jul
	2026 03:08:13 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v3 0/2] scsi: ufs: Add support for the aggregated read query
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
Message-ID: <20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
Date: Fri, 24 Jul 2026 12:08:12 +0900
X-CMS-MailID: 20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa
References: <CGME20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>

UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode (0x9),
which retrieves an aggregated data packet bundling multiple Descriptors,
Attributes and Flags in a single QUERY RESPONSE UPIU. Such a packet can be
far larger than a single descriptor, so the reserved (device management)
tag gets a dedicated UCD with an enlarged response area.

Patch 1 is a preparatory cleanup that switches the BSG query descriptor
length to unsigned types. Patch 2 adds the aggregated read support.

Changes since v2 (Bart Van Assche):
- Split into a series; new patch 1 switches the BSG query length to
  unsigned types and uses min() instead of min_t(int, ...).
- Folded ufs_bsg_get_query_desc_size() into its only caller.
- Shrank the devman UCD PRDT from SG_ALL to two entries.
- Added WARN_ON_ONCE(slot < 0) in ufshcd_init_lrb().
- Made struct ufs_dev_cmd.tag unsigned (u8).
- Reworded the "multiple of 128" BUILD_BUG_ON comment.
Also capped QUERY_AGGREGATED_MAX_SIZE (4096 -> 4064) plus a static_assert
so the UPIU header and data segment fit the response area, fixing the OOB
read flagged by Sashiko AI.

v2: https://lore.kernel.org/linux-scsi/20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4/

Hyeoncheol Jeong (2):
  scsi: ufs: Use unsigned types for the BSG query descriptor length
  scsi: ufs: Add support for the aggregated read query opcode

 drivers/ufs/core/ufs-mcq.c | 14 ++++--
 drivers/ufs/core/ufs_bsg.c | 38 +++++++--------
 drivers/ufs/core/ufshcd.c  | 98 ++++++++++++++++++++++++++++----------
 include/ufs/ufs.h          |  8 ++++
 include/ufs/ufshcd.h       | 20 ++++++++
 include/ufs/ufshci.h       | 18 +++++++
 6 files changed, 148 insertions(+), 48 deletions(-)

-- 
2.25.1
