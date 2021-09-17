Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2DBC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 04:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFC260FBF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 04:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbhIQExZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 00:53:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232183AbhIQExX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 00:53:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18H2NtEo010537;
        Fri, 17 Sep 2021 00:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=bQTNFYrlZrl4vl9xRD83iG5z3n4cZ/UATl4yl2Y0s+Y=;
 b=NWDeBquR+7H680AEL7PjGOo4JQE71N44nzwPSF4P58WO/aJpYGmv20Tn3+pmkZ/7/dlS
 r2SK/h5OresuZRB5JBsNgS7k8tnOwlXoc5KKgw5Vb68tXsa5/IfVp0G2GBxxGD7D6jXU
 9NkaQXyhr6VqmBNkAhfF9nBGpQGlqP3Bd+Nzv//D4/vQCXtgakC7cGM/VkJRH4rytEBF
 1A5eE+ssYeh79edwdRFFcaKKvSZnC6N18YJOP9KJgVYIQZBhlYtuhJFPh0j0NWsgcVSF
 Il6MwHGnxO5G9t5hu9fWrZbbatKp9bM024dsjLnMsLg8ZlSPFsWxd+2mWGCHdlZRkKD2 QA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4g6embp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 00:52:00 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18H4l74E012574;
        Fri, 17 Sep 2021 04:51:59 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3b0m3d24kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 04:51:59 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18H4pvUF17105400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 04:51:57 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D1F46E05B;
        Fri, 17 Sep 2021 04:51:57 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 229FE6E04E;
        Fri, 17 Sep 2021 04:51:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.89])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 04:51:57 +0000 (GMT)
From:   wenxiong@linux.ibm.com
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com,
        Wen Xiong <wenxiong@linux.ibm.com>
Subject: [PATCH RESEND V4 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
Date:   Thu, 16 Sep 2021 22:24:21 -0500
Message-Id: <1631849061-10210-2-git-send-email-wenxiong@linux.ibm.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1631849061-10210-1-git-send-email-wenxiong@linux.ibm.com>
References: <1631849061-10210-1-git-send-email-wenxiong@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b3aFVx7OChEbzTji-NvSb9WEf9P4HvU4
X-Proofpoint-ORIG-GUID: b3aFVx7OChEbzTji-NvSb9WEf9P4HvU4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_02,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109170028
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

