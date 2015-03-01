From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 2/2] scsi_debug: use scsi_device_get_hdata
Date: Sun,  1 Mar 2015 12:22:07 +0200
Message-ID: <1425205327-27639-2-git-send-email-tomas.winkler@intel.com>
References: <1425205327-27639-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbbCAKXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Mar 2015 05:23:05 -0500
In-Reply-To: <1425205327-27639-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>

Cc: Christoph Hellwig <hch@lst.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/scsi_debug.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 079934c8698e..0825c0a62a33 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3498,7 +3498,7 @@ static void sdebug_q_cmd_complete(unsigned long indx)
 		pr_err("scp is NULL\n");
 		return;
 	}
-	devip = (struct sdebug_dev_info *)scp->device->hostdata;
+	devip = scsi_device_get_hdata(scp->device);
 	if (devip)
 		atomic_dec(&devip->num_in_q);
 	else
@@ -3558,7 +3558,7 @@ sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 		pr_err("scp is NULL\n");
 		goto the_end;
 	}
-	devip = (struct sdebug_dev_info *)scp->device->hostdata;
+	devip = scsi_device_get_hdata(scp->device);
 	if (devip)
 		atomic_dec(&devip->num_in_q);
 	else
@@ -3611,8 +3611,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 {
 	struct sdebug_host_info * sdbg_host;
 	struct sdebug_dev_info * open_devip = NULL;
-	struct sdebug_dev_info * devip =
-			(struct sdebug_dev_info *)sdev->hostdata;
+	struct sdebug_dev_info *devip = scsi_device_get_hdata(sdev);
 
 	if (devip)
 		return devip;
@@ -3670,7 +3669,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	devip = devInfoReg(sdp);
 	if (NULL == devip)
 		return 1;	/* no resources, will be marked offline */
-	sdp->hostdata = devip;
+	scsi_device_set_hdata(sdp, devip);
 	blk_queue_max_segment_size(sdp->request_queue, -1U);
 	if (scsi_debug_no_uld)
 		sdp->no_uld_attach = 1;
@@ -3679,8 +3678,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 
 static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 {
-	struct sdebug_dev_info *devip =
-		(struct sdebug_dev_info *)sdp->hostdata;
+	struct sdebug_dev_info *devip = scsi_device_get_hdata(sdp);
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 		pr_info("slave_destroy <%u %u %u %llu>\n",
@@ -3688,7 +3686,7 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 	if (devip) {
 		/* make this slot available for re-use */
 		devip->used = false;
-		sdp->hostdata = NULL;
+		scsi_device_set_hdata(sdp, NULL);
 	}
 }
 
@@ -3709,8 +3707,7 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
 			if (cmnd == sqcp->a_cmnd) {
-				devip = (struct sdebug_dev_info *)
-					cmnd->device->hostdata;
+				devip = scsi_device_get_hdata(cmnd->device);
 				if (devip)
 					atomic_dec(&devip->num_in_q);
 				sqcp->a_cmnd = NULL;
@@ -3750,8 +3747,7 @@ static void stop_all_queued(void)
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
 			if (sqcp->a_cmnd) {
-				devip = (struct sdebug_dev_info *)
-					sqcp->a_cmnd->device->hostdata;
+				devip = scsi_device_get_hdata(sqcp->a_cmnd->device);
 				if (devip)
 					atomic_dec(&devip->num_in_q);
 				sqcp->a_cmnd = NULL;
@@ -5113,7 +5109,7 @@ sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 	struct sdebug_dev_info *devip;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	devip = (struct sdebug_dev_info *)sdev->hostdata;
+	devip = scsi_device_get_hdata(sdev);
 	if (NULL == devip) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		return	-ENODEV;
@@ -5212,7 +5208,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 
 	sdeb_i = opcode_ind_arr[opcode];	/* fully mapped */
 	oip = &opcode_info_arr[sdeb_i];		/* safe if table consistent */
-	devip = (struct sdebug_dev_info *)sdp->hostdata;
+	devip = scsi_device_get_hdata(sdp);
 	if (!devip) {
 		devip = devInfoReg(sdp);
 		if (NULL == devip)
-- 
1.9.3

