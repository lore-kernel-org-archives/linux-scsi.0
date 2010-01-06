From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 3/3] be2iscsi: Fix to allow driver to load when the FW
 allows more cids
Date: Thu, 7 Jan 2010 01:51:44 +0530
Message-ID: <20100106202130.GA19945@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:26927 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756017Ab0AFUVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 15:21:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This fix allows the driver to load when the FW allows more cids
than than the driver supports. The driver will limit the number of cid
to what it can support. There was no reason to fail the driver load,so,
correcting that

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 18f8041..b0bb54d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -49,12 +49,12 @@ unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 		phba->fw_config.iscsi_cid_count =
 					pfw_cfg->ulp[0].sq_count;
 		if (phba->fw_config.iscsi_cid_count > (BE2_MAX_SESSIONS / 2)) {
-			status = 1;
-			shost_printk(KERN_WARNING, phba->shost,
-			     "FW reported MAX CXNS as %d \t"
-			     "Max Supported = %d. Failing to load \n",
-					phba->fw_config.iscsi_cid_count,
-					BE2_MAX_SESSIONS);
+			SE_DEBUG(DBG_LVL_8,
+				"FW reported MAX CXNS as %d \t"
+				"Max Supported = %d.\n",
+				phba->fw_config.iscsi_cid_count,
+				BE2_MAX_SESSIONS);
+			phba->fw_config.iscsi_cid_count = BE2_MAX_SESSIONS / 2;
 		}
 	} else {
 		shost_printk(KERN_WARNING, phba->shost,
-- 
1.6.4

