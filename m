Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795254;
	b=C7J9wWZgn9lz5tVmtTCOyFGDDLsfsfj2hSdRlea+9wDxegD6QZ2/U3GW6XdL3rq3d0ZJ
	 oop146A7pcEDCI2Qn1wc9zoAQuwtAt7ugoMLroJYOv/B7MjvRQxLNRyezIfybt1WyiDxM
	 +pYd4RIrQiV0d0ONTYNhNCjplU+UKYTwEQsKzBdGMpVzTnS6NmyfHnWfNvngGWI8pImX3
	 y0FmSn0XcFnlWejNSCsJNtwtl8+5xmhmtNIQeuG90OM+mHxVFUlFW1OuvOP1a6BXlbxT9
	 sT291fQcY7vQ9evX5NhmINBWwSoFa12haYpwsDFLXZPWgobbuw/KUB70p8MGnMGDacA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795254;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=hB2xcFpbnldrxETC4Qu7wsET6W6hDKy+Oz0dKg5g86k=;
	b=lUX0oWw/qSIvH/rjd6e6Tj9krn2PfV+Y9CR1OgqRSRDLIy3toMOK55X9Wac9efF2aSVW
	 Ivg+UGu55EJH995nd6XFeHuy0ciNFdlcsrcSljVeq7QOVkRMiVlWhnAn1z/y4hIeWsgmj
	 gA6rUVZYci0Ha/jTMlXcKHGmK+afhNcK26++BIiiiedIcN/zZ/G6pLesZtBh9PX1fAkxv
	 CXYLZS8TeqIn7oscZYnQS5J8L+xdJQmWIwwddx11WiFSa341WsdEeKhBtq25jMItwVU2G
	 UUSZL3nXRZN5uWrIfI57Y8pxkrNECQOzuh3rHNbhOmBG9+WuEF0lIIkR2xZwREKcfBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=IQLJx2qA;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D6860A2638;
	Fri, 27 Nov 2026 16:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1D6860A2638
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=IQLJx2qA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795795252;
	bh=BH/vSvBN6lEf5PIBrlkG4uFpSEzvinn2hQjD27hkMnk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IQLJx2qAmnFC9BSZIJFyJ/a0RNeGg2pxqL3TqCXx2DqvNqky10X+3hKzdPPwPylis
	 lXqFMbyKuLh3/fo+sq91eRK9lZ17LPmqvkU0SFbuKD96bDq0P6CVmvOEVPRyznXV9t
	 YaiGeXbzXoEuu5Ngf4dgrz45inMUGVpASsHP9HDRDqcZmRs2X3AXvToEcNxnt9VZwL
	 UrnuwuGA9aeriCsiYH7dlzAsEi2wD3Z9Cp4LIMYdEihOHG+uuusS96eeNQdobDQuEk
	 WjaFlIr5SYQDLHbgppuvzrl44GSnnfkH0XkQoilwqD3NNeLaaDW6YlaEhVzm6paq6x
	 KUjhu1OQu+BhA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0597A17E0477;
	Fri, 27 Nov 2026 17:00:50 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 27 Nov 2026 17:00:24 +0100
Subject: [PATCH v16 21/23] scsi: ufs: mediatek: Remove ret local from
 link_startup_notify
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-mt8196-ufs-v16-21-6f2568f7c119@collabora.com>
References: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
In-Reply-To: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
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
 Mark Brown <broonie@kernel.org>, Chun-Hung Wu <chun-hung.wu@mediatek.com>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795795222; l=1411;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=IOwWrT+/uQLSZA4pVA9FbixFTjAE+E0jODvDabwQg0Y=;
 b=gX2oMYWa0YBvzC9Wjd9BA+Qzi7Zmj+hQq5O+X/3mMahVhd+SwVYzn1Q9b+pzm6He2d2uOrQsi
 4jOH3H7QemDDGfj12OktpqKm7AFhJNDqb1/vKxDMyRhgcH13yziLYhK
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Remove the "ret" local variable from ufs_mtk_link_startup_notify, as
it's pointless; in all cases it is assigned, it is returned right after
without being read first.

Rework the code to just return directly, and get rid of the default
branch while at it.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 412ff74a4aaa..a94601d24a87 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1592,21 +1592,15 @@ static void ufs_mtk_post_link(struct ufs_hba *hba)
 static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
 				       enum ufs_notify_change_status stage)
 {
-	int ret = 0;
-
 	switch (stage) {
 	case PRE_CHANGE:
-		ret = ufs_mtk_pre_link(hba);
-		break;
+		return ufs_mtk_pre_link(hba);
 	case POST_CHANGE:
 		ufs_mtk_post_link(hba);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
+		return 0;
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int ufs_mtk_device_reset(struct ufs_hba *hba)

-- 
2.56.1

