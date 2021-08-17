Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EBBC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C7860FD7
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbhHQFOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26882 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234139AbhHQFOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lb7B006738
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=F+0ijfdKYxj/3Wl2Qbf0GREddfSar2ZYAXZDgzsLm30=;
 b=MugO+A3Oft5ba4lUUuqVFs8m2Dw8H+f8RLUUDPawliKnO8LXkxZ4A51zP7B85a6iJVra
 r8+3zEkSWazsuzfPWuKTLErDNZm501+7c2+6yaGc9Mgu6XDZAwhBoVAcRAzN7++GBVS1
 cRc16GJ3On2rOCaWECSRC+P9UipS9PzQ9jwree5QmyCrfOgVQ5n0XtiP85wEZRXtgE30
 Y3UfkUlE8B22cPG7ySUpMBBxHh7pxBUAsCxaJYz4kCOtMF0JVE/jh0TdlyG/JaT0DGC2
 ZwTpElo0CiuoLE6yXMzl0GAcrsF10uESQkAWC/aUAC0w+2b4pYcUgEISizYGtfJyreKS Og== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D8B663F70A8;
        Mon, 16 Aug 2021 22:13:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5DoHx002520;
        Mon, 16 Aug 2021 22:13:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DlRQ002519;
        Mon, 16 Aug 2021 22:13:47 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 02/12] qla2xxx: edif: reject AUTH ELS on session down
Date:   Mon, 16 Aug 2021 22:13:05 -0700
Message-ID: <20210817051315.2477-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: QWumS9cu_RoQwN_C8BHZdRX0tB_IqoWE
X-Proofpoint-ORIG-GUID: QWumS9cu_RoQwN_C8BHZdRX0tB_IqoWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Reject inflight AUTH ELS if driver is going through session recovery.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 drivers/scsi/qla2xxx/qla_edif.h | 6 ++++++
 drivers/scsi/qla2xxx/qla_os.c   | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 7d16955383dd..555c38bea08a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2376,7 +2376,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	fcport = qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
 
 	if (host->e_dbell.db_flags != EDB_ACTIVE ||
-	    (fcport && fcport->loop_id == FC_NO_LOOP_ID)) {
+	    (fcport && EDIF_SESSION_DOWN(fcport))) {
 		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =%x %06x\n",
 		    __func__, host->e_dbell.db_flags,
 		    fcport ? fcport->d_id.b24 : 0);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 88495df9a3c2..9384765460cf 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -127,4 +127,10 @@ struct enode {
 		struct purexevent	purexinfo;
 	} u;
 };
+
+#define EDIF_SESSION_DOWN(_s) \
+	(_s->disc_state == DSC_DELETE_PEND || \
+	 _s->disc_state == DSC_DELETED || \
+	 !_s->edif.app_sess_online)
+
 #endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5c01b1eaf84e..94e12a398d7f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4345,7 +4345,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		goto fail_elsrej;
 	}
 	ha->elsrej.c->er_cmd = ELS_LS_RJT;
-	ha->elsrej.c->er_reason = ELS_RJT_BUSY;
+	ha->elsrej.c->er_reason = ELS_RJT_LOGIC;
 	ha->elsrej.c->er_explan = ELS_EXPL_UNAB_DATA;
 	return 0;
 
-- 
2.23.1

