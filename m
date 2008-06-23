From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] esp: tidy up target reference counting
Date: Mon, 23 Jun 2008 14:52:09 -0500
Message-ID: <1214250729.3310.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52042 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbYFWTwO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2008 15:52:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The esp driver currently does hand rolled reference counting of its
target.  It's much easier to do what it needs to do if it's plugged into
the mid-layer callbacks (target_alloc and target_destroy) which were
designed for this case, so do it this way and get rid of the internal
target reference count.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index fa75636..62a4618 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2361,6 +2361,24 @@ void scsi_esp_unregister(struct esp *esp)
 }
 EXPORT_SYMBOL(scsi_esp_unregister);
 
+static int esp_target_alloc(struct scsi_target *starget)
+{
+	struct esp *esp = shost_priv(dev_to_shost(&starget->dev));
+	struct esp_target_data *tp = &esp->target[starget->id];
+
+	tp->starget = starget;
+
+	return 0;
+}
+
+static void esp_target_destroy(struct scsi_target *starget)
+{
+	struct esp *esp = shost_priv(dev_to_shost(&starget->dev));
+	struct esp_target_data *tp = &esp->target[starget->id];
+
+	tp->starget = NULL;
+}
+
 static int esp_slave_alloc(struct scsi_device *dev)
 {
 	struct esp *esp = shost_priv(dev->host);
@@ -2372,9 +2390,6 @@ static int esp_slave_alloc(struct scsi_device *dev)
 		return -ENOMEM;
 	dev->hostdata = lp;
 
-	tp->starget = dev->sdev_target;
-	tp->starget_ref++;
-
 	spi_min_period(tp->starget) = esp->min_period;
 	spi_max_offset(tp->starget) = 15;
 
@@ -2428,17 +2443,10 @@ static int esp_slave_configure(struct scsi_device *dev)
 
 static void esp_slave_destroy(struct scsi_device *dev)
 {
-	struct esp *esp = shost_priv(dev->host);
-	struct esp_target_data *tp = &esp->target[dev->id];
 	struct esp_lun_data *lp = dev->hostdata;
 
 	kfree(lp);
 	dev->hostdata = NULL;
-
-	BUG_ON(tp->starget_ref <= 0);
-
-	if (!--tp->starget_ref)
-		tp->starget = NULL;
 }
 
 static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
@@ -2618,6 +2626,8 @@ struct scsi_host_template scsi_esp_template = {
 	.name			= "esp",
 	.info			= esp_info,
 	.queuecommand		= esp_queuecommand,
+	.target_alloc		= esp_target_alloc,
+	.target_destroy		= esp_target_destroy,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_configure	= esp_slave_configure,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 655e0b2..bb43a13 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -322,7 +322,6 @@ struct esp_target_data {
 	u8			nego_goal_tags;
 
 	struct scsi_target	*starget;
-	int			starget_ref;
 };
 
 struct esp_event_ent {


