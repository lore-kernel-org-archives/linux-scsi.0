Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3463C2D0ED
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B57F7206F2
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YUvTDffm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgC0Oc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 10:32:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61726 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726518AbgC0Oc7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 10:32:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02REVKRf002782
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2020 07:32:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=FbWI/oRaR8adAHpIU+yeNVP3dA70m0waj+JtywflHgs=;
 b=YUvTDffmrxTCGt9rKIcDqpHY3N4X5Ro0etlXQWxNU5IpoE5qwZ1QhlUxHw/uHYZ5x/N1
 BXDQc286IdkhFSPNryE9YEpSpFRN4vWflWjWwVlRNFy0FRz+h0Pe2kqhKU7TXZ+Bnfxz
 oIKfQVzfudu8gKggPFsg9m1aUHojNT+sXtD56OHdRfPTCva9qcTvRY6D1w5t5WBrq3Kh
 cuV2VIEc2WovHN1EZQFL/Qnw3kzXIM3/9RlhgpgVdCFJsYI0TSF1TfGSyShfPm+TFXYb
 Qhj5eto2obiMl+sizXZ7W1DqurSvJA+91SiVRK0Ul+jUuR+pBS46eVvlaICEAJDcJHs4 rA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpd1gcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2020 07:32:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 07:32:56 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 07:32:56 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 27 Mar 2020 07:32:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A82A53F703F;
        Fri, 27 Mar 2020 07:32:55 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02REWt3x027331;
        Fri, 27 Mar 2020 07:32:55 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02REWtIc027330;
        Fri, 27 Mar 2020 07:32:55 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 2/3] qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV.
Date:   Fri, 27 Mar 2020 07:32:47 -0700
Message-ID: <20200327143248.27288-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200327143248.27288-1-njavali@marvell.com>
References: <20200327143248.27288-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_05:2020-03-27,2020-03-27 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

In NPIV environment, a NPIV host may use a queue pair created
by base host or other NPIVs, so the check for a queue pair
created by this NPIV is not correct, and can cause an abort
to fail, which in turn means the NVME command not returned.
This leads to hang in nvme_fc layer in nvme_fc_delete_association()
which waits for all I/Os to be returned, which is seen as hang
in the application.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9fd83d1bffe0..7cefe35d61d1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3153,7 +3153,7 @@ qla24xx_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 	else
 		return QLA_FUNCTION_FAILED;
-- 
2.19.0.rc0

