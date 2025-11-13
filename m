Received: from mail-m49223.qiye.163.com (mail-m49223.qiye.163.com [45.254.49.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B42C3074AD
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 04:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763009930; cv=none; b=sqf/2ZEFgyzIyD4axZjsYufQ2PD4X9Xcjp1CHqy1EpYt4lhsfXk8JZ9K6hmdPJ6fPSZ482OzVRPiTWLJbJY+oIg6t519tO7+qGub3hafRolzAcORy3YZghhb0FIKpQBCfuPpTtOm2OjjiabTb+7wKPN8sfjtGakDAx1RTrht9mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763009930; c=relaxed/simple;
	bh=hPg1hnvKLM2IpUbEoudYpRh/nWJBlJAREhN7fzn9x1k=;
	h=From:To:Cc:Subject:Date:Message-Id; b=h4CmdE+M2OGlqhkTQ9Q9WX8y6ewTsARDiyYXBnrkNwH7h/gk8Z1UkENEZV10fAy5zG/8lfwqMM+zWn57kBkFF1xb1lZDTSrQvXHfeRwcjXxGXsa4WqvDhoFo/ccLF7ceWX2c+UhCGp5bVcIXj76cIT2cSvPJXucM7nivPJEuHmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=J1XlFhEX; arc=none smtp.client-ip=45.254.49.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="J1XlFhEX"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 296bfa5cc;
	Thu, 13 Nov 2025 12:53:27 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] scsi: ufs: rockchip: Reset controller on PRE_CHANGE of hce enable notify
Date: Thu, 13 Nov 2025 12:52:55 +0800
Message-Id: <1763009575-237552-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0a9a7b8fb58909cckunm46d766c72755ee
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGk8aS1YeTUpCHkpKGkkeSx5WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=J1XlFhEX2yFS7sC4gOYGGqYmfMuOVG92NPKwbE2CtnW49oKs/9NpZqWwiaqFcQLnE1dQHL5SrolvCFGrmcu2yxG1wxSue83TWZb5xFy53H/VoARY2o/c4w9OTh3Q9r4QpGhyiGvklHWBHk5qkp5vlFfL7NcM/5C3/As/zZCmc8U=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=N8ROXJH/S65qux5vKaPYPdwXagamfVXkgVOLDFKArRw=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This fixes the dme-reset failed when doing recoverying, because device
reset is not enough, we could occasionally see the error below:

ufshcd-rockchip 2a2d0000.ufs: uic cmd 0x14 with arg3 0x0 completion timeout
ufshcd-rockchip 2a2d0000.ufs: dme-reset: error code -110
ufshcd-rockchip 2a2d0000.ufs: DME_RESET failed
ufshcd-rockchip 2a2d0000.ufs: ufshcd_host_reset_and_restore: Host init failed -110

Fix this by resetting the controller on PRE_CHANGE stage of hce enable
notify.

Fixes: d3cbe455d6eb ("scsi: ufs: rockchip: Initial support for UFS")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/ufs/host/ufs-rockchip.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 8754085..8cecb28 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -20,9 +20,17 @@
 #include "ufshcd-pltfrm.h"
 #include "ufs-rockchip.h"
 
+static void ufs_rockchip_controller_reset(struct ufs_rockchip_host *host)
+{
+	reset_control_assert(host->rst);
+	udelay(1);
+	reset_control_deassert(host->rst);
+}
+
 static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
 					 enum ufs_notify_change_status status)
 {
+	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
 	int err = 0;
 
 	if (status == POST_CHANGE) {
@@ -37,6 +45,9 @@ static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
 		return ufshcd_vops_phy_initialization(hba);
 	}
 
+	/* PRE_CHANGE */
+	ufs_rockchip_controller_reset(host);
+
 	return 0;
 }
 
@@ -156,9 +167,7 @@ static int ufs_rockchip_common_init(struct ufs_hba *hba)
 		return dev_err_probe(dev, PTR_ERR(host->rst),
 				"failed to get reset control\n");
 
-	reset_control_assert(host->rst);
-	udelay(1);
-	reset_control_deassert(host->rst);
+	ufs_rockchip_controller_reset(host);
 
 	host->ref_out_clk = devm_clk_get_enabled(dev, "ref_out");
 	if (IS_ERR(host->ref_out_clk))
@@ -282,9 +291,7 @@ static int ufs_rockchip_runtime_resume(struct device *dev)
 		return err;
 	}
 
-	reset_control_assert(host->rst);
-	udelay(1);
-	reset_control_deassert(host->rst);
+	ufs_rockchip_controller_reset(host);
 
 	return ufshcd_runtime_resume(dev);
 }
-- 
2.7.4

