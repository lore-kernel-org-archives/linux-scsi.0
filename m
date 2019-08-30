Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4F2C3A59B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D0023439
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kaea24LE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfH3WYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Aug 2019 18:24:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53660 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbfH3WYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Aug 2019 18:24:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMKEUA001819;
        Fri, 30 Aug 2019 15:24:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=OdsEUw3KV4mT+3xhx9HtNz9lDOE+3br5FRU8dMNo4kQ=;
 b=kaea24LEKOz0kDPb6vlc+R+hTelZWWr3OFa8GizhC4zWjjy0kvKfKUoxPca0ynQC3FoV
 N+BHhtMCazzORmougdFO1aQ9YtIPvZKdkpekwHfGsLzq8D0m2+V2NdPI1uIksMmJ/27/
 VPQjIcBxVPakchCDcsA4q6JtbqGnJh1ze0ZsAodeI9IexcxQJe4Ssg3N1nLbc0thtN4H
 MwXYEORI1T5oKPP3SRcwjfinFGQeJxsURVNLTy2hLeaTgXE1InO696ky1lUK/sYL7dRY
 qa5Ubx4/ErFLpmxLh1JUhkb/V3hAfXKKdyvXFF0rjVdLQSG0FpPKpoPotLGnhXH2harc Eg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uk4rm2daf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:24:11 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 15:24:09 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 15:24:09 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0A0CA3F703F;
        Fri, 30 Aug 2019 15:24:08 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7UMO8hp023731;
        Fri, 30 Aug 2019 15:24:08 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7UMO8N6023730;
        Fri, 30 Aug 2019 15:24:08 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/6] qla2xxx: Fix flash read for Qlogic ISPs
Date:   Fri, 30 Aug 2019 15:23:58 -0700
Message-ID: <20190830222402.23688-3-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830222402.23688-1-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Use adapter specific callback to read flash instead of ISP
adapter specific.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 drivers/scsi/qla2xxx/qla_nx.c   | 1 +
 drivers/scsi/qla2xxx/qla_sup.c  | 8 ++++----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 632130b6165d..8161f08f3a4d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8229,7 +8229,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		    active_regions.aux.vpd_nvram == QLA27XX_PRIMARY_IMAGE ?
 		    "primary" : "secondary");
 	}
-	qla24xx_read_flash_data(vha, ha->vpd, faddr, ha->vpd_size >> 2);
+	ha->isp_ops->read_optrom(vha, ha->vpd, faddr << 2, ha->vpd_size);
 
 	/* Get NVRAM data into cache and calculate checksum. */
 	faddr = ha->flt_region_nvram;
@@ -8241,7 +8241,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	    "Loading %s nvram image.\n",
 	    active_regions.aux.vpd_nvram == QLA27XX_PRIMARY_IMAGE ?
 	    "primary" : "secondary");
-	qla24xx_read_flash_data(vha, ha->nvram, faddr, ha->nvram_size >> 2);
+	ha->isp_ops->read_optrom(vha, ha->nvram, faddr << 2, ha->nvram_size);
 
 	dptr = (uint32_t *)nv;
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++, dptr++)
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 65a675906188..a79f8da38abe 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2288,6 +2288,7 @@ qla82xx_disable_intrs(struct qla_hw_data *ha)
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	qla82xx_mbx_intr_disable(vha);
+
 	spin_lock_irq(&ha->hardware_lock);
 	if (IS_QLA8044(ha))
 		qla8044_wr_reg(ha, LEG_INTR_MASK_OFFSET, 1);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 764e1bb0f695..f2d5115b2d8d 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -682,8 +682,8 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 
 	ha->flt_region_flt = flt_addr;
 	wptr = (uint16_t *)ha->flt;
-	qla24xx_read_flash_data(vha, (void *)flt, flt_addr,
-	    (sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE) >> 2);
+	ha->isp_ops->read_optrom(vha, (void *)flt, flt_addr << 2,
+	    (sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE));
 
 	if (le16_to_cpu(*wptr) == 0xffff)
 		goto no_flash_data;
@@ -950,11 +950,11 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	struct req_que *req = ha->req_q_map[0];
 	uint16_t cnt, chksum;
 	uint16_t *wptr = (void *)req->ring;
-	struct qla_fdt_layout *fdt = (void *)req->ring;
+	struct qla_fdt_layout *fdt = (struct qla_fdt_layout *)req->ring;
 	uint8_t	man_id, flash_id;
 	uint16_t mid = 0, fid = 0;
 
-	qla24xx_read_flash_data(vha, (void *)fdt, ha->flt_region_fdt,
+	ha->isp_ops->read_optrom(vha, fdt, ha->flt_region_fdt << 2,
 	    OPTROM_BURST_DWORDS);
 	if (le16_to_cpu(*wptr) == 0xffff)
 		goto no_flash_data;
-- 
2.12.0

