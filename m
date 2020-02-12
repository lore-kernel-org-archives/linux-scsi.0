Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD47C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2EF221734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="mvynUhbM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgBLVrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:32 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6128 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLexG7001688;
        Wed, 12 Feb 2020 13:45:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=GAOvzyhkeBV2epRD9E2252t7dUhs2oiBErlK6AA9Va8=;
 b=mvynUhbME8WdwuuOxP78KlUgGrWdgPUwSDNGA/zwKEBX/zZK7/xjh9Fs3/X38qZNAftI
 4IYF1d+CZWhE4Y4I5gHaQ/kRVukpe95WPlfIGl/AdyHpkQEnhX6gW4IPIvlVR/Uq6lc5
 3o7kE8Mh6HTdfjsAGtjbfON2Pq163q2Fn6Kl7gNyO9HAwD0RlYsxBaWoiHyzBsZktgsg
 sJnTzr/QFCP/ELmz0k6wkddmPn0Z6O1G/SxaB8xQ5Ip4BaDVg6dkG5aTCty+RX7O0XuP
 CiEiI+wuFJztlV7tYAzBkc4rhJg+VJZ6cmEpc0zSBW0vYilj/TC1n9ss9b3C7MObpdhv YA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt50p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:29 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:28 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:28 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 425573F703F;
        Wed, 12 Feb 2020 13:45:28 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjSZg025644;
        Wed, 12 Feb 2020 13:45:28 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjSR0025643;
        Wed, 12 Feb 2020 13:45:28 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 17/25] qla2xxx: Correction to selection of loopback/echo test
Date:   Wed, 12 Feb 2020 13:44:28 -0800
Message-ID: <20200212214436.25532-18-hmadhani@marvell.com>
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

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This Fixes loopback and echo test options

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5870d26ab707..34fa200900fc 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -728,7 +728,7 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 	uint16_t response[MAILBOX_REGISTER_COUNT];
 	uint16_t config[4], new_config[4];
 	uint8_t *fw_sts_ptr;
-	uint8_t *req_data = NULL;
+	void *req_data = NULL;
 	dma_addr_t req_data_dma;
 	uint32_t req_data_len;
 	uint8_t *rsp_data = NULL;
@@ -806,10 +806,11 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 	    bsg_request->rqst_data.h_vendor.vendor_cmd[2];
 
 	if (atomic_read(&vha->loop_state) == LOOP_READY &&
-	    (ha->current_topology == ISP_CFG_F ||
-	    (get_unaligned_le32(req_data) == ELS_OPCODE_BYTE &&
-	     req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
-	    elreq.options == EXTERNAL_LOOPBACK) {
+	    ((ha->current_topology == ISP_CFG_F && (elreq.options & 7) >= 2) ||
+	    ((IS_QLA81XX(ha) || IS_QLA8031(ha) || IS_QLA8044(ha)) &&
+	    get_unaligned_le32(req_data) == ELS_OPCODE_BYTE &&
+	    req_data_len == MAX_ELS_FRAME_PAYLOAD &&
+	    elreq.options == EXTERNAL_LOOPBACK))) {
 		type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
 		ql_dbg(ql_dbg_user, vha, 0x701e,
 		    "BSG request type: %s.\n", type);
-- 
2.12.0

