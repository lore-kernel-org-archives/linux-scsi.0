Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09589C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 08:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344954AbiCHIWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 03:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344958AbiCHIWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 03:22:08 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D4D3F337
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 00:21:11 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22881NIE019263
        for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2022 00:21:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=WauoYmXPAzia8qIEqGeMdO4HverGL8Dm4HD5UNAkHRs=;
 b=Fi7f/ks81tQnpQSthqjECa0Hg1neObrhQg8hyX83kwvaSdSKvihUTJoFZqcr5bvkgQUp
 xQCT5f0bTj7stDQUyqQFOg3ZCIP2P75WiZgsB8X3X7Kho+OcMcgRyyWGF1I0crZlgQM0
 YmL0hpoBrFYgzRoyoOFG0TuS3VsUSs4uE3ToDEGNBBTqwsV6AH2TzMRvlg7INNvf/LIA
 rduhEmf06f3mJOWVOhzKZhGQ2BSiaJgj/obDna7nDCCQICLKAYGvxIWJ/u6zUORhhzpO
 xq0j9PwRqIIwqCTK6eHagGnXEdhSUChuAC+bgEv13iPbSkm77/9Mfvbm2XRCHtWgOfEZ KQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38p838b-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2022 00:21:10 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Mar
 2022 00:21:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Mar 2022 00:21:06 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4F02B5B6930;
        Tue,  8 Mar 2022 00:21:06 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 2288L6Ux009845;
        Tue, 8 Mar 2022 00:21:06 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 2288L66L009844;
        Tue, 8 Mar 2022 00:21:06 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/13] qla2xxx: reduce false trigger to login
Date:   Tue, 8 Mar 2022 00:20:44 -0800
Message-ID: <20220308082048.9774-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220308082048.9774-1-njavali@marvell.com>
References: <20220308082048.9774-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: JjnZn8_b3TdJHLIeU0tjRRly6SyAnrJs
X-Proofpoint-ORIG-GUID: JjnZn8_b3TdJHLIeU0tjRRly6SyAnrJs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

While a session is in the middle of a relogin,
a late RSCN can be delivered from switch. RSCN trigger fabric
scan where the scan logic can trigger another session login
while a login is in progress.
This patch reduce the extra trigger to prevent multiple login
to the same session.

Cc: stable@vger.kernel.org
Fixes: bee8b84686c4 ("scsi: qla2xxx: Reduce redundant ADISC command for RSCNs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3c58a2911937..a53894444460 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1644,7 +1644,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	    fcport->login_gen, fcport->loop_id, fcport->scan_state,
 	    fcport->fc4_type);
 
-	if (fcport->scan_state != QLA_FCPORT_FOUND)
+	if (fcport->scan_state != QLA_FCPORT_FOUND ||
+	    fcport->disc_state == DSC_DELETE_PEND)
 		return 0;
 
 	if ((fcport->loop_id != FC_NO_LOOP_ID) &&
@@ -1665,7 +1666,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (vha->host->active_mode == MODE_TARGET && !N2N_TOPO(vha->hw))
 		return 0;
 
-	if (fcport->flags & FCF_ASYNC_SENT) {
+	if (fcport->flags & (FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE)) {
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return 0;
 	}
-- 
2.19.0.rc0

