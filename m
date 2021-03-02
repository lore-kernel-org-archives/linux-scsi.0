Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3755FC28E86
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1293F64EE6
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhCCMq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:46:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29906 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1840160AbhCBXHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 18:07:52 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122N3ShX085219;
        Tue, 2 Mar 2021 18:07:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mh59kqzS3Vta0WgtVShW7Y2yOas9L+oy4a7h3f2fbPk=;
 b=tQZKdrq51BDN9mZQ96+PE/+LfmXaua2l78xv+25ftd1LtSiIsPWA/U+M5tcERiAJHIAN
 j+Xn76QrDlvjJS0b2PFOXy1ap1yLyZynOMAyBIkG0JyjCQ5wV3aP4L2gH/LkoE/WpJnj
 ku4I/IOtEQ96CpCrilmO0TBEXjGEGq7tgkP4T/zPnOQwFRpHoQP/OqGuOu7kQtSSdzee
 jJuDKWcF2esirY1i5mrhN/Y0MTordYoXD3CuL3iNVR333NwKXcNiZ5aBdEjmmph+rBFY
 /Ncm0IVJEVBK4CwUdQqS3rFdxXlxwqcuSuhhxWzSBWP7AVF0WpDs/1MGLYSr+/aoTBwF +Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371xmwrg4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 18:07:04 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122N2YNh011270;
        Tue, 2 Mar 2021 23:05:48 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3710sqpaxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 23:05:48 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122N5kYI16384470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 23:05:47 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3E8B6E04E;
        Tue,  2 Mar 2021 23:05:46 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 758C96E056;
        Tue,  2 Mar 2021 23:05:46 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 23:05:46 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v5 4/5] ibmvfc: store return code of H_FREE_SUB_CRQ during cleanup
Date:   Tue,  2 Mar 2021 17:05:42 -0600
Message-Id: <20210302230543.9905-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302230543.9905-1-tyreld@linux.ibm.com>
References: <20210302230543.9905-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 adultscore=0 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020170
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

Fixes: 39e461fddff0 ("ibmvfc: map/request irq and register Sub-CRQ interrupt handler")
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

