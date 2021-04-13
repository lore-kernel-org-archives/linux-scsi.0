Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E2DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 00:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D851861369
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 00:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344277AbhDMAKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 20:10:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24346 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239862AbhDMAKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 20:10:39 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D033Au074297;
        Mon, 12 Apr 2021 20:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=b5OkmVCIlgrSNkc0HXVFd7Y74lhcvJOs79Gyz/bi1os=;
 b=BFd4OOshzYxytYPezKs8Lp5ocCWZK8R3xLxMHAsQMUhkLngtJ8TUwg20j4lk90jggkfb
 MWrhzWNXBMtuxQtT/7Wi5ovFIT99PQfJic85dc2l3BdT7mBCCjn8baz/3yMUKFKtCDXb
 1q9Gp0kT58BsmcJwEebudUmEXwWjkoe82ZkSup2Uc85spDUQHR6Nn+DjULELFKNyrpGN
 Ef+mtj1uP0ZTuj16Z2NRqSQ0GzPDfoGjduJp9sXrEqSlPNQPaORdsUX44zYzjC8mIKmE
 KIpbtmyWgkNx2TLk97od/VY8IPa8WQKaF2EwwS62azELvSCEWSNeANuC+/vrfweqzizB YQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37uskah5xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 20:10:13 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D08APE026827;
        Tue, 13 Apr 2021 00:10:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 37u3n9hcuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 00:10:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D0ABJT20906406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 00:10:11 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B1C5BE053;
        Tue, 13 Apr 2021 00:10:11 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C135EBE04F;
        Tue, 13 Apr 2021 00:10:10 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 00:10:10 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH] ibmvfc: Fix invalid state machine BUG_ON
Date:   Mon, 12 Apr 2021 18:10:09 -0600
Message-Id: <20210413001009.902400-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9A9OYfiBUiRlRes3E9Oel-LhcAYgExpD
X-Proofpoint-GUID: 9A9OYfiBUiRlRes3E9Oel-LhcAYgExpD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>

This fixes an issue hitting the BUG_ON in ibmvfc_do_work. When
going through a host action of IBMVFC_HOST_ACTION_RESET,
we change the action to IBMVFC_HOST_ACTION_TGT_DEL,
then drop the host lock, and reset the CRQ, which changes
the host state to IBMVFC_NO_CRQ. If, prior to setting the
host state to IBMVFC_NO_CRQ, ibmvfc_init_host is called,
it can then end up changing the host action to IBMVFC_HOST_ACTION_INIT.
If we then change the host state to IBMVFC_NO_CRQ, we will then
hit the BUG_ON. This patch makes a couple of changes to avoid this.
It leaves the host action to be IBMVFC_HOST_ACTION_RESET
or IBMVFC_HOST_ACTION_REENABLE until after we drop the host
lock and reset or reenable the CRQ. It also hardens the
host state machine to ensure we cannot leave the reset / reenable
state until we've finished processing the reset or reenable.

Fixes: 73ee5d867287 ("[SCSI] ibmvfc: Fix soft lockup on resume")
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
[tyreld: added fixes tag]
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 53 ++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 61831f2fdb30..f813608d74cc 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -603,8 +603,17 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 		if (vhost->action == IBMVFC_HOST_ACTION_ALLOC_TGTS)
 			vhost->action = action;
 		break;
+	case IBMVFC_HOST_ACTION_REENABLE:
+	case IBMVFC_HOST_ACTION_RESET:
+		vhost->action = action;
+		break;
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
+	case IBMVFC_HOST_ACTION_LOGO:
+	case IBMVFC_HOST_ACTION_QUERY_TGTS:
+	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
+	case IBMVFC_HOST_ACTION_NONE:
+	default:
 		switch (vhost->action) {
 		case IBMVFC_HOST_ACTION_RESET:
 		case IBMVFC_HOST_ACTION_REENABLE:
@@ -614,15 +623,6 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 			break;
 		}
 		break;
-	case IBMVFC_HOST_ACTION_LOGO:
-	case IBMVFC_HOST_ACTION_QUERY_TGTS:
-	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
-	case IBMVFC_HOST_ACTION_NONE:
-	case IBMVFC_HOST_ACTION_RESET:
-	case IBMVFC_HOST_ACTION_REENABLE:
-	default:
-		vhost->action = action;
-		break;
 	}
 }
 
@@ -5373,30 +5373,45 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_INIT_WAIT:
 		break;
 	case IBMVFC_HOST_ACTION_RESET:
-		vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
 		list_splice_init(&vhost->purge, &purge);
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		ibmvfc_complete_purge(&purge);
 		rc = ibmvfc_reset_crq(vhost);
+
 		spin_lock_irqsave(vhost->host->host_lock, flags);
-		if (rc == H_CLOSED)
+		if (!rc || rc == H_CLOSED)
 			vio_enable_interrupts(to_vio_dev(vhost->dev));
-		if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
-		    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
-			dev_err(vhost->dev, "Error after reset (rc=%d)\n", rc);
+		if (vhost->action == IBMVFC_HOST_ACTION_RESET) {
+			/* The only action we could have changed to would have been reenable,
+			 in which case, we skip the rest of this path and wait until
+			 we've done the re-enable before sending the crq init */
+
+			vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
+
+			if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
+			    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
+				ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+				dev_err(vhost->dev, "Error after reset (rc=%d)\n", rc);
+			}
 		}
 		break;
 	case IBMVFC_HOST_ACTION_REENABLE:
-		vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
 		list_splice_init(&vhost->purge, &purge);
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		ibmvfc_complete_purge(&purge);
 		rc = ibmvfc_reenable_crq_queue(vhost);
+
 		spin_lock_irqsave(vhost->host->host_lock, flags);
-		if (rc || (rc = ibmvfc_send_crq_init(vhost))) {
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
-			dev_err(vhost->dev, "Error after enable (rc=%d)\n", rc);
+		if (vhost->action == IBMVFC_HOST_ACTION_REENABLE) {
+			/* The only action we could have changed to would have been reset,
+			 in which case, we skip the rest of this path and wait until
+			 we've done the reset before sending the crq init */
+
+			vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
+			if (rc || (rc = ibmvfc_send_crq_init(vhost))) {
+				ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+				dev_err(vhost->dev, "Error after enable (rc=%d)\n", rc);
+			}
 		}
 		break;
 	case IBMVFC_HOST_ACTION_LOGO:
-- 
2.27.0

