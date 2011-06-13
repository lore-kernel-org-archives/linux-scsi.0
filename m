From: Dan Carpenter <error27@gmail.com>
Subject: [patch 3/4] SCSI: target: don't return ERR_PTR in
 target_fabric_configfs_init()
Date: Mon, 13 Jun 2011 23:10:49 +0300
Message-ID: <20110613201049.GJ3583@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38245 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1FMULo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 16:11:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

In the original code, there were several places inside the
target_fabric_configfs_init() function that returned NULL on error
and one place the returned an ERR_PTR.  There are two places that
call this function and they only check for NULL returns; they don't
check for ERR_PTRs.  So I've changed the ERR_PTR so now the function
only returns NULL on error.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ee6fad9..b17abd1 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -312,7 +312,7 @@ struct target_fabric_configfs *target_fabric_configfs_init(
 
 	tf = kzalloc(sizeof(struct target_fabric_configfs), GFP_KERNEL);
 	if (!(tf))
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	INIT_LIST_HEAD(&tf->tf_list);
 	atomic_set(&tf->tf_access_cnt, 0);
