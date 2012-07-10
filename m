From: Dan Williams <dan.j.williams@intel.com>
Subject: [resend PATCH 5/5] libsas,
 ipr: cleanup ata_host flags initialization via ata_host_init
Date: Mon, 09 Jul 2012 21:06:08 -0700
Message-ID: <20120710040608.26529.20117.stgit@dwillia2-linux.jf.intel.com>
References: <20120710040434.26529.86552.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120710040434.26529.86552.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com, JBottomley@parallels.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

libsas and ipr pass flags to ata_host_init that are meant for the port.

ata_host flags:
	ATA_HOST_SIMPLEX	= (1 << 0),	/* Host is simplex, one DMA channel per host only */
	ATA_HOST_STARTED	= (1 << 1),	/* Host started */
	ATA_HOST_PARALLEL_SCAN	= (1 << 2),	/* Ports on this host can be scanned in parallel */
	ATA_HOST_IGNORE_ATA	= (1 << 3),	/* Ignore ATA devices on this host. */

flags passed by libsas:
	ATA_FLAG_SATA		= (1 << 1),
	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */

The only one that aliases is ATA_HOST_STARTED which is a 'don't care' in
the libsas and ipr cases since ata_hosts from these sources are not
registered with libata.

Cc: Brian King <brking@us.ibm.com>
Reported-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c     |   10 ++--------
 drivers/scsi/ipr.c            |    3 +--
 drivers/scsi/libsas/sas_ata.c |    5 +----
 include/linux/libata.h        |    3 +--
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index da31691..6aa72b8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5958,24 +5958,18 @@ int ata_host_start(struct ata_host *host)
 }
 
 /**
- *	ata_sas_host_init - Initialize a host struct
+ *	ata_sas_host_init - Initialize a host struct for sas (ipr, libsas)
  *	@host:	host to initialize
  *	@dev:	device host is attached to
- *	@flags:	host flags
  *	@ops:	port_ops
  *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
  */
-/* KILLME - the only user left is ipr */
 void ata_host_init(struct ata_host *host, struct device *dev,
-		   unsigned long flags, struct ata_port_operations *ops)
+		   struct ata_port_operations *ops)
 {
 	spin_lock_init(&host->lock);
 	mutex_init(&host->eh_mutex);
 	host->dev = dev;
-	host->flags = flags;
 	host->ops = ops;
 }
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 467dc38..dacc784 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8775,8 +8775,7 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
 
 	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
 	memset(ioa_cfg, 0, sizeof(struct ipr_ioa_cfg));
-	ata_host_init(&ioa_cfg->ata_host, &pdev->dev,
-		      sata_port_info.flags, &ipr_sata_ops);
+	ata_host_init(&ioa_cfg->ata_host, &pdev->dev, &ipr_sata_ops);
 
 	ioa_cfg->ipr_chip = ipr_get_chip_info(dev_id);
 
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 4208e16..5d10e4d 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -580,10 +580,7 @@ int sas_ata_init(struct domain_device *found_dev)
 	struct ata_port *ap;
 	int rc;
 
-	ata_host_init(&found_dev->sata_dev.ata_host,
-		      ha->dev,
-		      sata_port_info.flags,
-		      &sas_sata_ops);
+	ata_host_init(&found_dev->sata_dev.ata_host, ha->dev, &sas_sata_ops);
 	ap = ata_sas_port_alloc(&found_dev->sata_dev.ata_host,
 				&sata_port_info,
 				shost);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index af467d3..baf9f82 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -990,8 +990,7 @@ extern int ata_host_activate(struct ata_host *host, int irq,
 			     irq_handler_t irq_handler, unsigned long irq_flags,
 			     struct scsi_host_template *sht);
 extern void ata_host_detach(struct ata_host *host);
-extern void ata_host_init(struct ata_host *, struct device *,
-			  unsigned long, struct ata_port_operations *);
+extern void ata_host_init(struct ata_host *, struct device *, struct ata_port_operations *);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd);

