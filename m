From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 12/18] libata: make ata_print_id atomic
Date: Sat, 10 Mar 2012 23:28:46 -0800
Message-ID: <20120311072845.6320.68461.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

This variable is incremented from multiple contexts (module_init via
libata-lldds and the libsas discovery thread).  Make it atomic to head
off any chance of libsas and libata creating duplicate ids.

Acked-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c |    4 ++--
 drivers/ata/libata-scsi.c |    4 ++--
 drivers/ata/libata.h      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ea8444e..bd79c8b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -97,7 +97,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
-unsigned int ata_print_id = 1;
+atomic_t ata_print_id = ATOMIC_INIT(1);
 
 struct ata_force_param {
 	const char	*name;
@@ -6031,7 +6031,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++)
-		host->ports[i]->print_id = ata_print_id++;
+		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
 
 
 	/* Create associated sysfs transport objects  */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1ee00c8..93dabdc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3843,7 +3843,7 @@ int ata_sas_async_port_init(struct ata_port *ap)
 	int rc = ap->ops->port_start(ap);
 
 	if (!rc) {
-		ap->print_id = ata_print_id++;
+		ap->print_id = atomic_inc_return(&ata_print_id);
 		__ata_port_probe(ap);
 	}
 
@@ -3867,7 +3867,7 @@ int ata_sas_port_init(struct ata_port *ap)
 	int rc = ap->ops->port_start(ap);
 
 	if (!rc) {
-		ap->print_id = ata_print_id++;
+		ap->print_id = atomic_inc_return(&ata_print_id);
 		rc = ata_port_probe(ap);
 	}
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2e26fca..9d0fd0b 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -53,7 +53,7 @@ enum {
 	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
-extern unsigned int ata_print_id;
+extern atomic_t ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;

