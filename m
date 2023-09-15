Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F82DEE643D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjIOIZ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjIOIZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:25:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FBE4215;
        Fri, 15 Sep 2023 01:23:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C598C433CD;
        Fri, 15 Sep 2023 08:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765721;
        bh=xXVwedrZT/LFdUWhRCXCKcCASpb8VmRoyYMVCjOGXCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIg2UnOx2Ra8lcIx5yASvpJwUkpHWbUZ5yJMbkwyocAMtPlzO6YIn8nF71EBWkTW8
         37a2i5lOwk7DS0JvLbNlCCFxVf7UY+BkO3eff36+XHiuOjPxHeMqDnarJAmh+kmmtf
         6Lqg6bNgXj+MVVnhEvpTEzX9Muy2Az2mEaIWPOTmOyOYqbmb0yDAeiiAkaVeB5RO4V
         7q9oXahE9h6rJZoCsDr0UBmV+9gGAkNJRCOCF8I8ECK3DJYWXH9OaN95k9XTFVyTlE
         RyUZyBTfjf3Bjf2ex2OsB8HyLAYyvVEVwnPz3ZT6M020OmjAwGlhBJucHFEzOwM61e
         QfbeqAPegK9cw==
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
Subject: [PATCH v3 06/23] scsi: Do not attempt to rescan suspended devices
Date:   Fri, 15 Sep 2023 17:14:50 +0900
Message-ID: <20230915081507.761711-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_rescan_device() takes a scsi device lock before executing a device
handler and device driver rescan methods. Waiting for the completion of
any command issued to the device by these methods will thus be done with
the device lock held. As a result, there is a risk of deadlocking within
the power management code if scsi_rescan_device() is called to handle a
device resume with the associated scsi device not yet resumed.

Avoid such situation by checking that the target scsi device is in the
running state, that is, fully capable of executing commands, before
proceeding with the rescan and bailout returning -EWOULDBLOCK otherwise.
With this error return, the caller can retry rescaning the device after
a delay.

The state check is done with the device lock held and is thus safe
against incoming suspend power management operations.

Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after device resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 18 +++++++++++++++++-
 include/scsi/scsi_host.h |  2 +-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 52014b2d39e1..3db4d31a03a1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1619,12 +1619,24 @@ int scsi_add_device(struct Scsi_Host *host, uint channel,
 }
 EXPORT_SYMBOL(scsi_add_device);
 
-void scsi_rescan_device(struct scsi_device *sdev)
+int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	int ret = 0;
 
 	device_lock(dev);
 
+	/*
+	 * Bail out if the device is not running. Otherwise, the rescan may
+	 * block waiting for commands to be executed, with us holding the
+	 * device lock. This can result in a potential deadlock in the power
+	 * management core code when system resume is on-going.
+	 */
+	if (sdev->sdev_state != SDEV_RUNNING) {
+		ret = -EWOULDBLOCK;
+		goto unlock;
+	}
+
 	scsi_attach_vpd(sdev);
 	scsi_cdl_check(sdev);
 
@@ -1638,7 +1650,11 @@ void scsi_rescan_device(struct scsi_device *sdev)
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

