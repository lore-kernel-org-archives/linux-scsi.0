From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aic7xxx: Fix unintended sign extension issue
Date: Thu, 25 Oct 2018 16:13:34 +0100
Message-ID: <20181025151334.15622-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the expression "ahc_inb(ahc, port+3) << 24", the initial value is a
u8, but is promoted to a signed int, then sign-extended to uint64_t.  If
the value read from the port has the upper bit set then the sign
extension will set all the upper bits of the expression which is probably
not what was intended.  Cast to uint64_t to avoid the sign extension.

Detected by CoverityScan, CID#138806, 138807 ("Unintended sign extension")

Fixes: be0d67680d52 ("[SCSI] aic7xxx, aic79xx: deinline functions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 9ee75c9a9aa1..a836233edb91 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -622,7 +622,7 @@ ahd_inq(struct ahd_softc *ahd, u_int port)
 	return ((ahd_inb(ahd, port))
 	      | (ahd_inb(ahd, port+1) << 8)
 	      | (ahd_inb(ahd, port+2) << 16)
-	      | (ahd_inb(ahd, port+3) << 24)
+	      | (((uint64_t)ahd_inb(ahd, port+3)) << 24)
 	      | (((uint64_t)ahd_inb(ahd, port+4)) << 32)
 	      | (((uint64_t)ahd_inb(ahd, port+5)) << 40)
 	      | (((uint64_t)ahd_inb(ahd, port+6)) << 48)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index f3362f4ab16e..74d3f1dd0427 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -493,7 +493,7 @@ ahc_inq(struct ahc_softc *ahc, u_int port)
 	return ((ahc_inb(ahc, port))
 	      | (ahc_inb(ahc, port+1) << 8)
 	      | (ahc_inb(ahc, port+2) << 16)
-	      | (ahc_inb(ahc, port+3) << 24)
+	      | (((uint64_t)ahc_inb(ahc, port+3)) << 24)
 	      | (((uint64_t)ahc_inb(ahc, port+4)) << 32)
 	      | (((uint64_t)ahc_inb(ahc, port+5)) << 40)
 	      | (((uint64_t)ahc_inb(ahc, port+6)) << 48)
-- 
2.19.1
