From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi_lib_dma.c : fix bug /w dma mpas on virtual vc ports
Date: Wed, 23 Sep 2009 13:39:00 -0400
Message-ID: <1253727540.30846.4.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43676 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZIWRi7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2009 13:38:59 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n8NHd3HI003510
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2009 10:39:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

James,

This patch was originally posted 10/7/2008. It hasn't been picked up yet. Please incorporate the patch.

The original threads are at:
http://marc.info/?l=linux-scsi&m=122339015023134&w=2
http://marc.info/?l=linux-scsi&m=122338653014680&w=2

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 drivers/scsi/scsi_lib.c     |    2 +-
 drivers/scsi/scsi_lib_dma.c |    7 +++++--
 include/scsi/scsi_host.h    |   15 +++++++++++++++
 3 files changed, 21 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2009-09-23 12:37:53.000000000 -0400
+++ b/drivers/scsi/scsi_lib.c	2009-09-23 13:31:43.000000000 -0400
@@ -1611,7 +1611,7 @@ struct request_queue *__scsi_alloc_queue
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
-	struct device *dev = shost->shost_gendev.parent;
+	struct device *dev = dev_to_nonscsi_dev(shost->shost_gendev.parent);
 
 	q = blk_init_queue(request_fn, NULL);
 	if (!q)
diff -upNr a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
--- a/drivers/scsi/scsi_lib_dma.c	2008-09-23 15:12:13.000000000 -0400
+++ b/drivers/scsi/scsi_lib_dma.c	2009-09-23 13:31:43.000000000 -0400
@@ -23,7 +23,8 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
 	int nseg = 0;
 
 	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
+		struct device *dev = dev_to_nonscsi_dev(
+					cmd->device->host->shost_gendev.parent);
 
 		nseg = dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 				  cmd->sc_data_direction);
@@ -41,10 +42,12 @@ EXPORT_SYMBOL(scsi_dma_map);
 void scsi_dma_unmap(struct scsi_cmnd *cmd)
 {
 	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
+		struct device *dev = dev_to_nonscsi_dev(
+					cmd->device->host->shost_gendev.parent);
 
 		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 			     cmd->sc_data_direction);
 	}
 }
 EXPORT_SYMBOL(scsi_dma_unmap);
+
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2009-06-29 10:31:27.000000000 -0400
+++ b/include/scsi/scsi_host.h	2009-09-23 13:31:43.000000000 -0400
@@ -698,6 +698,10 @@ static inline void *shost_priv(struct Sc
 
 int scsi_is_host_device(const struct device *);
 
+/*
+ * walks object list backward, to find the first shost object.
+ * Skips over transport objects that may not be stargets, etc
+ */
 static inline struct Scsi_Host *dev_to_shost(struct device *dev)
 {
 	while (!scsi_is_host_device(dev)) {
@@ -708,6 +712,17 @@ static inline struct Scsi_Host *dev_to_s
 	return container_of(dev, struct Scsi_Host, shost_gendev);
 }
 
+/*
+ * walks object list backward, to find the first non-scsi object
+ * Skips over transport objects that may be vports, shosts under vports, etc 
+ */
+static inline struct device *dev_to_nonscsi_dev(struct device *dev)
+{
+	while (dev->type == NULL || scsi_is_host_device(dev))
+		dev = dev->parent;
+	return dev;
+}
+
 static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 {
 	return shost->shost_state == SHOST_RECOVERY ||


