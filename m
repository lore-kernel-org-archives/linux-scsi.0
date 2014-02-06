From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4] scsi,
 libsas: introduce scmd_dbg() to quiet false positive "timeout"
 messages
Date: Thu, 06 Feb 2014 12:23:07 -0800
Message-ID: <20140206202307.5227.44096.stgit@viggo.jf.intel.com>
References: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47644 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbaBFUXL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 15:23:11 -0500
In-Reply-To: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dave.jiang@intel.com, lukasz.dorau@intel.com, Jack Wang <jack_wang@usish.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, artur.paszkiewicz@intel.com, JBottomley@Parallels.com, Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, Xun Ni <xun.ni@intel.com>, Nelson Cheng <nelson.cheng@intel.com>

libsas sometimes short circuits timeouts to force commands into error
recovery.  It is misleading to log that the command timed-out in
sas_scsi_timed_out() when in fact it was just queued for error handling.
It's also redundant in the case of a true timeout as libata eh will
detect and report timeouts via it's AC_ERR_TIMEOUT facility.

Given that some environments consider "timeout" errors to be indicative
of impending device failure demote the sas_scsi_timed_out() timeout
message to be disabled by default.  This parallels ata_scsi_timed_out().

Cc: Jack Wang <jack_wang@usish.com>
Cc: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>
Cc: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Reported-by: Xun Ni <xun.ni@intel.com>
Tested-by: Nelson Cheng <nelson.cheng@intel.com>
Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 include/scsi/scsi_device.h          |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index da3aee17faa5..25d0f127424d 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -862,7 +862,7 @@ out:
 
 enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_DEBUG, cmd, "command %p timed out\n", cmd);
+	scmd_dbg(cmd, "command %p timed out\n", cmd);
 
 	return BLK_EH_NOT_HANDLED;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec2533d..067ac9f1607c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -235,12 +235,24 @@ struct scsi_dh_data {
 #define sdev_printk(prefix, sdev, fmt, a...)	\
 	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
 
+#define sdev_dbg(sdev, fmt, a...) \
+	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
+
 #define scmd_printk(prefix, scmd, fmt, a...)				\
         (scmd)->request->rq_disk ?					\
 	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
 		    (scmd)->request->rq_disk->disk_name, ##a) :		\
 	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
+#define scmd_dbg(scmd, fmt, a...)					   \
+        do {								   \
+		if ((scmd)->request->rq_disk)				   \
+			sdev_dbg((scmd)->device, "[%s] " fmt,		   \
+				 (scmd)->request->rq_disk->disk_name, ##a);\
+		else							   \
+			sdev_dbg((scmd)->device, fmt, ##a);		   \
+	} while (0)
+
 enum scsi_target_state {
 	STARGET_CREATED = 1,
 	STARGET_RUNNING,

