From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH v2] storvsc: use default I/O timeout handler for FC devices
Date: Tue, 13 Jun 2017 14:34:05 -0700
Message-ID: <1497389645-8912-1-git-send-email-longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, KY Srinivasan <kys@microsoft.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Stephen Hemminger <sthemmin@microsoft.com>
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

FC disks issue I/O directly to the host storage port driver, this is
diffirent to VHD disks where I/O is virtualized and timeout is handled
by the host VSP (Virtualization Service Provider).

FC disks are usually setup in a multipath system, and they don't want to
reset timer on I/O timeout. Timeout is detected by multipath as a good 
time to failover and recover.

Patch v2 includes suggestions from Bart Van Assche
<Bart.VanAssche@sandisk.com>

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8d955db..3cc8d67 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1495,6 +1495,10 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
  */
 static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
 {
+#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
+	if (scmnd->device->host->transportt == fc_transport_template)
+		return fc_eh_timed_out(scmnd);
+#endif
 	return BLK_EH_RESET_TIMER;
 }
 
-- 
2.7.4
