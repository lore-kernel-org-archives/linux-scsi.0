Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955A5C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358615AbiFPFfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358574AbiFPFfP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9425A089
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9tAd014579
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hDmU5He2DAPzikNhgHMT0k2XVoYKYfuu2c1GeoRjI1o=;
 b=hiiluy/D9Yyi1sJjWPz9+ScNyKZX2TRMGMYvmMiQu9jc6vkYsJ/VlJyRDhC6wJDjfDV/
 XKHWPnvsT9OAkyFHE9XPAF6EWjIJb5Jf+dfDzuwg1QRK/2g7Zi/ZbZXCjeY15PAty146
 /HUNqPKlt6otn9XD2d7PoPbKxpND0NIN+mBBA1XGALYVl2a+9V22A0FPg5NptVF3Buqr
 Mf+pYCNWAhSIzFqLrp6Mmeeg0MP39C3vpzIw5ua0Znqq4gxiV/oDgb4LdIa9GhSvxW7K
 RSGbcAhfN56djyEYHKuKlvRT/eVj57n+KIZwKdEwb6BRquvZjIptxTtmZml7TeWkECWd Lg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jun
 2022 22:35:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6C2513F70AE;
        Wed, 15 Jun 2022 22:35:11 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 01/11] qla2xxx: Fix excessive IO error messages by default
Date:   Wed, 15 Jun 2022 22:34:58 -0700
Message-ID: <20220616053508.27186-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OV3Cq1BxBWt-eUVO-_HNdCy7keBJq3YG
X-Proofpoint-GUID: OV3Cq1BxBWt-eUVO-_HNdCy7keBJq3YG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Disable printing IO error messages by default.
The messages will be printed only when logging
was enabled.

Fixes: 8e2d81c6b5be ("scsi: qla2xxx: Fix excessive messages during device logout")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d87c53bc014b..9ca20eafe433 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2645,7 +2645,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	if (unlikely(logit))
-		ql_log(ql_dbg_io, fcport->vha, 0x5060,
+		ql_dbg(ql_dbg_io, fcport->vha, 0x5060,
 		   "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
 		   sp->name, sp->handle, comp_status,
 		   fd->transferred_length, le32_to_cpu(sts->residual_len),
@@ -3503,7 +3503,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 out:
 	if (logit)
-		ql_log(ql_dbg_io, fcport->vha, 0x3022,
+		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
 		       "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
 		       comp_status, scsi_status, res, vha->host_no,
 		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,
-- 
2.19.0.rc0

