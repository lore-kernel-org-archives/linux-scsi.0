Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2377483BFB;
	Fri, 16 Oct 2026 12:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154018; cv=none; b=t8fA95FEYEuH1PONBBvS8qELg+cKPJYweG7DVuM7XhLizANVPQd2Z8TNkXUEbLkq97h6jxlfs2rVRjmvn2LkL/JcUtkz4ahyq3Kwbk0OhYETxdeXsRsyYA4xG2x7Dc+1cFoQnWs+1ZTUZtb9g/F35l71UL8WrgprZFcY5a56bVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154018; c=relaxed/simple;
	bh=Yx74k9FBc1k/4s/wqGih7fG59PtJCXH6WArab5XivVg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oX0lvh51bzKpVEzcgoWHexnHIx7TbTkq5LmnN+eTByPgUDRovqdCiJRRDxDLEVr/s0PRETc+7mNx4/39pS/ItKwpRq+y1Pm6RqXQ0OLVMkZVVKjWHqprmMduxCQ0lERB0/40CT4jz2YEibD+sFqj4paAxEEl5YbTN/9nB4N9zk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=g0/myGBU; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="g0/myGBU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154015;
	bh=Yx74k9FBc1k/4s/wqGih7fG59PtJCXH6WArab5XivVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g0/myGBUGA3eWIVdKI0rfI8mInP2nfTF/6FA6oXVl/tGOzfQBQkaDGPhppVd4IRWT
	 5NZowpSg6bt57MRDbUvWLc/2G/GdwEz6KC+IXEgpMUr6g/Gjx430JBXku4U73NdFwe
	 9laH8wpvq6FOITyDY8Rk4FeGQzeIvf4V1Buw5Y3GvfJ9GFiPC7lLstp+ZMnoQ4Hy78
	 NKldHDBt2EDkHOBBpy4pP6pHOB/k0FJcZpCBPdyjWgxwmj/6y/5/Ce0HY8K+U18B9A
	 Kb6D8SWwSgjuBKXRnBerTmmLyl2ETRI6z28QCac1r4MlHzm3LV7OZeGYa8cV6vK1oS
	 eLWt/Hscj4w9Q==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 425BA17E150A;
	Fri, 16 Oct 2026 14:33:34 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:32:56 +0200
Subject: [PATCH v14 04/23] scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to
 mtk_sip_svc.h
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-4-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
In-Reply-To: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=1832;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=e11uj3DE6zvd4oYfRMlams6rLdYNXhiR9LbrPBoXvrA=;
 b=ztPolG/plmM7/McYm3/1WAnOVFSO7sXVprjlyojcnDDZY8OTz/JIJUoBvA7QrqcCuVi0EjCI6
 VACM361HSwSBngOw36wG+oDoWZQ0PjY9lhTCp9Z1ItzSO0d1BpWGxQe
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

SMC commands used by multiple drivers need to live in a shared header
file somewhere to avoid code duplication. In order to rework the MPHY
reset control to be in the phy-mtk-ufs.c driver, both ufs-mediatek and
the phy driver need access to this command.

Move it to mtk_sip_svc.h, where other such command definitions already
live.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
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
index 6c95a29b79fa..36ab3153fe44 100644
--- a/include/linux/soc/mediatek/mtk_sip_svc.h
+++ b/include/linux/soc/mediatek/mtk_sip_svc.h
@@ -22,6 +22,9 @@
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, MTK_SIP_SMC_CONVENTION, \
 			   ARM_SMCCC_OWNER_SIP, fn_id)
 
+/* UFS related SMC call */
+#define MTK_SIP_UFS_CONTROL		MTK_SIP_SMC_CMD(0x276)
+
 /* Modem related SMC call */
 #define MTK_SIP_KERNEL_CCCI_CONTROL	MTK_SIP_SMC_CMD(0x505)
 

-- 
2.56.0

