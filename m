Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6318C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 19:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E53960FD7
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 19:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhI0Tj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 15:39:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhI0Tj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 15:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632771499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w8zVEowPpHEw4K+DjtjdHUbsuCY06YRlaczJf98yNn0=;
        b=J3/gSD7lFBOzsFTjkDNUrWVOwSQpWyI12dDBKYwv4UBWhfp7Pw6xT2a31eLmxw5LeMwmN7
        +GMlHA4fl8XfCRrQP+cG1MsyjjeCfjWpfJvd3sSSRp1z2M9yZICfmRGihN9T8o8ojRR08D
        c7KhSdeRuraTnNl91GtxXSLD1DHwdg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-Gz1bFcK-NzK6xGoEiP2Fcw-1; Mon, 27 Sep 2021 15:38:18 -0400
X-MC-Unique: Gz1bFcK-NzK6xGoEiP2Fcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FF3D1084683;
        Mon, 27 Sep 2021 19:38:17 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.40.193.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD80C3AC0;
        Mon, 27 Sep 2021 19:38:15 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     bostroesser@gmail.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] target: allow setting dbroot as a module parameter
Date:   Mon, 27 Sep 2021 21:38:14 +0200
Message-Id: <20210927193814.79111-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The target driver prevents the users from changing
the database root directory if a target module like ib_srpt
has already been loaded during boot.

Let the users set their preferred root directory
by passing it as a module parameter. This, combined
with the modprobe.d's "options" command,
will mitigate the issue because the parameter will be
automatically passed every time the target_core_mod module is inserted
into the kernel; whether directly (using modprobe) or
because another module being loaded depends on it.

If the directory cannot be opened, the target driver will print
an error and fall back to its default (/etc/target)

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_configfs.c | 29 ++++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 274ffb6b83a1..c0fc6312aa20 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -100,7 +100,10 @@ static ssize_t target_core_item_version_show(struct config_item *item,
 CONFIGFS_ATTR_RO(target_core_item_, version);
 
 char db_root[DB_ROOT_LEN] = DB_ROOT_DEFAULT;
-static char db_root_stage[DB_ROOT_LEN];
+static char db_root_stage[DB_ROOT_LEN] = {0};
+
+module_param_string(dbroot, db_root_stage, DB_ROOT_LEN, 0);
+MODULE_PARM_DESC(dbroot, "Target database root directory (def=/etc/target)");
 
 static ssize_t target_core_item_dbroot_show(struct config_item *item,
 					    char *page)
@@ -3507,25 +3510,25 @@ void target_setup_backend_cits(struct target_backend *tb)
 	target_core_setup_dev_stat_cit(tb);
 }
 
-static void target_init_dbroot(void)
+static int target_init_dbroot(char *path)
 {
 	struct file *fp;
 
-	snprintf(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
-	fp = filp_open(db_root_stage, O_RDONLY, 0);
+	fp = filp_open(path, O_RDONLY, 0);
 	if (IS_ERR(fp)) {
-		pr_err("db_root: cannot open: %s\n", db_root_stage);
-		return;
+		pr_err("db_root: cannot open: %s\n", path);
+		return -EINVAL;
 	}
 	if (!S_ISDIR(file_inode(fp)->i_mode)) {
 		filp_close(fp, NULL);
-		pr_err("db_root: not a valid directory: %s\n", db_root_stage);
-		return;
+		pr_err("db_root: not a valid directory: %s\n", path);
+		return -EINVAL;
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
+	strlcpy(db_root, path, DB_ROOT_LEN);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
+	return 0;
 }
 
 static int __init target_core_init_configfs(void)
@@ -3608,7 +3611,13 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
-	target_init_dbroot();
+	if (db_root_stage[0]) {
+		ret = target_init_dbroot(db_root_stage);
+		if (ret < 0)
+			target_init_dbroot(DB_ROOT_PREFERRED);
+	} else {
+		target_init_dbroot(DB_ROOT_PREFERRED);
+	}
 
 	return 0;
 
-- 
2.27.0

