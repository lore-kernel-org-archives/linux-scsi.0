From: Dan Carpenter <error27@gmail.com>
Subject: [patch] fix locking in mpt2sas_ctl.c
Date: Wed, 22 Apr 2009 18:40:37 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0904211827320.28180@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:36198 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbZDVPkx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 11:40:53 -0400
Received: by wa-out-1112.google.com with SMTP id j5so13053wah.21
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 08:40:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

With state == NON_BLOCKING, we would either return -EAGAIN or double lock.

The other thing in patch is:
-                       return -ENOMEM;
+                       rc = -ENOMEM;
+                       goto out;

Going to out releases the ioc->ctl_cmds.mutex lock and sets 
ioc->ctl_cmds.status = MPT2_CMD_NOT_USED.

The patch is against 2.6.30-rc1.  Sorry if that is too old...
Found by smatch (http://repo.or.cz/w/smatch.git).  Compile tested only.  :/

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-21 18:23:44.000000000 +0300
+++ devel/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-21 18:38:41.000000000 +0300
@@ -550,7 +550,7 @@
 
 	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
 		return -EAGAIN;
-	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
+	if (state != NON_BLOCKING && mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
@@ -1269,7 +1269,7 @@
 
 	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
 		return -EAGAIN;
-	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
+	if (state != NON_BLOCKING && mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
@@ -1321,7 +1321,8 @@
 			    " for diag buffers, requested size(%d)\n",
 			    ioc->name, __func__, request_data_sz);
 			mpt2sas_base_free_smid(ioc, smid);
-			return -ENOMEM;
+			rc = -ENOMEM;
+			goto out;
 		}
 		ioc->diag_buffer[buffer_type] = request_data;
 		ioc->diag_buffer_sz[buffer_type] = request_data_sz;
@@ -1623,7 +1624,7 @@
 
 	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
 		return -EAGAIN;
-	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
+	if (state != NON_BLOCKING && mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
@@ -1787,7 +1788,7 @@
 	*/
 	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
 		return -EAGAIN;
-	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
+	if (state != NON_BLOCKING && mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
