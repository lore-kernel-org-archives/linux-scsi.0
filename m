From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd_dif: Return correct error code
Date: Tue, 10 Nov 2009 00:39:12 -0500
Message-ID: <yq1y6mfndkv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:22439 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZKJFkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 00:40:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com


sd_dif.c was not updated to return -EILSEQ, leading to error handling
failures in applications which provide their own integrity metadata (as
opposed to being protected by the block layer functions).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 88da977..84be621 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -418,7 +418,7 @@ error:
 		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag),
 		  be16_to_cpu(sdt->app_tag));
 
-	return -EIO;
+	return -EILSEQ;
 }
 
 /*
