From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 07/14] libsas: async ata-eh
Date: Thu, 05 Jan 2012 16:59:36 -0800
Message-ID: <20120106005936.11464.35825.stgit@localhost6.localdomain6>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Once sas_ata_hard_reset() starts honoring the 'deadline' parameter a
pathological configuration could take 25 seconds per ata device
(serialized) to recover.  Run per-port recoveries in parallel.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 39ce224..537e8da 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -23,6 +23,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/async.h>
 
 #include <scsi/sas_ata.h>
 #include "sas_internal.h"
@@ -605,10 +606,21 @@ int sas_discover_sata(struct domain_device *dev)
 	return 0;
 }
 
+static void async_sas_ata_eh(void *data, async_cookie_t cookie)
+{
+	struct domain_device *dev = data;
+	struct ata_port *ap = dev->sata_dev.ap;
+	struct sas_ha_struct *ha = dev->port->ha;
+
+	ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error handler");
+	ata_scsi_port_error_handler(ha->core.shost, ap);
+}
+
 void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+	LIST_HEAD(async);
 
 	/* it's ok to defer revalidation events during ata eh, these
 	 * disks are in one of three states:
@@ -622,14 +634,13 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 
 	shost_for_each_device(sdev, shost) {
 		struct domain_device *ddev = sdev_to_domain_dev(sdev);
-		struct ata_port *ap = ddev->sata_dev.ap;
 
 		if (!dev_is_sata(ddev))
 			continue;
 
-		ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error handler");
-		ata_scsi_port_error_handler(shost, ap);
+		async_schedule_domain(async_sas_ata_eh, ddev, &async);
 	}
+	async_synchronize_full_domain(&async);
 
 	sas_enable_revalidation(sas_ha);
 }

