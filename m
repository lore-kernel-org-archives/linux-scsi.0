Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100804;
	b=lc0sk9mK/6IOPf5aU0qUQAMG7zRScUIhkU7pnc4/5paMLhGSzNSwE732UmY8M6WfQRAU
	 FzLXLKNyoLfLf/XzmdTkiSD8c1sQ32aDfBTaRBHYZw//h992hw1aGblnFf1CmZ1yEDKBG
	 57qEoHUIB1zDXAfxpfZfB21HBWDMZ4urPsFfRUAYcFwwdyU5J8O93nBELtRLhdM+B2rY8
	 U9aJTF/OtXjzcAvk//HnQrFPScEZFM5E6pQshCbhpgmCO54fh15kr5Seq7+5GC6H6ko4M
	 r0wLrqBiWmRvWCuF4jkj4S9e/AQOKkqux9uGREGrHiZJC1xEEDTO6Z9/Kr3SQnejeog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100804;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=a07D2Y/s97JABMyDfEmBuoSqRrmLZvC7khrZ0wj/FFE=;
	b=1qqS9g5PNsDG3jI9jtQizJB5w42I/tUi7meeJld4cOepfFE/H/1FvGBOFUC6Qr6+gKhg
	 h0zVRe9LlK2dhytdLAFZOYhwZyjGf0r8wOh28czGl+ulndBn8jX360VvsDxsCcE/YmLmp
	 SO87cDom8Napva9RoxTWYw4NFQAgL/f3R2pEytqeimLgqYhzP1erUpt7C+KNCTGTJDpIp
	 kqiJ6CS+UGr6QIvbM2RSf00yRuBMjK30ducN+dQXi5OlO3kMuYPYCKFjRs2sZb8ZPrV1P
	 RHHCZTKPqI47eiK8zmWRDtBzXbCzTZ2lXWEDR5Sa3oNArjIIpp9bF9mbyXqofyEFFSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=FqUpOI8j;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBE560A263D;
	Thu, 19 Nov 2026 15:06:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EBE560A263D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=FqUpOI8j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795100802;
	bh=p8VofSyuOASY1EKk7j1Rqq0/0ineEgz4W5FAlilzr4k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FqUpOI8jRosE1FyVHRT/xYxO8ZmvAF9hx0OEF2yWvqmRkTzf1D3tWZ65pSN0CKiR5
	 n0H1hIW4SoqKu+B3b8lJzliDJgHwU6NCLYDQFvX2rMTN9r0sFCv94p6qKDScMvUdFV
	 WLFIOBSLwLAi/0Mnalg0klW3by3BIvid+wcgGqzvz7Eed6XcInrARDXtTMMdrCr0MG
	 TwhvQOrtTHbH6Zc5omCPQOw2wBlyI5mD5ZYOWTkR8IkrjFrmrbXzjLxsn3S3AnmrAe
	 XgR0+HhB8l5TIKzyCiZUeYlmLzqTGti8ttOFk1aTijpu4tPG3P006DtBuQYwMoLW3d
	 DDTFWlOfIgDjg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EF4B217E0A27;
	Thu, 19 Nov 2026 16:06:40 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 19 Nov 2026 16:06:09 +0100
Subject: [PATCH v15 21/23] scsi: ufs: mediatek: Remove ret local from
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
Message-Id: <20261119-mt8196-ufs-v15-21-aae1eb0382e8@collabora.com>
References: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
In-Reply-To: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795100772; l=1411;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=rhCj2lBaeMPQekS8CHyDqLmwobBHm1t3s6/jTNNmU4M=;
 b=YMP7nGnnLEq4xk2Q3MQ2hH8kj5vdXm4I6MTQsl/WVRCQgMjj9sAMemyZ19qCYVtVytyPQtN9l
 UbcjN8Wg3/bA22+M4nCO4qEIKrbSGpB8vo2tMzhRmLgVsDrott6xI5Y
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
index b1167f7831a7..da5383387c8f 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1581,21 +1581,15 @@ static void ufs_mtk_post_link(struct ufs_hba *hba)
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

