Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11182C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 21:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD73E64EBA
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 21:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhBYVvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 16:51:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232113AbhBYVvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 16:51:49 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PLXB0j141622;
        Thu, 25 Feb 2021 16:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZkvXIMVJGjwuiCfuG5uF4ldFvhede59Cis5SwsdGaNw=;
 b=OnSVjkeZb7QW3aHwsfoXC1WORmXO71yA58pQVR5Oe+Kv59vREfwx3i/N7u5TRvVkMHjf
 pxwap7Cc8xXGzx19jlAJxN32cw1WRj5MKK+76VvjY0CmGxRUPgKizYN8Us7LTHH44D3N
 phwqUc74MISEAao4hhlarfgBZAoUmaicPi3b36nHElJDRnqZBF6iIa5rO5tguFnXfJMY
 BlVCyegqMcxmU0yPb8fbG56giLMF9DrTd0LmQCCqyHlVwo3OaeUqQ0ljT6+d4spjkpRR
 zZ+p/86M/eHVuCDNC1uCL/mI4MKnFCQQfAeEuVEkVpJbi9VUpn/ijw455oVHl3MLi74R tw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xfcxh636-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 16:51:03 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PLmVUY018692;
        Thu, 25 Feb 2021 21:51:01 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 36tt29hvwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 21:51:01 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PLp0Oe31981876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 21:51:00 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4179F6E04C;
        Thu, 25 Feb 2021 21:51:00 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED6256E053;
        Thu, 25 Feb 2021 21:50:59 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 21:50:59 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v4 4/5] ibmvfc: store return code of H_FREE_SUB_CRQ during cleanup
Date:   Thu, 25 Feb 2021 15:50:56 -0600
Message-Id: <20210225215057.23020-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210225215057.23020-1-tyreld@linux.ibm.com>
References: <20210225215057.23020-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_14:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250163
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The H_FREE_SUB_CRQ hypercall can return a retry delay return code that
indicates the call needs to be retried after a specific amount of time
delay. The error path to free a sub-CRQ in case of a failure during
channel registration fails to capture the return code of H_FREE_SUB_CRQ
which will result in the delay loop being skipped in the case of a retry
delay return code.

Store the return code result of the H_FREE_SUB_CRQ call such that the
return code check in the delay loop evaluates a meaningful value. Also,
use the rtas_busy_delay() to check the rc value and delay for the
appropriate amount of time.

Fixes: 9288d35d70b5 ("ibmvfc: map/request irq and register Sub-CRQ interrupt handler")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1d9f961715ca..ef03fa559433 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -21,6 +21,7 @@
 #include <linux/bsg-lib.h>
 #include <asm/firmware.h>
 #include <asm/irq.h>
+#include <asm/rtas.h>
 #include <asm/vio.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -5670,8 +5671,8 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (rtas_busy_delay(rc));
 reg_failed:
 	ibmvfc_free_queue(vhost, scrq);
 	LEAVE;
-- 
2.27.0

