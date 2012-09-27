From: Gwendal Grignou <gwendal@google.com>
Subject: [PATCH 3/3] libata: Change transport topology layout
Date: Thu, 27 Sep 2012 12:04:04 -0700
Message-ID: <1348772644-12486-4-git-send-email-gwendal@google.com>
References: <1348772644-12486-1-git-send-email-gwendal@google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36084 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2I0TEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2012 15:04:15 -0400
Received: by qaea16 with SMTP id a16so356764qae.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 12:04:14 -0700 (PDT)
In-Reply-To: <1348772644-12486-1-git-send-email-gwendal@google.com>
In-Reply-To: <20120920020145.GA23210@mint-spring.sh.intel.com>
References: <20120920020145.GA23210@mint-spring.sh.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aaron.lu@intel.com, minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com
Cc: Gwendal Grignou <gwendal@google.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Integrate ata objects [port, link, device] with scsi objects.


The path of a scsi device is:
.../0000:00:1f.2/host0/ata1/link1/dev1.0/target0:0:0/0:0:0:0

or when a port multiplier is present: for instance the device in port 4 of the
port multiplier:
.../0000:00:06.0/0000:09:00.0/host5/ata6/link6.4/dev6.4.0/target5:4:0/5:4:0:0


Change-Id: I202e089208e8746ccdaf2053d43da831a0c0976d

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/ata/libata-core.c      |   13 ++++++-------
 drivers/ata/libata-scsi.c      |    4 ++--
 drivers/ata/libata-transport.c |    2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 611050d..c83590b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6063,19 +6063,18 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
 
+	rc = ata_scsi_add_hosts(host, sht);
+	if (rc)
+		return rc;
 
 	/* Create associated sysfs transport objects  */
 	for (i = 0; i < host->n_ports; i++) {
-		rc = ata_tport_add(host->dev,host->ports[i]);
-		if (rc) {
+		struct ata_port *ap = host->ports[i];
+		rc = ata_tport_add(&ap->scsi_host->shost_gendev, ap);
+		if (rc)
 			goto err_tadd;
-		}
 	}
 
-	rc = ata_scsi_add_hosts(host, sht);
-	if (rc)
-		goto err_tadd;
-
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfda61f..9023bb1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3649,8 +3649,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			else
 				channel = link->pmp;
 
-			sdev = __scsi_add_device(&ap->scsi_host->shost_gendev,
-						 channel, id, 0, NULL);
+			sdev = __scsi_add_device(&dev->tdev, channel, id, 0,
+						 NULL);
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index c04d393..6829be6 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -284,7 +284,7 @@ int ata_tport_add(struct device *parent,
 
 	dev->parent = get_device(parent);
 	dev->release = ata_tport_release;
-	dev_set_name(dev, "ata%d", ap->print_id);
+	dev_set_name(dev, "port%d", ap->print_id);
 	transport_setup_device(dev);
 	error = device_add(dev);
 	if (error) {
-- 
1.7.7.3

