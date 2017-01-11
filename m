From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH RFC] sas: convert to bsg-lib
Date: Wed, 11 Jan 2017 14:54:54 +0100
Message-ID: <20170111135454.23907-1-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966936AbdAKN5A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 08:57:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Convert the SAS transport class over to using bsg-lib instead of doing "raw"
bsg access.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_sas.c | 41 +++++++++++++++------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 60b651b..b87edfe 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -187,25 +187,19 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 	}
 }
 
-static void sas_host_smp_request(struct request_queue *q)
-{
-	sas_smp_request(q, (struct Scsi_Host *)q->queuedata, NULL);
-}
-
-static void sas_non_host_smp_request(struct request_queue *q)
-{
-	struct sas_rphy *rphy = q->queuedata;
-	sas_smp_request(q, rphy_to_shost(rphy), rphy);
-}
-
-static void sas_host_release(struct device *dev)
+static int sas_bsg_dispatch(struct bsg_job *job)
 {
+	struct device *dev = job->dev;
 	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	struct request_queue *q = sas_host->q;
+	struct sas_rphy *rphy = dev_to_rphy(dev);
+	struct request_queue *q = job->req->q;
 
-	if (q)
-		blk_cleanup_queue(q);
+	if (rphy)
+		sas_smp_request(q, rphy_to_shost(rphy), rphy);
+	else
+		sas_smp_request(q, shost, NULL);
+
+	return 0;
 }
 
 static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
@@ -215,7 +209,6 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	struct device *dev;
 	char namebuf[20];
 	const char *name;
-	void (*release)(struct device *);
 
 	if (!to_sas_internal(shost->transportt)->f->smp_handler) {
 		printk("%s can't handle SMP requests\n", shost->hostt->name);
@@ -223,22 +216,20 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	}
 
 	if (rphy) {
-		q = blk_init_queue(sas_non_host_smp_request, NULL);
 		dev = &rphy->dev;
 		name = dev_name(dev);
-		release = NULL;
 	} else {
-		q = blk_init_queue(sas_host_smp_request, NULL);
 		dev = &shost->shost_gendev;
-		snprintf(namebuf, sizeof(namebuf),
-			 "sas_host%d", shost->host_no);
-		name = namebuf;
-		release = sas_host_release;
+		name = kasprintf(GFP_KERNEL, "sas_host%d", shost->host_no);
+		if (!name)
+			return -ENOMEM;
 	}
+
+	q = __scsi_alloc_queue(shost, bsg_request_fn);
 	if (!q)
 		return -ENOMEM;
 
-	error = bsg_register_queue(q, dev, name, release);
+	error = bsg_setup_queue(dev, queue, name, sas_bsg_dispatch, 0);
 	if (error) {
 		blk_cleanup_queue(q);
 		return -ENOMEM;
-- 
2.10.2

