Received: from mail-m15566.qiye.163.com (mail-m15566.qiye.163.com [101.71.155.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFAE8248C
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 05:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763011113; cv=none; b=Ff5I4yc3ZWrsX+1Jn4isZF9LF9POMG6xKtsPejCfTTTaEB9FxnEacrtUhUV5aA4VDWZkMIztzYQBCNM7AwnPVgc/9YkTkqOzDuaeiQoVYsyQCNn2jgxJfmmVH4wdJnyIOAxlK9JtiyM5SgDJlm9Je66UDCGgwYJOvCa82F/7EWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763011113; c=relaxed/simple;
	bh=VaaYe5su+E+oMjDY9ku0fwb7ce6A+DbleWzhs51Wing=;
	h=From:To:Cc:Subject:Date:Message-Id; b=a2tj26U5DUG8f5e3dbWY3qDeC8DrSbQUitz8Gg9QYm4rvLa/As+8JjQICqLfIPTgWBYBbmMGD+NxO8Vj396sgZ43MlLDMW8OrN7rdQsu1EOhZfq0Cmvn9E0cVNjpJQfkyXF9ZZ/cJabPZbgHDOjyotspEpJzU23b9CooVkHgEW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=cGynuQme; arc=none smtp.client-ip=101.71.155.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="cGynuQme"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 296cb3bd9;
	Thu, 13 Nov 2025 13:18:19 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] scsi: ufs: rockchip: Fix compile error without CONFIG_GPIOLIB
Date: Thu, 13 Nov 2025 13:18:11 +0800
Message-Id: <1763011091-243727-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0a9a7ba67a5e09cckunmbf7a407227c465
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQkoaSFYYSRoZT05KT04eS0tWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpOTE
	5VSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=cGynuQmeo5r/pOMUg0L1MqV/sw2qlW5PE0tGU9SxRwTM9WSrlzA5dmoxKAJAoALSL44uZXFd/d+75xrpPaqIx1QEa8NLkiG6sRgs1IJ8t5bKuvLMeMCJiT6JRX6TlPvvnVT88CpgyM6bAz0jehhAUxDCWxYVTM9JFjTE4jKyC9s=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=EuHff+UzGclYinLMWG1EV1RQo36xlHX9LHPO+bIQJ+o=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

drivers/ufs/host/ufs-rockchip.c:168:19: error: implicit declaration of function
'devm_gpiod_get'; did you mean 'em_pd_get'? [-Werror=implicit-function-declaration]

drivers/ufs/host/ufs-rockchip.c:214:2: error: implicit declaration of function
'gpiod_set_value_cansleep'; did you mean 'gpio_set_value_cansleep'?
[-Werror=implicit-function-declaration]

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511130238.LlA0MKxW-lkp@intel.com/
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/ufs/host/ufs-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 8cecb28..7fff345 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -7,6 +7,7 @@
 
 #include <linux/clk.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-- 
2.7.4

