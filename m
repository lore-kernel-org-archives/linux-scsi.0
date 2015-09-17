From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/3] scsi: introduce short_inquiry flag for broken host
 adapters
Date: Thu, 17 Sep 2015 15:29:18 -0700
Message-ID: <1442528959-3298-2-git-send-email-kys@microsoft.com>
References: <1442528938-3252-1-git-send-email-kys@microsoft.com>
 <1442528959-3298-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1442528959-3298-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Some host adapters (e.g. Hyper-V storvsc) are known for not respecting the
SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain at
least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
INQUIRY result too short (5), using 36' messages on console. This can be
problematic for slow consoles. Introduce short_inquiry host template flag
to avoid printing error messages for such adapters.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Alex Ng <alexng@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/scsi_scan.c   |    7 ++++---
 drivers/scsi/storvsc_drv.c |    1 +
 include/scsi/scsi_host.h   |    6 ++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 01ad016..5e325ce 100644
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
index 40c43ae..bce131b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1781,6 +1781,7 @@ static struct scsi_host_template scsi_driver = {
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
1.7.4.1
