Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1AAC3DA7A
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 11:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiLSLIM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiLSLIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 06:08:01 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7FB389B
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ9Q1ph010480
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rAUfwy/AHwK8qd9UGR5QKXDfsg5FGl1pvuGb6VGC/xA=;
 b=aP1zKU+dF+lj8jDxYtzJ6tY4de87mBbvwOk5XH7yz3BBse1GkN/3T4GtgpJSCh0BPF0u
 RyZydSk3Rv8vgWRCM1QVs2exS84sjmVn2dapGwIpZQv6Q2pjBV73wQIGUaczt0efvtET
 bQef7ivNcAUiISJ6LW0+6lD+EyeFm5/Zzz7T4gJsMWkhSMb7lf+HnG4hJVYADD/gUNkT
 2TqLn5BDrI/ymbSiRi7iL27FxCW81SPEMp+W8mBECrsSxNya+oUYcA1OO1P5gUkTT3T6
 cTxnSpqjNuS/lO5HBf1TODzcsL6szl82SpoY+AOOMG9wUMrSfEPK7TYU2cpALzfrhCIf IQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mjnanrb8v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 19 Dec
 2022 03:07:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 19 Dec 2022 03:07:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A92953F706F;
        Mon, 19 Dec 2022 03:07:57 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 06/11] qla2xxx: Fix stalled login
Date:   Mon, 19 Dec 2022 03:07:43 -0800
Message-ID: <20221219110748.7039-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com>
References: <20221219110748.7039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Ge_P6JGTPJpHiK7v59C1GiAaWp-5Ymef
X-Proofpoint-ORIG-GUID: Ge_P6JGTPJpHiK7v59C1GiAaWp-5Ymef
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

If a login failed due to low FW resource, the session can stall
from being connected. Reset session state to allow relogin
logic to re-drive the connection.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index fd27fb511479..745fee298d56 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -390,6 +390,12 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
+
+	/*
+	 * async login failed. Could be due to iocb/exchange resource
+	 * being low. Set state DELETED for re-login process to start again.
+	 */
+	qla2x00_set_fcport_disc_state(fcport, DSC_DELETED);
 	return rval;
 }
 
-- 
2.19.0.rc0

