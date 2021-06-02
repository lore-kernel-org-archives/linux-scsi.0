Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E75CC47092
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 10:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855FB613BF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 10:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhFBKuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 06:50:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59656 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231329AbhFBKtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 06:49:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152Ak9he030092
        for <linux-scsi@vger.kernel.org>; Wed, 2 Jun 2021 03:47:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=lbxnEHC94H891BTQdQyXbuCjeVZAWEC7oANUFb60QLw=;
 b=SwJBAuZU7SY//Tc3draDYHCU18tvzJzjb2gI/BviC0U6a0cOgkpakYXFqwPxX5CIUiSk
 IUR0G02Gs46jVsY5hK4vCohaTjxr3VW4I00B/qgrTiwQDmjzR+lsV8EhL5cX48vqYlJV
 LhEyJGJY7CStp/TY5BAUGa+ZTml2odo39or6FPg+3vZzoMH2bFunKaxNpYj6yJBFner2
 KgO7c3IhYJN1ARBPSs5T3Dc2o7/+UDyV/zbSkg4htz3bDPtlERwU+FXXnSCLnOidbF2p
 R7Pa4nbrWKniY/7e84eFLENBaXXX912vixJA1z+SgngcAR52HkX956JOwqUnlV3hUirG XA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38wug72j60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jun 2021 03:47:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 03:47:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 03:47:20 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2A9BE3F7051;
        Wed,  2 Jun 2021 03:47:18 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 152AlHtT017313;
        Wed, 2 Jun 2021 03:47:17 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 152AlHGW017312;
        Wed, 2 Jun 2021 03:47:17 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH V2] qedf: Update the max_id value in host structure.
Date:   Wed, 2 Jun 2021 03:46:53 -0700
Message-ID: <20210602104653.17278-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 98BqvhZZPy9T9QLcYXJJqNH9KYCBZzIq
X-Proofpoint-GUID: 98BqvhZZPy9T9QLcYXJJqNH9KYCBZzIq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_06:2021-06-02,2021-06-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

  The max_id value defines the max id of the target that stack
  can scan during manual scanning through scsi_host sysfs interface.
  If default value is 8, update the value to the max sessions driver support.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
Changes in v2:
 - Added description and signed-off.
---
 drivers/scsi/qedf/qedf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index c5f37277..322046f4 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2089,6 +2089,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vn_port->host->max_lun = qedf_max_lun;
 	vn_port->host->sg_tablesize = QEDF_MAX_BDS_PER_CMD;
 	vn_port->host->max_cmd_len = QEDF_MAX_CDB_LEN;
+	vn_port->host->max_id = QEDF_MAX_SESSIONS;
 
 	rc = scsi_add_host(vn_port->host, &vport->dev);
 	if (rc) {
@@ -3855,6 +3856,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		host->transportt = qedf_fc_transport_template;
 		host->max_lun = qedf_max_lun;
 		host->max_cmd_len = QEDF_MAX_CDB_LEN;
+		host->max_id = QEDF_MAX_SESSIONS;
 #ifdef USE_BLK_MQ
 		host->use_blk_mq = qedf_use_blk_mq;
 		if (shost_use_blk_mq(host)) {
-- 
2.18.2

