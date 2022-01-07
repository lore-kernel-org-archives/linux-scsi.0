Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E150CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Jan 2022 15:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347925AbiAGPLA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Jan 2022 10:11:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232227AbiAGPLA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2022 10:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641568259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IexUmlPEyALpq6clKWBupz42YnycD2masBzABJWHgaU=;
        b=Mwq8qX/8Q9dxeE8bsyzBIrZew8Bt5bxiOuM6ichgMlNH3gS0VnROy6T8K1uw16uoerxNjq
        Nozd1IbTBEIdYIn/XpwksjKoGLU9WTVsgrWWVBj31CZDEPKq+wZAioO+H8Qxi+CxW8JAmq
        lxV0SAh0/cZ2VXWTDJZRUx5eQBNuuNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-AQ14s0CxOP-rFjFfcfQeJA-1; Fri, 07 Jan 2022 10:10:57 -0500
X-MC-Unique: AQ14s0CxOP-rFjFfcfQeJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABEF5100CCC1;
        Fri,  7 Jan 2022 15:10:56 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.40.192.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8522D85F1A;
        Fri,  7 Jan 2022 15:10:55 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com
Subject: [PATCH] target: allow changing dbroot if there are no registered devices
Date:   Fri,  7 Jan 2022 16:10:54 +0100
Message-Id: <20220107151054.29734-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The target driver prevents the users from changing
the database root directory if a target module like ib_srpt has
been registered, this makes it difficult for users to
set their preferred database directory if the module
gets loaded during the system boot.

Let the users modify dbroot if there are no registered devices

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_configfs.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 023bd4516a68..cba10829e62f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -72,6 +72,8 @@ static struct config_group target_core_hbagroup;
 static struct config_group alua_group;
 static struct config_group alua_lu_gps_group;
 
+static unsigned int target_devices;
+
 static inline struct se_hba *
 item_to_hba(struct config_item *item)
 {
@@ -106,38 +108,32 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	ssize_t read_bytes;
 	struct file *fp;
 
-	mutex_lock(&g_tf_lock);
-	if (!list_empty(&g_tf_list)) {
-		mutex_unlock(&g_tf_lock);
-		pr_err("db_root: cannot be changed: target drivers registered");
+	if (target_devices) {
+		pr_err("db_root: cannot be changed because it's in use\n");
 		return -EINVAL;
 	}
 
 	if (count > (DB_ROOT_LEN - 1)) {
-		mutex_unlock(&g_tf_lock);
 		pr_err("db_root: count %d exceeds DB_ROOT_LEN-1: %u\n",
 		       (int)count, DB_ROOT_LEN - 1);
 		return -EINVAL;
 	}
 
 	read_bytes = snprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
-	if (!read_bytes) {
-		mutex_unlock(&g_tf_lock);
+	if (!read_bytes)
 		return -EINVAL;
-	}
+
 	if (db_root_stage[read_bytes - 1] == '\n')
 		db_root_stage[read_bytes - 1] = '\0';
 
 	/* validate new db root before accepting it */
 	fp = filp_open(db_root_stage, O_RDONLY, 0);
 	if (IS_ERR(fp)) {
-		mutex_unlock(&g_tf_lock);
 		pr_err("db_root: cannot open: %s\n", db_root_stage);
 		return -EINVAL;
 	}
 	if (!S_ISDIR(file_inode(fp)->i_mode)) {
 		filp_close(fp, NULL);
-		mutex_unlock(&g_tf_lock);
 		pr_err("db_root: not a directory: %s\n", db_root_stage);
 		return -EINVAL;
 	}
@@ -145,8 +141,6 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 
 	strncpy(db_root, db_root_stage, read_bytes);
 
-	mutex_unlock(&g_tf_lock);
-
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	return read_bytes;
@@ -3315,6 +3309,7 @@ static struct config_group *target_core_make_subdev(
 	 */
 	target_stat_setup_dev_default_groups(dev);
 
+	target_devices++;
 	mutex_unlock(&hba->hba_access_mutex);
 	return &dev->dev_group;
 
@@ -3353,6 +3348,7 @@ static void target_core_drop_subdev(
 	 * se_dev is released from target_core_dev_item_ops->release()
 	 */
 	config_item_put(item);
+	target_devices--;
 	mutex_unlock(&hba->hba_access_mutex);
 }
 
-- 
2.27.0

