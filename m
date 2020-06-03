Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B1BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A0320738
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgFCCzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:55:51 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45229 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgFCCzu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jun 2020 22:55:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7D5A72041CB;
        Wed,  3 Jun 2020 04:55:48 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TgJbtiLeHY-Q; Wed,  3 Jun 2020 04:55:42 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 29EF42041B2;
        Wed,  3 Jun 2020 04:55:40 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH] scsi: add starget_to_shost() specialization
Date:   Tue,  2 Jun 2020 22:55:39 -0400
Message-Id: <20200603025539.163780-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the SCSI mid-layer object tree the host level and the target level
under it can be separated by transport supplied objects. For example
the SCSI SAS transport inserts SAS port and phy objects. To cope with
this in a generic way there is function called dev_to_host() that
loops back up the 'device' object hierarchy asking at each level:
"Are you a shost object?".

It does the job but it is not particulary efficient in the case where
the given object is a SCSI target. This is because when a SCSI target
object is created it knows its SCSI host object and can hold that
pointer value. So as long as a SCSI target cannot change its parent
SCSI host object "midstream" then following that pointer (which is
what starget_to_shost() does) is safe and faster.

Also the level below the starget, is the sdev (aka LU) object which
already has a redundant pointer called scsi_device::host . So since
that has proven safe, adding another redundant pointer at the target
level must also be safe (by induction).

This patch is against Martin's 5.8/scsi-queue branch and Hannes' v4
"scsi: use xarray for devices and targets" patchset sent earlier today.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi.c           |  2 +-
 drivers/scsi/scsi_scan.c      | 11 ++++++-----
 drivers/scsi/scsi_sysfs.c     |  2 +-
 include/scsi/scsi_device.h    |  8 ++++++++
 include/scsi/scsi_transport.h |  2 +-
 5 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 296cecd61d3a..9d0ce5959866 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -761,7 +761,7 @@ struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 u64 lun)
 {
 	struct scsi_device *sdev;
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 41818111808e..5f4b8ed31a76 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -217,7 +217,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 {
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_KERNEL);
@@ -305,7 +305,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 static void scsi_target_destroy(struct scsi_target *starget)
 {
 	struct device *dev = &starget->dev;
-	struct Scsi_Host *shost = dev_to_shost(dev->parent);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 	unsigned long flags;
 	unsigned long tid = scsi_target_index(starget);
 
@@ -424,6 +424,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	device_initialize(dev);
 	kref_init(&starget->reap_ref);
 	dev->parent = get_device(parent);
+	starget->parent_shost = shost;		/* redundant but faster */
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
 	dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
@@ -1055,7 +1056,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	unsigned char *result;
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1205,7 +1206,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 {
 	uint max_dev_lun;
 	u64 sparse_lun, lun;
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 
 	SCSI_LOG_SCAN_BUS(3, starget_printk(KERN_INFO, starget,
 		"scsi scan: Sequential scan\n"));
@@ -1303,7 +1304,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	struct scsi_lun *lunp, *lun_data;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 	int ret = 0;
 
 	/*
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e30a058c6b33..0b5ede1b8ebe 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1477,7 +1477,7 @@ EXPORT_SYMBOL(scsi_remove_device);
 
 static void __scsi_remove_target(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 	unsigned long flags;
 	struct scsi_device *sdev, *sdev_next;
 	unsigned long lun_idx = 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3690af6ce6af..fd1465a73ef4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -278,12 +278,14 @@ enum scsi_target_state {
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
  * starget_sdev_user is NULL, else it points to the active sdev.
+ * * Invariant: starg->parent_shost == dev_to_shost(starg->dev.parent)
  */
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
 	struct list_head	siblings;
 	struct xarray		__devices;
 	struct device		dev;
+	struct Scsi_Host        *parent_shost;	/* redundant but faster */
 	struct kref		reap_ref; /* last put renders target invisible */
 	u16			channel;
 	u16			id; /* target id ... replace
@@ -323,6 +325,12 @@ static inline u32 scsi_target_index(struct scsi_target *starget)
 	return (starget->channel << 16) | (starget->id);
 }
 
+/* This is faster that doing dev_to_shost(starg->dev.parent) */
+static inline struct Scsi_Host *starget_to_shost(struct scsi_target *starg)
+{
+	return starg->parent_shost;
+}
+
 #define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
 static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 {
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index a0458bda3148..5a2337ded7b0 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -70,7 +70,7 @@ scsi_transport_reserve_device(struct scsi_transport_template * t, int space)
 static inline void *
 scsi_transport_target_data(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct Scsi_Host *shost = starget_to_shost(starget);
 	return (u8 *)starget->starget_data
 		+ shost->transportt->target_private_offset;
 
-- 
2.25.1

