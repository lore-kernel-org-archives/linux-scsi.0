From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v5 12/12] [SCSI] sr: make sure ODD is in resumed state in block ioctl
Date: Mon, 18 Jun 2012 14:26:06 +0800
Message-ID: <1340000766-129148-13-git-send-email-ming.m.lin@intel.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Aaron Lu <aaron.lu@amd.com>

When application tries to access the ODD's block device by ioctl,
make sure ODD is in an active state.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/sr.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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
1.7.10

