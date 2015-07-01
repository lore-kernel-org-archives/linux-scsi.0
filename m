From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] scsi: storvsc: use shost_for_each_device() instead of open
 coding
Date: Wed,  1 Jul 2015 11:31:27 +0200
Message-ID: <1435743087-7824-1-git-send-email-vkuznets@redhat.com>
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
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Comment in struct Scsi_Host says that drivers are not supposed to access
__devices directly. storvsc_host_scan() doesn't happen in irq context
so we can just use shost_for_each_device().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c6584f..9ea912b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -426,7 +426,6 @@ static void storvsc_host_scan(struct work_struct *work)
 	struct storvsc_scan_work *wrk;
 	struct Scsi_Host *host;
 	struct scsi_device *sdev;
-	unsigned long flags;
 
 	wrk = container_of(work, struct storvsc_scan_work, work);
 	host = wrk->host;
@@ -443,14 +442,8 @@ static void storvsc_host_scan(struct work_struct *work)
 	 * may have been removed this way.
 	 */
 	mutex_lock(&host->scan_mutex);
-	spin_lock_irqsave(host->host_lock, flags);
-	list_for_each_entry(sdev, &host->__devices, siblings) {
-		spin_unlock_irqrestore(host->host_lock, flags);
+	shost_for_each_device(sdev, host)
 		scsi_test_unit_ready(sdev, 1, 1, NULL);
-		spin_lock_irqsave(host->host_lock, flags);
-		continue;
-	}
-	spin_unlock_irqrestore(host->host_lock, flags);
 	mutex_unlock(&host->scan_mutex);
 	/*
 	 * Now scan the host to discover LUNs that may have been added.
-- 
2.4.3
