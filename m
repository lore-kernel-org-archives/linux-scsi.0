Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC6550A67;
	Tue, 19 Mar 2024 07:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710832333; cv=none; b=tI+YsWkMDFgzF6J+E7NGRLQk3z0KPWn1NIOPFtE3PenDOzvpikpOOYPCJhOlQJeDaYi1wdnT+UulseJeCqB6WzjN0giqKzzZGqpDZ7h7zCWBEnoZZemLbtKNw6zkBnNoZ/6OSEp2PamYjyZF3NX+zh/7WgBtjmJ7aw572ENDFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710832333; c=relaxed/simple;
	bh=P6dv7ZJYNZSpHjoI+V+tD8KMVwQ6xbrIQm3h9JQ1Vxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uTlyahdcIGDYXlTeFTZGM5f29ji079GLAM0O1OfdDwK9YGkoazBfNSw/WvgCFjpTe/MuK9IYuzIZASJsElvtafdwklYrRdi6dFwiMj6utwfBlJUxKhJFPUCKJ52YrAz84Ytv2kYq8LrkH0w/61ppG5b43kB2Y3hDtgQmLRor934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qh1GlINA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qh1GlINA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958E1C433C7;
	Tue, 19 Mar 2024 07:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710832332;
	bh=P6dv7ZJYNZSpHjoI+V+tD8KMVwQ6xbrIQm3h9JQ1Vxc=;
	h=From:To:Cc:Subject:Date:From;
	b=qh1GlINAcfAyZx2RGqDjtBTgqvmcRwU32pRiS2WigoifhSlgYj2+kfFIjifx85gAd
	 3bAaV+oi6zQPUzdh2kwEgwVVt9Zv3f1zcX4iojn21QJvPfXhSwwERN6xuNLu2z3kIb
	 qMwDu4XYlr08/iTUn8cGee4oI1LPF7rhYisxCbiQlFTeG6SV7SOu+w61yai352i7XQ
	 /AtT71PquC1qwikVmDeRgYFE7ZZZPrt1+Lsi8++Arxtj6Ox/EY5id6AaVCLKh9OO71
	 3+B57wJPokxRZAip+mY/mLckDGoNxcccEWuWaSdjlachGFoboemCtP/Br7NL3+bU7c
	 cQ79YN7xfLxSA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	desgua@gmail.com
Subject: [PATCH] scsi: sd: Fix TCG OPAL unlock on system resume
Date: Tue, 19 Mar 2024 16:12:09 +0900
Message-ID: <20240319071209.1179257-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 3cc2ffe5c16d introduced the manage_system_start_stop scsi device
flag to allow libata to indicate to the scsi disk driver that nothing
should be done when resuming a disk on system resume. This change turned
the execution of sd_resume() into a no-op for ATA devices on system
resume. While this solved deadlock issues during device resume, this
change also wrongly removed the execution of opal_unlock_from_suspend().
As a result, devices with TCG OPAL locking enabled remain locked and
inaccessible after a system resume from sleep.

To fix this issue, introduce the scsi driver resume method and implement
it with the sd_resume() function calling opal_unlock_from_suspend(). The
former sd_resume() function is renamed to sd_resume_common() and
modified to call the new sd_resume() function. For non-ata devices, this
result in no functional changes.

Inorder for libata to explicitly execute sd_resume() when a device is
resumed during system re-start, the function scsi_resume_device() is
introduced. libata calls this function from the revalidation work
executed on devie resume, a state that is indicated with the new device
flag ATA_DFLAG_RESUMING. Doing so, locked TCG OPAL enabled devices are
unlocked on resume, allowing normal operation.

Fixes: 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime start/stop management")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218538
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c    |  5 ++++-
 drivers/ata/libata-scsi.c  |  9 +++++++++
 drivers/scsi/scsi_scan.c   | 34 ++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          | 23 +++++++++++++++++++----
 include/linux/libata.h     |  1 +
 include/scsi/scsi_driver.h |  1 +
 include/scsi/scsi_host.h   |  1 +
 7 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b0d6e69c4a5b..214b935c2ced 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -712,8 +712,10 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 				ehc->saved_ncq_enabled |= 1 << devno;
 
 			/* If we are resuming, wake up the device */
-			if (ap->pflags & ATA_PFLAG_RESUMING)
+			if (ap->pflags & ATA_PFLAG_RESUMING) {
+				dev->flags |= ATA_DFLAG_RESUMING;
 				ehc->i.dev_action[devno] |= ATA_EH_SET_ACTIVE;
+			}
 		}
 	}
 
@@ -3169,6 +3171,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 	return 0;
 
  err:
+	dev->flags &= ~ATA_DFLAG_RESUMING;
 	*r_failed_dev = dev;
 	return rc;
 }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0a0f483124c3..2f4c58837641 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4730,6 +4730,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long flags;
+	bool do_resume;
 	int ret = 0;
 
 	mutex_lock(&ap->scsi_scan_mutex);
@@ -4751,7 +4752,15 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 			if (scsi_device_get(sdev))
 				continue;
 
+			do_resume = dev->flags & ATA_DFLAG_RESUMING;
+
 			spin_unlock_irqrestore(ap->lock, flags);
+			if (do_resume) {
+				ret = scsi_resume_device(sdev);
+				if (ret == -EWOULDBLOCK)
+					goto unlock;
+				dev->flags &= ~ATA_DFLAG_RESUMING;
+			}
 			ret = scsi_rescan_device(sdev);
 			scsi_device_put(sdev);
 			spin_lock_irqsave(ap->lock, flags);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8d06475de17a..ffd7e7e72933 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1642,6 +1642,40 @@ int scsi_add_device(struct Scsi_Host *host, uint channel,
 }
 EXPORT_SYMBOL(scsi_add_device);
 
+int scsi_resume_device(struct scsi_device *sdev)
+{
+	struct device *dev = &sdev->sdev_gendev;
+	int ret = 0;
+
+	device_lock(dev);
+
+	/*
+	 * Bail out if the device or its queue are not running. Otherwise,
+	 * the rescan may block waiting for commands to be executed, with us
+	 * holding the device lock. This can result in a potential deadlock
+	 * in the power management core code when system resume is on-going.
+	 */
+	if (sdev->sdev_state != SDEV_RUNNING ||
+	    blk_queue_pm_only(sdev->request_queue)) {
+		ret = -EWOULDBLOCK;
+		goto unlock;
+	}
+
+	if (dev->driver && try_module_get(dev->driver->owner)) {
+		struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+		if (drv->resume)
+			ret = drv->resume(dev);
+		module_put(dev->driver->owner);
+	}
+
+unlock:
+	device_unlock(dev);
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_resume_device);
+
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2cc73c650ca6..7a5ad9b25ab7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4003,7 +4003,21 @@ static int sd_suspend_runtime(struct device *dev)
 	return sd_suspend_common(dev, true);
 }
 
-static int sd_resume(struct device *dev, bool runtime)
+static int sd_resume(struct device *dev)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
+	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
+		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int sd_resume_common(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	int ret;
@@ -4019,7 +4033,7 @@ static int sd_resume(struct device *dev, bool runtime)
 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
-		opal_unlock_from_suspend(sdkp->opal_dev);
+		sd_resume(dev);
 		sdkp->suspended = false;
 	}
 
@@ -4038,7 +4052,7 @@ static int sd_resume_system(struct device *dev)
 		return 0;
 	}
 
-	return sd_resume(dev, false);
+	return sd_resume_common(dev, false);
 }
 
 static int sd_resume_runtime(struct device *dev)
@@ -4065,7 +4079,7 @@ static int sd_resume_runtime(struct device *dev)
 				  "Failed to clear sense data\n");
 	}
 
-	return sd_resume(dev, true);
+	return sd_resume_common(dev, true);
 }
 
 static const struct dev_pm_ops sd_pm_ops = {
@@ -4088,6 +4102,7 @@ static struct scsi_driver sd_template = {
 		.pm		= &sd_pm_ops,
 	},
 	.rescan			= sd_rescan,
+	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
 	.done			= sd_done,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 26d68115afb8..324d792e7c78 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -107,6 +107,7 @@ enum {
 
 	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 20), /* Priority cmds sent to dev */
 	ATA_DFLAG_CDL_ENABLED	= (1 << 21), /* cmd duration limits is enabled */
+	ATA_DFLAG_RESUMING	= (1 << 22),  /* Device is resuming */
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 4ce1988b2ba0..f40915d2ecee 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -12,6 +12,7 @@ struct request;
 struct scsi_driver {
 	struct device_driver	gendrv;
 
+	int (*resume)(struct device *);
 	void (*rescan)(struct device *);
 	blk_status_t (*init_command)(struct scsi_cmnd *);
 	void (*uninit_command)(struct scsi_cmnd *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b259d42a1e1a..129001f600fc 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -767,6 +767,7 @@ scsi_template_proc_dir(const struct scsi_host_template *sht);
 #define scsi_template_proc_dir(sht) NULL
 #endif
 extern void scsi_scan_host(struct Scsi_Host *);
+extern int scsi_resume_device(struct scsi_device *sdev);
 extern int scsi_rescan_device(struct scsi_device *sdev);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
-- 
2.44.0

