From: Vasu Dev <vasu.dev@intel.com>
Subject: [RFC PATCH 8/9] fcoe,
	libfc: fix an libfc issue with queue ramp down in libfc
Date: Wed, 26 Aug 2009 11:03:58 -0700
Message-ID: <20090826180357.23396.6196.stgit@vi1.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16922 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbZHZSDz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 14:03:55 -0400
In-Reply-To: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

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
index 704b8e0..64fd867 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -137,7 +137,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
-	.cmd_per_lun = 32,
+	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = SG_ALL,
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 4037685..dda4162 100644
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

