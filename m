From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] esp: use shost_priv
Date: Thu, 31 May 2007 20:12:32 +0200
Message-ID: <20070531181232.GB3245@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41487 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796AbXEaSMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2007 14:12:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, davem@davemloft.net
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/esp_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/esp_scsi.c	2007-05-31 20:04:05.000000000 +0200
+++ linux-2.6/drivers/scsi/esp_scsi.c	2007-05-31 20:05:51.000000000 +0200
@@ -921,7 +921,7 @@ static void esp_event_queue_full(struct 
 static int esp_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	struct scsi_device *dev = cmd->device;
-	struct esp *esp = host_to_esp(dev->host);
+	struct esp *esp = shost_priv(dev->host);
 	struct esp_cmd_priv *spriv;
 	struct esp_cmd_entry *ent;
 
@@ -2356,7 +2356,7 @@ EXPORT_SYMBOL(scsi_esp_unregister);
 
 static int esp_slave_alloc(struct scsi_device *dev)
 {
-	struct esp *esp = host_to_esp(dev->host);
+	struct esp *esp = shost_priv(dev->host);
 	struct esp_target_data *tp = &esp->target[dev->id];
 	struct esp_lun_data *lp;
 
@@ -2380,7 +2380,7 @@ static int esp_slave_alloc(struct scsi_d
 
 static int esp_slave_configure(struct scsi_device *dev)
 {
-	struct esp *esp = host_to_esp(dev->host);
+	struct esp *esp = shost_priv(dev->host);
 	struct esp_target_data *tp = &esp->target[dev->id];
 	int goal_tags, queue_depth;
 
@@ -2422,7 +2422,7 @@ static void esp_slave_destroy(struct scs
 
 static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	struct esp *esp = host_to_esp(cmd->device->host);
+	struct esp *esp = shost_priv(cmd->device->host);
 	struct esp_cmd_entry *ent, *tmp;
 	struct completion eh_done;
 	unsigned long flags;
@@ -2538,7 +2538,7 @@ out_failure:
 
 static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct esp *esp = host_to_esp(cmd->device->host);
+	struct esp *esp = shost_priv(cmd->device->host);
 	struct completion eh_reset;
 	unsigned long flags;
 
@@ -2574,7 +2574,7 @@ static int esp_eh_bus_reset_handler(stru
 /* All bets are off, reset the entire device.  */
 static int esp_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct esp *esp = host_to_esp(cmd->device->host);
+	struct esp *esp = shost_priv(cmd->device->host);
 	unsigned long flags;
 
 	spin_lock_irqsave(esp->host->host_lock, flags);
@@ -2614,7 +2614,7 @@ EXPORT_SYMBOL(scsi_esp_template);
 
 static void esp_get_signalling(struct Scsi_Host *host)
 {
-	struct esp *esp = host_to_esp(host);
+	struct esp *esp = shost_priv(host);
 	enum spi_signal_type type;
 
 	if (esp->flags & ESP_FLAG_DIFFERENTIAL)
@@ -2628,7 +2628,7 @@ static void esp_get_signalling(struct Sc
 static void esp_set_offset(struct scsi_target *target, int offset)
 {
 	struct Scsi_Host *host = dev_to_shost(target->dev.parent);
-	struct esp *esp = host_to_esp(host);
+	struct esp *esp = shost_priv(host);
 	struct esp_target_data *tp = &esp->target[target->id];
 
 	tp->nego_goal_offset = offset;
@@ -2638,7 +2638,7 @@ static void esp_set_offset(struct scsi_t
 static void esp_set_period(struct scsi_target *target, int period)
 {
 	struct Scsi_Host *host = dev_to_shost(target->dev.parent);
-	struct esp *esp = host_to_esp(host);
+	struct esp *esp = shost_priv(host);
 	struct esp_target_data *tp = &esp->target[target->id];
 
 	tp->nego_goal_period = period;
@@ -2648,7 +2648,7 @@ static void esp_set_period(struct scsi_t
 static void esp_set_width(struct scsi_target *target, int width)
 {
 	struct Scsi_Host *host = dev_to_shost(target->dev.parent);
-	struct esp *esp = host_to_esp(host);
+	struct esp *esp = shost_priv(host);
 	struct esp_target_data *tp = &esp->target[target->id];
 
 	tp->nego_goal_width = (width ? 1 : 0);
Index: linux-2.6/drivers/scsi/esp_scsi.h
===================================================================
--- linux-2.6.orig/drivers/scsi/esp_scsi.h	2007-05-31 20:04:51.000000000 +0200
+++ linux-2.6/drivers/scsi/esp_scsi.h	2007-05-31 20:05:00.000000000 +0200
@@ -517,8 +517,6 @@ struct esp {
 	struct sbus_dma		*dma;
 };
 
-#define host_to_esp(host)	((struct esp *)(host)->hostdata)
-
 /* A front-end driver for the ESP chip should do the following in
  * it's device probe routine:
  * 1) Allocate the host and private area using scsi_host_alloc()
Index: linux-2.6/drivers/scsi/jazz_esp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/jazz_esp.c	2007-05-31 20:06:00.000000000 +0200
+++ linux-2.6/drivers/scsi/jazz_esp.c	2007-05-31 20:06:02.000000000 +0200
@@ -143,7 +143,7 @@ static int __devinit esp_jazz_probe(stru
 		goto fail;
 
 	host->max_id = 8;
-	esp = host_to_esp(host);
+	esp = shost_priv(host);
 
 	esp->host = host;
 	esp->dev = dev;
Index: linux-2.6/drivers/scsi/sun_esp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sun_esp.c	2007-05-31 20:04:39.000000000 +0200
+++ linux-2.6/drivers/scsi/sun_esp.c	2007-05-31 20:05:57.000000000 +0200
@@ -493,7 +493,7 @@ static int __devinit esp_sbus_probe_one(
 		goto fail;
 
 	host->max_id = (hme ? 16 : 8);
-	esp = host_to_esp(host);
+	esp = shost_priv(host);
 
 	esp->host = host;
 	esp->dev = esp_dev;
