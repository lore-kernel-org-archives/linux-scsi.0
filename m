Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B0FEB64DA
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jul 2023 15:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjGVP1Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jul 2023 11:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjGVP1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2023 11:27:23 -0400
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D282719;
        Sat, 22 Jul 2023 08:27:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 612CFC0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690039640; bh=O9q9yFCTBEwldl33FgOD+v5TZGvujKA8XxRacOpV3Ag=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=FYBm+3XDcUXjwRBGY32KXPTcaOEIFzhaUQKejaTwkOrcXBKbsQsWTsMO31xroxCGC
         RaiA2ZvbKUPU3jiujSxdBULO/sN4X63dF8qGMgNicIi5wnkqY7THx45vnpiJRhvbaA
         DP90UxxoABSVTYLoBdLTsKkh8RdvaIHQZMMCqhFKGboiSgCYCp8RIlFvWAFhGTyC0r
         KAvS0EbCP4lVxoXQPXhIzaZW7QWzVLAmz2l6Q5Y6UpryLloQwR6kEW1bxlij6QP2GG
         xfn2C4WgxQTKnWPwweNJk0mycu6fNsgF+rlqLJjv5JVI6Rq6WBpjrqpZUD8ya/cBa6
         BA9bkKumHHb8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690039640; bh=O9q9yFCTBEwldl33FgOD+v5TZGvujKA8XxRacOpV3Ag=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=XWkaXszXAX/iLc0yB6n7/Evi/3580SC8Z42zhGCiTeDJLEv4CPQNlsVQpYzHMvr/M
         P6pumjVTn+ia5jiMa5j6n1ayE9SciYNSQAAxvfvyhPc7WfAOhPH7o/iu8qcI0kwJwH
         lYJadZws6ZISvUCdVHh+UT01wijPh50qpspp4uOt468LsE0H0/V9ue7/HRHq7TcVav
         T3LXTzeiqlH7dGt2U6Vuc9aFHko8fyRWcxRqM+QzqNTzRfB5QSv69w0AhTI6fOE911
         2SchpUOT0hLc9ww+xkPjdC05zWCXdqlHQgMV6ONNOT/OATmv8xYhcJcfy3pt6wOaf/
         pE66RvWmj862A==
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH 2/2] scsi: target: iscsi: Stop using sprintf in iscsi_target_configfs.c
Date:   Sat, 22 Jul 2023 18:26:38 +0300
Message-ID: <20230722152657.168859-3-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230722152657.168859-1-k.shelekhin@yadro.com>
References: <20230722152657.168859-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Get rid of sprintf in favor of sysfs_emit. The latter ensures not to
overflow the given buffer.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index c142a67dc7cc..098eae55c4c5 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -45,9 +45,9 @@ static ssize_t lio_target_np_driver_show(struct config_item *item, char *page,
 
 	tpg_np_new = iscsit_tpg_locate_child_np(tpg_np, type);
 	if (tpg_np_new)
-		rb = sprintf(page, "1\n");
+		rb = sysfs_emit(page, "1\n");
 	else
-		rb = sprintf(page, "0\n");
+		rb = sysfs_emit(page, "0\n");
 
 	return rb;
 }
@@ -282,7 +282,7 @@ static ssize_t iscsi_nacl_attrib_##name##_show(struct config_item *item,\
 {									\
 	struct se_node_acl *se_nacl = attrib_to_nacl(item);		\
 	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);		\
-	return sprintf(page, "%u\n", nacl->node_attrib.name);		\
+	return sysfs_emit(page, "%u\n", nacl->node_attrib.name);		\
 }									\
 									\
 static ssize_t iscsi_nacl_attrib_##name##_store(struct config_item *item,\
@@ -320,7 +320,7 @@ static ssize_t iscsi_nacl_attrib_authentication_show(struct config_item *item,
 	struct se_node_acl *se_nacl = attrib_to_nacl(item);
 	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);
 
-	return sprintf(page, "%d\n", nacl->node_attrib.authentication);
+	return sysfs_emit(page, "%d\n", nacl->node_attrib.authentication);
 }
 
 static ssize_t iscsi_nacl_attrib_authentication_store(struct config_item *item,
@@ -641,7 +641,7 @@ static ssize_t lio_target_nacl_info_show(struct config_item *item, char *page)
 static ssize_t lio_target_nacl_cmdsn_depth_show(struct config_item *item,
 		char *page)
 {
-	return sprintf(page, "%u\n", acl_to_nacl(item)->queue_depth);
+	return sysfs_emit(page, "%u\n", acl_to_nacl(item)->queue_depth);
 }
 
 static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
@@ -750,7 +750,7 @@ static ssize_t iscsi_tpg_attrib_##name##_show(struct config_item *item,	\
 	if (iscsit_get_tpg(tpg) < 0)					\
 		return -EINVAL;						\
 									\
-	rb = sprintf(page, "%u\n", tpg->tpg_attrib.name);		\
+	rb = sysfs_emit(page, "%u\n", tpg->tpg_attrib.name);		\
 	iscsit_put_tpg(tpg);						\
 	return rb;							\
 }									\
@@ -1138,7 +1138,7 @@ static void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
 static ssize_t lio_target_wwn_lio_version_show(struct config_item *item,
 		char *page)
 {
-	return sprintf(page, "Datera Inc. iSCSI Target "ISCSIT_VERSION"\n");
+	return sysfs_emit(page, "Datera Inc. iSCSI Target %s\n", ISCSIT_VERSION);
 }
 
 CONFIGFS_ATTR_RO(lio_target_wwn_, lio_version);
@@ -1146,7 +1146,7 @@ CONFIGFS_ATTR_RO(lio_target_wwn_, lio_version);
 static ssize_t lio_target_wwn_cpus_allowed_list_show(
 		struct config_item *item, char *page)
 {
-	return sprintf(page, "%*pbl\n",
+	return sysfs_emit(page, "%*pbl\n",
 		       cpumask_pr_args(iscsit_global->allowed_cpumask));
 }
 
@@ -1283,7 +1283,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_show(struct config_item *item,
 {
 	struct iscsi_node_auth *discovery_auth = &iscsit_global->discovery_acl.node_auth;
 
-	return sprintf(page, "%d\n", discovery_auth->enforce_discovery_auth);
+	return sysfs_emit(page, "%d\n", discovery_auth->enforce_discovery_auth);
 }
 
 static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
-- 
2.41.0

