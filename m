From: David Jeffery <david_jeffery@adaptec.com>
Subject: [PATCH 2.6] ips fix for large mem 64bit machines
Date: Thu, 15 Jan 2004 12:40:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074188455.607.17.camel@blackmagic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-4gDSPI2CduO5WpffGzei"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54175 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265203AbUAORhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 12:37:38 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i0FHbZJ05994
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2004 09:37:35 -0800
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i0FHbZ825264
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2004 09:37:35 -0800
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-4gDSPI2CduO5WpffGzei
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch fixes DMA bugs on x86-64 and ia64 machines.  The driver was
using commands that only support 32bit addresses in places that could
return 64bit addresses.  One place was DMAing off the stack.  The other
place was causing problems on x86-64 machines by calling pci_map()
functions on a region allocated by pci_alloc_consistent().

David Jeffery

--=-4gDSPI2CduO5WpffGzei
Content-Disposition: attachment; filename=ips.patch1
Content-Type: text/x-patch; name=ips.patch1; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

diff -ur linux-2.6.1_p0/drivers/scsi/ips.c linux-2.6.1_p1/drivers/scsi/ips.c
--- linux-2.6.1_p0/drivers/scsi/ips.c	2004-01-13 14:10:06.000000000 -0500
+++ linux-2.6.1_p1/drivers/scsi/ips.c	2004-01-13 14:10:51.000000000 -0500
@@ -131,6 +131,8 @@
 /* 5.30.00  - use __devexit_p()                                              */
 /* 6.00.00  - Add 6x Adapters and Battery Flash                              */
 /* 6.10.00  - Remove 1G Addressing Limitations                               */
+/* 6.11.xx  - Get VersionInfo buffer off the stack !              DDTS 60401 */
+/* 6.11.xx  - Make Logical Drive Info structure safe for DMA      DDTS 60639 */
 /*****************************************************************************/
 
 /*
@@ -195,8 +197,8 @@
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "6.10"
-#define IPS_VERSION_LOW         ".90-BETA"
+#define IPS_VERSION_HIGH        "7.00"
+#define IPS_VERSION_LOW         ".00 "
 
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
@@ -497,8 +499,7 @@
 static int ips_host_info(ips_ha_t *, char *, off_t, int);
 static void copy_mem_info(IPS_INFOSTR *, char *, int);
 static int copy_info(IPS_INFOSTR *, char *, ...);
-static int ips_get_version_info(ips_ha_t * ha, IPS_VERSION_DATA * Buffer,
-				int intr);
+static int ips_get_version_info(ips_ha_t * ha, dma_addr_t, int intr);
 static void ips_version_check(ips_ha_t * ha, int intr);
 static int ips_abort_init(ips_ha_t * ha, int index);
 static int ips_init_phase2(int index);
@@ -3820,23 +3821,14 @@
 					scb->scsi_cmd->result = DID_OK << 16;
 				}
 			} else {
-				scb->cmd.logical_info.op_code =
-				    IPS_CMD_GET_LD_INFO;
-				scb->cmd.logical_info.command_id =
-				    IPS_COMMAND_ID(ha, scb);
+				scb->cmd.logical_info.op_code = IPS_CMD_GET_LD_INFO;
+				scb->cmd.logical_info.command_id = IPS_COMMAND_ID(ha, scb);
 				scb->cmd.logical_info.reserved = 0;
 				scb->cmd.logical_info.reserved2 = 0;
-				scb->data_len =
-				    sizeof (ha->adapt->logical_drive_info);
-				scb->data_busaddr =
-				    pci_map_single(ha->pcidev,
-						   &ha->adapt->
-						   logical_drive_info,
-						   scb->data_len,
-						   IPS_DMA_DIR(scb));
-				scb->flags |= IPS_SCB_MAP_SINGLE;
-				scb->cmd.logical_info.buffer_addr =
-				    scb->data_busaddr;
+				scb->data_len = sizeof (IPS_LD_INFO);
+				scb->data_busaddr = ha->logical_drive_info_dma_addr;
+				scb->flags = 0;
+				scb->cmd.logical_info.buffer_addr = scb->data_busaddr;
 				ret = IPS_SUCCESS;
 			}
 
@@ -3967,18 +3959,13 @@
 
 		case READ_CAPACITY:
 			scb->cmd.logical_info.op_code = IPS_CMD_GET_LD_INFO;
-			scb->cmd.logical_info.command_id =
-			    IPS_COMMAND_ID(ha, scb);
+			scb->cmd.logical_info.command_id = IPS_COMMAND_ID(ha, scb);
 			scb->cmd.logical_info.reserved = 0;
 			scb->cmd.logical_info.reserved2 = 0;
 			scb->cmd.logical_info.reserved3 = 0;
-			scb->data_len = sizeof (ha->adapt->logical_drive_info);
-			scb->data_busaddr = pci_map_single(ha->pcidev,
-							   &ha->adapt->
-							   logical_drive_info,
-							   scb->data_len,
-							   IPS_DMA_DIR(scb));
-			scb->flags |= IPS_SCB_MAP_SINGLE;
+			scb->data_len = sizeof (IPS_LD_INFO);
+			scb->data_busaddr = ha->logical_drive_info_dma_addr;
+			scb->flags = 0;
 			scb->cmd.logical_info.buffer_addr = scb->data_busaddr;
 			ret = IPS_SUCCESS;
 			break;
@@ -4302,19 +4289,17 @@
 		return (0);
 
 	if ((scb->basic_status & IPS_GSC_STATUS_MASK) > 1) {
-		memset(&ha->adapt->logical_drive_info, 0,
-		       sizeof (ha->adapt->logical_drive_info));
-
+		memset(ha->logical_drive_info, 0, sizeof (IPS_LD_INFO));
 		return (0);
 	}
 
-	if (ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	if (ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_OFFLINE
-	    && ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	    && ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_FREE
-	    && ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	    && ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_CRS
-	    && ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	    && ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_SYS)
 		return (1);
 	else
@@ -4377,7 +4362,7 @@
 
 	cap.lba =
 	    cpu_to_be32(le32_to_cpu
-			(ha->adapt->logical_drive_info.
+			(ha->logical_drive_info->
 			 drive_info[scb->target_id].sector_count) - 1);
 	cap.len = cpu_to_be32((uint32_t) IPS_BLKSIZE);
 
@@ -4541,6 +4526,14 @@
 			ha->adapt = NULL;
 		}
 
+		if (ha->logical_drive_info) {
+			pci_free_consistent(ha->pcidev,
+					    sizeof (IPS_LD_INFO),
+					    ha->logical_drive_info,
+					    ha->logical_drive_info_dma_addr);
+			ha->logical_drive_info = NULL;
+		}
+
 		if (ha->nvram) {
 			kfree(ha->nvram);
 			ha->nvram = NULL;
@@ -4730,6 +4723,7 @@
 	}
 
 	ha->scb_freelist = scb->q_next;
+	scb->flags = 0;
 	scb->q_next = NULL;
 
 	ips_init_scb(ha, scb);
@@ -6777,7 +6771,7 @@
 static void
 ips_version_check(ips_ha_t * ha, int intr)
 {
-	IPS_VERSION_DATA VersionInfo;
+	IPS_VERSION_DATA *VersionInfo;
 	uint8_t FirmwareVersion[IPS_COMPAT_ID_LENGTH + 1];
 	uint8_t BiosVersion[IPS_COMPAT_ID_LENGTH + 1];
 	int MatchError;
@@ -6787,6 +6781,8 @@
 
 	METHOD_TRACE("ips_version_check", 1);
 
+	VersionInfo = ( IPS_VERSION_DATA * ) ha->ioctl_data;
+
 	memset(FirmwareVersion, 0, IPS_COMPAT_ID_LENGTH + 1);
 	memset(BiosVersion, 0, IPS_COMPAT_ID_LENGTH + 1);
 
@@ -6797,9 +6793,10 @@
 	rc = IPS_FAILURE;
 	if (ha->subsys->param[4] & IPS_GET_VERSION_SUPPORT) {	/* If Versioning is Supported */
 		/* Get the Version Info with a Get Version Command */
-		rc = ips_get_version_info(ha, &VersionInfo, intr);
+		memset( VersionInfo, 0, sizeof (IPS_VERSION_DATA));
+		rc = ips_get_version_info(ha, ha->ioctl_busaddr, intr);
 		if (rc == IPS_SUCCESS)
-			memcpy(FirmwareVersion, VersionInfo.compatibilityId,
+			memcpy(FirmwareVersion, VersionInfo->compatibilityId,
 			       IPS_COMPAT_ID_LENGTH);
 	}
 
@@ -6862,14 +6859,13 @@
 /*     0 if Successful, else non-zero                                        */
 /*---------------------------------------------------------------------------*/
 static int
-ips_get_version_info(ips_ha_t * ha, IPS_VERSION_DATA * Buffer, int intr)
+ips_get_version_info(ips_ha_t * ha, dma_addr_t Buffer, int intr)
 {
 	ips_scb_t *scb;
 	int rc;
 
 	METHOD_TRACE("ips_get_version_info", 1);
 
-	memset(Buffer, 0, sizeof (IPS_VERSION_DATA));
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -6881,11 +6877,10 @@
 	scb->cmd.version_info.reserved = 0;
 	scb->cmd.version_info.count = sizeof (IPS_VERSION_DATA);
 	scb->cmd.version_info.reserved2 = 0;
-	scb->data_len = sizeof (*Buffer);
-	scb->data_busaddr = pci_map_single(ha->pcidev, Buffer,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.version_info.buffer_addr = scb->data_busaddr;
-	scb->flags |= IPS_SCB_MAP_SINGLE;
+	scb->data_len = sizeof (IPS_VERSION_DATA);
+	scb->data_busaddr = Buffer;
+	scb->cmd.version_info.buffer_addr = Buffer;
+	scb->flags = 0;
 
 	/* issue command */
 	rc = ips_send_wait(ha, scb, ips_cmd_timeout, intr);
@@ -7356,6 +7351,17 @@
 	ha->adapt->hw_status_start = dma_address;
 	ha->dummy = (void *) (ha->adapt + 1);
 
+
+
+	ha->logical_drive_info = pci_alloc_consistent(pci_dev, sizeof (IPS_LD_INFO), &dma_address);
+	if (!ha->logical_drive_info) {
+		IPS_PRINTK(KERN_WARNING, pci_dev,
+			   "Unable to allocate logical drive info structure\n");
+		return ips_abort_init(ha, index);
+	}
+	ha->logical_drive_info_dma_addr = dma_address;
+
+
 	ha->conf = kmalloc(sizeof (IPS_CONF), GFP_KERNEL);
 
 	if (!ha->conf) {
diff -ur linux-2.6.1_p0/drivers/scsi/ips.h linux-2.6.1_p1/drivers/scsi/ips.h
--- linux-2.6.1_p0/drivers/scsi/ips.h	2004-01-13 14:10:06.000000000 -0500
+++ linux-2.6.1_p1/drivers/scsi/ips.h	2004-01-13 14:10:51.000000000 -0500
@@ -711,7 +711,6 @@
    volatile PIPS_STATUS p_status_tail;
    volatile uint32_t    hw_status_start;
    volatile uint32_t    hw_status_tail;
-   IPS_LD_INFO          logical_drive_info;
 } IPS_ADAPTER, *PIPS_ADAPTER;
 
 typedef struct {
@@ -1084,6 +1083,8 @@
    ips_scb_queue_t    scb_activelist;     /* Active SCB list            */
    IPS_IO_CMD        *dummy;              /* dummy command              */
    IPS_ADAPTER       *adapt;              /* Adapter status area        */
+   IPS_LD_INFO       *logical_drive_info; /* Adapter Logical Drive Info */
+   dma_addr_t         logical_drive_info_dma_addr; /* Logical Drive Info DMA Address */
    IPS_ENQ           *enq;                /* Adapter Enquiry data       */
    IPS_CONF          *conf;               /* Adapter config data        */
    IPS_NVRAM_P5      *nvram;              /* NVRAM page 5 data          */
@@ -1132,7 +1133,7 @@
    uint8_t           lun;
    uint8_t           cdb[12];
    uint32_t          scb_busaddr;
-   uint32_t          data_busaddr;
+   uint32_t          old_data_busaddr;  // Obsolete, but kept for old utility compatibility
    uint32_t          timeout;
    uint8_t           basic_status;
    uint8_t           extended_status;
@@ -1148,6 +1149,7 @@
    ips_scb_callback  callback;
    uint32_t          sg_busaddr;
    int               sg_count;
+   dma_addr_t        data_busaddr;
 } ips_scb_t;
 
 typedef struct ips_scb_pt {
@@ -1201,15 +1203,15 @@
 *
 *************************************************************************/
 
-#define IPS_VER_MAJOR 6
-#define IPS_VER_MAJOR_STRING "6"
-#define IPS_VER_MINOR 10
-#define IPS_VER_MINOR_STRING "10"
-#define IPS_VER_BUILD 90
-#define IPS_VER_BUILD_STRING "90"
-#define IPS_VER_STRING "6.10.90"
-#define IPS_RELEASE_ID 0x00010000
-#define IPS_BUILD_IDENT 364
+#define IPS_VER_MAJOR 7
+#define IPS_VER_MAJOR_STRING "7"
+#define IPS_VER_MINOR 00
+#define IPS_VER_MINOR_STRING "00"
+#define IPS_VER_BUILD 00
+#define IPS_VER_BUILD_STRING "00"
+#define IPS_VER_STRING "7.00.00"
+#define IPS_RELEASE_ID 0x00010001
+#define IPS_BUILD_IDENT 475
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2003. All Rights Reserved."
 #define IPS_ADAPTECCOPYRIGHT_STRING "(c) Copyright Adaptec, Inc. 2002 to present. All Rights Reserved."
 #define IPS_NT_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2003."
@@ -1219,11 +1221,11 @@
 #define IPS_VER_SERVERAID2 "2.88.13"
 #define IPS_VER_NAVAJO "2.88.13"
 #define IPS_VER_SERVERAID3 "6.10.24"
-#define IPS_VER_SERVERAID4H "6.10.24"
-#define IPS_VER_SERVERAID4MLx "6.10.24"
-#define IPS_VER_SARASOTA "6.10.24"
-#define IPS_VER_MARCO "6.10.24"
-#define IPS_VER_SEBRING "6.10.24"
+#define IPS_VER_SERVERAID4H "6.11.07"
+#define IPS_VER_SERVERAID4MLx "6.11.07"
+#define IPS_VER_SARASOTA "6.11.07"
+#define IPS_VER_MARCO "6.11.07"
+#define IPS_VER_SEBRING "6.11.07"
 
 /* Compatability IDs for various adapters */
 #define IPS_COMPAT_UNKNOWN ""

--=-4gDSPI2CduO5WpffGzei--

