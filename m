From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Fri,  6 Feb 2015 15:33:41 +0100
Message-ID: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33329 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbbBFOdx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 09:33:53 -0500
Received: by mail-lb0-f180.google.com with SMTP id b6so18242189lbj.11
        for <linux-scsi@vger.kernel.org>; Fri, 06 Feb 2015 06:33:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

There is currently no %po format extension, so currently the letters
"on" are simply skipped and the pointer is printed as expected (while
missing the word on). However, it is probably only a matter of time
before someone comes up with a %po extension, at which point this is
likely to fail spectacularly.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ff283d23788a..e7c6b9c946d6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3105,7 +3105,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
 		if (cmd->sync_cmd == 1 || cmd->scmd) {
-			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
+			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p "
 					"on the defer queue as internal\n",
 				defer_index, cmd, cmd->sync_cmd, cmd->scmd);
 
-- 
2.1.3

