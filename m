From: domen@coderock.org
Subject: [patch 2/7] scsi/ppa: replace schedule_timeout() with msleep()
Date: Wed, 12 Jan 2005 00:22:50 +0100
Message-ID: <20050111232251.3BBB31F226@trashy.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:27589 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262933AbVAKXW7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 18:22:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com, janitor@sternwelten.at




Any comments would be appreciated.

Description: Use msleep() instead of schedule_timeout()
to guarantee the task delays as expected.

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/ppa.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ppa.c~msleep-drivers_scsi_ppa drivers/scsi/ppa.c
--- kj/drivers/scsi/ppa.c~msleep-drivers_scsi_ppa	2005-01-10 18:00:05.000000000 +0100
+++ kj-domen/drivers/scsi/ppa.c	2005-01-10 18:00:05.000000000 +0100
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
