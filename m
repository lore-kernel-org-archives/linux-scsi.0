From: kys@exchange.microsoft.com
Subject: [PATCH 2/6] storvsc: Remove the restriction on max segment size
Date: Wed, 14 Dec 2016 18:45:59 -0800
Message-ID: <1481769963-2069-2-git-send-email-kys@exchange.microsoft.com>
References: <1481769928-2026-1-git-send-email-kys@exchange.microsoft.com>
 <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
Reply-To: kys@microsoft.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de, James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@messages.microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: K. Y. Srinivasan <kys@messages.microsoft.com>

Remove the artificially imposed restriction on max segment size.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ccb2101..3b1c2f6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1267,8 +1267,6 @@ static int storvsc_do_io(struct hv_device *device,
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
 
-	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
-
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
 	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));
-- 
1.7.4.1
