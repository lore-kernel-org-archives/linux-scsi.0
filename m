Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B93B641
	for <linux-scsi@vger.kernel.org>; Sat, 26 Oct 2024 12:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729947471; cv=none; b=kPBC+7mBRotW4fEnaGs5NpCzCjRZivyQp57jKT4t5Wqs4lORwR4c9MsKx2dog5HafOa1MCseCWTyrDOC8K9iEhQeZI0eKM3Eopu1MP+mNCCBpfPf4CHWiKydaA1Yjl09jmN3owsIMVzpVQThKeIsciArLzU1ANvTt4MbyWKIi+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729947471; c=relaxed/simple;
	bh=7SMgdhtbZShm/9T2Q5p8yqvU9UzdRmdcwcBhJr/cY04=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HuWIZ0iR+EAXwxga1ybzKahXJcjDIyvRncHt0atm2NDpMB6Hn7IywpHpiiWr/C+eLJTzcBAFHsfSmYVeZJ+sIHhQlBby916n7LJTtL2H6SgXgwFf7+Ra7jvYEj9asUiwQ4jv2pJEeB3r4p2fP4tTnPcKKU50ZWUHXrkW0x1zKCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XbKQp22K1z2Ddqk;
	Sat, 26 Oct 2024 20:56:18 +0800 (CST)
Received: from dggpemf100006.china.huawei.com (unknown [7.185.36.228])
	by mail.maildlp.com (Postfix) with ESMTPS id 6841114011D;
	Sat, 26 Oct 2024 20:57:45 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemf100006.china.huawei.com (7.185.36.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 26 Oct 2024 20:57:44 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>, Nilesh Javali
	<njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>
CC: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 0/2] scsi: Fix two possible memory leaks
Date: Sat, 26 Oct 2024 20:57:09 +0800
Message-ID: <20241026125711.484-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100006.china.huawei.com (7.185.36.228)

When "ops->common->sb_init = qed_sb_init" fails, the DMA memory needs to be
explicitly released.

Zhen Lei (2):
  scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
  scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()

 drivers/scsi/qedf/qedf_main.c | 1 +
 drivers/scsi/qedi/qedi_main.c | 1 +
 2 files changed, 2 insertions(+)

-- 
2.34.1

