Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D756C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 05:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7D2613C2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 05:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345287AbhDGF7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 01:59:18 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:39200 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345259AbhDGF7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 01:59:12 -0400
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 940A022566;
        Tue,  6 Apr 2021 22:59:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 940A022566
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1617775142;
        bh=d6tS35YGWCW9agJ3M8LpakfG7RdM5DC13s3mwlFQonQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JA7tAYrlnP5/K3Bv50V0K04JudJZAAqVfvNbJSc6MpjGfZqqVs0OcRy+1VrvLg/yR
         PZzCtUP4kX2E5NLoSe3K+fnEcs/CrJLWt2I7gYLx/YJuljZfLedZ/CgGSvzZZDgfZ9
         44X/2hkhcUu00FIIv6lcv/4I+3DenMMfa7gqucJ0=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v9 02/13] blkcg: Added a app identifier support for blkcg
Date:   Wed,  7 Apr 2021 04:36:26 +0530
Message-Id: <1617750397-26466-3-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This Patch added a unique application identifier i.e
fc_app_id  member in blkcg which allows identification of traffic
sources at an individual cgroup based Applications
(ex:virtual machine (VM))level in both host and
fabric infrastructure.

Added a new function blkcg_get_fc_appid to
grab the app identifier associated with a bio.

Added a new function blkcg_set_fc_appid to
set the app identifier in a blkcgrp associated with cgroup id

Added a new config BLK_CGROUP_FC_APPID and moved the changes
under this config

Merged the patch 16 of previous version in which we
added a new config FC_APPID to select BLK_CGROUP_FC_APPID which Enable
support to track FC io Traffic.

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v9:
Merged patch16 of previosu version to this patch
where we are using Kconfig settings

v8:
No change

v7:
Modified the Kconfig file

v6:
Modified the Kconfig file as per standard specified
in Documentation/process/coding-style.rst

v5:
Renamed the arguments appropriatley
Renamed APPID_LEN  to FC_APPID_LEN
Moved the input validation at the begining of the function
Modified the comments

v4:
No change

v3:
Renamed the functions and app_id to more specific

Addressed the reference leaks in blkcg_set_app_identifier

Added a new config BLK_CGROUP_FC_APPID and moved the changes
under this config

Added blkcg_get_fc_appid,blkcg_set_fc_appid as inline functions

v2:
renamed app_identifier to app_id
removed the  sysfs interface blkio.app_identifie under
---
 block/Kconfig              |  9 ++++++
 drivers/scsi/Kconfig       | 13 +++++++++
 include/linux/blk-cgroup.h | 56 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index a2297edfdde8..03886d105301 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -144,6 +144,15 @@ config BLK_CGROUP_IOLATENCY
 
 	Note, this is an experimental interface and could be changed someday.
 
+config BLK_CGROUP_FC_APPID
+	bool "Enable support to track FC I/O Traffic across cgroup applications"
+	depends on BLK_CGROUP=y
+	help
+	  Enabling this option enables the support to track FC I/O traffic across
+	  cgroup applications. It enables the Fabric and the storage targets to
+	  identify, monitor, and handle FC traffic based on VM tags by inserting
+	  application specific identification into the FC frame.
+
 config BLK_CGROUP_IOCOST
 	bool "Enable support for cost model based cgroup IO controller"
 	depends on BLK_CGROUP=y
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 06b87c7f6bab..20aa1536a3ba 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -235,6 +235,19 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
+config FC_APPID
+	bool "Enable support to track FC I/O Traffic"
+	depends on BLOCK && BLK_CGROUP
+	depends on SCSI
+	select BLK_CGROUP_FC_APPID
+	default y
+	help
+	  If you say Y here, it enables the support to track
+	  FC I/O traffic over fabric. It enables the Fabric and the
+	  storage targets to identify, monitor, and handle FC traffic
+	  based on VM tags by inserting application specific
+	  identification into the FC frame.
+
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
 	depends on SCSI && NET
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index b9f3c246c3c9..9204f8f8a932 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -30,6 +30,8 @@
 
 /* Max limits for throttle policy */
 #define THROTL_IOPS_MAX		UINT_MAX
+#define FC_APPID_LEN              129
+
 
 #ifdef CONFIG_BLK_CGROUP
 
@@ -55,6 +57,9 @@ struct blkcg {
 	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
 
 	struct list_head		all_blkcgs_node;
+#ifdef CONFIG_BLK_CGROUP_FC_APPID
+	char                            fc_app_id[FC_APPID_LEN];
+#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head		cgwb_list;
 #endif
@@ -660,4 +665,55 @@ static inline void blk_cgroup_bio_start(struct bio *bio) { }
 
 #endif	/* CONFIG_BLOCK */
 #endif	/* CONFIG_BLK_CGROUP */
+
+#ifdef CONFIG_BLK_CGROUP_FC_APPID
+/*
+ * Sets the fc_app_id field associted to blkcg
+ * @app_id: application identifier
+ * @cgrp_id: cgroup id
+ * @app_id_len: size of application identifier
+ */
+static inline int blkcg_set_fc_appid(char *app_id, u64 cgrp_id, size_t app_id_len)
+{
+	struct cgroup *cgrp;
+	struct cgroup_subsys_state *css;
+	struct blkcg *blkcg;
+	int ret  = 0;
+
+	if (app_id_len > FC_APPID_LEN)
+		return -EINVAL;
+
+	cgrp = cgroup_get_from_id(cgrp_id);
+	if (!cgrp)
+		return -ENOENT;
+	css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
+	if (!css) {
+		ret = -ENOENT;
+		goto out_cgrp_put;
+	}
+	blkcg = css_to_blkcg(css);
+	strlcpy(blkcg->fc_app_id, app_id, app_id_len);
+	css_put(css);
+out_cgrp_put:
+	cgroup_put(cgrp);
+	return ret;
+}
+
+/**
+ * blkcg_get_fc_appid - get the fc app identifier associated with a bio
+ * @bio: target bio
+ *
+ * On success it returns the fc_app_id on failure it returns NULL
+ */
+static inline char *blkcg_get_fc_appid(struct bio *bio)
+{
+	if (bio && bio->bi_blkg &&
+		(bio->bi_blkg->blkcg->fc_app_id[0] != '\0'))
+		return bio->bi_blkg->blkcg->fc_app_id;
+	return NULL;
+}
+#else
+static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len) { return -EINVAL; }
+static inline char *blkcg_get_fc_appid(struct bio *bio) { return NULL; }
+#endif /*CONFIG_BLK_CGROUP_FC_APPID*/
 #endif	/* _BLK_CGROUP_H */
-- 
2.26.2

