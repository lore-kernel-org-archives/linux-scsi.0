Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92290C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 646DA21734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QXBcB6NN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgBLVry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:54 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54002 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729128AbgBLVry (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLeja2001670;
        Wed, 12 Feb 2020 13:45:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=jyF+yST81BaZE4isR7NP2Bvj+M1X/1oToJF1rPKBWcM=;
 b=QXBcB6NNNJmGTr+x5g6nUlR9QeVYs0GfMEvX2Qhwt42vrkV5ZkXBH9oY8O7I3eIGG0Pe
 fkF1zo/xdKes+1sKsXfwn8JJmjdCIw5jORpUJi9efHuXY9QnQhyPrlzYJdFtyA9jQ7sF
 aDmwzD5Vhe68hKVKqLbzld5J/quNMgP5GKSnJR9j/75g0An5VBCsVEAlS+qX50bCfCfp
 lK2j2N2rvW0R60CcqfwZUPhWY3D6QK/9WHqKh4pEMELBEUMrue3mPwY3gxSbcExbGphJ
 xRAytRXPPtL9VoPFa8dwCDfUYBVem7YvD+oNJW3Bg6CyqXL4SZ8eguLANLmBj+rzn97e rw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt52m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:52 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:50 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:50 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B6B883F703F;
        Wed, 12 Feb 2020 13:45:50 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjor9025672;
        Wed, 12 Feb 2020 13:45:50 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjomW025671;
        Wed, 12 Feb 2020 13:45:50 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 24/25] qla2xxx: Use QLA_FW_STOPPED macro to propagate flag
Date:   Wed, 12 Feb 2020 13:44:35 -0800
Message-ID: <20200212214436.25532-25-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch uses QLA_FW_STOPPED macro, so that flag is propogated
to all the QPairs.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8fee3f5154c7..1ec93e28560e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6676,7 +6676,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	ha->flags.n2n_ae = 0;
 	ha->flags.lip_ae = 0;
 	ha->current_topology = 0;
-	ha->flags.fw_started = 0;
+	QLA_FW_STOPPED(ha);
 	ha->flags.fw_init_done = 0;
 	ha->chip_reset++;
 	ha->base_qpair->chip_reset = ha->chip_reset;
-- 
2.12.0

