From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: pmcraid: fix duplicated code for different branches
Date: Sat, 12 Aug 2017 20:26:32 -0500
Message-ID: <20170813012632.GA4323@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Refactor code in order to avoid identical code for different branches.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
This code was tested by compilation only.

 drivers/scsi/pmcraid.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1f8b153..b4d6cd8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1595,12 +1595,7 @@ static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 	if (pinstance->ccn.hcam->notification_type ==
 	    NOTIFICATION_TYPE_ENTRY_CHANGED &&
 	    cfg_entry->resource_type == RES_TYPE_VSET) {
-
-		if (fw_version <= PMCRAID_FW_VERSION_1)
-			hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;
-		else
-			hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;
-
+		hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;
 	} else if (!pmcraid_expose_resource(fw_version, cfg_entry)) {
 		goto out_notify_apps;
 	}
-- 
2.5.0
