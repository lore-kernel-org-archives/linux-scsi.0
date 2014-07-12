From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 5/7] Drivers: scsi: storvsc: Implement a timedout handler
Date: Sat, 12 Jul 2014 09:48:30 -0700
Message-ID: <1405183712-23967-5-git-send-email-kys@microsoft.com>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1405183712-23967-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Azure, we have seen instances of unbounded I/O latencies. To deal with
this issue, implement handler that can reset the timeout. Note that the
host gaurantees that it will respond to each command that has been issued.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7e8a642..3516761 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -33,6 +33,7 @@
 #include <linux/device.h>
 #include <linux/hyperv.h>
 #include <linux/mempool.h>
+#include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -1518,6 +1519,14 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	return SUCCESS;
 }
 
+static enum blk_eh_timer_return storvsc_timeout_handler(struct scsi_cmnd *scmnd)
+{
+	/*
+	 * The host will respond; ask for more time.
+	 */
+	return BLK_EH_RESET_TIMER;
+}
+
 static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 {
 	bool allowed = true;
@@ -1697,6 +1706,7 @@ static struct scsi_host_template scsi_driver = {
 	.bios_param =		storvsc_get_chs,
 	.queuecommand =		storvsc_queuecommand,
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
+	.eh_timed_out =		storvsc_timeout_handler,
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
-- 
1.7.4.1
