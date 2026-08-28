Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5987138E5F9;
	Fri, 28 Aug 2026 09:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909002; cv=none; b=f7i26fc2CN43sHeFsNg3FoSk1/eydmyL0zK2bJrxUeRQKBNeaxddto4PzVMtQZ/1hYn8dxydIZqe8Nk4OYp+XhoU0lusGqB09I5dHf3eLgnPXgNlv6J4GVCQCLVTD8tjwAxgUj+TRvqKofzgjxSC/KubQvHRo5Q4XgVyHQP04GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909002; c=relaxed/simple;
	bh=lck/uXkDIS5zoO1M6uHWkF8x8sVfkxe/XW0JA9yXW7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tw7KGOMVQmY19Rz0CiMt/h2c+epdxCnRBi8dibSgDCsOjz9gkmubeGGp9+9ovbohY52q+kux0yr4T+yKxoNIYmfOSKLuEd93qFUMOONLVWH9vQfVDQhxDdni08ew1sdqtj4UrJNb8em+iUEGfeCtdJFcTuGFNje2DzNJCJziR4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowAC3wT+BU5Fqb1d1Bg--.60494S2;
	Fri, 28 Aug 2026 17:23:13 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] scsi: ufs: mediatek: Handle mPHY power-on failures
Date: Fri, 28 Aug 2026 17:23:11 +0800
Message-ID: <20260828092311.10774-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAC3wT+BU5Fqb1d1Bg--.60494S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr45WF1rGr1kGw4xtF1fZwb_yoW5JF1Dpa
	ykKrWqyr1kWayI9F42gF4293WFg3yrGrW8Gr13Cw1I93ZxKrZFqFykKa4xWF1ftryrAa47
	tF4xta47GanI9wUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr
	1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUDOz3UUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

ufs_mtk_mphy_power_on() enables the optional VA09 supply before powering
on the mPHY.  The PHY result is ignored, so a failure leaves VA09
enabled and records mphy_powered_on as true, suppressing later retries.
The initialization path also ignores the helper result and continues
setting up the host.

Check phy_power_on(), turn VA09 back off on failure, and leave the state
flag unchanged.  Propagate the helper error from initialization as well
as the existing resume caller.  Keep regulator and mPHY diagnostics on
separate paths so regulator errors are not mislabeled.

The issue was identified via static analysis and manually reviewed.

Fixes: 561e3a8726b2 ("scsi: ufs-mediatek: Fix unbalanced clock on/off")
Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")

Assisted-by: LLM
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/ufs/host/ufs-mediatek.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 814c1b7343b9..9d481147ea38 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -509,6 +509,7 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct phy *mphy = host->mphy;
 	struct arm_smccc_res res;
+	int rollback_ret;
 	int ret = 0;
 
 	if (!mphy || !(on ^ host->mphy_powered_on))
@@ -523,7 +524,18 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 			usleep_range(200, 210);
 			ufs_mtk_va09_pwr_ctrl(res, 1);
 		}
-		phy_power_on(mphy);
+		ret = phy_power_on(mphy);
+		if (ret) {
+			if (ufs_mtk_is_va09_supported(hba)) {
+				ufs_mtk_va09_pwr_ctrl(res, 0);
+				rollback_ret = regulator_disable(host->reg_va09);
+				if (rollback_ret)
+					dev_warn(hba->dev, "failed to disable va09 after mphy failure: %d\n",
+						 rollback_ret);
+			}
+			dev_info(hba->dev, "failed to enable mphy: %d\n", ret);
+			return ret;
+		}
 	} else {
 		phy_power_off(mphy);
 		if (ufs_mtk_is_va09_supported(hba)) {
@@ -1295,7 +1307,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	 *
 	 * Enable phy clocks specifically here.
 	 */
-	ufs_mtk_mphy_power_on(hba, true);
+	err = ufs_mtk_mphy_power_on(hba, true);
+	if (err)
+		goto out_variant_clear;
 
 	if (ufs_mtk_is_rtff_mtcmos(hba)) {
 		/* First Restore here, to avoid backup unexpected value */
-- 
2.43.0

