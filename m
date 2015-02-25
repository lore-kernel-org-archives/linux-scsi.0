From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH v2] [SCSI] bfa: Replace bfa_get_log_time()
Date: Wed, 25 Feb 2015 07:44:39 +0530
Message-ID: <20150225021439.GA2819@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33052 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbBYCOu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2015 21:14:50 -0500
Received: by pabkx10 with SMTP id kx10so1405477pab.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2015 18:14:50 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

struct timeval will have its tv_sec field overflow on 32-bit systems
in year 2038 and beyond. This patch removes bfa_get_log_time which
uses struct timeval, and instead replaces calls to it with
calls to ktime_get_real_seconds() which returns 64-bit wall-clock
seconds.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
--
Changes in v2:
  - Removed call to bfa_get_log_time entirely, instead of retaining
    it and making it call ktime_get_real_seconds internally.
  - Made subject line more clear.
---
 drivers/scsi/bfa/bfa_svc.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 625225f..dd7cc36 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -14,6 +14,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/ktime.h>
 
 #include "bfad_drv.h"
 #include "bfad_im.h"
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
2.2.0.rc0.207.ga3a616c

