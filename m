From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 3/7] scsi/dpt_i2o: replace schedule_timeout() with msleep_interruptible()
Date: Wed, 12 Jan 2005 11:43:50 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BA3B764@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:24970 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261244AbVALQoD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 11:44:03 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, nacc@us.ibm.com, janitor@sternwelten.at

There was a patch to *remove* that line completely issued about a month
ago. It is a case of a second schedule_timeout left over from an editing
mistake made long ago in a distant galaxy.

I am suggesting:

diff -puN
drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o
drivers/scsi/dpt_i2o.c
--- kj/drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o
2005-01-10 18:00:12.000000000 +0100
+++ kj-domen/drivers/scsi/dpt_i2o.c	2005-01-10 18:00:12.000000000
+0100
@@ -1178,7 +1178,6 @@ static int adpt_i2o_post_wait(adpt_hba* 
 				// dangerous.
 				status = -ETIME;
 			}
-			schedule_timeout(timeout*HZ);
		}
 		if(pHba->host)
 			spin_lock_irq(pHba->host->host_lock);

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
domen@coderock.org
Sent: Tuesday, January 11, 2005 6:23 PM
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org; domen@coderock.org; nacc@us.ibm.com;
janitor@sternwelten.at
Subject: [patch 3/7] scsi/dpt_i2o: replace schedule_timeout() with
msleep_interruptible()




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/dpt_i2o.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN
drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o
drivers/scsi/dpt_i2o.c
--- kj/drivers/scsi/dpt_i2o.c~msleep_interruptible-drivers_scsi_dpt_i2o
2005-01-10 18:00:12.000000000 +0100
+++ kj-domen/drivers/scsi/dpt_i2o.c	2005-01-10 18:00:12.000000000
+0100
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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
