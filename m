From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 3/6] fastboot: make the libata port scan asynchronous
Date: Mon, 5 Jan 2009 20:12:04 -0800
Message-ID: <20090105201204.2c0bf9af@infradead.org>
References: <20090105200959.04a626ac@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090105200959.04a626ac@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>From 3637ab5b7e9fa4dd3e831f76979fb67314d058e2 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 4 Jan 2009 05:32:28 -0800
Subject: [PATCH] fastboot: make the libata port scan asynchronous

This patch makes the libata port scanning asynchronous (per device).
There is a synchronization point before doing the actual disk scan
so that device ordering is not affected.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/ata/libata-core.c |   84 ++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 38 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fecca42..fe2c208 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -56,6 +56,7 @@
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
 #include <linux/io.h>
+#include <linux/async.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -5909,6 +5910,48 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 	host->ops = ops;
 }
 
+
+void async_port_probe(void *data, async_cookie_t cookie)
+{
+	int rc;
+	struct ata_port *ap = data;
+	/* probe */
+	if (ap->ops->error_handler) {
+		struct ata_eh_info *ehi = &ap->link.eh_info;
+		unsigned long flags;
+
+		ata_port_probe(ap);
+
+		/* kick EH for boot probing */
+		spin_lock_irqsave(ap->lock, flags);
+
+		ehi->probe_mask |= ATA_ALL_DEVICES;
+		ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
+		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+
+		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
+		ap->pflags |= ATA_PFLAG_LOADING;
+		ata_port_schedule_eh(ap);
+
+		spin_unlock_irqrestore(ap->lock, flags);
+
+		/* wait for EH to finish */
+		ata_port_wait_eh(ap);
+	} else {
+		DPRINTK("ata%u: bus probe begin\n", ap->print_id);
+		rc = ata_bus_probe(ap);
+		DPRINTK("ata%u: bus probe end\n", ap->print_id);
+
+		if (rc) {
+			/* FIXME: do something useful here?
+			 * Current libata behavior will
+			 * tear down everything when
+			 * the module is removed
+			 * or the h/w is unplugged.
+			 */
+		}
+	}
+}
 /**
  *	ata_host_register - register initialized ATA host
  *	@host: ATA host to register
@@ -5988,45 +6031,9 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	DPRINTK("probe begin\n");
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
-
-		/* probe */
-		if (ap->ops->error_handler) {
-			struct ata_eh_info *ehi = &ap->link.eh_info;
-			unsigned long flags;
-
-			ata_port_probe(ap);
-
-			/* kick EH for boot probing */
-			spin_lock_irqsave(ap->lock, flags);
-
-			ehi->probe_mask |= ATA_ALL_DEVICES;
-			ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
-			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
-
-			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
-			ap->pflags |= ATA_PFLAG_LOADING;
-			ata_port_schedule_eh(ap);
-
-			spin_unlock_irqrestore(ap->lock, flags);
-
-			/* wait for EH to finish */
-			ata_port_wait_eh(ap);
-		} else {
-			DPRINTK("ata%u: bus probe begin\n", ap->print_id);
-			rc = ata_bus_probe(ap);
-			DPRINTK("ata%u: bus probe end\n", ap->print_id);
-
-			if (rc) {
-				/* FIXME: do something useful here?
-				 * Current libata behavior will
-				 * tear down everything when
-				 * the module is removed
-				 * or the h/w is unplugged.
-				 */
-			}
-		}
+		async_schedule(async_port_probe, ap);
 	}
-
+	async_synchronize_full();
 	/* probes are done, now scan each port's disk(s) */
 	DPRINTK("host probe begin\n");
 	for (i = 0; i < host->n_ports; i++) {
@@ -6034,6 +6041,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 		ata_scsi_scan_host(ap, 1);
 	}
+	DPRINTK("host probe end\n");
 
 	return 0;
 }
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
