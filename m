From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] tcmu: Oops in unmap_thread_fn()
Date: Tue, 1 Aug 2017 23:09:17 +0300
Message-ID: <20170801200917.brigs5x47eujfx7a@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29424 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbdHAUJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 16:09:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Xiubo Li <lixiubo@cmss.chinamobile.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

Calling list_del() on the iterator pointer in list_for_each_entry() will
cause an oops.  We need to user the _safe() version for that.

Fixes: c73d02f63c16 ("tcmu: Add fifo type waiter list support to avoid starvation")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9258b7dd2c30..fd9fcea68d23 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1985,7 +1985,7 @@ static struct target_backend_ops tcmu_ops = {
 
 static int unmap_thread_fn(void *data)
 {
-	struct tcmu_dev *udev;
+	struct tcmu_dev *udev, *tmp;
 	loff_t off;
 	uint32_t start, end, block;
 	static uint32_t free_blocks;
@@ -2056,7 +2056,7 @@ static int unmap_thread_fn(void *data)
 		 * for the global data pool blocks.
 		 */
 		mutex_lock(&root_udev_waiter_mutex);
-		list_for_each_entry(udev, &root_udev_waiter, waiter) {
+		list_for_each_entry_safe(udev, tmp, &root_udev_waiter, waiter) {
 			mutex_lock(&udev->cmdr_lock);
 			if (udev->waiting_blocks < free_blocks) {
 				mutex_unlock(&udev->cmdr_lock);
