Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A23C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbiFHL7A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238397AbiFHL67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:58:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3556A16F938
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:58:58 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2587SoaA013216
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:58:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dc3ECuf0ogrGfko3U+vxZCgjxpGHnfOCbvl7avAPKJc=;
 b=dQi07SRHcF9D4SAJTKdr4JnT1RHmLRD6YHMIOtpGJYr++pJIXhadiqwLlCYSKhcdZF32
 L/qmnYIf3Dr8tbIH7n57oplhR9BgL4x+au1XARK8Toyo7oCF0Fa9ae6kD2F1FS+Y9wqn
 OUHBXTMYh+92JGNmU/s/NwGyjHsd/tREsZxIhu4+touX2eqvzZHE10JALVHP/cLdmcEl
 +7azm3zkNtUR0fu2q7uX5L9ixQ+QTRP7lS63kkok4ZrewrP7cUsnVEGkSfJJBd/Vl+bE
 +Z0xpogXlB5NhDdKSICRn3RyaJU1cYyz8/jyiwFPtHaaOOM0xRs9BmgdK08CcyhaB2jL sA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gjqdps05t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:58:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jun
 2022 04:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 19F0D3F7089;
        Wed,  8 Jun 2022 04:58:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/10] qla2xxx: edif: fix no login after app start
Date:   Wed, 8 Jun 2022 04:58:43 -0700
Message-ID: <20220608115849.16693-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Lp7xIQKkOoh4aXAbecpzvJDXIP8uTD2Q
X-Proofpoint-GUID: Lp7xIQKkOoh4aXAbecpzvJDXIP8uTD2Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

The scenario is user loaded driver but has not start authentication
app. All sessions to secure device will exhaust all login attempt,
fail and in stay in delete state.
Some time later, app started. Driver will:
replenish the login retry count,
trigger delete to prepare for secure login,
after deletion, relogin is triggered.

For the session that is already deleted, the delete trigger
is a no-op. If none of the session trigger the relogin needed, then
there's no movement.

This patch add a re-login trigger to relogin.

Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index a4e444ea0363..dd3593333d7b 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -567,6 +567,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			qlt_schedule_sess_for_deletion(fcport);
 			qla_edif_sa_ctl_init(vha, fcport);
 		}
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 	}
 
 	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
-- 
2.19.0.rc0

