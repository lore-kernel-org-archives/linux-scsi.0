Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34858C8300C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7801206F7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hX19DKtj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732724AbgKZBtP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:49:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731040AbgKZBsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 20:48:41 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ1YIp4028947;
        Wed, 25 Nov 2020 20:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wxseCDOIWmAqaI8JiONcKCsnb83eQ0s3L1Y8IZ1Jv24=;
 b=hX19DKtjLxNQiZWJkqpFZ56He3W/ntjAUqCbRfYZ+v420q4QO32u+rSfugxHA7F8XxYI
 0E/ulMgAtYJbk5BenX5tQhi0uFBDPUCNxUna4dk+MWlumsbwydB9s2Stcjo+jmxguybq
 2xWjgxKqb8ii14bcy3Y4HIGeGqH//l6rtmn9Z3ucuuju83JrJMeHBqFPMpmM0u2SQua5
 mOFC6DYJHv7OKjgTbs7gMt4luAy1JsQNzfB5RC1hkRBNkmgaacpt8CWZSp+xhzfeLNxw
 ccrZGJZFGALAxFypjKRaRQWyGQWpD2P31aGY+eEyuHVM/F5qw654XOiwxUp9L8t9El4A Ew== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3521cht09q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 20:48:36 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ1ZOPN013521;
        Thu, 26 Nov 2020 01:48:34 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 34xth9bnux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 01:48:34 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ1mXGa64880920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 01:48:33 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7296D6E04E;
        Thu, 26 Nov 2020 01:48:33 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BAB46E053;
        Thu, 26 Nov 2020 01:48:33 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 01:48:33 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 10/13] ibmvfc: advertise client support for using hardware channels
Date:   Wed, 25 Nov 2020 19:48:21 -0600
Message-Id: <20201126014824.123831-11-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201126014824.123831-1-tyreld@linux.ibm.com>
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_14:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=983 lowpriorityscore=0 suspectscore=1 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Previous patches have plumbed the necessary Sub-CRQ interface and
channel negotiation MADs to fully channelized hardware queues.

Advertise client support via NPIV Login capability
IBMVFC_CAN_USE_CHANNELS when the client bits have MQ enabled via
vhost->mq_enabled, or when channels were already in use during a
subsequent NPIV Login. The later is required because channel support is
only renegotiated after a CRQ pair is broken. Simple NPIV Logout/Logins
require the client to continue to advertise the channel capability until
the CRQ pair between the client is broken.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 40a945712bdb..55893d09f883 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1272,6 +1272,10 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
 	login_info->max_cmds = cpu_to_be32(max_requests + IBMVFC_NUM_INTERNAL_REQ);
 	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
+
+	if (vhost->mq_enabled || vhost->using_channels)
+		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
+
 	login_info->async.va = cpu_to_be64(vhost->async_crq.msg_token);
 	login_info->async.len = cpu_to_be32(vhost->async_crq.size * sizeof(*vhost->async_crq.msgs));
 	strncpy(login_info->partition_name, vhost->partition_name, IBMVFC_MAX_NAME);
-- 
2.27.0

