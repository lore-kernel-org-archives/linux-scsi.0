Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9355C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 05:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB58E613BE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 05:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhD0FK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 01:10:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51902 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhD0FK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 01:10:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13R51QAx016592;
        Mon, 26 Apr 2021 22:09:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=TUxOhcWJxDtRcDztgFpGAN123HyuwZWq64GDmoY0rVU=;
 b=eE68v9uSWD5Xpi11gUMialIb+ce0fF+Pspb0J4oNX/ROQXdbkVb+NdfBG/89H0vyt+g/
 pFjYSwllSAEqF/itv+/hOWr23a0z29pVdek4TSctWhy6vnlrDpnkkyMApTw8N1OV22C/
 cOTNE9gvsoUwD7Ft83HqCCfVA6irtfrMTIRBRIV5mxC3sdMmjxvJLt5YEQV5s1n9Cr2C
 icpyH/WUye2jnBYXIzpZ/OkKD4+gnH6pdxk9VFl/PGTVUODRMcF6FbPORqvG5AFA+fBr
 /7KLOzvNqKIqMiZd1uxsJdVSrBxW27in/3vJXOgPtH5L8V2UV3Yi0J5c2hy0VyCDPVEC sg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 385tvvk3fb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 22:09:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 22:09:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 22:09:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 34A3A3F7041;
        Mon, 26 Apr 2021 22:09:41 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 13R59db1007305;
        Mon, 26 Apr 2021 22:09:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 13R59cK4007304;
        Mon, 26 Apr 2021 22:09:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH 1/1] qla2xxx: Add marginal path support
Date:   Mon, 26 Apr 2021 22:09:14 -0700
Message-ID: <20210427050914.7270-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ADoaFjviaQNv4PhAre-ech8uy5RJzI3S
X-Proofpoint-ORIG-GUID: ADoaFjviaQNv4PhAre-ech8uy5RJzI3S
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_01:2021-04-26,2021-04-27 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Added support for eh_should_retry_cmd callback in qla2xxx host template.

Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d74c32f84ef5..4eab564ea6a0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7707,6 +7707,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= qla2xxx_eh_abort,
+	.eh_should_retry_cmd	= fc_eh_should_retry_cmd,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
 	.eh_target_reset_handler = qla2xxx_eh_target_reset,
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
-- 
2.19.0.rc0

