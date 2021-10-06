Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D72BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F4B611C6
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbhJFV5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 17:57:01 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:39612 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbhJFV5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 17:57:00 -0400
Received: by mail-pf1-f179.google.com with SMTP id g2so3553749pfc.6
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 14:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7Lnkklrw/Bc5zy7tpo9PDXMLIKYO82R/Z+qX72F/yU=;
        b=3v9uUV3qLxIUhP3QH+uCWuWg4jQ9pLEmWNXiL2CWHq+C+fH7Fpm5qvDETywthJoc5A
         I29FBDZjkqN0LnHSWeWrtGRlX/rdrjfJlpQjxYKHJXd28yaPGF9V6FExHY27BXXf9keN
         uURMy2qaxta84c4R/ZiTNLHBzgbWP1JHrgcuxpYiPv0fQx9wFcq5oW1s45nIT6JkFMbj
         ENknFxfjxtMdZgA907i624CxBeF1FljDITIqkKRTn9zg3wv8t3H2Q40EZQ2WZ5ME06lZ
         QU2Ui866LHUrIF7AK/b8RhDhN4yAqjo5WW8YtlyKfVT4z0H32PFM0R9MRoE+4tzGW3JX
         7Kvg==
X-Gm-Message-State: AOAM530M0rttqN65+aPdnKEZdqyX6Puz0faRRD5SdEpdU2/1n33lEies
        mDAjfw4Q8Tbj76xLy3SXDAC5zURwpwY=
X-Google-Smtp-Source: ABdhPJws9vNBzg5dHmIQwSJasqB6JhWjxT7VuCm9mlAXEo+kr11FuX5fl76/zIsVkCy54/6MUq1XjA==
X-Received: by 2002:a63:4606:: with SMTP id t6mr373297pga.388.1633557307571;
        Wed, 06 Oct 2021 14:55:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7a81:1c54:a610:d139])
        by smtp.gmail.com with ESMTPSA id x7sm5902586pjl.55.2021.10.06.14.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 14:55:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 3/3] scsi: pm: Only runtime resume if necessary
Date:   Wed,  6 Oct 2021 14:54:53 -0700
Message-Id: <20211006215453.3318929-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20211006215453.3318929-1-bvanassche@acm.org>
References: <20211006215453.3318929-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following query shows which drivers define callbacks that are called
by the power management support code in the SCSI core (scsi_pm.c):

$ git grep -nHEwA16 "$(echo $(git grep -h 'scsi_register_driver(&' |
      sed 's/.*&//;s/\..*//') | sed 's/ /|/g')" |
    grep '\.pm[[:blank:]]*=[[:blank:]]'
drivers/scsi/sd.c-620-		.pm		= &sd_pm_ops,
drivers/scsi/sr.c-100-		.pm		= &sr_pm_ops,
drivers/scsi/ufs/ufshcd.c-9765-		.pm = &ufshcd_wl_pm_ops,

Since unconditionally runtime resuming a device during system resume is
not necessary, remove that code. Modify the SCSI disk (sd) driver such
that it follows the same approach as the UFS driver, namely to skip
system suspend and resume for devices that are runtime suspended. The
CD-ROM code does not need to be updated since its PM callbacks do not
affect the device power state.

This patch has been tested as follows:

[ shell 1 ]

cd /sys/kernel/debug/tracing
grep -E 'blk_(pre|post)_runtime|runtime_(suspend|resume)|autosuspend_delay|pm_runtime_(get|put)' available_filter_functions |
  while read a b; do echo "$a"; done |
  grep -v __pm_runtime_resume >set_ftrace_filter
echo function > current_tracer
echo 1 > tracing_on
cat trace_pipe

[ shell 2 ]

cd /sys/block/sr0
 # Increase the event poll interval to make it easier to derive from the
 # tracing output whether runtime power actions are the result of sg_inq.
echo 30000 > events_poll_msecs
cd device/power
 # Enable runtime power management.
echo auto > control
echo 1000 > autosuspend_delay_ms
sleep 1
 # Verify in shell 1 that sr0 has been runtime suspended
sg_inq /dev/sr0
eject /dev/sr0
sg_inq /dev/sr0
 # Disable runtime power management.
echo on > control

cd /sys/block/sda/device/power
echo auto > control
echo 1000 > autosuspend_delay_ms
sleep 1
 # Verify in shell 1 that sr0 has been runtime suspended
sg_inq /dev/sda

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_pm.c | 69 +++++++++---------------------------------
 drivers/scsi/sd.c      |  6 ++++
 2 files changed, 20 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 50b6bad4df79..b5a858c29488 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -66,71 +66,30 @@ static int scsi_dev_type_suspend(struct device *dev,
 	return err;
 }
 
-static int scsi_dev_type_resume(struct device *dev,
-		int (*cb)(struct device *, const struct dev_pm_ops *))
-{
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	int err = 0;
-
-	err = cb(dev, pm);
-	scsi_device_resume(to_scsi_device(dev));
-	dev_dbg(dev, "scsi resume: %d\n", err);
-
-	if (err == 0) {
-		pm_runtime_disable(dev);
-		err = pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-
-		/*
-		 * Forcibly set runtime PM status of request queue to "active"
-		 * to make sure we can again get requests from the queue
-		 * (see also blk_pm_peek_request()).
-		 *
-		 * The resume hook will correct runtime PM status of the disk.
-		 */
-		if (!err && scsi_is_sdev_device(dev)) {
-			struct scsi_device *sdev = to_scsi_device(dev);
-
-			blk_set_runtime_active(sdev->request_queue);
-		}
-	}
-
-	return err;
-}
-
 static int
 scsi_bus_suspend_common(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
-	int err = 0;
+	if (!scsi_is_sdev_device(dev))
+		return 0;
 
-	if (scsi_is_sdev_device(dev)) {
-		/*
-		 * All the high-level SCSI drivers that implement runtime
-		 * PM treat runtime suspend, system suspend, and system
-		 * hibernate nearly identically. In all cases the requirements
-		 * for runtime suspension are stricter.
-		 */
-		if (pm_runtime_suspended(dev))
-			return 0;
-
-		err = scsi_dev_type_suspend(dev, cb);
-	}
-
-	return err;
+	return scsi_dev_type_suspend(dev, cb);
 }
 
 static int scsi_bus_resume_common(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
-	if (scsi_is_sdev_device(dev)) {
-		scsi_dev_type_resume(dev, cb);
-	} else {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
-	return 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int err;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	err = cb(dev, pm);
+	scsi_device_resume(to_scsi_device(dev));
+	dev_dbg(dev, "scsi resume: %d\n", err);
+
+	return err;
 }
 
 static int scsi_bus_prepare(struct device *dev)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d61b096562d3..a3c6e156e83a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3656,6 +3656,9 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 
 static int sd_suspend_system(struct device *dev)
 {
+	if (pm_runtime_suspended(dev))
+		return 0;
+
 	return sd_suspend_common(dev, true);
 }
 
@@ -3684,6 +3687,9 @@ static int sd_resume(struct device *dev)
 
 static int sd_resume_system(struct device *dev)
 {
+	if (pm_runtime_suspended(dev))
+		return 0;
+
 	return sd_resume(dev);
 }
 
