Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59DE42E419;
	Wed, 30 Oct 2024 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730254695; cv=none; b=NMDuvmWTX22WbtVT/RB9u3afTfKz3/fwfDcFbcOqT2zxMnDxkSbCR/qI+L2rn/zu/R0mijTkbHJyXwlcqf1pL3rnbZWgSU3kM4z+1fd8nmyalqQLkXpiCeuwo1tzW7qgGzjWKE6Apd3AH2z/vem7FYXp5AFx6HiRyIKm0ef5ZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730254695; c=relaxed/simple;
	bh=9eqQfdscBEjLtcrWq8qKVNz4RDrbIrtOF0WQ6IAd98E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GQI0MRfSLF30T7lbUlgpa7UrcoCDPdiyePBKf2MxldF6arqAlT76usYkbFdIWMvG44yY5ItBQHcQ/rBkIlRKcKqq85CfOqvX+DNd+IGpTufCbm7/XDTv0pz77RKPKWg1Hw4Hc/E/JOwKkzx4VDVBtVqBmiGjU0lWW59w+bNSSkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=P/hSRdOe; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="P/hSRdOe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=+LaK4
	I9+wihg0+jMQhuM6fhmJK0Ypaq2No83nxa1oWg=; b=P/hSRdOe3bu+dRTXrH/+a
	iEIpgRMP7wXLjYl5ltIepFWr4OSDxM7VE7GL94S2HW+7l+7FIXB8wI2T2L+bJdJb
	Ry9lsDMHg8yu7SgBAh8V/dwfdU9iaHs11s1+hr+j+tYQ/M/gIlIlFwAgHTPow/FO
	l7l7B4uXITSdYwdLP4lvII=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [223.70.160.239])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgD3n_BZlyFngsUABw--.64607S2;
	Wed, 30 Oct 2024 10:18:02 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liubaolin12138@163.com,
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v1 v1] target: fix incorrect function name in pr_err
Date: Wed, 30 Oct 2024 10:18:00 +0800
Message-Id: <20241030021800.234980-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgD3n_BZlyFngsUABw--.64607S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF17ZryruF1DZF4rWw4kJFb_yoWDWrc_u3
	4UArnrWr18ur1kW34fC3s7Zr90yrn7ZF4Iva1Fy39xta45W34Yy3sYgFn5ArWq9r40q3W5
	C3saqF4DGFWfKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRtkucJUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/1tbiMRmIymchlCVYDAAAsJ

From: Baolin Liu <liubaolin@kylinos.cn>

in pr_err(),bdev_open_by_path() should be renamed to
bdev_file_open_by_path()

Fixes: 034f0cf8fdf9 ("target: port block device access to file")

Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 drivers/target/target_core_pscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 440e07b1d5cd..287ac5b0495f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -369,7 +369,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	bdev_file = bdev_file_open_by_path(dev->udev_path,
 				BLK_OPEN_WRITE | BLK_OPEN_READ, pdv, NULL);
 	if (IS_ERR(bdev_file)) {
-		pr_err("pSCSI: bdev_open_by_path() failed\n");
+		pr_err("pSCSI: bdev_file_open_by_path() failed\n");
 		scsi_device_put(sd);
 		return PTR_ERR(bdev_file);
 	}
-- 
2.39.2

