From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 1/3] libata: plumb sas port scan into standard libata paths
Date: Sun, 23 Jan 2011 08:28:33 -0600
Message-ID: <1295792913.3007.14.camel@mulgrave.site>
References: <1295792806.3007.12.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1295792806.3007.12.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The function ata_sas_port_init() has always really done its own thing.
However, as a precursor to moving to the libata new eh, it has to be
properly using the standard libata scan paths.  This means separating
the current libata scan paths into pieces which can be shared with
libsas and pieces which cant (really just the async call and the host
scan).

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/ata/libata-core.c |   46 +++++++++++++++++++++-----------------------
 drivers/ata/libata-scsi.c |    2 +-
 drivers/ata/libata.h      |    1 +
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a31fe96..99df83c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5886,21 +5886,9 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 	host->ops = ops;
 }
 
-
-static void async_port_probe(void *data, async_cookie_t cookie)
+int ata_port_probe(struct ata_port *ap)
 {
-	int rc;
-	struct ata_port *ap = data;
-
-	/*
-	 * If we're not allowed to scan this host in parallel,
-	 * we need to wait until all previous scans have completed
-	 * before going further.
-	 * Jeff Garzik says this is only within a controller, so we
-	 * don't need to wait for port 0, only for later ports.
-	 */
-	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
-		async_synchronize_cookie(cookie);
+	int rc = 0;
 
 	/* probe */
 	if (ap->ops->error_handler) {
@@ -5926,23 +5914,33 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 		DPRINTK("ata%u: bus probe begin\n", ap->print_id);
 		rc = ata_bus_probe(ap);
 		DPRINTK("ata%u: bus probe end\n", ap->print_id);
-
-		if (rc) {
-			/* FIXME: do something useful here?
-			 * Current libata behavior will
-			 * tear down everything when
-			 * the module is removed
-			 * or the h/w is unplugged.
-			 */
-		}
 	}
+	return rc;
+}
+
+
+static void async_port_probe(void *data, async_cookie_t cookie)
+{
+	struct ata_port *ap = data;
+	
+	/*
+	 * If we're not allowed to scan this host in parallel,
+	 * we need to wait until all previous scans have completed
+	 * before going further.
+	 * Jeff Garzik says this is only within a controller, so we
+	 * don't need to wait for port 0, only for later ports.
+	 */
+	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
+		async_synchronize_cookie(cookie);
+
+	(void)ata_port_probe(ap);
 
 	/* in order to keep device order, we need to synchronize at this point */
 	async_synchronize_cookie(cookie);
 
 	ata_scsi_scan_host(ap, 1);
-
 }
+
 /**
  *	ata_host_register - register initialized ATA host
  *	@host: ATA host to register
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5defc74..8970667 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3809,7 +3809,7 @@ int ata_sas_port_init(struct ata_port *ap)
 
 	if (!rc) {
 		ap->print_id = ata_print_id++;
-		rc = ata_bus_probe(ap);
+		rc = ata_port_probe(ap);
 	}
 
 	return rc;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index a9be110..773de97 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -103,6 +103,7 @@ extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern const char *sata_spd_string(unsigned int spd);
+extern int ata_port_probe(struct ata_port *ap);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
-- 
1.7.2.3



