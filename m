Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7A6C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF9862065D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JXuI8R1+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgHRMej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:34:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25494 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726688AbgHRMec (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:34:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICVcZ5026230
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:34:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=VL2A49UFRVNsv+wQt/xYa7TVkN91/ig3tPIRLKkcObg=;
 b=JXuI8R1+UI0oc3+rUMJYSohtDBYCw9jM+qy552FJPtW+az20DBqjANxsMt94zFS4m8T+
 WT9MRhdT6QazWRSD2U3yYLNU+tvJ6S3XvGY0Po/kAUU6aXDM4WiIPJ2Ptaf1UD+VU5J8
 /6MErZwScDm5XyDaiYJS/JCUpR+nYs4kQsaxxk3UnghOtNEwGWBUDZ/xl+Ne2CLE88mI
 02b4b3NWFkKEqhHnZSusw6K9OU8EnIe9BkZRM/5QtJr7TM0x25Pwd7Dp5WK5LKeT8DI7
 xOI3Xe+DhXRQLb7zty6dS7ICjOmY6K855tfVEqXnr3OY4r8oHybETSUW07Ws8g0XPGJk uQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhjcnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:34:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:34:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:34:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EEEE53F7043;
        Tue, 18 Aug 2020 05:34:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICYRJr020434;
        Tue, 18 Aug 2020 05:34:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICYRrQ020432;
        Tue, 18 Aug 2020 05:34:27 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 05/12] qla2xxx: Reduce duplicate code in reporting speed
Date:   Tue, 18 Aug 2020 05:31:56 -0700
Message-ID: <20200818123203.20361-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200818123203.20361-1-njavali@marvell.com>
References: <20200818123203.20361-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Indicate correct speed for 16G Mezz card.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 41 +-------------
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 +
 drivers/scsi/qla2xxx/qla_gs.c   |  7 +--
 drivers/scsi/qla2xxx/qla_os.c   | 96 +--------------------------------
 4 files changed, 9 insertions(+), 137 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5d93ccc73153..d006ae193677 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3214,46 +3214,7 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
-	if (IS_CNA_CAPABLE(ha))
-		speeds = FC_PORTSPEED_10GBIT;
-	else if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
-		if (ha->max_supported_speed == 2) {
-			if (ha->min_supported_speed <= 6)
-				speeds |= FC_PORTSPEED_64GBIT;
-		}
-		if (ha->max_supported_speed == 2 ||
-		    ha->max_supported_speed == 1) {
-			if (ha->min_supported_speed <= 5)
-				speeds |= FC_PORTSPEED_32GBIT;
-		}
-		if (ha->max_supported_speed == 2 ||
-		    ha->max_supported_speed == 1 ||
-		    ha->max_supported_speed == 0) {
-			if (ha->min_supported_speed <= 4)
-				speeds |= FC_PORTSPEED_16GBIT;
-		}
-		if (ha->max_supported_speed == 1 ||
-		    ha->max_supported_speed == 0) {
-			if (ha->min_supported_speed <= 3)
-				speeds |= FC_PORTSPEED_8GBIT;
-		}
-		if (ha->max_supported_speed == 0) {
-			if (ha->min_supported_speed <= 2)
-				speeds |= FC_PORTSPEED_4GBIT;
-		}
-	} else if (IS_QLA2031(ha))
-		speeds = FC_PORTSPEED_16GBIT|FC_PORTSPEED_8GBIT|
-			FC_PORTSPEED_4GBIT;
-	else if (IS_QLA25XX(ha) || IS_QLAFX00(ha))
-		speeds = FC_PORTSPEED_8GBIT|FC_PORTSPEED_4GBIT|
-			FC_PORTSPEED_2GBIT|FC_PORTSPEED_1GBIT;
-	else if (IS_QLA24XX_TYPE(ha))
-		speeds = FC_PORTSPEED_4GBIT|FC_PORTSPEED_2GBIT|
-			FC_PORTSPEED_1GBIT;
-	else if (IS_QLA23XX(ha))
-		speeds = FC_PORTSPEED_2GBIT|FC_PORTSPEED_1GBIT;
-	else
-		speeds = FC_PORTSPEED_1GBIT;
+	speeds = qla25xx_fdmi_port_speed_capability(ha);
 
 	fc_host_supported_speeds(vha->host) = speeds;
 }
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 36c210c24f72..3360857c4405 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -704,6 +704,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *, fc_port_t *);
 void qla24xx_handle_gfpnid_event(scsi_qla_host_t *, struct event_arg *);
 void qla24xx_sp_unmap(scsi_qla_host_t *, srb_t *);
 void qla_scan_work_fn(struct work_struct *);
+uint qla25xx_fdmi_port_speed_capability(struct qla_hw_data *);
+uint qla25xx_fdmi_port_speed_currently(struct qla_hw_data *);
 
 /*
  * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index de9fd7f688d0..700d4247a791 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1502,7 +1502,7 @@ qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, uint16_t cmd,
 	return &p->p.req;
 }
 
-static uint
+uint
 qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 {
 	uint speeds = 0;
@@ -1546,7 +1546,7 @@ qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 		}
 		return speeds;
 	}
-	if (IS_QLA25XX(ha))
+	if (IS_QLA25XX(ha) || IS_QLAFX00(ha))
 		return FDMI_PORT_SPEED_8GB|FDMI_PORT_SPEED_4GB|
 			FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
 	if (IS_QLA24XX_TYPE(ha))
@@ -1556,7 +1556,8 @@ qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 		return FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
 	return FDMI_PORT_SPEED_1GB;
 }
-static uint
+
+uint
 qla25xx_fdmi_port_speed_currently(struct qla_hw_data *ha)
 {
 	switch (ha->link_data_rate) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8da00ba54aec..f10a43ac1ec7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5810,98 +5810,6 @@ qla25xx_rdp_rsp_reduce_size(struct scsi_qla_host *vha,
 	return true;
 }
 
-static uint
-qla25xx_rdp_port_speed_capability(struct qla_hw_data *ha)
-{
-	if (IS_CNA_CAPABLE(ha))
-		return RDP_PORT_SPEED_10GB;
-
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-		unsigned int speeds = 0;
-
-		if (ha->max_supported_speed == 2) {
-			if (ha->min_supported_speed <= 6)
-				speeds |= RDP_PORT_SPEED_64GB;
-		}
-
-		if (ha->max_supported_speed == 2 ||
-		    ha->max_supported_speed == 1) {
-			if (ha->min_supported_speed <= 5)
-				speeds |= RDP_PORT_SPEED_32GB;
-		}
-
-		if (ha->max_supported_speed == 2 ||
-		    ha->max_supported_speed == 1 ||
-		    ha->max_supported_speed == 0) {
-			if (ha->min_supported_speed <= 4)
-				speeds |= RDP_PORT_SPEED_16GB;
-		}
-
-		if (ha->max_supported_speed == 1 ||
-		    ha->max_supported_speed == 0) {
-			if (ha->min_supported_speed <= 3)
-				speeds |= RDP_PORT_SPEED_8GB;
-		}
-
-		if (ha->max_supported_speed == 0) {
-			if (ha->min_supported_speed <= 2)
-				speeds |= RDP_PORT_SPEED_4GB;
-		}
-
-		return speeds;
-	}
-
-	if (IS_QLA2031(ha))
-		return RDP_PORT_SPEED_16GB|RDP_PORT_SPEED_8GB|
-		       RDP_PORT_SPEED_4GB;
-
-	if (IS_QLA25XX(ha))
-		return RDP_PORT_SPEED_8GB|RDP_PORT_SPEED_4GB|
-		       RDP_PORT_SPEED_2GB|RDP_PORT_SPEED_1GB;
-
-	if (IS_QLA24XX_TYPE(ha))
-		return RDP_PORT_SPEED_4GB|RDP_PORT_SPEED_2GB|
-		       RDP_PORT_SPEED_1GB;
-
-	if (IS_QLA23XX(ha))
-		return RDP_PORT_SPEED_2GB|RDP_PORT_SPEED_1GB;
-
-	return RDP_PORT_SPEED_1GB;
-}
-
-static uint
-qla25xx_rdp_port_speed_currently(struct qla_hw_data *ha)
-{
-	switch (ha->link_data_rate) {
-	case PORT_SPEED_1GB:
-		return RDP_PORT_SPEED_1GB;
-
-	case PORT_SPEED_2GB:
-		return RDP_PORT_SPEED_2GB;
-
-	case PORT_SPEED_4GB:
-		return RDP_PORT_SPEED_4GB;
-
-	case PORT_SPEED_8GB:
-		return RDP_PORT_SPEED_8GB;
-
-	case PORT_SPEED_10GB:
-		return RDP_PORT_SPEED_10GB;
-
-	case PORT_SPEED_16GB:
-		return RDP_PORT_SPEED_16GB;
-
-	case PORT_SPEED_32GB:
-		return RDP_PORT_SPEED_32GB;
-
-	case PORT_SPEED_64GB:
-		return RDP_PORT_SPEED_64GB;
-
-	default:
-		return RDP_PORT_SPEED_UNKNOWN;
-	}
-}
-
 /*
  * Function Name: qla24xx_process_purex_iocb
  *
@@ -6068,9 +5976,9 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	rsp_payload->port_speed_desc.desc_len =
 	    cpu_to_be32(RDP_DESC_LEN(rsp_payload->port_speed_desc));
 	rsp_payload->port_speed_desc.speed_capab = cpu_to_be16(
-	    qla25xx_rdp_port_speed_capability(ha));
+	    qla25xx_fdmi_port_speed_capability(ha));
 	rsp_payload->port_speed_desc.operating_speed = cpu_to_be16(
-	    qla25xx_rdp_port_speed_currently(ha));
+	    qla25xx_fdmi_port_speed_currently(ha));
 
 	/* Link Error Status Descriptor */
 	rsp_payload->ls_err_desc.desc_tag = cpu_to_be32(0x10002);
-- 
2.19.0.rc0

