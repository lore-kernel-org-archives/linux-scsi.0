From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: module: fix module_refcount() return when running in a module exit
 routine
Date: Sun, 18 Jan 2015 08:55:46 -0800
Message-ID: <1421600146.2080.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <JBottomley@Parallels.com>

After e513cc1 module: Remove stop_machine from module unloading,
module_refcount() is returning (unsigned long)-1 when called from within
a routine that runs in module_exit.  This is confusing the scsi device
put code which is coded to detect a module_refcount() of zero for
running within a module exit routine and not try to do another
module_put.  The fix is to restore the original behaviour of
module_refcount() and return zero if we're running inside an exit
routine.

Fixes: e513cc1c07e2ab93a4514eec9833e031df3e30bb
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---

diff --git a/kernel/module.c b/kernel/module.c
index 3965511..c33a113 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -774,7 +774,12 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 
 unsigned long module_refcount(struct module *mod)
 {
-	return (unsigned long)atomic_read(&mod->refcnt) - MODULE_REF_BASE;
+	unsigned long ret = atomic_read(&mod->refcnt);
+
+	if (ret == 0)
+		/* ref is already zero (probably in module exit) */
+		return 0;
+	return ret - MODULE_REF_BASE;
 }
 EXPORT_SYMBOL(module_refcount);
 
