From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ses: Retry UNIT ATTENTION for receive diagnostics
Date: Fri, 26 Aug 2016 06:09:01 -0500
Message-ID: <20160826110902.6BF696E038@b03ledav001.gho.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45691 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752872AbcHZLJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 07:09:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7QB8jRn079388
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 07:09:07 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25231t25gh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 07:09:07 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Fri, 26 Aug 2016 05:09:06 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org, wenxiong@linux.vnet.ibm.com


If the ses driver receives a UNIT ATTENTION when issuing
a receive diagnostics while probing a SES device, it
fails to attach with messages such as:

scsi 1:0:7:0: Failed to get diagnostic page 0x8000002
scsi 1:0:7:0: Failed to bind enclosure -19

Fix this by eating unit attentions for these commands.

Cc: <stable@vger.kernel.org>
Suggested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ses.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ses.c~ses_rcv_diag_retry drivers/scsi/ses.c
--- linux-2.6.git/drivers/scsi/ses.c~ses_rcv_diag_retry	2016-08-25 18:28:18.720565322 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ses.c	2016-08-25 18:28:29.687496342 -0500
@@ -86,7 +86,7 @@ static void init_device_slot_control(uns
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
-	int ret;
+	int ret, retries = SES_RETRIES;
 	unsigned char cmd[] = {
 		RECEIVE_DIAGNOSTIC,
 		1,		/* Set PCV bit */
@@ -96,11 +96,14 @@ static int ses_recv_diag(struct scsi_dev
 		0
 	};
 	unsigned char recv_page_code;
+	struct scsi_sense_hdr sshdr;
 
-	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
-	if (unlikely(!ret))
-		return ret;
+	do {
+		memset(&sshdr, 0, sizeof(sshdr));
+		ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+					&sshdr, SES_TIMEOUT, retries, NULL);
+	} while (scsi_sense_valid(&sshdr) &&
+		 sshdr.sense_key == UNIT_ATTENTION && --retries);
 
 	recv_page_code = ((unsigned char *)buf)[0];
 
_

