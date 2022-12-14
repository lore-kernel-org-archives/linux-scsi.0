Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE31CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237294AbiLNEun (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbiLNEu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:50:28 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B0FE090
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:28 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3gC9I020064
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4RsAUxliXCi93/vY3XShMJsis4AxeE+9R6O8EHspDzQ=;
 b=Cr2yGxtsIFBeS8u8xos54pXvNDu7WF9hUABqwGPQ1mnc7oGGDyMp+pF8UMc6O552w7yQ
 f+gY6qXzlXjZl6mgQ5VDldVtg9uLlcSYq2IUO5c/x1KCxUwFTMs6VRFKzHpngfF+JF9p
 ZXZ0ec6Djgh1SqDCYFRnkwH9fOKM3til9b71NEEItYF38K1E/r5RNXuytlljLnqikHq9
 51SwuBBHz4gMQYmEAI9KVjalb72w2wMtx8owuv2AR+vvsKcpSzjF1Jvj3/kRgMQgiTt7
 dBziNLLXfV+K964+/DGPoM1Ml9mb6frzV17cUfHry6/PfFI2O1EEc0uawYWq6HIGW5ko sA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj078c-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:28 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 13 Dec
 2022 20:50:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 13 Dec 2022 20:50:24 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B201B3F7084;
        Tue, 13 Dec 2022 20:50:24 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 06/10] qla2xxx: Fix stalled login
Date:   Tue, 13 Dec 2022 20:50:10 -0800
Message-ID: <20221214045014.19362-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221214045014.19362-1-njavali@marvell.com>
References: <20221214045014.19362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1WRShfGM9LvKHUX9jNPNGdPdTeKZ_kXy
X-Proofpoint-GUID: 1WRShfGM9LvKHUX9jNPNGdPdTeKZ_kXy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

If a login failed due to low FW resource, the session can stall
from being connected. Reset session state to allow relogin
logic to re-drive the connection.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

