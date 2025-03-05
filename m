Received: from gauss.telenet-ops.be (gauss.telenet-ops.be [195.130.132.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE34248884
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741181674; cv=none; b=ugbALocdfYtGBvp0Qi6L/OnmXBsoZajxhWyD2ocuotZFDEor2Mcs0iPzGQsvyqdYhbDZ9PDg+axzWwDyWWYPmPdUjx6W74MvDwvPYGZ4DRtr0fXBQkagED7qkUSkwikCJhDUe17w5z6qqwe0RsB+KlvCm+Y3IpNlqCAkt5UKZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741181674; c=relaxed/simple;
	bh=EFn8x84y+ssiUEmY8pmGqS6SBB2MjzD1MWR5Rd4bSQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiHZxNWcwJeZ8sZLJuy1dCNfg1KZr7sca9uehnNV0yXD3Ja0dMQtPR80jJxBsxNL0If/TG5HXVH/8aSnsuUitkP/HFQa1Z0xOMLs1mAw+TxejcTfO2w+WZYytJoPC61r3hT7KHL5fkAxg8ycDJ1YN78nrkTpzKIJ8hzj5Zzjk2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
	by gauss.telenet-ops.be (Postfix) with ESMTPS id 4Z7D6t3vVLz4x6ct
	for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2025 14:34:30 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:fba:8cad:3d23:9db3])
	by xavier.telenet-ops.be with cmsmtp
	id M1aJ2E00J0exi8p011aJln; Wed, 05 Mar 2025 14:34:22 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tposn-0000000Cv42-1LkA;
	Wed, 05 Mar 2025 14:34:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tpot8-00000008woZ-1nvb;
	Wed, 05 Mar 2025 14:34:18 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 4/7] scsi: ufs: renesas: Remove register control helper function
Date: Wed,  5 Mar 2025 14:34:12 +0100
Message-ID: <69500e4c18be1ca1de360f9e797e282ffef04004.1741179611.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1741179611.git.geert+renesas@glider.be>
References: <cover.1741179611.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

After refactoring the code, ufs_renesas_reg_control() is no longer
needed, because all operations are simple and can be called directly.
Remove the ufs_renesas_reg_control() helper function, and call udelay()
directly.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v3:
  - No changes,

v2:
  - Remove not just MODE_WAIT, but all of the struct-based control.
---
 drivers/ufs/host/ufs-renesas.c | 102 +++++----------------------------
 1 file changed, 14 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesas.c
index 100186a2e1807445..59e35ec4955f19af 100644
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -23,106 +23,32 @@ struct ufs_renesas_priv {
 	bool initialized;	/* The hardware needs initialization once */
 };
 
-enum ufs_renesas_init_param_mode {
-	MODE_POLL,
-	MODE_READ,
-	MODE_WAIT,
-	MODE_WRITE,
-};
-
-struct ufs_renesas_init_param {
-	enum ufs_renesas_init_param_mode mode;
-	u32 reg;
-	union {
-		u32 expected;
-		u32 delay_us;
-		u32 val;
-	} u;
-	u32 mask;
-	u32 index;
-};
-
 static void ufs_renesas_dbg_register_dump(struct ufs_hba *hba)
 {
 	ufshcd_dump_regs(hba, 0xc0, 0x40, "regs: 0xc0 + ");
 }
 
-static u32 ufs_renesas_reg_control(struct ufs_hba *hba,
-				   const struct ufs_renesas_init_param *p)
-{
-	u32 val = 0;
-	int ret;
-
-	switch (p->mode) {
-	case MODE_POLL:
-		ret = readl_poll_timeout_atomic(hba->mmio_base + p->reg,
-						val,
-						(val & p->mask) == p->u.expected,
-						10, 1000);
-		if (ret)
-			dev_err(hba->dev, "%s: poll failed %d (%08x, %08x, %08x)\n",
-				__func__, ret, val, p->mask, p->u.expected);
-		break;
-	case MODE_READ:
-		val = ufshcd_readl(hba, p->reg);
-		break;
-	case MODE_WAIT:
-		if (p->u.delay_us > 1000)
-			mdelay(DIV_ROUND_UP(p->u.delay_us, 1000));
-		else
-			udelay(p->u.delay_us);
-		break;
-	case MODE_WRITE:
-		ufshcd_writel(hba, p->u.val, p->reg);
-		break;
-	default:
-		break;
-	}
-
-	return val;
-}
-
 static void ufs_renesas_poll(struct ufs_hba *hba, u32 reg, u32 expected, u32 mask)
 {
-	struct ufs_renesas_init_param param = {
-		.mode = MODE_POLL,
-		.reg = reg,
-		.u.expected = expected,
-		.mask = mask,
-	};
-
-	ufs_renesas_reg_control(hba, &param);
+	int ret;
+	u32 val;
+
+	ret = readl_poll_timeout_atomic(hba->mmio_base + reg,
+					val, (val & mask) == expected,
+					10, 1000);
+	if (ret)
+		dev_err(hba->dev, "%s: poll failed %d (%08x, %08x, %08x)\n",
+			__func__, ret, val, mask, expected);
 }
 
 static u32 ufs_renesas_read(struct ufs_hba *hba, u32 reg)
 {
-	struct ufs_renesas_init_param param = {
-		.mode = MODE_READ,
-		.reg = reg,
-	};
-
-	return ufs_renesas_reg_control(hba, &param);
-}
-
-static void ufs_renesas_wait(struct ufs_hba *hba, u32 delay_us)
-{
-	struct ufs_renesas_init_param param = {
-		.mode = MODE_WAIT,
-		.u.delay_us = delay_us,
-	};
-
-	ufs_renesas_reg_control(hba, &param);
+	return ufshcd_readl(hba, reg);
 }
 
 static void ufs_renesas_write(struct ufs_hba *hba, u32 reg, u32 value)
 {
-	struct ufs_renesas_init_param param = {
-		.mode = MODE_WRITE,
-		.reg = reg,
-		.u.val = value,
-	};
-
-	ufs_renesas_reg_control(hba, &param);
+	ufshcd_writel(hba, value, reg);
 }
 
 static void ufs_renesas_write_d0_d4(struct ufs_hba *hba, u32 data_d0, u32 data_d4)
@@ -216,13 +142,13 @@ static void ufs_renesas_pre_init(struct ufs_hba *hba)
 	/* This setting is for SERIES B */
 	ufs_renesas_write(hba, 0xc0, 0x49425308);
 	ufs_renesas_write_d0_d4(hba, 0x00000104, 0x00000002);
-	ufs_renesas_wait(hba, 1);
+	udelay(1);
 	ufs_renesas_write_d0_d4(hba, 0x00000828, 0x00000200);
-	ufs_renesas_wait(hba, 1);
+	udelay(1);
 	ufs_renesas_write_d0_d4(hba, 0x00000828, 0x00000000);
 	ufs_renesas_write_d0_d4(hba, 0x00000104, 0x00000001);
 	ufs_renesas_write_d0_d4(hba, 0x00000940, 0x00000001);
-	ufs_renesas_wait(hba, 1);
+	udelay(1);
 	ufs_renesas_write_d0_d4(hba, 0x00000940, 0x00000000);
 
 	ufs_renesas_write(hba, 0xc0, 0x49425308);
-- 
2.43.0

