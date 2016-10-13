From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v2 2/2] scsi: sr: Drop custom handling of unit attention
Date: Thu, 13 Oct 2016 15:47:57 -0300
Message-ID: <1476384477-3060-2-git-send-email-krisman@linux.vnet.ibm.com>
References: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43609 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754948AbcJMSsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 14:48:17 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DIicUU076986
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 14:48:08 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0b-001b2d01.pphosted.com with ESMTP id 262bd47yp2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 14:48:08 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Thu, 13 Oct 2016 15:48:06 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id D83FC352005C
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 14:47:37 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9DIm3qk4919330
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:48:03 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9DIm3S6031832
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:48:03 -0300
In-Reply-To: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

These custom handling are no longer necessary, since we always retry UA
in scsi_execute now.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c | 21 ++++++---------------
 drivers/scsi/sr_ioctl.c |  6 ++----
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c6623abf120..e9324a224b11 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2317,7 +2317,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
 
 	memset(data, 0, sizeof(*data));
@@ -2396,11 +2396,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			data->block_descriptor_length = buffer[3];
 		}
 		data->header_length = header_length;
-	} else if ((status_byte(result) == CHECK_CONDITION) &&
-		   scsi_sense_valid(sshdr) &&
-		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
-		retry_count--;
-		goto retry;
 	}
 
 	return result;
@@ -2434,15 +2429,11 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	else
 		sshdr = sshdr_external;
 
-	/* try to eat the UNIT_ATTENTION if there are enough retries */
-	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, retries, NULL);
-		if (sdev->removable && scsi_sense_valid(sshdr) &&
-		    sshdr->sense_key == UNIT_ATTENTION)
-			sdev->changed = 1;
-	} while (scsi_sense_valid(sshdr) &&
-		 sshdr->sense_key == UNIT_ATTENTION && --retries);
+	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
+				  timeout, retries, NULL);
+	if (sdev->removable && scsi_sense_valid(sshdr) &&
+	    sshdr->sense_key == UNIT_ATTENTION)
+		sdev->changed = 1;
 
 	if (!sshdr_external)
 		kfree(sshdr);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 03054c0e7689..93b5544a5966 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -179,8 +179,8 @@ static int sr_play_trkind(struct cdrom_device_info *cdi,
 }
 
 /* We do our own retries because we want to know what the specific
-   error code is.  Normally the UNIT_ATTENTION code will automatically
-   clear after one error */
+   error code is.
+*/
 
 int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 {
@@ -220,8 +220,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 			if (!cgc->quiet)
 				sr_printk(KERN_INFO, cd,
 					  "disc change detected.\n");
-			if (retries++ < 10)
-				goto retry;
 			err = -ENOMEDIUM;
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
-- 
2.7.4

