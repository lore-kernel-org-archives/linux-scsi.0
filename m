Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7209DC432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442D8207DD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g+wGXtDN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfLCWhO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 17:37:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51192 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727637AbfLCWhN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 17:37:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB3MZtQn017112;
        Tue, 3 Dec 2019 14:37:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=JyFrHiQN0w+EsMnsKIQ/YqI9YEMpTQ5E6cROe2ofsVU=;
 b=g+wGXtDNYMnWhTBMom4iU6hRM0LzR3UY7ja41uer2lQPtuDjHoAzaAqRoL9kTNA9GPrf
 YGVfk0bSD10gPQ+LPEL1UDCLpDJ0yhl92S25rafNJpDTDq+67cw1efxT3d5Z3s2iS9Jf
 JNu+3HqahVaIEAbVjezOdWG+HgsPIStI6uRTp/QvQT19vDFk2SjrBkEuHE5iqkk+UmG9
 zwX6KLh2ZqzulhawEu9ZSGL08G2sgBGIS2RgiPenLFtfO42DMlEEMlHG0I/mRnnTMUxX
 kevWjNHXGPRrl7Z/AtDBraXVJWA8X6uuvU1KB6zHhsLQtNTCbSeONhMkzt7VAjkp5dxb TQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wkrtsnbd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Dec 2019 14:37:11 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 3 Dec
 2019 14:37:07 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 3 Dec 2019 14:37:07 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3E2773F7041;
        Tue,  3 Dec 2019 14:37:07 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xB3Mb7aU022156;
        Tue, 3 Dec 2019 14:37:07 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xB3Mb781022155;
        Tue, 3 Dec 2019 14:37:07 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/3] qla2xxx: Fix incorrect SFUB length used for Secure Flash Update MB Cmd
Date:   Tue, 3 Dec 2019 14:36:57 -0800
Message-ID: <20191203223657.22109-4-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191203223657.22109-1-hmadhani@marvell.com>
References: <20191203223657.22109-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_07:2019-12-02,2019-12-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Michael Hernandez <mhernandez@marvell.com>

SFUB length should be in DWORDs when passed to FW.

Fixes: 3f006ac342c03 ("scsi: qla2xxx: Secure flash update support for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ae9d7422e78b..bbe90354f49b 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2897,7 +2897,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			    "Sending Secure Flash MB Cmd\n");
 			rval = qla28xx_secure_flash_update(vha, 0, region.code,
 				buf_size_without_sfub, sfub_dma,
-				sizeof(struct secure_flash_update_block));
+				sizeof(struct secure_flash_update_block) >> 2);
 			if (rval != QLA_SUCCESS) {
 				ql_log(ql_log_warn, vha, 0xffff,
 				    "Secure Flash MB Cmd failed %x.", rval);
-- 
2.12.0

