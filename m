Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623A63CAA41;
	Mon, 31 Aug 2026 09:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169767; cv=none; b=Ym5FaTnVOu3/Jah0N5nQjX0teFZ2CrdIT0bk0HrGF7YwwWI1ipdFm01wxZY1/8dSUk8O79OEXWXJYZ7gFt+nVtUiOhvpWo7tcFtklXQAUn4FSXRPejFnZDa+WI+Sx3nswxOMFXjYs62HbnqFTWVOJ9Tp6ce+IIZoI346LRbhjFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169767; c=relaxed/simple;
	bh=BPSBHVHwtg6F6NTQNRQrL+63+1rXBP6TQlmVbo/fiMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tnzyJx1LYY4Z533lzKhaQNvQVWA8uWUoHnqLDzHRwAoLJyEX11mBmrKqOaJDfncHyjQZGETIeF+MQd0HWid1F4uTCABWRwM0/CLNQx97kLKtY1ykOcjT8+XxX0+m/txKZ6SGZZha0sat1Bjf4Gpd+eSgxhJYthyC74EeM80DC2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC761F000E9;
	Mon, 31 Aug 2026 09:49:23 +0000 (UTC)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi: zorro7xx: Use individual zorro_driver_data structures
Date: Mon, 31 Aug 2026 11:49:20 +0200
Message-ID: <7deafe83754415c5beb280f3c1808e153029e890.1788169600.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using an array of zorro_driver_data objects and referring to its
elements by index obfuscates the code and is error-prone.

Improve readability and reduce code size by replacing the array (which
includes an unneeded sentinel) by individual zorro_driver_data objects.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested + assembler output inspected.
---
 drivers/scsi/zorro7xx.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 21c769dc1ecbda49..89475632675c0fb1 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -35,38 +35,45 @@ static struct scsi_host_template zorro7xx_scsi_driver_template = {
 	.module		= THIS_MODULE,
 };
 
-static struct zorro_driver_data {
+struct zorro_driver_data {
 	const char *name;
 	unsigned long offset;
 	int absolute;	/* offset is absolute address */
-} zorro7xx_driver_data[] = {
-	{ .name = "PowerUP 603e+", .offset = 0xf40000, .absolute = 1 },
-	{ .name = "WarpEngine 40xx", .offset = 0x40000 },
-	{ .name = "A4091", .offset = 0x800000 },
-	{ .name = "GForce 040/060", .offset = 0x40000 },
-	{ 0 }
+};
+
+static const struct zorro_driver_data zorro7xx_blizzard_603e_plus_data = {
+	.name = "PowerUP 603e+", .offset = 0xf40000, .absolute = 1
+};
+static const struct zorro_driver_data zorro7xx_warp_engine_40xx_data = {
+	.name = "WarpEngine 40xx", .offset = 0x40000
+};
+static const struct zorro_driver_data zorro7xx_a4091_data = {
+	.name = "A4091", .offset = 0x800000
+};
+static const struct zorro_driver_data zorro7xx_gforce_040_060_data = {
+	.name = "GForce 040/060", .offset = 0x40000
 };
 
 static struct zorro_device_id zorro7xx_zorro_tbl[] = {
 	{
 		.id = ZORRO_PROD_PHASE5_BLIZZARD_603E_PLUS,
-		.driver_data_ptr = &zorro7xx_driver_data[0],
+		.driver_data_ptr = &zorro7xx_blizzard_603e_plus_data,
 	},
 	{
 		.id = ZORRO_PROD_MACROSYSTEMS_WARP_ENGINE_40xx,
-		.driver_data_ptr = &zorro7xx_driver_data[1],
+		.driver_data_ptr = &zorro7xx_warp_engine_40xx_data,
 	},
 	{
 		.id = ZORRO_PROD_CBM_A4091_1,
-		.driver_data_ptr = &zorro7xx_driver_data[2],
+		.driver_data_ptr = &zorro7xx_a4091_data,
 	},
 	{
 		.id = ZORRO_PROD_CBM_A4091_2,
-		.driver_data_ptr = &zorro7xx_driver_data[2],
+		.driver_data_ptr = &zorro7xx_a4091_data,
 	},
 	{
 		.id = ZORRO_PROD_GVP_GFORCE_040_060,
-		.driver_data_ptr = &zorro7xx_driver_data[3],
+		.driver_data_ptr = &zorro7xx_gforce_040_060_data,
 	},
 	{ }
 };
-- 
2.43.0

