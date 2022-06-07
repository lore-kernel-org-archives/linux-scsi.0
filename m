Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC38CC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiFGErK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiFGEqq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBE5D02A1
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:45 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXd0Z025485
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=xCoIAmFmkvpNYM5ECbyDO5vudZEMZSohDcSi3BcRgek=;
 b=VBygulIEIv06eo1VVUrRPYBfCQhC1LyZA+SaoKi/KajY8MyPj4aDNEocUi/EqrvgelVr
 +jR6i3PxjU4kroVn3wf2KEFNH+bQ1SHWJRxI9IME5UM6UDYlRbRuWiGof7A38jzgms5H
 /wS13N9/mlQtQeO7ir1aQH9BeD7XQvFmUSDEKtBKPZEsoZymIq7+A/Ra/kr6xnlbrjxj
 1SC7yWJQVlRyqGzqvbmJbkqJ8EvmVnQpOBRFirRLwT/jmZECTD6xXsyd5CJpiLinyScb
 vfDNp18NYiGQoZe0wuqbXzXTW74fYcOVkmHuU10Z+dz/Glqxu1d3Xxz9fi4V7AIjzSyT aQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8g-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:45 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Jun
 2022 21:46:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:42 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C32CA3F7058;
        Mon,  6 Jun 2022 21:46:41 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/11] qla2xxx: edif: fix n2n discovery issue with secure target
Date:   Mon, 6 Jun 2022 21:46:25 -0700
Message-ID: <20220607044627.19563-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Z_RMpVoIPZDbSzhyjTZ8dhSrkuffJxiq
X-Proofpoint-GUID: Z_RMpVoIPZDbSzhyjTZ8dhSrkuffJxiq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

User failed to see disk via n2n topology,
driver used up all login retries before authentication
application starts. When authentication application
starts, driver did not have enough login retries to
connect as secure. On app_start, driver will reset the
login retry attempt count.

Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 7f2106f2d94d..18eb8d63e37c 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -515,6 +515,9 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	}
 
 	if (N2N_TOPO(vha->hw)) {
+		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list)
+			fcport->n2n_link_reset_cnt = 0;
+
 		if (vha->hw->flags.n2n_fw_acc_sec)
 			set_bit(N2N_LINK_RESET, &vha->dpc_flags);
 		else
-- 
2.19.0.rc0

