Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652DFC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 06:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 430FF61355
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 06:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbhESGQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 02:16:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45624 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231191AbhESGQB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 May 2021 02:16:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J65XOu014594
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 23:14:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=QSbsGo+bQ2CcFoe9EfA31hvgz9dMt3itvgp1nWPWxyY=;
 b=Yn9hqkKr9q685Vdp65HXpg3QUKK1AMeV2AwCKhWt7UK82+c/gELJhph6vvc9d/cT0fOl
 veOAOVnwFGT1cnus+VygWMqnTz0H+QbN+fi7F9Y14mA1xKTNYxMMhkIAKJbB/sdsb/JY
 SY/RvTAIib2t+R1VdHMKzUNSgMteOohXiEpy6URlWN+iMDdcOqSGjQ6HLteAT79sZgww
 d/Pmanj9sMtGyp5wjWIustWCVI3e4/vI97wgErCoH1ngUYoLNpKHJGXHHOK1VtRoIrgB
 5T7I24rdL+SUl+D8sw3GD5RdY4tjlH2TU5a4o2lMVLhXXG76U3BuNrIPxwJcld2Bs6Ti mA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38mqc1h3vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 23:14:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 May
 2021 23:14:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 May 2021 23:14:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CD1C65B6938;
        Tue, 18 May 2021 23:14:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14J6EeoZ019365;
        Tue, 18 May 2021 23:14:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14J6Eema019355;
        Tue, 18 May 2021 23:14:40 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH] bnx2fc: Return failure from bnx2fc_eh_abort() since io_req is already in abts processing
Date:   Tue, 18 May 2021 23:14:16 -0700
Message-ID: <20210519061416.19321-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: fi2zmMeeG1mjttbFAzLD3fNu_3bCNUPl
X-Proofpoint-ORIG-GUID: fi2zmMeeG1mjttbFAzLD3fNu_3bCNUPl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -Return failure as abts is already in processing.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1a0dc18d6915..ed300a279a38 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1220,6 +1220,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
-- 
2.18.2

