From: domen@coderock.org
Subject: [patch 3/7] scsi/dpt_i2o: replace schedule_timeout() with msleep_interruptible()
Date: Wed, 12 Jan 2005 00:22:53 +0100
Message-ID: <20050111232254.51BCD1F225@trashy.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:29381 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262934AbVAKXXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 18:23:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com, janitor@sternwelten.at




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/dpt_i2o.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o drivers/scsi/dpt_i2o.c
--- kj/drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o	2005-01-10 18:00:12.000000000 +0100
+++ kj-domen/drivers/scsi/dpt_i2o.c	2005-01-10 18:00:12.000000000 +0100
@@ -1178,7 +1178,7 @@ static int adpt_i2o_post_wait(adpt_hba* 
 				// dangerous.
 				status = -ETIME;
 			}
-			schedule_timeout(timeout*HZ);
+			msleep_interruptible(timeout * 1000);
 		}
 		if(pHba->host)
 			spin_lock_irq(pHba->host->host_lock);
_
