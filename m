Received: from mail-m49200.qiye.163.com (mail-m49200.qiye.163.com [45.254.49.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97710175A9B;
	Wed, 11 Mar 2026 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773193548; cv=none; b=S+WC9h6INPiZKnO+Dedv5ESgx+L0HWx4+lW15nSvAl2P253e3EOGnRfTUwgjG40Phdxg/sEVeopFUfkVaKmjAP1N7rR99pnSEaFRJjJ0DQUNn0Vc9lA/r9rHC9GbEsWWX+DqzhK1xzM7mjsCZLONnODl850dI0bZNFxHIN4n1qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773193548; c=relaxed/simple;
	bh=GKVGntZqEzKfzt78i5sIlAgPq8X+DkWTNAxWWLfP9gE=;
	h=From:To:Cc:Subject:Date:Message-Id; b=sZWviTwMSigKlabvaFtgW8rYXL+SMKHsk66ZqN7yrRGmHtW8uqHMgc5cwoiklOYMbtCd/mHfcgRyohNRA9c9R8oPfZm5N0TmYQfPkfjdIW36OaDMqAyAydHR4WnEFlIOUX1Qt+vqQ9WuP48UUw2AOTM5577pdpApjKkHOOD3qf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=Cwrsp6M5; arc=none smtp.client-ip=45.254.49.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="Cwrsp6M5"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 367a6a38c;
	Wed, 11 Mar 2026 09:40:27 +0800 (GMT+08:00)
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
Subject: [PATCH 0/2] Add mphy reset signal to Rockchip ufshc node
Date: Wed, 11 Mar 2026 09:40:16 +0800
Message-Id: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0a9cda8d691c09cckunm2316bf2d158493
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGktOQ1YYQ05KTR8ZH09OGRhWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Cwrsp6M5504KHzH4SH6cZeNGq768UzFNhvH7wEptvLZ2fNdkD9T7fVtO/NczCW+dhRMCSDlqN9ivpZasxViVzXpEnZ9UIxO/zNdBytNp+Wd53mklpnvWjOlZpm1kTFFM8b4B0nWemuzcWfM37UcsHcQrP0v6VOoS2mmomhnr4mg=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=daEjB+39kEWOuY3U2gYjDvWs5SyNz/PoHWsss2wFk68=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>


This series adds mphy reset signal to ufshc node of RK3576.dtsi
and update the dt-bingding file.


Shawn Lin (2):
  scsi: ufs: drockchip,rk3576-ufshc: dt-bindings: Add new mphy reset
    item
  arm64: dts: rockchip: Add mphy reset to ufshc node

 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml | 7 ++++---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi                         | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.7.4

