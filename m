From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.26-rc8
Date: Tue, 01 Jul 2008 12:07:14 -0500
Message-ID: <1214932034.3316.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51073 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYGARHS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 13:07:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

These are all pretty minor (but bug fixes none the less).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

David S. Miller (1):
      esp: Fix OOPS in esp_reset_cleanup().

James Bottomley (1):
      esp: tidy up target reference counting

Matthew Wilcox (1):
      ses: Fix timeout

And the diffstat:

 drivers/scsi/esp_scsi.c |   22 ++++++++++++++++++++--
 drivers/scsi/ses.c      |    2 +-
 2 files changed, 21 insertions(+), 3 deletions(-)

Full diff is below

James

---

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index a0b6d41..59fbef0 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2359,6 +2359,24 @@ void scsi_esp_unregister(struct esp *esp)
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
@@ -2370,8 +2388,6 @@ static int esp_slave_alloc(struct scsi_device *dev)
 		return -ENOMEM;
 	dev->hostdata = lp;
 
-	tp->starget = dev->sdev_target;
-
 	spi_min_period(tp->starget) = esp->min_period;
 	spi_max_offset(tp->starget) = 15;
 
@@ -2608,6 +2624,8 @@ struct scsi_host_template scsi_esp_template = {
 	.name			= "esp",
 	.info			= esp_info,
 	.queuecommand		= esp_queuecommand,
+	.target_alloc		= esp_target_alloc,
+	.target_destroy		= esp_target_destroy,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_configure	= esp_slave_configure,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 45df83b..0fe031f 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -61,7 +61,7 @@ static int ses_probe(struct device *dev)
 	return err;
 }
 
-#define SES_TIMEOUT 30
+#define SES_TIMEOUT (30 * HZ)
 #define SES_RETRIES 3
 
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,


