From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 08/10]  scsi/dpt_i2o: replace 	schedule_timeout() with msleep_interruptible()
Date: Thu, 21 Oct 2004 07:44:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B40B5B1@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:34794 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S270699AbUJULpP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 07:45:15 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: janitor@sternwelten.at, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, nacc@us.ibm.com

The timeout granularity of 1 second should be the first clue that this
is not important. Commands complete and wake up the task under normal
operation; the timeout is to deal with an errant controller.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
janitor@sternwelten.at
Sent: Thursday, October 21, 2004 4:47 AM
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org; janitor@sternwelten.at; nacc@us.ibm.com
Subject: [patch 08/10] scsi/dpt_i2o: replace schedule_timeout() with
msleep_interruptible()




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/dpt_i2o.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN
drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o
drivers/scsi/dpt_i2o.c
---
linux-2.6.9/drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt
_i2o	2004-10-21 02:41:53.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/dpt_i2o.c	2004-10-21
02:41:53.000000000 +0200
@@ -1179,7 +1179,7 @@ static int adpt_i2o_post_wait(adpt_hba* 
 				// dangerous.
 				status = -ETIME;
 			}
-			schedule_timeout(timeout*HZ);
+			msleep_interruptible(timeout * 1000);
 		}
 		if(pHba->host)
 			spin_lock_irq(pHba->host->host_lock);
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
