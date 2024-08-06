Received: from mail-m2424.xmail.ntesmail.com (mail-m2424.xmail.ntesmail.com [45.195.24.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E2754FAD;
	Tue,  6 Aug 2024 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.195.24.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965111; cv=none; b=bmFJ6AZ19IgU2fvPy5WAhwO+KtPNjzwUpdQIvFLhFxQ2wIUWFlrZjZel/AG15QPpcwd7HxMvKNEKbfKMx5UmJWMIj5J7diVRE5GV+3LaY+3FFksP4zTKFyJhfBZ89FUI1Ne1gydjpeR8Rlk3dCkbCsyygYLjpbtVdtLGblqE+7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965111; c=relaxed/simple;
	bh=3fZVWefqUk0Zjct/unBsJL/ObBr/A0DCpYGzqqMmyCw=;
	h=From:To:Cc:Subject:Date:Message-Id; b=FC7fl0tE3Kw1qcuLuNrSUEXmyVMXMu6id6l1G6xK/fejh4c1+jXn5JrO72yqIu48NCfz/kY0aE1cNp5YeYpiRdDri/7MfvGZny1M0KyCDDo/hCAl6VjnEXV9XiZOh1agBj50btsCd1iNqUEZbqY0/9VhyTYk/HH+ofwFqFefPNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=QZbE1jdu; arc=none smtp.client-ip=45.195.24.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="QZbE1jdu"
DKIM-Signature: a=rsa-sha256;
	b=QZbE1jduuSrYrNsfD18oHCNymfgk2GS+DiFGz3wQZAB68x1DeLxvEdbpmgqcUyv6ifBt70Dgl+NJLKKt7kMR/uLD1q9Clr8T0tESW/QBwjMn0KeljylyEDc0scEh34uyK6CTDfWu1FBnliX3vXVm6y+jfkTjRUZIF1TjgDHXWDY=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=VoEidbWMgEaAD+w4sppjFIkcTnBtA/FRKYDmYz7yR08=;
	h=date:mime-version:subject:message-id:from;
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 834F746051B;
	Tue,  6 Aug 2024 15:20:13 +0800 (CST)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Rob Herring <robh+dt@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>,
	Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v1 0/3] Init support for RK3576 UFS controller
Date: Tue,  6 Aug 2024 15:19:57 +0800
Message-Id: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQh5DS1ZMTx8eGk9DGk5ISk9WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91268f583803aekunm834f746051b
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mk06Fjo6DzI6SBI*GjpCShJK
	GCsKFBhVSlVKTElJQklDQ0pPTE1OVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUlPS083Bg++
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>


This patchset add initial support UFS controller for RK3576 SoC.
Patch 1 export ufshcd_dme_link_startup function for host drivers, and
patch 2&3 add ufs-rockchip driver.



Shawn Lin (3):
  scsi: ufs: core: Export ufshcd_dme_link_startup() helper
  dt-bindings: ufs: Document Rockchip UFS host controller
  scsi: ufs: rockchip: init support for UFS

 .../devicetree/bindings/ufs/rockchip,ufs.yaml      |  78 ++++
 drivers/ufs/core/ufshcd.c                          |   4 +-
 drivers/ufs/host/Kconfig                           |  12 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-rockchip.c                    | 477 +++++++++++++++++++++
 drivers/ufs/host/ufs-rockchip.h                    |  52 +++
 include/ufs/ufshcd.h                               |   1 +
 7 files changed, 624 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-rockchip.c
 create mode 100644 drivers/ufs/host/ufs-rockchip.h

-- 
2.7.4

