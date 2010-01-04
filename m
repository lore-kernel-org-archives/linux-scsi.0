From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 08/12] be2iscsi: No requirement for endianess change for
 data_count
Date: Tue, 5 Jan 2010 05:10:01 +0530
Message-ID: <20100104233949.GA16839@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:14927 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753709Ab0ADXjj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:39:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch removes the endianess change that was wrongly
added for data_count

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 26d7016..6170548 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3607,7 +3607,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	}
 
 	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb,
-		      be32_to_cpu(task->data_count));
+		      task->data_count);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
 		      io_task->pwrb_handle->nxt_wrb_index);
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
-- 
1.6.4

