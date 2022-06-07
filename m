Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC19C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiFGErD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbiFGEqq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3F0D4104
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:45 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXafs025411
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=A8O7tCGZa3RM1J0DVj/Lbb7bQC9goAyttj451QrYAUc=;
 b=Z9ByBFPfG/gOa5acPDDHjDYXxFoum4Zan5NuwBYHhOMiuemHE8Yv24+VIJObRQ20oaqO
 ibZ0RNxgWZA3+33Z6tCybzO3GKSpu3XVXbJoVfq6eBor7gJJmtDoEHIxvqAdBSnsdWo7
 am6St8wwM0BBjWrMFQwRYv27KzMpPXyoe9EubI9IaTRGyauFGHmyTReULfX2V6on4e1U
 NHbNB5D2gPfNl39V6EXYOVYAVSPBhk5jVD0qm8t+G7fVqfXFBFobBC/JwZ8VEy7/k15j
 TcTPeISW9C++MhauE4GDTh9jKL25GH9qvD040B1/6zj7kFnJ3sm3AcQqTDZ4Brh3TNzr 2w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8e-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jun
 2022 21:46:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:42 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 035443F7068;
        Mon,  6 Jun 2022 21:46:41 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 10/11] qla2xxx: edif: fix n2n login retry for secure device
Date:   Mon, 6 Jun 2022 21:46:26 -0700
Message-ID: <20220607044627.19563-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: keYqTsJUyKHKA0JSyQTNhW3Do-I-3JbO
X-Proofpoint-GUID: keYqTsJUyKHKA0JSyQTNhW3Do-I-3JbO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

After initiator has burn up all login retry, target authentication
application begins to run. This triggers a link bounce on target side.
Initiator will attempt another login. Due to N2N, the prli [nvme | fcp]
can fail because of the mode mismatch with target. This patch add a
few more login retries to revive the connection.

Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ec1722e86f10..d915c1f85fa2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2123,6 +2123,13 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		}
 
 		if (N2N_TOPO(vha->hw)) {
+			if (ea->fcport->n2n_link_reset_cnt ==
+			    vha->hw->login_retry_count &&
+			    ea->fcport->flags & FCF_FCSP_DEVICE) {
+				/* remote authentication app just started */
+				ea->fcport->n2n_link_reset_cnt = 0;
+			}
+
 			if (ea->fcport->n2n_link_reset_cnt <
 			    vha->hw->login_retry_count) {
 				ea->fcport->n2n_link_reset_cnt++;
-- 
2.19.0.rc0

