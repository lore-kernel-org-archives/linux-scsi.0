From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH 3/3] storvsc: use block layer default segment size
Date: Tue,  6 Sep 2016 14:25:43 -0700
Message-ID: <1473197143-16760-4-git-send-email-longli@exchange.microsoft.com>
References: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

We no long have the restriction of page size limit in the SG list. Remove it. The driver can properly handle default block segment size.

---
 drivers/scsi/storvsc_drv.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8328c87..ac57f9c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1271,9 +1271,6 @@ static int storvsc_do_io(struct hv_device *device,
 
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
-
-	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
-
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
 	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));
-- 
1.8.5.6
