From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH] storvsc: fix memory leak on ring buffer busy
Date: Mon, 28 Aug 2017 17:43:59 -0700
Message-ID: <20170829004359.28526-1-longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

When storvsc is sending I/O to Hyper-v, it may allocate a bigger buffer
descriptor for large data payload that can't fit into a pre-allocated
buffer descriptor. This bigger buffer is freed on return path.

If I/O request to Hyper-v fails due to ring buffer busy, the storvsc allocated
buffer descriptor should also be freed.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 009adb0..db52882 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1657,6 +1657,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	ret = storvsc_do_io(dev, cmd_request, smp_processor_id());
 
 	if (ret == -EAGAIN) {
+		if (payload_sz > sizeof(cmd_request->mpb))
+			kfree(payload);
 		/* no more space */
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
-- 
2.7.4
