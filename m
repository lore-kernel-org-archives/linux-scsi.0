Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F722C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A7C822EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbhAGEyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:54:24 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:52070 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727287AbhAGEyX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:54:23 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 3B9BC361CF;
        Wed,  6 Jan 2021 20:53:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 3B9BC361CF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609995200;
        bh=FQfo3BoSonNirsa5eAI/CKA7TFAH1Gqfs8iY9T+MT4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AckvWiQwzMp1FRU2nNLuPd3vnFQbEIwjiioaoslWwC/N432+Cbm8Vny/3SvmUA0Ip
         hOfi33bSckRuhfXwS/M3NTUrzBFN1XkMQRc0FD9oahPevtjVqqbVCcu9bwiG+eb7Pf
         dVeBraBcH7Tc6hXAulx5jyxuuFIytigWa3YouLWg=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v7 02/16] blkcg: Added a app identifier support for blkcg
Date:   Thu,  7 Jan 2021 03:30:16 +0530
Message-Id: <1609970430-19084-3-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
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

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
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
 include/linux/blk-cgroup.h | 56 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

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
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c8fc9792ac77..216ca0d5eda7 100644
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

