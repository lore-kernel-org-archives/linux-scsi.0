From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] bfa: deinline __bfa_trc, wwn2str and fcid2str
Date: Mon, 21 Sep 2015 14:04:31 +0200
Message-ID: <1442837071-17803-1-git-send-email-dvlasenk@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Krishna Gudipati <kgudipat@brocade.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>, James Bottomley <JBottomley@Parallels.com>, Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining these functions have sizes and callsite counts
as follows:

__bfa_trc: 115 bytes, 1494 calls
wwn2str: 108 bytes, 27 calls
fcid2str: 46 bytes, 3 calls

__bfa_trc32 is similar to __bfa_trc, so it should have been
uninlined too. However, it is also unused.
Anil Gurumurthy suggested I can just delete it, I did so.

Change in code size is about 135,000 bytes:

    text     data      bss       dec     hex filename
91470054 19945080 36421632 147836766 8cfcf5e vmlinux.before
91335078 19944984 36421632 147701694 8cdbfbe vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Krishna Gudipati <kgudipat@brocade.com>
CC: Vijaya Mohan Guvva <vmohan@brocade.com>
CC: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
CC: James Bottomley <JBottomley@Parallels.com>
CC: Fabian Frederick <fabf@skynet.be>
CC: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Guenter Roeck <linux@roeck-us.net>
CC: Ben Hutchings <ben@decadent.org.uk>
CC: James Bottomley <JBottomley@Parallels.com>
CC: linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org
---
 drivers/scsi/bfa/bfa_core.c | 45 ++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_cs.h   | 67 +++------------------------------------------
 2 files changed, 49 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index e3f67b0..fdf0f4e 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -90,6 +90,51 @@ static bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] = {
 
 
 
+void
+wwn2str(char *wwn_str, u64 wwn)
+{
+	union {
+		u64 wwn;
+		u8 byte[8];
+	} w;
+
+	w.wwn = wwn;
+	sprintf(wwn_str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", w.byte[0],
+		w.byte[1], w.byte[2], w.byte[3], w.byte[4], w.byte[5],
+		w.byte[6], w.byte[7]);
+}
+
+void
+fcid2str(char *fcid_str, u32 fcid)
+{
+	union {
+		u32 fcid;
+		u8 byte[4];
+	} f;
+
+	f.fcid = fcid;
+	sprintf(fcid_str, "%02x:%02x:%02x", f.byte[1], f.byte[2], f.byte[3]);
+}
+
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
 static void
 bfa_com_port_attach(struct bfa_s *bfa)
 {
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 91a8aa3..3f00eab 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -107,44 +107,8 @@ bfa_trc_stop(struct bfa_trc_mod_s *trcm)
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
-
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
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data);
 
 #define bfa_sm_fault(__mod, __event)	do {				\
 	bfa_trc(__mod, (((u32)0xDEAD << 16) | __event));		\
@@ -324,31 +288,8 @@ bfa_wc_wait(struct bfa_wc_s *wc)
 	bfa_wc_down(wc);
 }
 
-static inline void
-wwn2str(char *wwn_str, u64 wwn)
-{
-	union {
-		u64 wwn;
-		u8 byte[8];
-	} w;
-
-	w.wwn = wwn;
-	sprintf(wwn_str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", w.byte[0],
-		w.byte[1], w.byte[2], w.byte[3], w.byte[4], w.byte[5],
-		w.byte[6], w.byte[7]);
-}
-
-static inline void
-fcid2str(char *fcid_str, u32 fcid)
-{
-	union {
-		u32 fcid;
-		u8 byte[4];
-	} f;
-
-	f.fcid = fcid;
-	sprintf(fcid_str, "%02x:%02x:%02x", f.byte[1], f.byte[2], f.byte[3]);
-}
+void wwn2str(char *wwn_str, u64 wwn);
+void fcid2str(char *fcid_str, u32 fcid);
 
 #define bfa_swap_3b(_x)				\
 	((((_x) & 0xff) << 16) |		\
-- 
1.8.1.4
