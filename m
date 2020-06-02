Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5775C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C2A2068D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgFBLeY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:34:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:37938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBLeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jun 2020 07:34:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B1D8DAE18;
        Tue,  2 Jun 2020 11:34:20 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] scsi_error: use xarray lookup instead of wrappers
Date:   Tue,  2 Jun 2020 13:33:10 +0200
Message-Id: <20200602113311.121513-6-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200602113311.121513-1-hare@suse.de>
References: <20200602113311.121513-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SCSI EH most shost_for_each_sdev() calls are just to filter
out devices for specific targets or channels.
These calls can be made more efficient using direct xarray
lookup and iterators.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c       |  2 +-
 drivers/scsi/scsi_error.c | 35 ++++++++++++++++++++++-------------
 drivers/scsi/scsi_priv.h  |  2 ++
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 6a1d8c6bd8f9..296cecd61d3a 100644
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
index 22b6585e28b4..0a87c95359aa 100644
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
2.16.4

