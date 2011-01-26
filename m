From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] target: allow release() to be called on NULL
 pointers
Date: Wed, 26 Jan 2011 11:58:25 +0300
Message-ID: <20110126085825.GM2721@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51377 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab1AZI6q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2011 03:58:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This is a cleanup and not a bugfix.

container_of() does pointer math and the result of that math can
basically not be NULL here so "se_dev" is non-NULL.

Normally release() type functions accept a NULL parameter.  I don't
think target_core_dev_release() is ever called with a NULL parameter but
it's a cleaner to allow that.

So instead of checking "se_dev", I've changed it to check "item".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2764510..d9dcd9d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1973,7 +1973,7 @@ static void target_core_dev_release(struct config_item *item)
 				struct se_subsystem_dev, se_dev_group);
 	struct config_group *dev_cg;
 
-	if (!(se_dev))
+	if (!item)
 		return;
 
 	dev_cg = &se_dev->se_dev_group;
