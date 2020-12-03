Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD78C8303B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38AF7221EB
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgLCCJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:09:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728252AbgLCCJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 21:09:01 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B322kET095952;
        Wed, 2 Dec 2020 21:08:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=quLqGqXAl/PPgl+TuyjYAEjbjck4OUuu3Qk2jmO0lrg=;
 b=HfTpzJrch9k/+CR54cx6q7JB0qQwTKPrSfs+cZOrQTtV762n2SsjbI0Xv01XDUtJXR7L
 ATk6jsf0xEHd402U08XUANGteVtKMOottZqDIXb8QRuQ6ziLK0JccB06EdRQaonYIgZ1
 IhLHZh4AyGEMXd5+UaTSxYg8G20hd6CjaUM1ffvfpq4N+uatfeamBnK83XSpjJWw2lqD
 /MlvAgLSf9K1y/Bk6CH4Efk3NbK8ukqny+ZkI/olCQKJo8OYobRYZkjPtmfP7tfnTXA7
 uKg3ledqaZYQF2DkM51CukUCuAisejdpNx/vvbil0j4OlIFAHEyil/eg+xsEz5gOw6VS LQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 356jfcxxcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 21:08:14 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B31uLTO013319;
        Thu, 3 Dec 2020 02:08:12 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrfvc7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 02:08:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B328BQ221102922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 02:08:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6561178064;
        Thu,  3 Dec 2020 02:08:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD0EE7805F;
        Thu,  3 Dec 2020 02:08:10 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 02:08:10 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v3 03/18] ibmvfc: add Subordinate CRQ definitions
Date:   Wed,  2 Dec 2020 20:07:51 -0600
Message-Id: <20201203020806.14747-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203020806.14747-1-tyreld@linux.ibm.com>
References: <20201203020806.14747-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=1
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Subordinate Command Response Queues (Sub CRQ) are used in conjunction
with the primary CRQ when more than one queue is needed by the virtual
IO adapter. Recent phyp firmware versions support Sub CRQ's with ibmvfc
adapters. This feature is a prerequisite for supporting multiple
hardware backed submission queues in the vfc adapter.

The Sub CRQ command element differs from the standard CRQ in that it is
32bytes long as opposed to 16bytes for the latter. Despite this extra
16bytes the ibmvfc protocol will use the original CRQ command element
mapped to the first 16bytes of the Sub CRQ element initially.

Add definitions for the Sub CRQ command element and queue.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index e095daada70e..b3cd35cbf067 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -656,6 +656,29 @@ struct ibmvfc_crq_queue {
 	dma_addr_t msg_token;
 };
 
+struct ibmvfc_sub_crq {
+	struct ibmvfc_crq crq;
+	__be64 reserved[2];
+} __packed __aligned(8);
+
+struct ibmvfc_sub_queue {
+	struct ibmvfc_sub_crq *msgs;
+	dma_addr_t msg_token;
+	int size, cur;
+	struct ibmvfc_host *vhost;
+	unsigned long cookie;
+	unsigned long vios_cookie;
+	unsigned long hw_irq;
+	unsigned long irq;
+	unsigned long hwq_id;
+	char name[32];
+};
+
+struct ibmvfc_scsi_channels {
+	struct ibmvfc_sub_queue *scrqs;
+	unsigned int active_queues;
+};
+
 enum ibmvfc_ae_link_state {
 	IBMVFC_AE_LS_LINK_UP		= 0x01,
 	IBMVFC_AE_LS_LINK_BOUNCED	= 0x02,
-- 
2.27.0

