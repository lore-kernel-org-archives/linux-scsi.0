From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] scsi/snic: fixing the error print
Date: Thu, 25 Jun 2015 15:22:16 +0530
Message-ID: <1435225936-10250-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44077 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbFYJyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2015 05:54:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nmusini@cisco.com, sebaddel@cisco.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>

Currently SNIC_HOST_ERR is called in both cases
whether snic_disc_start returns zero or non-zero.

>From the code it looks like it has to print only if
snic_disc_start return non-zero value, So calling
SNIC_HOST_ERR only for non-zero return from snic_disc_start.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Rohit Thapliyal <r.thapliyal@samsung.com>
---
 drivers/scsi/snic/snic_disc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index 5f63217..8c29d5e 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -514,12 +514,9 @@ snic_handle_disc(struct work_struct *work)
 
 	ret = snic_disc_start(snic);
 	if (ret)
-		goto disc_err;
-
-disc_err:
-	SNIC_HOST_ERR(snic->shost,
-		      "disc_work: Discovery Failed w/ err = %d\n",
-		      ret);
+		SNIC_HOST_ERR(snic->shost,
+			      "disc_work: Discovery Failed w/ err = %d\n",
+			      ret);
 } /* end of snic_disc_work */
 
 /*
-- 
1.7.9.5

