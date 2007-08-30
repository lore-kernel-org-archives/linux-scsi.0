From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH/RESENT] hptiop: adding new firmware interface and more PCI device IDs
Date: Thu, 30 Aug 2007 18:06:21 +0800
Message-ID: <200708301635.42481.linux@highpoint-tech.com>
References: <200605101704.27491.linux@highpoint-tech.com> <200605161438.09717.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.biz.mail.mud.yahoo.com ([68.142.201.179]:41539 "HELO
	smtp110.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754952AbXH3KK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Aug 2007 06:10:29 -0400
In-Reply-To: <200708291510.53793.linux@highpoint-tech.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

updated patch based on Jeff Garzik's comments.

- check adapter firmware version and use appropriate interface accordingly
- add new PCI device IDs and use PCI_VDEVICE macro
- update driver version string
- remove unused data structures
- remove unnecessary typecasts

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---
 drivers/scsi/hptiop.c |   63 +++++++++++++----
 drivers/scsi/hptiop.h |  229 ++-------------------------------------------------------------
 2 files changed, 58 insertions(+), 234 deletions(-)

diff -urpN a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c	2007-08-28 22:52:20.000000000 -0700
+++ b/drivers/scsi/hptiop.c	2007-08-30 10:08:13.000000000 -0700
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
+static const char driver_ver[] = "v1.2 (070830)";
 
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
+	if (hba->iopintf_v2) {
+		tag = _tag & ~ IOPMU_QUEUE_REQUEST_RESULT_BIT;
+		req = hba->reqs[tag].req_virt;
+		if (likely(_tag & IOPMU_QUEUE_REQUEST_RESULT_BIT))
+			req->header.result = IOP_RESULT_SUCCESS;
+	} else {
+		tag = _tag;
+		req = hba->reqs[tag].req_virt;
+	}
 
-	req = (struct hpt_iop_request_scsi_command *)hba->reqs[tag].req_virt;
 	dprintk("hptiop_host_request_callback: req=%p, type=%d, "
 			"result=%d, context=0x%x tag=%d\n",
 			req, req->header.type, req->header.result,
@@ -497,7 +507,7 @@ static int hptiop_queuecommand(struct sc
 		goto cmd_done;
 	}
 
-	req = (struct hpt_iop_request_scsi_command *)_req->req_virt;
+	req = _req->req_virt;
 
 	/* build S/G table */
 	sg_count = hptiop_buildsgl(scp, req->sg_list);
@@ -521,8 +531,19 @@ static int hptiop_queuecommand(struct sc
 
 	memcpy(req->cdb, scp->cmnd, sizeof(req->cdb));
 
-	writel(IOPMU_QUEUE_ADDR_HOST_BIT | _req->req_shifted_phy,
-			&hba->iop->inbound_queue);
+	if (hba->iopintf_v2) {
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
 
@@ -688,6 +709,7 @@ static int __devinit hptiop_probe(struct
 	hba->pcidev = pcidev;
 	hba->host = host;
 	hba->initialized = 0;
+	hba->iopintf_v2 = 0;
 
 	atomic_set(&hba->resetting, 0);
 	atomic_set(&hba->reset_count, 0);
@@ -722,8 +744,13 @@ static int __devinit hptiop_probe(struct
 	hba->max_request_size = le32_to_cpu(iop_config.request_size);
 	hba->max_sg_descriptors = le32_to_cpu(iop_config.max_sg_count);
 	hba->firmware_version = le32_to_cpu(iop_config.firmware_version);
+	hba->interface_version = le32_to_cpu(iop_config.interface_version);
 	hba->sdram_size = le32_to_cpu(iop_config.sdram_size);
 
+	if (hba->firmware_version > 0x01020000 ||
+			hba->interface_version > 0x01020000)
+		hba->iopintf_v2 = 1;
+
 	host->max_sectors = le32_to_cpu(iop_config.data_transfer_length) >> 9;
 	host->max_id = le32_to_cpu(iop_config.max_devices);
 	host->sg_tablesize = le32_to_cpu(iop_config.max_sg_count);
@@ -731,8 +758,15 @@ static int __devinit hptiop_probe(struct
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
@@ -750,10 +784,6 @@ static int __devinit hptiop_probe(struct
 	}
 
 	/* Allocate request mem */
-	req_size = sizeof(struct hpt_iop_request_scsi_command)
-		+ sizeof(struct hpt_iopsg) * (hba->max_sg_descriptors - 1);
-	if ((req_size& 0x1f) != 0)
-		req_size = (req_size + 0x1f) & ~0x1f;
 
 	dprintk("req_size=%d, max_requests=%d\n", req_size, hba->max_requests);
 
@@ -879,8 +909,10 @@ static void hptiop_remove(struct pci_dev
 }
 
 static struct pci_device_id hptiop_id_table[] = {
-	{ PCI_DEVICE(0x1103, 0x3220) },
-	{ PCI_DEVICE(0x1103, 0x3320) },
+	{ PCI_VDEVICE(TTI, 0x3220) },
+	{ PCI_VDEVICE(TTI, 0x3320) },
+	{ PCI_VDEVICE(TTI, 0x3520) },
+	{ PCI_VDEVICE(TTI, 0x4320) },
 	{},
 };
 
@@ -910,3 +942,4 @@ module_init(hptiop_module_init);
 module_exit(hptiop_module_exit);
 
 MODULE_LICENSE("GPL");
+
diff -urpN a/drivers/scsi/hptiop.h b/drivers/scsi/hptiop.h
--- a/drivers/scsi/hptiop.h	2007-08-20 02:15:52.000000000 -0700
+++ b/drivers/scsi/hptiop.h	2007-08-30 10:08:14.000000000 -0700
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx controller driver for Linux
- * Copyright (C) 2006 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,219 +18,6 @@
 #ifndef _HPTIOP_H_
 #define _HPTIOP_H_
 
-/*
- * logical device type.
- * Identify array (logical device) and physical device.
- */
-#define LDT_ARRAY   1
-#define LDT_DEVICE  2
-
-/*
- * Array types
- */
-#define AT_UNKNOWN  0
-#define AT_RAID0    1
-#define AT_RAID1    2
-#define AT_RAID5    3
-#define AT_RAID6    4
-#define AT_JBOD     7
-
-#define MAX_NAME_LENGTH     36
-#define MAX_ARRAYNAME_LEN   16
-
-#define MAX_ARRAY_MEMBERS_V1 8
-#define MAX_ARRAY_MEMBERS_V2 16
-
-/* keep definition for source code compatiblity */
-#define MAX_ARRAY_MEMBERS MAX_ARRAY_MEMBERS_V1
-
-/*
- * array flags
- */
-#define ARRAY_FLAG_DISABLED         0x00000001 /* The array is disabled */
-#define ARRAY_FLAG_NEEDBUILDING     0x00000002 /* need to be rebuilt */
-#define ARRAY_FLAG_REBUILDING       0x00000004 /* in rebuilding process */
-#define ARRAY_FLAG_BROKEN           0x00000008 /* broken but still working */
-#define ARRAY_FLAG_BOOTDISK         0x00000010 /* has a active partition */
-#define ARRAY_FLAG_BOOTMARK         0x00000040 /* array has boot mark set */
-#define ARRAY_FLAG_NEED_AUTOREBUILD 0x00000080 /* auto-rebuild should start */
-#define ARRAY_FLAG_VERIFYING        0x00000100 /* is being verified */
-#define ARRAY_FLAG_INITIALIZING     0x00000200 /* is being initialized */
-#define ARRAY_FLAG_TRANSFORMING     0x00000400 /* tranform in progress */
-#define ARRAY_FLAG_NEEDTRANSFORM    0x00000800 /* array need tranform */
-#define ARRAY_FLAG_NEEDINITIALIZING 0x00001000 /* initialization not done */
-#define ARRAY_FLAG_BROKEN_REDUNDANT 0x00002000 /* broken but redundant */
-
-/*
- * device flags
- */
-#define DEVICE_FLAG_DISABLED        0x00000001 /* device is disabled */
-#define DEVICE_FLAG_UNINITIALIZED   0x00010000 /* device is not initialized */
-#define DEVICE_FLAG_LEGACY          0x00020000 /* lagacy drive */
-#define DEVICE_FLAG_IS_SPARE        0x80000000 /* is a spare disk */
-
-/*
- * ioctl codes
- */
-#define HPT_CTL_CODE(x) (x+0xFF00)
-#define HPT_CTL_CODE_LINUX_TO_IOP(x) ((x)-0xff00)
-
-#define HPT_IOCTL_GET_CONTROLLER_INFO       HPT_CTL_CODE(2)
-#define HPT_IOCTL_GET_CHANNEL_INFO          HPT_CTL_CODE(3)
-#define HPT_IOCTL_GET_LOGICAL_DEVICES       HPT_CTL_CODE(4)
-#define HPT_IOCTL_GET_DRIVER_CAPABILITIES   HPT_CTL_CODE(19)
-#define HPT_IOCTL_GET_DEVICE_INFO_V3        HPT_CTL_CODE(46)
-#define HPT_IOCTL_GET_CONTROLLER_INFO_V2    HPT_CTL_CODE(47)
-
-/*
- * Controller information.
- */
-struct hpt_controller_info {
-	u8      chip_type;                    /* chip type */
-	u8      interrupt_level;              /* IRQ level */
-	u8      num_buses;                    /* bus count */
-	u8      chip_flags;
-
-	u8      product_id[MAX_NAME_LENGTH];/* product name */
-	u8      vendor_id[MAX_NAME_LENGTH]; /* vendor name */
-}
-__attribute__((packed));
-
-/*
- * Channel information.
- */
-struct hpt_channel_info {
-	__le32  io_port;         /* IDE Base Port Address */
-	__le32  control_port;    /* IDE Control Port Address */
-	__le32  devices[2];      /* device connected to this channel */
-}
-__attribute__((packed));
-
-/*
- * Array information.
- */
-struct hpt_array_info_v3 {
-	u8      name[MAX_ARRAYNAME_LEN]; /* array name */
-	u8      description[64];         /* array description */
-	u8      create_manager[16];      /* who created it */
-	__le32  create_time;             /* when created it */
-
-	u8      array_type;              /* array type */
-	u8      block_size_shift;        /* stripe size */
-	u8      ndisk;                   /* Number of ID in Members[] */
-	u8      reserved;
-
-	__le32  flags;                   /* working flags, see ARRAY_FLAG_XXX */
-	__le32  members[MAX_ARRAY_MEMBERS_V2];  /* member array/disks */
-
-	__le32  rebuilding_progress;
-	__le64  rebuilt_sectors; /* rebuilding point (LBA) for single member */
-
-	__le32  transform_source;
-	__le32  transform_target;    /* destination device ID */
-	__le32  transforming_progress;
-	__le32  signature;              /* persistent identification*/
-	__le16  critical_members;       /* bit mask of critical members */
-	__le16  reserve2;
-	__le32  reserve;
-}
-__attribute__((packed));
-
-/*
- * physical device information.
- */
-#define MAX_PARENTS_PER_DISK    8
-
-struct hpt_device_info_v2 {
-	u8   ctlr_id;             /* controller id */
-	u8   path_id;             /* bus */
-	u8   target_id;           /* id */
-	u8   device_mode_setting; /* Current Data Transfer mode: 0-4 PIO0-4 */
-				  /* 5-7 MW DMA0-2, 8-13 UDMA0-5 */
-	u8   device_type;         /* device type */
-	u8   usable_mode;         /* highest usable mode */
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	u8   NCQ_enabled: 1;
-	u8   NCQ_supported: 1;
-	u8   TCQ_enabled: 1;
-	u8   TCQ_supported: 1;
-	u8   write_cache_enabled: 1;
-	u8   write_cache_supported: 1;
-	u8   read_ahead_enabled: 1;
-	u8   read_ahead_supported: 1;
-	u8   reserved6: 6;
-	u8   spin_up_mode: 2;
-#else
-	u8   read_ahead_supported: 1;
-	u8   read_ahead_enabled: 1;
-	u8   write_cache_supported: 1;
-	u8   write_cache_enabled: 1;
-	u8   TCQ_supported: 1;
-	u8   TCQ_enabled: 1;
-	u8   NCQ_supported: 1;
-	u8   NCQ_enabled: 1;
-	u8   spin_up_mode: 2;
-	u8   reserved6: 6;
-#endif
-
-	__le32  flags;         /* working flags, see DEVICE_FLAG_XXX */
-	u8      ident[150];    /* (partitial) Identify Data of this device */
-
-	__le64  total_free;
-	__le64  max_free;
-	__le64  bad_sectors;
-	__le32  parent_arrays[MAX_PARENTS_PER_DISK];
-}
-__attribute__((packed));
-
-/*
- * Logical device information.
- */
-#define INVALID_TARGET_ID   0xFF
-#define INVALID_BUS_ID      0xFF
-
-struct hpt_logical_device_info_v3 {
-	u8       type;                   /* LDT_ARRAY or LDT_DEVICE */
-	u8       cache_policy;           /* refer to CACHE_POLICY_xxx */
-	u8       vbus_id;                /* vbus sequence in vbus_list */
-	u8       target_id;              /* OS target id. 0xFF is invalid */
-					 /* OS name: DISK $VBusId_$TargetId */
-	__le64   capacity;               /* array capacity */
-	__le32   parent_array;           /* don't use this field for physical
-					    device. use ParentArrays field in
-					    hpt_device_info_v2 */
-	/* reserved statistic fields */
-	__le32   stat1;
-	__le32   stat2;
-	__le32   stat3;
-	__le32   stat4;
-
-	union {
-		struct hpt_array_info_v3 array;
-		struct hpt_device_info_v2 device;
-	} __attribute__((packed)) u;
-
-}
-__attribute__((packed));
-
-/*
- * ioctl structure
- */
-#define HPT_IOCTL_MAGIC   0xA1B2C3D4
-
-struct hpt_ioctl_u {
-	u32   magic;            /* used to check if it's a valid ioctl packet */
-	u32   ioctl_code;       /* operation control code */
-	void __user *inbuf;     /* input data buffer */
-	u32   inbuf_size;       /* size of input data buffer */
-	void __user *outbuf;    /* output data buffer */
-	u32   outbuf_size;      /* size of output data buffer */
-	void __user *bytes_returned;   /* count of bytes returned */
-}
-__attribute__((packed));
-
-
 struct hpt_iopmu
 {
 	__le32 resrved0[4];
@@ -252,6 +39,8 @@ struct hpt_iopmu
 #define IOPMU_QUEUE_EMPTY            0xffffffff
 #define IOPMU_QUEUE_MASK_HOST_BITS   0xf0000000
 #define IOPMU_QUEUE_ADDR_HOST_BIT    0x80000000
+#define IOPMU_QUEUE_REQUEST_SIZE_BIT    0x40000000
+#define IOPMU_QUEUE_REQUEST_RESULT_BIT   0x40000000
 
 #define IOPMU_OUTBOUND_INT_MSG0      1
 #define IOPMU_OUTBOUND_INT_MSG1      2
@@ -336,7 +125,8 @@ struct hpt_iop_request_set_config
 {
 	struct hpt_iop_request_header header;
 	__le32 iop_id;
-	__le32 vbus_id;
+	__le16 vbus_id;
+	__le16 max_host_request_size;
 	__le32 reserve[6];
 };
 
@@ -412,9 +202,8 @@ struct hptiop_hba {
 	struct Scsi_Host * host;
 	struct pci_dev * pcidev;
 
-	struct list_head link;
-
 	/* IOP config info */
+	u32     interface_version;
 	u32     firmware_version;
 	u32     sdram_size;
 	u32     max_devices;
@@ -423,8 +212,10 @@ struct hptiop_hba {
 	u32     max_sg_descriptors;
 
 	u32     req_size; /* host-allocated request buffer size */
-	int     initialized;
-	int     msg_done;
+
+	int     iopintf_v2: 1;
+	int     initialized: 1;
+	int     msg_done: 1;
 
 	struct hptiop_request * req_list;
 	struct hptiop_request reqs[HPTIOP_MAX_REQUESTS];

