From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][SCST]: Fix for minor scst_user race
Date: Mon, 26 Jan 2009 21:19:16 +0300
Message-ID: <497DFEA4.4040101@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:52025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZAZSTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 13:19:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net

This patch fixed race in scst_user module, which can lead to usage of already freed
command. A misbehaving user space handler can make ucmd to get dead immediately
after the lock is released and we should catch it.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 scst_user.c |    8 ++++++--
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: scst/src/dev_handlers/scst_user.c
===================================================================
--- scst/src/dev_handlers/scst_user.c	(revision 641)
+++ scst/src/dev_handlers/scst_user.c	(working copy)
@@ -1721,6 +1729,7 @@ static int dev_user_reply_get_cmd(struct
 	kmem_cache_free(user_get_cmd_cachep, cmd);
 
 	spin_lock_irq(&dev->cmd_lists.cmd_list_lock);
+again:
 	res = dev_user_get_next_cmd(dev, &ucmd);
 	if (res == 0) {
 		int len;
@@ -1730,12 +1739,15 @@ static int dev_user_reply_get_cmd(struct
 		 * copy of dead data to the user space, which can lead to a
 		 * leak of sensitive information.
 		 */
-		ucmd_get(ucmd);
+		if (unlikely(ucmd_get_check(ucmd))) {
+			/* Oops, this ucmd is already being destroyed. Retry. */
+			goto again;
+		}
 		spin_unlock_irq(&dev->cmd_lists.cmd_list_lock);
 
 		EXTRACHECKS_BUG_ON(ucmd->user_cmd_payload_len == 0);

