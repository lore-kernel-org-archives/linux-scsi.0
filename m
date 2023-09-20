Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210EDCE79D4
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbjITNzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbjITNzP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96BD185;
        Wed, 20 Sep 2023 06:54:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFF5C433C8;
        Wed, 20 Sep 2023 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218095;
        bh=mOBwbWRdakagjC8RwsqMHAFuRmiiUBYpAp19WoA1g/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvg6vkkzG+YmnpBxbHcD6pHJiqP8UdSN9y3ba0W2bpcpSx09zj03MtZWJjFyUWROj
         DzP20xgH17GWKTGF5yfw0xgQV3Yj4zVmBSM5plgNVpef5t/FNowIbtgklcLiA9B0WA
         jjWKzsCsmt2zafp5hR6smj3VjOcMtuHWEdIKzl0Ju/zMYQAbSg9LGZsFQd2zvQLdfi
         TCiMofgaeE/baUVRNY6qk4OAOt82FM/3wP/zLv6M0eTf/EBPNcpI2J7dq2vVz62cfF
         z362aDMMuWJ4xTvFXFNfDFZn44vsfrA93IKhQB0Fgd/cqcODDEyfaCuXTV/MY3msZB
         Gn9BmXh/EeJ5Q==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v4 07/23] ata: libata-scsi: Fix delayed scsi_rescan_device() execution
Date:   Wed, 20 Sep 2023 22:54:23 +0900
Message-ID: <20230920135439.929695-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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
1) It relies on a PM internal field that should not be used without PM
   device locking protection.
2) The check for is_suspended and the call to scsi_rescan_device() are
   not atomic and a suspend PM event may be triggered between them,
   casuing scsi_rescan_device() to be called on a suspended device and
   in that function blocking while holding the scsi device lock. This
   would deadlock a following resume operation.
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

Fix this by replacing the check on is_suspended with a check on the
return value given by scsi_rescan_device() as that function will fail if
called against a suspended device. Also make sure rescan tasks already
scheduled are first cancelled before suspending an ata port.

Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after device resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 16 ++++++++++++++++
 drivers/ata/libata-scsi.c | 33 +++++++++++++++------------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a0bc01606b30..092372334e92 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5168,11 +5168,27 @@ static const unsigned int ata_port_suspend_ehi = ATA_EHI_QUIET
 
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
index 6ce436992792..ba898eebb259 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4760,7 +4760,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long flags;
-	bool delay_rescan = false;
+	int ret = 0;
 
 	mutex_lock(&ap->scsi_scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
@@ -4769,37 +4769,34 @@ void ata_scsi_dev_rescan(struct work_struct *work)
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
+	/* Reschedule with a delay if scsi_rescan_device() returned an error */
+	if (ret)
 		schedule_delayed_work(&ap->scsi_rescan_task,
 				      msecs_to_jiffies(5));
 }
-- 
2.41.0

