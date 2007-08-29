From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH] hptiop: adding new firmware interface and more PCI device IDs
Date: Wed, 29 Aug 2007 15:10:53 +0800
Message-ID: <200708291510.53793.linux@highpoint-tech.com>
References: <200605101704.27491.linux@highpoint-tech.com> <200605121107.48597.linux@highpoint-tech.com> <200605161438.09717.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.biz.mail.re2.yahoo.com ([206.190.52.173]:46442 "HELO
	smtp104.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752549AbXH2HQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Aug 2007 03:16:26 -0400
In-Reply-To: <200605161438.09717.linux@highpoint-tech.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com


- check adapter firmware version and using appropriate interface accordingly
- add new PCI device IDs
- update driver version string

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---

 hptiop.c |   57 +++++++++++++++++++++++++++++++++++++++++++--------------
 hptiop.h |    9 +++++++--
 2 files changed, 50 insertions(+), 16 deletions(-)

diff -uprN a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c	2007-08-29 13:52:20.000000000 +0800
+++ b/drivers/scsi/hptiop.c	2007-08-29 13:52:39.000000000 +0800
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx controller driver for Linux
- * Copyright (C) 2006 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -42,7 +42,7 @@ MODULE_DESCRIPTION("HighPoint RocketRAID
 
 static char driver_name[] = "hptiop";
 static const char driver_name_long[] = "RocketRAID 3xxx SATA Controller driver";
-static const char driver_ver[] = "v1.0 (060426)";
+static const char driver_ver[] = "v1.2 (070810)";
 
 static void hptiop_host_request_callback(struct hptiop_hba *hba, u32 tag);
 static void hptiop_iop_request_callback(struct hptiop_hba *hba, u32 tag);
@@ -76,7 +76,7 @@ static int iop_wait_ready(struct hpt_iop
 
 static void hptiop_request_callback(struct hptiop_hba *hba, u32 tag)
 {
-	if ((tag & IOPMU_QUEUE_MASK_HOST_BITS) == IOPMU_QUEUE_ADDR_HOST_BIT)
+	if (tag & IOPMU_QUEUE_ADDR_HOST_BIT)
 		return hptiop_host_request_callback(hba,
 				tag & ~IOPMU_QUEUE_ADDR_HOST_BIT);
 	else
@@ -323,12 +323,22 @@ static inline void free_req(struct hptio
 	hba->req_list = req;
 }
 
-static void hptiop_host_request_callback(struct hptiop_hba *hba, u32 tag)
+static void hptiop_host_request_callback(struct hptiop_hba *hba, u32 _tag)
 {
 	struct hpt_iop_request_scsi_command *req;
 	struct scsi_cmnd *scp;
+	u32 tag;
+
+	if (hba->firmware_version > 0x01020000 || hba->interface_version > 0x01020000) {
+		tag = _tag & ~ IOPMU_QUEUE_REQUEST_RESULT_BIT;
+		req = (struct hpt_iop_request_scsi_command *)hba->reqs[tag].req_virt;
+		if (likely(_tag & IOPMU_QUEUE_REQUEST_RESULT_BIT))
+			req->header.result = IOP_RESULT_SUCCESS;
+	} else {
+		tag = _tag;
+		req = (struct hpt_iop_request_scsi_command *)hba->reqs[tag].req_virt;
+	}
 
-	req = (struct hpt_iop_request_scsi_command *)hba->reqs[tag].req_virt;
 	dprintk("hptiop_host_request_callback: req=%p, type=%d, "
 			"result=%d, context=0x%x tag=%d\n",
 			req, req->header.type, req->header.result,
@@ -521,8 +531,20 @@ static int hptiop_queuecommand(struct sc
 
 	memcpy(req->cdb, scp->cmnd, sizeof(req->cdb));
 
-	writel(IOPMU_QUEUE_ADDR_HOST_BIT | _req->req_shifted_phy,
-			&hba->iop->inbound_queue);
+	if (hba->firmware_version > 0x01020000 ||
+				hba->interface_version > 0x01020000) {
+		u32 size_bits;
+		if (req->header.size < 256)
+			size_bits = IOPMU_QUEUE_REQUEST_SIZE_BIT;
+		else if (req->header.size < 512)
+			size_bits = IOPMU_QUEUE_ADDR_HOST_BIT;
+		else
+			size_bits = IOPMU_QUEUE_REQUEST_SIZE_BIT |
+						IOPMU_QUEUE_ADDR_HOST_BIT;
+		writel(_req->req_shifted_phy | size_bits, &hba->iop->inbound_queue);
+	} else
+		writel(_req->req_shifted_phy | IOPMU_QUEUE_ADDR_HOST_BIT,
+					&hba->iop->inbound_queue);
 
 	return 0;
 
@@ -722,6 +744,7 @@ static int __devinit hptiop_probe(struct
 	hba->max_request_size = le32_to_cpu(iop_config.request_size);
 	hba->max_sg_descriptors = le32_to_cpu(iop_config.max_sg_count);
 	hba->firmware_version = le32_to_cpu(iop_config.firmware_version);
+	hba->interface_version = le32_to_cpu(iop_config.interface_version);
 	hba->sdram_size = le32_to_cpu(iop_config.sdram_size);
 
 	host->max_sectors = le32_to_cpu(iop_config.data_transfer_length) >> 9;
@@ -731,8 +754,15 @@ static int __devinit hptiop_probe(struct
 	host->cmd_per_lun = le32_to_cpu(iop_config.max_requests);
 	host->max_cmd_len = 16;
 
-	set_config.vbus_id = cpu_to_le32(host->host_no);
+	req_size = sizeof(struct hpt_iop_request_scsi_command)
+		+ sizeof(struct hpt_iopsg) * (hba->max_sg_descriptors - 1);
+	if ((req_size & 0x1f) != 0)
+		req_size = (req_size + 0x1f) & ~0x1f;
+
+	memset(&set_config, 0, sizeof(struct hpt_iop_request_set_config));
 	set_config.iop_id = cpu_to_le32(host->host_no);
+	set_config.vbus_id = cpu_to_le16(host->host_no);
+	set_config.max_host_request_size = cpu_to_le16(req_size);
 
 	if (iop_set_config(hba, &set_config)) {
 		printk(KERN_ERR "scsi%d: set config failed\n",
@@ -750,10 +780,6 @@ static int __devinit hptiop_probe(struct
 	}
 
 	/* Allocate request mem */
-	req_size = sizeof(struct hpt_iop_request_scsi_command)
-		+ sizeof(struct hpt_iopsg) * (hba->max_sg_descriptors - 1);
-	if ((req_size& 0x1f) != 0)
-		req_size = (req_size + 0x1f) & ~0x1f;
 
 	dprintk("req_size=%d, max_requests=%d\n", req_size, hba->max_requests);
 
@@ -879,8 +905,10 @@ static void hptiop_remove(struct pci_dev
 }
 
 static struct pci_device_id hptiop_id_table[] = {
-	{ PCI_DEVICE(0x1103, 0x3220) },
-	{ PCI_DEVICE(0x1103, 0x3320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3220) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3520) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x4320) },
 	{},
 };
 
@@ -910,3 +938,4 @@ module_init(hptiop_module_init);
 module_exit(hptiop_module_exit);
 
 MODULE_LICENSE("GPL");
+
diff -uprN a/drivers/scsi/hptiop.h b/drivers/scsi/hptiop.h
--- a/drivers/scsi/hptiop.h	2007-08-20 17:15:52.000000000 +0800
+++ b/drivers/scsi/hptiop.h	2007-08-28 19:15:04.000000000 +0800
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx controller driver for Linux
- * Copyright (C) 2006 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -252,6 +252,8 @@ struct hpt_iopmu
 #define IOPMU_QUEUE_EMPTY            0xffffffff
 #define IOPMU_QUEUE_MASK_HOST_BITS   0xf0000000
 #define IOPMU_QUEUE_ADDR_HOST_BIT    0x80000000
+#define IOPMU_QUEUE_REQUEST_SIZE_BIT    0x40000000
+#define IOPMU_QUEUE_REQUEST_RESULT_BIT   0x40000000
 
 #define IOPMU_OUTBOUND_INT_MSG0      1
 #define IOPMU_OUTBOUND_INT_MSG1      2
@@ -336,7 +338,8 @@ struct hpt_iop_request_set_config
 {
 	struct hpt_iop_request_header header;
 	__le32 iop_id;
-	__le32 vbus_id;
+	__le16 vbus_id;
+	__le16 max_host_request_size;
 	__le32 reserve[6];
 };
 
@@ -415,6 +418,7 @@ struct hptiop_hba {
 	struct list_head link;
 
 	/* IOP config info */
+	u32     interface_version;
 	u32     firmware_version;
 	u32     sdram_size;
 	u32     max_devices;
@@ -463,3 +467,4 @@ struct hpt_ioctl_k
 #endif
 
 #endif
+

