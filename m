From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2 of 3] sd: Always print actual protection_type
Date: Fri, 19 Sep 2008 18:47:20 -0400
Message-ID: <cc6088963c66d955725d.1221864440@sermon.lab.mkp.net>
References: <patchbomb.1221864438@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:48240 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbYISW6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2008 18:58:55 -0400
In-Reply-To: <patchbomb.1221864438@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Now that we no longer use protection_type as trigger for preparing
protected CDBs we can remove the places that set it to zero.  This
allows userland to see which protection type the device is formatted
with regardless of whether the HBA supports DIF or not.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 2 insertions(+), 6 deletions(-)
drivers/scsi/sd.c     |    7 ++-----
drivers/scsi/sd_dif.c |    1 -



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1248,14 +1248,12 @@ void sd_read_protection_type(struct scsi
 	else
 		type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 
+	sdkp->protection_type = type;
+
 	switch (type) {
 	case SD_DIF_TYPE0_PROTECTION:
-		sdkp->protection_type = 0;
-		break;
-
 	case SD_DIF_TYPE1_PROTECTION:
 	case SD_DIF_TYPE3_PROTECTION:
-		sdkp->protection_type = type;
 		break;
 
 	case SD_DIF_TYPE2_PROTECTION:
@@ -1273,7 +1271,6 @@ void sd_read_protection_type(struct scsi
 	return;
 
 disable:
-	sdkp->protection_type = 0;
 	sdkp->capacity = 0;
 }
 
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -321,7 +321,6 @@ void sd_dif_config_host(struct scsi_disk
 		if (scsi_host_dif_capable(sdp->host, type) == 0) {
 			sd_printk(KERN_INFO, sdkp, "Type %d protection " \
 				  "unsupported by HBA. Disabling DIF.\n", type);
-			sdkp->protection_type = 0;
 			return;
 		}
 


