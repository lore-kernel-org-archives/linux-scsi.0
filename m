From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/5] Drivers: scsi: storvsc: Increase the value of scsi timeout for storvsc devices
Date: Tue,  4 Jun 2013 12:05:05 -0700
Message-ID: <1370372709-10098-1-git-send-email-kys@microsoft.com>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370372674-10046-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

The standard scsi timeout is not appropriate in some of the environments where
Hyper-V is deployed. Set this timeout appropriately for all devices managed
by this driver.

On cloud environments where storage latencies may be unbounded, having the scsi
layer initiating recovery can be problematic since (a) the host is already
implementing a variety of recovery strategies and (b) implementing a recovery
strategy at the VM level may be more appropriate in cases where storage latencies
exceed a certain threshold.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 16a3a0c..ede8694 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -221,6 +221,11 @@ static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
+/*
+ * Timeout in seconds for all devices managed by this driver.
+ */
+static int storvsc_timeout = 180;
+
 #define STORVSC_MAX_IO_REQUESTS				128
 
 /*
@@ -1204,6 +1209,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
+	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));
+
 	sdevice->no_write_same = 1;
 
 	return 0;
-- 
1.7.4.1
