Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69583C11F6A
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 08:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D2561CD7
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 08:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhF3IsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 04:48:13 -0400
Received: from comms.puri.sm ([159.203.221.185]:59144 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233597AbhF3IsH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 04:48:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id B2C16E0304;
        Wed, 30 Jun 2021 01:45:08 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fRWSAhGHjiXu; Wed, 30 Jun 2021 01:45:07 -0700 (PDT)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     martin.kepplinger@puri.sm, bvanassche@acm.org
Cc:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, kernel@puri.sm,
        stern@rowland.harvard.edu
Subject: [PATCH v5 2/3] scsi: sd: send REQUEST SENSE for BLIST_MEDIA_CHANGE devices in runtime_resume()
Date:   Wed, 30 Jun 2021 10:44:52 +0200
Message-Id: <20210630084453.186764-3-martin.kepplinger@puri.sm>
In-Reply-To: <20210630084453.186764-1-martin.kepplinger@puri.sm>
References: <20210630084453.186764-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SD cardreader devices that have the BLIST_MEDIA_CHANGE flag set,
a MEDIA CHANGE unit attention is received after resuming from runtime
suspend. Send a REQUEST SENSE to avoid that.

The "downside" is that for these devices we now rely on users not to
really change the medium (SD card) *during* a runtime suspend/resume
cycle, i.e. when not unmounting.

To enable runtime PM for an SD cardreader (device number 0:0:0:0), do:

echo 0 > /sys/module/block/parameters/events_dfl_poll_msecs
echo 1000 > /sys/bus/scsi/devices/0:0:0:0/power/autosuspend_delay_ms
echo auto > /sys/bus/scsi/devices/0:0:0:0/power/control

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/sd.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6d2d63629a90..b02378f40620 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -63,6 +63,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
@@ -114,6 +115,7 @@ static void sd_shutdown(struct device *);
 static int sd_suspend_system(struct device *);
 static int sd_suspend_runtime(struct device *);
 static int sd_resume(struct device *);
+static int sd_resume_runtime(struct device *);
 static void sd_rescan(struct device *);
 static blk_status_t sd_init_command(struct scsi_cmnd *SCpnt);
 static void sd_uninit_command(struct scsi_cmnd *SCpnt);
@@ -608,7 +610,7 @@ static const struct dev_pm_ops sd_pm_ops = {
 	.poweroff		= sd_suspend_system,
 	.restore		= sd_resume,
 	.runtime_suspend	= sd_suspend_runtime,
-	.runtime_resume		= sd_resume,
+	.runtime_resume		= sd_resume_runtime,
 };
 
 static struct scsi_driver sd_template = {
@@ -3720,6 +3722,28 @@ static int sd_resume(struct device *dev)
 	return ret;
 }
 
+static int sd_resume_runtime(struct device *dev)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_device *sdp = sdkp->device;
+	int timeout, res;
+
+	timeout = sdp->request_queue->rq_timeout * SD_FLUSH_TIMEOUT_MULTIPLIER;
+
+	if (sdp->sdev_bflags & BLIST_MEDIA_CHANGE) {
+		/* clear the devices' sense data */
+		static const u8 cmd[10] = { REQUEST_SENSE };
+
+		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
+				   NULL, timeout, 1, 0, RQF_PM, NULL);
+		if (res)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Failed to clear sense data\n");
+	}
+
+	return sd_resume(dev);
+}
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).
-- 
2.30.2

