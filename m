From: Michael Reed <mdr@sgi.com>
Subject: PATCH [1/1]: sd_remove() hangs waiting on async_synchronize of unrelated
 threads
Date: Tue, 01 Dec 2009 15:45:31 -0600
Message-ID: <4B158E7B.3040708@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:59506 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754056AbZLAVp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2009 16:45:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Jeremy Higdon <jeremy@sgi.com>, James Smart <James.Smart@Emulex.Com>

Prevent delays and hangs due to sd_remove() waiting for the completion of
async threads executing sd_probe_async of disks on unrelated host adapters.
This patch executes every sd_probe_async in its own async domain allowing
sd_remove() to wait for just the completion of the async thread associated with
the scsi_disk being removed.

Found via fault insertion on a large fibre channel fabric.

Applies to 2.6.32-rc8.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- linux-2.6.32-rc8/drivers/scsi/sd.h	2009-11-19 16:32:38.000000000 -0600
+++ linux-2.6.32-rc8-modified/drivers/scsi/sd.h	2009-12-01 15:25:33.686651715 -0600
@@ -60,6 +60,7 @@ struct scsi_disk {
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
 	unsigned	first_scan : 1;
+	struct list_head async_domain;	/* for sd_probe_async */
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
--- linux-2.6.32-rc8/drivers/scsi/sd.c	2009-11-19 16:32:38.000000000 -0600
+++ linux-2.6.32-rc8-modified/drivers/scsi/sd.c	2009-12-01 15:26:17.686653817 -0600
@@ -2171,7 +2171,8 @@ static int sd_probe(struct device *dev)
 	get_device(&sdp->sdev_gendev);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-	async_schedule(sd_probe_async, sdkp);
+	INIT_LIST_HEAD(&sdkp->async_domain);
+	async_schedule_domain(sd_probe_async, sdkp, &sdkp->async_domain);
 
 	return 0;
 
@@ -2202,8 +2203,9 @@ static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
 
-	async_synchronize_full();
 	sdkp = dev_get_drvdata(dev);
+	async_synchronize_full_domain(&sdkp->async_domain);
+
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
