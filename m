From: <sreekanth.reddy@lsi.com>
Subject: [RESEND][PATCH 4/20][SCSI] mpt3sas: Part 3 of MPI API headers
Date: Sat, 29 Sep 2012 19:49:42 +0530
Message-ID: <20120929141942.GA20788@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39356 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab2I2Ucb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 16:32:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This patch contains MPI API headers
This patch is part 3 of MPI API headers.
Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 7e24c55..d8b2c3e 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -1705,3 +1705,1619 @@ typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_0 {
 	*pMpi2RaidPhysDiskPage0_t;
 
 #define MPI2_RAIDPHYSDISKPAGE0_PAGEVERSION          (0x05)
+
+/*PhysDiskState defines */
+#define MPI2_RAID_PD_STATE_NOT_CONFIGURED               (0x00)
+#define MPI2_RAID_PD_STATE_NOT_COMPATIBLE               (0x01)
+#define MPI2_RAID_PD_STATE_OFFLINE                      (0x02)
+#define MPI2_RAID_PD_STATE_ONLINE                       (0x03)
+#define MPI2_RAID_PD_STATE_HOT_SPARE                    (0x04)
+#define MPI2_RAID_PD_STATE_DEGRADED                     (0x05)
+#define MPI2_RAID_PD_STATE_REBUILDING                   (0x06)
+#define MPI2_RAID_PD_STATE_OPTIMAL                      (0x07)
+
+/*OfflineReason defines */
+#define MPI2_PHYSDISK0_ONLINE                           (0x00)
+#define MPI2_PHYSDISK0_OFFLINE_MISSING                  (0x01)
+#define MPI2_PHYSDISK0_OFFLINE_FAILED                   (0x03)
+#define MPI2_PHYSDISK0_OFFLINE_INITIALIZING             (0x04)
+#define MPI2_PHYSDISK0_OFFLINE_REQUESTED                (0x05)
+#define MPI2_PHYSDISK0_OFFLINE_FAILED_REQUESTED         (0x06)
+#define MPI2_PHYSDISK0_OFFLINE_OTHER                    (0xFF)
+
+/*IncompatibleReason defines */
+#define MPI2_PHYSDISK0_COMPATIBLE                       (0x00)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_PROTOCOL            (0x01)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_BLOCKSIZE           (0x02)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_MAX_LBA             (0x03)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_SATA_EXTENDED_CMD   (0x04)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_REMOVEABLE_MEDIA    (0x05)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_MEDIA_TYPE          (0x06)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_UNKNOWN             (0xFF)
+
+/*PhysDiskAttributes defines */
+#define MPI2_PHYSDISK0_ATTRIB_MEDIA_MASK                (0x0C)
+#define MPI2_PHYSDISK0_ATTRIB_SOLID_STATE_DRIVE         (0x08)
+#define MPI2_PHYSDISK0_ATTRIB_HARD_DISK_DRIVE           (0x04)
+
+#define MPI2_PHYSDISK0_ATTRIB_PROTOCOL_MASK             (0x03)
+#define MPI2_PHYSDISK0_ATTRIB_SAS_PROTOCOL              (0x02)
+#define MPI2_PHYSDISK0_ATTRIB_SATA_PROTOCOL             (0x01)
+
+/*PhysDiskStatusFlags defines */
+#define MPI2_PHYSDISK0_STATUS_FLAG_NOT_CERTIFIED        (0x00000040)
+#define MPI2_PHYSDISK0_STATUS_FLAG_OCE_TARGET           (0x00000020)
+#define MPI2_PHYSDISK0_STATUS_FLAG_WRITE_CACHE_ENABLED  (0x00000010)
+#define MPI2_PHYSDISK0_STATUS_FLAG_OPTIMAL_PREVIOUS     (0x00000000)
+#define MPI2_PHYSDISK0_STATUS_FLAG_NOT_OPTIMAL_PREVIOUS (0x00000008)
+#define MPI2_PHYSDISK0_STATUS_FLAG_INACTIVE_VOLUME      (0x00000004)
+#define MPI2_PHYSDISK0_STATUS_FLAG_QUIESCED             (0x00000002)
+#define MPI2_PHYSDISK0_STATUS_FLAG_OUT_OF_SYNC          (0x00000001)
+
+
+/*RAID Physical Disk Page 1 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhysDiskPaths at runtime.
+ */
+#ifndef MPI2_RAID_PHYS_DISK1_PATH_MAX
+#define MPI2_RAID_PHYS_DISK1_PATH_MAX   (1)
+#endif
+
+typedef struct _MPI2_RAIDPHYSDISK1_PATH {
+	U16             DevHandle;          /*0x00 */
+	U16             Reserved1;          /*0x02 */
+	U64             WWID;               /*0x04 */
+	U64             OwnerWWID;          /*0x0C */
+	U8              OwnerIdentifier;    /*0x14 */
+	U8              Reserved2;          /*0x15 */
+	U16             Flags;              /*0x16 */
+} MPI2_RAIDPHYSDISK1_PATH, *PTR_MPI2_RAIDPHYSDISK1_PATH,
+	Mpi2RaidPhysDisk1Path_t,
+	*pMpi2RaidPhysDisk1Path_t;
+
+/*RAID Physical Disk Page 1 Physical Disk Path Flags field defines */
+#define MPI2_RAID_PHYSDISK1_FLAG_PRIMARY        (0x0004)
+#define MPI2_RAID_PHYSDISK1_FLAG_BROKEN         (0x0002)
+#define MPI2_RAID_PHYSDISK1_FLAG_INVALID        (0x0001)
+
+typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_1 {
+	MPI2_CONFIG_PAGE_HEADER         Header;             /*0x00 */
+	U8                              NumPhysDiskPaths;   /*0x04 */
+	U8                              PhysDiskNum;        /*0x05 */
+	U16                             Reserved1;          /*0x06 */
+	U32                             Reserved2;          /*0x08 */
+	MPI2_RAIDPHYSDISK1_PATH
+		PhysicalDiskPath[MPI2_RAID_PHYS_DISK1_PATH_MAX];/*0x0C */
+} MPI2_CONFIG_PAGE_RD_PDISK_1,
+	*PTR_MPI2_CONFIG_PAGE_RD_PDISK_1,
+	Mpi2RaidPhysDiskPage1_t,
+	*pMpi2RaidPhysDiskPage1_t;
+
+#define MPI2_RAIDPHYSDISKPAGE1_PAGEVERSION          (0x02)
+
+
+/****************************************************************************
+*  values for fields used by several types of SAS Config Pages
+****************************************************************************/
+
+/*values for NegotiatedLinkRates fields */
+#define MPI2_SAS_NEG_LINK_RATE_MASK_LOGICAL             (0xF0)
+#define MPI2_SAS_NEG_LINK_RATE_SHIFT_LOGICAL            (4)
+#define MPI2_SAS_NEG_LINK_RATE_MASK_PHYSICAL            (0x0F)
+/*link rates used for Negotiated Physical and Logical Link Rate */
+#define MPI2_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE        (0x00)
+#define MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED             (0x01)
+#define MPI2_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED       (0x02)
+#define MPI2_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE        (0x03)
+#define MPI2_SAS_NEG_LINK_RATE_PORT_SELECTOR            (0x04)
+#define MPI2_SAS_NEG_LINK_RATE_SMP_RESET_IN_PROGRESS    (0x05)
+#define MPI2_SAS_NEG_LINK_RATE_UNSUPPORTED_PHY          (0x06)
+#define MPI2_SAS_NEG_LINK_RATE_1_5                      (0x08)
+#define MPI2_SAS_NEG_LINK_RATE_3_0                      (0x09)
+#define MPI2_SAS_NEG_LINK_RATE_6_0                      (0x0A)
+#define MPI25_SAS_NEG_LINK_RATE_12_0                    (0x0B)
+
+
+/*values for AttachedPhyInfo fields */
+#define MPI2_SAS_APHYINFO_INSIDE_ZPSDS_PERSISTENT       (0x00000040)
+#define MPI2_SAS_APHYINFO_REQUESTED_INSIDE_ZPSDS        (0x00000020)
+#define MPI2_SAS_APHYINFO_BREAK_REPLY_CAPABLE           (0x00000010)
+
+#define MPI2_SAS_APHYINFO_REASON_MASK                   (0x0000000F)
+#define MPI2_SAS_APHYINFO_REASON_UNKNOWN                (0x00000000)
+#define MPI2_SAS_APHYINFO_REASON_POWER_ON               (0x00000001)
+#define MPI2_SAS_APHYINFO_REASON_HARD_RESET             (0x00000002)
+#define MPI2_SAS_APHYINFO_REASON_SMP_PHY_CONTROL        (0x00000003)
+#define MPI2_SAS_APHYINFO_REASON_LOSS_OF_SYNC           (0x00000004)
+#define MPI2_SAS_APHYINFO_REASON_MULTIPLEXING_SEQ       (0x00000005)
+#define MPI2_SAS_APHYINFO_REASON_IT_NEXUS_LOSS_TIMER    (0x00000006)
+#define MPI2_SAS_APHYINFO_REASON_BREAK_TIMEOUT          (0x00000007)
+#define MPI2_SAS_APHYINFO_REASON_PHY_TEST_STOPPED       (0x00000008)
+
+
+/*values for PhyInfo fields */
+#define MPI2_SAS_PHYINFO_PHY_VACANT                     (0x80000000)
+
+#define MPI2_SAS_PHYINFO_PHY_POWER_CONDITION_MASK       (0x18000000)
+#define MPI2_SAS_PHYINFO_SHIFT_PHY_POWER_CONDITION      (27)
+#define MPI2_SAS_PHYINFO_PHY_POWER_ACTIVE               (0x00000000)
+#define MPI2_SAS_PHYINFO_PHY_POWER_PARTIAL              (0x08000000)
+#define MPI2_SAS_PHYINFO_PHY_POWER_SLUMBER              (0x10000000)
+
+#define MPI2_SAS_PHYINFO_CHANGED_REQ_INSIDE_ZPSDS       (0x04000000)
+#define MPI2_SAS_PHYINFO_INSIDE_ZPSDS_PERSISTENT        (0x02000000)
+#define MPI2_SAS_PHYINFO_REQ_INSIDE_ZPSDS               (0x01000000)
+#define MPI2_SAS_PHYINFO_ZONE_GROUP_PERSISTENT          (0x00400000)
+#define MPI2_SAS_PHYINFO_INSIDE_ZPSDS                   (0x00200000)
+#define MPI2_SAS_PHYINFO_ZONING_ENABLED                 (0x00100000)
+
+#define MPI2_SAS_PHYINFO_REASON_MASK                    (0x000F0000)
+#define MPI2_SAS_PHYINFO_REASON_UNKNOWN                 (0x00000000)
+#define MPI2_SAS_PHYINFO_REASON_POWER_ON                (0x00010000)
+#define MPI2_SAS_PHYINFO_REASON_HARD_RESET              (0x00020000)
+#define MPI2_SAS_PHYINFO_REASON_SMP_PHY_CONTROL         (0x00030000)
+#define MPI2_SAS_PHYINFO_REASON_LOSS_OF_SYNC            (0x00040000)
+#define MPI2_SAS_PHYINFO_REASON_MULTIPLEXING_SEQ        (0x00050000)
+#define MPI2_SAS_PHYINFO_REASON_IT_NEXUS_LOSS_TIMER     (0x00060000)
+#define MPI2_SAS_PHYINFO_REASON_BREAK_TIMEOUT           (0x00070000)
+#define MPI2_SAS_PHYINFO_REASON_PHY_TEST_STOPPED        (0x00080000)
+
+#define MPI2_SAS_PHYINFO_MULTIPLEXING_SUPPORTED         (0x00008000)
+#define MPI2_SAS_PHYINFO_SATA_PORT_ACTIVE               (0x00004000)
+#define MPI2_SAS_PHYINFO_SATA_PORT_SELECTOR_PRESENT     (0x00002000)
+#define MPI2_SAS_PHYINFO_VIRTUAL_PHY                    (0x00001000)
+
+#define MPI2_SAS_PHYINFO_MASK_PARTIAL_PATHWAY_TIME      (0x00000F00)
+#define MPI2_SAS_PHYINFO_SHIFT_PARTIAL_PATHWAY_TIME     (8)
+
+#define MPI2_SAS_PHYINFO_MASK_ROUTING_ATTRIBUTE         (0x000000F0)
+#define MPI2_SAS_PHYINFO_DIRECT_ROUTING                 (0x00000000)
+#define MPI2_SAS_PHYINFO_SUBTRACTIVE_ROUTING            (0x00000010)
+#define MPI2_SAS_PHYINFO_TABLE_ROUTING                  (0x00000020)
+
+
+/*values for SAS ProgrammedLinkRate fields */
+#define MPI2_SAS_PRATE_MAX_RATE_MASK                    (0xF0)
+#define MPI2_SAS_PRATE_MAX_RATE_NOT_PROGRAMMABLE        (0x00)
+#define MPI2_SAS_PRATE_MAX_RATE_1_5                     (0x80)
+#define MPI2_SAS_PRATE_MAX_RATE_3_0                     (0x90)
+#define MPI2_SAS_PRATE_MAX_RATE_6_0                     (0xA0)
+#define MPI2_SAS_PRATE_MIN_RATE_MASK                    (0x0F)
+#define MPI2_SAS_PRATE_MIN_RATE_NOT_PROGRAMMABLE        (0x00)
+#define MPI2_SAS_PRATE_MIN_RATE_1_5                     (0x08)
+#define MPI2_SAS_PRATE_MIN_RATE_3_0                     (0x09)
+#define MPI2_SAS_PRATE_MIN_RATE_6_0                     (0x0A)
+#define MPI25_SAS_PRATE_MIN_RATE_12_0                   (0x0B)
+
+
+/*values for SAS HwLinkRate fields */
+#define MPI2_SAS_HWRATE_MAX_RATE_MASK                   (0xF0)
+#define MPI2_SAS_HWRATE_MAX_RATE_1_5                    (0x80)
+#define MPI2_SAS_HWRATE_MAX_RATE_3_0                    (0x90)
+#define MPI2_SAS_HWRATE_MAX_RATE_6_0                    (0xA0)
+#define MPI2_SAS_HWRATE_MIN_RATE_MASK                   (0x0F)
+#define MPI2_SAS_HWRATE_MIN_RATE_1_5                    (0x08)
+#define MPI2_SAS_HWRATE_MIN_RATE_3_0                    (0x09)
+#define MPI2_SAS_HWRATE_MIN_RATE_6_0                    (0x0A)
+#define MPI25_SAS_HWRATE_MIN_RATE_12_0                  (0x0B)
+
+
+
+/****************************************************************************
+*  SAS IO Unit Config Pages
+****************************************************************************/
+
+/*SAS IO Unit Page 0 */
+
+typedef struct _MPI2_SAS_IO_UNIT0_PHY_DATA {
+	U8          Port;                   /*0x00 */
+	U8          PortFlags;              /*0x01 */
+	U8          PhyFlags;               /*0x02 */
+	U8          NegotiatedLinkRate;     /*0x03 */
+	U32         ControllerPhyDeviceInfo;/*0x04 */
+	U16         AttachedDevHandle;      /*0x08 */
+	U16         ControllerDevHandle;    /*0x0A */
+	U32         DiscoveryStatus;        /*0x0C */
+	U32         Reserved;               /*0x10 */
+} MPI2_SAS_IO_UNIT0_PHY_DATA,
+	*PTR_MPI2_SAS_IO_UNIT0_PHY_DATA,
+	Mpi2SasIOUnit0PhyData_t,
+	*pMpi2SasIOUnit0PhyData_t;
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhys at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT0_PHY_MAX
+#define MPI2_SAS_IOUNIT0_PHY_MAX        (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;   /*0x00 */
+	U32                                 Reserved1;/*0x08 */
+	U8                                  NumPhys;  /*0x0C */
+	U8                                  Reserved2;/*0x0D */
+	U16                                 Reserved3;/*0x0E */
+	MPI2_SAS_IO_UNIT0_PHY_DATA
+		PhyData[MPI2_SAS_IOUNIT0_PHY_MAX];    /*0x10 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_0,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_0,
+	Mpi2SasIOUnitPage0_t, *pMpi2SasIOUnitPage0_t;
+
+#define MPI2_SASIOUNITPAGE0_PAGEVERSION                     (0x05)
+
+/*values for SAS IO Unit Page 0 PortFlags */
+#define MPI2_SASIOUNIT0_PORTFLAGS_DISCOVERY_IN_PROGRESS     (0x08)
+#define MPI2_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG          (0x01)
+
+/*values for SAS IO Unit Page 0 PhyFlags */
+#define MPI2_SASIOUNIT0_PHYFLAGS_ZONING_ENABLED             (0x10)
+#define MPI2_SASIOUNIT0_PHYFLAGS_PHY_DISABLED               (0x08)
+
+/*use MPI2_SAS_NEG_LINK_RATE_ defines for the NegotiatedLinkRate field */
+
+/*see mpi2_sas.h for values for
+ *SAS IO Unit Page 0 ControllerPhyDeviceInfo values */
+
+/*values for SAS IO Unit Page 0 DiscoveryStatus */
+#define MPI2_SASIOUNIT0_DS_MAX_ENCLOSURES_EXCEED            (0x80000000)
+#define MPI2_SASIOUNIT0_DS_MAX_EXPANDERS_EXCEED             (0x40000000)
+#define MPI2_SASIOUNIT0_DS_MAX_DEVICES_EXCEED               (0x20000000)
+#define MPI2_SASIOUNIT0_DS_MAX_TOPO_PHYS_EXCEED             (0x10000000)
+#define MPI2_SASIOUNIT0_DS_DOWNSTREAM_INITIATOR             (0x08000000)
+#define MPI2_SASIOUNIT0_DS_MULTI_SUBTRACTIVE_SUBTRACTIVE    (0x00008000)
+#define MPI2_SASIOUNIT0_DS_EXP_MULTI_SUBTRACTIVE            (0x00004000)
+#define MPI2_SASIOUNIT0_DS_MULTI_PORT_DOMAIN                (0x00002000)
+#define MPI2_SASIOUNIT0_DS_TABLE_TO_SUBTRACTIVE_LINK        (0x00001000)
+#define MPI2_SASIOUNIT0_DS_UNSUPPORTED_DEVICE               (0x00000800)
+#define MPI2_SASIOUNIT0_DS_TABLE_LINK                       (0x00000400)
+#define MPI2_SASIOUNIT0_DS_SUBTRACTIVE_LINK                 (0x00000200)
+#define MPI2_SASIOUNIT0_DS_SMP_CRC_ERROR                    (0x00000100)
+#define MPI2_SASIOUNIT0_DS_SMP_FUNCTION_FAILED              (0x00000080)
+#define MPI2_SASIOUNIT0_DS_INDEX_NOT_EXIST                  (0x00000040)
+#define MPI2_SASIOUNIT0_DS_OUT_ROUTE_ENTRIES                (0x00000020)
+#define MPI2_SASIOUNIT0_DS_SMP_TIMEOUT                      (0x00000010)
+#define MPI2_SASIOUNIT0_DS_MULTIPLE_PORTS                   (0x00000004)
+#define MPI2_SASIOUNIT0_DS_UNADDRESSABLE_DEVICE             (0x00000002)
+#define MPI2_SASIOUNIT0_DS_LOOP_DETECTED                    (0x00000001)
+
+
+/*SAS IO Unit Page 1 */
+
+typedef struct _MPI2_SAS_IO_UNIT1_PHY_DATA {
+	U8          Port;                       /*0x00 */
+	U8          PortFlags;                  /*0x01 */
+	U8          PhyFlags;                   /*0x02 */
+	U8          MaxMinLinkRate;             /*0x03 */
+	U32         ControllerPhyDeviceInfo;    /*0x04 */
+	U16         MaxTargetPortConnectTime;   /*0x08 */
+	U16         Reserved1;                  /*0x0A */
+} MPI2_SAS_IO_UNIT1_PHY_DATA,
+	*PTR_MPI2_SAS_IO_UNIT1_PHY_DATA,
+	Mpi2SasIOUnit1PhyData_t,
+	*pMpi2SasIOUnit1PhyData_t;
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhys at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT1_PHY_MAX
+#define MPI2_SAS_IOUNIT1_PHY_MAX        (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_1 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header; /*0x00 */
+	U16
+		ControlFlags;                       /*0x08 */
+	U16
+		SASNarrowMaxQueueDepth;             /*0x0A */
+	U16
+		AdditionalControlFlags;             /*0x0C */
+	U16
+		SASWideMaxQueueDepth;               /*0x0E */
+	U8
+		NumPhys;                            /*0x10 */
+	U8
+		SATAMaxQDepth;                      /*0x11 */
+	U8
+		ReportDeviceMissingDelay;           /*0x12 */
+	U8
+		IODeviceMissingDelay;               /*0x13 */
+	MPI2_SAS_IO_UNIT1_PHY_DATA
+		PhyData[MPI2_SAS_IOUNIT1_PHY_MAX];  /*0x14 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_1,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_1,
+	Mpi2SasIOUnitPage1_t, *pMpi2SasIOUnitPage1_t;
+
+#define MPI2_SASIOUNITPAGE1_PAGEVERSION     (0x09)
+
+/*values for SAS IO Unit Page 1 ControlFlags */
+#define MPI2_SASIOUNIT1_CONTROL_DEVICE_SELF_TEST                    (0x8000)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_3_0_MAX                        (0x4000)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_1_5_MAX                        (0x2000)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_SW_PRESERVE                    (0x1000)
+
+#define MPI2_SASIOUNIT1_CONTROL_MASK_DEV_SUPPORT                    (0x0600)
+#define MPI2_SASIOUNIT1_CONTROL_SHIFT_DEV_SUPPORT                   (9)
+#define MPI2_SASIOUNIT1_CONTROL_DEV_SUPPORT_BOTH                    (0x0)
+#define MPI2_SASIOUNIT1_CONTROL_DEV_SAS_SUPPORT                     (0x1)
+#define MPI2_SASIOUNIT1_CONTROL_DEV_SATA_SUPPORT                    (0x2)
+
+#define MPI2_SASIOUNIT1_CONTROL_SATA_48BIT_LBA_REQUIRED             (0x0080)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_SMART_REQUIRED                 (0x0040)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_NCQ_REQUIRED                   (0x0020)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_FUA_REQUIRED                   (0x0010)
+#define MPI2_SASIOUNIT1_CONTROL_TABLE_SUBTRACTIVE_ILLEGAL           (0x0008)
+#define MPI2_SASIOUNIT1_CONTROL_SUBTRACTIVE_ILLEGAL                 (0x0004)
+#define MPI2_SASIOUNIT1_CONTROL_FIRST_LVL_DISC_ONLY                 (0x0002)
+#define MPI2_SASIOUNIT1_CONTROL_CLEAR_AFFILIATION                   (0x0001)
+
+/*values for SAS IO Unit Page 1 AdditionalControlFlags */
+#define MPI2_SASIOUNIT1_ACONTROL_MULTI_PORT_DOMAIN_ILLEGAL          (0x0080)
+#define MPI2_SASIOUNIT1_ACONTROL_SATA_ASYNCHROUNOUS_NOTIFICATION    (0x0040)
+#define MPI2_SASIOUNIT1_ACONTROL_INVALID_TOPOLOGY_CORRECTION        (0x0020)
+#define MPI2_SASIOUNIT1_ACONTROL_PORT_ENABLE_ONLY_SATA_LINK_RESET   (0x0010)
+#define MPI2_SASIOUNIT1_ACONTROL_OTHER_AFFILIATION_SATA_LINK_RESET  (0x0008)
+#define MPI2_SASIOUNIT1_ACONTROL_SELF_AFFILIATION_SATA_LINK_RESET   (0x0004)
+#define MPI2_SASIOUNIT1_ACONTROL_NO_AFFILIATION_SATA_LINK_RESET     (0x0002)
+#define MPI2_SASIOUNIT1_ACONTROL_ALLOW_TABLE_TO_TABLE               (0x0001)
+
+/*defines for SAS IO Unit Page 1 ReportDeviceMissingDelay */
+#define MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK                 (0x7F)
+#define MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16                      (0x80)
+
+/*values for SAS IO Unit Page 1 PortFlags */
+#define MPI2_SASIOUNIT1_PORT_FLAGS_AUTO_PORT_CONFIG                 (0x01)
+
+/*values for SAS IO Unit Page 1 PhyFlags */
+#define MPI2_SASIOUNIT1_PHYFLAGS_ZONING_ENABLE                      (0x10)
+#define MPI2_SASIOUNIT1_PHYFLAGS_PHY_DISABLE                        (0x08)
+
+/*values for SAS IO Unit Page 1 MaxMinLinkRate */
+#define MPI2_SASIOUNIT1_MAX_RATE_MASK                               (0xF0)
+#define MPI2_SASIOUNIT1_MAX_RATE_1_5                                (0x80)
+#define MPI2_SASIOUNIT1_MAX_RATE_3_0                                (0x90)
+#define MPI2_SASIOUNIT1_MAX_RATE_6_0                                (0xA0)
+#define MPI25_SASIOUNIT1_MAX_RATE_12_0                              (0xB0)
+#define MPI2_SASIOUNIT1_MIN_RATE_MASK                               (0x0F)
+#define MPI2_SASIOUNIT1_MIN_RATE_1_5                                (0x08)
+#define MPI2_SASIOUNIT1_MIN_RATE_3_0                                (0x09)
+#define MPI2_SASIOUNIT1_MIN_RATE_6_0                                (0x0A)
+#define MPI25_SASIOUNIT1_MIN_RATE_12_0                              (0x0B)
+
+/*see mpi2_sas.h for values for
+ *SAS IO Unit Page 1 ControllerPhyDeviceInfo values */
+
+
+/*SAS IO Unit Page 4 */
+
+typedef struct _MPI2_SAS_IOUNIT4_SPINUP_GROUP {
+	U8          MaxTargetSpinup;            /*0x00 */
+	U8          SpinupDelay;                /*0x01 */
+	U8          SpinupFlags;                /*0x02 */
+	U8          Reserved1;                  /*0x03 */
+} MPI2_SAS_IOUNIT4_SPINUP_GROUP,
+	*PTR_MPI2_SAS_IOUNIT4_SPINUP_GROUP,
+	Mpi2SasIOUnit4SpinupGroup_t,
+	*pMpi2SasIOUnit4SpinupGroup_t;
+/*defines for SAS IO Unit Page 4 SpinupFlags */
+#define MPI2_SASIOUNIT4_SPINUP_DISABLE_FLAG         (0x01)
+
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhys at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT4_PHY_MAX
+#define MPI2_SAS_IOUNIT4_PHY_MAX        (4)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_4 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;/*0x00 */
+	MPI2_SAS_IOUNIT4_SPINUP_GROUP
+		SpinupGroupParameters[4];       /*0x08 */
+	U32
+		Reserved1;                      /*0x18 */
+	U32
+		Reserved2;                      /*0x1C */
+	U32
+		Reserved3;                      /*0x20 */
+	U8
+		BootDeviceWaitTime;             /*0x24 */
+	U8
+		Reserved4;                      /*0x25 */
+	U16
+		Reserved5;                      /*0x26 */
+	U8
+		NumPhys;                        /*0x28 */
+	U8
+		PEInitialSpinupDelay;           /*0x29 */
+	U8
+		PEReplyDelay;                   /*0x2A */
+	U8
+		Flags;                          /*0x2B */
+	U8
+		PHY[MPI2_SAS_IOUNIT4_PHY_MAX];  /*0x2C */
+} MPI2_CONFIG_PAGE_SASIOUNIT_4,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_4,
+	Mpi2SasIOUnitPage4_t, *pMpi2SasIOUnitPage4_t;
+
+#define MPI2_SASIOUNITPAGE4_PAGEVERSION     (0x02)
+
+/*defines for Flags field */
+#define MPI2_SASIOUNIT4_FLAGS_AUTO_PORTENABLE               (0x01)
+
+/*defines for PHY field */
+#define MPI2_SASIOUNIT4_PHY_SPINUP_GROUP_MASK               (0x03)
+
+
+/*SAS IO Unit Page 5 */
+
+typedef struct _MPI2_SAS_IO_UNIT5_PHY_PM_SETTINGS {
+	U8          ControlFlags;               /*0x00 */
+	U8          PortWidthModGroup;          /*0x01 */
+	U16         InactivityTimerExponent;    /*0x02 */
+	U8          SATAPartialTimeout;         /*0x04 */
+	U8          Reserved2;                  /*0x05 */
+	U8          SATASlumberTimeout;         /*0x06 */
+	U8          Reserved3;                  /*0x07 */
+	U8          SASPartialTimeout;          /*0x08 */
+	U8          Reserved4;                  /*0x09 */
+	U8          SASSlumberTimeout;          /*0x0A */
+	U8          Reserved5;                  /*0x0B */
+} MPI2_SAS_IO_UNIT5_PHY_PM_SETTINGS,
+	*PTR_MPI2_SAS_IO_UNIT5_PHY_PM_SETTINGS,
+	Mpi2SasIOUnit5PhyPmSettings_t,
+	*pMpi2SasIOUnit5PhyPmSettings_t;
+
+/*defines for ControlFlags field */
+#define MPI2_SASIOUNIT5_CONTROL_SAS_SLUMBER_ENABLE      (0x08)
+#define MPI2_SASIOUNIT5_CONTROL_SAS_PARTIAL_ENABLE      (0x04)
+#define MPI2_SASIOUNIT5_CONTROL_SATA_SLUMBER_ENABLE     (0x02)
+#define MPI2_SASIOUNIT5_CONTROL_SATA_PARTIAL_ENABLE     (0x01)
+
+/*defines for PortWidthModeGroup field */
+#define MPI2_SASIOUNIT5_PWMG_DISABLE                    (0xFF)
+
+/*defines for InactivityTimerExponent field */
+#define MPI2_SASIOUNIT5_ITE_MASK_SAS_SLUMBER            (0x7000)
+#define MPI2_SASIOUNIT5_ITE_SHIFT_SAS_SLUMBER           (12)
+#define MPI2_SASIOUNIT5_ITE_MASK_SAS_PARTIAL            (0x0700)
+#define MPI2_SASIOUNIT5_ITE_SHIFT_SAS_PARTIAL           (8)
+#define MPI2_SASIOUNIT5_ITE_MASK_SATA_SLUMBER           (0x0070)
+#define MPI2_SASIOUNIT5_ITE_SHIFT_SATA_SLUMBER          (4)
+#define MPI2_SASIOUNIT5_ITE_MASK_SATA_PARTIAL           (0x0007)
+#define MPI2_SASIOUNIT5_ITE_SHIFT_SATA_PARTIAL          (0)
+
+#define MPI2_SASIOUNIT5_ITE_TEN_SECONDS                 (7)
+#define MPI2_SASIOUNIT5_ITE_ONE_SECOND                  (6)
+#define MPI2_SASIOUNIT5_ITE_HUNDRED_MILLISECONDS        (5)
+#define MPI2_SASIOUNIT5_ITE_TEN_MILLISECONDS            (4)
+#define MPI2_SASIOUNIT5_ITE_ONE_MILLISECOND             (3)
+#define MPI2_SASIOUNIT5_ITE_HUNDRED_MICROSECONDS        (2)
+#define MPI2_SASIOUNIT5_ITE_TEN_MICROSECONDS            (1)
+#define MPI2_SASIOUNIT5_ITE_ONE_MICROSECOND             (0)
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhys at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT5_PHY_MAX
+#define MPI2_SAS_IOUNIT5_PHY_MAX        (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_5 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;   /*0x00 */
+	U8                                  NumPhys;  /*0x08 */
+	U8                                  Reserved1;/*0x09 */
+	U16                                 Reserved2;/*0x0A */
+	U32                                 Reserved3;/*0x0C */
+	MPI2_SAS_IO_UNIT5_PHY_PM_SETTINGS
+	SASPhyPowerManagementSettings[MPI2_SAS_IOUNIT5_PHY_MAX];/*0x10 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_5,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_5,
+	Mpi2SasIOUnitPage5_t, *pMpi2SasIOUnitPage5_t;
+
+#define MPI2_SASIOUNITPAGE5_PAGEVERSION     (0x01)
+
+
+/*SAS IO Unit Page 6 */
+
+typedef struct _MPI2_SAS_IO_UNIT6_PORT_WIDTH_MOD_GROUP_STATUS {
+	U8          CurrentStatus;              /*0x00 */
+	U8          CurrentModulation;          /*0x01 */
+	U8          CurrentUtilization;         /*0x02 */
+	U8          Reserved1;                  /*0x03 */
+	U32         Reserved2;                  /*0x04 */
+} MPI2_SAS_IO_UNIT6_PORT_WIDTH_MOD_GROUP_STATUS,
+	*PTR_MPI2_SAS_IO_UNIT6_PORT_WIDTH_MOD_GROUP_STATUS,
+	Mpi2SasIOUnit6PortWidthModGroupStatus_t,
+	*pMpi2SasIOUnit6PortWidthModGroupStatus_t;
+
+/*defines for CurrentStatus field */
+#define MPI2_SASIOUNIT6_STATUS_UNAVAILABLE                      (0x00)
+#define MPI2_SASIOUNIT6_STATUS_UNCONFIGURED                     (0x01)
+#define MPI2_SASIOUNIT6_STATUS_INVALID_CONFIG                   (0x02)
+#define MPI2_SASIOUNIT6_STATUS_LINK_DOWN                        (0x03)
+#define MPI2_SASIOUNIT6_STATUS_OBSERVATION_ONLY                 (0x04)
+#define MPI2_SASIOUNIT6_STATUS_INACTIVE                         (0x05)
+#define MPI2_SASIOUNIT6_STATUS_ACTIVE_IOUNIT                    (0x06)
+#define MPI2_SASIOUNIT6_STATUS_ACTIVE_HOST                      (0x07)
+
+/*defines for CurrentModulation field */
+#define MPI2_SASIOUNIT6_MODULATION_25_PERCENT                   (0x00)
+#define MPI2_SASIOUNIT6_MODULATION_50_PERCENT                   (0x01)
+#define MPI2_SASIOUNIT6_MODULATION_75_PERCENT                   (0x02)
+#define MPI2_SASIOUNIT6_MODULATION_100_PERCENT                  (0x03)
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumGroups at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT6_GROUP_MAX
+#define MPI2_SAS_IOUNIT6_GROUP_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_6 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                 /*0x00 */
+	U32                                 Reserved1;              /*0x08 */
+	U32                                 Reserved2;              /*0x0C */
+	U8                                  NumGroups;              /*0x10 */
+	U8                                  Reserved3;              /*0x11 */
+	U16                                 Reserved4;              /*0x12 */
+	MPI2_SAS_IO_UNIT6_PORT_WIDTH_MOD_GROUP_STATUS
+	PortWidthModulationGroupStatus[MPI2_SAS_IOUNIT6_GROUP_MAX]; /*0x14 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_6,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_6,
+	Mpi2SasIOUnitPage6_t, *pMpi2SasIOUnitPage6_t;
+
+#define MPI2_SASIOUNITPAGE6_PAGEVERSION     (0x00)
+
+
+/*SAS IO Unit Page 7 */
+
+typedef struct _MPI2_SAS_IO_UNIT7_PORT_WIDTH_MOD_GROUP_SETTINGS {
+	U8          Flags;                      /*0x00 */
+	U8          Reserved1;                  /*0x01 */
+	U16         Reserved2;                  /*0x02 */
+	U8          Threshold75Pct;             /*0x04 */
+	U8          Threshold50Pct;             /*0x05 */
+	U8          Threshold25Pct;             /*0x06 */
+	U8          Reserved3;                  /*0x07 */
+} MPI2_SAS_IO_UNIT7_PORT_WIDTH_MOD_GROUP_SETTINGS,
+	*PTR_MPI2_SAS_IO_UNIT7_PORT_WIDTH_MOD_GROUP_SETTINGS,
+	Mpi2SasIOUnit7PortWidthModGroupSettings_t,
+	*pMpi2SasIOUnit7PortWidthModGroupSettings_t;
+
+/*defines for Flags field */
+#define MPI2_SASIOUNIT7_FLAGS_ENABLE_PORT_WIDTH_MODULATION  (0x01)
+
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumGroups at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT7_GROUP_MAX
+#define MPI2_SAS_IOUNIT7_GROUP_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_7 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER Header;             /*0x00 */
+	U8                               SamplingInterval;   /*0x08 */
+	U8                               WindowLength;       /*0x09 */
+	U16                              Reserved1;          /*0x0A */
+	U32                              Reserved2;          /*0x0C */
+	U32                              Reserved3;          /*0x10 */
+	U8                               NumGroups;          /*0x14 */
+	U8                               Reserved4;          /*0x15 */
+	U16                              Reserved5;          /*0x16 */
+	MPI2_SAS_IO_UNIT7_PORT_WIDTH_MOD_GROUP_SETTINGS
+	PortWidthModulationGroupSettings[MPI2_SAS_IOUNIT7_GROUP_MAX];/*0x18 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_7,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_7,
+	Mpi2SasIOUnitPage7_t, *pMpi2SasIOUnitPage7_t;
+
+#define MPI2_SASIOUNITPAGE7_PAGEVERSION     (0x00)
+
+
+/*SAS IO Unit Page 8 */
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_8 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                         /*0x00 */
+	U32
+		Reserved1;                      /*0x08 */
+	U32
+		PowerManagementCapabilities;    /*0x0C */
+	U8
+		TxRxSleepStatus;                /*0x10 */
+	U8
+		Reserved2;                      /*0x11 */
+	U16
+		Reserved3;                      /*0x12 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_8,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_8,
+	Mpi2SasIOUnitPage8_t, *pMpi2SasIOUnitPage8_t;
+
+#define MPI2_SASIOUNITPAGE8_PAGEVERSION     (0x00)
+
+/*defines for PowerManagementCapabilities field */
+#define MPI2_SASIOUNIT8_PM_HOST_PORT_WIDTH_MOD          (0x00001000)
+#define MPI2_SASIOUNIT8_PM_HOST_SAS_SLUMBER_MODE        (0x00000800)
+#define MPI2_SASIOUNIT8_PM_HOST_SAS_PARTIAL_MODE        (0x00000400)
+#define MPI2_SASIOUNIT8_PM_HOST_SATA_SLUMBER_MODE       (0x00000200)
+#define MPI2_SASIOUNIT8_PM_HOST_SATA_PARTIAL_MODE       (0x00000100)
+#define MPI2_SASIOUNIT8_PM_IOUNIT_PORT_WIDTH_MOD        (0x00000010)
+#define MPI2_SASIOUNIT8_PM_IOUNIT_SAS_SLUMBER_MODE      (0x00000008)
+#define MPI2_SASIOUNIT8_PM_IOUNIT_SAS_PARTIAL_MODE      (0x00000004)
+#define MPI2_SASIOUNIT8_PM_IOUNIT_SATA_SLUMBER_MODE     (0x00000002)
+#define MPI2_SASIOUNIT8_PM_IOUNIT_SATA_PARTIAL_MODE     (0x00000001)
+
+/*defines for TxRxSleepStatus field */
+#define MPI25_SASIOUNIT8_TXRXSLEEP_UNSUPPORTED          (0x00)
+#define MPI25_SASIOUNIT8_TXRXSLEEP_DISENGAGED           (0x01)
+#define MPI25_SASIOUNIT8_TXRXSLEEP_ACTIVE               (0x02)
+#define MPI25_SASIOUNIT8_TXRXSLEEP_SHUTDOWN             (0x03)
+
+
+
+/*SAS IO Unit Page 16 */
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT16 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                             /*0x00 */
+	U64
+		TimeStamp;                          /*0x08 */
+	U32
+		Reserved1;                          /*0x10 */
+	U32
+		Reserved2;                          /*0x14 */
+	U32
+		FastPathPendedRequests;             /*0x18 */
+	U32
+		FastPathUnPendedRequests;           /*0x1C */
+	U32
+		FastPathHostRequestStarts;          /*0x20 */
+	U32
+		FastPathFirmwareRequestStarts;      /*0x24 */
+	U32
+		FastPathHostCompletions;            /*0x28 */
+	U32
+		FastPathFirmwareCompletions;        /*0x2C */
+	U32
+		NonFastPathRequestStarts;           /*0x30 */
+	U32
+		NonFastPathHostCompletions;         /*0x30 */
+} MPI2_CONFIG_PAGE_SASIOUNIT16,
+	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT16,
+	Mpi2SasIOUnitPage16_t, *pMpi2SasIOUnitPage16_t;
+
+#define MPI2_SASIOUNITPAGE16_PAGEVERSION    (0x00)
+
+
+/****************************************************************************
+*  SAS Expander Config Pages
+****************************************************************************/
+
+/*SAS Expander Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_EXPANDER_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U8
+		PhysicalPort;               /*0x08 */
+	U8
+		ReportGenLength;            /*0x09 */
+	U16
+		EnclosureHandle;            /*0x0A */
+	U64
+		SASAddress;                 /*0x0C */
+	U32
+		DiscoveryStatus;            /*0x14 */
+	U16
+		DevHandle;                  /*0x18 */
+	U16
+		ParentDevHandle;            /*0x1A */
+	U16
+		ExpanderChangeCount;        /*0x1C */
+	U16
+		ExpanderRouteIndexes;       /*0x1E */
+	U8
+		NumPhys;                    /*0x20 */
+	U8
+		SASLevel;                   /*0x21 */
+	U16
+		Flags;                      /*0x22 */
+	U16
+		STPBusInactivityTimeLimit;  /*0x24 */
+	U16
+		STPMaxConnectTimeLimit;     /*0x26 */
+	U16
+		STP_SMP_NexusLossTime;      /*0x28 */
+	U16
+		MaxNumRoutedSasAddresses;   /*0x2A */
+	U64
+		ActiveZoneManagerSASAddress;/*0x2C */
+	U16
+		ZoneLockInactivityLimit;    /*0x34 */
+	U16
+		Reserved1;                  /*0x36 */
+	U8
+		TimeToReducedFunc;          /*0x38 */
+	U8
+		InitialTimeToReducedFunc;   /*0x39 */
+	U8
+		MaxReducedFuncTime;         /*0x3A */
+	U8
+		Reserved2;                  /*0x3B */
+} MPI2_CONFIG_PAGE_EXPANDER_0,
+	*PTR_MPI2_CONFIG_PAGE_EXPANDER_0,
+	Mpi2ExpanderPage0_t, *pMpi2ExpanderPage0_t;
+
+#define MPI2_SASEXPANDER0_PAGEVERSION       (0x06)
+
+/*values for SAS Expander Page 0 DiscoveryStatus field */
+#define MPI2_SAS_EXPANDER0_DS_MAX_ENCLOSURES_EXCEED         (0x80000000)
+#define MPI2_SAS_EXPANDER0_DS_MAX_EXPANDERS_EXCEED          (0x40000000)
+#define MPI2_SAS_EXPANDER0_DS_MAX_DEVICES_EXCEED            (0x20000000)
+#define MPI2_SAS_EXPANDER0_DS_MAX_TOPO_PHYS_EXCEED          (0x10000000)
+#define MPI2_SAS_EXPANDER0_DS_DOWNSTREAM_INITIATOR          (0x08000000)
+#define MPI2_SAS_EXPANDER0_DS_MULTI_SUBTRACTIVE_SUBTRACTIVE (0x00008000)
+#define MPI2_SAS_EXPANDER0_DS_EXP_MULTI_SUBTRACTIVE         (0x00004000)
+#define MPI2_SAS_EXPANDER0_DS_MULTI_PORT_DOMAIN             (0x00002000)
+#define MPI2_SAS_EXPANDER0_DS_TABLE_TO_SUBTRACTIVE_LINK     (0x00001000)
+#define MPI2_SAS_EXPANDER0_DS_UNSUPPORTED_DEVICE            (0x00000800)
+#define MPI2_SAS_EXPANDER0_DS_TABLE_LINK                    (0x00000400)
+#define MPI2_SAS_EXPANDER0_DS_SUBTRACTIVE_LINK              (0x00000200)
+#define MPI2_SAS_EXPANDER0_DS_SMP_CRC_ERROR                 (0x00000100)
+#define MPI2_SAS_EXPANDER0_DS_SMP_FUNCTION_FAILED           (0x00000080)
+#define MPI2_SAS_EXPANDER0_DS_INDEX_NOT_EXIST               (0x00000040)
+#define MPI2_SAS_EXPANDER0_DS_OUT_ROUTE_ENTRIES             (0x00000020)
+#define MPI2_SAS_EXPANDER0_DS_SMP_TIMEOUT                   (0x00000010)
+#define MPI2_SAS_EXPANDER0_DS_MULTIPLE_PORTS                (0x00000004)
+#define MPI2_SAS_EXPANDER0_DS_UNADDRESSABLE_DEVICE          (0x00000002)
+#define MPI2_SAS_EXPANDER0_DS_LOOP_DETECTED                 (0x00000001)
+
+/*values for SAS Expander Page 0 Flags field */
+#define MPI2_SAS_EXPANDER0_FLAGS_REDUCED_FUNCTIONALITY      (0x2000)
+#define MPI2_SAS_EXPANDER0_FLAGS_ZONE_LOCKED                (0x1000)
+#define MPI2_SAS_EXPANDER0_FLAGS_SUPPORTED_PHYSICAL_PRES    (0x0800)
+#define MPI2_SAS_EXPANDER0_FLAGS_ASSERTED_PHYSICAL_PRES     (0x0400)
+#define MPI2_SAS_EXPANDER0_FLAGS_ZONING_SUPPORT             (0x0200)
+#define MPI2_SAS_EXPANDER0_FLAGS_ENABLED_ZONING             (0x0100)
+#define MPI2_SAS_EXPANDER0_FLAGS_TABLE_TO_TABLE_SUPPORT     (0x0080)
+#define MPI2_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE       (0x0010)
+#define MPI2_SAS_EXPANDER0_FLAGS_OTHERS_CONFIG              (0x0004)
+#define MPI2_SAS_EXPANDER0_FLAGS_CONFIG_IN_PROGRESS         (0x0002)
+#define MPI2_SAS_EXPANDER0_FLAGS_ROUTE_TABLE_CONFIG         (0x0001)
+
+
+/*SAS Expander Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_EXPANDER_1 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U8
+		PhysicalPort;               /*0x08 */
+	U8
+		Reserved1;                  /*0x09 */
+	U16
+		Reserved2;                  /*0x0A */
+	U8
+		NumPhys;                    /*0x0C */
+	U8
+		Phy;                        /*0x0D */
+	U16
+		NumTableEntriesProgrammed;  /*0x0E */
+	U8
+		ProgrammedLinkRate;         /*0x10 */
+	U8
+		HwLinkRate;                 /*0x11 */
+	U16
+		AttachedDevHandle;          /*0x12 */
+	U32
+		PhyInfo;                    /*0x14 */
+	U32
+		AttachedDeviceInfo;         /*0x18 */
+	U16
+		ExpanderDevHandle;          /*0x1C */
+	U8
+		ChangeCount;                /*0x1E */
+	U8
+		NegotiatedLinkRate;         /*0x1F */
+	U8
+		PhyIdentifier;              /*0x20 */
+	U8
+		AttachedPhyIdentifier;      /*0x21 */
+	U8
+		Reserved3;                  /*0x22 */
+	U8
+		DiscoveryInfo;              /*0x23 */
+	U32
+		AttachedPhyInfo;            /*0x24 */
+	U8
+		ZoneGroup;                  /*0x28 */
+	U8
+		SelfConfigStatus;           /*0x29 */
+	U16
+		Reserved4;                  /*0x2A */
+} MPI2_CONFIG_PAGE_EXPANDER_1,
+	*PTR_MPI2_CONFIG_PAGE_EXPANDER_1,
+	Mpi2ExpanderPage1_t, *pMpi2ExpanderPage1_t;
+
+#define MPI2_SASEXPANDER1_PAGEVERSION       (0x02)
+
+/*use MPI2_SAS_PRATE_ defines for the ProgrammedLinkRate field */
+
+/*use MPI2_SAS_HWRATE_ defines for the HwLinkRate field */
+
+/*use MPI2_SAS_PHYINFO_ for the PhyInfo field */
+
+/*see mpi2_sas.h for the MPI2_SAS_DEVICE_INFO_ defines
+ *used for the AttachedDeviceInfo field */
+
+/*use MPI2_SAS_NEG_LINK_RATE_ defines for the NegotiatedLinkRate field */
+
+/*values for SAS Expander Page 1 DiscoveryInfo field */
+#define MPI2_SAS_EXPANDER1_DISCINFO_BAD_PHY_DISABLED    (0x04)
+#define MPI2_SAS_EXPANDER1_DISCINFO_LINK_STATUS_CHANGE  (0x02)
+#define MPI2_SAS_EXPANDER1_DISCINFO_NO_ROUTING_ENTRIES  (0x01)
+
+/*use MPI2_SAS_APHYINFO_ defines for AttachedPhyInfo field */
+
+
+/****************************************************************************
+*  SAS Device Config Pages
+****************************************************************************/
+
+/*SAS Device Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_DEV_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                 /*0x00 */
+	U16
+		Slot;                   /*0x08 */
+	U16
+		EnclosureHandle;        /*0x0A */
+	U64
+		SASAddress;             /*0x0C */
+	U16
+		ParentDevHandle;        /*0x14 */
+	U8
+		PhyNum;                 /*0x16 */
+	U8
+		AccessStatus;           /*0x17 */
+	U16
+		DevHandle;              /*0x18 */
+	U8
+		AttachedPhyIdentifier;  /*0x1A */
+	U8
+		ZoneGroup;              /*0x1B */
+	U32
+		DeviceInfo;             /*0x1C */
+	U16
+		Flags;                  /*0x20 */
+	U8
+		PhysicalPort;           /*0x22 */
+	U8
+		MaxPortConnections;     /*0x23 */
+	U64
+		DeviceName;             /*0x24 */
+	U8
+		PortGroups;             /*0x2C */
+	U8
+		DmaGroup;               /*0x2D */
+	U8
+		ControlGroup;           /*0x2E */
+	U8
+		Reserved1;              /*0x2F */
+	U32
+		Reserved2;              /*0x30 */
+	U32
+		Reserved3;              /*0x34 */
+} MPI2_CONFIG_PAGE_SAS_DEV_0,
+	*PTR_MPI2_CONFIG_PAGE_SAS_DEV_0,
+	Mpi2SasDevicePage0_t,
+	*pMpi2SasDevicePage0_t;
+
+#define MPI2_SASDEVICE0_PAGEVERSION         (0x08)
+
+/*values for SAS Device Page 0 AccessStatus field */
+#define MPI2_SAS_DEVICE0_ASTATUS_NO_ERRORS                  (0x00)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_INIT_FAILED           (0x01)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_CAPABILITY_FAILED     (0x02)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_AFFILIATION_CONFLICT  (0x03)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_NEEDS_INITIALIZATION  (0x04)
+#define MPI2_SAS_DEVICE0_ASTATUS_ROUTE_NOT_ADDRESSABLE      (0x05)
+#define MPI2_SAS_DEVICE0_ASTATUS_SMP_ERROR_NOT_ADDRESSABLE  (0x06)
+#define MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED             (0x07)
+/*specific values for SATA Init failures */
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_UNKNOWN                (0x10)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_AFFILIATION_CONFLICT   (0x11)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_DIAG                   (0x12)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_IDENTIFICATION         (0x13)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_CHECK_POWER            (0x14)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_PIO_SN                 (0x15)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_MDMA_SN                (0x16)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_UDMA_SN                (0x17)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_ZONING_VIOLATION       (0x18)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_NOT_ADDRESSABLE        (0x19)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_MAX                    (0x1F)
+
+/*see mpi2_sas.h for values for SAS Device Page 0 DeviceInfo values */
+
+/*values for SAS Device Page 0 Flags field */
+#define MPI2_SAS_DEVICE0_FLAGS_UNAUTHORIZED_DEVICE          (0x8000)
+#define MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH           (0x4000)
+#define MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE           (0x2000)
+#define MPI2_SAS_DEVICE0_FLAGS_SLUMBER_PM_CAPABLE           (0x1000)
+#define MPI2_SAS_DEVICE0_FLAGS_PARTIAL_PM_CAPABLE           (0x0800)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_ASYNCHRONOUS_NOTIFY     (0x0400)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_SW_PRESERVE             (0x0200)
+#define MPI2_SAS_DEVICE0_FLAGS_UNSUPPORTED_DEVICE           (0x0100)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_48BIT_LBA_SUPPORTED     (0x0080)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_SMART_SUPPORTED         (0x0040)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_NCQ_SUPPORTED           (0x0020)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_FUA_SUPPORTED           (0x0010)
+#define MPI2_SAS_DEVICE0_FLAGS_PORT_SELECTOR_ATTACH         (0x0008)
+#define MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT               (0x0001)
+
+
+/*SAS Device Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_DEV_1 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                 /*0x00 */
+	U32
+		Reserved1;              /*0x08 */
+	U64
+		SASAddress;             /*0x0C */
+	U32
+		Reserved2;              /*0x14 */
+	U16
+		DevHandle;              /*0x18 */
+	U16
+		Reserved3;              /*0x1A */
+	U8
+		InitialRegDeviceFIS[20];/*0x1C */
+} MPI2_CONFIG_PAGE_SAS_DEV_1,
+	*PTR_MPI2_CONFIG_PAGE_SAS_DEV_1,
+	Mpi2SasDevicePage1_t,
+	*pMpi2SasDevicePage1_t;
+
+#define MPI2_SASDEVICE1_PAGEVERSION         (0x01)
+
+
+/****************************************************************************
+*  SAS PHY Config Pages
+****************************************************************************/
+
+/*SAS PHY Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                 /*0x00 */
+	U16
+		OwnerDevHandle;         /*0x08 */
+	U16
+		Reserved1;              /*0x0A */
+	U16
+		AttachedDevHandle;      /*0x0C */
+	U8
+		AttachedPhyIdentifier;  /*0x0E */
+	U8
+		Reserved2;              /*0x0F */
+	U32
+		AttachedPhyInfo;        /*0x10 */
+	U8
+		ProgrammedLinkRate;     /*0x14 */
+	U8
+		HwLinkRate;             /*0x15 */
+	U8
+		ChangeCount;            /*0x16 */
+	U8
+		Flags;                  /*0x17 */
+	U32
+		PhyInfo;                /*0x18 */
+	U8
+		NegotiatedLinkRate;     /*0x1C */
+	U8
+		Reserved3;              /*0x1D */
+	U16
+		Reserved4;              /*0x1E */
+} MPI2_CONFIG_PAGE_SAS_PHY_0,
+	*PTR_MPI2_CONFIG_PAGE_SAS_PHY_0,
+	Mpi2SasPhyPage0_t, *pMpi2SasPhyPage0_t;
+
+#define MPI2_SASPHY0_PAGEVERSION            (0x03)
+
+/*use MPI2_SAS_APHYINFO_ defines for AttachedPhyInfo field */
+
+/*use MPI2_SAS_PRATE_ defines for the ProgrammedLinkRate field */
+
+/*use MPI2_SAS_HWRATE_ defines for the HwLinkRate field */
+
+/*values for SAS PHY Page 0 Flags field */
+#define MPI2_SAS_PHY0_FLAGS_SGPIO_DIRECT_ATTACH_ENC             (0x01)
+
+/*use MPI2_SAS_PHYINFO_ for the PhyInfo field */
+
+/*use MPI2_SAS_NEG_LINK_RATE_ defines for the NegotiatedLinkRate field */
+
+
+/*SAS PHY Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_1 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U32
+		Reserved1;                  /*0x08 */
+	U32
+		InvalidDwordCount;          /*0x0C */
+	U32
+		RunningDisparityErrorCount; /*0x10 */
+	U32
+		LossDwordSynchCount;        /*0x14 */
+	U32
+		PhyResetProblemCount;       /*0x18 */
+} MPI2_CONFIG_PAGE_SAS_PHY_1,
+	*PTR_MPI2_CONFIG_PAGE_SAS_PHY_1,
+	Mpi2SasPhyPage1_t, *pMpi2SasPhyPage1_t;
+
+#define MPI2_SASPHY1_PAGEVERSION            (0x01)
+
+
+/*SAS PHY Page 2 */
+
+typedef struct _MPI2_SASPHY2_PHY_EVENT {
+	U8          PhyEventCode;       /*0x00 */
+	U8          Reserved1;          /*0x01 */
+	U16         Reserved2;          /*0x02 */
+	U32         PhyEventInfo;       /*0x04 */
+} MPI2_SASPHY2_PHY_EVENT, *PTR_MPI2_SASPHY2_PHY_EVENT,
+	Mpi2SasPhy2PhyEvent_t, *pMpi2SasPhy2PhyEvent_t;
+
+/*use MPI2_SASPHY3_EVENT_CODE_ for the PhyEventCode field */
+
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhyEvents at runtime.
+ */
+#ifndef MPI2_SASPHY2_PHY_EVENT_MAX
+#define MPI2_SASPHY2_PHY_EVENT_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_2 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U32
+		Reserved1;                  /*0x08 */
+	U8
+		NumPhyEvents;               /*0x0C */
+	U8
+		Reserved2;                  /*0x0D */
+	U16
+		Reserved3;                  /*0x0E */
+	MPI2_SASPHY2_PHY_EVENT
+		PhyEvent[MPI2_SASPHY2_PHY_EVENT_MAX]; /*0x10 */
+} MPI2_CONFIG_PAGE_SAS_PHY_2,
+	*PTR_MPI2_CONFIG_PAGE_SAS_PHY_2,
+	Mpi2SasPhyPage2_t,
+	*pMpi2SasPhyPage2_t;
+
+#define MPI2_SASPHY2_PAGEVERSION            (0x00)
+
+
+/*SAS PHY Page 3 */
+
+typedef struct _MPI2_SASPHY3_PHY_EVENT_CONFIG {
+	U8          PhyEventCode;       /*0x00 */
+	U8          Reserved1;          /*0x01 */
+	U16         Reserved2;          /*0x02 */
+	U8          CounterType;        /*0x04 */
+	U8          ThresholdWindow;    /*0x05 */
+	U8          TimeUnits;          /*0x06 */
+	U8          Reserved3;          /*0x07 */
+	U32         EventThreshold;     /*0x08 */
+	U16         ThresholdFlags;     /*0x0C */
+	U16         Reserved4;          /*0x0E */
+} MPI2_SASPHY3_PHY_EVENT_CONFIG,
+	*PTR_MPI2_SASPHY3_PHY_EVENT_CONFIG,
+	Mpi2SasPhy3PhyEventConfig_t,
+	*pMpi2SasPhy3PhyEventConfig_t;
+
+/*values for PhyEventCode field */
+#define MPI2_SASPHY3_EVENT_CODE_NO_EVENT                    (0x00)
+#define MPI2_SASPHY3_EVENT_CODE_INVALID_DWORD               (0x01)
+#define MPI2_SASPHY3_EVENT_CODE_RUNNING_DISPARITY_ERROR     (0x02)
+#define MPI2_SASPHY3_EVENT_CODE_LOSS_DWORD_SYNC             (0x03)
+#define MPI2_SASPHY3_EVENT_CODE_PHY_RESET_PROBLEM           (0x04)
+#define MPI2_SASPHY3_EVENT_CODE_ELASTICITY_BUF_OVERFLOW     (0x05)
+#define MPI2_SASPHY3_EVENT_CODE_RX_ERROR                    (0x06)
+#define MPI2_SASPHY3_EVENT_CODE_RX_ADDR_FRAME_ERROR         (0x20)
+#define MPI2_SASPHY3_EVENT_CODE_TX_AC_OPEN_REJECT           (0x21)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AC_OPEN_REJECT           (0x22)
+#define MPI2_SASPHY3_EVENT_CODE_TX_RC_OPEN_REJECT           (0x23)
+#define MPI2_SASPHY3_EVENT_CODE_RX_RC_OPEN_REJECT           (0x24)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP_PARTIAL_WAITING_ON   (0x25)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP_CONNECT_WAITING_ON   (0x26)
+#define MPI2_SASPHY3_EVENT_CODE_TX_BREAK                    (0x27)
+#define MPI2_SASPHY3_EVENT_CODE_RX_BREAK                    (0x28)
+#define MPI2_SASPHY3_EVENT_CODE_BREAK_TIMEOUT               (0x29)
+#define MPI2_SASPHY3_EVENT_CODE_CONNECTION                  (0x2A)
+#define MPI2_SASPHY3_EVENT_CODE_PEAKTX_PATHWAY_BLOCKED      (0x2B)
+#define MPI2_SASPHY3_EVENT_CODE_PEAKTX_ARB_WAIT_TIME        (0x2C)
+#define MPI2_SASPHY3_EVENT_CODE_PEAK_ARB_WAIT_TIME          (0x2D)
+#define MPI2_SASPHY3_EVENT_CODE_PEAK_CONNECT_TIME           (0x2E)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SSP_FRAMES               (0x40)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SSP_FRAMES               (0x41)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SSP_ERROR_FRAMES         (0x42)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SSP_ERROR_FRAMES         (0x43)
+#define MPI2_SASPHY3_EVENT_CODE_TX_CREDIT_BLOCKED           (0x44)
+#define MPI2_SASPHY3_EVENT_CODE_RX_CREDIT_BLOCKED           (0x45)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SATA_FRAMES              (0x50)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SATA_FRAMES              (0x51)
+#define MPI2_SASPHY3_EVENT_CODE_SATA_OVERFLOW               (0x52)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SMP_FRAMES               (0x60)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SMP_FRAMES               (0x61)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SMP_ERROR_FRAMES         (0x63)
+#define MPI2_SASPHY3_EVENT_CODE_HOTPLUG_TIMEOUT             (0xD0)
+#define MPI2_SASPHY3_EVENT_CODE_MISALIGNED_MUX_PRIMITIVE    (0xD1)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP                      (0xD2)
+
+/*values for the CounterType field */
+#define MPI2_SASPHY3_COUNTER_TYPE_WRAPPING                  (0x00)
+#define MPI2_SASPHY3_COUNTER_TYPE_SATURATING                (0x01)
+#define MPI2_SASPHY3_COUNTER_TYPE_PEAK_VALUE                (0x02)
+
+/*values for the TimeUnits field */
+#define MPI2_SASPHY3_TIME_UNITS_10_MICROSECONDS             (0x00)
+#define MPI2_SASPHY3_TIME_UNITS_100_MICROSECONDS            (0x01)
+#define MPI2_SASPHY3_TIME_UNITS_1_MILLISECOND               (0x02)
+#define MPI2_SASPHY3_TIME_UNITS_10_MILLISECONDS             (0x03)
+
+/*values for the ThresholdFlags field */
+#define MPI2_SASPHY3_TFLAGS_PHY_RESET                       (0x0002)
+#define MPI2_SASPHY3_TFLAGS_EVENT_NOTIFY                    (0x0001)
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumPhyEvents at runtime.
+ */
+#ifndef MPI2_SASPHY3_PHY_EVENT_MAX
+#define MPI2_SASPHY3_PHY_EVENT_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_3 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U32
+		Reserved1;                  /*0x08 */
+	U8
+		NumPhyEvents;               /*0x0C */
+	U8
+		Reserved2;                  /*0x0D */
+	U16
+		Reserved3;                  /*0x0E */
+	MPI2_SASPHY3_PHY_EVENT_CONFIG
+		PhyEventConfig[MPI2_SASPHY3_PHY_EVENT_MAX]; /*0x10 */
+} MPI2_CONFIG_PAGE_SAS_PHY_3,
+	*PTR_MPI2_CONFIG_PAGE_SAS_PHY_3,
+	Mpi2SasPhyPage3_t, *pMpi2SasPhyPage3_t;
+
+#define MPI2_SASPHY3_PAGEVERSION            (0x00)
+
+
+/*SAS PHY Page 4 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_4 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U16
+		Reserved1;                  /*0x08 */
+	U8
+		Reserved2;                  /*0x0A */
+	U8
+		Flags;                      /*0x0B */
+	U8
+		InitialFrame[28];           /*0x0C */
+} MPI2_CONFIG_PAGE_SAS_PHY_4,
+	*PTR_MPI2_CONFIG_PAGE_SAS_PHY_4,
+	Mpi2SasPhyPage4_t, *pMpi2SasPhyPage4_t;
+
+#define MPI2_SASPHY4_PAGEVERSION            (0x00)
+
+/*values for the Flags field */
+#define MPI2_SASPHY4_FLAGS_FRAME_VALID        (0x02)
+#define MPI2_SASPHY4_FLAGS_SATA_FRAME         (0x01)
+
+
+
+
+/****************************************************************************
+*  SAS Port Config Pages
+****************************************************************************/
+
+/*SAS Port Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PORT_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U8
+		PortNumber;                 /*0x08 */
+	U8
+		PhysicalPort;               /*0x09 */
+	U8
+		PortWidth;                  /*0x0A */
+	U8
+		PhysicalPortWidth;          /*0x0B */
+	U8
+		ZoneGroup;                  /*0x0C */
+	U8
+		Reserved1;                  /*0x0D */
+	U16
+		Reserved2;                  /*0x0E */
+	U64
+		SASAddress;                 /*0x10 */
+	U32
+		DeviceInfo;                 /*0x18 */
+	U32
+		Reserved3;                  /*0x1C */
+	U32
+		Reserved4;                  /*0x20 */
+} MPI2_CONFIG_PAGE_SAS_PORT_0,
+	*PTR_MPI2_CONFIG_PAGE_SAS_PORT_0,
+	Mpi2SasPortPage0_t, *pMpi2SasPortPage0_t;
+
+#define MPI2_SASPORT0_PAGEVERSION           (0x00)
+
+/*see mpi2_sas.h for values for SAS Port Page 0 DeviceInfo values */
+
+
+/****************************************************************************
+*  SAS Enclosure Config Pages
+****************************************************************************/
+
+/*SAS Enclosure Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                     /*0x00 */
+	U32
+		Reserved1;                  /*0x08 */
+	U64
+		EnclosureLogicalID;         /*0x0C */
+	U16
+		Flags;                      /*0x14 */
+	U16
+		EnclosureHandle;            /*0x16 */
+	U16
+		NumSlots;                   /*0x18 */
+	U16
+		StartSlot;                  /*0x1A */
+	U16
+		Reserved2;                  /*0x1C */
+	U16
+		SEPDevHandle;               /*0x1E */
+	U32
+		Reserved3;                  /*0x20 */
+	U32
+		Reserved4;                  /*0x24 */
+} MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0,
+	*PTR_MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0,
+	Mpi2SasEnclosurePage0_t, *pMpi2SasEnclosurePage0_t;
+
+#define MPI2_SASENCLOSURE0_PAGEVERSION      (0x03)
+
+/*values for SAS Enclosure Page 0 Flags field */
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_MASK              (0x000F)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_UNKNOWN           (0x0000)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_IOC_SES           (0x0001)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_IOC_SGPIO         (0x0002)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_EXP_SGPIO         (0x0003)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_SES_ENCLOSURE     (0x0004)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_IOC_GPIO          (0x0005)
+
+
+/****************************************************************************
+*  Log Config Page
+****************************************************************************/
+
+/*Log Page 0 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumLogEntries at runtime.
+ */
+#ifndef MPI2_LOG_0_NUM_LOG_ENTRIES
+#define MPI2_LOG_0_NUM_LOG_ENTRIES          (1)
+#endif
+
+#define MPI2_LOG_0_LOG_DATA_LENGTH          (0x1C)
+
+typedef struct _MPI2_LOG_0_ENTRY {
+	U64         TimeStamp;                      /*0x00 */
+	U32         Reserved1;                      /*0x08 */
+	U16         LogSequence;                    /*0x0C */
+	U16         LogEntryQualifier;              /*0x0E */
+	U8          VP_ID;                          /*0x10 */
+	U8          VF_ID;                          /*0x11 */
+	U16         Reserved2;                      /*0x12 */
+	U8
+		LogData[MPI2_LOG_0_LOG_DATA_LENGTH];/*0x14 */
+} MPI2_LOG_0_ENTRY, *PTR_MPI2_LOG_0_ENTRY,
+	Mpi2Log0Entry_t, *pMpi2Log0Entry_t;
+
+/*values for Log Page 0 LogEntry LogEntryQualifier field */
+#define MPI2_LOG_0_ENTRY_QUAL_ENTRY_UNUSED          (0x0000)
+#define MPI2_LOG_0_ENTRY_QUAL_POWER_ON_RESET        (0x0001)
+#define MPI2_LOG_0_ENTRY_QUAL_TIMESTAMP_UPDATE      (0x0002)
+#define MPI2_LOG_0_ENTRY_QUAL_MIN_IMPLEMENT_SPEC    (0x8000)
+#define MPI2_LOG_0_ENTRY_QUAL_MAX_IMPLEMENT_SPEC    (0xFFFF)
+
+typedef struct _MPI2_CONFIG_PAGE_LOG_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;       /*0x00 */
+	U32                                 Reserved1;    /*0x08 */
+	U32                                 Reserved2;    /*0x0C */
+	U16                                 NumLogEntries;/*0x10 */
+	U16                                 Reserved3;    /*0x12 */
+	MPI2_LOG_0_ENTRY
+		LogEntry[MPI2_LOG_0_NUM_LOG_ENTRIES]; /*0x14 */
+} MPI2_CONFIG_PAGE_LOG_0, *PTR_MPI2_CONFIG_PAGE_LOG_0,
+	Mpi2LogPage0_t, *pMpi2LogPage0_t;
+
+#define MPI2_LOG_0_PAGEVERSION              (0x02)
+
+
+/****************************************************************************
+*  RAID Config Page
+****************************************************************************/
+
+/*RAID Page 0 */
+
+/*
+ *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ *one and check the value returned for NumElements at runtime.
+ */
+#ifndef MPI2_RAIDCONFIG0_MAX_ELEMENTS
+#define MPI2_RAIDCONFIG0_MAX_ELEMENTS       (1)
+#endif
+
+typedef struct _MPI2_RAIDCONFIG0_CONFIG_ELEMENT {
+	U16                     ElementFlags;             /*0x00 */
+	U16                     VolDevHandle;             /*0x02 */
+	U8                      HotSparePool;             /*0x04 */
+	U8                      PhysDiskNum;              /*0x05 */
+	U16                     PhysDiskDevHandle;        /*0x06 */
+} MPI2_RAIDCONFIG0_CONFIG_ELEMENT,
+	*PTR_MPI2_RAIDCONFIG0_CONFIG_ELEMENT,
+	Mpi2RaidConfig0ConfigElement_t,
+	*pMpi2RaidConfig0ConfigElement_t;
+
+/*values for the ElementFlags field */
+#define MPI2_RAIDCONFIG0_EFLAGS_MASK_ELEMENT_TYPE       (0x000F)
+#define MPI2_RAIDCONFIG0_EFLAGS_VOLUME_ELEMENT          (0x0000)
+#define MPI2_RAIDCONFIG0_EFLAGS_VOL_PHYS_DISK_ELEMENT   (0x0001)
+#define MPI2_RAIDCONFIG0_EFLAGS_HOT_SPARE_ELEMENT       (0x0002)
+#define MPI2_RAIDCONFIG0_EFLAGS_OCE_ELEMENT             (0x0003)
+
+
+typedef struct _MPI2_CONFIG_PAGE_RAID_CONFIGURATION_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;         /*0x00 */
+	U8                                  NumHotSpares;   /*0x08 */
+	U8                                  NumPhysDisks;   /*0x09 */
+	U8                                  NumVolumes;     /*0x0A */
+	U8                                  ConfigNum;      /*0x0B */
+	U32                                 Flags;          /*0x0C */
+	U8                                  ConfigGUID[24]; /*0x10 */
+	U32                                 Reserved1;      /*0x28 */
+	U8                                  NumElements;    /*0x2C */
+	U8                                  Reserved2;      /*0x2D */
+	U16                                 Reserved3;      /*0x2E */
+	MPI2_RAIDCONFIG0_CONFIG_ELEMENT
+		ConfigElement[MPI2_RAIDCONFIG0_MAX_ELEMENTS]; /*0x30 */
+} MPI2_CONFIG_PAGE_RAID_CONFIGURATION_0,
+	*PTR_MPI2_CONFIG_PAGE_RAID_CONFIGURATION_0,
+	Mpi2RaidConfigurationPage0_t,
+	*pMpi2RaidConfigurationPage0_t;
+
+#define MPI2_RAIDCONFIG0_PAGEVERSION            (0x00)
+
+/*values for RAID Configuration Page 0 Flags field */
+#define MPI2_RAIDCONFIG0_FLAG_FOREIGN_CONFIG        (0x00000001)
+
+
+/****************************************************************************
+*  Driver Persistent Mapping Config Pages
+****************************************************************************/
+
+/*Driver Persistent Mapping Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY {
+	U64	PhysicalIdentifier;         /*0x00 */
+	U16	MappingInformation;         /*0x08 */
+	U16	DeviceIndex;                /*0x0A */
+	U32	PhysicalBitsMapping;        /*0x0C */
+	U32	Reserved1;                  /*0x10 */
+} MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY,
+	*PTR_MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY,
+	Mpi2DriverMap0Entry_t, *pMpi2DriverMap0Entry_t;
+
+typedef struct _MPI2_CONFIG_PAGE_DRIVER_MAPPING_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header; /*0x00 */
+	MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY  Entry;  /*0x08 */
+} MPI2_CONFIG_PAGE_DRIVER_MAPPING_0,
+	*PTR_MPI2_CONFIG_PAGE_DRIVER_MAPPING_0,
+	Mpi2DriverMappingPage0_t, *pMpi2DriverMappingPage0_t;
+
+#define MPI2_DRIVERMAPPING0_PAGEVERSION         (0x00)
+
+/*values for Driver Persistent Mapping Page 0 MappingInformation field */
+#define MPI2_DRVMAP0_MAPINFO_SLOT_MASK              (0x07F0)
+#define MPI2_DRVMAP0_MAPINFO_SLOT_SHIFT             (4)
+#define MPI2_DRVMAP0_MAPINFO_MISSING_MASK           (0x000F)
+
+
+/****************************************************************************
+*  Ethernet Config Pages
+****************************************************************************/
+
+/*Ethernet Page 0 */
+
+/*IP address (union of IPv4 and IPv6) */
+typedef union _MPI2_ETHERNET_IP_ADDR {
+	U32     IPv4Addr;
+	U32     IPv6Addr[4];
+} MPI2_ETHERNET_IP_ADDR, *PTR_MPI2_ETHERNET_IP_ADDR,
+	Mpi2EthernetIpAddr_t, *pMpi2EthernetIpAddr_t;
+
+#define MPI2_ETHERNET_HOST_NAME_LENGTH          (32)
+
+typedef struct _MPI2_CONFIG_PAGE_ETHERNET_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;          /*0x00 */
+	U8                                  NumInterfaces;   /*0x08 */
+	U8                                  Reserved0;       /*0x09 */
+	U16                                 Reserved1;       /*0x0A */
+	U32                                 Status;          /*0x0C */
+	U8                                  MediaState;      /*0x10 */
+	U8                                  Reserved2;       /*0x11 */
+	U16                                 Reserved3;       /*0x12 */
+	U8                                  MacAddress[6];   /*0x14 */
+	U8                                  Reserved4;       /*0x1A */
+	U8                                  Reserved5;       /*0x1B */
+	MPI2_ETHERNET_IP_ADDR               IpAddress;       /*0x1C */
+	MPI2_ETHERNET_IP_ADDR               SubnetMask;      /*0x2C */
+	MPI2_ETHERNET_IP_ADDR               GatewayIpAddress;/*0x3C */
+	MPI2_ETHERNET_IP_ADDR               DNS1IpAddress;   /*0x4C */
+	MPI2_ETHERNET_IP_ADDR               DNS2IpAddress;   /*0x5C */
+	MPI2_ETHERNET_IP_ADDR               DhcpIpAddress;   /*0x6C */
+	U8
+		HostName[MPI2_ETHERNET_HOST_NAME_LENGTH];/*0x7C */
+} MPI2_CONFIG_PAGE_ETHERNET_0,
+	*PTR_MPI2_CONFIG_PAGE_ETHERNET_0,
+	Mpi2EthernetPage0_t, *pMpi2EthernetPage0_t;
+
+#define MPI2_ETHERNETPAGE0_PAGEVERSION   (0x00)
+
+/*values for Ethernet Page 0 Status field */
+#define MPI2_ETHPG0_STATUS_IPV6_CAPABLE             (0x80000000)
+#define MPI2_ETHPG0_STATUS_IPV4_CAPABLE             (0x40000000)
+#define MPI2_ETHPG0_STATUS_CONSOLE_CONNECTED        (0x20000000)
+#define MPI2_ETHPG0_STATUS_DEFAULT_IF               (0x00000100)
+#define MPI2_ETHPG0_STATUS_FW_DWNLD_ENABLED         (0x00000080)
+#define MPI2_ETHPG0_STATUS_TELNET_ENABLED           (0x00000040)
+#define MPI2_ETHPG0_STATUS_SSH2_ENABLED             (0x00000020)
+#define MPI2_ETHPG0_STATUS_DHCP_CLIENT_ENABLED      (0x00000010)
+#define MPI2_ETHPG0_STATUS_IPV6_ENABLED             (0x00000008)
+#define MPI2_ETHPG0_STATUS_IPV4_ENABLED             (0x00000004)
+#define MPI2_ETHPG0_STATUS_IPV6_ADDRESSES           (0x00000002)
+#define MPI2_ETHPG0_STATUS_ETH_IF_ENABLED           (0x00000001)
+
+/*values for Ethernet Page 0 MediaState field */
+#define MPI2_ETHPG0_MS_DUPLEX_MASK                  (0x80)
+#define MPI2_ETHPG0_MS_HALF_DUPLEX                  (0x00)
+#define MPI2_ETHPG0_MS_FULL_DUPLEX                  (0x80)
+
+#define MPI2_ETHPG0_MS_CONNECT_SPEED_MASK           (0x07)
+#define MPI2_ETHPG0_MS_NOT_CONNECTED                (0x00)
+#define MPI2_ETHPG0_MS_10MBIT                       (0x01)
+#define MPI2_ETHPG0_MS_100MBIT                      (0x02)
+#define MPI2_ETHPG0_MS_1GBIT                        (0x03)
+
+
+/*Ethernet Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_ETHERNET_1 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                 /*0x00 */
+	U32
+		Reserved0;              /*0x08 */
+	U32
+		Flags;                  /*0x0C */
+	U8
+		MediaState;             /*0x10 */
+	U8
+		Reserved1;              /*0x11 */
+	U16
+		Reserved2;              /*0x12 */
+	U8
+		MacAddress[6];          /*0x14 */
+	U8
+		Reserved3;              /*0x1A */
+	U8
+		Reserved4;              /*0x1B */
+	MPI2_ETHERNET_IP_ADDR
+		StaticIpAddress;        /*0x1C */
+	MPI2_ETHERNET_IP_ADDR
+		StaticSubnetMask;       /*0x2C */
+	MPI2_ETHERNET_IP_ADDR
+		StaticGatewayIpAddress; /*0x3C */
+	MPI2_ETHERNET_IP_ADDR
+		StaticDNS1IpAddress;    /*0x4C */
+	MPI2_ETHERNET_IP_ADDR
+		StaticDNS2IpAddress;    /*0x5C */
+	U32
+		Reserved5;              /*0x6C */
+	U32
+		Reserved6;              /*0x70 */
+	U32
+		Reserved7;              /*0x74 */
+	U32
+		Reserved8;              /*0x78 */
+	U8
+		HostName[MPI2_ETHERNET_HOST_NAME_LENGTH];/*0x7C */
+} MPI2_CONFIG_PAGE_ETHERNET_1,
+	*PTR_MPI2_CONFIG_PAGE_ETHERNET_1,
+	Mpi2EthernetPage1_t, *pMpi2EthernetPage1_t;
+
+#define MPI2_ETHERNETPAGE1_PAGEVERSION   (0x00)
+
+/*values for Ethernet Page 1 Flags field */
+#define MPI2_ETHPG1_FLAG_SET_DEFAULT_IF             (0x00000100)
+#define MPI2_ETHPG1_FLAG_ENABLE_FW_DOWNLOAD         (0x00000080)
+#define MPI2_ETHPG1_FLAG_ENABLE_TELNET              (0x00000040)
+#define MPI2_ETHPG1_FLAG_ENABLE_SSH2                (0x00000020)
+#define MPI2_ETHPG1_FLAG_ENABLE_DHCP_CLIENT         (0x00000010)
+#define MPI2_ETHPG1_FLAG_ENABLE_IPV6                (0x00000008)
+#define MPI2_ETHPG1_FLAG_ENABLE_IPV4                (0x00000004)
+#define MPI2_ETHPG1_FLAG_USE_IPV6_ADDRESSES         (0x00000002)
+#define MPI2_ETHPG1_FLAG_ENABLE_ETH_IF              (0x00000001)
+
+/*values for Ethernet Page 1 MediaState field */
+#define MPI2_ETHPG1_MS_DUPLEX_MASK                  (0x80)
+#define MPI2_ETHPG1_MS_HALF_DUPLEX                  (0x00)
+#define MPI2_ETHPG1_MS_FULL_DUPLEX                  (0x80)
+
+#define MPI2_ETHPG1_MS_DATA_RATE_MASK               (0x07)
+#define MPI2_ETHPG1_MS_DATA_RATE_AUTO               (0x00)
+#define MPI2_ETHPG1_MS_DATA_RATE_10MBIT             (0x01)
+#define MPI2_ETHPG1_MS_DATA_RATE_100MBIT            (0x02)
+#define MPI2_ETHPG1_MS_DATA_RATE_1GBIT              (0x03)
+
+
+/****************************************************************************
+*  Extended Manufacturing Config Pages
+****************************************************************************/
+
+/*
+ *Generic structure to use for product-specific extended manufacturing pages
+ *(currently Extended Manufacturing Page 40 through Extended Manufacturing
+ *Page 60).
+ */
+
+typedef struct _MPI2_CONFIG_PAGE_EXT_MAN_PS {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER
+		Header;                 /*0x00 */
+	U32
+		ProductSpecificInfo;    /*0x08 */
+} MPI2_CONFIG_PAGE_EXT_MAN_PS,
+	*PTR_MPI2_CONFIG_PAGE_EXT_MAN_PS,
+	Mpi2ExtManufacturingPagePS_t,
+	*pMpi2ExtManufacturingPagePS_t;
+
+/*PageVersion should be provided by product-specific code */
+
+#endif
