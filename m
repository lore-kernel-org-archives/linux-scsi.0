Received: from gauss.telenet-ops.be (gauss.telenet-ops.be [195.130.132.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDBF24A051
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741181676; cv=none; b=tO2BSz3xT6EPdQldwktkDn9ey5NYDv19ghoxBFnGAgJl01/gjcOhRYHyNyK7Y03TQk8KGTbcj7SgXElxsQ0al7b+yC5DgUgUFeUWq2Lc7k9Nezdl5lHgFtE6UWjQL+HbRt08w4NCnJbVgsv7J2m6AZsEdPsa9Anhz4vszbinQf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741181676; c=relaxed/simple;
	bh=2CQfQYPB2DJ1ROQb4shpWr4KDmFhYio/1xwOBxthYMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAjnKyDNPFYUcPQ6J6qFEIK5lhqbTmkctqvkaMFJzyeMeUnbM32hc+JWxxnkLGkONXYNrOIhVKSxpxMdBBy7bHtmYNQj0I8uHNUCgGe0rQYnFgBnDypHMrIYmSpywolhdneNUZViHN1tg3vacjzUh5SN3m2Htu5kTPhng3ikrPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
	by gauss.telenet-ops.be (Postfix) with ESMTPS id 4Z7D6v3NZvz4x21w
	for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2025 14:34:31 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:fba:8cad:3d23:9db3])
	by albert.telenet-ops.be with cmsmtp
	id M1aL2E00B0exi8p061aLDJ; Wed, 05 Mar 2025 14:34:23 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tposn-0000000Cv4A-1dSZ;
	Wed, 05 Mar 2025 14:34:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tpot8-00000008woj-23Ft;
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
Subject: [PATCH v3 6/7] scsi: ufs: renesas: Add reusable functions
Date: Wed,  5 Mar 2025 14:34:14 +0100
Message-ID: <446d67b751a96645799de3aeefec539735aa78c8.1741179611.git.geert+renesas@glider.be>
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

Since some settings can be reused on other UFS controller (R-Car S4-8
ES1.2), add reusable functions.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v3:
  - Rename ufs_renesas_init_ufshc() to ufs_renesas_init_step1_to_3(),
  - Extract ufs_renesas_init_step4_to_6(),
  - Move ufs_renesas_write_phy_10ad_10af() just before its sole user,

v2:
  - No changes.
---
 drivers/ufs/host/ufs-renesas.c | 71 ++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 21 deletions(-)

diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesas.c
index e4510e9b1a2cb195..d9ba766dcd2f4de7 100644
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -135,21 +135,8 @@ static void ufs_renesas_indirect_poll(struct ufs_hba *hba, u32 gpio, u32 addr,
 	ufs_renesas_write(hba, 0xf0, 0);
 }
 
-static void ufs_renesas_write_phy_10ad_10af(struct ufs_hba *hba,
-					    u32 data_10ad, u32 data_10af)
+static void ufs_renesas_init_step1_to_3(struct ufs_hba *hba)
 {
-	ufs_renesas_write_phy(hba, 0x10ae, 0x0001);
-	ufs_renesas_write_phy(hba, 0x10ad, data_10ad);
-	ufs_renesas_write_phy(hba, 0x10af, data_10af);
-	ufs_renesas_write_phy(hba, 0x10b6, 0x0001);
-	ufs_renesas_write_phy(hba, 0x10ae, 0x0000);
-}
-
-static void ufs_renesas_pre_init(struct ufs_hba *hba)
-{
-	u32 timer_val;
-
-	/* This setting is for SERIES B */
 	ufs_renesas_write(hba, 0xc0, 0x49425308);
 	ufs_renesas_write_d0_d4(hba, 0x00000104, 0x00000002);
 	udelay(1);
@@ -163,7 +150,10 @@ static void ufs_renesas_pre_init(struct ufs_hba *hba)
 
 	ufs_renesas_write(hba, 0xc0, 0x49425308);
 	ufs_renesas_write(hba, 0xc0, 0x41584901);
+}
 
+static void ufs_renesas_init_step4_to_6(struct ufs_hba *hba)
+{
 	ufs_renesas_write_d0_d4(hba, 0x0000080c, 0x00000100);
 	ufs_renesas_write_d0_d4(hba, 0x00000804, 0x00000000);
 	ufs_renesas_write(hba, 0xd0, 0x0000080c);
@@ -173,6 +163,11 @@ static void ufs_renesas_pre_init(struct ufs_hba *hba)
 
 	ufs_renesas_write(hba, 0xd0, 0x00000804);
 	ufs_renesas_poll(hba, 0xd4, BIT(8) | BIT(6) | BIT(0), BIT(8) | BIT(6) | BIT(0));
+}
+
+static u32 ufs_renesas_init_disable_timer(struct ufs_hba *hba)
+{
+	u32 timer_val;
 
 	ufs_renesas_write(hba, 0xd0, 0x00000d00);
 	timer_val = ufs_renesas_read(hba, 0xd4) & 0x0000ffff;
@@ -184,6 +179,45 @@ static void ufs_renesas_pre_init(struct ufs_hba *hba)
 	ufs_renesas_write(hba, 0xd0, 0x00000d2c);
 	ufs_renesas_poll(hba, 0xd4, BIT(0), BIT(0));
 
+	return timer_val;
+}
+
+static void ufs_renesas_init_enable_timer(struct ufs_hba *hba, u32 timer_val)
+{
+	ufs_renesas_write(hba, 0xf0, 0);
+	ufs_renesas_write(hba, 0xd0, 0x00000d00);
+	ufs_renesas_write(hba, 0xd4, timer_val);
+}
+
+static void ufs_renesas_write_phy_10ad_10af(struct ufs_hba *hba,
+					    u32 data_10ad, u32 data_10af)
+{
+	ufs_renesas_write_phy(hba, 0x10ae, 0x0001);
+	ufs_renesas_write_phy(hba, 0x10ad, data_10ad);
+	ufs_renesas_write_phy(hba, 0x10af, data_10af);
+	ufs_renesas_write_phy(hba, 0x10b6, 0x0001);
+	ufs_renesas_write_phy(hba, 0x10ae, 0x0000);
+}
+
+static void ufs_renesas_init_compensation_and_slicers(struct ufs_hba *hba)
+{
+	ufs_renesas_write_phy_10ad_10af(hba, 0x0000, 0x0001);
+	ufs_renesas_write_phy_10ad_10af(hba, 0x0000, 0x0002);
+	ufs_renesas_write_phy_10ad_10af(hba, 0x0080, 0x0000);
+	ufs_renesas_write_phy_10ad_10af(hba, 0x0080, 0x001a);
+}
+
+static void ufs_renesas_pre_init(struct ufs_hba *hba)
+{
+	u32 timer_val;
+
+	/* This setting is for SERIES B */
+	ufs_renesas_init_step1_to_3(hba);
+
+	ufs_renesas_init_step4_to_6(hba);
+
+	timer_val = ufs_renesas_init_disable_timer(hba);
+
 	/* phy setup */
 	ufs_renesas_indirect_write(hba, 1, 0x01, 0x001f);
 	ufs_renesas_indirect_write(hba, 7, 0x5d, 0x0014);
@@ -219,10 +253,7 @@ static void ufs_renesas_pre_init(struct ufs_hba *hba)
 	ufs_renesas_write_phy(hba, 0x4000, 0x0000);
 	ufs_renesas_write_phy(hba, 0x4001, 0x0000);
 
-	ufs_renesas_write_phy_10ad_10af(hba, 0x0000, 0x0001);
-	ufs_renesas_write_phy_10ad_10af(hba, 0x0000, 0x0002);
-	ufs_renesas_write_phy_10ad_10af(hba, 0x0080, 0x0000);
-	ufs_renesas_write_phy_10ad_10af(hba, 0x0080, 0x001a);
+	ufs_renesas_init_compensation_and_slicers(hba);
 
 	ufs_renesas_indirect_write(hba, 7, 0x70, 0x0016);
 	ufs_renesas_indirect_write(hba, 7, 0x71, 0x0016);
@@ -249,9 +280,7 @@ static void ufs_renesas_pre_init(struct ufs_hba *hba)
 	ufs_renesas_indirect_poll(hba, 7, 0x41, 0, BIT(7));
 	/* end of phy setup */
 
-	ufs_renesas_write(hba, 0xf0, 0);
-	ufs_renesas_write(hba, 0xd0, 0x00000d00);
-	ufs_renesas_write(hba, 0xd4, timer_val);
+	ufs_renesas_init_enable_timer(hba, timer_val);
 }
 
 static int ufs_renesas_hce_enable_notify(struct ufs_hba *hba,
-- 
2.43.0

