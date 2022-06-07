Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A0AC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiFGEqx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiFGEqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01373D4103
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:44 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXd0X025485
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=r1X0tCiQD0ZU3+j/kwWEma0z9i37+7vQC1/FSS/IknY=;
 b=OU6JAu7MB77zEonH42PlvEK5R/SrLjX7r2XaReSug00rSvtqA33EQLgIQKa6CyPen4Ut
 guSp6GfjlVe10I+vyqXQRyGGr+oX61PonUvMMXuuOJIelvlw89tSLpPpLYvdQIC15p/k
 elVl+FDkJFVZJbmXR9DqfqW49T84OBMTysUq2VHa+ER8zWUIW5KPK81iDkeb5TfCrIBi
 +wt7vukHrtDV4A8i0VyKOfqXmk4WGEkLw8vWwZYNcF3ZFPTfrnTZxDy5cC6tp+C+bkNd
 hdoc3srU1kr3jfpja6vg9KlJhtBImMh7dA9EsS9OBQkYHt187zEGK0Fam62DbEA558Tp Aw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8g-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Jun
 2022 21:46:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 42A9B3F7077;
        Mon,  6 Jun 2022 21:46:41 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/11] qla2xxx: edif: Synchronize NPIV deletion with authentication application
Date:   Mon, 6 Jun 2022 21:46:22 -0700
Message-ID: <20220607044627.19563-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 33nwQXywjtLBllBVzTTAwv6Om_3upUty
X-Proofpoint-GUID: 33nwQXywjtLBllBVzTTAwv6Om_3upUty
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Notify authentication application of a NPIV deletion
event is about to occur. This allows app to perform cleanup.

Fixes: 9efea843a906c ("scsi: qla2xxx: edif: Add detection of secure device")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 2 ++
 drivers/scsi/qla2xxx/qla_mid.c      | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 110843b13767..0931f4e4e127 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -253,4 +253,6 @@ struct aen_complete_cmd {
 
 #define RX_DELAY_DELETE_TIMEOUT 20
 
+#define FCH_EVT_VENDOR_UNIQUE_VPORT_DOWN  1
+
 #endif	/* QLA_EDIF_BSG_H */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e6b5c4ccce97..eb43a5f1b399 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -166,9 +166,13 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	int ret = QLA_SUCCESS;
 	fc_port_t *fcport;
 
-	if (vha->hw->flags.edif_enabled)
+	if (vha->hw->flags.edif_enabled) {
+		if (DBELL_ACTIVE(vha))
+			qla2x00_post_aen_work(vha, FCH_EVT_VENDOR_UNIQUE,
+			    FCH_EVT_VENDOR_UNIQUE_VPORT_DOWN);
 		/* delete sessions and flush sa_indexes */
 		qla2x00_wait_for_sess_deletion(vha);
+	}
 
 	if (vha->hw->flags.fw_started)
 		ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
-- 
2.19.0.rc0

