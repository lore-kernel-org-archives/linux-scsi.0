From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi/mac_esp: Replace bogus memory barrier with spinlock
Date: Sun, 02 Apr 2017 17:08:05 +1000
Message-ID: <1ecb1ec37388c616335dba37b42b4a7676df6c1e.1491115954.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit da244654c66e ("[SCSI] mac_esp: fix for quadras with two esp chips")
added mac_scsi_esp_intr() to handle the IRQ lines from a pair of on-board
ESP chips (a normal shared IRQ did not work).

Proper mutual exclusion was missing from that patch. This patch fixes
race conditions between comparison and assignment of esp_chips[]
pointers.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_esp.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 14c0334..586efd1 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -55,6 +55,7 @@ struct mac_esp_priv {
 	int error;
 };
 static struct esp *esp_chips[2];
+static DEFINE_SPINLOCK(esp_chips_lock);
 
 #define MAC_ESP_GET_PRIV(esp) ((struct mac_esp_priv *) \
 			       platform_get_drvdata((struct platform_device *) \
@@ -562,15 +563,18 @@ static int esp_mac_probe(struct platform_device *dev)
 	}
 
 	host->irq = IRQ_MAC_SCSI;
-	esp_chips[dev->id] = esp;
-	mb();
-	if (esp_chips[!dev->id] == NULL) {
-		err = request_irq(host->irq, mac_scsi_esp_intr, 0, "ESP", NULL);
-		if (err < 0) {
-			esp_chips[dev->id] = NULL;
-			goto fail_free_priv;
-		}
+
+	/* The request_irq() call is intended to succeed for the first device
+	 * and fail for the second device.
+	 */
+	err = request_irq(host->irq, mac_scsi_esp_intr, 0, "ESP", NULL);
+	spin_lock(&esp_chips_lock);
+	if (err < 0 && esp_chips[!dev->id] == NULL) {
+		spin_unlock(&esp_chips_lock);
+		goto fail_free_priv;
 	}
+	esp_chips[dev->id] = esp;
+	spin_unlock(&esp_chips_lock);
 
 	err = scsi_esp_register(esp, &dev->dev);
 	if (err)
@@ -579,8 +583,13 @@ static int esp_mac_probe(struct platform_device *dev)
 	return 0;
 
 fail_free_irq:
-	if (esp_chips[!dev->id] == NULL)
+	spin_lock(&esp_chips_lock);
+	esp_chips[dev->id] = NULL;
+	if (esp_chips[!dev->id] == NULL) {
+		spin_unlock(&esp_chips_lock);
 		free_irq(host->irq, esp);
+	} else
+		spin_unlock(&esp_chips_lock);
 fail_free_priv:
 	kfree(mep);
 fail_free_command_block:
@@ -599,9 +608,13 @@ static int esp_mac_remove(struct platform_device *dev)
 
 	scsi_esp_unregister(esp);
 
+	spin_lock(&esp_chips_lock);
 	esp_chips[dev->id] = NULL;
-	if (!(esp_chips[0] || esp_chips[1]))
+	if (esp_chips[!dev->id] == NULL) {
+		spin_unlock(&esp_chips_lock);
 		free_irq(irq, NULL);
+	} else
+		spin_unlock(&esp_chips_lock);
 
 	kfree(mep);
 
-- 
2.10.2
