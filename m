From: janitor@sternwelten.at
Subject: [patch 10/10]  scsi/st: replace 	schedule_timeout() with msleep_interruptible()
Date: Thu, 21 Oct 2004 10:47:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYbS-0004Uu-MB@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:55433 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270409AbUJUIrY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com, Kai.Makisara@kolumbus.fi




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>

---

 linux-2.6.9-max/drivers/scsi/st.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/st.c~msleep_interruptible-drivers_scsi_st drivers/scsi/st.c
--- linux-2.6.9/drivers/scsi/st.c~msleep_interruptible-drivers_scsi_st	2004-10-21 02:41:55.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/st.c	2004-10-21 02:41:55.000000000 +0200
@@ -760,8 +760,7 @@ static int test_ready(Scsi_Tape *STp, in
 
 			if (scode == NOT_READY) {
 				if (waits < max_wait) {
-					set_current_state(TASK_INTERRUPTIBLE);
-					schedule_timeout(HZ);
+					msleep_interruptible(1000);
 					if (signal_pending(current)) {
 						retval = (-EINTR);
 						break;
_
