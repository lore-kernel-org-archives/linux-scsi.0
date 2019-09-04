Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6D7C3A5AB
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B0EF22CEA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oncLdinM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfIDInC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39226 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfIDInB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586581; x=1599122581;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=lXmNGw+0DXKWd3/CW5QfLTARK01VfROVWdtvZQJsTFQ=;
  b=oncLdinMiHPlW1Of87pFyqeNb0X4vkG9lYlxcaIJU4J7lXUgkf1rWCpD
   mBMENxegp5ndWjzJGZbBk2zlUL4DOjbMq3nQy7jmCGPu1KPh8Zlx7QQUT
   J0zkVkjJM6ITMZYYidWzGVwUOZ3fmiy+wT+jxT0eBmPr+KaC515YKpH6C
   885Pzh+CDsvRMrbzaUCrGLG2MESIHq7Yvr3u4PZxLtlxWUsRq43PfXgE5
   aZzPljRmn4Ba3eDO3d0lzq8H5rLl2sCFWkzI1Ef+Kz4EG3GZqIoDHtYYn
   Kqny99PbgAF5IHOXWa8JN0VA8EwBPfm/yRjJgft6lVyVIWATD17oHtSkT
   w==;
IronPort-SDR: eoRU6uHPcQ4FTEJmcoxNKUaJ0bm7UQfu3v39A9ORoXwGVG4zO6dC3By/PeBbUcNqPlxNZ/WtnN
 746OYB3i8PAVkMvoRGapvRghl3Ge4WIOV3LjcJ9nlCh/ro9UZ0CnDASIpaJV6LkL5w37vEKK/Z
 1UXR7BEjbwIZXQtdgSS9ymNBjyZHbm5WK1PyWH840sMYqPmSbsTaUC+E+70i4MOd0DPXmM71Ta
 fPgUk6SkWSE/3ypQH2zGX2s2dzeVH/x5AQ0NdKVb0Xznoq7tj+VqV/O29HWw0V3bBSE4SOM3p8
 fS8=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374680"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:52 +0800
IronPort-SDR: KGWOoTYRrMxIRd2uj/AIGVXQAq4aW240H/Pg91VTTgvFgXBhK8uHuU/1QZkgk/TQo02WO2OXg8
 34Y6AzMkXMRjLxV6GNYZsZ4M6AIwLN50dG9avEtBWrteT6KeeFSfMaUVqRZz3oT6wntE1BiVSj
 oDPL7Ku6IS4Ap2oG7XhbFDcBnOlxHEgEZWEYwRIcA/2onjT8ZYXPNnS5Xx8jEZXFbCJKIm9/sH
 vaZNaedeXVqcQIl8SAbmsgjEqJB2kQ9YjZ64Tm9pHJGcmJpFrPEH4Cy/d5ltpIyy3ZW/zlRY2D
 RxxqkNroYnfFo0oOR1LKMgaN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:50 -0700
IronPort-SDR: Sjs1gmQf32XnslO1hjHgHtUIret/HA6AQ+8t+vqeyFWnsJIZGWnkPSUnTaiyQB3atY9r3dNVFw
 Bt1P2daWmctuAUjmHQ5Q+ZcMbVbNd4nioAQv6UonWJYgG6iGItPYFOhMqWwxq7wTPoW9zeHCw2
 3wpeUUd0uXdJXU0ou2HUXMYNdEtvJUx1oVZNIRlUs7+WP/RcDr6RIphRKEa/GaDTMhcP+4upCC
 GaH6BXv314nxxKTiHhSa16fqpvShjY/CRRwwINYk65nMqJUTDVr9HLBP6TPDvj5+nbVDp92NhY
 aeg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:50 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 3/7] block: Introduce elevator features
Date:   Wed,  4 Sep 2019 17:42:43 +0900
Message-Id: <20190904084247.23338-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904084247.23338-1-damien.lemoal@wdc.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the definition of elevator features through the
elevator_features flags in the elevator_type structure. Each flag can
represent a feature supported by an elevator. The first feature defined
by this patch is support for zoned block device sequential write
constraint with the flag ELEVATOR_F_ZBD_SEQ_WRITE, which is implemented
by the mq-deadline elevator using zone write locking.

Other possible features are IO priorities, write hints, latency targets
or single-LUN dual-actuator disks (for which the elevator could maintain
one LBA ordered list per actuator).

The required_elevator_features field is also added to the request_queue
structure to allow a device driver to specify elevator feature flags
that an elevator must support for the correct operation of the device
(e.g. device drivers for zoned block devices can have the
ELEVATOR_F_ZBD_SEQ_WRITE flag as a required feature).
The helper function blk_queue_required_elevator_features() is
defined for setting this new field.

With these two new fields in place, the elevator functions
elevator_match() and elevator_find() are modified to allow a user to set
only an elevator with a set of features that satisfies the device
required features. Elevators not matching the device requirements are
not shown in the device sysfs queue/scheduler file to prevent their use.

The "none" elevator can always be selected as before.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c     | 16 +++++++++++++
 block/elevator.c         | 49 +++++++++++++++++++++++++++++++---------
 block/mq-deadline.c      |  1 +
 include/linux/blkdev.h   |  4 ++++
 include/linux/elevator.h |  8 +++++++
 5 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a058997b9cce..6bd1e3b082d8 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -832,6 +832,22 @@ void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
 }
 EXPORT_SYMBOL_GPL(blk_queue_write_cache);
 
+/**
+ * blk_queue_required_elevator_features - Set a queue required elevator features
+ * @q:		the request queue for the target device
+ * @features:	Required elevator features OR'ed together
+ *
+ * Tell the block layer that for the device controlled through @q, only the
+ * only elevators that can be used are those that implement at least the set of
+ * features specified by @features.
+ */
+void blk_queue_required_elevator_features(struct request_queue *q,
+					  unsigned int features)
+{
+	q->required_elevator_features = features;
+}
+EXPORT_SYMBOL_GPL(blk_queue_required_elevator_features);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/block/elevator.c b/block/elevator.c
index 2944c129760c..ac7c8ad580ba 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -83,8 +83,26 @@ bool elv_bio_merge_ok(struct request *rq, struct bio *bio)
 }
 EXPORT_SYMBOL(elv_bio_merge_ok);
 
-static bool elevator_match(const struct elevator_type *e, const char *name)
+static inline bool elv_support_features(unsigned int elv_features,
+					unsigned int required_features)
 {
+	return (required_features & elv_features) == required_features;
+}
+
+/**
+ * elevator_match - Test an elevator name and features
+ * @e: Scheduler to test
+ * @name: Elevator name to test
+ * @required_features: Features that the elevator must provide
+ *
+ * Return true is the elevator @e name matches @name and if @e provides all the
+ * the feratures spcified by @required_features.
+ */
+static bool elevator_match(const struct elevator_type *e, const char *name,
+			   unsigned int required_features)
+{
+	if (!elv_support_features(e->elevator_features, required_features))
+		return false;
 	if (!strcmp(e->elevator_name, name))
 		return true;
 	if (e->elevator_alias && !strcmp(e->elevator_alias, name))
@@ -93,15 +111,21 @@ static bool elevator_match(const struct elevator_type *e, const char *name)
 	return false;
 }
 
-/*
- * Return scheduler with name 'name'
+/**
+ * elevator_find - Find an elevator
+ * @name: Name of the elevator to find
+ * @required_features: Features that the elevator must provide
+ *
+ * Return the first registered scheduler with name @name and supporting the
+ * features @required_features and NULL otherwise.
  */
-static struct elevator_type *elevator_find(const char *name)
+static struct elevator_type *elevator_find(const char *name,
+					   unsigned int required_features)
 {
 	struct elevator_type *e;
 
 	list_for_each_entry(e, &elv_list, list) {
-		if (elevator_match(e, name))
+		if (elevator_match(e, name, required_features))
 			return e;
 	}
 
@@ -120,12 +144,12 @@ static struct elevator_type *elevator_get(struct request_queue *q,
 
 	spin_lock(&elv_list_lock);
 
-	e = elevator_find(name);
+	e = elevator_find(name, q->required_elevator_features);
 	if (!e && try_loading) {
 		spin_unlock(&elv_list_lock);
 		request_module("%s-iosched", name);
 		spin_lock(&elv_list_lock);
-		e = elevator_find(name);
+		e = elevator_find(name, q->required_elevator_features);
 	}
 
 	if (e && !try_module_get(e->elevator_owner))
@@ -525,7 +549,7 @@ int elv_register(struct elevator_type *e)
 
 	/* register, don't allow duplicate names */
 	spin_lock(&elv_list_lock);
-	if (elevator_find(e->elevator_name)) {
+	if (elevator_find(e->elevator_name, 0)) {
 		spin_unlock(&elv_list_lock);
 		kmem_cache_destroy(e->icq_cache);
 		return -EBUSY;
@@ -709,7 +733,8 @@ static int __elevator_change(struct request_queue *q, const char *name)
 	if (!e)
 		return -EINVAL;
 
-	if (q->elevator && elevator_match(q->elevator->type, elevator_name)) {
+	if (q->elevator &&
+	    elevator_match(q->elevator->type, elevator_name, 0)) {
 		elevator_put(e);
 		return 0;
 	}
@@ -749,11 +774,13 @@ ssize_t elv_iosched_show(struct request_queue *q, char *name)
 
 	spin_lock(&elv_list_lock);
 	list_for_each_entry(__e, &elv_list, list) {
-		if (elv && elevator_match(elv, __e->elevator_name)) {
+		if (elv && elevator_match(elv, __e->elevator_name, 0)) {
 			len += sprintf(name+len, "[%s] ", elv->elevator_name);
 			continue;
 		}
-		if (elv_support_iosched(q))
+		if (elv_support_iosched(q) &&
+		    elevator_match(__e, __e->elevator_name,
+				   q->required_elevator_features))
 			len += sprintf(name+len, "%s ", __e->elevator_name);
 	}
 	spin_unlock(&elv_list_lock);
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 35e84bc0ec8c..b490f47fd553 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -794,6 +794,7 @@ static struct elevator_type mq_deadline = {
 	.elevator_attrs = deadline_attrs,
 	.elevator_name = "mq-deadline",
 	.elevator_alias = "deadline",
+	.elevator_features = ELEVATOR_F_ZBD_SEQ_WRITE,
 	.elevator_owner = THIS_MODULE,
 };
 MODULE_ALIAS("mq-deadline-iosched");
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d0ad21e4771b..b196124e3240 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -496,6 +496,8 @@ struct request_queue {
 
 	struct queue_limits	limits;
 
+	unsigned int		required_elevator_features;
+
 #ifdef CONFIG_BLK_DEV_ZONED
 	/*
 	 * Zoned block device information for request dispatch control.
@@ -1097,6 +1099,8 @@ extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
+extern void blk_queue_required_elevator_features(struct request_queue *q,
+						 unsigned int features);
 
 /*
  * Number of physical segments as sent to the device.
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 1dd014c9c87b..901bda352dcb 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -76,6 +76,7 @@ struct elevator_type
 	struct elv_fs_entry *elevator_attrs;
 	const char *elevator_name;
 	const char *elevator_alias;
+	const unsigned int elevator_features;
 	struct module *elevator_owner;
 #ifdef CONFIG_BLK_DEBUG_FS
 	const struct blk_mq_debugfs_attr *queue_debugfs_attrs;
@@ -165,5 +166,12 @@ extern struct request *elv_rb_find(struct rb_root *, sector_t);
 #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
 #define rq_fifo_clear(rq)	list_del_init(&(rq)->queuelist)
 
+/*
+ * Elevator features.
+ */
+
+/* Supports zoned block devices sequential write constraint */
+#define ELEVATOR_F_ZBD_SEQ_WRITE	(1U << 0)
+
 #endif /* CONFIG_BLOCK */
 #endif
-- 
2.21.0

