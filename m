From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/7] ahci: Cache host controller version
Date: Thu, 18 Feb 2016 10:54:14 +0200
Message-ID: <1455785657-22924-5-git-send-email-mika.westerberg@linux.intel.com>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This allows sysfs nodes to read the cached value directly instead of
powering up possibly runtime suspended controller.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/ata/ahci.h    | 1 +
 drivers/ata/libahci.c | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index a44c75d4c284..8138bc967eda 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -336,6 +336,7 @@ struct ahci_host_priv {
 	void __iomem *		mmio;		/* bus-independent mem map */
 	u32			cap;		/* cap to use */
 	u32			cap2;		/* cap2 to use */
+	u32			version;	/* cached version */
 	u32			port_map;	/* port map to use */
 	u32			saved_cap;	/* saved initial cap */
 	u32			saved_cap2;	/* saved initial cap2 */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 402967902cbe..2ce4c638714e 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -250,9 +250,8 @@ static ssize_t ahci_show_host_version(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ata_port *ap = ata_shost_to_port(shost);
 	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *mmio = hpriv->mmio;
 
-	return sprintf(buf, "%x\n", readl(mmio + HOST_VERSION));
+	return sprintf(buf, "%x\n", hpriv->version);
 }
 
 static ssize_t ahci_show_port_cmd(struct device *dev,
@@ -508,6 +507,7 @@ void ahci_save_initial_config(struct device *dev, struct ahci_host_priv *hpriv)
 	/* record values to use during operation */
 	hpriv->cap = cap;
 	hpriv->cap2 = cap2;
+	hpriv->version = readl(mmio + HOST_VERSION);
 	hpriv->port_map = port_map;
 
 	if (!hpriv->start_engine)
@@ -2389,11 +2389,10 @@ static void ahci_port_stop(struct ata_port *ap)
 void ahci_print_info(struct ata_host *host, const char *scc_s)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = hpriv->mmio;
 	u32 vers, cap, cap2, impl, speed;
 	const char *speed_s;
 
-	vers = readl(mmio + HOST_VERSION);
+	vers = hpriv->version;
 	cap = hpriv->cap;
 	cap2 = hpriv->cap2;
 	impl = hpriv->port_map;
-- 
2.7.0
