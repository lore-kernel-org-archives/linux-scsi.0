From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V1 3/7] Drivers: scsi: storvsc: Make the scsi timeout a module
 parameter
Date: Thu, 16 May 2013 05:21:15 -0700
Message-ID: <1368706879-32321-3-git-send-email-kys@microsoft.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1368706879-32321-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

The standard scsi timeout is not appropriate in some of the environments where
Hyper-V is deployed. Set this timeout appropriately for all devices managed
by this driver. Further make this a module parameter.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 16a3a0c..8d29a95 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -221,6 +221,13 @@ static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
+/*
+ * Timeout in seconds for all devices managed by this driver.
+ */
+static int storvsc_timeout = 180;
+module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
+MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
+
 #define STORVSC_MAX_IO_REQUESTS				128
 
 /*
@@ -1204,6 +1211,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
+	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));
+
 	sdevice->no_write_same = 1;
 
 	return 0;
-- 
1.7.4.1
