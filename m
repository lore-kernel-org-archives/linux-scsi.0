Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30B1C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A794C21734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WtSSIf7U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgBLVps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:45:48 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8464 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727564AbgBLVps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:45:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLe3Cq006707;
        Wed, 12 Feb 2020 13:45:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=G7Yv3NT+nI0LfziG3idXoysr27LM0QhfYVdYvouzncw=;
 b=WtSSIf7Ur7mRD1GJLihkECTekMuq6gt056Ro/+OEd+Wp7zVR02J+8s2KGXi/BwFvZ3Lz
 ijd6xFQovXSGJP/69R/VjHJ14Bzcrz+xu5YdCImG+3uoWVa9zymvoLo3PBylyhBv8GIx
 wLiFPKBZMh8k5VIuZi8C6GD9IjATxGWC3UB4/rAM/fEAJ/Dxt+8X3HyOOxOrBmVnlTA8
 V2s4OIRHtHwzJIVOz0huMWlcP/GXxksoDsBUk1/D6OzitovOKM5dVDYxismhggHzqgwz
 vAxdggUK5yG6c/8B0y53MpnRLeX5MvcZ6sFUaZ29w1kKkSdw+kjTaVNL7Qu3p45+ioqA Sg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2bpne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:42 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:40 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F129D3F703F;
        Wed, 12 Feb 2020 13:45:40 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjedM025660;
        Wed, 12 Feb 2020 13:45:40 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjeP1025659;
        Wed, 12 Feb 2020 13:45:40 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 21/25] qla2xxx: Save rscn_gen for new fcport
Date:   Wed, 12 Feb 2020 13:44:32 -0800
Message-ID: <20200212214436.25532-22-hmadhani@marvell.com>
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

Add missing rscn_gen when creating new fcport.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index f57bfcb9c548..551102462737 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3487,6 +3487,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			if (memcmp(rp->port_name, fcport->port_name, WWN_SIZE))
 				continue;
 			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->last_rscn_gen = fcport->rscn_gen;
 			found = true;
 			/*
 			 * If device was not a fabric device before.
-- 
2.12.0

