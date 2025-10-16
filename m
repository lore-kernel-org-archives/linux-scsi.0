Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF0631CA54;
	Thu, 16 Oct 2025 12:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760616452; cv=pass; b=FgJ3DvYppN/T1gQ8TjLCzIRQ2C7YeWn7fJsR7x7OnUSk8nXT/sYXSYeCdAr9le4u3GGP516cr4NILuEuQh5Q5LlPokACQRW05HLZVJWJWpxC/9Pf5taPTHsv9lRjTVkX0uUcvyA8zgQRSwPwTVtX21d0kRI2fmYZMzTxAMOtXMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760616452; c=relaxed/simple;
	bh=4BXUhipKa4saO2jFEeVtSyVEBdruhAlxjSMFQGg2Lk0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WKD7G5XyXk0r47qIctaRZsauqKYKZximnph0t/eRJhx1Fj6xYFKj6JAWi/h+fEoU9xoEYtmeJj4E0QyjJYCAP/r7RUOqN5eW1zZkxW3u6Gn+Nji1QIAa8TCyKka27PFvULCDD0bN0auzDFiHpmumInUaRviNlIO0bv0hYpWSvq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=L/JmjaIh; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="L/JmjaIh"
ARC-Seal: i=1; a=rsa-sha256; t=1760616416; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=U/OY09R1Umycf387LhQRQvZWdXv8njqpy4JvwlwOh6P5/txt7dlKHGsnuow2Y6m9+L9GKo98s9rA5t+grQmppVghS9EiN4KCwAdD9YhVf6k8iDQBgoe1eqcplqdE9zHy1WewTUKkq/et05/3VlnsUPaWYX/za3S9HLlNEYnySfU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760616416; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dxq839aAHMctLtHNxtYiJDDAjbNWx58BYY8KBjuCdF0=; 
	b=GVSwdJmw5rqzgD1x5BxRbXFq5txk0HivTAw0atpZziWAxGR4jLn1iNJpe9d42Zxr873dBciobmGOFiKft/T5jfad8+v743K64lW2YEB1AXrueDWZ3XJwx4t5g0JlJDjBMkI/g+U/UqhaXAZrp09jL6trf65XGgWMRiymdVqpyNI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760616416;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:To:Cc:Cc:Reply-To;
	bh=dxq839aAHMctLtHNxtYiJDDAjbNWx58BYY8KBjuCdF0=;
	b=L/JmjaIh81EMz0o2ijeatci130DJ87NLZ00HdpCWEqdBE18ciO5xVau4hP8l7Xi1
	LijPfqEiw5sgZuvGhqLPWspEAA6WlW4EO56UdCDxEjaxIXNAqE0IXCimoQHych8Nx16
	yhISoSHJXWNGWkGHqvImOMv7wzGzbWKqlzm/lipo=
Received: by mx.zohomail.com with SMTPS id 1760616413675917.2416629138661;
	Thu, 16 Oct 2025 05:06:53 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: [PATCH v2 0/5] MediaTek UFS Cleanup and MT8196 Enablement
Date: Thu, 16 Oct 2025 14:06:42 +0200
Message-Id: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANLf8GgC/22OQQ6CMBBFr0Jm7RhaQCkr72FYtGWQJkC1LQRDu
 LsV4s7lm+S9Pyt4coY8VMkKjmbjjR0j8FMCupPjg9A0kYGnvGApy3EIJRMXnFqPmnSuhBRXKjK
 IwtNRa5Y9dq8PdvSaYjMcR1DSE2o7DCZUyUhLwF8XvkJnfLDuvT8zs934tzszTJGJotGkykzp8
 qZt30tlnTzHONTbtn0AtFB0eNkAAAA=
X-Change-ID: 20251014-mt8196-ufs-cec4b9a97e53
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

In this series, the existing MediaTek UFS binding is expanded and
completed to correctly describe not just the existing compatibles, but
also to introduce a new compatible in the from of the MT8196 SoC.

The resets, which until now were completely absent from both the UFS
host controller binding and the UFS PHY binding, are introduced to both.
This also means the driver's undocumented and, in mainline, unused reset
logic is reworked. In particular, the PHY reset is no longer a reset of
the host controller node, but of the PHY node.

This means the host controller can reset the PHY through the common PHY
framework.

The resets remain optional.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
Changes in v2:
- Reorder define in mtk_sip_svc.h
- Use bulk reset APIs in UFS host driver
- Link to v1: https://lore.kernel.org/r/20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com

---
Nicolas Frattaroli (5):
      dt-bindings: ufs: mediatek,ufs: Add mt8196-ufshci variant
      dt-bindings: phy: Add mediatek,mt8196-ufsphy variant
      scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to mtk_sip_svc.h
      phy: mediatek: ufs: Add support for resets
      scsi: ufs: mediatek: Rework resets

 .../devicetree/bindings/phy/mediatek,ufs-phy.yaml  |  16 +++
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 134 +++++++++++++++++++--
 drivers/phy/mediatek/phy-mtk-ufs.c                 |  71 +++++++++++
 drivers/ufs/host/ufs-mediatek-sip.h                |   9 --
 drivers/ufs/host/ufs-mediatek.c                    |  78 ++++++------
 drivers/ufs/host/ufs-mediatek.h                    |   7 +-
 include/linux/soc/mediatek/mtk_sip_svc.h           |   3 +
 7 files changed, 255 insertions(+), 63 deletions(-)
---
base-commit: 40a3abb0f3e5229996c8ef0498fc8d8a0c2bd64f
change-id: 20251014-mt8196-ufs-cec4b9a97e53

Best regards,
-- 
Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

