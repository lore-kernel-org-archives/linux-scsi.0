Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C44FE7D0B4
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjIUWzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjIUWyw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94907123
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:45 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMd0UC002911;
        Thu, 21 Sep 2023 22:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LrlW+Ts3B5EKcpkWgZSqInwiSmlmaMbJ5kPpiOkfGjk=;
 b=VhpINfs7TXbDAa4VQ9gKTnSbR8NuDLkpyy4BmFbskWIFT8ExspJ5t3S3Mai63hVIWkLX
 Z0dk4a7232ItU907qajusuAcJRR0gqCiLOvm+NnO68yZQ+0L0wsTD+HAneOPkh2h1SKU
 JxrJxePDev43dGFFalgAcPpCLCeqLAuN9DR1CcXPz8IN90ov6v+hMvTLAwXC8cLoaEU+
 G7dcJp113HNZtrC0iXMOn26t2Ka/QlQRL380S9F6FhI1HDe27X/IGwJk0jNj0psYLs05
 PSCDueo9u2L7bXUfa7DqDnQjo8mJvqO7/NoNEDE5pmGGaT2/y0xkakr1//vb2fUXLKtW Gg== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8vx9jjfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:41 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLwQBG025939;
        Thu, 21 Sep 2023 22:54:41 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t8tspm6vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:41 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMseJU34472702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:40 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 707DC5805A;
        Thu, 21 Sep 2023 22:54:40 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33D605805C;
        Thu, 21 Sep 2023 22:54:40 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:40 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 11/11] ibmvfc: add protocol field to target structure
Date:   Thu, 21 Sep 2023 17:54:35 -0500
Message-Id: <20230921225435.3537728-12-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c_GxAmQlbxOWkmos9KexlVlNjtEIx08P
X-Proofpoint-GUID: c_GxAmQlbxOWkmos9KexlVlNjtEIx08P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=867 impostorscore=0
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309210196
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

