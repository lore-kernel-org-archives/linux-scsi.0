From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v1 1/2] ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI SATA controller driver.
Date: Wed, 17 Dec 2014 22:57:56 +0530
Message-ID: <1418837277-23260-2-git-send-email-stripathi@apm.com>
References: <1418837277-23260-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1418837277-23260-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch fixes the big endian mode issue with function
xgene_ahci_read_id.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 0f8538f..0ffd3c9 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -188,7 +188,7 @@ static unsigned int xgene_ahci_read_id(struct ata_device *dev,
 	 *
 	 * Clear reserved bit 8 (DEVSLP bit) as we don't support DEVSLP
 	 */
-	id[ATA_ID_FEATURE_SUPP] &= ~(1 << 8);
+	id[ATA_ID_FEATURE_SUPP] &= cpu_to_le16(~(1 << 8));

 	return 0;
 }
--
1.8.2.1

