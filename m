From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/4] bnx2fc: fix panic in bnx2fc_post_io_req
Date: Mon, 23 Jan 2012 18:00:46 -0800
Message-ID: <1327370449-28168-2-git-send-email-bprakash@broadcom.com>
References: <1327370449-28168-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3263 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab2AXCBA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 21:01:00 -0500
In-Reply-To: <1327370449-28168-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, mchan@broadcom.com

System panics while accessing stale pointer - timer_work_queue - in the IO path
before bnx2fc_stop is called. Fix is to destroy the workqueue after the destroy
operation is complete.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8c6156a..10cf5d9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1537,6 +1537,7 @@ static void __bnx2fc_destroy(struct bnx2fc_interface *interface)
 static int bnx2fc_destroy(struct net_device *netdev)
 {
 	struct bnx2fc_interface *interface = NULL;
+	struct workqueue_struct *timer_work_queue;
 	int rc = 0;
 
 	rtnl_lock();
@@ -1549,9 +1550,9 @@ static int bnx2fc_destroy(struct net_device *netdev)
 		goto netdev_err;
 	}
 
-
-	destroy_workqueue(interface->timer_work_queue);
+	timer_work_queue = interface->timer_work_queue;
 	__bnx2fc_destroy(interface);
+	destroy_workqueue(timer_work_queue);
 
 netdev_err:
 	mutex_unlock(&bnx2fc_dev_lock);
-- 
1.7.0.6


