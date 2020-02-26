Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85DFC4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88F0020658
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VaoAYO8P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgBZWk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:59 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44476 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgBZWk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:59 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMVUdj003768;
        Wed, 26 Feb 2020 14:40:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=pip/HbFuPBZNR/jzrUQPPK9J9GZ64FHtF0lQakUR8gw=;
 b=VaoAYO8P/Gxdcgl0dnPaUDQ0mtMLnLZ/4wipQCDZflUmYe9fpOnssh50zH/Dl8iPuwRq
 TwLgKf0zTJubOT2xGF1xQCve8oz+CBCgKccQzf6NYRteo5Ng/I3TEDyQce+/cgZcoW6b
 XymjvqKs59eT4GnHXS+T20KVJNny5C0jkPO0mCUN/wET9Hajqj7g7KAqDfDoKNUQC2Er
 t2BcZIGntNulrAL6LEd1BZ2WthMozzgR+OVvTIAID9Y9B/ROUnrr33oFAf+h0o9/dVjA
 2gv5zTarMZFGk1rrJzslfb5RlshnA3rIwDQB9E64jK+pQt9qWa4c2R4xSvrblnA5LCRX vQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ydcm15b8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:57 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:56 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:55 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 82C983F7040;
        Wed, 26 Feb 2020 14:40:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMet9L024605;
        Wed, 26 Feb 2020 14:40:55 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMet4I024604;
        Wed, 26 Feb 2020 14:40:55 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 11/18] qla2xxx: Force semaphore on flash validation failure
Date:   Wed, 26 Feb 2020 14:40:15 -0800
Message-ID: <20200226224022.24518-12-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For single port 28XX adapter, the second core can still runs in
the back ground.  The flash semaphore can be held by the non-active
core.  This patch tell MPI FW to check for this case and clear the
semaphore from the non-active core.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 09531b9ab517..ca5eb518927b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -667,10 +667,14 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	u8 semaphore = 0;
+#define EXE_FW_FORCE_SEMAPHORE BIT_7
+	u8 retry = 3;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1025,
 	    "Entered %s.\n", __func__);
 
+again:
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
@@ -712,6 +716,9 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		if (ha->flags.exchoffld_enabled)
 			mcp->mb[4] |= ENABLE_EXCHANGE_OFFLD;
 
+		if (semaphore)
+			mcp->mb[11] |= EXE_FW_FORCE_SEMAPHORE;
+
 		mcp->out_mb |= MBX_4 | MBX_3 | MBX_2 | MBX_1 | MBX_11;
 		mcp->in_mb |= MBX_3 | MBX_2 | MBX_1;
 	} else {
@@ -728,6 +735,15 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
+		if (IS_QLA28XX(ha) && rval == QLA_COMMAND_ERROR &&
+		    mcp->mb[1] == 0x27 && retry) {
+			semaphore = 1;
+			retry--;
+			ql_dbg(ql_dbg_async, vha, 0x1026,
+			    "Exe FW: force semaphore.\n");
+			goto again;
+		}
+
 		ql_dbg(ql_dbg_mbx, vha, 0x1026,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 		return rval;
-- 
2.12.0

