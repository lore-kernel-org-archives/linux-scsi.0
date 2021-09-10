Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169F2C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 20:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7D4611F2
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 20:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhIJUeB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 16:34:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233498AbhIJUeA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 16:34:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18AK3Mdb075169;
        Fri, 10 Sep 2021 16:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=kgYgJ5H7x2x8QshTAh5JGbumInIQ72ahQ7HW6gjIb/0=;
 b=Zlnf/f1RIOZqhlczNB7busbZieh9ydY3r6U2dFanoHWvaGRV/wDWjZe9jQyI1SzAn8Al
 hDj7iFmZPC4ohTCXFay3VWA6Yll+olNTuBtfGrN80b31E1ZynamWjliY5u0Y0/lcdkw3
 ads23tZufRhmzMbD5oIQErp2oruUs7HF+pkbQD9Bli1xBFn3X5oO42KbFG6UotH3ep1P
 8cEpidtsO+4MP5LzF1Ocl+DdAj8ICszYxDHeuq9KXQD7GqJ76MWk2heIp4H4fWE0NErE
 x4d5ivfB3lOpQxaYGphGvCxRRKxAO6wGTwT/5a45HpSE1wS7oTlQMJTNPDqfa+rahyei hw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b05nq3hxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 16:32:47 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18AKCWSa018573;
        Fri, 10 Sep 2021 20:32:46 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3axcnm7ygn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 20:32:46 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18AKVTlL32113144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 20:31:29 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33130AE06D;
        Fri, 10 Sep 2021 20:31:29 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0FB0AE076;
        Fri, 10 Sep 2021 20:31:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.89])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 10 Sep 2021 20:31:28 +0000 (GMT)
From:   wenxiong@linux.vnet.ibm.com
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com,
        Wen Xiong <root@ltczz405-lp2.aus.stglabs.ibm.com>,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>
Subject: [PATCH V2 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
Date:   Fri, 10 Sep 2021 14:04:05 -0500
Message-Id: <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yS7vhzezIG2szJ3tUT-rJz3cYJB5tZ0T
X-Proofpoint-GUID: yS7vhzezIG2szJ3tUT-rJz3cYJB5tZ0T
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-10_07:2021-09-09,2021-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 clxscore=1011 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109100113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wen Xiong <root@ltczz405-lp2.aus.stglabs.ibm.com>

We saw two errors with Slider drawer:
- Failed to get diagnostic page 0x1 during booting up
- /sys/class/enclosure is empty with ipr adapter + Slider drawer

From scsi logging level with error=3, looks ses_recv_diag not try on a UA.
The patch addes retrying on a UA in ses_recv_diag();

Signed-Off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ses.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..93f6a8ce1bea 100644
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
+		ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
+			bufflen, &sshdr, NULL, SES_TIMEOUT, SES_RETRIES, NULL);
+
+	} while (scsi_sense_valid(&sshdr) &&
+                 sshdr.sense_key == UNIT_ATTENTION && --retries);
 
-	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (unlikely(ret))
 		return ret;
 
-- 
2.27.0

