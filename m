From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 09/20] be2iscsi: Free tags allocated
Date: Mon, 12 Jul 2010 23:23:49 +0530
Message-ID: <20100712175339.GA11572@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:32759 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756395Ab0GLRxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:53:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

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

