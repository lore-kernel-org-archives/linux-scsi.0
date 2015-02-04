From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH] [SCSI] bfa: Remove use of struct timeval
Date: Wed, 4 Feb 2015 08:42:03 +0530
Message-ID: <20150204031203.GA3762@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56040 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbbBDDMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 22:12:08 -0500
Received: by mail-pa0-f41.google.com with SMTP id kq14so104556788pab.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Feb 2015 19:12:07 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>

struct timeval will have its tv_sec field overflow on 32-bit systems
in year 2038 and beyond. This patch removes the usage of struct timeval
and instead uses ktime_get_real_seconds() which returns 64-bit wall-clock
seconds.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 drivers/scsi/bfa/bfa_svc.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 625225f..5554461 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -14,6 +14,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/ktime.h>
 
 #include "bfad_drv.h"
 #include "bfad_im.h"
@@ -303,16 +304,9 @@ plkd_validate_logrec(struct bfa_plog_rec_s *pl_rec)
 	return 0;
 }
 
-static u64
-bfa_get_log_time(void)
+static u64 bfa_get_log_time(void)
 {
-	u64 system_time = 0;
-	struct timeval tv;
-	do_gettimeofday(&tv);
-
-	/* We are interested in seconds only. */
-	system_time = tv.tv_sec;
-	return system_time;
+	return ktime_get_real_seconds();
 }
 
 static void
-- 
2.2.0.rc0.207.ga3a616c

