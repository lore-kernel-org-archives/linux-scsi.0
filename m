From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 1/3] [SCSI]: runtime resume parent for child's system-resume
Date: Thu, 22 Dec 2011 14:50:47 +0800
Message-ID: <1324536649-5796-2-git-send-email-ming.m.lin@intel.com>
References: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab1LVGvF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2011 01:51:05 -0500
In-Reply-To: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

[Patch description from Alan Stern]

If a child device was runtime-suspended when a system suspend began,
then there will be nothing to prevent its parent from
runtime-suspending as soon as it is woken up during the system resume.
Then when the time comes to resume the child, the resume will fail
because the parent is already back at low power.

On the other hand, there are some devices which should remain at low
power across an entire suspend-resume cycle.  The details depend on the
device and the platform.

This suggests that the PM core is not the right place to solve the
problem. One possible solution is for the subsystem or device driver
to call pm_runtime_get_sync(dev->parent) at the start of the
system-resume procedure and pm_runtime_put_sync(dev->parent) at the
end.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 62b8fba..aaf5dfa 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -71,8 +71,17 @@ static int scsi_bus_resume_common(struct device *dev)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * Parent device may have runtime suspended as soon as
+		 * it is woken up during the system resume.
+		 *
+		 * Resume it on behalf of child.
+		 */
+		pm_runtime_get_sync(dev->parent);
 		err = scsi_dev_type_resume(dev);
+		pm_runtime_put_sync(dev->parent);
+	}
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
-- 
1.7.2.5

