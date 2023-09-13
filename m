Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83CAEE0212
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 23:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbjIMXax (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 19:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjIMXax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 19:30:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37975E3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 16:30:49 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DN7oo4021656;
        Wed, 13 Sep 2023 23:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7HWDHfLMQE3ZcmXSSmhyOewGnNiIl3xnUvPxAWH9MmQ=;
 b=ayy2ELr8YC2Ky+e68hxQruP1V+QmtiA1rwgPE8uYybXBLHZL6b0sbF7nVg+/TVIliRwB
 aDdA9XXMqLVGg48RxDlkJWCllMHPKCB6evuK4dmpwz8hsvbqaI5ITsx3xQveTZfYbVFm
 bY8onJzlzVJBVWIDX3Z7z4CNL7YyS6/5t57VWJQqx+O6VJYCiJJvH7q2++EjTZpwcgKc
 1pBekzZ453rFXMJ96Bd04RDItQo6mls9rpWsAs8xZJgk3TtqrnBdsaw0uwo5gugCsT8p
 FD+3C7nG9iR+i6OgnJtzGhaRWIceDkXeB+5GdHSeZeXcHnC8oYQwOmmxBHx7SoR13iRW 0Q== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3nu51fp4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:30:47 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DKMjNh023142;
        Wed, 13 Sep 2023 23:05:02 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t141nxm0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:02 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN512457475350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:01 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 513A658053;
        Wed, 13 Sep 2023 23:05:01 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0AB58043;
        Wed, 13 Sep 2023 23:05:00 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:05:00 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 03/11] ibmvfc: limit max hw queues by num_online_cpus()
Date:   Wed, 13 Sep 2023 18:04:49 -0500
Message-Id: <20230913230457.2575849-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: g90pDCT4tCDM1R0UMKXlFGycVVsfhiql
X-Proofpoint-GUID: g90pDCT4tCDM1R0UMKXlFGycVVsfhiql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_17,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0 mlxlogscore=846
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309130191
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
index 9cd11cab4f3e..f35fed60fdae 100644
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

