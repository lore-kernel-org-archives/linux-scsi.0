Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1EEC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbiFHL7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbiFHL7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:59:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B587E24CC9B
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:59:10 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2581X4Ng020925
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:59:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EUExEiSrXoOlxttfATpTHGO+2HXCPu0cQFdorB88cts=;
 b=BLcbFRc1ekrS8N6PIpSiHobslzQDaqv0ggWp7W1OYigDmmVJXzjEBE7fOIigZepdbPGR
 7Dtwzv6IQKMKBwN7MAxuFPKVQgdxgLxwhCL1Z5IG3DJVwmUJJIogmp/sO8/jwkO8hqvR
 Pl+6GeSXioKYmz1eiBrIfzJ/V/UXAUCX5K2qxqm7CaXIp4L0KhfjlR6B2LOybYe2WWyr
 +1dhvE3mFLrzFfpnoVpM5u5PxCSHWGQnDCGR0Oalwxbhn47cWgyOekZyr6MEmCXYbx8Y
 rsZVqTmh6LFvqKxjdpQDDg3FtNTZqXbsaZ7UW9QaGYAyRLjUbBMK4Ii9NcK0GoZY6d+f Kw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gjb7pbsag-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:59:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Jun
 2022 04:58:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CC8A73F7087;
        Wed,  8 Jun 2022 04:58:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 02/10] qla2xxx: edif: send logo for unexpected IKE message
Date:   Wed, 8 Jun 2022 04:58:41 -0700
Message-ID: <20220608115849.16693-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: hCZJWl2LO3L5fJO3wDIGF7XqH54s0HPJ
X-Proofpoint-ORIG-GUID: hCZJWl2LO3L5fJO3wDIGF7XqH54s0HPJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

If session is down and local port continue to receive
AUTH ELS messages for the down session, driver need to
send back LOGO so that remote device knows to tear down
its session. This patch terminate/cleanup the AUTH ELS exchange followed
with a pass through LOGO.

Fixes: 225479296c4f ("scsi: qla2xxx: edif: Reject AUTH ELS on session down")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 19 +++++++++++++++++--
 drivers/scsi/qla2xxx/qla_fw.h   |  2 +-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 6a16e16e39f5..d25eb212398e 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2565,8 +2565,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 
 	fcport = qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
 
-	if (DBELL_INACTIVE(vha) ||
-	    (fcport && EDIF_SESSION_DOWN(fcport))) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =%x %06x\n",
 		    __func__, host->e_dbell.db_flags,
 		    fcport ? fcport->d_id.b24 : 0);
@@ -2576,6 +2575,22 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 		return;
 	}
 
+	if (fcport && EDIF_SESSION_DOWN(fcport)) {
+		ql_dbg(ql_dbg_edif, host, 0x13b6,
+		    "%s terminate exchange. Send logo to 0x%x\n",
+		    __func__, a.did.b24);
+
+		a.tx_byte_count = a.tx_len = 0;
+		a.tx_addr = 0;
+		a.control_flags = EPD_RX_XCHG;  /* EPD_RX_XCHG = terminate cmd */
+		qla_els_reject_iocb(host, (*rsp)->qpair, &a);
+		qla_enode_free(host, ptr);
+		/* send logo to let remote port knows to tear down session */
+		fcport->send_els_logo = 1;
+		qlt_schedule_sess_for_deletion(fcport);
+		return;
+	}
+
 	/* add the local enode to the list */
 	qla_enode_add(host, ptr);
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 0bb1d562f0bf..361015b5763e 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -807,7 +807,7 @@ struct els_entry_24xx {
 #define EPD_ELS_COMMAND		(0 << 13)
 #define EPD_ELS_ACC		(1 << 13)
 #define EPD_ELS_RJT		(2 << 13)
-#define EPD_RX_XCHG		(3 << 13)
+#define EPD_RX_XCHG		(3 << 13)  /* terminate exchange */
 #define ECF_CLR_PASSTHRU_PEND	BIT_12
 #define ECF_INCL_FRAME_HDR	BIT_11
 #define ECF_SEC_LOGIN		BIT_3
-- 
2.19.0.rc0

