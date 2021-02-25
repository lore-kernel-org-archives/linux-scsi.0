Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3708C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 20:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6FE860201
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 20:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbhBYUtu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 15:49:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233556AbhBYUtP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 15:49:15 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PKYt3w088882;
        Thu, 25 Feb 2021 15:48:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XNJPQ1yZpvnoSLRI/ZOLiz1GIbhHvMflJIZ/7VBGJS0=;
 b=UGtVdC8XM82Z7w0C4UX/FxS0N34w47iaDejuUUToXBETO7SmDj52sH+euY1KbfE5g4TD
 n1cDC1icOd66HuRs5wZzbTUu1UBZ/TojKeMMqVKwStMmmglHpd75NkNl2PPn12TWRDSG
 jfOng3tKh9v5vUA/Zrk5IohzYhkxkjwItOiyokKFOFjiOmIEK+PsTeE67xoC8UsdXjTL
 W8H5D8zcUTuv6YLpgztr840vIEft6UXsAPvmUPWWh/KjIOtnvseC6PEbDdLGSMU37zlC
 iG2PdXEBr6xZ5x5V7q9u8KLZry6LxDOdaNBIFymvYRR/Dp0VNOd6C/oIQa6EyRQXrgmS 0g== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xjs0rthp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 15:48:30 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PKkvuf002739;
        Thu, 25 Feb 2021 20:48:29 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 36tt29hfg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 20:48:29 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PKmS0j38011362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 20:48:28 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF6336E050;
        Thu, 25 Feb 2021 20:48:27 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2D176E04E;
        Thu, 25 Feb 2021 20:48:27 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 20:48:27 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 3/5] ibmvfc: treat H_CLOSED as success during sub-CRQ registration
Date:   Thu, 25 Feb 2021 14:48:22 -0600
Message-Id: <20210225204824.14570-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210225204824.14570-1-tyreld@linux.ibm.com>
References: <20210225204824.14570-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_11:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A non-zero return code for H_REG_SUB_CRQ is currently treated as a
failure resulting in failing sub-CRQ setup. The case of H_CLOSED should
not be treated as a failure. This return code translates to a successful
sub-CRQ registration by the hypervisor, and is meant to communicate back
that there is currently no partner VIOS CRQ connection established as of
yet. This is a common occurrence during a disconnect where the client
adapter can possibly come back up prior to the partner adapter.

For non-zero return code from H_REG_SUB_CRQ treat a H_CLOSED as success
so that sub-CRQs are successfully setup.

Fixes: faacf8c5f1d5 ("ibmvfc: add alloc/dealloc routines for SCSI Sub-CRQ Channels")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 3dd20f383453..ba6fcf9cbc57 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5636,7 +5636,8 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 	rc = h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
 			   &scrq->cookie, &scrq->hw_irq);
 
-	if (rc) {
+	/* H_CLOSED indicates successful register, but no CRQ partner */
+	if (rc && rc != H_CLOSED) {
 		dev_warn(dev, "Error registering sub-crq: %d\n", rc);
 		if (rc == H_PARAMETER)
 			dev_warn_once(dev, "Firmware may not support MQ\n");
-- 
2.27.0

