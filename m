From: domen@coderock.org
Subject: [patch 02/11] scsi/st: replace schedule_timeout() with msleep_interruptible()
Date: Sun, 06 Mar 2005 23:26:53 +0100
Message-ID: <20050306222654.47AD71EC90@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:49326 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261523AbVCFW1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com



Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/st.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/st.c~msleep_interruptible-drivers_scsi_st drivers/scsi/st.c
--- kj/drivers/scsi/st.c~msleep_interruptible-drivers_scsi_st	2005-03-05 16:11:03.000000000 +0100
+++ kj-domen/drivers/scsi/st.c	2005-03-05 16:11:03.000000000 +0100
@@ -36,6 +36,7 @@ static char *verstr = "20041025";
 #include <linux/moduleparam.h>
 #include <linux/devfs_fs_kernel.h>
 #include <linux/cdev.h>
+#include <linux/delay.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -760,9 +761,7 @@ static int test_ready(struct scsi_tape *
 
 			if (scode == NOT_READY) {
 				if (waits < max_wait) {
-					set_current_state(TASK_INTERRUPTIBLE);
-					schedule_timeout(HZ);
-					if (signal_pending(current)) {
+					if (msleep_interruptible(1000)) {
 						retval = (-EINTR);
 						break;
 					}
_
