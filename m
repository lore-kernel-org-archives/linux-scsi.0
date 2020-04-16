Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9464DC2D0EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 762B420784
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="hs9w0Amv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503419AbgDPJER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 05:04:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50872 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502536AbgDPIos (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 04:44:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8e7dH020366;
        Thu, 16 Apr 2020 01:43:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=PDQAKmv2brTdTZRLKJMNmsauJBAFXBZ3lx7TNn1516k=;
 b=hs9w0Amvoidcli1dkH7zRtpYoYL2NAFXLUDIT6R5MHVZwllj6QPoEcH2vOXSKeoG6DEE
 f6B19yHB2+EAYrmqR/8lrcOC0x1dzRGEp33t2l3xenlX2QOQpiTLxTIPrOmbLw7jd8Yx
 QuZ4nrYXZdv0sg1HXsQC3QTGAn5hcqD2zzv0fqNiKxlBC9bxrD1cl3HyFN+lLh8KDJZk
 RTsik9f5VG3rEXrbMyclS34kW4AWQ55X4HzB44e/PQAmvEOrWQh9axDSja6PSM4x7zgk
 8ySSzU0wJ3Quh6Ey9kYtAlg5UFi3TkUWMb4dxbfsNPSMw+ufNN0e+wnUij48iScmS+qK 8A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30dn84p7qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:30 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 548703F703F;
        Thu, 16 Apr 2020 01:43:30 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hUu2018906;
        Thu, 16 Apr 2020 01:43:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hUS8018905;
        Thu, 16 Apr 2020 01:43:30 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 5/9] qed: Send BW update notifications to the protocol drivers.
Date:   Thu, 16 Apr 2020 01:43:10 -0700
Message-ID: <20200416084314.18851-6-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200416084314.18851-1-skashyap@marvell.com>
References: <20200416084314.18851-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_03:2020-04-14,2020-04-16 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

Management firmware (MFW) send a notification whenever there is a change in
the bandwidth values. The patch adds driver support to send this info to
the upper layer drivers (e.g., qedf).

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      | 1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c | 9 +++++++++
 include/linux/qed/qed_if.h                 | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index fa41bf0..d006639 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -1016,6 +1016,7 @@ void qed_set_fw_mac_addr(__le16 *fw_msb,
 int qed_fill_dev_info(struct qed_dev *cdev,
 		      struct qed_dev_info *dev_info);
 void qed_link_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt);
+void qed_bw_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt);
 u32 qed_unzip_data(struct qed_hwfn *p_hwfn,
 		   u32 input_len, u8 *input_buf,
 		   u32 max_size, u8 *unzip_buf);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2c189c6..8d82d65 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1949,6 +1949,15 @@ void qed_link_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt)
 		op->link_update(cookie, &if_link);
 }
 
+void qed_bw_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt)
+{
+	void *cookie = hwfn->cdev->ops_cookie;
+	struct qed_common_cb_ops *op = hwfn->cdev->protocol_ops.common;
+
+	if (IS_LEAD_HWFN(hwfn) && cookie && op && op->bw_update)
+		op->bw_update(cookie);
+}
+
 static int qed_drain(struct qed_dev *cdev)
 {
 	struct qed_hwfn *hwfn;
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 8f29e0d..c495637 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -817,6 +817,7 @@ struct qed_common_cb_ops {
 	void	(*dcbx_aen)(void *dev, struct qed_dcbx_get *get, u32 mib_type);
 	void (*get_generic_tlv_data)(void *dev, struct qed_generic_tlvs *data);
 	void (*get_protocol_tlv_data)(void *dev, void *data);
+	void (*bw_update)(void *dev);
 };
 
 struct qed_selftest_ops {
-- 
1.8.3.1

