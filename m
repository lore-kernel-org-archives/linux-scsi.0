From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [RESEND PATCH] [SCSI] mpt2sas: fix double mutex lock in NON_BLOCKING state
Date: Fri, 24 Aug 2012 21:14:38 +0400
Message-ID: <1345828479-30231-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.43]:41818 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab2HXRO6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Aug 2012 13:14:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>, linux-kernel@vger.kernel.org, ldv-project@ispras.ru

If state is NON_BLOCKING and mutex_trylock is succeed,
the control flow goes to mutex_lock_interruptible() that is a deadlock.

Found by Linux Driver Verification project (linuxtesting.org).

Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 49bdd2d..d29ea56 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2181,8 +2181,10 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 		return -EAGAIN;
 
 	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
-- 
1.7.9.5

