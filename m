Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F626C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 20:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 340D364E24
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 20:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhBYUwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 15:52:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234055AbhBYUt6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 15:49:58 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PKYvO8163004;
        Thu, 25 Feb 2021 15:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J0uWTrHIk6oNTIWtgvGVHPADCf5iJCgm2AKv0bC8II0=;
 b=V266Lxg6SBijbWxiM6j1k7DW3FsdkzqwLh6nvq1+JX1zdQSJDK/7nl0xbbLSHGQa/nlb
 wllVfHEC+6nCZBZbFiMflOhQ4uirdIZ8jJFYXeIXTTGhW1943gdFdj2wRFIt4Ux+/9ye
 vxy8pdpU1oZMhrxShj7FNQZ1CHAyDPrb1M/SusFCYWH1J4HKJ1+3RGtHs8CqDApVKolL
 8xgn1N4r/3AljjeohPNhBW3vbGHA9EAD35lMnh+rjkammZxbSOZDJxBbDQ/5AoNU0xw5
 h5VoBdL5gVyhlZgCw3dizjQvTj2hxujgXu9GrDmHWXRYpw5JOOlGwwKPmTQxLHGSKh8r vQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36xgksvmm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 15:49:12 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PKnARX023403;
        Thu, 25 Feb 2021 20:49:12 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 36tt2b3tqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 20:49:12 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PKmSfM37224930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 20:48:28 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56AFF6E050;
        Thu, 25 Feb 2021 20:48:28 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09BD76E054;
        Thu, 25 Feb 2021 20:48:28 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 20:48:27 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 4/5] ibmvfc: store return code of H_FREE_SUB_CRQ during cleanup
Date:   Thu, 25 Feb 2021 14:48:23 -0600
Message-Id: <20210225204824.14570-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210225204824.14570-1-tyreld@linux.ibm.com>
References: <20210225204824.14570-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_11:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250158
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
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ba6fcf9cbc57..4ac2c442e1e2 100644
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

