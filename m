From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH RESEND] bfa: deinline __bfa_trc() and __bfa_trc32()
Date: Thu,  4 Feb 2016 21:40:48 +0100
Message-ID: <1454618448-1381-1-git-send-email-dvlasenk@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

__bfa_trc() compiles to 115 bytes of machine code.
With this .config: http://busybox.net/~vda/kernel_config
there are 1494 calls of __bfa_trc().

__bfa_trc32() is very similar, so it is uninlined too.
However, it appears to be unused, therefore this patch
ifdefs it out.

Change in code size is about 130,000 bytes:

    text     data      bss       dec     hex filename
85975426 22294712 20627456 128897594 7aed23a vmlinux.before
85842882 22294584 20627456 128764922 7accbfa vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
CC: Fabian Frederick <fabf@skynet.be>
CC: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Guenter Roeck <linux@roeck-us.net>
CC: Ben Hutchings <ben@decadent.org.uk>
CC: James Bottomley <JBottomley@Parallels.com>
CC: linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org
---
 drivers/scsi/bfa/bfa_core.c | 40 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_cs.h   | 41 ++++-------------------------------------
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index e3f67b0..3657a00 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -90,6 +90,46 @@ static bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] = {
 
 
 
+void
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s	*trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u64 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+}
+
+#if 0 /* UNUSED */
+void
+__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s *trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u32.u32 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+}
+#endif
+
 static void
 bfa_com_port_attach(struct bfa_s *bfa)
 {
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 91a8aa3..dd3154e 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -107,44 +107,11 @@ bfa_trc_stop(struct bfa_trc_mod_s *trcm)
 	trcm->stopped = 1;
 }
 
-static inline void
-__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data)
-{
-	int		tail = trcm->tail;
-	struct bfa_trc_s	*trc = &trcm->trc[tail];
-
-	if (trcm->stopped)
-		return;
-
-	trc->fileno = (u16) fileno;
-	trc->line = (u16) line;
-	trc->data.u64 = data;
-	trc->timestamp = BFA_TRC_TS(trcm);
-
-	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
-	if (trcm->tail == trcm->head)
-		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
-}
-
+void
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data);
 
-static inline void
-__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
-{
-	int		tail = trcm->tail;
-	struct bfa_trc_s *trc = &trcm->trc[tail];
-
-	if (trcm->stopped)
-		return;
-
-	trc->fileno = (u16) fileno;
-	trc->line = (u16) line;
-	trc->data.u32.u32 = data;
-	trc->timestamp = BFA_TRC_TS(trcm);
-
-	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
-	if (trcm->tail == trcm->head)
-		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
-}
+void
+__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data);
 
 #define bfa_sm_fault(__mod, __event)	do {				\
 	bfa_trc(__mod, (((u32)0xDEAD << 16) | __event));		\
-- 
1.8.1.4
