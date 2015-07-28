From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 5/7 RESEND] scsi_debug: schedule_resp fix input variable check
Date: Tue, 28 Jul 2015 16:54:24 +0300
Message-ID: <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

The function should never be called with cmnd NULL so
put a fat WARN there.
Fix also smatch wraning:
schedule_resp() warn: variable dereferenced before check 'cmnd'

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3a70683cf9f9..faa4ddd8decf 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3941,13 +3941,20 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	unsigned long iflags;
 	int k, num_in_q, qdepth, inject;
 	struct sdebug_queued_cmd *sqcp = NULL;
-	struct scsi_device *sdp = cmnd->device;
+	struct scsi_device *sdp;
+
+	/* this should never happen */
+	if (WARN_ON(!cmnd))
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	if (NULL == cmnd || NULL == devip) {
-		pr_warn("called with NULL cmnd or devip pointer\n");
+	if (NULL == devip) {
+		pr_warn("called devip == NULL\n");
 		/* no particularly good error to report back */
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
+
+	sdp = cmnd->device;
+
 	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
 			    __func__, scsi_result);
-- 
2.4.3
