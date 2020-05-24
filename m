Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B17AC433E4
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F44C20776
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbgEXP6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 11:58:30 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43443 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgEXP6a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 May 2020 11:58:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 31D4D20423B;
        Sun, 24 May 2020 17:58:28 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Yj9iyJmeklmU; Sun, 24 May 2020 17:58:26 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 5EC27204258;
        Sun, 24 May 2020 17:58:22 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC v2 5/6] scsi: add __scsi_target_lookup
Date:   Sun, 24 May 2020 11:58:13 -0400
Message-Id: <20200524155814.5895-6-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200524155814.5895-1-dgilbert@interlog.com>
References: <20200524155814.5895-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hides the xarray based lookup of a target given the channel and target
identifiers within a shost. Use this and __sstarg_for_each_device()
where useful.

Break the pattern when deleting to jump back and restart the iteration
as that seems to be a linked list quirk. May change semantics if
elements can be added in the newly created holes in the xarray at the
same time as the ongoing deletion.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi.c        | 24 ++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  | 34 +++++++++++++++++-----------------
 drivers/scsi/scsi_lib.c    |  8 +++-----
 drivers/scsi/scsi_scan.c   |  4 ++--
 drivers/scsi/scsi_sysfs.c  |  8 +++-----
 include/scsi/scsi_device.h |  2 ++
 6 files changed, 51 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9e7658aebdb7..1b1fc8d4e5c2 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -667,6 +667,30 @@ struct scsi_device *__scsi_target_iterate_devices(struct scsi_target *starg,
 }
 EXPORT_SYMBOL(__scsi_target_iterate_devices);
 
+/**
+ * __scsi_target_lookup  -  helper to find target given channel and target_id
+ * @shost:	host to search within
+ * @chan:	channel number
+ * @t_id:	target identifier
+ *
+ * No locks or references taken. Returns NULL if not found.
+ */
+struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
+					 uint chan, uint t_id)
+{
+	unsigned long l_idx;
+	struct scsi_target *starg = NULL;
+
+	if (shost) {
+		xa_for_each(&shost->__targets, l_idx, starg) {
+			if (chan == starg->channel && t_id == starg->id)
+				break;
+		}
+	}
+	return starg;
+}
+EXPORT_SYMBOL(__scsi_target_lookup);
+
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starg:	target whose devices we want to iterate over.
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 978be1602f71..b2dbfa5f73a0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -644,6 +644,7 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 {
 	struct scsi_host_template *sht = sdev->host->hostt;
 	struct scsi_device *tmp_sdev;
+	struct scsi_target *starg = scsi_target(sdev);
 
 	if (!sht->track_queue_depth ||
 	    sdev->queue_depth >= sdev->max_queue_depth)
@@ -658,13 +659,10 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 		return;
 
 	/*
-	 * Walk all devices of a target and do
-	 * ramp up on them.
+	 * Walk all devices of a target and do ramp up on them.
 	 */
-	shost_for_each_device(tmp_sdev, sdev->host) {
-		if (tmp_sdev->channel != sdev->channel ||
-		    tmp_sdev->id != sdev->id ||
-		    tmp_sdev->queue_depth == sdev->max_queue_depth)
+	sstarg_for_each_device(tmp_sdev, starg) {
+		if (tmp_sdev->queue_depth == sdev->max_queue_depth)
 			continue;
 
 		scsi_change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1);
@@ -672,25 +670,26 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 	}
 }
 
+/*
+ * queue_full corresponds to the SCSI status: "Task Set Full". Its scope is
+ * at the SCSI taret device level.
+ */
 static void scsi_handle_queue_full(struct scsi_device *sdev)
 {
 	struct scsi_host_template *sht = sdev->host->hostt;
 	struct scsi_device *tmp_sdev;
+	struct scsi_target *starg = scsi_target(sdev);
 
 	if (!sht->track_queue_depth)
 		return;
 
-	shost_for_each_device(tmp_sdev, sdev->host) {
-		if (tmp_sdev->channel != sdev->channel ||
-		    tmp_sdev->id != sdev->id)
-			continue;
+	sstarg_for_each_device(tmp_sdev, starg)
 		/*
 		 * We do not know the number of commands that were at
-		 * the device when we got the queue full so we start
+		 * the target when we got the queue full so we start
 		 * from the highest possible value and work our way down.
 		 */
 		scsi_track_queue_full(tmp_sdev, tmp_sdev->queue_depth - 1);
-	}
 }
 
 /**
@@ -2305,12 +2304,13 @@ EXPORT_SYMBOL(scsi_report_bus_reset);
 void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 {
 	struct scsi_device *sdev;
+	struct scsi_target *starg = __scsi_target_lookup(shost, channel,
+							 target);
 
-	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev_channel(sdev) &&
-		    target == sdev_id(sdev))
-			__scsi_report_device_reset(sdev, NULL);
-	}
+	if (!starg)
+		return;
+	__sstarg_for_each_device(sdev, starg)
+		__scsi_report_device_reset(sdev, NULL);
 }
 EXPORT_SYMBOL(scsi_report_device_reset);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f484bf2b5d7d..034ec2e57d1c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -374,7 +374,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	struct Scsi_Host *shost = current_sdev->host;
 	struct scsi_device *sdev;
 	struct scsi_target *starget = scsi_target(current_sdev);
-	unsigned long flags, l_idx;
+	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->starget_sdev_user = NULL;
@@ -392,7 +392,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	if (starget->starget_sdev_user)
 		goto out;
 	/* XARRAY: was list_for_each_entry_safe(); is this safe ? */
-	xa_for_each(&starget->devices, l_idx, sdev) {
+	__sstarg_for_each_device(sdev, starget) {
 		if (sdev == current_sdev)
 			continue;
 		if (scsi_device_get(sdev))
@@ -2217,14 +2217,12 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
 
-/* Assume host_lock taken and that xahp->xa_lock is the same lock. */
 static inline void
 scsi_adjust_non_sdev_del_mark(struct scsi_device *sdev,
 			      enum scsi_device_state old_state,
 			      enum scsi_device_state new_state)
 {
-	struct xarray *xatp =
-			&to_scsi_target(sdev->sdev_gendev.parent)->devices;
+	struct xarray *xatp = &scsi_target(sdev)->devices;
 	struct xarray *xahp = &sdev->host->__devices;
 
 	if (old_state == new_state)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f5a5e48ca5ae..c055ee083ea9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1880,13 +1880,13 @@ void scsi_forget_host(struct Scsi_Host *shost)
 	struct scsi_device *sdev;
 	unsigned long flags, l_idx;
 
- restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	xa_for_each_marked(&shost->__devices, l_idx, sdev,
 			   SCSI_XA_NON_SDEV_DEL) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		__scsi_remove_device(sdev);
-		goto restart;
+		/* XARRAY: was a goto to before first line */
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6fdd4648f374..394230d69afd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1480,7 +1480,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	unsigned long flags, l_idx;
 
 	spin_lock_irqsave(shost->host_lock, flags);
- restart:
 	xa_for_each_marked(&starget->devices, l_idx, sdev,
 			   SCSI_XA_NON_SDEV_DEL) {
 		/*
@@ -1496,8 +1495,7 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		scsi_remove_device(sdev);
 		put_device(&sdev->sdev_gendev);
 		spin_lock_irqsave(shost->host_lock, flags);
-		/* XARRAY: is this goto start of loop correct ? */
-		goto restart;
+		/* XARRAY: was a goto to restart loop */
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
@@ -1516,7 +1514,6 @@ void scsi_remove_target(struct device *dev)
 	struct scsi_target *starget;
 	unsigned long flags, l_idx;
 
-restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	xa_for_each(&shost->__targets, l_idx, starget) {
 		if (starget->state == STARGET_DEL ||
@@ -1532,7 +1529,8 @@ void scsi_remove_target(struct device *dev)
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
-			goto restart;
+			/* XARRAY: was a goto to before first line */
+			spin_lock_irqsave(shost->host_lock, flags);
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 23bf686cbabc..e019621416d5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -362,6 +362,8 @@ extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
 							u64);
 extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
 							  u64);
+extern struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
+						uint chan, uint t_id);
 /* XARRAY: these visitor names too close to sstarg_for_each_device macros? */
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
-- 
2.25.1

