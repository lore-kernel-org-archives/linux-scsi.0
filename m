Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD94E7D0B4
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjIUWyy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjIUWyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E5C11A
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:43 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMnOeZ008571;
        Thu, 21 Sep 2023 22:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5rCW3F+4pP8C1o3BK7NCezsjnuNif09ZOf5kx9CEJpI=;
 b=WrgC4f4OxTRePAhChEawZuk7qW7dNfz0oxzTVXEstWpoBBN6I6hJUJoGp+rtgMYrqnxf
 zBKZmEUVm/9BLAl/EsFv3ppB5MQxTheS14lpHSaXoeOQtvfQAeagM3aKOgDhur59TNiF
 zECchYToMYZPmvxK59Sx5R5kOeSK7WF5sC8tQGDCQ3hV6jY2B2SmPDz2mz3Wee/6cs89
 o6pfp3I7OL8QhQrfA3ZJH4zoUmeQy3qyY2YDyug+FBXgmu0KMclFqDCNa5z4iLuv0P9Y
 FWz/TFssnCsYW4wvF51kFTe+MpsvkuZX6HNPvSJKeIp3b2Fb6MaIOHLHAb44mTs7uOvT UQ== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8wb4texy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:39 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLthpT022924;
        Thu, 21 Sep 2023 22:54:38 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t8tspv74a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:38 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMscaS9110148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:38 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A78158051;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F06A25805A;
        Thu, 21 Sep 2023 22:54:37 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:37 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 03/11] ibmvfc: limit max hw queues by num_online_cpus()
Date:   Thu, 21 Sep 2023 17:54:27 -0500
Message-Id: <20230921225435.3537728-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yHJBa4I91RkXJZGBYU_hVPiuRKVr6sMb
X-Proofpoint-ORIG-GUID: yHJBa4I91RkXJZGBYU_hVPiuRKVr6sMb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=846 clxscore=1015
 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 adultscore=0 mlxscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309210196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A LPAR could potentially be configured with a small logical cpu count
that is less then the default hardware queue max. Ensure that we don't
allocate more hw queues than available cpus.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6d66a416c44e..2bfeeb9ace01 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -6261,7 +6261,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct Scsi_Host *shost;
 	struct device *dev = &vdev->dev;
 	int rc = -ENOMEM;
-	unsigned int max_scsi_queues = IBMVFC_MAX_SCSI_QUEUES;
+	unsigned int online_cpus = num_online_cpus();
+	unsigned int max_scsi_queues = min((unsigned int)IBMVFC_MAX_SCSI_QUEUES, online_cpus);
 
 	ENTER;
 	shost = scsi_host_alloc(&driver_template, sizeof(*vhost));
-- 
2.31.1

