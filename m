From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 13/13] [SCSI] sr: make sure ODD is in resumed state in block ioctl
Date: Mon, 28 May 2012 13:08:40 +0800
Message-ID: <1338181720-4149-14-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32734 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab2E1FJT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 May 2012 01:09:19 -0400
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org

From: Aaron Lu <aaron.lu@amd.com>

When application tries to access the ODD's block device by ioctl,
make sure ODD is in an active state.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/sr.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 72488c2..3da0879 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -654,6 +654,13 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
+	/* Make sure the ODD is not suspended */
+	ret = pm_runtime_get_sync(&sdev->sdev_gendev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(&sdev->sdev_gendev);
+		return -EACCES;
+	}
+
 	mutex_lock(&sr_mutex);
 
 	/*
@@ -685,6 +692,8 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 out:
 	mutex_unlock(&sr_mutex);
+	pm_runtime_mark_last_busy(&cd->device->sdev_gendev);
+	pm_runtime_put_autosuspend(&cd->device->sdev_gendev);
 	return ret;
 }
 
-- 
1.7.2.5

