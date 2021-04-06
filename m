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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321C1C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 05:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E64E2613A3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 05:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345252AbhDGF7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 01:59:17 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:39170 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243610AbhDGF7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 01:59:10 -0400
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 0E88921829;
        Tue,  6 Apr 2021 22:58:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 0E88921829
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1617775140;
        bh=2WueO+L+WPkxa8j6sNZVzXHUywAB54EZZgPo0i0AcgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIv2ZKSI5GEhLsEsO3diUV6RQ66HtAjoXLy5max1vkC/5AHnSg2Qju8mMN+67rp62
         yIWZsQpEwVnivrcCQBgctgA9JhDxcVE3sO5U0hnT9BAHQEhtEZnWHiLaIP/2UYZeS0
         lhnEwzl2BFBu6EFHMjCTqkbPPoXTWfF6tRqwCrXY=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v9 01/13] cgroup: Added cgroup_get_from_id
Date:   Wed,  7 Apr 2021 04:36:25 +0530
Message-Id: <1617750397-26466-2-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new function cgroup_get_from_id  to retrieve the cgroup
associated with cgroup id.
Exported the same as this can be used by blk-cgorup.c

Added function declaration of cgroup_get_from_id in cgorup.h

This patch also exported the function cgroup_get_e_css
as this is getting used in blk-cgroup.h

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v9:
Addressed the issues reported by kernel test robot

v8:
No change

v7:
No change

v6:
No change

v5:
renamed the function cgroup_get_from_kernfs_id to
cgroup_get_from_id

v4:
No change

v3:
Exported the cgroup_get_e_css

v2:
New patch
---
 include/linux/cgroup.h |  6 ++++++
 kernel/cgroup/cgroup.c | 26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4f2f79de083e..d2eace88d9d1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -696,6 +696,7 @@ static inline void cgroup_kthread_ready(void)
 }
 
 void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
+struct cgroup *cgroup_get_from_id(u64 id);
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
@@ -743,6 +744,11 @@ static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 
 static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 {}
+
+static inline struct cgroup *cgroup_get_from_id(u64 id)
+{
+	return NULL;
+}
 #endif /* !CONFIG_CGROUPS */
 
 #ifdef CONFIG_CGROUPS
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9153b20e5cc6..20e5424a8227 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -577,6 +577,7 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 	rcu_read_unlock();
 	return css;
 }
+EXPORT_SYMBOL_GPL(cgroup_get_e_css);
 
 static void cgroup_get_live(struct cgroup *cgrp)
 {
@@ -5768,6 +5769,31 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 	kernfs_put(kn);
 }
 
+/*
+ * cgroup_get_from_id : get the cgroup associated with cgroup id
+ * @id: cgroup id
+ * On success it returns the cgrp on failure it returns NULL
+ */
+struct cgroup *cgroup_get_from_id(u64 id)
+{
+	struct kernfs_node *kn;
+	struct cgroup *cgrp = NULL;
+
+	mutex_lock(&cgroup_mutex);
+	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
+	if (!kn)
+		goto out_unlock;
+
+	cgrp = kn->priv;
+	if (cgroup_is_dead(cgrp) || !cgroup_tryget(cgrp))
+		cgrp = NULL;
+	kernfs_put(kn);
+out_unlock:
+	mutex_unlock(&cgroup_mutex);
+	return cgrp;
+}
+EXPORT_SYMBOL_GPL(cgroup_get_from_id);
+
 /*
  * proc_cgroup_show()
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
-- 
2.26.2

