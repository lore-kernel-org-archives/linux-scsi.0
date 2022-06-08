Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BC8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbiFHL7B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbiFHL67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:58:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652A5173299
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:58:58 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2587SoaB013216
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:58:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1bZp9klZ9wDlqUQTWTD9JYyD+1lN7jO8UR5aSjTr0fY=;
 b=TZ97gaddnN1rA0cWQtjMoKVPMDXV5OVRoqat8AU5/ifn6niVRY89HUkLGDhQ8SxjfAPk
 grjP1BdnZz51Hg1I7m/zZKWYS18yE26NZ9uIMumq3B92F/Vzx6MwnlUp01fD36JmWV0W
 fD5diKU/e2qqM3OJXH+CZHAj/ueM4k+VqxcD7cAytNtFzaJDrHnyFNg7uhAgPHSMPzPo
 vZstwC8//6TUh2U6a6XA0ZXR4q43l7tnVNL4TWYopXf34KxVdGcdjO65UQwzmkaBZZiq
 NKXzEJ+A3LdlY59tRhgT2q89DB/hXEAhAVBOOPUfXAMjIr6HH2q3TSknaYShN53fHn+Q rg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gjqdps05t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:58:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jun
 2022 04:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3F6613F708A;
        Wed,  8 Jun 2022 04:58:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 05/10] qla2xxx: edif: tear down session if keys has been removed
Date:   Wed, 8 Jun 2022 04:58:44 -0700
Message-ID: <20220608115849.16693-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ptx6pkj7Y2IEYErWq0YdCXgi1z0z_TEr
X-Proofpoint-GUID: ptx6pkj7Y2IEYErWq0YdCXgi1z0z_TEr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

If all keys for a session has been deleted then
trigger a session tear down.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 5 +++++
 drivers/scsi/qla2xxx/qla_isr.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3e78bafa4011..f064dcdbb975 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2158,6 +2158,11 @@ typedef struct {
 #define CS_IOCB_ERROR		0x31	/* Generic error for IOCB request
 					   failure */
 #define CS_REJECT_RECEIVED	0x4E	/* Reject received */
+#define CS_EDIF_AUTH_ERROR	0x63	/* decrypt error */
+#define CS_EDIF_PAD_LEN_ERROR	0x65	/* pad > frame size, not 4byte align */
+#define CS_EDIF_INV_REQ		0x66	/* invalid request */
+#define CS_EDIF_SPI_ERROR	0x67	/* rx frame unable to locate sa */
+#define CS_EDIF_HDR_ERROR	0x69	/* data frame != expected len */
 #define CS_BAD_PAYLOAD		0x80	/* Driver defined */
 #define CS_UNKNOWN		0x81	/* Driver defined */
 #define CS_RETRY		0x82	/* Driver defined */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 21b31d6359c8..8e6831953e7c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3426,6 +3426,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	case CS_PORT_UNAVAILABLE:
 	case CS_TIMEOUT:
 	case CS_RESET:
+	case CS_EDIF_INV_REQ:
 
 		/*
 		 * We are going to have the fc class block the rport
-- 
2.19.0.rc0

