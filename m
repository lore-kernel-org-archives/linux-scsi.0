Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86F3C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbiFHL7E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiFHL67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:58:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012C41775D5
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:58:58 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2587SoaD013216
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:58:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=q/PChqyD9iihTLaWAJ8+9/Y/2bNUAghucgNAWNQXuZM=;
 b=L3poA11+g/lSzm061Mon9ME5NzczCvZ4I/+rI/vmN2Ui7BX7+BnfhtR+TlRx3qbyQK1A
 ImcgaJryRRhb+9m7jGcKWd7gMp2AJa1vXbGZh7jZdSZ77m4mukBdF4wdQgZhf+IR9+re
 i3bzVhie4lmvRuajkWp7HnSQbf1mgIwHvKz8G9hjaGTF8jFtbQiiVX+5eCfKSoiCZxFI
 +8BL1QrHNWqfJpoximTk3HIBNXXsnUalSE+RRcopa8tV34IdIf+8sKE2PNa0zOGQR+co
 Tlfg6LX0Ykde8LKjbRxLr3Z+3myhW8vK/vNXV/IGC5jfKkfJTJBr7YZhCjUgtwLC7y9V sQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gjqdps05t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:58:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jun
 2022 04:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9D83A3F704B;
        Wed,  8 Jun 2022 04:58:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 08/10] qla2xxx: edif: Reduce N2N thrashing at app_start time
Date:   Wed, 8 Jun 2022 04:58:47 -0700
Message-ID: <20220608115849.16693-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ALd9rkgYn--milhm39KyR2xD6F5XztpS
X-Proofpoint-GUID: ALd9rkgYn--milhm39KyR2xD6F5XztpS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For n2n + remote wwpn is bigger than local adapter,
remote adapter will login to local adapter while authentication
application is not running. When authentication application do
starts, the current session in FW needs to to be invalidate.
This patch make sure the old session is torn down before
triggering a relogin.

Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 47 ++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 5ada36acf129..9d093b053c32 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -517,11 +517,28 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list)
 			fcport->n2n_link_reset_cnt = 0;
 
-		if (vha->hw->flags.n2n_fw_acc_sec)
-			set_bit(N2N_LINK_RESET, &vha->dpc_flags);
-		else
+		if (vha->hw->flags.n2n_fw_acc_sec) {
+			list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list)
+				qla_edif_sa_ctl_init(vha, fcport);
+
+			/*
+			 * While authentication app was not running, remote device
+			 * could still try to login with this local port.  Let's
+			 * clear the state and try again.
+			 */
+			qla2x00_wait_for_sess_deletion(vha);
+
+			/* bounce the link to get the other guy to relogin */
+			if (!vha->hw->flags.n2n_bigger) {
+				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+			}
+		} else {
+			qla2x00_wait_for_hba_online(vha);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
+			qla2xxx_wake_dpc(vha);
+			qla2x00_wait_for_hba_online(vha);
+		}
 	} else {
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			ql_dbg(ql_dbg_edif, vha, 0x2058,
@@ -920,17 +937,21 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
 				continue;
 
-			if (fcport->scan_state != QLA_FCPORT_FOUND)
-				continue;
+			if (!N2N_TOPO(vha->hw)) {
+				if (fcport->scan_state != QLA_FCPORT_FOUND)
+					continue;
 
-			if (fcport->port_type == FCT_UNKNOWN && !fcport->fc4_features)
-				rval = qla24xx_async_gffid(vha, fcport, true);
+				if (fcport->port_type == FCT_UNKNOWN &&
+				    !fcport->fc4_features)
+					rval = qla24xx_async_gffid(vha, fcport,
+								   true);
 
-			if (!rval &&
-			    !(fcport->fc4_features & FC4_FF_TARGET ||
-			      fcport->port_type &
-			      (FCT_TARGET | FCT_NVME_TARGET)))
-				continue;
+				if (!rval &&
+				    !(fcport->fc4_features & FC4_FF_TARGET ||
+				      fcport->port_type &
+				      (FCT_TARGET | FCT_NVME_TARGET)))
+					continue;
+			}
 
 			rval = 0;
 
-- 
2.19.0.rc0

