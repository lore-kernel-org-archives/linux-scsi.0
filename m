Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8FBC43217
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF3E23A5E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhANUdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:33:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61900 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727092AbhANUcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:32:42 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EKVjRX036399;
        Thu, 14 Jan 2021 15:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nKk1Um+B2/FZbZZiiN+/A8qPSztGvj/zmOxIlgLrIkE=;
 b=DTeRt6Kxay4pdWDRTekxaER5ytzAeX1TmVEG3xxLwh6VgVfd6cKf3Yau6yCBQJTQO9pz
 nzbgGO57FrALBqkCEVmQtbB8xeZ8o86MrKwOFl4rUtlsrp7e6sEYgOZ5Mi0Qgc4kvX8B
 JgYc0gZmkb9+ru7BDSjAAmS9yW5BZE7KW0jlF8eCZUaAASUaycExx7xcDRHn58a6XUNB
 BcyzCzKuokxKnMOA5yNHTVbttLP5zlim2Jg8Tym8xefpZPTpd/5sYzSmwgz3Cqt/dZkR
 fp4+M6HR5mUji0U9fpKfeKCdlIxUgu1Nfx1VAJaj3ESLgicZ5Q9FDTxPuVqwVAW0aBfC LQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362vbj94rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:31:55 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKS7fS007035;
        Thu, 14 Jan 2021 20:31:54 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 35y449sr0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:54 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVqLK23265688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:52 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 628A16E05F;
        Thu, 14 Jan 2021 20:31:52 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F98D6E052;
        Thu, 14 Jan 2021 20:31:52 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 20:31:51 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v5 05/21] ibmvfc: define hcall wrapper for registering a Sub-CRQ
Date:   Thu, 14 Jan 2021 14:31:32 -0600
Message-Id: <20210114203148.246656-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101140115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sub-CRQs are registred with firmware via a hypercall. Abstract that
interface into a simpler helper function.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 524e81164d70..612c7f3d7bd3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -138,6 +138,20 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
 static const char *unknown_error = "unknown error";
 
+static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
+			  unsigned long length, unsigned long *cookie,
+			  unsigned long *irq)
+{
+	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
+	long rc;
+
+	rc = plpar_hcall(H_REG_SUB_CRQ, retbuf, unit_address, ioba, length);
+	*cookie = retbuf[0];
+	*irq = retbuf[1];
+
+	return rc;
+}
+
 static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
 {
 	u64 host_caps = be64_to_cpu(vhost->login_buf->resp.capabilities);
-- 
2.27.0

