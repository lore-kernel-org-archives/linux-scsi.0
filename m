From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/4] libata: Add ata_port_init
Date: Mon, 07 Aug 2006 14:27:17 -0500
Message-ID: <200608071927.k77JRIxc020735@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:61118 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750838AbWHGT1u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 15:27:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Separate out the ata_port initialization from ata_host_init
so that it can be used in future SAS patches.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   49 ++++++++++++++++++--------
 libata-dev-bjking1/drivers/scsi/libata.h      |    2 +
 2 files changed, 36 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_port_init drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_port_init	2006-08-07 09:06:37.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-08-07 12:39:34.000000000 -0500
@@ -5240,35 +5240,25 @@ void ata_dev_init(struct ata_device *dev
 }
 
 /**
- *	ata_host_init - Initialize an ata_port structure
+ *	ata_port_init - Initialize an ata_port structure
  *	@ap: Structure to initialize
- *	@host: associated SCSI mid-layer structure
  *	@host_set: Collection of hosts to which @ap belongs
  *	@ent: Probe information provided by low-level driver
  *	@port_no: Port number associated with this ata_port
  *
- *	Initialize a new ata_port structure, and its associated
- *	scsi_host.
+ *	Initialize a new ata_port structure.
  *
  *	LOCKING:
  *	Inherited from caller.
  */
-static void ata_host_init(struct ata_port *ap, struct Scsi_Host *host,
-			  struct ata_host_set *host_set,
-			  const struct ata_probe_ent *ent, unsigned int port_no)
+void ata_port_init(struct ata_port *ap, struct ata_host_set *host_set,
+		   const struct ata_probe_ent *ent, unsigned int port_no)
 {
 	unsigned int i;
 
-	host->max_id = 16;
-	host->max_lun = 1;
-	host->max_channel = 1;
-	host->unique_id = ata_unique_id++;
-	host->max_cmd_len = 12;
-
 	ap->lock = &host_set->lock;
 	ap->flags = ATA_FLAG_DISABLED;
-	ap->id = host->unique_id;
-	ap->host = host;
+	ap->id = ata_unique_id++;
 	ap->ctl = ATA_DEVCTL_OBS;
 	ap->host_set = host_set;
 	ap->dev = ent->dev;
@@ -5320,6 +5310,35 @@ static void ata_host_init(struct ata_por
 }
 
 /**
+ *	ata_host_init - Initialize an ata_port structure
+ *	@ap: Structure to initialize
+ *	@host: associated SCSI mid-layer structure
+ *	@host_set: Collection of hosts to which @ap belongs
+ *	@ent: Probe information provided by low-level driver
+ *	@port_no: Port number associated with this ata_port
+ *
+ *	Initialize a new ata_port structure, and its associated
+ *	scsi_host.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+static void ata_host_init(struct ata_port *ap, struct Scsi_Host *host,
+			  struct ata_host_set *host_set,
+			  const struct ata_probe_ent *ent, unsigned int port_no)
+{
+	ata_port_init(ap, host_set, ent, port_no);
+	ap->host = host;
+
+	host->unique_id = ap->id;
+	host->max_id = 16;
+	host->max_lun = 1;
+	host->max_channel = 1;
+	host->max_cmd_len = 12;
+}
+
+/**
  *	ata_host_add - Attach low-level ATA driver to system
  *	@ent: Information provided by low-level driver
  *	@host_set: Collections of ports to which we add
diff -puN drivers/scsi/libata.h~libata_port_init drivers/scsi/libata.h
--- libata-dev/drivers/scsi/libata.h~libata_port_init	2006-08-07 09:06:37.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata.h	2006-08-07 12:37:58.000000000 -0500
@@ -69,6 +69,8 @@ extern int ata_flush_cache(struct ata_de
 extern void ata_dev_init(struct ata_device *dev);
 extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
+extern void ata_port_init(struct ata_port *ap, struct ata_host_set *host_set,
+			  const struct ata_probe_ent *ent, unsigned int port_no);
 
 
 /* libata-scsi.c */
_
