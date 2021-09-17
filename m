Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647EDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 04:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D10360F93
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 04:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhIQEtW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 00:49:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244716AbhIQEtJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 00:49:09 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18H4Udh1028324;
        Fri, 17 Sep 2021 00:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=bQTNFYrlZrl4vl9xRD83iG5z3n4cZ/UATl4yl2Y0s+Y=;
 b=KajxHcBBkaOUAzq0Ff4w1Nam+0Ea5KQSvhH/ZSW5YxJciorh4AK/j9OdWoAR2zO49/Xx
 vXOu9sNoSk0c8Q6lrHB0TurJIgNTL9mRbYgzd/eslT8jcU29SvAFZNmdt043IxvMChDG
 GYrUh8mySSFkseAvtUAFPswnngmPQwJuDdVAYFV6gkGob5swyXZx7FMNoHpmWQ4JNn5Z
 2RvvAKZd+IDEj4Bx0C04oEm1hg5xVmrJhVullFfKfQ0npsjhXMgezYjIYgv6mK6JVd35
 iK+cxa0RFc2yKKiAnehNZa85mSsI/G9f7etXo329zReaC+ycoXaSmmwU91o6Ew5vt1WV Tg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4g673txn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 00:47:45 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18H4g5vO012221;
        Fri, 17 Sep 2021 04:47:45 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 3b4m7p8246-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 04:47:45 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18H4lhl135979736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 04:47:43 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75C76AE063;
        Fri, 17 Sep 2021 04:47:43 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F335AAE05F;
        Fri, 17 Sep 2021 04:47:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.89])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 04:47:42 +0000 (GMT)
From:   wenxiong@linux.ibm.com
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com,
        Wen Xiong <wenxiong@linux.ibm.com>
Subject: [PATCH 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
Date:   Thu, 16 Sep 2021 22:20:06 -0500
Message-Id: <1631848806-10184-2-git-send-email-wenxiong@linux.ibm.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1631848806-10184-1-git-send-email-wenxiong@linux.ibm.com>
References: <1631848806-10184-1-git-send-email-wenxiong@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PiVR5bU_9n7ahfR3E2u2-yEMc4WO8YHd
X-Proofpoint-GUID: PiVR5bU_9n7ahfR3E2u2-yEMc4WO8YHd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_02,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wen Xiong <wenxiong@linux.ibm.com>

Setting scsi logging level with error=3, we saw some errors from enclosues:

[108017.360833] ses 0:0:9:0: tag#641 Done: NEEDS_RETRY Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[108017.360838] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01 00 20 00
[108017.427778] ses 0:0:9:0: Power-on or device reset occurred
[108017.427784] ses 0:0:9:0: tag#641 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[108017.427788] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01 00 20 00
[108017.427791] ses 0:0:9:0: tag#641 Sense Key : Unit Attention [current]
[108017.427793] ses 0:0:9:0: tag#641 Add. Sense: Bus device reset function occurred
[108017.427801] ses 0:0:9:0: Failed to get diagnostic page 0x1
[108017.427804] ses 0:0:9:0: Failed to bind enclosure -19
[108017.427895] ses 0:0:10:0: Attached Enclosure device
[108017.427942] ses 0:0:10:0: Attached scsi generic sg18 type 13

As Martin's suggestion, the patch checks to retry on NOT_READY as well as
UNIT_ATTENTION with ASC 0x29.

Signed-off-by: Wen Xiong <wenxiong@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.ibm.com>
Reviewed-by: James Bottomley <jejb@linux.ibm.com>
---
 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..e42775a6d3ff 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,9 +87,16 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
+	struct scsi_sense_hdr sshdr;
+	int retries = SES_RETRIES;
+
+	do {
+		ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+			&sshdr, SES_TIMEOUT, 1, NULL);
+	} while (ret > 0 && scsi_sense_valid(&sshdr) && --retries &&
+		(sshdr.sense_key == NOT_READY ||
+		(sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (unlikely(ret))
 		return ret;
 
@@ -121,9 +128,16 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
+	struct scsi_sense_hdr sshdr;
+	int retries = SES_RETRIES;
+
+	do {
+		result =  scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
+			&sshdr, SES_TIMEOUT, 1, NULL);
+	} while (result > 0 && scsi_sense_valid(&sshdr) && --retries &&
+		(sshdr.sense_key == NOT_READY ||
+		(sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.27.0

