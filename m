From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: gdth_proc.c:  Remove unused function
Date: Sun, 21 Dec 2014 00:09:48 +0100
Message-ID: <1419116988-13467-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove the function gdth_ioctl_check_bin() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/gdth_proc.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 9fb6326..efb9df5 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -598,24 +598,6 @@ static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, u64 paddr)
     }
 }
 
-#ifdef GDTH_IOCTL_PROC
-static int gdth_ioctl_check_bin(gdth_ha_str *ha, u16 size)
-{
-    unsigned long flags;
-    int ret_val;
-
-    spin_lock_irqsave(&ha->smp_lock, flags);
-
-    ret_val = FALSE;
-    if (ha->scratch_busy) {
-        if (((gdth_iord_str *)ha->pscratch)->size == (u32)size)
-            ret_val = TRUE;
-    }
-    spin_unlock_irqrestore(&ha->smp_lock, flags);
-    return ret_val;
-}
-#endif
-
 static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
     unsigned long flags;
-- 
1.7.10.4
