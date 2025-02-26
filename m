Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8230619D89E;
	Wed, 26 Feb 2025 02:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535942; cv=none; b=T+bbKtA4uuSLjLR+KyqNJUfyEmBYb/P9MJ0ixxXton4HoHxUdv1si2se6lCfqBVKFdCAhHEIBsXFw4yEpCu9/ZeVRHHtgbL5Jge1RzVXLInzN7L+CyCxomOSan/XVkE8K4C6Zz8YmGL6sX2XM5f67axGt9JX63kWzNSgjPCiqoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535942; c=relaxed/simple;
	bh=bXXR0itSb5vCm6uSsQEcEnQDgsp8SoDHma+jHpA1cwA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aw3qsQ6ouPRHmsBoJfAVgxjWlyn/7Vs6DIRY8LPyE8J0/qgTDVUosA+zLbn1/D/DZcw/w6j33UeS2nL+5bM7BboyeB0hDl//dAkD5noQBM/NWVdm3ML4zFY6vHwF+NaJgzaYlglB955OKJWbOFM6XMhAE531DkPN5iyX/A09Wzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=T7J92h8r; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="T7J92h8r"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740535928; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ZQODXK1cc2I+sNWZIm9dydVGUE4aa1Jdys9cTr2m3fM=;
	b=T7J92h8rGoNaMbWnQ//4KpQcjnwmSzpes/DtjMfMywsSz/WEY/1xjEWx8fhJK0bFsWcJ5i6e1kjERP42HN/0fV5JrdxZs0FL3Ago432WjQVn03Kx03dfvk2C8WdYfavTzqRWcMF81WlsyEYjc42X07iiQO1TIlDmkP4zCol9I7Y=
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WQG7I3G_1740535919 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Feb 2025 10:12:08 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	heiko@sntech.de,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: ufs: rockchip: Simplify bool conversion
Date: Wed, 26 Feb 2025 10:11:57 +0800
Message-Id: <20250226021157.77934-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./drivers/ufs/host/ufs-rockchip.c:268:70-75: WARNING: conversion to bool not needed here.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=19055
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/ufs/host/ufs-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 5b0ea9820767..350cb0f8d0c2 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -265,7 +265,7 @@ static int ufs_rockchip_runtime_suspend(struct device *dev)
 	clk_disable_unprepare(host->ref_out_clk);
 
 	/* Do not power down the genpd if rpm_lvl is less than level 5 */
-	dev_pm_genpd_rpm_always_on(dev, hba->rpm_lvl < UFS_PM_LVL_5 ? true : false);
+	dev_pm_genpd_rpm_always_on(dev, hba->rpm_lvl < UFS_PM_LVL_5);
 
 	return ufshcd_runtime_suspend(dev);
 }
-- 
2.32.0.3.g01195cf9f

