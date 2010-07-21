From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 08/19] be2iscsi: Free tags allocated
Date: Thu, 22 Jul 2010 04:24:22 +0530
Message-ID: <20100721225409.GA9479@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:24884 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755483Ab0GUWyH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:54:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, "michaelc@cs.wisc.edu:wq"@serverengines.com

 This patch  frees tags that are already allocated in case of
failure

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index dcb70fa..3036d9e 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -168,6 +168,7 @@ unsigned int  mgmt_invalidate_icds(struct beiscsi_hba *phba,
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to alloc memory for mgmt_invalidate_icds\n");
 		spin_unlock(&ctrl->mbox_lock);
+		free_mcc_tag(&phba->ctrl, tag);
 		return 0;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -330,6 +331,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		shost_printk(KERN_ERR, phba->shost, "unknown addr family %d\n",
 			     dst_addr->sa_family);
 		spin_unlock(&ctrl->mbox_lock);
+		free_mcc_tag(&phba->ctrl, tag);
 		return -EINVAL;
 
 	}
-- 
1.6.5.2

