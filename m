From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 15/29] qla2xxx: Add changes to support extended IOs for ISPFX00
Date: Tue, 27 Aug 2013 01:37:41 -0400
Message-ID: <1377581875-8574-16-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51814 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896Ab3H0GGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:49 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVw012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:48 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-17
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:48 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    5 ++---
 drivers/scsi/qla2xxx/qla_mr.h |    3 +++
 drivers/scsi/qla2xxx/qla_os.c |   10 +++++++---
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 27b8af8..f4c5d74 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1956,6 +1956,8 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 		memcpy(&vha->hw->mr.fru_serial_num, pinfo->fru_serial_num,
 		    sizeof(vha->hw->mr.fru_serial_num));
 		vha->hw->mr.critical_temperature = pinfo->nominal_temp_value;
+		ha->mr.extended_io_enabled = (pinfo->enabled_capabilities &
+		    QLAFX00_EXTENDED_IO_EN_MASK) != 0;
 	} else if (fx_type == FXDISC_GET_PORT_INFO) {
 		struct port_info_data *pinfo =
 		    (struct port_info_data *) fdisc->u.fxiocb.rsp_addr;
@@ -2799,9 +2801,6 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 	struct sts_entry_fx00 *pkt;
 	response_t *lptr;
 
-	if (!vha->flags.online)
-		return;
-
 	while (RD_REG_DWORD((void __iomem *)&(rsp->ring_ptr->signature)) !=
 	    RESPONSE_PROCESSED) {
 		lptr = rsp->ring_ptr;
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 982f7d3..772860b 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -510,8 +510,11 @@ struct mr_data_fx00 {
 	uint16_t fw_critemp_timer_tick;
 	uint32_t old_aenmbx0_state;
 	uint32_t critical_temperature;
+	bool extended_io_enabled;
 };
 
+#define QLAFX00_EXTENDED_IO_EN_MASK    0x20
+
 /*
  * SoC Junction Temperature is stored in
  * bits 9:1 of SoC Junction Temperature Register
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7a81ede..e1808b9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2876,6 +2876,13 @@ skip_dpc:
 
 	ha->isp_ops->enable_intrs(ha);
 
+	if (IS_QLAFX00(ha)) {
+		ret = qlafx00_fx_disc(base_vha,
+			&base_vha->hw->mr.fcport, FXDISC_GET_CONFIG_INFO);
+		host->sg_tablesize = (ha->mr.extended_io_enabled) ?
+		    QLA_SG_ALL : 128;
+	}
+
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
 		goto probe_failed;
@@ -2896,9 +2903,6 @@ skip_dpc:
 
 	if (IS_QLAFX00(ha)) {
 		ret = qlafx00_fx_disc(base_vha,
-			&base_vha->hw->mr.fcport, FXDISC_GET_CONFIG_INFO);
-
-		ret = qlafx00_fx_disc(base_vha,
 			&base_vha->hw->mr.fcport, FXDISC_GET_PORT_INFO);
 
 		/* Register system information */
-- 
1.7.7

