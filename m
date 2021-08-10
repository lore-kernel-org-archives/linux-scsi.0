Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571C7C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D0BE60E76
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhHJEiz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:38:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10020 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236408AbhHJEis (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:38:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aOZI008580
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:38:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=d5AlEyT4jLKqNDLPRCifGZvP9kIW9Qj1PsOQhaPQtJw=;
 b=WauL2b7WIZl/grzVwvtHZu3SP24lRJkOvLqLbn0Vvhx9Sj5f4ypJs7LXQ/mPo1+sdw2e
 Hm3pHcQSuScCj1qfpCejqRClEyXFEeN9aw0H/U8ycEj/c2YqdZUUIKDLqYPHXX7GS1QO
 +gYcWR8j/Pnhnzzp+lR2jwSBnFS1K0WZc3HJSKBG4rw28PTS5AxjBso8Km8IPDsqYOD1
 SxinjdlpHSipzxYltY/l+Ysdz2onrXNRV3J3m6jiuf7XbImCXWT/wft8hHUlmmJAahr2
 TySpd8MjVbQQARKFODN4cEpD3w8Ip2H8LdkJoN52I8Pgp3XptU9Iap276/ofOUvz3NHF ig== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:38:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:38:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:38:24 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 01AB93F7044;
        Mon,  9 Aug 2021 21:38:24 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4cOk7001192;
        Mon, 9 Aug 2021 21:38:24 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4cOmi001191;
        Mon, 9 Aug 2021 21:38:24 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 03/14] qla2xxx: adjust request/response queue size for 28xx
Date:   Mon, 9 Aug 2021 21:37:09 -0700
Message-ID: <20210810043720.1137-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tMpfrW4IX-t3rUZaGin9Lj9z_Inp4u3p
X-Proofpoint-GUID: tMpfrW4IX-t3rUZaGin9Lj9z_Inp4u3p
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

adjust request/respond queue size for 28xx to match 27xx adapter.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 53e9eea031bd..921bd4d127f4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3065,8 +3065,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->portnum = PCI_FUNC(ha->pdev->devfn);
 		ha->max_fibre_devices = MAX_FIBRE_DEVICES_2400;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		req_length = REQUEST_ENTRY_CNT_24XX;
-		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		req_length = REQUEST_ENTRY_CNT_83XX;
+		rsp_length = RESPONSE_ENTRY_CNT_83XX;
 		ha->tgt.atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
-- 
2.19.0.rc0

