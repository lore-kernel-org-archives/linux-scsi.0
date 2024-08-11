Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F661CAAF;
	Sun, 11 Aug 2024 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723387209; cv=none; b=P5VzcY0wdtxY9S4s8TKDpg/S/h55Xtydd7Dkld9ff4AaPRlDse6FB12QTyRCURY4ks2FJzXkcIU7sLcYDXEs5u2uEnweFbPvYoh7g5u/MJnHhycQrc++2L6yeEEpz12gmM++/dIOavrROs1vi5qUg1sQr76BqaPCFglQ6Gi3NtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723387209; c=relaxed/simple;
	bh=epQhxs8sy1zYkShhWyN83noCeVO4L3n1LqKdSyhuhl0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KUFaA9gSegSjojE7fexp2K/BGZLt/IGxa1v6BN1VM/AObxcAmXWoWMfboKvh5a2BGr+VVbDy7hjXizeSoVDh9gQ7F86XurRRXOS4D8EkHKii/yll64+N8/rIq2AOypk1Pj7hDwO0dD8sT8+grjp2JpWa5G+Kz13iMMzn71zq4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KCfAkj6L; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KCfAkj6L"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723387208; x=1754923208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=epQhxs8sy1zYkShhWyN83noCeVO4L3n1LqKdSyhuhl0=;
  b=KCfAkj6LGtxqvLKB74XExUAui2Czia008W0bIdAJrD7ntzZUIT+PE4jI
   /wvRi/CQhDH16zjZETiuHBa8VqncYPoHKKBb7drcFlJpWnvNGp/f3UbZR
   sl/Fzr5ie4uNBf3SnsMlgdJw4tcGezr0mpdZZf4NDZxu4acm7wBy67kF3
   l20Q0/Fp0Eq8VMeFyRP+lXIqnbYnXhBHGiDBR2Y0pM5kppR06J+u3cYQv
   WzimqegcUfw+d9N7RPVHjIpwsiyAEs9rmjyN45Jagrs16chPYcJPA/zSt
   iaYX8q913sKEChyFp6AB+BJyBaHSVpgsuJ2pH22lKgqrVSQw4GwAG8VUr
   w==;
X-CSE-ConnectionGUID: KHhPyBg0TgKxxah0Aftujw==
X-CSE-MsgGUID: Cn3c6x5jRXuQv0T5F691zg==
X-IronPort-AV: E=Sophos;i="6.09,281,1716220800"; 
   d="scan'208";a="23408920"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2024 22:40:01 +0800
IronPort-SDR: 66b8c096_cBbqJ2DZ+H9PBoE/4N192+Eu9UEiD8fPvaIIWwVQ88u+z8J
 X30g4q1dwSj7uC0nPRhmxsuG6+9ttNAPj/lkxBg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2024 06:45:58 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2024 07:39:59 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
Date: Sun, 11 Aug 2024 17:37:56 +0300
Message-Id: <20240811143757.2538212-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240811143757.2538212-1-avri.altman@wdc.com>
References: <20240811143757.2538212-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare so we'll be able to read various other HCI registers.
While at it, fix the HCPID & HCMID register names to stand for what they
really are. Also replace the pm_runtime_{get/put}_sync() calls in
auto_hibern8_show to ufshcd_rpm_{get/put}_sync() as any host controller
register reads should.

Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufs-sysfs.c | 38 +++++++++++++++++++++---------------
 include/ufs/ufshci.h         |  5 +++--
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index e80a32421a8c..dec7746c98e0 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -198,6 +198,24 @@ static u32 ufshcd_us_to_ahit(unsigned int timer)
 	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
 }
 
+static int ufshcd_read_hci_reg(struct ufs_hba *hba, u32 *val, unsigned int reg)
+{
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ufshcd_hold(hba);
+	*val = ufshcd_readl(hba, reg);
+	ufshcd_release(hba);
+	ufshcd_rpm_put_sync(hba);
+
+	up(&hba->host_sem);
+	return 0;
+}
+
 static ssize_t auto_hibern8_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -208,23 +226,11 @@ static ssize_t auto_hibern8_show(struct device *dev,
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return -EOPNOTSUPP;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	pm_runtime_get_sync(hba->dev);
-	ufshcd_hold(hba);
-	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
-	ufshcd_release(hba);
-	pm_runtime_put_sync(hba->dev);
-
-	ret = sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
+	ret = ufshcd_read_hci_reg(hba, &ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	if (ret)
+		return ret;
 
-out:
-	up(&hba->host_sem);
-	return ret;
+	return sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
 }
 
 static ssize_t auto_hibern8_store(struct device *dev,
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 38fe97971a65..194e3655902e 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -25,8 +25,9 @@ enum {
 	REG_CONTROLLER_CAPABILITIES		= 0x00,
 	REG_MCQCAP				= 0x04,
 	REG_UFS_VERSION				= 0x08,
-	REG_CONTROLLER_DEV_ID			= 0x10,
-	REG_CONTROLLER_PROD_ID			= 0x14,
+	REG_EXT_CONTROLLER_CAPABILITIES		= 0x0C,
+	REG_CONTROLLER_PID			= 0x10,
+	REG_CONTROLLER_MID			= 0x14,
 	REG_AUTO_HIBERNATE_IDLE_TIMER		= 0x18,
 	REG_INTERRUPT_STATUS			= 0x20,
 	REG_INTERRUPT_ENABLE			= 0x24,
-- 
2.25.1

