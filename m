From: janitor@sternwelten.at
Subject: [patch 05/10]  scsi/ppa: replace 	schedule_timeout() with msleep()
Date: Thu, 21 Oct 2004 10:47:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYbC-0004Gd-W6@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:27112 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270709AbUJUIrK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep() instead of schedule_timeout()
to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/ppa.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ppa.c~msleep-drivers_scsi_ppa drivers/scsi/ppa.c
--- linux-2.6.9/drivers/scsi/ppa.c~msleep-drivers_scsi_ppa	2004-10-21 02:41:32.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/ppa.c	2004-10-21 02:41:32.000000000 +0200
@@ -1034,7 +1034,7 @@ static int __ppa_attach(struct parport *
 	dev->waiting = &waiting;
 	prepare_to_wait(&waiting, &wait, TASK_UNINTERRUPTIBLE);
 	if (ppa_pb_claim(dev))
-		schedule_timeout(3 * HZ);
+		msleep(3000);
 	if (dev->wanted) {
 		printk(KERN_ERR "ppa%d: failed to claim parport because "
 				"a pardevice is owning the port for too long "
_
