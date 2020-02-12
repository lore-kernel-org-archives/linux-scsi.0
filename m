Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314F9C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A04206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="P6mStRwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgBLVrI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14288 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729071AbgBLVrI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLexG0001688;
        Wed, 12 Feb 2020 13:45:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=GMgflBVTXXteau5+sd+tg1dVT8iadb/Q+ZIuTlcwnnE=;
 b=P6mStRwbHtAX8Xvm6YcLF7Zn8mxHUVLBK/XaLD/kE6MsV+6+fv6lyenFHZ9sc+iu7dkt
 1Isw43MExhSleMw8x1aMYJEhwn0KgF2sdZgHNlamn/sCHi8nhCrUe8tUOzu3vHgB+zdE
 wEfSLb9/2o1Bt4RDwuHbVCRoRmK9PGgJMgTPm1D3eoEdRFOanHXbywXzW2B0ITNLgNsC
 khnDxP0lkGXmyYkQtih4qvZQWxGf+RoI1RZlt3sy1LAogZZH7djc94fJQhhnSAlqN2YO
 5uqB0LOStFoZ7PVMQWKoZkT53cWHaG6S3zGG1zbFUAtY1Cif7x00wOpca/eb7a4SWicL RA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:07 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:05 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:05 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8BEB53F7040;
        Wed, 12 Feb 2020 13:45:05 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLj51e025616;
        Wed, 12 Feb 2020 13:45:05 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLj5uS025615;
        Wed, 12 Feb 2020 13:45:05 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 10/25] qla2xxx: Display message for FCE enabled
Date:   Wed, 12 Feb 2020 13:44:21 -0800
Message-ID: <20200212214436.25532-11-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During Link up phase and Data rate MBX command response,
print message indicating FCE is enabled.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 ++++++
 drivers/scsi/qla2xxx/qla_mbx.c | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f0a4245f892c..a274872ff15d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -820,6 +820,12 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    "LOOP UP detected (%s Gbps).\n",
 		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
 
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			if (mb[2] & BIT_0)
+				ql_log(ql_log_info, vha, 0x11a0,
+				    "FEC=enabled (link up).\n");
+		}
+
 		vha->flags.management_server_logged_in = 0;
 		qla2x00_post_aen_work(vha, FCH_EVT_LINKUP, ha->link_data_rate);
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2e531e289eb0..9d73ae165a98 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5554,6 +5554,15 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1107,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
+		if (mcp->mb[1] != 0x7)
+			ha->link_data_rate = mcp->mb[1];
+
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			if (mcp->mb[4] & BIT_0)
+				ql_log(ql_log_info, vha, 0x11a2,
+				    "FEC=enabled (data rate).\n");
+		}
+
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
 		if (mcp->mb[1] != 0x7)
-- 
2.12.0

