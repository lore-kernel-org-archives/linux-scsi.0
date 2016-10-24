From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v3 2/2] scsi: sr: Drop custom handling of unit attention
Date: Mon, 24 Oct 2016 01:20:16 -0200
Message-ID: <1477279216-11256-2-git-send-email-krisman@linux.vnet.ibm.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59521 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756948AbcJXDUd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Oct 2016 23:20:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9O3IgdZ056425
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2016 23:20:33 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2694e02fd7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2016 23:20:32 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Mon, 24 Oct 2016 01:20:30 -0200
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id 8D353352005F
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2016 23:20:00 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9O3KRFC15204828
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 01:20:27 -0200
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9O3KQJg003683
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 01:20:27 -0200
In-Reply-To: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, gabriel@krisman.be, brking@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

These custom handling are no longer necessary, since we always retry UA
in scsi_execute now.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c | 21 ++++++---------------
 drivers/scsi/sr_ioctl.c |  6 ++----
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4f6a91d6ee34..9e62290e6136 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2320,7 +2320,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
 
 	memset(data, 0, sizeof(*data));
@@ -2399,11 +2399,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
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
@@ -2437,15 +2432,11 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
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

