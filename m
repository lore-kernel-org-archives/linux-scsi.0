Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74CDC433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B04FE22D57
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405539AbhALAZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403932AbhAKXOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 18:14:41 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BN9FR9028234;
        Mon, 11 Jan 2021 18:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zItf6+mbSfLvIL9pxQZIi/E7XRG+Y4KsHH2EKTlW9iM=;
 b=AJDI7Ph1hI7r2Sl2nOeovWhDSA1hT0AgMFpUzNFAkj8PglGsdAQKa8N1yRsD0uS9CRK2
 AAODp/jRVuf5bXFHUKtAMou4mbBQUxwsgp0YgbVfRYuClt3fxsfO0xPzte06Dc1+X9Ya
 flHatr+aOVs6V7++/pF9W2W3q4wqHGVfmMKrj1mD3JjPoT4PNRVFNqs/acacabtWIoSn
 12qmi01l6ZwzvqLSz7M84o25cDDQKEZHyuWlvh2wPa7UYOYfNNHRR00p/aXnqu1uppF3
 rjiJY7d7BuXIfVyTty+ch9kn5KDfzQIg3HeXmGWBh2QXE/7kSdt4V2r8Zpp6Mrbv6wOX 3Q== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360yc7ry3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 18:12:36 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BN7S5I010344;
        Mon, 11 Jan 2021 23:12:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 35y448sys5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 23:12:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BNCVFD27656670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 23:12:31 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B38D478063;
        Mon, 11 Jan 2021 23:12:31 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4840F7805C;
        Mon, 11 Jan 2021 23:12:31 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 23:12:31 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v4 08/21] ibmvfc: add Sub-CRQ IRQ enable/disable routine
Date:   Mon, 11 Jan 2021 17:12:12 -0600
Message-Id: <20210111231225.105347-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111231225.105347-1-tyreld@linux.ibm.com>
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 mlxlogscore=838 mlxscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Each Sub-CRQ has its own interrupt. A hypercall is required to toggle
the IRQ state. Provide the necessary mechanism via a helper function.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a198e118887d..5d7ada0ed0d6 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3465,6 +3465,26 @@ static void ibmvfc_tasklet(void *data)
 	}
 }
 
+static int ibmvfc_toggle_scrq_irq(struct ibmvfc_queue *scrq, int enable)
+{
+	struct device *dev = scrq->vhost->dev;
+	struct vio_dev *vdev = to_vio_dev(dev);
+	unsigned long rc;
+	int irq_action = H_ENABLE_VIO_INTERRUPT;
+
+	if (!enable)
+		irq_action = H_DISABLE_VIO_INTERRUPT;
+
+	rc = plpar_hcall_norets(H_VIOCTL, vdev->unit_address, irq_action,
+				scrq->hw_irq, 0, 0);
+
+	if (rc)
+		dev_err(dev, "Couldn't %s sub-crq[%lu] irq. rc=%ld\n",
+			enable ? "enable" : "disable", scrq->hwq_id, rc);
+
+	return rc;
+}
+
 /**
  * ibmvfc_init_tgt - Set the next init job step for the target
  * @tgt:		ibmvfc target struct
-- 
2.27.0

