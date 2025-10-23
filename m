Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EDE34E75A;
	Thu, 23 Oct 2025 19:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249309; cv=pass; b=lTNB/LZ13aZY1u5pzDHbqOj9GvJkTNRX0akEyhsx8duhn6yzs+FT3chyU9sTiiHVm85elYhYoGdKbDDopc6fHStNZOlEHVV5JyAgto7Sli/m4Vx/GRlGKujoMsb955s7lDdODL6Th5BF+bwhCGMSt/rC1fF3I5l+L5ljJEwFIew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249309; c=relaxed/simple;
	bh=2MgGQBN7HIhsOwYPNp857MPKJx6nbFQYjkN8h458qHE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OeA4FrESLDYafK79hagEVoqW9mJMd3z2dNi/yFSTuV+eRnUGqAlH/X9LipRHGeWC9pYP7uJBKdhyHfVICyp1gs5UH/ZLHq6IRc9BdW4j7OYDOipIMVOrBLxQ7HrReRCjp4ijDC7F+ak+lN3suSc7yOZtkiY3mn2QbtX5eCcfCPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Rg1/iCTc; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Rg1/iCTc"
ARC-Seal: i=1; a=rsa-sha256; t=1761249040; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=UwWp46qbqiqDB8MgMLs378EEZ5FfiV2NzxHZDXTzAr/OWgurnjRkodt9Sca27SMIBEnzZw+4Ti+N6m99G5L2kuuGWJWOJVBzPIR8spsGIDBUnnrE9X9bU5ASTuEll6gpjY5bdQK9iLNUPPhML2YTO9rn5ULKogm73JH0wVqcG+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249040; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=pCaH1a9wldvO9Pw9Dx3Q0BTdvJ48nMmHGiHHjar/Pus=; 
	b=HIrksnmpKgiZeKfYSXOSajl6VaXsXd4fDNBcACYwhAnODFwNbGaH4ADVkCuMhZ4iAQDQmgpjR8bVDQ9xlyDbz4+jGO7QfXnL+HHbfW4pR6+D+smVe+mPOvLB0nZLD40XiEXdt9pS4ZaSuY55eE/kHLPC4Vz3SnqbQOupwbZVIeg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249040;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=pCaH1a9wldvO9Pw9Dx3Q0BTdvJ48nMmHGiHHjar/Pus=;
	b=Rg1/iCTcBCs4+t/UbXUSX4ifgFWdnl++S6j4lrXaHo0NdEnPpbOeSUwWOoBobFU6
	FkHqhQuzZh2fEZhxwABoBxmjJU9rNORq3u2lF391u14mZ0DcxLuI7CJc58OcxzEjh97
	tmcFB+uTu34uADoJei6cLBgFiXqd369ElmrbBCYE=
Received: by mx.zohomail.com with SMTPS id 1761249038272520.1118303217484;
	Thu, 23 Oct 2025 12:50:38 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:22 +0200
Subject: [PATCH v3 04/24] scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to
 mtk_sip_svc.h
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-4-0f04b4a795ff@collabora.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
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
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

SMC commands used by multiple drivers need to live in a shared header
file somewhere to avoid code duplication. In order to rework the MPHY
reset control to be in the phy-mtk-ufs.c driver, both ufs-mediatek and
the phy driver need access to this command.

Move it to mtk_sip_svc.h, where other such command definitions already
live.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h      | 1 -
 include/linux/soc/mediatek/mtk_sip_svc.h | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
index 7d17aedf6fb8..d627dfb4a766 100644
--- a/drivers/ufs/host/ufs-mediatek-sip.h
+++ b/drivers/ufs/host/ufs-mediatek-sip.h
@@ -11,7 +11,6 @@
 /*
  * SiP (Slicon Partner) commands
  */
-#define MTK_SIP_UFS_CONTROL               MTK_SIP_SMC_CMD(0x276)
 #define UFS_MTK_SIP_VA09_PWR_CTRL         BIT(0)
 #define UFS_MTK_SIP_DEVICE_RESET          BIT(1)
 #define UFS_MTK_SIP_CRYPTO_CTRL           BIT(2)
diff --git a/include/linux/soc/mediatek/mtk_sip_svc.h b/include/linux/soc/mediatek/mtk_sip_svc.h
index abe24a73ee19..7265ff2a6e2a 100644
--- a/include/linux/soc/mediatek/mtk_sip_svc.h
+++ b/include/linux/soc/mediatek/mtk_sip_svc.h
@@ -22,6 +22,9 @@
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, MTK_SIP_SMC_CONVENTION, \
 			   ARM_SMCCC_OWNER_SIP, fn_id)
 
+/* UFS related SMC call */
+#define MTK_SIP_UFS_CONTROL		MTK_SIP_SMC_CMD(0x276)
+
 /* DVFSRC SMC calls */
 #define MTK_SIP_DVFSRC_VCOREFS_CONTROL	MTK_SIP_SMC_CMD(0x506)
 

-- 
2.51.1.dirty

