Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BCBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 14:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA5106044F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 14:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbhIOOdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 10:33:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233771AbhIOOdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 10:33:04 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18FCBpHw005206;
        Wed, 15 Sep 2021 10:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=dPMvXhNP7Y9V/h7wZPa1moch9wM34k/wgiU9g6kfkbs=;
 b=Dr4+RiJS0eBH7IQct2EWuzkr+/mzHtZrD908pC3MXdoN0KzZBFOlb1jtnD54m5Zygkjq
 wxFnDghkHyKVNGl/PVc6yF9Ha/mpeUtGiUMoJDLmqiO9H1vG3a7chQP6ZPA5jlsVFmYz
 NWh5Vzlk47o42yFRDY9Y/Ha3qUZxAawsejreaYRUHnq3gqzBrJc4dLRVeTazj1Dy8NxH
 tsAwEqejWr8MQFB4lCnE5SgDxrPbWhpHOzeOtoVjMvsK5nJeDsne+2mAHrLVrhAT9hlv
 Y7DBoobf808rQp4VWWopt3C/7/bj66OeKSLCgdNv3bkfv52OLRfxr5meMgSIoIl8g1ao rg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b3c11tpbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 10:31:43 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18FENbBH011711;
        Wed, 15 Sep 2021 14:31:42 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3b0m3bkgh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 14:31:42 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18FEVfnP36897232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 14:31:41 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 204717805E;
        Wed, 15 Sep 2021 14:31:41 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5DE478070;
        Wed, 15 Sep 2021 14:31:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.89])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 14:31:40 +0000 (GMT)
From:   wenxiong@linux.vnet.ibm.com
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>
Subject: [PATCH V3 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
Date:   Wed, 15 Sep 2021 08:04:08 -0500
Message-Id: <1631711048-6177-1-git-send-email-wenxiong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jHWXZCq2NFlXRrstnl3JBDJVPbUBnKcj
X-Proofpoint-ORIG-GUID: jHWXZCq2NFlXRrstnl3JBDJVPbUBnKcj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109150040
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

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

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..7b6efe4ccc13 100644
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
+	} while (scsi_sense_valid(&sshdr) && --retries &&
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
+		result =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+			&sshdr, SES_TIMEOUT, 1, NULL);
+	} while (scsi_sense_valid(&sshdr) && --retries &&
+		(sshdr.sense_key == NOT_READY ||
+		(sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.27.0

