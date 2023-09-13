Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672DCEE0213
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 00:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjINABI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjINABH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 20:01:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4531E6B
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 17:01:03 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNcVYu021313;
        Thu, 14 Sep 2023 00:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MHitxDHdHxRHb2NtEOdi0JivkDBDnArbdVXfZV209uc=;
 b=YH/v9Bm0FIhBeIl+Lz+HwzDBgNxrUCdKkFtaf4y1ALGloLza5mRoORhylZCJCtg0C/o9
 V5Xu/UjVwfnfYGz6NLTxpTXvNdj7GQEZRLInW08f9zs9rIhEspj0uXWpRnJSFbQAnYGV
 Rztn02qhva8GRlMO7DRD2AmLi+iMKKwx0it/EdOt0nnS/oQjkIEi4hmuoB8Y/p5nZCmv
 rwn4f/XYGLr9t1JIt45q73HAmOJWxaqMqpumyhZd0RkaMHD+nQpFSSObfjlz3ryVUTei
 zwpf+yVyeEfFXyBKLppiqKU5FX4YulV6MnFGAejURZZZYCR4vz4+5+3U1mVvvAMqCJR/ 4g== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3ps08jgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Sep 2023 00:00:54 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DL9Cpl002775;
        Wed, 13 Sep 2023 23:05:04 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t14hm6etp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:04 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN53f364225732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:03 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E80175805F;
        Wed, 13 Sep 2023 23:05:02 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1057B58053;
        Wed, 13 Sep 2023 23:05:02 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:05:01 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 05/11] ibmvfc: use a bitfield for boolean flags
Date:   Wed, 13 Sep 2023 18:04:51 -0500
Message-Id: <20230913230457.2575849-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NfXrMlv7Ptxy6AN6jjhAE1IEU9E_QpXH
X-Proofpoint-ORIG-GUID: NfXrMlv7Ptxy6AN6jjhAE1IEU9E_QpXH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_18,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=928 bulkscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 spamscore=0 phishscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130195
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are currently 9 binary flag fields in the ibmvfc host
structure. Converting each of these to a single bitfield reduces the
foot print of the structure by 32 bytes.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 0e641a880e1c..8ae52c239009 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -877,21 +877,21 @@ struct ibmvfc_host {
 	struct ibmvfc_discover_targets_entry *disc_buf;
 	struct mutex passthru_mutex;
 	int max_vios_scsi_channels;
+	int client_scsi_channels;
 	int task_set;
 	int init_retries;
 	int discovery_threads;
 	int abort_threads;
-	int client_migrated;
-	int reinit;
-	int delay_init;
-	int scan_complete;
+	int client_migrated:1;
+	int reinit:1;
+	int delay_init:1;
+	int logged_in:1;
+	int mq_enabled:1;
+	int using_channels:1;
+	int do_enquiry:1;
+	int aborting_passthru:1;
+	int scan_complete:1;
 	int scan_timeout;
-	int logged_in;
-	int mq_enabled;
-	int using_channels;
-	int do_enquiry;
-	int client_scsi_channels;
-	int aborting_passthru;
 	int events_to_log;
 #define IBMVFC_AE_LINKUP	0x0001
 #define IBMVFC_AE_LINKDOWN	0x0002
-- 
2.31.1

