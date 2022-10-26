Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FF3C38A2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 18:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiJZSOV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 14:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiJZSOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 14:14:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E440AB80F
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 11:14:19 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QI8lZT005118;
        Wed, 26 Oct 2022 18:14:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OYmqZvZ+irXwuSAnR/t6qV1pFq1Ay+RDfTTRuBZbi60=;
 b=MZjNK0EyZ0FMOON0gUo/FEHNM1oxoJ97Bz6iz08hAKi6Tm31e6JFZviRrPYsT7QDtXpg
 gM+W/12PR071d3pFnfSLfdw0esQkW7zp1uzfEzJ7LCKMdlBwCMu0usAPyWkCgiF0y6Lj
 5UIgi+41QcIe0I6IXy0/UWNj2/NIPEF9trWQGb3vpDOfgWLgrpc6a7KbgWXAOYwsGGBr
 KjMr+xvC3d7t92PMGPUd44mcvVE5menilEX5dkBe1HO5OHNQ4f5KSApT70dbiMtlf1rx
 6odWcdrKwwpjjP1hPVBw6sYsJtBfvOqqk0mVGFLrjUWxzLYCV45J4AhKytW5y9Z3Kmf9 Lw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf8uuac05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 18:14:13 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29QI6Ckk032017;
        Wed, 26 Oct 2022 18:14:12 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 3kc85axp6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 18:14:12 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29QIEA8G41091392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 18:14:10 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27B5358061;
        Wed, 26 Oct 2022 18:14:11 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB2DB5805D;
        Wed, 26 Oct 2022 18:14:10 +0000 (GMT)
Received: from li-6bf4d4cc-31f5-11b2-a85c-838e9310af65.ibm.com.com (unknown [9.163.43.124])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 18:14:10 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     tyreld@linux.ibm.com
Cc:     linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: Avoid path failures during live migration
Date:   Wed, 26 Oct 2022 13:13:56 -0500
Message-Id: <20221026181356.148517-1-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _BiNbAOrhfyt6SDNYhxPZCtxlEizwYpo
X-Proofpoint-ORIG-GUID: _BiNbAOrhfyt6SDNYhxPZCtxlEizwYpo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_07,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260102
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes an issue reported when performing a live
migration when multipath is configured with a short fast
fail timeout of 5 seconds and also to have no_path_retry
set to fail. In this scenario, all paths would go into the
devloss state while the ibmvfc driver went through discovery
to log back in. On a loaded system, the discovery might
take longer than 5 seconds, which was resulting in all paths
being marked failed, which then resulted in a read only filesystem.

This patch changes the migration code in ibmvfc to
avoid deleting rports at all in this scenario, so we
avoid losing all paths.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 00684e11976b..1a0c0b7289d2 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -708,8 +708,13 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 		memset(vhost->async_crq.msgs.async, 0, PAGE_SIZE);
 		vhost->async_crq.cur = 0;
 
-		list_for_each_entry(tgt, &vhost->targets, queue)
-			ibmvfc_del_tgt(tgt);
+		list_for_each_entry(tgt, &vhost->targets, queue) {
+			if (vhost->client_migrated)
+				tgt->need_login = 1;
+			else
+				ibmvfc_del_tgt(tgt);
+		}
+
 		scsi_block_requests(vhost->host);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
 		vhost->job_step = ibmvfc_npiv_login;
@@ -3235,9 +3240,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 			/* We need to re-setup the interpartition connection */
 			dev_info(vhost->dev, "Partition migrated, Re-enabling adapter\n");
 			vhost->client_migrated = 1;
+
+			scsi_block_requests(vhost->host);
 			ibmvfc_purge_requests(vhost, DID_REQUEUE);
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_set_host_state(vhost, IBMVFC_LINK_DOWN);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_REENABLE);
+			wake_up(&vhost->work_wait_q);
 		} else if (crq->format == IBMVFC_PARTNER_FAILED || crq->format == IBMVFC_PARTNER_DEREGISTER) {
 			dev_err(vhost->dev, "Host partner adapter deregistered or failed (rc=%d)\n", crq->format);
 			ibmvfc_purge_requests(vhost, DID_ERROR);
-- 
2.31.1

