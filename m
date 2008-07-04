From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/2] scsi_dh: use GFP_ATOMIC for critical sections
Date: Fri, 04 Jul 2008 15:46:48 +0200
Message-ID: <20080704134648.EC6C710B5DD@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:43078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbYGDNqu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2008 09:46:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


The device_handler functions might be called from an IO path,
so we have to use GFP_ATOMIC there.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a3c89df..1cc90d1 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -93,7 +93,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
 
-	rq = blk_get_request(q, rw, GFP_KERNEL);
+	rq = blk_get_request(q, rw, GFP_ATOMIC);
 
 	if (!rq) {
 		sdev_printk(KERN_INFO, sdev,
@@ -101,7 +101,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
+	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_ATOMIC)) {
 		blk_put_request(rq);
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: blk_rq_map_kern failed\n", __FUNCTION__);
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b915957..b2bc0a8 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -210,7 +210,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
 
-	rq = blk_get_request(q, rw, GFP_KERNEL);
+	rq = blk_get_request(q, rw, GFP_ATOMIC);
 
 	if (!rq) {
 		sdev_printk(KERN_INFO, sdev,
@@ -218,7 +218,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
+	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_ATOMIC)) {
 		blk_put_request(rq);
 		sdev_printk(KERN_INFO, sdev,
 				"get_rdac_req: blk_rq_map_kern failed.\n");
-- 
1.5.2.4

