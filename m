Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29727256C84
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783080; cv=none; b=QDaHZ3Owpm/+C1RKwf6E94xPnoYcxRI6/xsNdDP2HP4XRaDT3rgK6lMo0XVEPD4CZ1xoRWIahkP7kH1XVnvZpYxyQzQwM9a2l5jlFpL0INhgZJMlOacDqGL9Q41pT9E5fZKAwGOldYwzZhuoGq09LZmOouEwE1jF7XcG03kVWFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783080; c=relaxed/simple;
	bh=wUwCdTLqeTveXQ2sZB3F5+Tl9KjJSLF9ddr2wS1DUVA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QD4OWf2vvAL7CCNrad0WB9d3Q9cUQ86RQhGZYpMv1Y0lN4sOj4zMddDu36UDM5ZgEoU6kXgalgudQnvPvC2IPBkiEb1kwvGpAkpTJ22ui2+bMPTD/e7klht2MqKBtqGKAoDTTqWqt19tlDsScDR9feQoCV9NidEDUR6rb9MBuw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kJVilV70; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kJVilV70"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w05U422576;
	Wed, 22 Jul 2026 22:04:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=g
	LXtos2qZsv6py2/WGKHX12163VwODweXZBNyU+5CWo=; b=kJVilV70/0J3Irbfw
	7THA5RUVQQVuSAR8mLdOtfMI25sHVs7mATSIbm1HtfHmtrwfltqKvyQcrGpNT3//
	yvdfWfsU1Is/k37AgO+dt1bvtMXdkD1+f1mhxeQaiOjr8W3wwI475ciMe6xfC69B
	VpMQq9wSDOJN7uAKL68G62oVvfvTeZVxd2FW5OYj4XrwtZdmbjVo5Q+bioefWCaA
	echK8MeII1nml7eksWYsyHVrlOTy43+71xGJCb2bFHU+/v39DDzUckgJJMbpJeZE
	HF+bKXXJMhWMDieIzz3YRYzUjgeU3ajvLoux+0PRRBkll8+TUtd6nmyGH+/BlP7W
	HuMrw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8bn-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:04:31 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:04:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:04:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9C7695C68E6;
	Wed, 22 Jul 2026 22:04:25 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 01/56] scsi: qla2xxx: Add 29xx series PCI device ID support
Date: Thu, 23 Jul 2026 10:33:18 +0530
Message-ID: <20260723050413.3897522-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: kfKfS2rpozA7B3K4GdQ9glIxJUFl3yvE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX6dUJuIWJIjsD
 vg/RwN2xYJZr731KQlRuhH9D5G4UXy5NgpZ9T0BqWhPfBCeQ7VnZ/C0vyFkvQHPM+TTV1Uoqw7V
 y1zpvYXq0hQvNCIXQaVWklh0hk4A1qM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX2c4HhlypnJie
 P5lyZGccDPQhDIWjNgStnd/QFBCXx8s+r+Hq5foac2GC3FG07xKdssM+XTOzFcplPx+gupJoRMX
 uYHReb0vCtMJRL4Nq8LXu4wIC3Z7BFCSDHC7IxaNS6qCRbJupn/FtjIMad+AG16MZgEX1Qbnyt5
 UhesabWZ+/3GFQ6YjXRhi2lF0yV86ra7ZZsdP2xCFNDDrUzf26yNLIeTAdicBpi0G5y6HzOLTmO
 ZdFZamnJXLz0s0MJHOXrQ5wv22PuzikVd6c7feGWMFqWsfaV8qjbRyzP/q481V9R9jH+n53dHf6
 8tgP5XS8PFK7098jZshawSRQ0hVuZfXKplhdVGdepc6vrCFy76JJoww8bWhD7bs2VE+gHSxJHcN
 2clilmTvtF1A+1pxxakXuxD2CTgDjkhLZOQgOcZkD2Cg+ryI45ymv9kPw9OMk5awei7vw53nRSb
 EjGli2JRCidZfjH7OBw==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a0df cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=9Ko3Zm86dqrhGpwkZ8sA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: kfKfS2rpozA7B3K4GdQ9glIxJUFl3yvE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

The QLA29xx is a new generation FC HBA that shares much of its
architecture with the 27xx/28xx family.  Register the new PCI
device IDs, wire up IS_QLA29XX() capability checks in the probe
and ISP-flags paths, and extend speed-capability logic so the
driver correctly recognises and initialises 29xx adapters.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 33 +++++++++++----
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c  |  5 ++-
 drivers/scsi/qla2xxx/qla_os.c   | 74 ++++++++++++++++++++++++++-------
 4 files changed, 88 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5593ad7fad27..6337a056b149 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3528,7 +3528,6 @@ struct isp_operations {
 #define QLA_MIDX_DEFAULT	0
 #define QLA_MIDX_RSP_Q		1
 #define QLA_PCI_MSIX_CONTROL	0xa2
-#define QLA_83XX_PCI_MSIX_CONTROL	0x92
 
 struct scsi_qla_host;
 
@@ -4287,6 +4286,10 @@ struct qla_hw_data {
 #define PCI_DEVICE_ID_QLOGIC_ISP2089	0x2089
 #define PCI_DEVICE_ID_QLOGIC_ISP2281	0x2281
 #define PCI_DEVICE_ID_QLOGIC_ISP2289	0x2289
+#define PCI_DEVICE_ID_QLOGIC_ISP2099	0x2099
+#define PCI_DEVICE_ID_QLOGIC_ISP2299	0x2299
+#define PCI_DEVICE_ID_QLOGIC_ISP2091	0x2091
+#define PCI_DEVICE_ID_QLOGIC_ISP2291	0x2291
 
 	uint32_t	isp_type;
 #define DT_ISP2100                      BIT_0
@@ -4316,7 +4319,11 @@ struct qla_hw_data {
 #define DT_ISP2089			BIT_24
 #define DT_ISP2281			BIT_25
 #define DT_ISP2289			BIT_26
-#define DT_ISP_LAST			(DT_ISP2289 << 1)
+#define DT_ISP2299			BIT_27
+#define DT_ISP2099			BIT_28
+#define DT_ISP2091			BIT_29
+#define DT_ISP2291			BIT_30
+#define DT_ISP_LAST			((uint32_t)DT_ISP2291 << 1)
 
 	uint32_t	device_type;
 #define DT_T10_PI                       BIT_25
@@ -4353,6 +4360,10 @@ struct qla_hw_data {
 #define IS_QLA2261(ha)	(DT_MASK(ha) & DT_ISP2261)
 #define IS_QLA2081(ha)	(DT_MASK(ha) & DT_ISP2081)
 #define IS_QLA2281(ha)	(DT_MASK(ha) & DT_ISP2281)
+#define IS_QLA2299(ha)	(DT_MASK(ha) & DT_ISP2299)
+#define IS_QLA2099(ha)	(DT_MASK(ha) & DT_ISP2099)
+#define IS_QLA2091(ha)	(DT_MASK(ha) & DT_ISP2091)
+#define IS_QLA2291(ha)	(DT_MASK(ha) & DT_ISP2291)
 
 #define IS_QLA23XX(ha)  (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
 			IS_QLA6312(ha) || IS_QLA6322(ha))
@@ -4363,6 +4374,9 @@ struct qla_hw_data {
 #define IS_QLA84XX(ha)  (IS_QLA8432(ha))
 #define IS_QLA27XX(ha)  (IS_QLA2071(ha) || IS_QLA2271(ha) || IS_QLA2261(ha))
 #define IS_QLA28XX(ha)	(IS_QLA2081(ha) || IS_QLA2281(ha))
+#define IS_QLA29XX(ha)	(IS_QLA2099(ha) || IS_QLA2299(ha) || \
+			 IS_QLA2091(ha) || IS_QLA2291(ha))
+
 #define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
 				IS_QLA84XX(ha))
 #define IS_CNA_CAPABLE(ha)	(IS_QLA81XX(ha) || IS_QLA82XX(ha) || \
@@ -4372,9 +4386,10 @@ struct qla_hw_data {
 				IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
 				IS_QLA82XX(ha) || IS_QLA83XX(ha) || \
 				IS_QLA8044(ha) || IS_QLA27XX(ha) || \
-				IS_QLA28XX(ha))
+				IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha) || IS_QLA83XX(ha) || \
-				IS_QLA27XX(ha) || IS_QLA28XX(ha))
+				IS_QLA27XX(ha) || IS_QLA28XX(ha) || \
+				IS_QLA29XX(ha))
 #define IS_NOPOLLING_TYPE(ha)	(IS_QLA81XX(ha) && (ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha) || \
 				IS_QLA27XX(ha) || IS_QLA28XX(ha))
@@ -4390,9 +4405,9 @@ struct qla_hw_data {
 #define HAS_EXTENDED_IDS(ha)    ((ha)->device_type & DT_EXTENDED_IDS)
 #define IS_CT6_SUPPORTED(ha)	((ha)->device_type & DT_CT6_SUPPORTED)
 #define IS_MQUE_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
-				 IS_QLA28XX(ha))
+				 IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_BIDI_CAPABLE(ha) \
-    (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+    (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 /* Bit 21 of fw_attributes decides the MCTP capabilities */
 #define IS_MCTP_CAPABLE(ha)	(IS_QLA2031(ha) && \
 				((ha)->fw_attributes_ext[0] & BIT_0))
@@ -4408,12 +4423,12 @@ struct qla_hw_data {
 	(QLA_NVME_IOS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
 
 #define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
-					 IS_QLA28XX(ha))
+					 IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
-					 IS_QLA28XX(ha))
+					 IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
 #define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
-					IS_QLA28XX(ha))
+					IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_PI_SPLIT_DET_CAPABLE(ha)	(IS_PI_SPLIT_DET_CAPABLE_HBA(ha) && \
     (((ha)->fw_attributes_h << 16 | (ha)->fw_attributes) & BIT_22))
 #define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e746c9274cde..e23e7ac48ae2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2773,7 +2773,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	ha->isp_ops->reset_chip(vha);
 
 	/* Check for secure flash support */
-	if (IS_QLA28XX(ha)) {
+	if (IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		if (rd_reg_word(&reg->mailbox12) & BIT_0)
 			ha->flags.secure_adapter = 1;
 		ql_log(ql_log_info, vha, 0xffff, "Secure Adapter: %s\n",
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 33776330956c..c47c38e099ff 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4663,7 +4663,8 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 	/* If possible, enable MSI-X. */
 	if (ql2xenablemsix == 0 || (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
 	    !IS_QLA8432(ha) && !IS_CNA_CAPABLE(ha) && !IS_QLA2031(ha) &&
-	    !IS_QLAFX00(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha)))
+	    !IS_QLAFX00(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+	    !IS_QLA29XX(ha)))
 		goto skip_msi;
 
 	if (ql2xenablemsix == 2)
@@ -4702,7 +4703,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
 	    !IS_QLA8001(ha) && !IS_P3P_TYPE(ha) && !IS_QLAFX00(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		goto skip_msi;
 
 	ret = pci_alloc_irq_vectors(ha->pdev, 1, 1, PCI_IRQ_MSI);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 72b1c28e4dae..c91d2b8bd08e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -429,7 +429,8 @@ static void qla_init_base_qpair(struct scsi_qla_host *vha, struct req_que *req,
 	qla_cpu_update(rsp->qpair, raw_smp_processor_id());
 	ha->base_qpair->pdev = ha->pdev;
 
-	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha) ||
+	    IS_QLA29XX(ha))
 		ha->base_qpair->reqq_start_iocbs = qla_83xx_start_iocbs;
 }
 
@@ -2153,8 +2154,6 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 static int
 qla83xx_iospace_config(struct qla_hw_data *ha)
 {
-	uint16_t msix;
-
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
 	    QLA2XXX_DRIVER_NAME)) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x0117,
@@ -2203,10 +2202,18 @@ qla83xx_iospace_config(struct qla_hw_data *ha)
 	ha->msixbase = ioremap(pci_resource_start(ha->pdev, 2),
 			pci_resource_len(ha->pdev, 2));
 	if (ha->msixbase) {
+		int msix_cnt;
+
 		/* Read MSIX vector size of the board */
-		pci_read_config_word(ha->pdev,
-		    QLA_83XX_PCI_MSIX_CONTROL, &msix);
-		ha->msix_count = (msix & PCI_MSIX_FLAGS_QSIZE)  + 1;
+		msix_cnt = pci_msix_vec_count(ha->pdev);
+		if (msix_cnt <= 0) {
+			ql_log_pci(ql_log_warn, ha->pdev, 0x0120,
+				   "Failed to read MSI-X count (%d), falling back to base vectors.\n",
+				   msix_cnt);
+			goto mqiobase_exit;
+		}
+		ha->msix_count = msix_cnt;
+
 		/*
 		 * By default, driver uses at least two msix vectors
 		 * (default & rspq)
@@ -2796,6 +2803,20 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |= DT_T10_PI;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2099:
+	case PCI_DEVICE_ID_QLOGIC_ISP2299:
+	case PCI_DEVICE_ID_QLOGIC_ISP2091:
+	case PCI_DEVICE_ID_QLOGIC_ISP2291:
+		ha->isp_type |= DT_ISP2299;
+		ha->isp_type |= DT_ISP2099;
+		ha->isp_type |= DT_ISP2091;
+		ha->isp_type |= DT_ISP2291;
+		ha->device_type |= DT_ZIO_SUPPORTED;
+		ha->device_type |= DT_FWI2;
+		ha->device_type |= DT_IIDMA;
+		ha->device_type |= DT_T10_PI;
+		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
+		break;
 	}
 
 	if (IS_QLA82XX(ha))
@@ -2803,8 +2824,8 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 	else {
 		/* Get adapter physical port no from interrupt pin register. */
 		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
-		if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
-		    IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
+		    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			ha->port_no--;
 		else
 			ha->port_no = !(ha->port_no & 1);
@@ -2936,7 +2957,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2081 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2281 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2089 ||
-	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2289) {
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2289 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2099 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2299 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2091 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2291) {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
 		mem_only = 1;
 		ql_dbg_pci(ql_dbg_init, pdev, 0x0007,
@@ -2998,7 +3023,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Set EEH reset type to fundamental if required by hba */
 	if (IS_QLA24XX(ha) || IS_QLA25XX(ha) || IS_QLA81XX(ha) ||
-	    IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	    IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+	    IS_QLA29XX(ha))
 		pdev->needs_freset = 1;
 
 	ha->prev_topology = 0;
@@ -3195,6 +3221,22 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->flash_data_off = FARX_ACCESS_FLASH_DATA_28XX;
 		ha->nvram_conf_off = ~0;
 		ha->nvram_data_off = ~0;
+	} else if (IS_QLA29XX(ha)) {
+		ha->portnum = PCI_FUNC(ha->pdev->devfn);
+		ha->max_fibre_devices = MAX_FIBRE_DEVICES_2400;
+		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		req_length = REQUEST_ENTRY_CNT_83XX;
+		rsp_length = RESPONSE_ENTRY_CNT_83XX;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
+		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
+		ha->gid_list_info_size = 8;
+		ha->optrom_size = OPTROM_SIZE_28XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
+		ha->isp_ops = &qla27xx_isp_ops;
+		ha->flash_conf_off = ~0;
+		ha->flash_data_off = ~0;
+		ha->nvram_conf_off = ~0;
+		ha->nvram_data_off = ~0;
 	}
 
 	ql_dbg_pci(ql_dbg_init, pdev, 0x001e,
@@ -3373,7 +3415,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	rsp->rsp_q_in = &ha->iobase->isp24.rsp_q_in;
 	rsp->rsp_q_out = &ha->iobase->isp24.rsp_q_out;
 	if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		req->req_q_in = &ha->mqiobase->isp25mq.req_q_in;
 		req->req_q_out = &ha->mqiobase->isp25mq.req_q_out;
 		rsp->rsp_q_in = &ha->mqiobase->isp25mq.rsp_q_in;
@@ -3898,7 +3940,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		return;
 
 	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		if (ha->flags.fw_started)
 			qla2x00_abort_isp_cleanup(base_vha);
 	} else if (!IS_QLAFX00(ha)) {
@@ -4387,7 +4429,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 
 	/* Get consistent memory allocated for EX-INIT-CB. */
 	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		ha->ex_init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
 		    &ha->ex_init_cb_dma);
 		if (!ha->ex_init_cb)
@@ -4397,7 +4439,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	}
 
 	/* Get consistent memory allocated for Special Features-CB. */
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		ha->sf_init_cb = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL,
 						&ha->sf_init_cb_dma);
 		if (!ha->sf_init_cb)
@@ -8155,6 +8197,10 @@ static const struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2281) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2089) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2289) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2099) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2299) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2091) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2291) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
-- 
2.47.3

