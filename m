From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2 of 4] sd: Show app tag on error
Date: Sun, 04 Jan 2009 03:04:32 -0500
Message-ID: <6585ae7f3fe863431bc3.1231056272@sermon.lab.mkp.net>
References: <patchbomb.1231056270@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:52468 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZADIWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:41 -0500
In-Reply-To: <patchbomb.1231056270@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Add application tag to the output displayed on error.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 3 insertions(+), 2 deletions(-)
drivers/scsi/sd_dif.c |    5 +++--



diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -475,8 +475,9 @@ int sd_dif_prepare(struct request *rq, s
 
 error:
 	kunmap_atomic(sdt, KM_USER0);
-	sd_printk(KERN_ERR, sdkp, "%s: virt %u, phys %u, ref %u\n",
-		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag));
+	sd_printk(KERN_ERR, sdkp, "%s: virt %u, phys %u, ref %u, app %4x\n",
+		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag),
+		  be16_to_cpu(sdt->app_tag));
 
 	return -EIO;
 }


