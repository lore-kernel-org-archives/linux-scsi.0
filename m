From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH 1/6] scsi: bfa: bfa_svc: Use ktime_get_real_seconds()
Date: Sat, 9 Jan 2016 19:56:50 +0530
Message-ID: <20160109142650.GA7406@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org
List-Id: linux-scsi@vger.kernel.org

32 bit systems using 'struct timeval' will break in the year 2038, so
we modify the code appropriately.

This patch removes the function bfa_get_log_time() which is only used
to get current time in seconds. bfa_get_log_time() is replaced with
ktime_get_real_seconds() which returns a 64 bit value.

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/scsi/bfa/bfa_svc.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 625225f..b3668e9 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include <linux/ktime.h>
 #include "bfad_drv.h"
 #include "bfad_im.h"
 #include "bfa_plog.h"
@@ -303,18 +304,6 @@ plkd_validate_logrec(struct bfa_plog_rec_s *pl_rec)
 	return 0;
 }
 
-static u64
-bfa_get_log_time(void)
-{
-	u64 system_time = 0;
-	struct timeval tv;
-	do_gettimeofday(&tv);
-
-	/* We are interested in seconds only. */
-	system_time = tv.tv_sec;
-	return system_time;
-}
-
 static void
 bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
 {
@@ -335,7 +324,7 @@ bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
 
 	memcpy(pl_recp, pl_rec, sizeof(struct bfa_plog_rec_s));
 
-	pl_recp->tv = bfa_get_log_time();
+	pl_recp->tv = ktime_get_real_seconds();
 	BFA_PL_LOG_REC_INCR(plog->tail);
 
 	if (plog->head == plog->tail)
@@ -6278,7 +6267,7 @@ bfa_fcdiag_lb_is_running(struct bfa_s *bfa)
  *	D-port
  */
 #define bfa_dport_result_start(__dport, __mode) do {			\
-		(__dport)->result.start_time = bfa_get_log_time();	\
+		(__dport)->result.start_time = ktime_get_real_seconds();\
 		(__dport)->result.status = DPORT_TEST_ST_INPRG;		\
 		(__dport)->result.mode = (__mode);			\
 		(__dport)->result.rp_pwwn = (__dport)->rp_pwwn;		\
@@ -6717,7 +6706,7 @@ bfa_dport_scn(struct bfa_dport_s *dport, struct bfi_diag_dport_scn_s *msg)
 
 	switch (dport->i2hmsg.scn.state) {
 	case BFI_DPORT_SCN_TESTCOMP:
-		dport->result.end_time = bfa_get_log_time();
+		dport->result.end_time = ktime_get_real_seconds();
 		bfa_trc(dport->bfa, dport->result.end_time);
 
 		dport->result.status = msg->info.testcomp.status;
@@ -6764,7 +6753,7 @@ bfa_dport_scn(struct bfa_dport_s *dport, struct bfi_diag_dport_scn_s *msg)
 	case BFI_DPORT_SCN_SUBTESTSTART:
 		subtesttype = msg->info.teststart.type;
 		dport->result.subtest[subtesttype].start_time =
-			bfa_get_log_time();
+			ktime_get_real_seconds();
 		dport->result.subtest[subtesttype].status =
 			DPORT_TEST_ST_INPRG;
 
-- 
1.9.1
