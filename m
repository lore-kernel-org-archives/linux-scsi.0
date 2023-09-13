Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38548EE0211
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 23:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjIMXdJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 19:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjIMXdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 19:33:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1295183
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 16:33:04 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DN85V9030406;
        Wed, 13 Sep 2023 23:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LrlW+Ts3B5EKcpkWgZSqInwiSmlmaMbJ5kPpiOkfGjk=;
 b=T7tFAFlLvjnL9A+2hMsioGSG9fs4REfXqVDU+V2M3PTMjGefdW5O3t6gboxfCINQ7tIv
 nRkDhE00MA2mUepFiwYkD9BaPtoqSFHWkmeyB3TitSKaew9apuU3h5aRHblzB8rm6TVA
 5GnTphRiofYOrrDbHETFKsA+ftPkRKn9IjQdSeJA8GyeORE5N2YDc/HnGbnpieAPthqY
 Lnvyjyc/UytZjHSc2je25ZXEjuREBdGC33SX1rek2tP7SFBadfIWCstHSbMRgRMzKBlS
 rhIZerYuYjEaoSzq2cwOQPj1fXsxABxw9eFHYypGBOHur5OZSiwyGO33WJhc2XXqPUGL Ig== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3kpfn4q2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:33:00 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DLvoVw024103;
        Wed, 13 Sep 2023 23:05:07 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t131tey53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:07 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN566p10945174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:06 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68A295805F;
        Wed, 13 Sep 2023 23:05:06 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFED958059;
        Wed, 13 Sep 2023 23:05:05 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:05:05 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 11/11] ibmvfc: add protocol field to target structure
Date:   Wed, 13 Sep 2023 18:04:57 -0500
Message-Id: <20230913230457.2575849-12-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R8Dfzxiu2t0ypDIvLLHMjJT_NgsIsmJo
X-Proofpoint-ORIG-GUID: R8Dfzxiu2t0ypDIvLLHMjJT_NgsIsmJo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_17,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 mlxlogscore=873 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130191
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a per target protocol field so target code can determine correct
protocol specific actions as well as identify the correct channel group
target list.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index ab3a7070171b..331ecf8254be 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -716,9 +716,15 @@ enum ibmvfc_target_action {
 	IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT,
 };
 
+enum ibmvfc_protocol {
+	IBMVFC_PROTO_SCSI = 0,
+	IBMVFC_PROTO_NVME = 1,
+};
+
 struct ibmvfc_target {
 	struct list_head queue;
 	struct ibmvfc_host *vhost;
+	enum ibmvfc_protocol protocol;
 	u64 scsi_id;
 	u64 wwpn;
 	u64 new_scsi_id;
@@ -816,11 +822,6 @@ struct ibmvfc_queue {
 	irq_handler_t handler;
 };
 
-enum ibmvfc_protocol {
-	IBMVFC_PROTO_SCSI = 0,
-	IBMVFC_PROTO_NVME = 1,
-};
-
 struct ibmvfc_channels {
 	struct ibmvfc_queue *scrqs;
 	enum ibmvfc_protocol protocol;
-- 
2.31.1

