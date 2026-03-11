Received: from mail-m32100.qiye.163.com (mail-m32100.qiye.163.com [220.197.32.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEDF28D830;
	Wed, 11 Mar 2026 01:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773193247; cv=none; b=nIEWS0Ii2RmKaqqFXtrklydvhfH0LP4mQn20YIx/q3jWZ5SCaPzGElMd+5AN7YLo1BpOi4EsAD0EdbKjjUpxenGW2aj17+lBvHnJP/dANc5ohok/f+IZdjwVbLKbNxIsnRhTkdqgZgO6ypVajzHe9Fy97IMUeMbGVbruhQQe114=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773193247; c=relaxed/simple;
	bh=t19rYp/UP3r1THyzqQs/0RtJqZph7Ttt57pgfFKKpV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=JGhs2+qURXFx2KwJ3TWtU79EAleo9e7qLUkjkgaBhmjFMu0z9WhkbEgjofw0yqNZk7wNGUVrp/AIY4M1VjVeGMD0LIqiAojduTCGH6OIGANmQdwMpGVhlFt2iv5p//NCpmcH30u+PT+e7tCdRSv1vyoPjPUU3pBi6sTD8QQZT5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=Jzsz3RA2; arc=none smtp.client-ip=220.197.32.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="Jzsz3RA2"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 367a87875;
	Wed, 11 Mar 2026 09:40:33 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Heiko Stuebner <heiko@sntech.de>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	devicetree@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH 2/2] arm64: dts: rockchip: Add mphy reset to ufshc node
Date: Wed, 11 Mar 2026 09:40:18 +0800
Message-Id: <1773193218-215988-3-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
References: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
X-HM-Tid: 0a9cda8d841f09cckunm2316bf2d15851b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGU5MGlZPSUkfSUoYSRhMQkJWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Jzsz3RA2XXrDgueY12HySIdpgncCrZvdEghbHItFLUNS5GOiAeZzakfyALqzziMjmUW/oUAb9l7/OFdYCk/aRd3mOZOoy+GPhh6kkpuARrhtTn057r/bhM0FZrxRB7kpdccDhWwskJ3ah3vRctynUlN/qk/COWSBMX+/BIRbdWo=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=WC5Y8mSIbVN6HwHPXOPgHXXwQRMByedP7DOhwmKOkVg=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Add mphy reset to ufshc node to fully reset the whole UFS blocks
if needed. Otherwise, it may occasionally prevent the UFS controller
from successfully linking up with the device.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index 9c28769..9fa99be 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -2035,8 +2035,9 @@
 			pinctrl-0 = <&ufs_refclk &ufs_rstgpio>;
 			pinctrl-names = "default";
 			resets = <&cru SRST_A_UFS_BIU>, <&cru SRST_A_UFS_SYS>,
-				 <&cru SRST_A_UFS>, <&cru SRST_P_UFS_GRF>;
-			reset-names = "biu", "sys", "ufs", "grf";
+				 <&cru SRST_A_UFS>, <&cru SRST_P_UFS_GRF>,
+				 <&cru SRST_MPHY_INIT>;
+			reset-names = "biu", "sys", "ufs", "grf", "mphy";
 			reset-gpios = <&gpio4 RK_PD0 GPIO_ACTIVE_LOW>;
 			status = "disabled";
 		};
-- 
2.7.4

