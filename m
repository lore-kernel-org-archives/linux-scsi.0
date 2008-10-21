From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/22] libata-sff: ap->[last_]ctl are SFF specific
Date: Tue, 21 Oct 2008 18:17:50 +0900
Message-ID: <1224580680-13698-13-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

ap->[last_]ctl are specific to SFF controllers.  Put them inside
CONFIG_ATA_SFF and move initialization into ata_sff_port_init().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |    2 --
 drivers/ata/libata-sff.c  |    2 ++
 include/linux/libata.h    |    8 ++++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 582aeb6..3dd8512 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5273,10 +5273,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
-	ap->ctl = ATA_DEVCTL_OBS;
 	ap->host = host;
 	ap->dev = host->dev;
-	ap->last_ctl = 0xFF;
 
 #if defined(ATA_VERBOSE_DEBUG)
 	/* turn on all debugging levels */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 41affa4..9124f8d 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2826,6 +2826,8 @@ void ata_pci_bmdma_init(struct ata_host *host)
  */
 void ata_sff_port_init(struct ata_port *ap)
 {
+	ap->ctl = ATA_DEVCTL_OBS;
+	ap->last_ctl = 0xFF;
 }
 
 int __init ata_sff_init(void)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ea415aa..3125039 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -679,10 +679,10 @@ struct ata_port {
 
 #ifdef CONFIG_ATA_SFF
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
-#endif /* CONFIG_ATA_SFF */
-
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
+#endif /* CONFIG_ATA_SFF */
+
 	unsigned int		pio_mask;
 	unsigned int		mwdma_mask;
 	unsigned int		udma_mask;
@@ -1346,7 +1346,11 @@ static inline void ata_tf_init(struct ata_device *dev, struct ata_taskfile *tf)
 {
 	memset(tf, 0, sizeof(*tf));
 
+#ifdef CONFIG_ATA_SFF
 	tf->ctl = dev->link->ap->ctl;
+#else
+	tf->ctl = ATA_DEVCTL_OBS;
+#endif
 	if (dev->devno == 0)
 		tf->device = ATA_DEVICE_OBS;
 	else
-- 
1.5.4.5

