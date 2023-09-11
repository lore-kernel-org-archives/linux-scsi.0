Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6401EE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbjIKECm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjIKECg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AFAFE;
        Sun, 10 Sep 2023 21:02:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BC1C433C8;
        Mon, 11 Sep 2023 04:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404950;
        bh=DyqUZLqQHVi6SSGrporwKnrSUQi2hMJhoHLQMR+Pj14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMDDaY8FJa7li4RlnjTalxBdClK6vojIjMZ8JFQhBZArBBP1HeWjeLPv3B/L2LCT6
         /7gPKFfKJlp4MIfTvzUMts7cBXpyJdBJXxJlcAdcGgQxSKtBNZnZf3PETxB5Sg+Dr8
         LH89XsFAyG5oS8cT6MU9WjLHBpqYEfKW7cn22Rekybp4Lu7pteEiXwOtN2g67j07wq
         t+5Sk+3wEZJ85OwwTYkRSWAzF5B1c/eYTmWu+WeKUUzjVqrdhh70mtfvh9B4Gt99XN
         x8/31R1FL8lZEXL2Stne5Tnv1O+LtOW1/3jg5dw5fqk+fs3R9QUO10S0qesxu8PPWa
         48IK0T940s0lg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 05/19] ata: libata-scsi: Fix delayed scsi_rescan_device() execution
Date:   Mon, 11 Sep 2023 13:02:03 +0900
Message-ID: <20230911040217.253905-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after
device resume") modified ata_scsi_dev_rescan() to check the scsi device
"is_suspended" power field to ensure that the scsi device associated
with an ATA device is fully resumed when scsi_rescan_device() is
executed. However, this fix is problematic as:
1) it relies on a PM internal field that should not be used without PM
   device locking protection.
2) The check for is_suspended and the call to ata_scsi_dev_rescan() are
   not atomic and a suspend PM even may be triggered between them,
   casuing ata_scsi_dev_rescan() to be called on a suspended device,
   resulting in that function blocking while holding the scsi device
   lock, which would deadlock a following resume operation.
These problems can trigger PM deadlocks on resume, especially with
resume operations triggered quickly after or during suspend operations.
E.g., a simple bash script like:

for (( i=0; i<10; i++ )); do
	echo "+2 > /sys/class/rtc/rtc0/wakealarm
	echo mem > /sys/power/state
done

that triggers a resume 2 seconds after starting suspending a system can
quickly lead to a PM deadlock preventing the system from correctly
resuming.

Fix this by replacing the check on is_suspended with a check on the scsi
device state inside ata_scsi_dev_rescan(), while holding the scsi device
lock, thus making the device rescan atomic with regard to PM operations.
Additionnly, make sure that scheduled rescan tasks are first cancelled
before suspending an ata port.

Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after device resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-core.c | 16 ++++++++++++++++
 drivers/ata/libata-scsi.c | 36 ++++++++++++++++++------------------
 drivers/scsi/scsi_scan.c  | 12 +++++++++++-
 include/scsi/scsi_host.h  |  2 +-
 4 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0cf0caf77907..0479493e54bd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5172,11 +5172,27 @@ static const unsigned int ata_port_suspend_ehi = ATA_EHI_QUIET
 
 static void ata_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
+	/*
+	 * We are about to suspend the port, so we do not care about
+	 * scsi_rescan_device() calls scheduled by previous resume operations.
+	 * The next resume will schedule the rescan again. So cancel any rescan
+	 * that is not done yet.
+	 */
+	cancel_delayed_work_sync(&ap->scsi_rescan_task);
+
 	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, false);
 }
 
 static void ata_port_suspend_async(struct ata_port *ap, pm_message_t mesg)
 {
+	/*
+	 * We are about to suspend the port, so we do not care about
+	 * scsi_rescan_device() calls scheduled by previous resume operations.
+	 * The next resume will schedule the rescan again. So cancel any rescan
+	 * that is not done yet.
+	 */
+	cancel_delayed_work_sync(&ap->scsi_rescan_task);
+
 	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, true);
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9bb1ace8bf79..f2d4460ab450 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4750,7 +4750,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long flags;
-	bool delay_rescan = false;
+	int ret = 0;
 
 	mutex_lock(&ap->scsi_scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
@@ -4759,37 +4759,37 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 		ata_for_each_dev(dev, link, ENABLED) {
 			struct scsi_device *sdev = dev->sdev;
 
+			/*
+			 * If the port was suspended before this was scheduled,
+			 * bail out.
+			 */
+			if (ap->pflags & ATA_PFLAG_SUSPENDED)
+				goto unlock;
+
 			if (!sdev)
 				continue;
 			if (scsi_device_get(sdev))
 				continue;
 
-			/*
-			 * If the rescan work was scheduled because of a resume
-			 * event, the port is already fully resumed, but the
-			 * SCSI device may not yet be fully resumed. In such
-			 * case, executing scsi_rescan_device() may cause a
-			 * deadlock with the PM code on device_lock(). Prevent
-			 * this by giving up and retrying rescan after a short
-			 * delay.
-			 */
-			delay_rescan = sdev->sdev_gendev.power.is_suspended;
-			if (delay_rescan) {
-				scsi_device_put(sdev);
-				break;
-			}
-
 			spin_unlock_irqrestore(ap->lock, flags);
-			scsi_rescan_device(sdev);
+			ret = scsi_rescan_device(sdev);
 			scsi_device_put(sdev);
 			spin_lock_irqsave(ap->lock, flags);
+
+			if (ret)
+				goto unlock;
 		}
 	}
 
+unlock:
 	spin_unlock_irqrestore(ap->lock, flags);
 	mutex_unlock(&ap->scsi_scan_mutex);
 
-	if (delay_rescan)
+	/*
+	 * Reschedule with a delay if scsi_rescan_device() returned an error
+	 * and the port has not been suspended.
+	 */
+	if (ret && !(ap->pflags & ATA_PFLAG_SUSPENDED))
 		schedule_delayed_work(&ap->scsi_rescan_task,
 				      msecs_to_jiffies(5));
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 52014b2d39e1..6650f63afec9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1619,12 +1619,18 @@ int scsi_add_device(struct Scsi_Host *host, uint channel,
 }
 EXPORT_SYMBOL(scsi_add_device);
 
-void scsi_rescan_device(struct scsi_device *sdev)
+int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	int ret = 0;
 
 	device_lock(dev);
 
+	if (sdev->sdev_state != SDEV_RUNNING) {
+		ret = -ENXIO;
+		goto unlock;
+	}
+
 	scsi_attach_vpd(sdev);
 	scsi_cdl_check(sdev);
 
@@ -1638,7 +1644,11 @@ void scsi_rescan_device(struct scsi_device *sdev)
 			drv->rescan(dev);
 		module_put(dev->driver->owner);
 	}
+
+unlock:
 	device_unlock(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 49f768d0ff37..4c2dc8150c6d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -764,7 +764,7 @@ scsi_template_proc_dir(const struct scsi_host_template *sht);
 #define scsi_template_proc_dir(sht) NULL
 #endif
 extern void scsi_scan_host(struct Scsi_Host *);
-extern void scsi_rescan_device(struct scsi_device *);
+extern int scsi_rescan_device(struct scsi_device *sdev);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern int scsi_host_busy(struct Scsi_Host *shost);
-- 
2.41.0

