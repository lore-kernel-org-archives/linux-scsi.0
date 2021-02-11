Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA42C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74EE464DE3
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhBKTBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 14:01:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231341AbhBKS6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 13:58:33 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BIXS2p012550;
        Thu, 11 Feb 2021 13:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FoOed3gbJNkCHcMmZvPwVEtCy29QqfwRk6OBDnuXjIk=;
 b=UveRk1uaYDJN8KWHs5sKAUhCL/lH60v7MWh+lwILFjxNAfjVCVS1Gsb/vQT5A73DNt0U
 sl1XozTaqnC8vm1z4Jv+Oj0fmwG4sElx7WsIrTAmOGsn0C3VnbCWsVlQeIALUo8Noexr
 37A5ZqOJOubbKEgDMA/kISDXarUGH12y9lWk/DF3syH+umgvymcidaNfJgdtO9bvWFQM
 cpwh44bvxZQGJvKetS2voss01H5cbPetTQsrrFpEszPUE0aIljeB072L4cQA0/XJzrvS
 hfwTVtVrbHtR4DRmkTWBKPEDBcPrDAfmgZ5l68Y6mUogyADaRKOubTkSfWNYf5aaDs0C Iw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n9vq13ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 13:57:49 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BIvW1C020828;
        Thu, 11 Feb 2021 18:57:48 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 36hjra1pxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 18:57:48 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BIvkYn28508508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 18:57:46 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98DDC136053;
        Thu, 11 Feb 2021 18:57:46 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42FB813604F;
        Thu, 11 Feb 2021 18:57:46 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 18:57:46 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 4/4] ibmvfc: store return code of H_FREE_SUB_CRQ during cleanup
Date:   Thu, 11 Feb 2021 12:57:42 -0600
Message-Id: <20210211185742.50143-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210211185742.50143-1-tyreld@linux.ibm.com>
References: <20210211185742.50143-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110148
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
return code check in the delay loop evaluates a meaningful value.

Fixes: 9288d35d70b5 ("ibmvfc: map/request irq and register Sub-CRQ interrupt handler")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ba6fcf9cbc57..23b803ac4a13 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5670,7 +5670,7 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 reg_failed:
 	ibmvfc_free_queue(vhost, scrq);
-- 
2.27.0

