From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 2/7 RESEND] scsi_debug: use SCSI_W_LUN_REPORT_LUNS instead of SAM2_WLUN_REPORT_LUNS;
Date: Tue, 28 Jul 2015 16:54:21 +0300
Message-ID: <1438091666-18113-2-git-send-email-tomas.winkler@intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbbG1N53 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2015 09:57:29 -0400
In-Reply-To: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

use SCSI_W_LUN_REPORT_LUNS from scsi.h instead of localy defined
SAM2_WLUN_REPORT_LUNS

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6e6bf0f03cf7..bbe04dae040c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -204,7 +204,6 @@ static const char *scsi_debug_version_date = "20141022";
 /* If REPORT LUNS has luns >= 256 it can choose "flat space" (value 1)
  * or "peripheral device" addressing (value 0) */
 #define SAM2_LUN_ADDRESS_METHOD 0
-#define SAM2_WLUN_REPORT_LUNS 0xc101
 
 /* SCSI_DEBUG_CANQUEUE is the maximum number of commands that can be queued
  * (for response) at one time. Can be reduced by max_queue option. Command
@@ -701,7 +700,7 @@ static void sdebug_max_tgts_luns(void)
 		else
 			hpnt->max_id = scsi_debug_num_tgts;
 		/* scsi_debug_max_luns; */
-		hpnt->max_lun = SAM2_WLUN_REPORT_LUNS;
+		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;
 	}
 	spin_unlock(&sdebug_host_list_lock);
 }
@@ -1291,7 +1290,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
-	have_wlun = (scp->device->lun == SAM2_WLUN_REPORT_LUNS);
+	have_wlun = (scp->device->lun == SCSI_W_LUN_REPORT_LUNS);
 	if (have_wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
@@ -3367,8 +3366,8 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 		one_lun[i].scsi_lun[1] = lun & 0xff;
 	}
 	if (want_wlun) {
-		one_lun[i].scsi_lun[0] = (SAM2_WLUN_REPORT_LUNS >> 8) & 0xff;
-		one_lun[i].scsi_lun[1] = SAM2_WLUN_REPORT_LUNS & 0xff;
+		one_lun[i].scsi_lun[0] = (SCSI_W_LUN_REPORT_LUNS >> 8) & 0xff;
+		one_lun[i].scsi_lun[1] = SCSI_W_LUN_REPORT_LUNS & 0xff;
 		i++;
 	}
 	alloc_len = (unsigned char *)(one_lun + i) - arr;
@@ -5167,7 +5166,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 		}
 		sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name, b);
 	}
-	has_wlun_rl = (sdp->lun == SAM2_WLUN_REPORT_LUNS);
+	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
 	if ((sdp->lun >= scsi_debug_max_luns) && !has_wlun_rl)
 		return schedule_resp(scp, NULL, errsts_no_connect, 0);
 
@@ -5338,7 +5337,7 @@ static int sdebug_driver_probe(struct device * dev)
 		hpnt->max_id = scsi_debug_num_tgts + 1;
 	else
 		hpnt->max_id = scsi_debug_num_tgts;
-	hpnt->max_lun = SAM2_WLUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
+	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
 
 	host_prot = 0;
 
-- 
2.4.3

