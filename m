Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1452322E402
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741773104; cv=none; b=dUIGe8Nd7b3XPH2ohg02N4lOMoThvskbipPVKfw50dg7v7ZacldgYnePy08+EWvpBVG5JAxUH8h8YVjKONAvp7kxKdVoA+MzBFIv/6ZlbknNaOy0+xjRFTHe/vUMJjhI//yRjPTLg5EWQTstgqooG/SrQCsQwTEF/qzerTgzqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741773104; c=relaxed/simple;
	bh=JBcqw0iw4Wh7Ymu2dc1XvcAMyeCLv6APqDK072qU+DY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h+kfuGDFgUcvoWCIkRFbNxmHhudGg5smXojbkR28zc2ucW67BDD/oxoLKOFW8yf5Z1AXIFo98JEuhW4DaWAZfjjKGy5CTuQdT5tS+xAGAgp4AoUaeJoGS7UhSYKxqHWyf07WumCpFiSHlZe3x+Q4dFbfZStak3tHNBa2wEMPX+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ZCQlS0sbvz1f0ZY;
	Wed, 12 Mar 2025 17:47:16 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A8EC180044;
	Wed, 12 Mar 2025 17:51:38 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 12 Mar 2025 17:51:37 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<yangxingui@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
	<xiabing14@h-partners.com>, <zhonghaoquan@hisilicon.com>
Subject: [PATCH v4 0/2] scsi: hisi_sas: Fix IO errors caused by hardware port ID changes
Date: Wed, 12 Mar 2025 17:51:33 +0800
Message-ID: <20250312095135.3048379-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg100017.china.huawei.com (7.202.181.58)

This series of patches is used to solve the problem that IO may be sent to
the incorrect disk after the HW port ID of the directly connected device
is changed.

Changes from v3:
- Lose and find the disk when hw port id changes based on John's suggestion

Changes from v2:
- Use asynchronous scheduling

Changes from v1:
- Fix "BUG: Atomic scheduling in clear_itct_v3_hw()"

Xingui Yang (2):
  scsi: hisi_sas: Enable force phy when SATA disk directly connected
  scsi: hisi_sas: Fix IO errors caused by hardware port ID changes

 drivers/scsi/hisi_sas/hisi_sas_main.c  | 20 ++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  9 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 ++++++++++++--
 3 files changed, 39 insertions(+), 4 deletions(-)

-- 
2.33.0

