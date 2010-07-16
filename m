From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/10] zfcp: Enable data division support for FCP devices
Date: Fri, 16 Jul 2010 15:37:41 +0200
Message-ID: <20100716134300.845774000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:42925 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564Ab0GPNnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:04 -0400
Content-Disposition: inline; filename=linux-2.6.34-qdio-zfcp-data.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Try to enable data division support for FCP devices and indicate in
the adapter status flag if it succeeded.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 arch/s390/include/asm/qdio.h  |    6 ++++++
 drivers/s390/cio/qdio_setup.c |    2 ++
 drivers/s390/scsi/zfcp_def.h  |    1 +
 drivers/s390/scsi/zfcp_qdio.c |   11 ++++++++++-
 4 files changed, 19 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -84,6 +84,7 @@ struct qdr {
 
 #define QIB_AC_OUTBOUND_PCI_SUPPORTED	0x40
 #define QIB_RFLAGS_ENABLE_QEBSM		0x80
+#define QIB_RFLAGS_ENABLE_DATA_DIV	0x02
 
 /**
  * struct qib - queue information block (QIB)
@@ -284,6 +285,9 @@ struct slsb {
 	u8 val[QDIO_MAX_BUFFERS_PER_Q];
 } __attribute__ ((packed, aligned(256)));
 
+#define CHSC_AC2_DATA_DIV_AVAILABLE	0x0010
+#define CHSC_AC2_DATA_DIV_ENABLED	0x0002
+
 struct qdio_ssqd_desc {
 	u8 flags;
 	u8:8;
@@ -332,6 +336,7 @@ typedef void qdio_handler_t(struct ccw_d
  * @adapter_name: name for the adapter
  * @qib_param_field_format: format for qib_parm_field
  * @qib_param_field: pointer to 128 bytes or NULL, if no param field
+ * @qib_rflags: rflags to set
  * @input_slib_elements: pointer to no_input_qs * 128 words of data or NULL
  * @output_slib_elements: pointer to no_output_qs * 128 words of data or NULL
  * @no_input_qs: number of input queues
@@ -348,6 +353,7 @@ struct qdio_initialize {
 	unsigned char adapter_name[8];
 	unsigned int qib_param_field_format;
 	unsigned char *qib_param_field;
+	unsigned char qib_rflags;
 	unsigned long *input_slib_elements;
 	unsigned long *output_slib_elements;
 	unsigned int no_input_qs;
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -368,6 +368,8 @@ static void setup_qib(struct qdio_irq *i
 	if (qebsm_possible())
 		irq_ptr->qib.rflags |= QIB_RFLAGS_ENABLE_QEBSM;
 
+	irq_ptr->qib.rflags |= init_data->qib_rflags;
+
 	irq_ptr->qib.qfmt = init_data->q_format;
 	if (init_data->no_input_qs)
 		irq_ptr->qib.isliba =
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -77,6 +77,7 @@ struct zfcp_reqlist;
 #define ZFCP_STATUS_ADAPTER_HOST_CON_INIT	0x00000010
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
+#define ZFCP_STATUS_ADAPTER_DATA_DIV_ENABLED	0x00000400
 
 /* remote port status */
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -283,6 +283,7 @@ static void zfcp_qdio_setup_init_data(st
 	id->q_format = QDIO_ZFCP_QFMT;
 	memcpy(id->adapter_name, dev_name(&id->cdev->dev), 8);
 	ASCEBC(id->adapter_name, 8);
+	id->qib_rflags = QIB_RFLAGS_ENABLE_DATA_DIV;
 	id->qib_param_field_format = 0;
 	id->qib_param_field = NULL;
 	id->input_slib_elements = NULL;
@@ -294,8 +295,8 @@ static void zfcp_qdio_setup_init_data(st
 	id->int_parm = (unsigned long) qdio;
 	id->input_sbal_addr_array = (void **) (qdio->res_q);
 	id->output_sbal_addr_array = (void **) (qdio->req_q);
-
 }
+
 /**
  * zfcp_qdio_allocate - allocate queue memory and initialize QDIO data
  * @adapter: pointer to struct zfcp_adapter
@@ -358,6 +359,7 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 	struct qdio_initialize init_data;
 	struct zfcp_adapter *adapter = qdio->adapter;
 	struct ccw_device *cdev = adapter->ccw_device;
+	struct qdio_ssqd_desc ssqd;
 	int cc;
 
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
@@ -368,6 +370,13 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 	if (qdio_establish(&init_data))
 		goto failed_establish;
 
+	if (qdio_get_ssqd_desc(init_data.cdev, &ssqd))
+		goto failed_qdio;
+
+	if (ssqd.qdioac2 & CHSC_AC2_DATA_DIV_ENABLED)
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_DATA_DIV_ENABLED,
+				&qdio->adapter->status);
+
 	if (qdio_activate(cdev))
 		goto failed_qdio;
 

