From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/17] hpsa: Use shost_priv instead of accessing
	host->hostdata[0] directly.
Date: Wed, 11 Nov 2009 10:50:53 -0600
Message-ID: <20091111165053.17754.7913.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1403 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbZKKQt1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 11:49:27 -0500
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com

Use shost_priv instead of accessing host->hostdata[0] directly.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 85be09c..d5a795e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -177,6 +177,12 @@ static struct scsi_host_template hpsa_driver_template = {
 	.sdev_attrs = hpsa_sdev_attrs,
 };
 
+static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
+{
+	unsigned long *priv = shost_priv(sdev->host);
+	return (struct ctlr_info *) *priv;
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct hlist_head *list, struct CommandList *c)
 {
@@ -227,7 +233,7 @@ static ssize_t raid_level_show(struct device *dev,
 	unsigned long flags;
 
 	sdev = to_scsi_device(dev);
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->lock, flags);
 	hdev = sdev->hostdata;
 	if (!hdev) {
@@ -260,7 +266,7 @@ static ssize_t lunid_show(struct device *dev,
 	unsigned char lunid[8];
 
 	sdev = to_scsi_device(dev);
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->lock, flags);
 	hdev = sdev->hostdata;
 	if (!hdev) {
@@ -284,7 +290,7 @@ static ssize_t unique_id_show(struct device *dev,
 	unsigned char sn[16];
 
 	sdev = to_scsi_device(dev);
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->lock, flags);
 	hdev = sdev->hostdata;
 	if (!hdev) {
@@ -677,7 +683,7 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 	unsigned long flags;
 	struct ctlr_info *h;
 
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->devlock, flags);
 	sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
 		sdev_id(sdev), sdev->lun);
@@ -1615,7 +1621,7 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 	unsigned long flags;
 
 	/* Get the ptr to our adapter structure out of cmd->host. */
-	h = (struct ctlr_info *) cmd->device->host->hostdata[0];
+	h = sdev_to_hba(cmd->device);
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
@@ -1795,7 +1801,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	struct hpsa_scsi_dev_t *dev;
 
 	/* find the controller to which the command to be aborted was sent */
-	h = (struct ctlr_info *) scsicmd->device->host->hostdata[0];
+	h = sdev_to_hba(scsicmd->device);
 	if (h == NULL) /* paranoia */
 		return FAILED;
 	dev_warn(&h->pdev->dev, "resetting drive\n");
@@ -2325,7 +2331,7 @@ static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg)
 	struct ctlr_info *h;
 	void __user *argp = (void __user *)arg;
 
-	h = (struct ctlr_info *) dev->host->hostdata[0];
+	h = sdev_to_hba(dev);
 
 	switch (cmd) {
 	case CCISS_DEREGDISK:

