From: janitor@sternwelten.at
Subject: [patch 03/10]  scsi/imm: replace 	schedule_timeout() with msleep()
Date: Thu, 21 Oct 2004 10:47:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYb6-0004BN-RD@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:31142 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270699AbUJUIrE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep() instead of schedule_timeout()
to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/imm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/imm.c~msleep-drivers_scsi_imm drivers/scsi/imm.c
--- linux-2.6.9/drivers/scsi/imm.c~msleep-drivers_scsi_imm	2004-10-21 02:41:27.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/imm.c	2004-10-21 02:41:27.000000000 +0200
@@ -1184,7 +1184,7 @@ static int __imm_attach(struct parport *
 	dev->waiting = &waiting;
 	prepare_to_wait(&waiting, &wait, TASK_UNINTERRUPTIBLE);
 	if (imm_pb_claim(dev))
-		schedule_timeout(3 * HZ);
+		msleep(3000);
 	if (dev->wanted) {
 		printk(KERN_ERR "imm%d: failed to claim parport because "
 			"a pardevice is owning the port for too long "
_
