Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337734A4832;
	Fri, 25 Sep 2026 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346113; cv=none; b=MlgBLzPHG0osmVlYkcdYSX38UjDGp5x5aq+sa99V2FMGCrjq95bos5fNP8Fss1XRBD2IhsW5GbHwZviBPzizf8vJttHgVYXHHIX/bWb+Q639gwILQwTPLh0gJmIi7ZfjTTawhnYgsJB9AoezZex9YBWW7dOhnMYxH3v9zvEFKgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346113; c=relaxed/simple;
	bh=znabeNVR3AGepeCsA1EnxA5x4xL1xP957GJyIN1seys=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jh4saw5x14ucylBOZoO9fiAUpu6BrtsApykAJJkF8xdqdUBUkansnUZDC+O5lSV/YOpcWeydo6tpY9bU0Am2CqbV7gzKGUfXYgbQek5pFlvbSEE9JzvmkfuPsRpSQKZRegnVIBfeY4b8j6EbzQsen8y2GNQ5xOSwsSp/PSD4koI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RCOMbVpW; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RCOMbVpW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=bI
	vTjCdR8QBh40bXwP6YddIJiZylzjt30RVaHWiRRic=; b=RCOMbVpWAOnHoMIElp
	b7MsiAjWPdQCE8uBfHZdGyliK4jaWJsxImdMFHVpWql/K2f4K3UDFalIzyQhBL2p
	/Wd8AF26E0iMheLbuP4DbQHT6OlANgpbO+54yLdxuQoWprXRaF9M9I95vZY0XSTK
	3CUc3NLgTjKP/7MBknhagA0iY=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgA39tRcg7ZqXmxsBQ--.50533S2;
	Fri, 25 Sep 2026 22:21:17 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] scsi: qla2xxx: Protect VPD aux image query with optrom mutex
Date: Fri, 25 Sep 2026 22:21:15 +0800
Message-Id: <20260925142115.2265572-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgA39tRcg7ZqXmxsBQ--.50533S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFWfXFyfGrWxXw13Ar1xGrg_yoW8Ww15pa
	4rKryakryrJrs7Xry8u3WxuFyYkFnrKFWUG3yrta4a93WkXF9I9rWUAr98uFn7C3s3Jr4v
	vF4kXrZ5JayYyr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_FApUUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8B1Aemq2g12EbQAA38

qla2x00_sysfs_read_vpd() calls qla28xx_get_aux_images() before taking
optrom_mutex. That helper reads flash directly, so it can overlap with
other flash operations that hold optrom_mutex. The resulting image
selection can be based on corrupted auxiliary image status and cause the
wrong VPD region to be read.

Take optrom_mutex before querying the auxiliary images and keep it held
until the selected VPD region has been read, matching the locking order
used by qla2x00_sysfs_read_nvram().

Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a4ca22024ede..03feade738e2 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -560,6 +560,12 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 
 	faddr = ha->flt_region_vpd << 2;
 
+	mutex_lock(&ha->optrom_mutex);
+	if (qla2x00_chip_is_down(vha)) {
+		mutex_unlock(&ha->optrom_mutex);
+		return -EAGAIN;
+	}
+
 	if (IS_QLA28XX(ha)) {
 		qla28xx_get_aux_images(vha, &active_regions);
 		if (active_regions.aux.vpd_nvram == QLA27XX_SECONDARY_IMAGE)
@@ -571,12 +577,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 		    "primary" : "secondary");
 	}
 
-	mutex_lock(&ha->optrom_mutex);
-	if (qla2x00_chip_is_down(vha)) {
-		mutex_unlock(&ha->optrom_mutex);
-		return -EAGAIN;
-	}
-
 	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 	mutex_unlock(&ha->optrom_mutex);
 
-- 
2.34.1

