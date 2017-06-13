From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH] storvsc: use default I/O timeout handler for FC devices
Date: Mon, 12 Jun 2017 17:23:37 -0700
Message-ID: <1497313417-14815-1-git-send-email-longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

FC disks are usually setup in a multipath system, and they don't want to 
unconditionaly reset I/O on timeout. I/O timeout is detected by multipath 
as a good time to failover and recover.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8d955db..d60b5ea 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -486,6 +486,7 @@ struct hv_host_device {
 	unsigned int port;
 	unsigned char path;
 	unsigned char target;
+	bool is_fc;
 };
 
 struct storvsc_scan_work {
@@ -1495,6 +1496,11 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
  */
 static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
 {
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
+
+	if (host_dev->is_fc)
+		return BLK_EH_NOT_HANDLED;
+
 	return BLK_EH_RESET_TIMER;
 }
 
@@ -1738,6 +1744,7 @@ static int storvsc_probe(struct hv_device *device,
 
 	host_dev->port = host->host_no;
 	host_dev->dev = device;
+	host_dev->is_fc = is_fc;
 
 
 	stor_device = kzalloc(sizeof(struct storvsc_device), GFP_KERNEL);
-- 
2.7.4
