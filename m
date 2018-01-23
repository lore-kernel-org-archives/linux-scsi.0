From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Remove init_rcu_head() and destroy_rcu_head() calls
Date: Tue, 23 Jan 2018 15:48:21 -0800
Message-ID: <20180123234821.25565-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:22968 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbeAWXsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 18:48:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

According to Documentation/RCU/Design/Requirements/Requirements.html
calling these functions is not necessary for dynamically allocated
objects:

        The corresponding <tt>rcu_head</tt> structures that are
        dynamically allocated are automatically tracked, but
        <tt>rcu_head</tt> structures allocated on the stack
        must be initialized with <tt>init_rcu_head_on_stack()</tt>
        and cleaned up with <tt>destroy_rcu_head_on_stack()</tt>.
        Similarly, statically allocated non-stack <tt>rcu_head</tt>
        structures must be initialized with <tt>init_rcu_head()</tt>
        and cleaned up with <tt>destroy_rcu_head()</tt>.

Hence remove the calls to these functions from the SCSI core.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/scsi/hosts.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index a0a7e4ff255c..7279d3d2e941 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -334,8 +334,6 @@ static void scsi_host_dev_release(struct device *dev)
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 
-	destroy_rcu_head(&shost->rcu);
-
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
 		 * Free the shost_dev device name here if scsi_host_alloc()
@@ -404,7 +402,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
-	init_rcu_head(&shost->rcu);
 
 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
 	if (index < 0)
-- 
2.15.1
