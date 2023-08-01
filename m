Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CFCC0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 11:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbjHALlb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbjHALl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 07:41:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C767B10FA
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 04:41:25 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371AL7bZ013838
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2023 04:41:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=yj7w3npxO9wQ/egdOP3Us9dX76oArXzKe+YVISo1N1U=;
 b=NR2wkx8DdKqXuOvkNFF38Mj30VVlBnvECJe5KgArUm8ZsUtWfGhkUq/vxlIsEzgjClTA
 PNNGzEdhJRFWWm4NFUwHCMi2KT+1xKL3fBZ8Efe8XjvUg8SFNJgtXuIKdHi4fMSCdvPS
 8z6vQhNYQX+MEl7saGyrUemDiZTD773JtllnnocZ5RMREQbUqRWMU5+a2xZp2JipAqIV
 jRarMtx9bv0+y+83TSuMENavjUHofd4KFaXG8FppVzIEV22G8SvRfkXIL/QX2Sgb+Dq1
 /ulabTunx9R2ZZ7qDhSjWulHvee3an54mvN8Sw1ixs4BSgFUMUOn8sbEHqyIKqsu2LAq 3g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3s707dg83k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 04:41:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:41:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 1 Aug 2023 04:41:23 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id BD2D23F7040;
        Tue,  1 Aug 2023 04:41:21 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 09/10] Revert "scsi: qla2xxx: Fix buffer overrun"
Date:   Tue, 1 Aug 2023 17:10:56 +0530
Message-ID: <20230801114057.27039-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230801114057.27039-1-njavali@marvell.com>
References: <20230801114057.27039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: MBQ6foNtvwYI3lbZDv3zIHtB4224FUrt
X-Proofpoint-ORIG-GUID: MBQ6foNtvwYI3lbZDv3zIHtB4224FUrt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Revert due to Get PLOGI Template failed.
This reverts commit b68710a8094fdffe8dd4f7a82c82649f479bb453.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 62087ce51b3f..d4df07aaa0ab 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5607,7 +5607,7 @@ static void qla_get_login_template(scsi_qla_host_t *vha)
 	__be32 *q;
 
 	memset(ha->init_cb, 0, ha->init_cb_size);
-	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
+	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
 	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
 					    ha->init_cb, sz);
 	if (rval != QLA_SUCCESS) {
-- 
2.23.1

