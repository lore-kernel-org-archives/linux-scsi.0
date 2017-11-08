From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] tcmu: Add a missing unlock on an error path
Date: Wed, 8 Nov 2017 11:44:15 +0300
Message-ID: <20171108084415.dn443crpreqwqoiw@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19356 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdKHIpH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 03:45:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

We added a new error path here but we forgot to drop the lock first
before returning.

Fixes: 0d44374c1aae ("tcmu: fix double se_cmd completion")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 07f2d95f7ae7..cc2468a299d3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -888,6 +888,7 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	ret = tcmu_setup_cmd_timer(tcmu_cmd);
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
+		mutex_unlock(&udev->cmdr_lock);
 		return TCM_OUT_OF_RESOURCES;
 	}
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
