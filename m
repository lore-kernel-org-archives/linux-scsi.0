Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB754C4BA2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A7324670
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LtNJFPA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgBZWks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48208 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727887AbgBZWks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMePCM006141;
        Wed, 26 Feb 2020 14:40:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=GcmbzCmNhMg+kJgwQIoRavOFsjAltyv7IUEJJ8MzXeQ=;
 b=LtNJFPA9VC+9hQauYVwZBkarjnhvaIfIpKkiYhh9ImGRGesfTqtV+RQ+yoDdjAmoJFh+
 Ukf5RQj6xcURGyX3HvZ8Ml4vFrYwxES5Yqik33HhXL+wWXRigI0PHXNq53DkEOIvZ61R
 nutUHNiVmNbz90ihyoPvfRy9Jc9sPCtRlOS3/mlyVzEtKm10OGpeZATU3Le5M7xdx1rI
 wU7916GkLJE2+y/e183G0kUtf5hZ82BdgF9GqUFek8smS4PRtWaj1y3m/fplVDRM9tWi
 oVrHh3+EiIurtz7jFX9tZtrHO7CjZKwT+G18/LUAu6GgRIBSWztbPI/YMIVA8wzyh2EU oQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:43 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:42 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:42 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8CE973F703F;
        Wed, 26 Feb 2020 14:40:42 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMeg6J024577;
        Wed, 26 Feb 2020 14:40:42 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMegND024576;
        Wed, 26 Feb 2020 14:40:42 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 06/18] qla2xxx: Return appropriate failure through BSG Interface
Date:   Wed, 26 Feb 2020 14:40:10 -0800
Message-ID: <20200226224022.24518-7-hmadhani@marvell.com>
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

From: Michael Hernandez <mhernandez@marvell.com>

This patch ensures Flash updates API calls return possible
failure status through BSG interface to the application.

Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |  9 +++++++--
 drivers/scsi/qla2xxx/qla_sup.c | 13 ++++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 714bcf5e6e53..97b51c477972 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1517,10 +1517,15 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	    bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
 	    ha->optrom_region_size);
 
-	ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
+	rval = ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 	    ha->optrom_region_start, ha->optrom_region_size);
 
-	bsg_reply->result = DID_OK;
+	if (rval) {
+		bsg_reply->result = -EINVAL;
+		rval = -EINVAL;
+	} else {
+		bsg_reply->result = DID_OK;
+	}
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 76a38bf86cbc..3da79ee1d88e 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2683,7 +2683,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	uint32_t sec_mask, rest_addr, fdata;
 	void *optrom = NULL;
 	dma_addr_t optrom_dma;
-	int rval;
+	int rval, ret;
 	struct secure_flash_update_block *sfub;
 	dma_addr_t sfub_dma;
 	uint32_t offset = faddr << 2;
@@ -2939,11 +2939,12 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 write_protect:
 	ql_log(ql_log_warn + ql_dbg_verbose, vha, 0x7095,
 	    "Protect flash...\n");
-	rval = qla24xx_protect_flash(vha);
-	if (rval) {
+	ret = qla24xx_protect_flash(vha);
+	if (ret) {
 		qla81xx_fac_semaphore_access(vha, FAC_SEMAPHORE_UNLOCK);
 		ql_log(ql_log_warn, vha, 0x7099,
 		    "Failed protect flash\n");
+		rval = QLA_COMMAND_ERROR;
 	}
 
 	if (reset_to_rom == true) {
@@ -2951,10 +2952,12 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
 
-		rval = qla2x00_wait_for_hba_online(vha);
-		if (rval != QLA_SUCCESS)
+		ret = qla2x00_wait_for_hba_online(vha);
+		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0xffff,
 			    "Adapter did not come out of reset\n");
+			rval = QLA_COMMAND_ERROR;
+		}
 	}
 
 done:
-- 
2.12.0

