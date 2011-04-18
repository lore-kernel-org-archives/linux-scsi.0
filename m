From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] [SCSI] mpt2sas: fix double mutex lock in NON_BLOCKING state
Date: Mon, 18 Apr 2011 22:53:38 +0400
Message-ID: <1303152818-9856-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>
List-Id: linux-scsi@vger.kernel.org

If mutex_trylock succeed, the control flow goes to mutex_lock_interruptible()
that is not a good thing.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 1c6d2b4..9bd7ffc 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -648,8 +648,10 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 
 	issue_reset = 0;
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
@@ -1587,8 +1589,10 @@ _ctl_diag_register(void __user *arg, enum block_state state)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 	rc = _ctl_diag_register_2(ioc, &karg);
@@ -1932,8 +1936,10 @@ _ctl_diag_release(void __user *arg, enum block_state state)
 		return 0;
 	}
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
@@ -2033,8 +2039,10 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	}
 	/* Get a free request frame and save the message context.
 	*/
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
-- 
1.7.1
