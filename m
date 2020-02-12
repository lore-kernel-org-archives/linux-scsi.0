Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AF0C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0A9421734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g5WqYUUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgBLVpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:45:45 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728447AbgBLVpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:45:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLejnq001672;
        Wed, 12 Feb 2020 13:45:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=HC2XW18kYlNCpaKZk4fmYesFer5nFonqVSgpeRQcBqk=;
 b=g5WqYUUgeAZVxhGSU+DFA8keNXSjVXXV4LGitmOwc2rPdJ7j4nqWuNO/YiGnAGxACntK
 pYEiqGybwLwSn1ekcSXDwGdUIf0kwY2VcGeGYj8Ix2Z7miTMwZ+gn6+MW7cmmHT+eUwA
 JzZ5vr5nOZYbq7adBrHcdw1j0WcWUcRf5KghTlX+CnM/OG1+SiBoA8VM+1+Hv3RRI4+R
 lyrEcacChF8SDTecRMGVkDYRNKxCnvnYR+Gv0RQrLM4/dYUva6JGBP4khUv15nv83ZdW
 m753txzMGMug76Yf0d0cvduh6eyaFjeAJQXGTU7hoKTzt/EMv9Vqb3q7h4Q9p+9YJLcB 4A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt51g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:39 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:37 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:37 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C54403F7045;
        Wed, 12 Feb 2020 13:45:37 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjbus025656;
        Wed, 12 Feb 2020 13:45:37 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjb52025655;
        Wed, 12 Feb 2020 13:45:37 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 20/25] qla2xxx: Use correct ISP28xx active FW region
Date:   Wed, 12 Feb 2020 13:44:31 -0800
Message-ID: <20200212214436.25532-21-hmadhani@marvell.com>
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

From: Quinn Tran <qutran@marvell.com>

For ISP28xx, use 28xx call to retrieve active FW region.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 34fa200900fc..714bcf5e6e53 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2415,7 +2415,7 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 	regions.global_image = active_regions.global;
 
 	if (IS_QLA28XX(ha)) {
-		qla27xx_get_active_image(vha, &active_regions);
+		qla28xx_get_aux_images(vha, &active_regions);
 		regions.board_config = active_regions.aux.board_config;
 		regions.vpd_nvram = active_regions.aux.vpd_nvram;
 		regions.npiv_config_0_1 = active_regions.aux.npiv_config_0_1;
-- 
2.12.0

