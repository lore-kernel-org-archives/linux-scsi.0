Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12A2E7D0B4
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjIUWyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjIUWyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD7C110
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:43 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMe6td009492;
        Thu, 21 Sep 2023 22:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MHitxDHdHxRHb2NtEOdi0JivkDBDnArbdVXfZV209uc=;
 b=Kz9z0yU6k54DK6E7dku4zXdRADMXF6L+/VEwphk9WKReZyIMHLdE9Ihk13oQKIfvT8K9
 +GNFiu4k5nX8GNbbwOO0VyKFTHL314EChusROTKT0AitawTOqn4XOtCwq76++f+RvNU0
 2BEV10PHnig600E17xai3f9TcJQNzdtFKY4knOg8vqFsASdSJ+8tbHjDGhhlDKK/WWA7
 VYIHktgnYvtQH5ZsG2H0vIPpibBs60Sg0ovfx7ouPXTFve34QHviYoR7HjfiwBjkhsxB
 utyVT6suOXJdDxp8qa8HqWyfs7fiyR+7bhIx0RDtDquKBAfzWXzwZwDyYm1AVW5mKBgb tw== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8v2gvhcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:40 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLuKBK022854;
        Thu, 21 Sep 2023 22:54:39 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t8tspv74f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:39 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMscGQ8389250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:38 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B862458051;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84C5E5805A;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 05/11] ibmvfc: use a bitfield for boolean flags
Date:   Thu, 21 Sep 2023 17:54:29 -0500
Message-Id: <20230921225435.3537728-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Io3tjmQcoqQp33_qVI64Cub2MGuhYJvr
X-Proofpoint-GUID: Io3tjmQcoqQp33_qVI64Cub2MGuhYJvr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=928 spamscore=0
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309210196
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

