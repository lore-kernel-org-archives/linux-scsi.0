From: Long Li <longli@microsoft.com>
Subject: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Wed, 10 Dec 2014 00:38:25 -0800
Message-ID: <1418200705-488-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

MSFT targets currently claim SPC-2 compliance while they implement post SPC-2 features. With this patch we can correctly handle WRITE_SAME_16 issues.

This patch fixes an issue where the flag is setup too late in drive initialization process.

Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/storvsc_drv.c  | 10 ----------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c1d04d4..f6fe0b2 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -211,6 +211,7 @@ static struct {
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
+	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
 	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e3ba251..2452bb4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -327,8 +327,6 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  */
 static int storvsc_timeout = 180;
 
-static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
-
 #define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
@@ -1439,14 +1437,6 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
-	/*
-	 * Add blist flags to permit the reading of the VPD pages even when
-	 * the target may claim SPC-2 compliance. MSFT targets currently
-	 * claim SPC-2 compliance while they implement post SPC-2 features.
-	 * With this patch we can correctly handle WRITE_SAME_16 issues.
-	 */
-	sdevice->sdev_bflags |= msft_blist_flags;
-
 	return 0;
 }
 
-- 
2.1.0
