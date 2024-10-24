Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072F36F305;
	Thu, 24 Oct 2024 08:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729758643; cv=none; b=MuCAZSOWTELOr0coYI6AkoA396bGguFi7LK7eQDiGbOXitO+MMo5D02RB3HjuBR4YHJNfNUGo9VbYIErZRW5Trk43UjQnV42+VvsZJ98rCljIT/LXaFatt+x3xnqLSq3bOyIiyyUS5ROkbnMadydelUtqgTY7P67XIo58AgXYfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729758643; c=relaxed/simple;
	bh=zGfFzfZwqOhvRxHgI9aHvx9qkxsbHu5dqH8puYXq5Ig=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bS79IspigKES4PVyzY0U3FcGkfyTO219ESDwBBDgyyZVf5ZTxf6GmNRF4SiPQNGXDuoOiIlFHGg8WylbNgdVQf5mQX3IQcdhGa7/5+FxOu4nxkO633Pz1QjwzFHTrwzMi8dAKiz0ZXAVmHLaa/p0xozQjExl/fsIFB+kGzJ3bQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XYzZm4f7Cz10Nxt;
	Thu, 24 Oct 2024 16:28:32 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id BF715140135;
	Thu, 24 Oct 2024 16:30:35 +0800 (CST)
Received: from huawei.com (10.175.103.91) by kwepemf100008.china.huawei.com
 (7.202.181.222) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 24 Oct
 2024 16:30:34 +0800
From: Zeng Heng <zengheng4@huawei.com>
To: <sreekanth.reddy@broadcom.com>, <sathya.prakash@broadcom.com>,
	<James.Bottomley@SteelEye.com>, <eric.moore@lsil.com>,
	<suganath-prabu.subramani@broadcom.com>
CC: <bobo.shaobowang@huawei.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <MPT-FusionLinux.pdl@broadcom.com>
Subject: [PATCH] scsi: fusion: Fix not used variable 'rc'
Date: Thu, 24 Oct 2024 16:44:17 +0800
Message-ID: <20241024084417.154655-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Fixing exposed the fact that improperly ignore the return value of
scsi_device_reprobe() in _scsih_reprobe_lun(). Fixing the calling code to
deal with the potential error is non-trivial, so for now just WARN_ON().

The handling of scsi_device_reprobe()'s return value refers to
_scsih_reprobe_lun() and the following link:
https://lore.kernel.org/all/094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com/

Fixes: f99be43b3024 ("[SCSI] fusion: power pc and miscellaneous bug fixs")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 drivers/message/fusion/mptsas.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a0bcb0864ecd..a798e26c6402 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4231,10 +4231,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
-	int rc;
-
 	sdev->no_uld_attach = data ? 1 : 0;
-	rc = scsi_device_reprobe(sdev);
+	WARN_ON(scsi_device_reprobe(sdev));
 }
 
 static void
-- 
2.25.1

