From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] transport_sas: add SAS management protocol support
Date: Mon, 09 Jul 2007 12:52:06 +0900
Message-ID: <20070709125206S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60759 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887AbXGIDx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2007 23:53:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, Eric.Moore@lsi.com, jens.axboe@oracle.com

The sas transport class attaches one bsg device to every SAS object
(host, device, expander, etc). LLDs can define a function to handle
SMP requests via sas_function_template::smp_handler.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/Kconfig              |    2 +-
 drivers/scsi/scsi_transport_sas.c |   85 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_sas.h |    3 +-
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index eb46cb0..51632ee 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -277,7 +277,7 @@ config SCSI_ISCSI_ATTRS
 
 config SCSI_SAS_ATTRS
 	tristate "SAS Transport Attributes"
-	depends on SCSI
+	depends on SCSI && BLK_DEV_BSG
 	help
 	  If you wish to export transport-specific information about
 	  each attached SAS device to sysfs, say Y.
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index b2ef71a..2871fd0 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -29,6 +29,8 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/blkdev.h>
+#include <linux/bsg.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -152,6 +154,76 @@ static struct {
 sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
 sas_bitfield_name_set(linkspeed, sas_linkspeed_names)
 
+static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
+			    struct sas_rphy *rphy)
+{
+	struct request *req;
+	int ret;
+	int (*handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
+
+	while (!blk_queue_plugged(q)) {
+		req = elv_next_request(q);
+		if (!req)
+			break;
+
+		blkdev_dequeue_request(req);
+
+		spin_unlock_irq(q->queue_lock);
+
+		handler = to_sas_internal(shost->transportt)->f->smp_handler;
+		ret = handler(shost, rphy, req);
+
+		spin_lock_irq(q->queue_lock);
+
+		req->end_io(req, ret);
+	}
+}
+
+static void sas_host_smp_request(struct request_queue *q)
+{
+	sas_smp_request(q, (struct Scsi_Host *)q->queuedata, NULL);
+}
+
+static void sas_non_host_smp_request(struct request_queue *q)
+{
+	struct sas_rphy *rphy = q->queuedata;
+	sas_smp_request(q, rphy_to_shost(rphy), rphy);
+}
+
+static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy,
+			      char *name)
+{
+	struct request_queue *q;
+	int error;
+
+	if (!to_sas_internal(shost->transportt)->f->smp_handler) {
+		printk("%s can't handle SMP requests\n", shost->hostt->name);
+		return 0;
+	}
+
+	if (rphy)
+		q = blk_init_queue(sas_non_host_smp_request, NULL);
+	else
+		q = blk_init_queue(sas_host_smp_request, NULL);
+	if (!q)
+		return -ENOMEM;
+
+	error = bsg_register_queue(q, name);
+	if (error) {
+		blk_cleanup_queue(q);
+		return -ENOMEM;
+	}
+
+	if (rphy)
+		q->queuedata = rphy;
+	else
+		q->queuedata = shost;
+
+	set_bit(QUEUE_FLAG_BIDI, &q->queue_flags);
+
+	return 0;
+}
+
 /*
  * SAS host attributes
  */
@@ -161,12 +233,19 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	char name[BUS_ID_SIZE];
 
 	INIT_LIST_HEAD(&sas_host->rphy_list);
 	mutex_init(&sas_host->lock);
 	sas_host->next_target_id = 0;
 	sas_host->next_expander_id = 0;
 	sas_host->next_port_id = 0;
+
+	snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
+	if (sas_bsg_initialize(shost, NULL, name))
+		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
+			   shost->host_no);
+
 	return 0;
 }
 
@@ -1221,6 +1300,9 @@ struct sas_rphy *sas_end_device_alloc(struct sas_port *parent)
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
+	if (sas_bsg_initialize(shost, &rdev->rphy, rdev->rphy.dev.bus_id))
+		printk("fail to a bsg device %s\n", rdev->rphy.dev.bus_id);
+
 	return &rdev->rphy;
 }
 EXPORT_SYMBOL(sas_end_device_alloc);
@@ -1260,6 +1342,9 @@ struct sas_rphy *sas_expander_alloc(struct sas_port *parent,
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
+	if (sas_bsg_initialize(shost, &rdev->rphy, rdev->rphy.dev.bus_id))
+		printk("fail to a bsg device %s\n", rdev->rphy.dev.bus_id);
+
 	return &rdev->rphy;
 }
 EXPORT_SYMBOL(sas_expander_alloc);
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 9aedc19..43ed63b 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -7,7 +7,7 @@
 
 struct scsi_transport_template;
 struct sas_rphy;
-
+struct request;
 
 enum sas_device_type {
 	SAS_PHY_UNUSED,
@@ -166,6 +166,7 @@ struct sas_function_template {
 	int (*phy_reset)(struct sas_phy *, int);
 	int (*phy_enable)(struct sas_phy *, int);
 	int (*set_phy_speed)(struct sas_phy *, struct sas_phy_linkrates *);
+	int (*smp_handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
 };
 
 
-- 
1.4.4.4

