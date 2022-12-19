Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E13C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 11:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiLSLIN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiLSLIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 06:08:01 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03148EE35
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:01 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ9Poj5009676
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EVeXlVY7YgKqGDG8gIUnzMZBw431MqiOFxS60EDDh+w=;
 b=g/h+B5fCUi8irhxSsct1F3o3TSrDnSiIv5wNzjM88sabCXGFrotlwlS1VveOpI/lBKJ4
 COs7LMGsEh98nKhyE4rHDWe4ttUoKsWOKSQ0eCzDfEgThSgNuoA403voztbxzxY1rKJU
 7O7OhH2b96obSDa7/aaxCJuyaJiGqfPeFUG8Im22OriWMEyqEUXaaaeKI3Rzb3mZcwit
 bfu+/oOk61Ja2cPkpe07ez91F0DxqpRsWkd78ITNxX7L5mSuKZCdzGDIgqlhYXIyqoNF
 OO1K0aBtY/77Zbg23l9D5G1/khVVQ40RnxuUHvrenqKwDvbJ5cxKQ9S1uuQMQvs2sSGQ IQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mjnanrb8t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 19 Dec
 2022 03:07:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 19 Dec 2022 03:07:58 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DA0503F7050;
        Mon, 19 Dec 2022 03:07:57 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 07/11] qla2xxx: Remove unintended flag clearing
Date:   Mon, 19 Dec 2022 03:07:44 -0800
Message-ID: <20221219110748.7039-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com>
References: <20221219110748.7039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 89qzOsK-o89pUk61KJzGaQvQlekgbc9L
X-Proofpoint-ORIG-GUID: 89qzOsK-o89pUk61KJzGaQvQlekgbc9L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

FCF_ASYNC_SENT flag is used in session management. This flag
is cleared in task management path by accident.
Remove unintended flag clearing.

Fixes: 388a49959ee4 ("scsi: qla2xxx: Fix panic from use after free in qla2x00_async_tm_cmd")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 745fee298d56..6968e8d08968 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2082,7 +2082,6 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 done_free_sp:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
-- 
2.19.0.rc0

