From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 08/10] fcoe,
	libfc: fix an libfc issue with queue ramp down in libfc
Date: Thu, 03 Sep 2009 15:23:10 -0700
Message-ID: <20090903222310.24946.70140.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13695 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbZICWXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:23:20 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

The cmd_per_lun value is used by scsi-ml as fall back lowest
queue_depth value but in case of libfc cmd_per_lun is set to
same value as max queue_depth = 32.

So this patch reduces cmd_per_lun value to 3 and configures
each lun with default max queue_depth 32 in fc_slave_alloc.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/fcoe/fcoe.c    |    2 +-
 drivers/scsi/libfc/fc_fcp.c |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 757aa28..49dff32 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -125,7 +125,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
-	.cmd_per_lun = 32,
+	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = SG_ALL,
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index d919c2a..b49f48b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2031,18 +2031,16 @@ EXPORT_SYMBOL(fc_eh_host_reset);
 int fc_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	int queue_depth;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	if (sdev->tagged_supported) {
-		if (sdev->host->hostt->cmd_per_lun)
-			queue_depth = sdev->host->hostt->cmd_per_lun;
-		else
-			queue_depth = FC_FCP_DFLT_QUEUE_DEPTH;
-		scsi_activate_tcq(sdev, queue_depth);
-	}
+	if (sdev->tagged_supported)
+		scsi_activate_tcq(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
+	else
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
+					FC_FCP_DFLT_QUEUE_DEPTH);
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_slave_alloc);

