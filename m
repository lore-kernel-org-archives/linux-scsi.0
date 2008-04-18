From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] scsi_transport_sas: fix the lifetime of sas bsg objects
Date: Sat, 19 Apr 2008 00:43:15 +0900
Message-ID: <1208533395-31610-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1208533395-31610-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1208533395-31610-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59354 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbYDRPoR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 11:44:17 -0400
In-Reply-To: <1208533395-31610-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

scsi_transport_sas calls blk_cleanup_queue too early for bsg
queues. If a user holds a sas_host, end_device, or expander device
open, remove the device, then send a request to it, we get a kernel
crash. We need to call blk_cleanup_queue in the release callback as we
do with scsi devices.

This patch moves blk_cleanup_queue to sas_expander_release and
sas_end_device_release from sas_bsg_remove. sas_host can't use the
release callback in struct device so use bsg's release callback.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_transport_sas.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 94ff29f..7899e3d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -192,6 +192,16 @@ static void sas_non_host_smp_request(struct request_queue *q)
 	sas_smp_request(q, rphy_to_shost(rphy), rphy);
 }
 
+static void sas_host_release(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	struct request_queue *q = sas_host->q;
+
+	if (q)
+		blk_cleanup_queue(q);
+}
+
 static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 {
 	struct request_queue *q;
@@ -199,6 +209,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	struct device *dev;
 	char namebuf[BUS_ID_SIZE];
 	const char *name;
+	void (*release)(struct device *);
 
 	if (!to_sas_internal(shost->transportt)->f->smp_handler) {
 		printk("%s can't handle SMP requests\n", shost->hostt->name);
@@ -209,17 +220,19 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 		q = blk_init_queue(sas_non_host_smp_request, NULL);
 		dev = &rphy->dev;
 		name = dev->bus_id;
+		release = NULL;
 	} else {
 		q = blk_init_queue(sas_host_smp_request, NULL);
 		dev = &shost->shost_gendev;
 		snprintf(namebuf, sizeof(namebuf),
 			 "sas_host%d", shost->host_no);
 		name = namebuf;
+		release = sas_host_release;
 	}
 	if (!q)
 		return -ENOMEM;
 
-	error = bsg_register_queue(q, dev, name, NULL);
+	error = bsg_register_queue(q, dev, name, release);
 	if (error) {
 		blk_cleanup_queue(q);
 		return -ENOMEM;
@@ -253,7 +266,6 @@ static void sas_bsg_remove(struct Scsi_Host *shost, struct sas_rphy *rphy)
 		return;
 
 	bsg_unregister_queue(q);
-	blk_cleanup_queue(q);
 }
 
 /*
@@ -1301,6 +1313,9 @@ static void sas_expander_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_expander_device *edev = rphy_to_expander_device(rphy);
 
+	if (rphy->q)
+		blk_cleanup_queue(rphy->q);
+
 	put_device(dev->parent);
 	kfree(edev);
 }
@@ -1310,6 +1325,9 @@ static void sas_end_device_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_end_device *edev = rphy_to_end_device(rphy);
 
+	if (rphy->q)
+		blk_cleanup_queue(rphy->q);
+
 	put_device(dev->parent);
 	kfree(edev);
 }
-- 
1.5.3.4

