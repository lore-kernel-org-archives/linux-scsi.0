From: <sreekanth.reddy@lsi.com>
Subject: [PATCH][SCSI] mpt3sas: Part 2 of MPI API headers
Date: Sat, 29 Sep 2012 19:37:51 +0530
Message-ID: <20120929140751.GA20625@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42892 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab2I2UUk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 16:20:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This patch contains MPI API headers
This patch is part 2 of MPI API headers.
Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
new file mode 100644
index 0000000..7e24c55
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -0,0 +1,1707 @@
+/*
+ * Copyright (c) 2000-2011 LSI Corporation.
+ *
+ *
+ *          Name:  mpi2_cnfg.h
+ *         Title:  MPI Configuration messages and pages
+ * Creation Date:  November 10, 2006
+ *
+ *   mpi2_cnfg.h Version:  02.00.22
+ *
+ * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
+ *       prefix are for use only on MPI v2.5 products, and must not be used
+ *       with MPI v2.0 products. Unless otherwise noted, names beginning with
+ *       MPI2 or Mpi2 are for use with both MPI v2.0 and MPI v2.5 products.
+ *
+ * Version History
+ * ---------------
+ *
+ * Date      Version   Description
+ * --------  --------  ------------------------------------------------------
+ * 04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ * 06-04-07  02.00.01  Added defines for SAS IO Unit Page 2 PhyFlags.
+ *                     Added Manufacturing Page 11.
+ *                     Added MPI2_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE
+ *                     define.
+ * 06-26-07  02.00.02  Adding generic structure for product-specific
+ *                     Manufacturing pages: MPI2_CONFIG_PAGE_MANUFACTURING_PS.
+ *                     Rework of BIOS Page 2 configuration page.
+ *                     Fixed MPI2_BIOSPAGE2_BOOT_DEVICE to be a union of the
+ *                     forms.
+ *                     Added configuration pages IOC Page 8 and Driver
+ *                     Persistent Mapping Page 0.
+ * 08-31-07  02.00.03  Modified configuration pages dealing with Integrated
+ *                     RAID (Manufacturing Page 4, RAID Volume Pages 0 and 1,
+ *                     RAID Physical Disk Pages 0 and 1, RAID Configuration
+ *                     Page 0).
+ *                     Added new value for AccessStatus field of SAS Device
+ *                     Page 0 (_SATA_NEEDS_INITIALIZATION).
+ * 10-31-07  02.00.04  Added missing SEPDevHandle field to
+ *                     MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
+ * 12-18-07  02.00.05  Modified IO Unit Page 0 to use 32-bit version fields for
+ *                     NVDATA.
+ *                     Modified IOC Page 7 to use masks and added field for
+ *                     SASBroadcastPrimitiveMasks.
+ *                     Added MPI2_CONFIG_PAGE_BIOS_4.
+ *                     Added MPI2_CONFIG_PAGE_LOG_0.
+ * 02-29-08  02.00.06  Modified various names to make them 32-character unique.
+ *                     Added SAS Device IDs.
+ *                     Updated Integrated RAID configuration pages including
+ *                     Manufacturing Page 4, IOC Page 6, and RAID Configuration
+ *                     Page 0.
+ * 05-21-08  02.00.07  Added define MPI2_MANPAGE4_MIX_SSD_SAS_SATA.
+ *                     Added define MPI2_MANPAGE4_PHYSDISK_128MB_COERCION.
+ *                     Fixed define MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING.
+ *                     Added missing MaxNumRoutedSasAddresses field to
+ *                     MPI2_CONFIG_PAGE_EXPANDER_0.
+ *                     Added SAS Port Page 0.
+ *                     Modified structure layout for
+ *                     MPI2_CONFIG_PAGE_DRIVER_MAPPING_0.
+ * 06-27-08  02.00.08  Changed MPI2_CONFIG_PAGE_RD_PDISK_1 to use
+ *                     MPI2_RAID_PHYS_DISK1_PATH_MAX to size the array.
+ * 10-02-08  02.00.09  Changed MPI2_RAID_PGAD_CONFIGNUM_MASK from 0x0000FFFF
+ *                     to 0x000000FF.
+ *                     Added two new values for the Physical Disk Coercion Size
+ *                     bits in the Flags field of Manufacturing Page 4.
+ *                     Added product-specific Manufacturing pages 16 to 31.
+ *                     Modified Flags bits for controlling write cache on SATA
+ *                     drives in IO Unit Page 1.
+ *                     Added new bit to AdditionalControlFlags of SAS IO Unit
+ *                     Page 1 to control Invalid Topology Correction.
+ *                     Added additional defines for RAID Volume Page 0
+ *                     VolumeStatusFlags field.
+ *                     Modified meaning of RAID Volume Page 0 VolumeSettings
+ *                     define for auto-configure of hot-swap drives.
+ *                     Added SupportedPhysDisks field to RAID Volume Page 1 and
+ *                     added related defines.
+ *                     Added PhysDiskAttributes field (and related defines) to
+ *                     RAID Physical Disk Page 0.
+ *                     Added MPI2_SAS_PHYINFO_PHY_VACANT define.
+ *                     Added three new DiscoveryStatus bits for SAS IO Unit
+ *                     Page 0 and SAS Expander Page 0.
+ *                     Removed multiplexing information from SAS IO Unit pages.
+ *                     Added BootDeviceWaitTime field to SAS IO Unit Page 4.
+ *                     Removed Zone Address Resolved bit from PhyInfo and from
+ *                     Expander Page 0 Flags field.
+ *                     Added two new AccessStatus values to SAS Device Page 0
+ *                     for indicating routing problems. Added 3 reserved words
+ *                     to this page.
+ * 01-19-09  02.00.10  Fixed defines for GPIOVal field of IO Unit Page 3.
+ *                     Inserted missing reserved field into structure for IOC
+ *                     Page 6.
+ *                     Added more pending task bits to RAID Volume Page 0
+ *                     VolumeStatusFlags defines.
+ *                     Added MPI2_PHYSDISK0_STATUS_FLAG_NOT_CERTIFIED define.
+ *                     Added a new DiscoveryStatus bit for SAS IO Unit Page 0
+ *                     and SAS Expander Page 0 to flag a downstream initiator
+ *                     when in simplified routing mode.
+ *                     Removed SATA Init Failure defines for DiscoveryStatus
+ *                     fields of SAS IO Unit Page 0 and SAS Expander Page 0.
+ *                     Added MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED define.
+ *                     Added PortGroups, DmaGroup, and ControlGroup fields to
+ *                     SAS Device Page 0.
+ * 05-06-09  02.00.11  Added structures and defines for IO Unit Page 5 and IO
+ *                     Unit Page 6.
+ *                     Added expander reduced functionality data to SAS
+ *                     Expander Page 0.
+ *                     Added SAS PHY Page 2 and SAS PHY Page 3.
+ * 07-30-09  02.00.12  Added IO Unit Page 7.
+ *                     Added new device ids.
+ *                     Added SAS IO Unit Page 5.
+ *                     Added partial and slumber power management capable flags
+ *                     to SAS Device Page 0 Flags field.
+ *                     Added PhyInfo defines for power condition.
+ *                     Added Ethernet configuration pages.
+ * 10-28-09  02.00.13  Added MPI2_IOUNITPAGE1_ENABLE_HOST_BASED_DISCOVERY.
+ *                     Added SAS PHY Page 4 structure and defines.
+ * 02-10-10  02.00.14  Modified the comments for the configuration page
+ *                     structures that contain an array of data. The host
+ *                     should use the "count" field in the page data (e.g. the
+ *                     NumPhys field) to determine the number of valid elements
+ *                     in the array.
+ *                     Added/modified some MPI2_MFGPAGE_DEVID_SAS defines.
+ *                     Added PowerManagementCapabilities to IO Unit Page 7.
+ *                     Added PortWidthModGroup field to
+ *                     MPI2_SAS_IO_UNIT5_PHY_PM_SETTINGS.
+ *                     Added MPI2_CONFIG_PAGE_SASIOUNIT_6 and related defines.
+ *                     Added MPI2_CONFIG_PAGE_SASIOUNIT_7 and related defines.
+ *                     Added MPI2_CONFIG_PAGE_SASIOUNIT_8 and related defines.
+ * 05-12-10  02.00.15  Added MPI2_RAIDVOL0_STATUS_FLAG_VOL_NOT_CONSISTENT
+ *                     define.
+ *                     Added MPI2_PHYSDISK0_INCOMPATIBLE_MEDIA_TYPE define.
+ *                     Added MPI2_SAS_NEG_LINK_RATE_UNSUPPORTED_PHY define.
+ * 08-11-10  02.00.16  Removed IO Unit Page 1 device path (multi-pathing)
+ *                     defines.
+ * 11-10-10  02.00.17  Added ReceptacleID field (replacing Reserved1) to
+ *                     MPI2_MANPAGE7_CONNECTOR_INFO and reworked defines for
+ *                     the Pinout field.
+ *                     Added BoardTemperature and BoardTemperatureUnits fields
+ *                     to MPI2_CONFIG_PAGE_IO_UNIT_7.
+ *                     Added MPI2_CONFIG_EXTPAGETYPE_EXT_MANUFACTURING define
+ *                     and MPI2_CONFIG_PAGE_EXT_MAN_PS structure.
+ * 02-23-11  02.00.18  Added ProxyVF_ID field to MPI2_CONFIG_REQUEST.
+ *                     Added IO Unit Page 8, IO Unit Page 9,
+ *                     and IO Unit Page 10.
+ *                     Added SASNotifyPrimitiveMasks field to
+ *                     MPI2_CONFIG_PAGE_IOC_7.
+ * 03-09-11  02.00.19  Fixed IO Unit Page 10 (to match the spec).
+ * 05-25-11  02.00.20  Cleaned up a few comments.
+ * 08-24-11  02.00.21  Marked the IO Unit Page 7 PowerManagementCapabilities
+ *                     for PCIe link as obsolete.
+ *                     Added SpinupFlags field containing a Disable Spin-up bit
+ *                     to the MPI2_SAS_IOUNIT4_SPINUP_GROUP fields of SAS IO
+ *                     Unit Page 4.
+ * 11-18-11  02.00.22  Added define MPI2_IOCPAGE6_CAP_FLAGS_4K_SECTORS_SUPPORT.
+ *                     Added UEFIVersion field to BIOS Page 1 and defined new
+ *                     BiosOptions bits.
+ *                     Incorporating additions for MPI v2.5.
+ * --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_CNFG_H
+#define MPI2_CNFG_H
+
+/*****************************************************************************
+*  Configuration Page Header and defines
+*****************************************************************************/
+
+/*Config Page Header */
+typedef struct _MPI2_CONFIG_PAGE_HEADER {
+	U8                 PageVersion;                /*0x00 */
+	U8                 PageLength;                 /*0x01 */
+	U8                 PageNumber;                 /*0x02 */
+	U8                 PageType;                   /*0x03 */
+} MPI2_CONFIG_PAGE_HEADER, *PTR_MPI2_CONFIG_PAGE_HEADER,
+	Mpi2ConfigPageHeader_t, *pMpi2ConfigPageHeader_t;
+
+typedef union _MPI2_CONFIG_PAGE_HEADER_UNION {
+	MPI2_CONFIG_PAGE_HEADER  Struct;
+	U8                       Bytes[4];
+	U16                      Word16[2];
+	U32                      Word32;
+} MPI2_CONFIG_PAGE_HEADER_UNION, *PTR_MPI2_CONFIG_PAGE_HEADER_UNION,
+	Mpi2ConfigPageHeaderUnion, *pMpi2ConfigPageHeaderUnion;
+
+/*Extended Config Page Header */
+typedef struct _MPI2_CONFIG_EXTENDED_PAGE_HEADER {
+	U8                  PageVersion;                /*0x00 */
+	U8                  Reserved1;                  /*0x01 */
+	U8                  PageNumber;                 /*0x02 */
+	U8                  PageType;                   /*0x03 */
+	U16                 ExtPageLength;              /*0x04 */
+	U8                  ExtPageType;                /*0x06 */
+	U8                  Reserved2;                  /*0x07 */
+} MPI2_CONFIG_EXTENDED_PAGE_HEADER,
+	*PTR_MPI2_CONFIG_EXTENDED_PAGE_HEADER,
+	Mpi2ConfigExtendedPageHeader_t,
+	*pMpi2ConfigExtendedPageHeader_t;
+
+typedef union _MPI2_CONFIG_EXT_PAGE_HEADER_UNION {
+	MPI2_CONFIG_PAGE_HEADER          Struct;
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER Ext;
+	U8                               Bytes[8];
+	U16                              Word16[4];
+	U32                              Word32[2];
+} MPI2_CONFIG_EXT_PAGE_HEADER_UNION,
+	*PTR_MPI2_CONFIG_EXT_PAGE_HEADER_UNION,
+	Mpi2ConfigPageExtendedHeaderUnion,
+	*pMpi2ConfigPageExtendedHeaderUnion;
+
+
+/*PageType field values */
+#define MPI2_CONFIG_PAGEATTR_READ_ONLY              (0x00)
+#define MPI2_CONFIG_PAGEATTR_CHANGEABLE             (0x10)
+#define MPI2_CONFIG_PAGEATTR_PERSISTENT             (0x20)
+#define MPI2_CONFIG_PAGEATTR_MASK                   (0xF0)
+
+#define MPI2_CONFIG_PAGETYPE_IO_UNIT                (0x00)
+#define MPI2_CONFIG_PAGETYPE_IOC                    (0x01)
+#define MPI2_CONFIG_PAGETYPE_BIOS                   (0x02)
+#define MPI2_CONFIG_PAGETYPE_RAID_VOLUME            (0x08)
+#define MPI2_CONFIG_PAGETYPE_MANUFACTURING          (0x09)
+#define MPI2_CONFIG_PAGETYPE_RAID_PHYSDISK          (0x0A)
+#define MPI2_CONFIG_PAGETYPE_EXTENDED               (0x0F)
+#define MPI2_CONFIG_PAGETYPE_MASK                   (0x0F)
+
+#define MPI2_CONFIG_TYPENUM_MASK                    (0x0FFF)
+
+
+/*ExtPageType field values */
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_IO_UNIT         (0x10)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_EXPANDER        (0x11)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_DEVICE          (0x12)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_PHY             (0x13)
+#define MPI2_CONFIG_EXTPAGETYPE_LOG                 (0x14)
+#define MPI2_CONFIG_EXTPAGETYPE_ENCLOSURE           (0x15)
+#define MPI2_CONFIG_EXTPAGETYPE_RAID_CONFIG         (0x16)
+#define MPI2_CONFIG_EXTPAGETYPE_DRIVER_MAPPING      (0x17)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_PORT            (0x18)
+#define MPI2_CONFIG_EXTPAGETYPE_ETHERNET            (0x19)
+#define MPI2_CONFIG_EXTPAGETYPE_EXT_MANUFACTURING   (0x1A)
+
+
+/*****************************************************************************
+*  PageAddress defines
+*****************************************************************************/
+
+/*RAID Volume PageAddress format */
+#define MPI2_RAID_VOLUME_PGAD_FORM_MASK             (0xF0000000)
+#define MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE  (0x00000000)
+#define MPI2_RAID_VOLUME_PGAD_FORM_HANDLE           (0x10000000)
+
+#define MPI2_RAID_VOLUME_PGAD_HANDLE_MASK           (0x0000FFFF)
+
+
+/*RAID Physical Disk PageAddress format */
+#define MPI2_PHYSDISK_PGAD_FORM_MASK                    (0xF0000000)
+#define MPI2_PHYSDISK_PGAD_FORM_GET_NEXT_PHYSDISKNUM    (0x00000000)
+#define MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM             (0x10000000)
+#define MPI2_PHYSDISK_PGAD_FORM_DEVHANDLE               (0x20000000)
+
+#define MPI2_PHYSDISK_PGAD_PHYSDISKNUM_MASK             (0x000000FF)
+#define MPI2_PHYSDISK_PGAD_DEVHANDLE_MASK               (0x0000FFFF)
+
+
+/*SAS Expander PageAddress format */
+#define MPI2_SAS_EXPAND_PGAD_FORM_MASK              (0xF0000000)
+#define MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL     (0x00000000)
+#define MPI2_SAS_EXPAND_PGAD_FORM_HNDL_PHY_NUM      (0x10000000)
+#define MPI2_SAS_EXPAND_PGAD_FORM_HNDL              (0x20000000)
+
+#define MPI2_SAS_EXPAND_PGAD_HANDLE_MASK            (0x0000FFFF)
+#define MPI2_SAS_EXPAND_PGAD_PHYNUM_MASK            (0x00FF0000)
+#define MPI2_SAS_EXPAND_PGAD_PHYNUM_SHIFT           (16)
+
+
+/*SAS Device PageAddress format */
+#define MPI2_SAS_DEVICE_PGAD_FORM_MASK              (0xF0000000)
+#define MPI2_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE   (0x00000000)
+#define MPI2_SAS_DEVICE_PGAD_FORM_HANDLE            (0x20000000)
+
+#define MPI2_SAS_DEVICE_PGAD_HANDLE_MASK            (0x0000FFFF)
+
+
+/*SAS PHY PageAddress format */
+#define MPI2_SAS_PHY_PGAD_FORM_MASK                 (0xF0000000)
+#define MPI2_SAS_PHY_PGAD_FORM_PHY_NUMBER           (0x00000000)
+#define MPI2_SAS_PHY_PGAD_FORM_PHY_TBL_INDEX        (0x10000000)
+
+#define MPI2_SAS_PHY_PGAD_PHY_NUMBER_MASK           (0x000000FF)
+#define MPI2_SAS_PHY_PGAD_PHY_TBL_INDEX_MASK        (0x0000FFFF)
+
+
+/*SAS Port PageAddress format */
+#define MPI2_SASPORT_PGAD_FORM_MASK                 (0xF0000000)
+#define MPI2_SASPORT_PGAD_FORM_GET_NEXT_PORT        (0x00000000)
+#define MPI2_SASPORT_PGAD_FORM_PORT_NUM             (0x10000000)
+
+#define MPI2_SASPORT_PGAD_PORTNUMBER_MASK           (0x00000FFF)
+
+
+/*SAS Enclosure PageAddress format */
+#define MPI2_SAS_ENCLOS_PGAD_FORM_MASK              (0xF0000000)
+#define MPI2_SAS_ENCLOS_PGAD_FORM_GET_NEXT_HANDLE   (0x00000000)
+#define MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE            (0x10000000)
+
+#define MPI2_SAS_ENCLOS_PGAD_HANDLE_MASK            (0x0000FFFF)
+
+
+/*RAID Configuration PageAddress format */
+#define MPI2_RAID_PGAD_FORM_MASK                    (0xF0000000)
+#define MPI2_RAID_PGAD_FORM_GET_NEXT_CONFIGNUM      (0x00000000)
+#define MPI2_RAID_PGAD_FORM_CONFIGNUM               (0x10000000)
+#define MPI2_RAID_PGAD_FORM_ACTIVE_CONFIG           (0x20000000)
+
+#define MPI2_RAID_PGAD_CONFIGNUM_MASK               (0x000000FF)
+
+
+/*Driver Persistent Mapping PageAddress format */
+#define MPI2_DPM_PGAD_FORM_MASK                     (0xF0000000)
+#define MPI2_DPM_PGAD_FORM_ENTRY_RANGE              (0x00000000)
+
+#define MPI2_DPM_PGAD_ENTRY_COUNT_MASK              (0x0FFF0000)
+#define MPI2_DPM_PGAD_ENTRY_COUNT_SHIFT             (16)
+#define MPI2_DPM_PGAD_START_ENTRY_MASK              (0x0000FFFF)
+
+
+/*Ethernet PageAddress format */
+#define MPI2_ETHERNET_PGAD_FORM_MASK                (0xF0000000)
+#define MPI2_ETHERNET_PGAD_FORM_IF_NUM              (0x00000000)
+
+#define MPI2_ETHERNET_PGAD_IF_NUMBER_MASK           (0x000000FF)
+
+
+
+/****************************************************************************
+*  Configuration messages
+****************************************************************************/
+
+/*Configuration Request Message */
+typedef struct _MPI2_CONFIG_REQUEST {
+	U8                      Action;                     /*0x00 */
+	U8                      SGLFlags;                   /*0x01 */
+	U8                      ChainOffset;                /*0x02 */
+	U8                      Function;                   /*0x03 */
+	U16                     ExtPageLength;              /*0x04 */
+	U8                      ExtPageType;                /*0x06 */
+	U8                      MsgFlags;                   /*0x07 */
+	U8                      VP_ID;                      /*0x08 */
+	U8                      VF_ID;                      /*0x09 */
+	U16                     Reserved1;                  /*0x0A */
+	U8                      Reserved2;                  /*0x0C */
+	U8                      ProxyVF_ID;                 /*0x0D */
+	U16                     Reserved4;                  /*0x0E */
+	U32                     Reserved3;                  /*0x10 */
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x14 */
+	U32                     PageAddress;                /*0x18 */
+	MPI2_SGE_IO_UNION       PageBufferSGE;              /*0x1C */
+} MPI2_CONFIG_REQUEST, *PTR_MPI2_CONFIG_REQUEST,
+	Mpi2ConfigRequest_t, *pMpi2ConfigRequest_t;
+
+/*values for the Action field */
+#define MPI2_CONFIG_ACTION_PAGE_HEADER              (0x00)
+#define MPI2_CONFIG_ACTION_PAGE_READ_CURRENT        (0x01)
+#define MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT       (0x02)
+#define MPI2_CONFIG_ACTION_PAGE_DEFAULT             (0x03)
+#define MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM         (0x04)
+#define MPI2_CONFIG_ACTION_PAGE_READ_DEFAULT        (0x05)
+#define MPI2_CONFIG_ACTION_PAGE_READ_NVRAM          (0x06)
+#define MPI2_CONFIG_ACTION_PAGE_GET_CHANGEABLE      (0x07)
+
+/*use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
+
+
+/*Config Reply Message */
+typedef struct _MPI2_CONFIG_REPLY {
+	U8                      Action;                     /*0x00 */
+	U8                      SGLFlags;                   /*0x01 */
+	U8                      MsgLength;                  /*0x02 */
+	U8                      Function;                   /*0x03 */
+	U16                     ExtPageLength;              /*0x04 */
+	U8                      ExtPageType;                /*0x06 */
+	U8                      MsgFlags;                   /*0x07 */
+	U8                      VP_ID;                      /*0x08 */
+	U8                      VF_ID;                      /*0x09 */
+	U16                     Reserved1;                  /*0x0A */
+	U16                     Reserved2;                  /*0x0C */
+	U16                     IOCStatus;                  /*0x0E */
+	U32                     IOCLogInfo;                 /*0x10 */
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x14 */
+} MPI2_CONFIG_REPLY, *PTR_MPI2_CONFIG_REPLY,
+	Mpi2ConfigReply_t, *pMpi2ConfigReply_t;
+
+
+
+/*****************************************************************************
+*
+*              C o n f i g u r a t i o n    P a g e s
+*
+*****************************************************************************/
+
+/****************************************************************************
+*  Manufacturing Config pages
+****************************************************************************/
+
+#define MPI2_MFGPAGE_VENDORID_LSI                   (0x1000)
+
+/*MPI v2.0 SAS products */
+#define MPI2_MFGPAGE_DEVID_SAS2004                  (0x0070)
+#define MPI2_MFGPAGE_DEVID_SAS2008                  (0x0072)
+#define MPI2_MFGPAGE_DEVID_SAS2108_1                (0x0074)
+#define MPI2_MFGPAGE_DEVID_SAS2108_2                (0x0076)
+#define MPI2_MFGPAGE_DEVID_SAS2108_3                (0x0077)
+#define MPI2_MFGPAGE_DEVID_SAS2116_1                (0x0064)
+#define MPI2_MFGPAGE_DEVID_SAS2116_2                (0x0065)
+
+#define MPI2_MFGPAGE_DEVID_SSS6200                  (0x007E)
+
+#define MPI2_MFGPAGE_DEVID_SAS2208_1                (0x0080)
+#define MPI2_MFGPAGE_DEVID_SAS2208_2                (0x0081)
+#define MPI2_MFGPAGE_DEVID_SAS2208_3                (0x0082)
+#define MPI2_MFGPAGE_DEVID_SAS2208_4                (0x0083)
+#define MPI2_MFGPAGE_DEVID_SAS2208_5                (0x0084)
+#define MPI2_MFGPAGE_DEVID_SAS2208_6                (0x0085)
+#define MPI2_MFGPAGE_DEVID_SAS2308_1                (0x0086)
+#define MPI2_MFGPAGE_DEVID_SAS2308_2                (0x0087)
+#define MPI2_MFGPAGE_DEVID_SAS2308_3                (0x006E)
+
+/*MPI v2.5 SAS products */
+#define MPI25_MFGPAGE_DEVID_SAS3004                 (0x0096)
+#define MPI25_MFGPAGE_DEVID_SAS3008                 (0x0097)
+#define MPI25_MFGPAGE_DEVID_SAS3108_1               (0x0090)
+#define MPI25_MFGPAGE_DEVID_SAS3108_2               (0x0091)
+#define MPI25_MFGPAGE_DEVID_SAS3108_5               (0x0094)
+#define MPI25_MFGPAGE_DEVID_SAS3108_6               (0x0095)
+
+
+
+
+/*Manufacturing Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_0 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U8                      ChipName[16];               /*0x04 */
+	U8                      ChipRevision[8];            /*0x14 */
+	U8                      BoardName[16];              /*0x1C */
+	U8                      BoardAssembly[16];          /*0x2C */
+	U8                      BoardTracerNumber[16];      /*0x3C */
+} MPI2_CONFIG_PAGE_MAN_0,
+	*PTR_MPI2_CONFIG_PAGE_MAN_0,
+	Mpi2ManufacturingPage0_t,
+	*pMpi2ManufacturingPage0_t;
+
+#define MPI2_MANUFACTURING0_PAGEVERSION                (0x00)
+
+
+/*Manufacturing Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_1 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U8                      VPD[256];                   /*0x04 */
+} MPI2_CONFIG_PAGE_MAN_1,
+	*PTR_MPI2_CONFIG_PAGE_MAN_1,
+	Mpi2ManufacturingPage1_t,
+	*pMpi2ManufacturingPage1_t;
+
+#define MPI2_MANUFACTURING1_PAGEVERSION                (0x00)
+
+
+typedef struct _MPI2_CHIP_REVISION_ID {
+	U16 DeviceID;                                       /*0x00 */
+	U8  PCIRevisionID;                                  /*0x02 */
+	U8  Reserved;                                       /*0x03 */
+} MPI2_CHIP_REVISION_ID, *PTR_MPI2_CHIP_REVISION_ID,
+	Mpi2ChipRevisionId_t, *pMpi2ChipRevisionId_t;
+
+
+/*Manufacturing Page 2 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check Header.PageLength at runtime.
+ */
+#ifndef MPI2_MAN_PAGE_2_HW_SETTINGS_WORDS
+#define MPI2_MAN_PAGE_2_HW_SETTINGS_WORDS   (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_2 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	MPI2_CHIP_REVISION_ID   ChipId;                     /*0x04 */
+	U32
+		HwSettings[MPI2_MAN_PAGE_2_HW_SETTINGS_WORDS];/*0x08 */
+} MPI2_CONFIG_PAGE_MAN_2,
+	*PTR_MPI2_CONFIG_PAGE_MAN_2,
+	Mpi2ManufacturingPage2_t,
+	*pMpi2ManufacturingPage2_t;
+
+#define MPI2_MANUFACTURING2_PAGEVERSION                 (0x00)
+
+
+/*Manufacturing Page 3 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check Header.PageLength at runtime.
+ */
+#ifndef MPI2_MAN_PAGE_3_INFO_WORDS
+#define MPI2_MAN_PAGE_3_INFO_WORDS          (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_3 {
+	MPI2_CONFIG_PAGE_HEADER             Header;         /*0x00 */
+	MPI2_CHIP_REVISION_ID               ChipId;         /*0x04 */
+	U32
+		Info[MPI2_MAN_PAGE_3_INFO_WORDS];/*0x08 */
+} MPI2_CONFIG_PAGE_MAN_3,
+	*PTR_MPI2_CONFIG_PAGE_MAN_3,
+	Mpi2ManufacturingPage3_t,
+	*pMpi2ManufacturingPage3_t;
+
+#define MPI2_MANUFACTURING3_PAGEVERSION                 (0x00)
+
+
+/*Manufacturing Page 4 */
+
+typedef struct _MPI2_MANPAGE4_PWR_SAVE_SETTINGS {
+	U8                          PowerSaveFlags;                 /*0x00 */
+	U8                          InternalOperationsSleepTime;    /*0x01 */
+	U8                          InternalOperationsRunTime;      /*0x02 */
+	U8                          HostIdleTime;                   /*0x03 */
+} MPI2_MANPAGE4_PWR_SAVE_SETTINGS,
+	*PTR_MPI2_MANPAGE4_PWR_SAVE_SETTINGS,
+	Mpi2ManPage4PwrSaveSettings_t,
+	*pMpi2ManPage4PwrSaveSettings_t;
+
+/*defines for the PowerSaveFlags field */
+#define MPI2_MANPAGE4_MASK_POWERSAVE_MODE               (0x03)
+#define MPI2_MANPAGE4_POWERSAVE_MODE_DISABLED           (0x00)
+#define MPI2_MANPAGE4_CUSTOM_POWERSAVE_MODE             (0x01)
+#define MPI2_MANPAGE4_FULL_POWERSAVE_MODE               (0x02)
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_4 {
+	MPI2_CONFIG_PAGE_HEADER             Header;                 /*0x00 */
+	U32                                 Reserved1;              /*0x04 */
+	U32                                 Flags;                  /*0x08 */
+	U8                                  InquirySize;            /*0x0C */
+	U8                                  Reserved2;              /*0x0D */
+	U16                                 Reserved3;              /*0x0E */
+	U8                                  InquiryData[56];        /*0x10 */
+	U32                                 RAID0VolumeSettings;    /*0x48 */
+	U32                                 RAID1EVolumeSettings;   /*0x4C */
+	U32                                 RAID1VolumeSettings;    /*0x50 */
+	U32                                 RAID10VolumeSettings;   /*0x54 */
+	U32                                 Reserved4;              /*0x58 */
+	U32                                 Reserved5;              /*0x5C */
+	MPI2_MANPAGE4_PWR_SAVE_SETTINGS     PowerSaveSettings;      /*0x60 */
+	U8                                  MaxOCEDisks;            /*0x64 */
+	U8                                  ResyncRate;             /*0x65 */
+	U16                                 DataScrubDuration;      /*0x66 */
+	U8                                  MaxHotSpares;           /*0x68 */
+	U8                                  MaxPhysDisksPerVol;     /*0x69 */
+	U8                                  MaxPhysDisks;           /*0x6A */
+	U8                                  MaxVolumes;             /*0x6B */
+} MPI2_CONFIG_PAGE_MAN_4,
+	*PTR_MPI2_CONFIG_PAGE_MAN_4,
+	Mpi2ManufacturingPage4_t,
+	*pMpi2ManufacturingPage4_t;
+
+#define MPI2_MANUFACTURING4_PAGEVERSION                 (0x0A)
+
+/*Manufacturing Page 4 Flags field */
+#define MPI2_MANPAGE4_METADATA_SIZE_MASK                (0x00030000)
+#define MPI2_MANPAGE4_METADATA_512MB                    (0x00000000)
+
+#define MPI2_MANPAGE4_MIX_SSD_SAS_SATA                  (0x00008000)
+#define MPI2_MANPAGE4_MIX_SSD_AND_NON_SSD               (0x00004000)
+#define MPI2_MANPAGE4_HIDE_PHYSDISK_NON_IR              (0x00002000)
+
+#define MPI2_MANPAGE4_MASK_PHYSDISK_COERCION            (0x00001C00)
+#define MPI2_MANPAGE4_PHYSDISK_COERCION_1GB             (0x00000000)
+#define MPI2_MANPAGE4_PHYSDISK_128MB_COERCION           (0x00000400)
+#define MPI2_MANPAGE4_PHYSDISK_ADAPTIVE_COERCION        (0x00000800)
+#define MPI2_MANPAGE4_PHYSDISK_ZERO_COERCION            (0x00000C00)
+
+#define MPI2_MANPAGE4_MASK_BAD_BLOCK_MARKING            (0x00000300)
+#define MPI2_MANPAGE4_DEFAULT_BAD_BLOCK_MARKING         (0x00000000)
+#define MPI2_MANPAGE4_TABLE_BAD_BLOCK_MARKING           (0x00000100)
+#define MPI2_MANPAGE4_WRITE_LONG_BAD_BLOCK_MARKING      (0x00000200)
+
+#define MPI2_MANPAGE4_FORCE_OFFLINE_FAILOVER            (0x00000080)
+#define MPI2_MANPAGE4_RAID10_DISABLE                    (0x00000040)
+#define MPI2_MANPAGE4_RAID1E_DISABLE                    (0x00000020)
+#define MPI2_MANPAGE4_RAID1_DISABLE                     (0x00000010)
+#define MPI2_MANPAGE4_RAID0_DISABLE                     (0x00000008)
+#define MPI2_MANPAGE4_IR_MODEPAGE8_DISABLE              (0x00000004)
+#define MPI2_MANPAGE4_IM_RESYNC_CACHE_ENABLE            (0x00000002)
+#define MPI2_MANPAGE4_IR_NO_MIX_SAS_SATA                (0x00000001)
+
+
+/*Manufacturing Page 5 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhys at runtime.
+ */
+#ifndef MPI2_MAN_PAGE_5_PHY_ENTRIES
+#define MPI2_MAN_PAGE_5_PHY_ENTRIES         (1)
+#endif
+
+typedef struct _MPI2_MANUFACTURING5_ENTRY {
+	U64                                 WWID;           /*0x00 */
+	U64                                 DeviceName;     /*0x08 */
+} MPI2_MANUFACTURING5_ENTRY,
+	*PTR_MPI2_MANUFACTURING5_ENTRY,
+	Mpi2Manufacturing5Entry_t,
+	*pMpi2Manufacturing5Entry_t;
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_5 {
+	MPI2_CONFIG_PAGE_HEADER             Header;         /*0x00 */
+	U8                                  NumPhys;        /*0x04 */
+	U8                                  Reserved1;      /*0x05 */
+	U16                                 Reserved2;      /*0x06 */
+	U32                                 Reserved3;      /*0x08 */
+	U32                                 Reserved4;      /*0x0C */
+	MPI2_MANUFACTURING5_ENTRY
+		Phy[MPI2_MAN_PAGE_5_PHY_ENTRIES];/*0x08 */
+} MPI2_CONFIG_PAGE_MAN_5,
+	*PTR_MPI2_CONFIG_PAGE_MAN_5,
+	Mpi2ManufacturingPage5_t,
+	*pMpi2ManufacturingPage5_t;
+
+#define MPI2_MANUFACTURING5_PAGEVERSION                 (0x03)
+
+
+/*Manufacturing Page 6 */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_6 {
+	MPI2_CONFIG_PAGE_HEADER         Header;             /*0x00 */
+	U32                             ProductSpecificInfo;/*0x04 */
+} MPI2_CONFIG_PAGE_MAN_6,
+	*PTR_MPI2_CONFIG_PAGE_MAN_6,
+	Mpi2ManufacturingPage6_t,
+	*pMpi2ManufacturingPage6_t;
+
+#define MPI2_MANUFACTURING6_PAGEVERSION                 (0x00)
+
+
+/*Manufacturing Page 7 */
+
+typedef struct _MPI2_MANPAGE7_CONNECTOR_INFO {
+	U32                         Pinout;                 /*0x00 */
+	U8                          Connector[16];          /*0x04 */
+	U8                          Location;               /*0x14 */
+	U8                          ReceptacleID;           /*0x15 */
+	U16                         Slot;                   /*0x16 */
+	U32                         Reserved2;              /*0x18 */
+} MPI2_MANPAGE7_CONNECTOR_INFO,
+	*PTR_MPI2_MANPAGE7_CONNECTOR_INFO,
+	Mpi2ManPage7ConnectorInfo_t,
+	*pMpi2ManPage7ConnectorInfo_t;
+
+/*defines for the Pinout field */
+#define MPI2_MANPAGE7_PINOUT_LANE_MASK                  (0x0000FF00)
+#define MPI2_MANPAGE7_PINOUT_LANE_SHIFT                 (8)
+
+#define MPI2_MANPAGE7_PINOUT_TYPE_MASK                  (0x000000FF)
+#define MPI2_MANPAGE7_PINOUT_TYPE_UNKNOWN               (0x00)
+#define MPI2_MANPAGE7_PINOUT_SATA_SINGLE                (0x01)
+#define MPI2_MANPAGE7_PINOUT_SFF_8482                   (0x02)
+#define MPI2_MANPAGE7_PINOUT_SFF_8486                   (0x03)
+#define MPI2_MANPAGE7_PINOUT_SFF_8484                   (0x04)
+#define MPI2_MANPAGE7_PINOUT_SFF_8087                   (0x05)
+#define MPI2_MANPAGE7_PINOUT_SFF_8643_4I                (0x06)
+#define MPI2_MANPAGE7_PINOUT_SFF_8643_8I                (0x07)
+#define MPI2_MANPAGE7_PINOUT_SFF_8470                   (0x08)
+#define MPI2_MANPAGE7_PINOUT_SFF_8088                   (0x09)
+#define MPI2_MANPAGE7_PINOUT_SFF_8644_4X                (0x0A)
+#define MPI2_MANPAGE7_PINOUT_SFF_8644_8X                (0x0B)
+#define MPI2_MANPAGE7_PINOUT_SFF_8644_16X               (0x0C)
+#define MPI2_MANPAGE7_PINOUT_SFF_8436                   (0x0D)
+
+/*defines for the Location field */
+#define MPI2_MANPAGE7_LOCATION_UNKNOWN                  (0x01)
+#define MPI2_MANPAGE7_LOCATION_INTERNAL                 (0x02)
+#define MPI2_MANPAGE7_LOCATION_EXTERNAL                 (0x04)
+#define MPI2_MANPAGE7_LOCATION_SWITCHABLE               (0x08)
+#define MPI2_MANPAGE7_LOCATION_AUTO                     (0x10)
+#define MPI2_MANPAGE7_LOCATION_NOT_PRESENT              (0x20)
+#define MPI2_MANPAGE7_LOCATION_NOT_CONNECTED            (0x80)
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhys at runtime.
+ */
+#ifndef MPI2_MANPAGE7_CONNECTOR_INFO_MAX
+#define MPI2_MANPAGE7_CONNECTOR_INFO_MAX  (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_7 {
+	MPI2_CONFIG_PAGE_HEADER         Header;             /*0x00 */
+	U32                             Reserved1;          /*0x04 */
+	U32                             Reserved2;          /*0x08 */
+	U32                             Flags;              /*0x0C */
+	U8                              EnclosureName[16];  /*0x10 */
+	U8                              NumPhys;            /*0x20 */
+	U8                              Reserved3;          /*0x21 */
+	U16                             Reserved4;          /*0x22 */
+	MPI2_MANPAGE7_CONNECTOR_INFO
+	ConnectorInfo[MPI2_MANPAGE7_CONNECTOR_INFO_MAX]; /*0x24 */
+} MPI2_CONFIG_PAGE_MAN_7,
+	*PTR_MPI2_CONFIG_PAGE_MAN_7,
+	Mpi2ManufacturingPage7_t,
+	*pMpi2ManufacturingPage7_t;
+
+#define MPI2_MANUFACTURING7_PAGEVERSION                 (0x01)
+
+/*defines for the Flags field */
+#define MPI2_MANPAGE7_FLAG_USE_SLOT_INFO                (0x00000001)
+
+
+/*
+ *Generic structure to use for product-specific manufacturing pages
+ *(currently Manufacturing Page 8 through Manufacturing Page 31).
+ */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_PS {
+	MPI2_CONFIG_PAGE_HEADER         Header;             /*0x00 */
+	U32                             ProductSpecificInfo;/*0x04 */
+} MPI2_CONFIG_PAGE_MAN_PS,
+	*PTR_MPI2_CONFIG_PAGE_MAN_PS,
+	Mpi2ManufacturingPagePS_t,
+	*pMpi2ManufacturingPagePS_t;
+
+#define MPI2_MANUFACTURING8_PAGEVERSION                 (0x00)
+#define MPI2_MANUFACTURING9_PAGEVERSION                 (0x00)
+#define MPI2_MANUFACTURING10_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING11_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING12_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING13_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING14_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING15_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING16_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING17_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING18_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING19_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING20_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING21_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING22_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING23_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING24_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING25_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING26_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING27_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING28_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING29_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING30_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING31_PAGEVERSION                (0x00)
+
+
+/****************************************************************************
+*  IO Unit Config Pages
+****************************************************************************/
+
+/*IO Unit Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_0 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U64                     UniqueValue;                /*0x04 */
+	MPI2_VERSION_UNION      NvdataVersionDefault;       /*0x08 */
+	MPI2_VERSION_UNION      NvdataVersionPersistent;    /*0x0A */
+} MPI2_CONFIG_PAGE_IO_UNIT_0,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_0,
+	Mpi2IOUnitPage0_t, *pMpi2IOUnitPage0_t;
+
+#define MPI2_IOUNITPAGE0_PAGEVERSION                    (0x02)
+
+
+/*IO Unit Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U32                     Flags;                      /*0x04 */
+} MPI2_CONFIG_PAGE_IO_UNIT_1,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_1,
+	Mpi2IOUnitPage1_t, *pMpi2IOUnitPage1_t;
+
+#define MPI2_IOUNITPAGE1_PAGEVERSION                    (0x04)
+
+/*IO Unit Page 1 Flags defines */
+#define MPI25_IOUNITPAGE1_NEW_DEVICE_FAST_PATH_DISABLE  (0x00002000)
+#define MPI25_IOUNITPAGE1_DISABLE_FAST_PATH             (0x00001000)
+#define MPI2_IOUNITPAGE1_ENABLE_HOST_BASED_DISCOVERY    (0x00000800)
+#define MPI2_IOUNITPAGE1_MASK_SATA_WRITE_CACHE          (0x00000600)
+#define MPI2_IOUNITPAGE1_SATA_WRITE_CACHE_SHIFT         (9)
+#define MPI2_IOUNITPAGE1_ENABLE_SATA_WRITE_CACHE        (0x00000000)
+#define MPI2_IOUNITPAGE1_DISABLE_SATA_WRITE_CACHE       (0x00000200)
+#define MPI2_IOUNITPAGE1_UNCHANGED_SATA_WRITE_CACHE     (0x00000400)
+#define MPI2_IOUNITPAGE1_NATIVE_COMMAND_Q_DISABLE       (0x00000100)
+#define MPI2_IOUNITPAGE1_DISABLE_IR                     (0x00000040)
+#define MPI2_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING (0x00000020)
+#define MPI2_IOUNITPAGE1_IR_USE_STATIC_VOLUME_ID        (0x00000004)
+
+
+/*IO Unit Page 3 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for GPIOCount at runtime.
+ */
+#ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
+#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3 {
+	MPI2_CONFIG_PAGE_HEADER Header;			 /*0x00 */
+	U8                      GPIOCount;		 /*0x04 */
+	U8                      Reserved1;		 /*0x05 */
+	U16                     Reserved2;		 /*0x06 */
+	U16
+		GPIOVal[MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX];/*0x08 */
+} MPI2_CONFIG_PAGE_IO_UNIT_3,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_3,
+	Mpi2IOUnitPage3_t, *pMpi2IOUnitPage3_t;
+
+#define MPI2_IOUNITPAGE3_PAGEVERSION                    (0x01)
+
+/*defines for IO Unit Page 3 GPIOVal field */
+#define MPI2_IOUNITPAGE3_GPIO_FUNCTION_MASK             (0xFFFC)
+#define MPI2_IOUNITPAGE3_GPIO_FUNCTION_SHIFT            (2)
+#define MPI2_IOUNITPAGE3_GPIO_SETTING_OFF               (0x0000)
+#define MPI2_IOUNITPAGE3_GPIO_SETTING_ON                (0x0001)
+
+
+/*IO Unit Page 5 */
+
+/*
+ *Upper layer code (drivers, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumDmaEngines at runtime.
+ */
+#ifndef MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES
+#define MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_5 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U64
+		RaidAcceleratorBufferBaseAddress;           /*0x04 */
+	U64
+		RaidAcceleratorBufferSize;                  /*0x0C */
+	U64
+		RaidAcceleratorControlBaseAddress;          /*0x14 */
+	U8                      RAControlSize;              /*0x1C */
+	U8                      NumDmaEngines;              /*0x1D */
+	U8                      RAMinControlSize;           /*0x1E */
+	U8                      RAMaxControlSize;           /*0x1F */
+	U32                     Reserved1;                  /*0x20 */
+	U32                     Reserved2;                  /*0x24 */
+	U32                     Reserved3;                  /*0x28 */
+	U32
+	DmaEngineCapabilities[MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES]; /*0x2C */
+} MPI2_CONFIG_PAGE_IO_UNIT_5,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_5,
+	Mpi2IOUnitPage5_t, *pMpi2IOUnitPage5_t;
+
+#define MPI2_IOUNITPAGE5_PAGEVERSION                    (0x00)
+
+/*defines for IO Unit Page 5 DmaEngineCapabilities field */
+#define MPI2_IOUNITPAGE5_DMA_CAP_MASK_MAX_REQUESTS      (0xFF00)
+#define MPI2_IOUNITPAGE5_DMA_CAP_SHIFT_MAX_REQUESTS     (16)
+
+#define MPI2_IOUNITPAGE5_DMA_CAP_EEDP                   (0x0008)
+#define MPI2_IOUNITPAGE5_DMA_CAP_PARITY_GENERATION      (0x0004)
+#define MPI2_IOUNITPAGE5_DMA_CAP_HASHING                (0x0002)
+#define MPI2_IOUNITPAGE5_DMA_CAP_ENCRYPTION             (0x0001)
+
+
+/*IO Unit Page 6 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_6 {
+	MPI2_CONFIG_PAGE_HEADER Header;                 /*0x00 */
+	U16                     Flags;                  /*0x04 */
+	U8                      RAHostControlSize;      /*0x06 */
+	U8                      Reserved0;              /*0x07 */
+	U64
+		RaidAcceleratorHostControlBaseAddress;  /*0x08 */
+	U32                     Reserved1;              /*0x10 */
+	U32                     Reserved2;              /*0x14 */
+	U32                     Reserved3;              /*0x18 */
+} MPI2_CONFIG_PAGE_IO_UNIT_6,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_6,
+	Mpi2IOUnitPage6_t, *pMpi2IOUnitPage6_t;
+
+#define MPI2_IOUNITPAGE6_PAGEVERSION                    (0x00)
+
+/*defines for IO Unit Page 6 Flags field */
+#define MPI2_IOUNITPAGE6_FLAGS_ENABLE_RAID_ACCELERATOR  (0x0001)
+
+
+/*IO Unit Page 7 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_7 {
+	MPI2_CONFIG_PAGE_HEADER Header;                 /*0x00 */
+	U8                      CurrentPowerMode;       /*0x04 */
+	U8                      PreviousPowerMode;      /*0x05 */
+	U8                      PCIeWidth;              /*0x06 */
+	U8                      PCIeSpeed;              /*0x07 */
+	U32                     ProcessorState;         /*0x08 */
+	U32
+		PowerManagementCapabilities;            /*0x0C */
+	U16                     IOCTemperature;         /*0x10 */
+	U8
+		IOCTemperatureUnits;                    /*0x12 */
+	U8                      IOCSpeed;               /*0x13 */
+	U16                     BoardTemperature;       /*0x14 */
+	U8
+		BoardTemperatureUnits;                  /*0x16 */
+	U8                      Reserved3;              /*0x17 */
+} MPI2_CONFIG_PAGE_IO_UNIT_7,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_7,
+	Mpi2IOUnitPage7_t, *pMpi2IOUnitPage7_t;
+
+#define MPI2_IOUNITPAGE7_PAGEVERSION                    (0x02)
+
+/*defines for IO Unit Page 7 CurrentPowerMode and PreviousPowerMode fields */
+#define MPI25_IOUNITPAGE7_PM_INIT_MASK              (0xC0)
+#define MPI25_IOUNITPAGE7_PM_INIT_UNAVAILABLE       (0x00)
+#define MPI25_IOUNITPAGE7_PM_INIT_HOST              (0x40)
+#define MPI25_IOUNITPAGE7_PM_INIT_IO_UNIT           (0x80)
+#define MPI25_IOUNITPAGE7_PM_INIT_PCIE_DPA          (0xC0)
+
+#define MPI25_IOUNITPAGE7_PM_MODE_MASK              (0x07)
+#define MPI25_IOUNITPAGE7_PM_MODE_UNAVAILABLE       (0x00)
+#define MPI25_IOUNITPAGE7_PM_MODE_UNKNOWN           (0x01)
+#define MPI25_IOUNITPAGE7_PM_MODE_FULL_POWER        (0x04)
+#define MPI25_IOUNITPAGE7_PM_MODE_REDUCED_POWER     (0x05)
+#define MPI25_IOUNITPAGE7_PM_MODE_STANDBY           (0x06)
+
+
+/*defines for IO Unit Page 7 PCIeWidth field */
+#define MPI2_IOUNITPAGE7_PCIE_WIDTH_X1              (0x01)
+#define MPI2_IOUNITPAGE7_PCIE_WIDTH_X2              (0x02)
+#define MPI2_IOUNITPAGE7_PCIE_WIDTH_X4              (0x04)
+#define MPI2_IOUNITPAGE7_PCIE_WIDTH_X8              (0x08)
+
+/*defines for IO Unit Page 7 PCIeSpeed field */
+#define MPI2_IOUNITPAGE7_PCIE_SPEED_2_5_GBPS        (0x00)
+#define MPI2_IOUNITPAGE7_PCIE_SPEED_5_0_GBPS        (0x01)
+#define MPI2_IOUNITPAGE7_PCIE_SPEED_8_0_GBPS        (0x02)
+
+/*defines for IO Unit Page 7 ProcessorState field */
+#define MPI2_IOUNITPAGE7_PSTATE_MASK_SECOND         (0x0000000F)
+#define MPI2_IOUNITPAGE7_PSTATE_SHIFT_SECOND        (0)
+
+#define MPI2_IOUNITPAGE7_PSTATE_NOT_PRESENT         (0x00)
+#define MPI2_IOUNITPAGE7_PSTATE_DISABLED            (0x01)
+#define MPI2_IOUNITPAGE7_PSTATE_ENABLED             (0x02)
+
+/*defines for IO Unit Page 7 PowerManagementCapabilities field */
+#define MPI25_IOUNITPAGE7_PMCAP_DPA_FULL_PWR_MODE       (0x00400000)
+#define MPI25_IOUNITPAGE7_PMCAP_DPA_REDUCED_PWR_MODE    (0x00200000)
+#define MPI25_IOUNITPAGE7_PMCAP_DPA_STANDBY_MODE        (0x00100000)
+#define MPI25_IOUNITPAGE7_PMCAP_HOST_FULL_PWR_MODE      (0x00040000)
+#define MPI25_IOUNITPAGE7_PMCAP_HOST_REDUCED_PWR_MODE   (0x00020000)
+#define MPI25_IOUNITPAGE7_PMCAP_HOST_STANDBY_MODE       (0x00010000)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_FULL_PWR_MODE        (0x00004000)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_REDUCED_PWR_MODE     (0x00002000)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_STANDBY_MODE         (0x00001000)
+#define MPI2_IOUNITPAGE7_PMCAP_HOST_12_5_PCT_IOCSPEED   (0x00000400)
+#define MPI2_IOUNITPAGE7_PMCAP_HOST_25_0_PCT_IOCSPEED   (0x00000200)
+#define MPI2_IOUNITPAGE7_PMCAP_HOST_50_0_PCT_IOCSPEED   (0x00000100)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_12_5_PCT_IOCSPEED    (0x00000040)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_25_0_PCT_IOCSPEED    (0x00000020)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_50_0_PCT_IOCSPEED    (0x00000010)
+#define MPI2_IOUNITPAGE7_PMCAP_HOST_WIDTH_CHANGE_PCIE   (0x00000008)
+#define MPI2_IOUNITPAGE7_PMCAP_HOST_SPEED_CHANGE_PCIE   (0x00000004)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_WIDTH_CHANGE_PCIE    (0x00000002)
+#define MPI25_IOUNITPAGE7_PMCAP_IO_SPEED_CHANGE_PCIE    (0x00000001)
+
+/*obsolete names for the PowerManagementCapabilities bits (above) */
+#define MPI2_IOUNITPAGE7_PMCAP_12_5_PCT_IOCSPEED    (0x00000400)
+#define MPI2_IOUNITPAGE7_PMCAP_25_0_PCT_IOCSPEED    (0x00000200)
+#define MPI2_IOUNITPAGE7_PMCAP_50_0_PCT_IOCSPEED    (0x00000100)
+#define MPI2_IOUNITPAGE7_PMCAP_PCIE_WIDTH_CHANGE    (0x00000008) /*obsolete */
+#define MPI2_IOUNITPAGE7_PMCAP_PCIE_SPEED_CHANGE    (0x00000004) /*obsolete */
+
+
+/*defines for IO Unit Page 7 IOCTemperatureUnits field */
+#define MPI2_IOUNITPAGE7_IOC_TEMP_NOT_PRESENT       (0x00)
+#define MPI2_IOUNITPAGE7_IOC_TEMP_FAHRENHEIT        (0x01)
+#define MPI2_IOUNITPAGE7_IOC_TEMP_CELSIUS           (0x02)
+
+/*defines for IO Unit Page 7 IOCSpeed field */
+#define MPI2_IOUNITPAGE7_IOC_SPEED_FULL             (0x01)
+#define MPI2_IOUNITPAGE7_IOC_SPEED_HALF             (0x02)
+#define MPI2_IOUNITPAGE7_IOC_SPEED_QUARTER          (0x04)
+#define MPI2_IOUNITPAGE7_IOC_SPEED_EIGHTH           (0x08)
+
+/*defines for IO Unit Page 7 BoardTemperatureUnits field */
+#define MPI2_IOUNITPAGE7_BOARD_TEMP_NOT_PRESENT     (0x00)
+#define MPI2_IOUNITPAGE7_BOARD_TEMP_FAHRENHEIT      (0x01)
+#define MPI2_IOUNITPAGE7_BOARD_TEMP_CELSIUS         (0x02)
+
+
+/*IO Unit Page 8 */
+
+#define MPI2_IOUNIT8_NUM_THRESHOLDS     (4)
+
+typedef struct _MPI2_IOUNIT8_SENSOR {
+	U16                     Flags;                  /*0x00 */
+	U16                     Reserved1;              /*0x02 */
+	U16
+		Threshold[MPI2_IOUNIT8_NUM_THRESHOLDS]; /*0x04 */
+	U32                     Reserved2;              /*0x0C */
+	U32                     Reserved3;              /*0x10 */
+	U32                     Reserved4;              /*0x14 */
+} MPI2_IOUNIT8_SENSOR, *PTR_MPI2_IOUNIT8_SENSOR,
+	Mpi2IOUnit8Sensor_t, *pMpi2IOUnit8Sensor_t;
+
+/*defines for IO Unit Page 8 Sensor Flags field */
+#define MPI2_IOUNIT8_SENSOR_FLAGS_T3_ENABLE         (0x0008)
+#define MPI2_IOUNIT8_SENSOR_FLAGS_T2_ENABLE         (0x0004)
+#define MPI2_IOUNIT8_SENSOR_FLAGS_T1_ENABLE         (0x0002)
+#define MPI2_IOUNIT8_SENSOR_FLAGS_T0_ENABLE         (0x0001)
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumSensors at runtime.
+ */
+#ifndef MPI2_IOUNITPAGE8_SENSOR_ENTRIES
+#define MPI2_IOUNITPAGE8_SENSOR_ENTRIES     (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_8 {
+	MPI2_CONFIG_PAGE_HEADER Header;                 /*0x00 */
+	U32                     Reserved1;              /*0x04 */
+	U32                     Reserved2;              /*0x08 */
+	U8                      NumSensors;             /*0x0C */
+	U8                      PollingInterval;        /*0x0D */
+	U16                     Reserved3;              /*0x0E */
+	MPI2_IOUNIT8_SENSOR
+		Sensor[MPI2_IOUNITPAGE8_SENSOR_ENTRIES];/*0x10 */
+} MPI2_CONFIG_PAGE_IO_UNIT_8,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_8,
+	Mpi2IOUnitPage8_t, *pMpi2IOUnitPage8_t;
+
+#define MPI2_IOUNITPAGE8_PAGEVERSION                    (0x00)
+
+
+/*IO Unit Page 9 */
+
+typedef struct _MPI2_IOUNIT9_SENSOR {
+	U16                     CurrentTemperature;     /*0x00 */
+	U16                     Reserved1;              /*0x02 */
+	U8                      Flags;                  /*0x04 */
+	U8                      Reserved2;              /*0x05 */
+	U16                     Reserved3;              /*0x06 */
+	U32                     Reserved4;              /*0x08 */
+	U32                     Reserved5;              /*0x0C */
+} MPI2_IOUNIT9_SENSOR, *PTR_MPI2_IOUNIT9_SENSOR,
+	Mpi2IOUnit9Sensor_t, *pMpi2IOUnit9Sensor_t;
+
+/*defines for IO Unit Page 9 Sensor Flags field */
+#define MPI2_IOUNIT9_SENSOR_FLAGS_TEMP_VALID        (0x01)
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumSensors at runtime.
+ */
+#ifndef MPI2_IOUNITPAGE9_SENSOR_ENTRIES
+#define MPI2_IOUNITPAGE9_SENSOR_ENTRIES     (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_9 {
+	MPI2_CONFIG_PAGE_HEADER Header;                 /*0x00 */
+	U32                     Reserved1;              /*0x04 */
+	U32                     Reserved2;              /*0x08 */
+	U8                      NumSensors;             /*0x0C */
+	U8                      Reserved4;              /*0x0D */
+	U16                     Reserved3;              /*0x0E */
+	MPI2_IOUNIT9_SENSOR
+		Sensor[MPI2_IOUNITPAGE9_SENSOR_ENTRIES];/*0x10 */
+} MPI2_CONFIG_PAGE_IO_UNIT_9,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_9,
+	Mpi2IOUnitPage9_t, *pMpi2IOUnitPage9_t;
+
+#define MPI2_IOUNITPAGE9_PAGEVERSION                    (0x00)
+
+
+/*IO Unit Page 10 */
+
+typedef struct _MPI2_IOUNIT10_FUNCTION {
+	U8                      CreditPercent;      /*0x00 */
+	U8                      Reserved1;          /*0x01 */
+	U16                     Reserved2;          /*0x02 */
+} MPI2_IOUNIT10_FUNCTION,
+	*PTR_MPI2_IOUNIT10_FUNCTION,
+	Mpi2IOUnit10Function_t,
+	*pMpi2IOUnit10Function_t;
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumFunctions at runtime.
+ */
+#ifndef MPI2_IOUNITPAGE10_FUNCTION_ENTRIES
+#define MPI2_IOUNITPAGE10_FUNCTION_ENTRIES      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_10 {
+	MPI2_CONFIG_PAGE_HEADER Header;                      /*0x00 */
+	U8                      NumFunctions;                /*0x04 */
+	U8                      Reserved1;                   /*0x05 */
+	U16                     Reserved2;                   /*0x06 */
+	U32                     Reserved3;                   /*0x08 */
+	U32                     Reserved4;                   /*0x0C */
+	MPI2_IOUNIT10_FUNCTION
+		Function[MPI2_IOUNITPAGE10_FUNCTION_ENTRIES];/*0x10 */
+} MPI2_CONFIG_PAGE_IO_UNIT_10,
+	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_10,
+	Mpi2IOUnitPage10_t, *pMpi2IOUnitPage10_t;
+
+#define MPI2_IOUNITPAGE10_PAGEVERSION                   (0x01)
+
+
+
+/****************************************************************************
+*  IOC Config Pages
+****************************************************************************/
+
+/*IOC Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_0 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U32                     Reserved1;                  /*0x04 */
+	U32                     Reserved2;                  /*0x08 */
+	U16                     VendorID;                   /*0x0C */
+	U16                     DeviceID;                   /*0x0E */
+	U8                      RevisionID;                 /*0x10 */
+	U8                      Reserved3;                  /*0x11 */
+	U16                     Reserved4;                  /*0x12 */
+	U32                     ClassCode;                  /*0x14 */
+	U16                     SubsystemVendorID;          /*0x18 */
+	U16                     SubsystemID;                /*0x1A */
+} MPI2_CONFIG_PAGE_IOC_0,
+	*PTR_MPI2_CONFIG_PAGE_IOC_0,
+	Mpi2IOCPage0_t, *pMpi2IOCPage0_t;
+
+#define MPI2_IOCPAGE0_PAGEVERSION                       (0x02)
+
+
+/*IOC Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_1 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U32                     Flags;                      /*0x04 */
+	U32                     CoalescingTimeout;          /*0x08 */
+	U8                      CoalescingDepth;            /*0x0C */
+	U8                      PCISlotNum;                 /*0x0D */
+	U8                      PCIBusNum;                  /*0x0E */
+	U8                      PCIDomainSegment;           /*0x0F */
+	U32                     Reserved1;                  /*0x10 */
+	U32                     Reserved2;                  /*0x14 */
+} MPI2_CONFIG_PAGE_IOC_1,
+	*PTR_MPI2_CONFIG_PAGE_IOC_1,
+	Mpi2IOCPage1_t, *pMpi2IOCPage1_t;
+
+#define MPI2_IOCPAGE1_PAGEVERSION                       (0x05)
+
+/*defines for IOC Page 1 Flags field */
+#define MPI2_IOCPAGE1_REPLY_COALESCING                  (0x00000001)
+
+#define MPI2_IOCPAGE1_PCISLOTNUM_UNKNOWN                (0xFF)
+#define MPI2_IOCPAGE1_PCIBUSNUM_UNKNOWN                 (0xFF)
+#define MPI2_IOCPAGE1_PCIDOMAIN_UNKNOWN                 (0xFF)
+
+/*IOC Page 6 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_6 {
+	MPI2_CONFIG_PAGE_HEADER Header;         /*0x00 */
+	U32
+		CapabilitiesFlags;              /*0x04 */
+	U8                      MaxDrivesRAID0; /*0x08 */
+	U8                      MaxDrivesRAID1; /*0x09 */
+	U8
+		 MaxDrivesRAID1E;                /*0x0A */
+	U8
+		 MaxDrivesRAID10;		/*0x0B */
+	U8                      MinDrivesRAID0; /*0x0C */
+	U8                      MinDrivesRAID1; /*0x0D */
+	U8
+		 MinDrivesRAID1E;                /*0x0E */
+	U8
+		 MinDrivesRAID10;                /*0x0F */
+	U32                     Reserved1;      /*0x10 */
+	U8
+		 MaxGlobalHotSpares;             /*0x14 */
+	U8                      MaxPhysDisks;   /*0x15 */
+	U8                      MaxVolumes;     /*0x16 */
+	U8                      MaxConfigs;     /*0x17 */
+	U8                      MaxOCEDisks;    /*0x18 */
+	U8                      Reserved2;      /*0x19 */
+	U16                     Reserved3;      /*0x1A */
+	U32
+		SupportedStripeSizeMapRAID0;    /*0x1C */
+	U32
+		SupportedStripeSizeMapRAID1E;   /*0x20 */
+	U32
+		SupportedStripeSizeMapRAID10;   /*0x24 */
+	U32                     Reserved4;      /*0x28 */
+	U32                     Reserved5;      /*0x2C */
+	U16
+		DefaultMetadataSize;            /*0x30 */
+	U16                     Reserved6;      /*0x32 */
+	U16
+		MaxBadBlockTableEntries;        /*0x34 */
+	U16                     Reserved7;      /*0x36 */
+	U32
+		IRNvsramVersion;                /*0x38 */
+} MPI2_CONFIG_PAGE_IOC_6,
+	*PTR_MPI2_CONFIG_PAGE_IOC_6,
+	Mpi2IOCPage6_t, *pMpi2IOCPage6_t;
+
+#define MPI2_IOCPAGE6_PAGEVERSION                       (0x05)
+
+/*defines for IOC Page 6 CapabilitiesFlags */
+#define MPI2_IOCPAGE6_CAP_FLAGS_4K_SECTORS_SUPPORT      (0x00000020)
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID10_SUPPORT          (0x00000010)
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID1_SUPPORT           (0x00000008)
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID1E_SUPPORT          (0x00000004)
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID0_SUPPORT           (0x00000002)
+#define MPI2_IOCPAGE6_CAP_FLAGS_GLOBAL_HOT_SPARE        (0x00000001)
+
+
+/*IOC Page 7 */
+
+#define MPI2_IOCPAGE7_EVENTMASK_WORDS       (4)
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_7 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U32                     Reserved1;                  /*0x04 */
+	U32
+		EventMasks[MPI2_IOCPAGE7_EVENTMASK_WORDS];/*0x08 */
+	U16                     SASBroadcastPrimitiveMasks; /*0x18 */
+	U16                     SASNotifyPrimitiveMasks;    /*0x1A */
+	U32                     Reserved3;                  /*0x1C */
+} MPI2_CONFIG_PAGE_IOC_7,
+	*PTR_MPI2_CONFIG_PAGE_IOC_7,
+	Mpi2IOCPage7_t, *pMpi2IOCPage7_t;
+
+#define MPI2_IOCPAGE7_PAGEVERSION                       (0x02)
+
+
+/*IOC Page 8 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_8 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U8                      NumDevsPerEnclosure;        /*0x04 */
+	U8                      Reserved1;                  /*0x05 */
+	U16                     Reserved2;                  /*0x06 */
+	U16                     MaxPersistentEntries;       /*0x08 */
+	U16                     MaxNumPhysicalMappedIDs;    /*0x0A */
+	U16                     Flags;                      /*0x0C */
+	U16                     Reserved3;                  /*0x0E */
+	U16                     IRVolumeMappingFlags;       /*0x10 */
+	U16                     Reserved4;                  /*0x12 */
+	U32                     Reserved5;                  /*0x14 */
+} MPI2_CONFIG_PAGE_IOC_8,
+	*PTR_MPI2_CONFIG_PAGE_IOC_8,
+	Mpi2IOCPage8_t, *pMpi2IOCPage8_t;
+
+#define MPI2_IOCPAGE8_PAGEVERSION                       (0x00)
+
+/*defines for IOC Page 8 Flags field */
+#define MPI2_IOCPAGE8_FLAGS_DA_START_SLOT_1             (0x00000020)
+#define MPI2_IOCPAGE8_FLAGS_RESERVED_TARGETID_0         (0x00000010)
+
+#define MPI2_IOCPAGE8_FLAGS_MASK_MAPPING_MODE           (0x0000000E)
+#define MPI2_IOCPAGE8_FLAGS_DEVICE_PERSISTENCE_MAPPING  (0x00000000)
+#define MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING      (0x00000002)
+
+#define MPI2_IOCPAGE8_FLAGS_DISABLE_PERSISTENT_MAPPING  (0x00000001)
+#define MPI2_IOCPAGE8_FLAGS_ENABLE_PERSISTENT_MAPPING   (0x00000000)
+
+/*defines for IOC Page 8 IRVolumeMappingFlags */
+#define MPI2_IOCPAGE8_IRFLAGS_MASK_VOLUME_MAPPING_MODE  (0x00000003)
+#define MPI2_IOCPAGE8_IRFLAGS_LOW_VOLUME_MAPPING        (0x00000000)
+#define MPI2_IOCPAGE8_IRFLAGS_HIGH_VOLUME_MAPPING       (0x00000001)
+
+
+/****************************************************************************
+*  BIOS Config Pages
+****************************************************************************/
+
+/*BIOS Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U32                     BiosOptions;                /*0x04 */
+	U32                     IOCSettings;                /*0x08 */
+	U32                     Reserved1;                  /*0x0C */
+	U32                     DeviceSettings;             /*0x10 */
+	U16                     NumberOfDevices;            /*0x14 */
+	U16                     UEFIVersion;                /*0x16 */
+	U16                     IOTimeoutBlockDevicesNonRM; /*0x18 */
+	U16                     IOTimeoutSequential;        /*0x1A */
+	U16                     IOTimeoutOther;             /*0x1C */
+	U16                     IOTimeoutBlockDevicesRM;    /*0x1E */
+} MPI2_CONFIG_PAGE_BIOS_1,
+	*PTR_MPI2_CONFIG_PAGE_BIOS_1,
+	Mpi2BiosPage1_t, *pMpi2BiosPage1_t;
+
+#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x05)
+
+/*values for BIOS Page 1 BiosOptions field */
+#define MPI2_BIOSPAGE1_OPTIONS_MASK_UEFI_HII_REGISTRATION   (0x00000006)
+#define MPI2_BIOSPAGE1_OPTIONS_ENABLE_UEFI_HII              (0x00000000)
+#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_UEFI_HII             (0x00000002)
+#define MPI2_BIOSPAGE1_OPTIONS_VERSION_CHECK_UEFI_HII       (0x00000004)
+
+#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_BIOS                 (0x00000001)
+
+/*values for BIOS Page 1 IOCSettings field */
+#define MPI2_BIOSPAGE1_IOCSET_MASK_BOOT_PREFERENCE      (0x00030000)
+#define MPI2_BIOSPAGE1_IOCSET_ENCLOSURE_SLOT_BOOT       (0x00000000)
+#define MPI2_BIOSPAGE1_IOCSET_SAS_ADDRESS_BOOT          (0x00010000)
+
+#define MPI2_BIOSPAGE1_IOCSET_MASK_RM_SETTING           (0x000000C0)
+#define MPI2_BIOSPAGE1_IOCSET_NONE_RM_SETTING           (0x00000000)
+#define MPI2_BIOSPAGE1_IOCSET_BOOT_RM_SETTING           (0x00000040)
+#define MPI2_BIOSPAGE1_IOCSET_MEDIA_RM_SETTING          (0x00000080)
+
+#define MPI2_BIOSPAGE1_IOCSET_MASK_ADAPTER_SUPPORT      (0x00000030)
+#define MPI2_BIOSPAGE1_IOCSET_NO_SUPPORT                (0x00000000)
+#define MPI2_BIOSPAGE1_IOCSET_BIOS_SUPPORT              (0x00000010)
+#define MPI2_BIOSPAGE1_IOCSET_OS_SUPPORT                (0x00000020)
+#define MPI2_BIOSPAGE1_IOCSET_ALL_SUPPORT               (0x00000030)
+
+#define MPI2_BIOSPAGE1_IOCSET_ALTERNATE_CHS             (0x00000008)
+
+/*values for BIOS Page 1 DeviceSettings field */
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_SMART_POLLING     (0x00000010)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_SEQ_LUN           (0x00000008)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_RM_LUN            (0x00000004)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_NON_RM_LUN        (0x00000002)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_OTHER_LUN         (0x00000001)
+
+/*defines for BIOS Page 1 UEFIVersion field */
+#define MPI2_BIOSPAGE1_UEFI_VER_MAJOR_MASK              (0xFF00)
+#define MPI2_BIOSPAGE1_UEFI_VER_MAJOR_SHIFT             (8)
+#define MPI2_BIOSPAGE1_UEFI_VER_MINOR_MASK              (0x00FF)
+#define MPI2_BIOSPAGE1_UEFI_VER_MINOR_SHIFT             (0)
+
+
+
+/*BIOS Page 2 */
+
+typedef struct _MPI2_BOOT_DEVICE_ADAPTER_ORDER {
+	U32         Reserved1;                              /*0x00 */
+	U32         Reserved2;                              /*0x04 */
+	U32         Reserved3;                              /*0x08 */
+	U32         Reserved4;                              /*0x0C */
+	U32         Reserved5;                              /*0x10 */
+	U32         Reserved6;                              /*0x14 */
+} MPI2_BOOT_DEVICE_ADAPTER_ORDER,
+	*PTR_MPI2_BOOT_DEVICE_ADAPTER_ORDER,
+	Mpi2BootDeviceAdapterOrder_t,
+	*pMpi2BootDeviceAdapterOrder_t;
+
+typedef struct _MPI2_BOOT_DEVICE_SAS_WWID {
+	U64         SASAddress;                             /*0x00 */
+	U8          LUN[8];                                 /*0x08 */
+	U32         Reserved1;                              /*0x10 */
+	U32         Reserved2;                              /*0x14 */
+} MPI2_BOOT_DEVICE_SAS_WWID,
+	*PTR_MPI2_BOOT_DEVICE_SAS_WWID,
+	Mpi2BootDeviceSasWwid_t,
+	*pMpi2BootDeviceSasWwid_t;
+
+typedef struct _MPI2_BOOT_DEVICE_ENCLOSURE_SLOT {
+	U64         EnclosureLogicalID;                     /*0x00 */
+	U32         Reserved1;                              /*0x08 */
+	U32         Reserved2;                              /*0x0C */
+	U16         SlotNumber;                             /*0x10 */
+	U16         Reserved3;                              /*0x12 */
+	U32         Reserved4;                              /*0x14 */
+} MPI2_BOOT_DEVICE_ENCLOSURE_SLOT,
+	*PTR_MPI2_BOOT_DEVICE_ENCLOSURE_SLOT,
+	Mpi2BootDeviceEnclosureSlot_t,
+	*pMpi2BootDeviceEnclosureSlot_t;
+
+typedef struct _MPI2_BOOT_DEVICE_DEVICE_NAME {
+	U64         DeviceName;                             /*0x00 */
+	U8          LUN[8];                                 /*0x08 */
+	U32         Reserved1;                              /*0x10 */
+	U32         Reserved2;                              /*0x14 */
+} MPI2_BOOT_DEVICE_DEVICE_NAME,
+	*PTR_MPI2_BOOT_DEVICE_DEVICE_NAME,
+	Mpi2BootDeviceDeviceName_t,
+	*pMpi2BootDeviceDeviceName_t;
+
+typedef union _MPI2_MPI2_BIOSPAGE2_BOOT_DEVICE {
+	MPI2_BOOT_DEVICE_ADAPTER_ORDER  AdapterOrder;
+	MPI2_BOOT_DEVICE_SAS_WWID       SasWwid;
+	MPI2_BOOT_DEVICE_ENCLOSURE_SLOT EnclosureSlot;
+	MPI2_BOOT_DEVICE_DEVICE_NAME    DeviceName;
+} MPI2_BIOSPAGE2_BOOT_DEVICE,
+	*PTR_MPI2_BIOSPAGE2_BOOT_DEVICE,
+	Mpi2BiosPage2BootDevice_t,
+	*pMpi2BiosPage2BootDevice_t;
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_2 {
+	MPI2_CONFIG_PAGE_HEADER     Header;                 /*0x00 */
+	U32                         Reserved1;              /*0x04 */
+	U32                         Reserved2;              /*0x08 */
+	U32                         Reserved3;              /*0x0C */
+	U32                         Reserved4;              /*0x10 */
+	U32                         Reserved5;              /*0x14 */
+	U32                         Reserved6;              /*0x18 */
+	U8                          ReqBootDeviceForm;      /*0x1C */
+	U8                          Reserved7;              /*0x1D */
+	U16                         Reserved8;              /*0x1E */
+	MPI2_BIOSPAGE2_BOOT_DEVICE  RequestedBootDevice;    /*0x20 */
+	U8                          ReqAltBootDeviceForm;   /*0x38 */
+	U8                          Reserved9;              /*0x39 */
+	U16                         Reserved10;             /*0x3A */
+	MPI2_BIOSPAGE2_BOOT_DEVICE  RequestedAltBootDevice; /*0x3C */
+	U8                          CurrentBootDeviceForm;  /*0x58 */
+	U8                          Reserved11;             /*0x59 */
+	U16                         Reserved12;             /*0x5A */
+	MPI2_BIOSPAGE2_BOOT_DEVICE  CurrentBootDevice;      /*0x58 */
+} MPI2_CONFIG_PAGE_BIOS_2, *PTR_MPI2_CONFIG_PAGE_BIOS_2,
+	Mpi2BiosPage2_t, *pMpi2BiosPage2_t;
+
+#define MPI2_BIOSPAGE2_PAGEVERSION                      (0x04)
+
+/*values for BIOS Page 2 BootDeviceForm fields */
+#define MPI2_BIOSPAGE2_FORM_MASK                        (0x0F)
+#define MPI2_BIOSPAGE2_FORM_NO_DEVICE_SPECIFIED         (0x00)
+#define MPI2_BIOSPAGE2_FORM_SAS_WWID                    (0x05)
+#define MPI2_BIOSPAGE2_FORM_ENCLOSURE_SLOT              (0x06)
+#define MPI2_BIOSPAGE2_FORM_DEVICE_NAME                 (0x07)
+
+
+/*BIOS Page 3 */
+
+typedef struct _MPI2_ADAPTER_INFO {
+	U8      PciBusNumber;                        /*0x00 */
+	U8      PciDeviceAndFunctionNumber;          /*0x01 */
+	U16     AdapterFlags;                        /*0x02 */
+} MPI2_ADAPTER_INFO, *PTR_MPI2_ADAPTER_INFO,
+	Mpi2AdapterInfo_t, *pMpi2AdapterInfo_t;
+
+#define MPI2_ADAPTER_INFO_FLAGS_EMBEDDED                (0x0001)
+#define MPI2_ADAPTER_INFO_FLAGS_INIT_STATUS             (0x0002)
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_3 {
+	MPI2_CONFIG_PAGE_HEADER Header;              /*0x00 */
+	U32                     GlobalFlags;         /*0x04 */
+	U32                     BiosVersion;         /*0x08 */
+	MPI2_ADAPTER_INFO       AdapterOrder[4];     /*0x0C */
+	U32                     Reserved1;           /*0x1C */
+} MPI2_CONFIG_PAGE_BIOS_3,
+	*PTR_MPI2_CONFIG_PAGE_BIOS_3,
+	Mpi2BiosPage3_t, *pMpi2BiosPage3_t;
+
+#define MPI2_BIOSPAGE3_PAGEVERSION                      (0x00)
+
+/*values for BIOS Page 3 GlobalFlags */
+#define MPI2_BIOSPAGE3_FLAGS_PAUSE_ON_ERROR             (0x00000002)
+#define MPI2_BIOSPAGE3_FLAGS_VERBOSE_ENABLE             (0x00000004)
+#define MPI2_BIOSPAGE3_FLAGS_HOOK_INT_40_DISABLE        (0x00000010)
+
+#define MPI2_BIOSPAGE3_FLAGS_DEV_LIST_DISPLAY_MASK      (0x000000E0)
+#define MPI2_BIOSPAGE3_FLAGS_INSTALLED_DEV_DISPLAY      (0x00000000)
+#define MPI2_BIOSPAGE3_FLAGS_ADAPTER_DISPLAY            (0x00000020)
+#define MPI2_BIOSPAGE3_FLAGS_ADAPTER_DEV_DISPLAY        (0x00000040)
+
+
+/*BIOS Page 4 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhys at runtime.
+ */
+#ifndef MPI2_BIOS_PAGE_4_PHY_ENTRIES
+#define MPI2_BIOS_PAGE_4_PHY_ENTRIES        (1)
+#endif
+
+typedef struct _MPI2_BIOS4_ENTRY {
+	U64                     ReassignmentWWID;       /*0x00 */
+	U64                     ReassignmentDeviceName; /*0x08 */
+} MPI2_BIOS4_ENTRY, *PTR_MPI2_BIOS4_ENTRY,
+	Mpi2MBios4Entry_t, *pMpi2Bios4Entry_t;
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_4 {
+	MPI2_CONFIG_PAGE_HEADER Header;             /*0x00 */
+	U8                      NumPhys;            /*0x04 */
+	U8                      Reserved1;          /*0x05 */
+	U16                     Reserved2;          /*0x06 */
+	MPI2_BIOS4_ENTRY
+		Phy[MPI2_BIOS_PAGE_4_PHY_ENTRIES];  /*0x08 */
+} MPI2_CONFIG_PAGE_BIOS_4, *PTR_MPI2_CONFIG_PAGE_BIOS_4,
+	Mpi2BiosPage4_t, *pMpi2BiosPage4_t;
+
+#define MPI2_BIOSPAGE4_PAGEVERSION                      (0x01)
+
+
+/****************************************************************************
+*  RAID Volume Config Pages
+****************************************************************************/
+
+/*RAID Volume Page 0 */
+
+typedef struct _MPI2_RAIDVOL0_PHYS_DISK {
+	U8                      RAIDSetNum;        /*0x00 */
+	U8                      PhysDiskMap;       /*0x01 */
+	U8                      PhysDiskNum;       /*0x02 */
+	U8                      Reserved;          /*0x03 */
+} MPI2_RAIDVOL0_PHYS_DISK, *PTR_MPI2_RAIDVOL0_PHYS_DISK,
+	Mpi2RaidVol0PhysDisk_t, *pMpi2RaidVol0PhysDisk_t;
+
+/*defines for the PhysDiskMap field */
+#define MPI2_RAIDVOL0_PHYSDISK_PRIMARY                  (0x01)
+#define MPI2_RAIDVOL0_PHYSDISK_SECONDARY                (0x02)
+
+typedef struct _MPI2_RAIDVOL0_SETTINGS {
+	U16                     Settings;          /*0x00 */
+	U8                      HotSparePool;      /*0x01 */
+	U8                      Reserved;          /*0x02 */
+} MPI2_RAIDVOL0_SETTINGS, *PTR_MPI2_RAIDVOL0_SETTINGS,
+	Mpi2RaidVol0Settings_t,
+	*pMpi2RaidVol0Settings_t;
+
+/*RAID Volume Page 0 HotSparePool defines, also used in RAID Physical Disk */
+#define MPI2_RAID_HOT_SPARE_POOL_0                      (0x01)
+#define MPI2_RAID_HOT_SPARE_POOL_1                      (0x02)
+#define MPI2_RAID_HOT_SPARE_POOL_2                      (0x04)
+#define MPI2_RAID_HOT_SPARE_POOL_3                      (0x08)
+#define MPI2_RAID_HOT_SPARE_POOL_4                      (0x10)
+#define MPI2_RAID_HOT_SPARE_POOL_5                      (0x20)
+#define MPI2_RAID_HOT_SPARE_POOL_6                      (0x40)
+#define MPI2_RAID_HOT_SPARE_POOL_7                      (0x80)
+
+/*RAID Volume Page 0 VolumeSettings defines */
+#define MPI2_RAIDVOL0_SETTING_USE_PRODUCT_ID_SUFFIX     (0x0008)
+#define MPI2_RAIDVOL0_SETTING_AUTO_CONFIG_HSWAP_DISABLE (0x0004)
+
+#define MPI2_RAIDVOL0_SETTING_MASK_WRITE_CACHING        (0x0003)
+#define MPI2_RAIDVOL0_SETTING_UNCHANGED                 (0x0000)
+#define MPI2_RAIDVOL0_SETTING_DISABLE_WRITE_CACHING     (0x0001)
+#define MPI2_RAIDVOL0_SETTING_ENABLE_WRITE_CACHING      (0x0002)
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhysDisks at runtime.
+ */
+#ifndef MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX
+#define MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX       (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_0 {
+	MPI2_CONFIG_PAGE_HEADER Header;            /*0x00 */
+	U16                     DevHandle;         /*0x04 */
+	U8                      VolumeState;       /*0x06 */
+	U8                      VolumeType;        /*0x07 */
+	U32                     VolumeStatusFlags; /*0x08 */
+	MPI2_RAIDVOL0_SETTINGS  VolumeSettings;    /*0x0C */
+	U64                     MaxLBA;            /*0x10 */
+	U32                     StripeSize;        /*0x18 */
+	U16                     BlockSize;         /*0x1C */
+	U16                     Reserved1;         /*0x1E */
+	U8                      SupportedPhysDisks;/*0x20 */
+	U8                      ResyncRate;        /*0x21 */
+	U16                     DataScrubDuration; /*0x22 */
+	U8                      NumPhysDisks;      /*0x24 */
+	U8                      Reserved2;         /*0x25 */
+	U8                      Reserved3;         /*0x26 */
+	U8                      InactiveStatus;    /*0x27 */
+	MPI2_RAIDVOL0_PHYS_DISK
+	PhysDisk[MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX]; /*0x28 */
+} MPI2_CONFIG_PAGE_RAID_VOL_0,
+	*PTR_MPI2_CONFIG_PAGE_RAID_VOL_0,
+	Mpi2RaidVolPage0_t, *pMpi2RaidVolPage0_t;
+
+#define MPI2_RAIDVOLPAGE0_PAGEVERSION           (0x0A)
+
+/*values for RAID VolumeState */
+#define MPI2_RAID_VOL_STATE_MISSING                         (0x00)
+#define MPI2_RAID_VOL_STATE_FAILED                          (0x01)
+#define MPI2_RAID_VOL_STATE_INITIALIZING                    (0x02)
+#define MPI2_RAID_VOL_STATE_ONLINE                          (0x03)
+#define MPI2_RAID_VOL_STATE_DEGRADED                        (0x04)
+#define MPI2_RAID_VOL_STATE_OPTIMAL                         (0x05)
+
+/*values for RAID VolumeType */
+#define MPI2_RAID_VOL_TYPE_RAID0                            (0x00)
+#define MPI2_RAID_VOL_TYPE_RAID1E                           (0x01)
+#define MPI2_RAID_VOL_TYPE_RAID1                            (0x02)
+#define MPI2_RAID_VOL_TYPE_RAID10                           (0x05)
+#define MPI2_RAID_VOL_TYPE_UNKNOWN                          (0xFF)
+
+/*values for RAID Volume Page 0 VolumeStatusFlags field */
+#define MPI2_RAIDVOL0_STATUS_FLAG_PENDING_RESYNC            (0x02000000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BACKG_INIT_PENDING        (0x01000000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_MDC_PENDING               (0x00800000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_USER_CONSIST_PENDING      (0x00400000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_MAKE_DATA_CONSISTENT      (0x00200000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_DATA_SCRUB                (0x00100000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_CONSISTENCY_CHECK         (0x00080000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_CAPACITY_EXPANSION        (0x00040000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BACKGROUND_INIT           (0x00020000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS        (0x00010000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_VOL_NOT_CONSISTENT        (0x00000080)
+#define MPI2_RAIDVOL0_STATUS_FLAG_OCE_ALLOWED               (0x00000040)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BGI_COMPLETE              (0x00000020)
+#define MPI2_RAIDVOL0_STATUS_FLAG_1E_OFFSET_MIRROR          (0x00000000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_1E_ADJACENT_MIRROR        (0x00000010)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BAD_BLOCK_TABLE_FULL      (0x00000008)
+#define MPI2_RAIDVOL0_STATUS_FLAG_VOLUME_INACTIVE           (0x00000004)
+#define MPI2_RAIDVOL0_STATUS_FLAG_QUIESCED                  (0x00000002)
+#define MPI2_RAIDVOL0_STATUS_FLAG_ENABLED                   (0x00000001)
+
+/*values for RAID Volume Page 0 SupportedPhysDisks field */
+#define MPI2_RAIDVOL0_SUPPORT_SOLID_STATE_DISKS             (0x08)
+#define MPI2_RAIDVOL0_SUPPORT_HARD_DISKS                    (0x04)
+#define MPI2_RAIDVOL0_SUPPORT_SAS_PROTOCOL                  (0x02)
+#define MPI2_RAIDVOL0_SUPPORT_SATA_PROTOCOL                 (0x01)
+
+/*values for RAID Volume Page 0 InactiveStatus field */
+#define MPI2_RAIDVOLPAGE0_UNKNOWN_INACTIVE                  (0x00)
+#define MPI2_RAIDVOLPAGE0_STALE_METADATA_INACTIVE           (0x01)
+#define MPI2_RAIDVOLPAGE0_FOREIGN_VOLUME_INACTIVE           (0x02)
+#define MPI2_RAIDVOLPAGE0_INSUFFICIENT_RESOURCE_INACTIVE    (0x03)
+#define MPI2_RAIDVOLPAGE0_CLONE_VOLUME_INACTIVE             (0x04)
+#define MPI2_RAIDVOLPAGE0_INSUFFICIENT_METADATA_INACTIVE    (0x05)
+#define MPI2_RAIDVOLPAGE0_PREVIOUSLY_DELETED                (0x06)
+
+
+/*RAID Volume Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_1 {
+	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
+	U16                     DevHandle;                  /*0x04 */
+	U16                     Reserved0;                  /*0x06 */
+	U8                      GUID[24];                   /*0x08 */
+	U8                      Name[16];                   /*0x20 */
+	U64                     WWID;                       /*0x30 */
+	U32                     Reserved1;                  /*0x38 */
+	U32                     Reserved2;                  /*0x3C */
+} MPI2_CONFIG_PAGE_RAID_VOL_1,
+	*PTR_MPI2_CONFIG_PAGE_RAID_VOL_1,
+	Mpi2RaidVolPage1_t, *pMpi2RaidVolPage1_t;
+
+#define MPI2_RAIDVOLPAGE1_PAGEVERSION           (0x03)
+
+
+/****************************************************************************
+*  RAID Physical Disk Config Pages
+****************************************************************************/
+
+/*RAID Physical Disk Page 0 */
+
+typedef struct _MPI2_RAIDPHYSDISK0_SETTINGS {
+	U16                     Reserved1;                  /*0x00 */
+	U8                      HotSparePool;               /*0x02 */
+	U8                      Reserved2;                  /*0x03 */
+} MPI2_RAIDPHYSDISK0_SETTINGS,
+	*PTR_MPI2_RAIDPHYSDISK0_SETTINGS,
+	Mpi2RaidPhysDisk0Settings_t,
+	*pMpi2RaidPhysDisk0Settings_t;
+
+/*use MPI2_RAID_HOT_SPARE_POOL_ defines for the HotSparePool field */
+
+typedef struct _MPI2_RAIDPHYSDISK0_INQUIRY_DATA {
+	U8                      VendorID[8];                /*0x00 */
+	U8                      ProductID[16];              /*0x08 */
+	U8                      ProductRevLevel[4];         /*0x18 */
+	U8                      SerialNum[32];              /*0x1C */
+} MPI2_RAIDPHYSDISK0_INQUIRY_DATA,
+	*PTR_MPI2_RAIDPHYSDISK0_INQUIRY_DATA,
+	Mpi2RaidPhysDisk0InquiryData_t,
+	*pMpi2RaidPhysDisk0InquiryData_t;
+
+typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_0 {
+	MPI2_CONFIG_PAGE_HEADER         Header;             /*0x00 */
+	U16                             DevHandle;          /*0x04 */
+	U8                              Reserved1;          /*0x06 */
+	U8                              PhysDiskNum;        /*0x07 */
+	MPI2_RAIDPHYSDISK0_SETTINGS     PhysDiskSettings;   /*0x08 */
+	U32                             Reserved2;          /*0x0C */
+	MPI2_RAIDPHYSDISK0_INQUIRY_DATA InquiryData;        /*0x10 */
+	U32                             Reserved3;          /*0x4C */
+	U8                              PhysDiskState;      /*0x50 */
+	U8                              OfflineReason;      /*0x51 */
+	U8                              IncompatibleReason; /*0x52 */
+	U8                              PhysDiskAttributes; /*0x53 */
+	U32                             PhysDiskStatusFlags;/*0x54 */
+	U64                             DeviceMaxLBA;       /*0x58 */
+	U64                             HostMaxLBA;         /*0x60 */
+	U64                             CoercedMaxLBA;      /*0x68 */
+	U16                             BlockSize;          /*0x70 */
+	U16                             Reserved5;          /*0x72 */
+	U32                             Reserved6;          /*0x74 */
+} MPI2_CONFIG_PAGE_RD_PDISK_0,
+	*PTR_MPI2_CONFIG_PAGE_RD_PDISK_0,
+	Mpi2RaidPhysDiskPage0_t,
+	*pMpi2RaidPhysDiskPage0_t;
+
+#define MPI2_RAIDPHYSDISKPAGE0_PAGEVERSION          (0x05)
