Received: from mail-m15572.qiye.163.com (mail-m15572.qiye.163.com [101.71.155.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3634425A65A
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740553058; cv=none; b=oj5MtEYO42e2hh5jeIi1QvMhdQDH9OtJdNLdPCRrQS0c7jYCrvWKZf/LFypuZUqdvM/QXGxAi2R4kTWfwzJda3Ml29KDdojR5PZRCatuWawLV4Ap8tX3LsCpj6qKc2nDI3lCMe6d25uIdXejaXrf/9cAqp6j10UlU2Ko6+DImWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740553058; c=relaxed/simple;
	bh=DSr5R765Uc5AvhWGwFDH/nRABDfaZE7eVR0TZ5KkuvY=;
	h=From:To:Cc:Subject:Date:Message-Id; b=IY2YMp9Ys84m3DOOn40fx8z/xeoJa/poe6/UkxDjuZdHQ2Vz9qrRTdx5h8MX7dR2LNtr3vP8X9IvGtJHu0N97vsGyyUtbEqjvCrWtc/XhvvI0Xom0VMDP2eWmBtswbI1yC5Btllpwp13Qic+wcVdRXsP2qVvKSe1+cKV6F0K4A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=Tn8idupq; arc=none smtp.client-ip=101.71.155.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="Tn8idupq"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id c3c4802a;
	Wed, 26 Feb 2025 14:52:18 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH -next] scsi: ufs: rockchip: Fix devm_clk_bulk_get_all_enabled return value
Date: Wed, 26 Feb 2025 14:52:13 +0800
Message-Id: <1740552733-182527-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQkJPQ1ZCTklKHh5NGhoZHklWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
X-HM-Tid: 0a954107159209cckunmc3c4802a
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAw6MBw*NTIXFQsoNw1IFSIz
	SiNPCg1VSlVKTE9LTk5JTEhCSkpMVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUxKTTcG
DKIM-Signature:a=rsa-sha256;
	b=Tn8idupq9VW2EskSrudnzsQqVx4GJVI5Bf7VctgPUDcWwCezaqGZmk25qjUrFxMw8o3oMlpT9I4T6ti7i9t3p66XDJ04r3rRCwoXnWty4cU+swuYir0Nj7XaCh2NCUT+l6IrUSP3QjFVuJLUrp6r2vZ3WpW2feBm9m/ct57mjtk=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=VzrZ+wbG+3w9s0APHJLsMkoPDEWLjLl4FcmfI5qMrnw=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

A positive value is for the number of clocks obtained if assigned.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/ufs/host/ufs-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 5b0ea98..c4d561f 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -171,7 +171,7 @@ static int ufs_rockchip_common_init(struct ufs_hba *hba)
 				"failed to get reset gpio\n");
 
 	err = devm_clk_bulk_get_all_enabled(dev, &host->clks);
-	if (err)
+	if (err < 0)
 		return dev_err_probe(dev, err, "failed to enable clocks\n");
 
 	host->hba = hba;
-- 
2.7.4

