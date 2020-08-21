Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2D7C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4193207BB
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHUPmk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:42:40 -0400
Received: from smtp.infotech.no ([82.134.31.41]:48328 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgHUPmR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 11:42:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B3E57204190;
        Fri, 21 Aug 2020 17:42:14 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NOuqMNtP-sXO; Fri, 21 Aug 2020 17:42:13 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 3687E204248;
        Fri, 21 Aug 2020 17:42:12 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        john.garry@huawei.com
Subject: [PATCH v6 05/10] scsi_error: use xarray lookup instead of wrappers
Date:   Fri, 21 Aug 2020 11:41:59 -0400
Message-Id: <20200821154204.9298-6-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821154204.9298-1-dgilbert@interlog.com>
References: <20200821154204.9298-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

For SCSI EH most shost_for_each_sdev() calls are just to filter
out devices for specific targets or channels.
These calls can be made more efficient using direct xarray
lookup and iterators.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi.c       |  2 +-
 drivers/scsi/scsi_error.c | 35 ++++++++++++++++++++++-------------
 drivers/scsi/scsi_priv.h  |  2 ++
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 294e9d4d8b46..0e22fff072ff 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -652,7 +652,7 @@ EXPORT_SYMBOL(__scsi_iterate_devices_unlocked);
  * @id:		ID of the target
  *
  */
-static struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
+struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
 					 u16 channel, u16 id)
 {
 	return xa_load(&shost->__targets, (channel << 16) | id);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 927b1e641842..02605c848365 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -643,7 +643,9 @@ EXPORT_SYMBOL_GPL(scsi_check_sense);
 static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 {
 	struct scsi_host_template *sht = sdev->host->hostt;
+	struct scsi_target *starget;
 	struct scsi_device *tmp_sdev;
+	unsigned long lun_idx = 0;
 
 	if (!sht->track_queue_depth ||
 	    sdev->queue_depth >= sdev->max_queue_depth)
@@ -661,10 +663,9 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 	 * Walk all devices of a target and do
 	 * ramp up on them.
 	 */
-	shost_for_each_device(tmp_sdev, sdev->host) {
-		if (tmp_sdev->channel != sdev->channel ||
-		    tmp_sdev->id != sdev->id ||
-		    tmp_sdev->queue_depth == sdev->max_queue_depth)
+	starget = __scsi_target_lookup(sdev->host, sdev->channel, sdev->id);
+	xa_for_each(&starget->__devices, lun_idx, tmp_sdev) {
+		if (tmp_sdev->queue_depth == sdev->max_queue_depth)
 			continue;
 
 		scsi_change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1);
@@ -675,14 +676,15 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 static void scsi_handle_queue_full(struct scsi_device *sdev)
 {
 	struct scsi_host_template *sht = sdev->host->hostt;
+	struct scsi_target *starget = sdev->sdev_target;
 	struct scsi_device *tmp_sdev;
+	unsigned long lun_idx = 0;
 
 	if (!sht->track_queue_depth)
 		return;
 
-	shost_for_each_device(tmp_sdev, sdev->host) {
-		if (tmp_sdev->channel != sdev->channel ||
-		    tmp_sdev->id != sdev->id)
+	xa_for_each(&starget->__devices, lun_idx, tmp_sdev) {
+		if (tmp_sdev->sdev_state == SDEV_DEL)
 			continue;
 		/*
 		 * We do not know the number of commands that were at
@@ -2273,10 +2275,16 @@ int scsi_error_handler(void *data)
  */
 void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
 {
+	struct scsi_target *starget;
 	struct scsi_device *sdev;
+	unsigned long tid = 0;
 
-	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev_channel(sdev))
+	xa_for_each(&shost->__targets, tid, starget) {
+		unsigned long lun_idx = 0;
+
+		if (starget->channel != channel)
+			continue;
+		xa_for_each(&starget->__devices, lun_idx, sdev)
 			__scsi_report_device_reset(sdev, NULL);
 	}
 }
@@ -2306,13 +2314,14 @@ EXPORT_SYMBOL(scsi_report_bus_reset);
  */
 void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 {
+	struct scsi_target *starget;
 	struct scsi_device *sdev;
+	unsigned long lun_idx = 0;
 
-	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev_channel(sdev) &&
-		    target == sdev_id(sdev))
+	starget = __scsi_target_lookup(shost, channel, target);
+	if (starget)
+		xa_for_each(&starget->__devices, lun_idx, sdev)
 			__scsi_report_device_reset(sdev, NULL);
-	}
 }
 EXPORT_SYMBOL(scsi_report_device_reset);
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d12ada035961..86da143ae06b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -49,6 +49,8 @@ enum scsi_devinfo_key {
 	SCSI_DEVINFO_SPI,
 };
 
+extern struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
+						u16 channel, u16 id);
 extern blist_flags_t scsi_get_device_flags(struct scsi_device *sdev,
 					   const unsigned char *vendor,
 					   const unsigned char *model);
-- 
2.25.1

