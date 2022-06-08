Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8E8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbiFHL7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiFHL7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:59:13 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3332A24D69C
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:59:11 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2581X4Nh020925
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:59:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=JiSKnMdH8JLQa3cviFSP4FNceUnRKFWP0j0p22stWA4=;
 b=R050SD8nBeg65gTMPAvBhaqp1pySogSz/gCc386dqb+YLNlwC5U1W3UlhkD+B+AKc7hC
 sbaT6RHHfDE8jg9u3tYJKpXgldhMLifJMYCa7sUISA/2f4t8Ci8hCt30Sy2lLHBZECIz
 lIdUCJCutQTEz0uKIRAC0HmCPnkx12kCXkW0XAmZiBYuUat5zeptk80Q38v6G3s8CFwR
 hecwhcjOMFOccFByZ4ietoDdjMTjpSn59ChyWX6k3L9XX7fvZz20nwteleQdKi4rJ1j5
 Gn5LZgUaXOQ26l864o0XpUiL9A/vaxCK9ba1tHzFxWvPKJ1rJqM0q/2X2vWL7nbwsyx2 HA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gjb7pbsag-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:59:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Jun
 2022 04:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E8A0A3F7088;
        Wed,  8 Jun 2022 04:58:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 03/10] qla2xxx: edif: reduce disruption due to multiple app start
Date:   Wed, 8 Jun 2022 04:58:42 -0700
Message-ID: <20220608115849.16693-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: qtTf5rxNYNVYSEJjBd9BV108PapWnSAI
X-Proofpoint-ORIG-GUID: qtTf5rxNYNVYSEJjBd9BV108PapWnSAI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Multiple app start can trigger session bounce.
Driver will skip over session tear down if app start is
seen more than once.

Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index d25eb212398e..a4e444ea0363 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -510,8 +510,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		/* mark doorbell as active since an app is now present */
 		vha->e_dbell.db_flags |= EDB_ACTIVE;
 	} else {
-		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
-		     __func__);
+		goto out;
 	}
 
 	if (N2N_TOPO(vha->hw)) {
@@ -578,6 +577,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		     __func__);
 	}
 
+out:
 	appreply.host_support_edif = vha->hw->flags.edif_enabled;
 	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
 	appreply.edif_edb_active = vha->e_dbell.db_flags;
-- 
2.19.0.rc0

