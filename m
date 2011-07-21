From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 082/103] target: Allow for built-in target modules
Date: Thu, 21 Jul 2011 00:12:05 -0700
Message-ID: <1311232346-6674-83-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:42877 "HELO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035Ab1GUHIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:44 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

In target_fabric_configfs_init(), we should allow fabric_mod to be NULL,
since THIS_MODULE is NULL for built-in modules.  The main method of
using the target code may be as modules, but having everything built-in
is useful eg to be able to do quick testing with "qemu -kernel".

In any case, we shouldn't bomb out fabric registration for a perfectly
valid configuration, so simply drop the check of fabric_mod.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 63cba1e..8d2aba5 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -306,10 +306,6 @@ struct target_fabric_configfs *target_fabric_configfs_init(
 {
 	struct target_fabric_configfs *tf;
 
-	if (!(fabric_mod)) {
-		printk(KERN_ERR "Missing struct module *fabric_mod pointer\n");
-		return ERR_PTR(-EINVAL);
-	}
 	if (!(name)) {
 		printk(KERN_ERR "Unable to locate passed fabric name\n");
 		return ERR_PTR(-EINVAL);
-- 
1.7.6

