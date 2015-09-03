From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2] scsi: introduce short_inquiry flag for broken host adapters
Date: Thu,  3 Sep 2015 18:11:13 +0200
Message-ID: <1441296673-14315-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Some host adapters (e.g. Hyper-V storvsc) are known for not respecting the
SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain at
least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
INQUIRY result too short (5), using 36' messages on console. This can be
problematic for slow consoles. Introduce short_inquiry host template flag
to avoid printing error messages for such adapters.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
Changes since v1:
- This is a successor of previously sent "scsi_scan: move 'INQUIRY result
  too short' message to debug level" patch. Instead of moving the message
  to debug level for all adapters introduce a special 'short_inquiry' flag
  for host template [inspired by James Bottomley].
---
 drivers/scsi/scsi_scan.c   | 7 ++++---
 drivers/scsi/storvsc_drv.c | 1 +
 include/scsi/scsi_host.h   | 6 ++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..f1d00a0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -701,9 +701,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * strings.
 	 */
 	if (sdev->inquiry_len < 36) {
-		sdev_printk(KERN_INFO, sdev,
-			    "scsi scan: INQUIRY result too short (%d),"
-			    " using 36\n", sdev->inquiry_len);
+		if (!sdev->host->hostt->short_inquiry)
+			sdev_printk(KERN_INFO, sdev,
+				    "scsi scan: INQUIRY result too short (%d),"
+				    " using 36\n", sdev->inquiry_len);
 		sdev->inquiry_len = 36;
 	}
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c6584f..f3b4d0f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1711,6 +1711,7 @@ static struct scsi_host_template scsi_driver = {
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
 	.no_write_same =	1,
+	.short_inquiry =	1,
 };
 
 enum {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e113c75..7b022af 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -454,6 +454,12 @@ struct scsi_host_template {
 	unsigned no_async_abort:1;
 
 	/*
+	 * True if this host adapter returns short (<36 bytes) responses to
+	 * some INQUIRY requests.
+	 */
+	unsigned short_inquiry:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
-- 
2.4.3
