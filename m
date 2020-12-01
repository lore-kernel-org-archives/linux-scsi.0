Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAA0C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C2A221FD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:34:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NKmAloyE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgLAIeP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:34:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21190 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726988AbgLAIeP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:34:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18VrvF026049
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:33:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=exrc/jje4l3VUZhljtLb9GxmE/A4nw7uuGY5H4cbN+Q=;
 b=NKmAloyERmJMTUpYZNR8JUa57GDEREsH0oJa4a4X04l6w7bHCZwykOY89c8uezEO4aed
 2q8njIopKQS9KDoem15xb8nw/JqnH+KeJZq9HPRfLDg/NWzzbpVHFU30nEAlMkFGtcJL
 Cpv4oHxP602USAPikNw9VTpQd6rOtbXxgC/pDwrC/eIqVV3mlkMxbu+z8AqzY6lzEtyZ
 Zz409K5ulblP1qmb5TD5PPWMVhURLuUgNH7cWIlXP6S5Z2I6XvXOV0PPMkIRMV7dLRjo
 +6rG61/5qXPfO1Ee3AP9+y8DQRTblybYqZKp8k44p82DuC3G6n5ramHkECus8sBL+jSP rw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 353pxsf7qe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:33:34 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:33:33 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:33:32 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:33:33 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E3A613F703F;
        Tue,  1 Dec 2020 00:33:32 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18XWIl024353;
        Tue, 1 Dec 2020 00:33:32 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18XWM9024352;
        Tue, 1 Dec 2020 00:33:32 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 14/15] qla2xxx: Fix device loss on 4G and older HBAs.
Date:   Tue, 1 Dec 2020 00:27:29 -0800
Message-ID: <20201201082730.24158-15-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201201082730.24158-1-njavali@marvell.com>
References: <20201201082730.24158-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Due to a bug in the older scan logic, when a once lost device
re-appeared, it was not discovered. Fix this by resetting login_retry
counter upon device discovery.

This is applicable only for 4G and older HBAs.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 12e3b05baf41..dcc0f0d823db 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5982,6 +5982,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 				break;
 			}
 
+			if (fcport->login_retry == 0)
+				fcport->login_retry =
+					vha->hw->login_retry_count;
 			/*
 			 * If device was not a fabric device before.
 			 */
-- 
2.19.0.rc0

