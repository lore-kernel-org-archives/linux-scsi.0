Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A1BC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiI0MAM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiI0MAL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 08:00:11 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3396ABF22
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 05:00:09 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28R9Ze3r006358;
        Tue, 27 Sep 2022 05:00:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=iw1wxvJ38bbZ14dLN5hsGpP+P0mrve9BgoNA03Hd/h0=;
 b=UWAYeB4IHvf7ZMp8MjhyBgO+DsOfkFS6fHSnbf5YJual5ofb3IdDClmlBaHS8muyDMfx
 PW4qBgAvXKAfcRSbccNf8yR+gaBbEUEm/kXEl2O0ALG8BhyjdmY1b1i3Gx+vxspzkvfC
 nVPDpOzelZiljudkJARS+srXeSCg5tGe8GG/J1B0J/tHxs4Kyq9x75YOb5L+dxNJdSxp
 GyDPsQ0EfB163qCpCUQBpwMIeDvhRa3o8zvfppZwKzA6jUxeg4piUu7izXtaY4Jg1T91
 zonYr9PdSyvM3dSbDWnPWDdtN/FwKXd1PZh2gaPFmv+nQ0TdGi0RD8dEk+0jYqUjZpjE fA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jt1dp9pgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 05:00:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Sep
 2022 05:00:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Sep 2022 05:00:05 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B75FA5E6865;
        Tue, 27 Sep 2022 05:00:02 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>
Subject: [PATCH] qla2xxx: Use transport defined speed mask for supported_speeds
Date:   Tue, 27 Sep 2022 04:59:46 -0700
Message-ID: <20220927115946.17559-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QMgDufM7j-keagpt5rGVLGEq8IVZINTk
X-Proofpoint-GUID: QMgDufM7j-keagpt5rGVLGEq8IVZINTk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_03,2022-09-27_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

One of the sysfs value reported for supported_speeds
was not valid (20Gb/s reported instead of 64Gb/s).
Instead of driver internal speed mask definition, use speed mask
defined in transport_fc for reporting host->supported_speeds.

Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fa1fcbfb946f..6188f6e21464 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3330,11 +3330,34 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.bsg_timeout = qla24xx_bsg_timeout,
 };
 
+static uint
+qla2x00_get_host_supported_speeds(scsi_qla_host_t *vha, uint speeds)
+{
+	uint supported_speeds = FC_PORTSPEED_UNKNOWN;
+
+	if (speeds & FDMI_PORT_SPEED_64GB)
+		supported_speeds |= FC_PORTSPEED_64GBIT;
+	if (speeds & FDMI_PORT_SPEED_32GB)
+		supported_speeds |= FC_PORTSPEED_32GBIT;
+	if (speeds & FDMI_PORT_SPEED_16GB)
+		supported_speeds |= FC_PORTSPEED_16GBIT;
+	if (speeds & FDMI_PORT_SPEED_8GB)
+		supported_speeds |= FC_PORTSPEED_8GBIT;
+	if (speeds & FDMI_PORT_SPEED_4GB)
+		supported_speeds |= FC_PORTSPEED_4GBIT;
+	if (speeds & FDMI_PORT_SPEED_2GB)
+		supported_speeds |= FC_PORTSPEED_2GBIT;
+	if (speeds & FDMI_PORT_SPEED_1GB)
+		supported_speeds |= FC_PORTSPEED_1GBIT;
+
+	return supported_speeds;
+}
+
 void
 qla2x00_init_host_attr(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	u32 speeds = FC_PORTSPEED_UNKNOWN;
+	u32 speeds = 0, fdmi_speed = 0;
 
 	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
@@ -3344,7 +3367,8 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
-	speeds = qla25xx_fdmi_port_speed_capability(ha);
+	fdmi_speed = qla25xx_fdmi_port_speed_capability(ha);
+	speeds = qla2x00_get_host_supported_speeds(vha, fdmi_speed);
 
 	fc_host_supported_speeds(vha->host) = speeds;
 }
-- 
2.23.1

