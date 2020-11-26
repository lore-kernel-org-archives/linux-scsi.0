Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A19C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C91A2075A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NeQWGP5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbgKZBso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:48:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17966 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgKZBsm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 20:48:42 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ1VdpW145970;
        Wed, 25 Nov 2020 20:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eQLPrpmDLn0mKDW30XVCZe15M7EbeGguUVmQUeWFaO0=;
 b=NeQWGP5MRi87wpW9xwgZyxokbB2RmPgoSugTI1TFvmQJ1CCxbtHB2I4CKHP7nRSoh6Ph
 dNaCrZjUl2J4+MJaj8Cl988bJtGpu0vbdP34ukxq6OPbM803/t7F+20r+CmwFKm5APOQ
 nbM5X9jdCxRcrp1j9z7FVHz/HcIWFYiAjxoVEgNgf47IBnCTbxjZzIoLyaeTYobp+3fX
 kdlfuTaQa9VsYvWmSIRopxtUJXsYWxMwSkkiU0sE3lmkY5/uu6aMw/696WDg1V41ayUo
 MsLalqwnMsZ4cAeWEyBIYO+wyV43j/33RxJq2GFb1Gy02j7zu0jRt1YqVUTciwMt7N8B pA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351wndpsvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 20:48:32 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ1m8dN028849;
        Thu, 26 Nov 2020 01:48:32 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 34xth9vrqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 01:48:32 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ1mUeV18088382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 01:48:31 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8BCC6E053;
        Thu, 26 Nov 2020 01:48:30 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E4FC6E052;
        Thu, 26 Nov 2020 01:48:30 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 01:48:30 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 03/13] ibmvfc: add Subordinate CRQ definitions
Date:   Wed, 25 Nov 2020 19:48:14 -0600
Message-Id: <20201126014824.123831-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201126014824.123831-1-tyreld@linux.ibm.com>
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_14:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260001
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
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 8225bdbb127e..084ecdfe51ea 100644
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

