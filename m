Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB74FC4BA2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9189224672
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QNGlsjuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgBZWke (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:34 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727761AbgBZWke (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:34 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMVTvN003762;
        Wed, 26 Feb 2020 14:40:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=zHT9MlE4csytjRlR7o92ARUjNY7LmEJ3BHjO4KD0/go=;
 b=QNGlsjuAMFyDMe0gfvY7Vk5sTAMmuUIZU+JGdHh7vxsNZBriaOyPZ3y8A4/fMIV1c58C
 Ke0PREjfhaFzmdnsMeGbX5x1/c9VH8+E7kSv9nA0ZYaMtH6O5BK9/3rd7iahaJR6iFNU
 dAaB9L+q6Fy/13Kbc7FAdpTYMwjJeg/i7/X3rMSC9qFLPw30kXIQfRLsFL7tNCpPkihV
 J6905ZhBTaOzGpMgGPRJa1ON+OdpEVXJB9P5c0ogOuGY4gL1FX1pTlic6ZDCws0CySL9
 OX6cdYFUP+lO59S4bTFbtZdsZjjni9VpE5qw1BIieG5yp8tKR1YkN4NZPxt8128+eNS3 Zg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ydcm15b72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:32 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:30 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:29 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:29 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B9E333F703F;
        Wed, 26 Feb 2020 14:40:29 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMeTXs024561;
        Wed, 26 Feb 2020 14:40:29 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMeTLc024560;
        Wed, 26 Feb 2020 14:40:29 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 02/18] qla2xxx: Avoid setting firmware options twice in 24xx_update_fw_options.
Date:   Wed, 26 Feb 2020 14:40:06 -0800
Message-ID: <20200226224022.24518-3-hmadhani@marvell.com>
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

From: Giridhar Malavali <gmalavali@marvell.com>

This patch moves ql2xrdpenable check earlier to avoids setting fw_option
once again before exiting qla24xx_update_fw_options.

Signed-off-by: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1ec93e28560e..111a97a69489 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3929,6 +3929,9 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 			ha->fw_options[2] &= ~BIT_8;
 	}
 
+	if (ql2xrdpenable)
+		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
+
 	ql_dbg(ql_dbg_init, vha, 0x00e8,
 	    "%s, add FW options 1-3 = 0x%04x 0x%04x 0x%04x mode %x\n",
 	    __func__, ha->fw_options[1], ha->fw_options[2],
@@ -3939,7 +3942,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 
 	/* Update Serial Link options. */
 	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
-		goto enable_purex;
+		return;
 
 	rval = qla2x00_set_serdes_params(vha,
 	    le16_to_cpu(ha->fw_seriallink_options24[1]),
@@ -3949,12 +3952,6 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 		ql_log(ql_log_warn, vha, 0x0104,
 		    "Unable to update Serial Link options (%x).\n", rval);
 	}
-
-enable_purex:
-	if (ql2xrdpenable)
-		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
-
-	qla2x00_set_fw_options(vha, ha->fw_options);
 }
 
 void
-- 
2.12.0

