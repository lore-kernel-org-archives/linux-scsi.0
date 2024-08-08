Received: from mail-m19731103.qiye.163.com (mail-m19731103.qiye.163.com [220.197.31.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8744A33;
	Thu,  8 Aug 2024 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723123213; cv=none; b=j8kB/CmRoHsmt4/gmIrgcYpVVgXZo4QivPwTzX96y5mXC5rOl6GxLueYpbTWvDhubUoYPH/1dp1NzWc7In1JnZiClA63DOtQ0pOK5/dEVkceXU1WEV7lU8pYV8j8oFudpCFOSgm3xOWMO0OC7j1DyG8DxCQXfPx/fFzYYzuQjv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723123213; c=relaxed/simple;
	bh=7/yCxFPro8RakUQFD/0TlBtf7y1AC/HaUbdkmyuJfXk=;
	h=From:To:Cc:Subject:Date:Message-Id; b=lYDDzLbIoXhAQl5yQSl9AmWfcj0JyEH/ovC0quDp9hF8m8Epx/d2VFE3fcgrEoZLJ2eBQvKX7jECUZma48OcttyNeYVWrwSlkFGGZVLps4V5qcxmjaBvIjxkVE4aCEe/j1kyGBDq3EskxLqaMWjBey+DKclLxB1QEPlBgK2d1mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=IRmC65bj; arc=none smtp.client-ip=220.197.31.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="IRmC65bj"
DKIM-Signature: a=rsa-sha256;
	b=IRmC65bjg0O2MQCEcTZKZ91mzw4TUasMD1V0i5q4J2Q8HdiiQcD+iXrRNAYyfcbLSrTUuMlijmsZzbaugXLo8xRjn94ZwLfZu4KeCo695onKZ3q7Go0mUZu/3UZrhFvV3XaTdt3cK/lBy7tifWw2oCuv075TCpG2NS9ez/gW1OI=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=RrX9VkXf3lokm0hBqCnf6pgq8Xxrgk1T4urj3G50BrQ=;
	h=date:mime-version:subject:message-id:from;
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 353F0460378;
	Thu,  8 Aug 2024 11:53:05 +0800 (CST)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>,
	Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v2 0/3] Init support for RK3576 UFS controller
Date: Thu,  8 Aug 2024 11:52:40 +0800
Message-Id: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGkkZSlYdSEkYS05DTBlLHxhWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91301e6d0503aekunm353f0460378
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mjo6Ngw5TjI1IQsPAQodKDof
	NAEKCjlVSlVKTElIS0NCSkNNTklKVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUhKSU03Bg++
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>


This patchset add initial support UFS controller for RK3576 SoC.
Patch 1 export ufshcd_dme_link_startup function for host drivers, and
patch 2&3 add ufs-rockchip driver.


Changes in v2:
- renmae file name
- fix all errors and pass the dt_binding_check:
  make dt_binding_check DT_SCHEMA_FILES=rockchip,rk3576-ufs.yaml
- use dev_probe_err
- remove ufs-phy-config-mode as it's not used
- drop of_match_ptr

Shawn Lin (3):
  scsi: ufs: core: Export ufshcd_dme_link_startup() helper
  dt-bindings: ufs: Document Rockchip UFS host controller
  scsi: ufs: rockchip: init support for UFS

 .../bindings/ufs/rockchip,rk3576-ufs.yaml          |  96 +++++
 drivers/ufs/core/ufshcd.c                          |   4 +-
 drivers/ufs/host/Kconfig                           |  12 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-rockchip.c                    | 438 +++++++++++++++++++++
 drivers/ufs/host/ufs-rockchip.h                    |  51 +++
 include/ufs/ufshcd.h                               |   1 +
 7 files changed, 602 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-rockchip.c
 create mode 100644 drivers/ufs/host/ufs-rockchip.h

-- 
2.7.4

