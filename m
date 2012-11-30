From: <sreekanth.reddy@lsi.com>
Subject: [v2 PATCH 6/20][SCSI] mpt3sas: Part 5 of MPI API headers
Date: Fri, 30 Nov 2012 07:48:18 +0530
Message-ID: <20121130021818.GA10209@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:38845 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab2K2PVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Nov 2012 10:21:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This patch contains MPI API headers
This patch is part 5 of MPI API headers.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_raid.h b/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
new file mode 100644
index 0000000..d1d9866
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
@@ -0,0 +1,346 @@
+/*
+ * Copyright (c) 2000-2012 LSI Corporation.
+ *
+ *
+ *          Name:  mpi2_raid.h
+ *         Title:  MPI Integrated RAID messages and structures
+ * Creation Date:  April 26, 2007
+ *
+ *   mpi2_raid.h Version:  02.00.08
+ *
+ * Version History
+ * ---------------
+ *
+ * Date      Version   Description
+ * --------  --------  ------------------------------------------------------
+ * 04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ * 08-31-07  02.00.01  Modifications to RAID Action request and reply,
+ *                     including the Actions and ActionData.
+ * 02-29-08  02.00.02  Added MPI2_RAID_ACTION_ADATA_DISABL_FULL_REBUILD.
+ * 05-21-08  02.00.03  Added MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS so that
+ *                     the PhysDisk array in MPI2_RAID_VOLUME_CREATION_STRUCT
+ *                     can be sized by the build environment.
+ * 07-30-09  02.00.04  Added proper define for the Use Default Settings bit of
+ *                     VolumeCreationFlags and marked the old one as obsolete.
+ * 05-12-10  02.00.05  Added MPI2_RAID_VOL_FLAGS_OP_MDC define.
+ * 08-24-10  02.00.06  Added MPI2_RAID_ACTION_COMPATIBILITY_CHECK along with
+ *                     related structures and defines.
+ *                     Added product-specific range to RAID Action values.
+ * 11-18-11  02.00.07  Incorporating additions for MPI v2.5.
+ * 02-06-12  02.00.08  Added MPI2_RAID_ACTION_PHYSDISK_HIDDEN.
+ * --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_RAID_H
+#define MPI2_RAID_H
+
+/*****************************************************************************
+*
+*              Integrated RAID Messages
+*
+*****************************************************************************/
+
+/****************************************************************************
+* RAID Action messages
+****************************************************************************/
+
+/*ActionDataWord defines for use with MPI2_RAID_ACTION_DELETE_VOLUME action */
+#define MPI2_RAID_ACTION_ADATA_KEEP_LBA0            (0x00000000)
+#define MPI2_RAID_ACTION_ADATA_ZERO_LBA0            (0x00000001)
+
+/*use MPI2_RAIDVOL0_SETTING_ defines from mpi2_cnfg.h for
+ *MPI2_RAID_ACTION_CHANGE_VOL_WRITE_CACHE action */
+
+/*ActionDataWord defines for use with
+ *MPI2_RAID_ACTION_DISABLE_ALL_VOLUMES action */
+#define MPI2_RAID_ACTION_ADATA_DISABL_FULL_REBUILD  (0x00000001)
+
+/*ActionDataWord for MPI2_RAID_ACTION_SET_RAID_FUNCTION_RATE Action */
+typedef struct _MPI2_RAID_ACTION_RATE_DATA {
+	U8 RateToChange;	/*0x00 */
+	U8 RateOrMode;		/*0x01 */
+	U16 DataScrubDuration;	/*0x02 */
+} MPI2_RAID_ACTION_RATE_DATA, *PTR_MPI2_RAID_ACTION_RATE_DATA,
+	Mpi2RaidActionRateData_t, *pMpi2RaidActionRateData_t;
+
+#define MPI2_RAID_ACTION_SET_RATE_RESYNC            (0x00)
+#define MPI2_RAID_ACTION_SET_RATE_DATA_SCRUB        (0x01)
+#define MPI2_RAID_ACTION_SET_RATE_POWERSAVE_MODE    (0x02)
+
+/*ActionDataWord for MPI2_RAID_ACTION_START_RAID_FUNCTION Action */
+typedef struct _MPI2_RAID_ACTION_START_RAID_FUNCTION {
+	U8 RAIDFunction;	/*0x00 */
+	U8 Flags;		/*0x01 */
+	U16 Reserved1;		/*0x02 */
+} MPI2_RAID_ACTION_START_RAID_FUNCTION,
+	*PTR_MPI2_RAID_ACTION_START_RAID_FUNCTION,
+	Mpi2RaidActionStartRaidFunction_t,
+	*pMpi2RaidActionStartRaidFunction_t;
+
+/*defines for the RAIDFunction field */
+#define MPI2_RAID_ACTION_START_BACKGROUND_INIT      (0x00)
+#define MPI2_RAID_ACTION_START_ONLINE_CAP_EXPANSION (0x01)
+#define MPI2_RAID_ACTION_START_CONSISTENCY_CHECK    (0x02)
+
+/*defines for the Flags field */
+#define MPI2_RAID_ACTION_START_NEW                  (0x00)
+#define MPI2_RAID_ACTION_START_RESUME               (0x01)
+
+/*ActionDataWord for MPI2_RAID_ACTION_STOP_RAID_FUNCTION Action */
+typedef struct _MPI2_RAID_ACTION_STOP_RAID_FUNCTION {
+	U8 RAIDFunction;	/*0x00 */
+	U8 Flags;		/*0x01 */
+	U16 Reserved1;		/*0x02 */
+} MPI2_RAID_ACTION_STOP_RAID_FUNCTION,
+	*PTR_MPI2_RAID_ACTION_STOP_RAID_FUNCTION,
+	Mpi2RaidActionStopRaidFunction_t,
+	*pMpi2RaidActionStopRaidFunction_t;
+
+/*defines for the RAIDFunction field */
+#define MPI2_RAID_ACTION_STOP_BACKGROUND_INIT       (0x00)
+#define MPI2_RAID_ACTION_STOP_ONLINE_CAP_EXPANSION  (0x01)
+#define MPI2_RAID_ACTION_STOP_CONSISTENCY_CHECK     (0x02)
+
+/*defines for the Flags field */
+#define MPI2_RAID_ACTION_STOP_ABORT                 (0x00)
+#define MPI2_RAID_ACTION_STOP_PAUSE                 (0x01)
+
+/*ActionDataWord for MPI2_RAID_ACTION_CREATE_HOT_SPARE Action */
+typedef struct _MPI2_RAID_ACTION_HOT_SPARE {
+	U8 HotSparePool;	/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U16 DevHandle;		/*0x02 */
+} MPI2_RAID_ACTION_HOT_SPARE, *PTR_MPI2_RAID_ACTION_HOT_SPARE,
+	Mpi2RaidActionHotSpare_t, *pMpi2RaidActionHotSpare_t;
+
+/*ActionDataWord for MPI2_RAID_ACTION_DEVICE_FW_UPDATE_MODE Action */
+typedef struct _MPI2_RAID_ACTION_FW_UPDATE_MODE {
+	U8 Flags;		/*0x00 */
+	U8 DeviceFirmwareUpdateModeTimeout;	/*0x01 */
+	U16 Reserved1;		/*0x02 */
+} MPI2_RAID_ACTION_FW_UPDATE_MODE,
+	*PTR_MPI2_RAID_ACTION_FW_UPDATE_MODE,
+	Mpi2RaidActionFwUpdateMode_t,
+	*pMpi2RaidActionFwUpdateMode_t;
+
+/*ActionDataWord defines for use with
+ *MPI2_RAID_ACTION_DEVICE_FW_UPDATE_MODE action */
+#define MPI2_RAID_ACTION_ADATA_DISABLE_FW_UPDATE        (0x00)
+#define MPI2_RAID_ACTION_ADATA_ENABLE_FW_UPDATE         (0x01)
+
+typedef union _MPI2_RAID_ACTION_DATA {
+	U32 Word;
+	MPI2_RAID_ACTION_RATE_DATA Rates;
+	MPI2_RAID_ACTION_START_RAID_FUNCTION StartRaidFunction;
+	MPI2_RAID_ACTION_STOP_RAID_FUNCTION StopRaidFunction;
+	MPI2_RAID_ACTION_HOT_SPARE HotSpare;
+	MPI2_RAID_ACTION_FW_UPDATE_MODE FwUpdateMode;
+} MPI2_RAID_ACTION_DATA, *PTR_MPI2_RAID_ACTION_DATA,
+	Mpi2RaidActionData_t, *pMpi2RaidActionData_t;
+
+/*RAID Action Request Message */
+typedef struct _MPI2_RAID_ACTION_REQUEST {
+	U8 Action;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 VolDevHandle;	/*0x04 */
+	U8 PhysDiskNum;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved2;		/*0x0A */
+	U32 Reserved3;		/*0x0C */
+	MPI2_RAID_ACTION_DATA ActionDataWord;	/*0x10 */
+	MPI2_SGE_SIMPLE_UNION ActionDataSGE;	/*0x14 */
+} MPI2_RAID_ACTION_REQUEST, *PTR_MPI2_RAID_ACTION_REQUEST,
+	Mpi2RaidActionRequest_t, *pMpi2RaidActionRequest_t;
+
+/*RAID Action request Action values */
+
+#define MPI2_RAID_ACTION_INDICATOR_STRUCT           (0x01)
+#define MPI2_RAID_ACTION_CREATE_VOLUME              (0x02)
+#define MPI2_RAID_ACTION_DELETE_VOLUME              (0x03)
+#define MPI2_RAID_ACTION_DISABLE_ALL_VOLUMES        (0x04)
+#define MPI2_RAID_ACTION_ENABLE_ALL_VOLUMES         (0x05)
+#define MPI2_RAID_ACTION_PHYSDISK_OFFLINE           (0x0A)
+#define MPI2_RAID_ACTION_PHYSDISK_ONLINE            (0x0B)
+#define MPI2_RAID_ACTION_FAIL_PHYSDISK              (0x0F)
+#define MPI2_RAID_ACTION_ACTIVATE_VOLUME            (0x11)
+#define MPI2_RAID_ACTION_DEVICE_FW_UPDATE_MODE      (0x15)
+#define MPI2_RAID_ACTION_CHANGE_VOL_WRITE_CACHE     (0x17)
+#define MPI2_RAID_ACTION_SET_VOLUME_NAME            (0x18)
+#define MPI2_RAID_ACTION_SET_RAID_FUNCTION_RATE     (0x19)
+#define MPI2_RAID_ACTION_ENABLE_FAILED_VOLUME       (0x1C)
+#define MPI2_RAID_ACTION_CREATE_HOT_SPARE           (0x1D)
+#define MPI2_RAID_ACTION_DELETE_HOT_SPARE           (0x1E)
+#define MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED  (0x20)
+#define MPI2_RAID_ACTION_START_RAID_FUNCTION        (0x21)
+#define MPI2_RAID_ACTION_STOP_RAID_FUNCTION         (0x22)
+#define MPI2_RAID_ACTION_COMPATIBILITY_CHECK        (0x23)
+#define MPI2_RAID_ACTION_PHYSDISK_HIDDEN            (0x24)
+#define MPI2_RAID_ACTION_MIN_PRODUCT_SPECIFIC       (0x80)
+#define MPI2_RAID_ACTION_MAX_PRODUCT_SPECIFIC       (0xFF)
+
+/*RAID Volume Creation Structure */
+
+/*
+ *The following define can be customized for the targeted product.
+ */
+#ifndef MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS
+#define MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS        (1)
+#endif
+
+typedef struct _MPI2_RAID_VOLUME_PHYSDISK {
+	U8 RAIDSetNum;		/*0x00 */
+	U8 PhysDiskMap;		/*0x01 */
+	U16 PhysDiskDevHandle;	/*0x02 */
+} MPI2_RAID_VOLUME_PHYSDISK, *PTR_MPI2_RAID_VOLUME_PHYSDISK,
+	Mpi2RaidVolumePhysDisk_t, *pMpi2RaidVolumePhysDisk_t;
+
+/*defines for the PhysDiskMap field */
+#define MPI2_RAIDACTION_PHYSDISK_PRIMARY            (0x01)
+#define MPI2_RAIDACTION_PHYSDISK_SECONDARY          (0x02)
+
+typedef struct _MPI2_RAID_VOLUME_CREATION_STRUCT {
+	U8 NumPhysDisks;	/*0x00 */
+	U8 VolumeType;		/*0x01 */
+	U16 Reserved1;		/*0x02 */
+	U32 VolumeCreationFlags;	/*0x04 */
+	U32 VolumeSettings;	/*0x08 */
+	U8 Reserved2;		/*0x0C */
+	U8 ResyncRate;		/*0x0D */
+	U16 DataScrubDuration;	/*0x0E */
+	U64 VolumeMaxLBA;	/*0x10 */
+	U32 StripeSize;		/*0x18 */
+	U8 Name[16];		/*0x1C */
+	MPI2_RAID_VOLUME_PHYSDISK
+		PhysDisk[MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS];	/*0x2C */
+} MPI2_RAID_VOLUME_CREATION_STRUCT,
+	*PTR_MPI2_RAID_VOLUME_CREATION_STRUCT,
+	Mpi2RaidVolumeCreationStruct_t,
+	*pMpi2RaidVolumeCreationStruct_t;
+
+/*use MPI2_RAID_VOL_TYPE_ defines from mpi2_cnfg.h for VolumeType */
+
+/*defines for the VolumeCreationFlags field */
+#define MPI2_RAID_VOL_CREATION_DEFAULT_SETTINGS     (0x80000000)
+#define MPI2_RAID_VOL_CREATION_BACKGROUND_INIT      (0x00000004)
+#define MPI2_RAID_VOL_CREATION_LOW_LEVEL_INIT       (0x00000002)
+#define MPI2_RAID_VOL_CREATION_MIGRATE_DATA         (0x00000001)
+/*The following is an obsolete define.
+ *It must be shifted left 24 bits in order to set the proper bit.
+ */
+#define MPI2_RAID_VOL_CREATION_USE_DEFAULT_SETTINGS (0x80)
+
+/*RAID Online Capacity Expansion Structure */
+
+typedef struct _MPI2_RAID_ONLINE_CAPACITY_EXPANSION {
+	U32 Flags;		/*0x00 */
+	U16 DevHandle0;		/*0x04 */
+	U16 Reserved1;		/*0x06 */
+	U16 DevHandle1;		/*0x08 */
+	U16 Reserved2;		/*0x0A */
+} MPI2_RAID_ONLINE_CAPACITY_EXPANSION,
+	*PTR_MPI2_RAID_ONLINE_CAPACITY_EXPANSION,
+	Mpi2RaidOnlineCapacityExpansion_t,
+	*pMpi2RaidOnlineCapacityExpansion_t;
+
+/*RAID Compatibility Input Structure */
+
+typedef struct _MPI2_RAID_COMPATIBILITY_INPUT_STRUCT {
+	U16 SourceDevHandle;	/*0x00 */
+	U16 CandidateDevHandle;	/*0x02 */
+	U32 Flags;		/*0x04 */
+	U32 Reserved1;		/*0x08 */
+	U32 Reserved2;		/*0x0C */
+} MPI2_RAID_COMPATIBILITY_INPUT_STRUCT,
+	*PTR_MPI2_RAID_COMPATIBILITY_INPUT_STRUCT,
+	Mpi2RaidCompatibilityInputStruct_t,
+	*pMpi2RaidCompatibilityInputStruct_t;
+
+/*defines for RAID Compatibility Structure Flags field */
+#define MPI2_RAID_COMPAT_SOURCE_IS_VOLUME_FLAG      (0x00000002)
+#define MPI2_RAID_COMPAT_REPORT_SOURCE_INFO_FLAG    (0x00000001)
+
+/*RAID Volume Indicator Structure */
+
+typedef struct _MPI2_RAID_VOL_INDICATOR {
+	U64 TotalBlocks;	/*0x00 */
+	U64 BlocksRemaining;	/*0x08 */
+	U32 Flags;		/*0x10 */
+} MPI2_RAID_VOL_INDICATOR, *PTR_MPI2_RAID_VOL_INDICATOR,
+	Mpi2RaidVolIndicator_t, *pMpi2RaidVolIndicator_t;
+
+/*defines for RAID Volume Indicator Flags field */
+#define MPI2_RAID_VOL_FLAGS_OP_MASK                 (0x0000000F)
+#define MPI2_RAID_VOL_FLAGS_OP_BACKGROUND_INIT      (0x00000000)
+#define MPI2_RAID_VOL_FLAGS_OP_ONLINE_CAP_EXPANSION (0x00000001)
+#define MPI2_RAID_VOL_FLAGS_OP_CONSISTENCY_CHECK    (0x00000002)
+#define MPI2_RAID_VOL_FLAGS_OP_RESYNC               (0x00000003)
+#define MPI2_RAID_VOL_FLAGS_OP_MDC                  (0x00000004)
+
+/*RAID Compatibility Result Structure */
+
+typedef struct _MPI2_RAID_COMPATIBILITY_RESULT_STRUCT {
+	U8 State;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U16 Reserved2;		/*0x02 */
+	U32 GenericAttributes;	/*0x04 */
+	U32 OEMSpecificAttributes;	/*0x08 */
+	U32 Reserved3;		/*0x0C */
+	U32 Reserved4;		/*0x10 */
+} MPI2_RAID_COMPATIBILITY_RESULT_STRUCT,
+	*PTR_MPI2_RAID_COMPATIBILITY_RESULT_STRUCT,
+	Mpi2RaidCompatibilityResultStruct_t,
+	*pMpi2RaidCompatibilityResultStruct_t;
+
+/*defines for RAID Compatibility Result Structure State field */
+#define MPI2_RAID_COMPAT_STATE_COMPATIBLE           (0x00)
+#define MPI2_RAID_COMPAT_STATE_NOT_COMPATIBLE       (0x01)
+
+/*defines for RAID Compatibility Result Structure GenericAttributes field */
+#define MPI2_RAID_COMPAT_GENATTRIB_4K_SECTOR            (0x00000010)
+
+#define MPI2_RAID_COMPAT_GENATTRIB_MEDIA_MASK           (0x0000000C)
+#define MPI2_RAID_COMPAT_GENATTRIB_SOLID_STATE_DRIVE    (0x00000008)
+#define MPI2_RAID_COMPAT_GENATTRIB_HARD_DISK_DRIVE      (0x00000004)
+
+#define MPI2_RAID_COMPAT_GENATTRIB_PROTOCOL_MASK        (0x00000003)
+#define MPI2_RAID_COMPAT_GENATTRIB_SAS_PROTOCOL         (0x00000002)
+#define MPI2_RAID_COMPAT_GENATTRIB_SATA_PROTOCOL        (0x00000001)
+
+/*RAID Action Reply ActionData union */
+typedef union _MPI2_RAID_ACTION_REPLY_DATA {
+	U32 Word[5];
+	MPI2_RAID_VOL_INDICATOR RaidVolumeIndicator;
+	U16 VolDevHandle;
+	U8 VolumeState;
+	U8 PhysDiskNum;
+	MPI2_RAID_COMPATIBILITY_RESULT_STRUCT RaidCompatibilityResult;
+} MPI2_RAID_ACTION_REPLY_DATA, *PTR_MPI2_RAID_ACTION_REPLY_DATA,
+	Mpi2RaidActionReplyData_t, *pMpi2RaidActionReplyData_t;
+
+/*use MPI2_RAIDVOL0_SETTING_ defines from mpi2_cnfg.h for
+ *MPI2_RAID_ACTION_CHANGE_VOL_WRITE_CACHE action */
+
+/*RAID Action Reply Message */
+typedef struct _MPI2_RAID_ACTION_REPLY {
+	U8 Action;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 VolDevHandle;	/*0x04 */
+	U8 PhysDiskNum;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved2;		/*0x0A */
+	U16 Reserved3;		/*0x0C */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+	MPI2_RAID_ACTION_REPLY_DATA ActionData;	/*0x14 */
+} MPI2_RAID_ACTION_REPLY, *PTR_MPI2_RAID_ACTION_REPLY,
+	Mpi2RaidActionReply_t, *pMpi2RaidActionReply_t;
+
+#endif
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_sas.h b/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
new file mode 100644
index 0000000..b4e7084
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
@@ -0,0 +1,295 @@
+/*
+ * Copyright (c) 2000-2012 LSI Corporation.
+ *
+ *
+ *          Name:  mpi2_sas.h
+ *         Title:  MPI Serial Attached SCSI structures and definitions
+ * Creation Date:  February 9, 2007
+ *
+ * mpi2_sas.h Version:  02.00.07
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
+ * 06-26-07  02.00.01  Added Clear All Persistent Operation to SAS IO Unit
+ *                     Control Request.
+ * 10-02-08  02.00.02  Added Set IOC Parameter Operation to SAS IO Unit Control
+ *                     Request.
+ * 10-28-09  02.00.03  Changed the type of SGL in MPI2_SATA_PASSTHROUGH_REQUEST
+ *                     to MPI2_SGE_IO_UNION since it supports chained SGLs.
+ * 05-12-10  02.00.04  Modified some comments.
+ * 08-11-10  02.00.05  Added NCQ operations to SAS IO Unit Control.
+ * 11-18-11  02.00.06  Incorporating additions for MPI v2.5.
+ * 07-10-12  02.00.07  Added MPI2_SATA_PT_SGE_UNION for use in the SATA
+ *                     Passthrough Request message.
+ * --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_SAS_H
+#define MPI2_SAS_H
+
+/*
+ *Values for SASStatus.
+ */
+#define MPI2_SASSTATUS_SUCCESS                          (0x00)
+#define MPI2_SASSTATUS_UNKNOWN_ERROR                    (0x01)
+#define MPI2_SASSTATUS_INVALID_FRAME                    (0x02)
+#define MPI2_SASSTATUS_UTC_BAD_DEST                     (0x03)
+#define MPI2_SASSTATUS_UTC_BREAK_RECEIVED               (0x04)
+#define MPI2_SASSTATUS_UTC_CONNECT_RATE_NOT_SUPPORTED   (0x05)
+#define MPI2_SASSTATUS_UTC_PORT_LAYER_REQUEST           (0x06)
+#define MPI2_SASSTATUS_UTC_PROTOCOL_NOT_SUPPORTED       (0x07)
+#define MPI2_SASSTATUS_UTC_STP_RESOURCES_BUSY           (0x08)
+#define MPI2_SASSTATUS_UTC_WRONG_DESTINATION            (0x09)
+#define MPI2_SASSTATUS_SHORT_INFORMATION_UNIT           (0x0A)
+#define MPI2_SASSTATUS_LONG_INFORMATION_UNIT            (0x0B)
+#define MPI2_SASSTATUS_XFER_RDY_INCORRECT_WRITE_DATA    (0x0C)
+#define MPI2_SASSTATUS_XFER_RDY_REQUEST_OFFSET_ERROR    (0x0D)
+#define MPI2_SASSTATUS_XFER_RDY_NOT_EXPECTED            (0x0E)
+#define MPI2_SASSTATUS_DATA_INCORRECT_DATA_LENGTH       (0x0F)
+#define MPI2_SASSTATUS_DATA_TOO_MUCH_READ_DATA          (0x10)
+#define MPI2_SASSTATUS_DATA_OFFSET_ERROR                (0x11)
+#define MPI2_SASSTATUS_SDSF_NAK_RECEIVED                (0x12)
+#define MPI2_SASSTATUS_SDSF_CONNECTION_FAILED           (0x13)
+#define MPI2_SASSTATUS_INITIATOR_RESPONSE_TIMEOUT       (0x14)
+
+/*
+ *Values for the SAS DeviceInfo field used in SAS Device Status Change Event
+ *data and SAS Configuration pages.
+ */
+#define MPI2_SAS_DEVICE_INFO_SEP                (0x00004000)
+#define MPI2_SAS_DEVICE_INFO_ATAPI_DEVICE       (0x00002000)
+#define MPI2_SAS_DEVICE_INFO_LSI_DEVICE         (0x00001000)
+#define MPI2_SAS_DEVICE_INFO_DIRECT_ATTACH      (0x00000800)
+#define MPI2_SAS_DEVICE_INFO_SSP_TARGET         (0x00000400)
+#define MPI2_SAS_DEVICE_INFO_STP_TARGET         (0x00000200)
+#define MPI2_SAS_DEVICE_INFO_SMP_TARGET         (0x00000100)
+#define MPI2_SAS_DEVICE_INFO_SATA_DEVICE        (0x00000080)
+#define MPI2_SAS_DEVICE_INFO_SSP_INITIATOR      (0x00000040)
+#define MPI2_SAS_DEVICE_INFO_STP_INITIATOR      (0x00000020)
+#define MPI2_SAS_DEVICE_INFO_SMP_INITIATOR      (0x00000010)
+#define MPI2_SAS_DEVICE_INFO_SATA_HOST          (0x00000008)
+
+#define MPI2_SAS_DEVICE_INFO_MASK_DEVICE_TYPE   (0x00000007)
+#define MPI2_SAS_DEVICE_INFO_NO_DEVICE          (0x00000000)
+#define MPI2_SAS_DEVICE_INFO_END_DEVICE         (0x00000001)
+#define MPI2_SAS_DEVICE_INFO_EDGE_EXPANDER      (0x00000002)
+#define MPI2_SAS_DEVICE_INFO_FANOUT_EXPANDER    (0x00000003)
+
+/*****************************************************************************
+*
+*       SAS Messages
+*
+*****************************************************************************/
+
+/****************************************************************************
+* SMP Passthrough messages
+****************************************************************************/
+
+/*SMP Passthrough Request Message */
+typedef struct _MPI2_SMP_PASSTHROUGH_REQUEST {
+	U8 PassthroughFlags;	/*0x00 */
+	U8 PhysicalPort;	/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 RequestDataLength;	/*0x04 */
+	U8 SGLFlags;		/*0x06*//*MPI v2.0 only. Reserved on MPI v2.5*/
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved1;		/*0x0A */
+	U32 Reserved2;		/*0x0C */
+	U64 SASAddress;		/*0x10 */
+	U32 Reserved3;		/*0x18 */
+	U32 Reserved4;		/*0x1C */
+	MPI2_SIMPLE_SGE_UNION SGL;/*0x20 */
+} MPI2_SMP_PASSTHROUGH_REQUEST, *PTR_MPI2_SMP_PASSTHROUGH_REQUEST,
+	Mpi2SmpPassthroughRequest_t, *pMpi2SmpPassthroughRequest_t;
+
+/*values for PassthroughFlags field */
+#define MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE      (0x80)
+
+/*MPI v2.0: use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
+
+/*SMP Passthrough Reply Message */
+typedef struct _MPI2_SMP_PASSTHROUGH_REPLY {
+	U8 PassthroughFlags;	/*0x00 */
+	U8 PhysicalPort;	/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 ResponseDataLength;	/*0x04 */
+	U8 SGLFlags;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved1;		/*0x0A */
+	U8 Reserved2;		/*0x0C */
+	U8 SASStatus;		/*0x0D */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+	U32 Reserved3;		/*0x14 */
+	U8 ResponseData[4];	/*0x18 */
+} MPI2_SMP_PASSTHROUGH_REPLY, *PTR_MPI2_SMP_PASSTHROUGH_REPLY,
+	Mpi2SmpPassthroughReply_t, *pMpi2SmpPassthroughReply_t;
+
+/*values for PassthroughFlags field */
+#define MPI2_SMP_PT_REPLY_PT_FLAGS_IMMEDIATE    (0x80)
+
+/*values for SASStatus field are at the top of this file */
+
+/****************************************************************************
+* SATA Passthrough messages
+****************************************************************************/
+
+typedef union _MPI2_SATA_PT_SGE_UNION {
+	MPI2_SGE_SIMPLE_UNION MpiSimple;	/*MPI v2.0 only */
+	MPI2_SGE_CHAIN_UNION MpiChain;	/*MPI v2.0 only */
+	MPI2_IEEE_SGE_SIMPLE_UNION IeeeSimple;
+	MPI2_IEEE_SGE_CHAIN_UNION IeeeChain;	/*MPI v2.0 only */
+	MPI25_IEEE_SGE_CHAIN64 IeeeChain64;	/*MPI v2.5 only */
+} MPI2_SATA_PT_SGE_UNION, *PTR_MPI2_SATA_PT_SGE_UNION,
+	Mpi2SataPTSGEUnion_t, *pMpi2SataPTSGEUnion_t;
+
+/*SATA Passthrough Request Message */
+typedef struct _MPI2_SATA_PASSTHROUGH_REQUEST {
+	U16 DevHandle;		/*0x00 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 PassthroughFlags;	/*0x04 */
+	U8 SGLFlags;		/*0x06*//*MPI v2.0 only. Reserved on MPI v2.5*/
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved1;		/*0x0A */
+	U32 Reserved2;		/*0x0C */
+	U32 Reserved3;		/*0x10 */
+	U32 Reserved4;		/*0x14 */
+	U32 DataLength;		/*0x18 */
+	U8 CommandFIS[20];	/*0x1C */
+	MPI2_SATA_PT_SGE_UNION SGL;/*0x30*//*MPI v2.5: IEEE 64 elements only*/
+} MPI2_SATA_PASSTHROUGH_REQUEST, *PTR_MPI2_SATA_PASSTHROUGH_REQUEST,
+	Mpi2SataPassthroughRequest_t,
+	*pMpi2SataPassthroughRequest_t;
+
+/*values for PassthroughFlags field */
+#define MPI2_SATA_PT_REQ_PT_FLAGS_EXECUTE_DIAG      (0x0100)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_DMA               (0x0020)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_PIO               (0x0010)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_UNSPECIFIED_VU    (0x0004)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_WRITE             (0x0002)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_READ              (0x0001)
+
+/*MPI v2.0: use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
+
+/*SATA Passthrough Reply Message */
+typedef struct _MPI2_SATA_PASSTHROUGH_REPLY {
+	U16 DevHandle;		/*0x00 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 PassthroughFlags;	/*0x04 */
+	U8 SGLFlags;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved1;		/*0x0A */
+	U8 Reserved2;		/*0x0C */
+	U8 SASStatus;		/*0x0D */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+	U8 StatusFIS[20];	/*0x14 */
+	U32 StatusControlRegisters;	/*0x28 */
+	U32 TransferCount;	/*0x2C */
+} MPI2_SATA_PASSTHROUGH_REPLY, *PTR_MPI2_SATA_PASSTHROUGH_REPLY,
+	Mpi2SataPassthroughReply_t, *pMpi2SataPassthroughReply_t;
+
+/*values for SASStatus field are at the top of this file */
+
+/****************************************************************************
+* SAS IO Unit Control messages
+****************************************************************************/
+
+/*SAS IO Unit Control Request Message */
+typedef struct _MPI2_SAS_IOUNIT_CONTROL_REQUEST {
+	U8 Operation;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 DevHandle;		/*0x04 */
+	U8 IOCParameter;	/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved3;		/*0x0A */
+	U16 Reserved4;		/*0x0C */
+	U8 PhyNum;		/*0x0E */
+	U8 PrimFlags;		/*0x0F */
+	U32 Primitive;		/*0x10 */
+	U8 LookupMethod;	/*0x14 */
+	U8 Reserved5;		/*0x15 */
+	U16 SlotNumber;		/*0x16 */
+	U64 LookupAddress;	/*0x18 */
+	U32 IOCParameterValue;	/*0x20 */
+	U32 Reserved7;		/*0x24 */
+	U32 Reserved8;		/*0x28 */
+} MPI2_SAS_IOUNIT_CONTROL_REQUEST,
+	*PTR_MPI2_SAS_IOUNIT_CONTROL_REQUEST,
+	Mpi2SasIoUnitControlRequest_t,
+	*pMpi2SasIoUnitControlRequest_t;
+
+/*values for the Operation field */
+#define MPI2_SAS_OP_CLEAR_ALL_PERSISTENT        (0x02)
+#define MPI2_SAS_OP_PHY_LINK_RESET              (0x06)
+#define MPI2_SAS_OP_PHY_HARD_RESET              (0x07)
+#define MPI2_SAS_OP_PHY_CLEAR_ERROR_LOG         (0x08)
+#define MPI2_SAS_OP_SEND_PRIMITIVE              (0x0A)
+#define MPI2_SAS_OP_FORCE_FULL_DISCOVERY        (0x0B)
+#define MPI2_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL (0x0C)
+#define MPI2_SAS_OP_REMOVE_DEVICE               (0x0D)
+#define MPI2_SAS_OP_LOOKUP_MAPPING              (0x0E)
+#define MPI2_SAS_OP_SET_IOC_PARAMETER           (0x0F)
+#define MPI25_SAS_OP_ENABLE_FP_DEVICE           (0x10)
+#define MPI25_SAS_OP_DISABLE_FP_DEVICE          (0x11)
+#define MPI25_SAS_OP_ENABLE_FP_ALL              (0x12)
+#define MPI25_SAS_OP_DISABLE_FP_ALL             (0x13)
+#define MPI2_SAS_OP_DEV_ENABLE_NCQ              (0x14)
+#define MPI2_SAS_OP_DEV_DISABLE_NCQ             (0x15)
+#define MPI2_SAS_OP_PRODUCT_SPECIFIC_MIN        (0x80)
+
+/*values for the PrimFlags field */
+#define MPI2_SAS_PRIMFLAGS_SINGLE               (0x08)
+#define MPI2_SAS_PRIMFLAGS_TRIPLE               (0x02)
+#define MPI2_SAS_PRIMFLAGS_REDUNDANT            (0x01)
+
+/*values for the LookupMethod field */
+#define MPI2_SAS_LOOKUP_METHOD_SAS_ADDRESS          (0x01)
+#define MPI2_SAS_LOOKUP_METHOD_SAS_ENCLOSURE_SLOT   (0x02)
+#define MPI2_SAS_LOOKUP_METHOD_SAS_DEVICE_NAME      (0x03)
+
+/*SAS IO Unit Control Reply Message */
+typedef struct _MPI2_SAS_IOUNIT_CONTROL_REPLY {
+	U8 Operation;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 DevHandle;		/*0x04 */
+	U8 IOCParameter;	/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved3;		/*0x0A */
+	U16 Reserved4;		/*0x0C */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+} MPI2_SAS_IOUNIT_CONTROL_REPLY,
+	*PTR_MPI2_SAS_IOUNIT_CONTROL_REPLY,
+	Mpi2SasIoUnitControlReply_t, *pMpi2SasIoUnitControlReply_t;
+
+#endif
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_tool.h b/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
new file mode 100644
index 0000000..71453d1
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
@@ -0,0 +1,437 @@
+/*
+ * Copyright (c) 2000-2012 LSI Corporation.
+ *
+ *
+ *          Name:  mpi2_tool.h
+ *         Title:  MPI diagnostic tool structures and definitions
+ * Creation Date:  March 26, 2007
+ *
+ *   mpi2_tool.h Version:  02.00.09
+ *
+ * Version History
+ * ---------------
+ *
+ * Date      Version   Description
+ * --------  --------  ------------------------------------------------------
+ * 04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ * 12-18-07  02.00.01  Added Diagnostic Buffer Post and Diagnostic Release
+ *                     structures and defines.
+ * 02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ * 05-06-09  02.00.03  Added ISTWI Read Write Tool and Diagnostic CLI Tool.
+ * 07-30-09  02.00.04  Added ExtendedType field to DiagnosticBufferPost request
+ *                     and reply messages.
+ *                     Added MPI2_DIAG_BUF_TYPE_EXTENDED.
+ *                     Incremented MPI2_DIAG_BUF_TYPE_COUNT.
+ * 05-12-10  02.00.05  Added Diagnostic Data Upload tool.
+ * 08-11-10  02.00.06  Added defines that were missing for Diagnostic Buffer
+ *                     Post Request.
+ * 05-25-11  02.00.07  Added Flags field and related defines to
+ *                     MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST.
+ * 11-18-11  02.00.08  Incorporating additions for MPI v2.5.
+ * 07-10-12  02.00.09  Add MPI v2.5 Toolbox Diagnostic CLI Tool Request
+ *                     message.
+ * --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_TOOL_H
+#define MPI2_TOOL_H
+
+/*****************************************************************************
+*
+*              Toolbox Messages
+*
+*****************************************************************************/
+
+/*defines for the Tools */
+#define MPI2_TOOLBOX_CLEAN_TOOL                     (0x00)
+#define MPI2_TOOLBOX_MEMORY_MOVE_TOOL               (0x01)
+#define MPI2_TOOLBOX_DIAG_DATA_UPLOAD_TOOL          (0x02)
+#define MPI2_TOOLBOX_ISTWI_READ_WRITE_TOOL          (0x03)
+#define MPI2_TOOLBOX_BEACON_TOOL                    (0x05)
+#define MPI2_TOOLBOX_DIAGNOSTIC_CLI_TOOL            (0x06)
+
+/****************************************************************************
+* Toolbox reply
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_REPLY {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U16 Reserved5;		/*0x0C */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+} MPI2_TOOLBOX_REPLY, *PTR_MPI2_TOOLBOX_REPLY,
+	Mpi2ToolboxReply_t, *pMpi2ToolboxReply_t;
+
+/****************************************************************************
+* Toolbox Clean Tool request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_CLEAN_REQUEST {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U32 Flags;		/*0x0C */
+} MPI2_TOOLBOX_CLEAN_REQUEST, *PTR_MPI2_TOOLBOX_CLEAN_REQUEST,
+	Mpi2ToolboxCleanRequest_t, *pMpi2ToolboxCleanRequest_t;
+
+/*values for the Flags field */
+#define MPI2_TOOLBOX_CLEAN_BOOT_SERVICES            (0x80000000)
+#define MPI2_TOOLBOX_CLEAN_PERSIST_MANUFACT_PAGES   (0x40000000)
+#define MPI2_TOOLBOX_CLEAN_OTHER_PERSIST_PAGES      (0x20000000)
+#define MPI2_TOOLBOX_CLEAN_FW_CURRENT               (0x10000000)
+#define MPI2_TOOLBOX_CLEAN_FW_BACKUP                (0x08000000)
+#define MPI2_TOOLBOX_CLEAN_MEGARAID                 (0x02000000)
+#define MPI2_TOOLBOX_CLEAN_INITIALIZATION           (0x01000000)
+#define MPI2_TOOLBOX_CLEAN_FLASH                    (0x00000004)
+#define MPI2_TOOLBOX_CLEAN_SEEPROM                  (0x00000002)
+#define MPI2_TOOLBOX_CLEAN_NVSRAM                   (0x00000001)
+
+/****************************************************************************
+* Toolbox Memory Move request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_MEM_MOVE_REQUEST {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	MPI2_SGE_SIMPLE_UNION SGL;	/*0x0C */
+} MPI2_TOOLBOX_MEM_MOVE_REQUEST, *PTR_MPI2_TOOLBOX_MEM_MOVE_REQUEST,
+	Mpi2ToolboxMemMoveRequest_t, *pMpi2ToolboxMemMoveRequest_t;
+
+/****************************************************************************
+* Toolbox Diagnostic Data Upload request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U8 SGLFlags;		/*0x0C */
+	U8 Reserved5;		/*0x0D */
+	U16 Reserved6;		/*0x0E */
+	U32 Flags;		/*0x10 */
+	U32 DataLength;		/*0x14 */
+	MPI2_SGE_SIMPLE_UNION SGL;	/*0x18 */
+} MPI2_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST,
+	*PTR_MPI2_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST,
+	Mpi2ToolboxDiagDataUploadRequest_t,
+	*pMpi2ToolboxDiagDataUploadRequest_t;
+
+/*use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
+
+typedef struct _MPI2_DIAG_DATA_UPLOAD_HEADER {
+	U32 DiagDataLength;	/*00h */
+	U8 FormatCode;		/*04h */
+	U8 Reserved1;		/*05h */
+	U16 Reserved2;		/*06h */
+} MPI2_DIAG_DATA_UPLOAD_HEADER, *PTR_MPI2_DIAG_DATA_UPLOAD_HEADER,
+	Mpi2DiagDataUploadHeader_t, *pMpi2DiagDataUploadHeader_t;
+
+/****************************************************************************
+* Toolbox ISTWI Read Write Tool
+****************************************************************************/
+
+/*Toolbox ISTWI Read Write Tool request message */
+typedef struct _MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U32 Reserved5;		/*0x0C */
+	U32 Reserved6;		/*0x10 */
+	U8 DevIndex;		/*0x14 */
+	U8 Action;		/*0x15 */
+	U8 SGLFlags;		/*0x16 */
+	U8 Flags;		/*0x17 */
+	U16 TxDataLength;	/*0x18 */
+	U16 RxDataLength;	/*0x1A */
+	U32 Reserved8;		/*0x1C */
+	U32 Reserved9;		/*0x20 */
+	U32 Reserved10;		/*0x24 */
+	U32 Reserved11;		/*0x28 */
+	U32 Reserved12;		/*0x2C */
+	MPI2_SGE_SIMPLE_UNION SGL;	/*0x30 */
+} MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST,
+	*PTR_MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST,
+	Mpi2ToolboxIstwiReadWriteRequest_t,
+	*pMpi2ToolboxIstwiReadWriteRequest_t;
+
+/*values for the Action field */
+#define MPI2_TOOL_ISTWI_ACTION_READ_DATA            (0x01)
+#define MPI2_TOOL_ISTWI_ACTION_WRITE_DATA           (0x02)
+#define MPI2_TOOL_ISTWI_ACTION_SEQUENCE             (0x03)
+#define MPI2_TOOL_ISTWI_ACTION_RESERVE_BUS          (0x10)
+#define MPI2_TOOL_ISTWI_ACTION_RELEASE_BUS          (0x11)
+#define MPI2_TOOL_ISTWI_ACTION_RESET                (0x12)
+
+/*use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
+
+/*values for the Flags field */
+#define MPI2_TOOL_ISTWI_FLAG_AUTO_RESERVE_RELEASE   (0x80)
+#define MPI2_TOOL_ISTWI_FLAG_PAGE_ADDR_MASK         (0x07)
+
+/*Toolbox ISTWI Read Write Tool reply message */
+typedef struct _MPI2_TOOLBOX_ISTWI_REPLY {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U16 Reserved5;		/*0x0C */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+	U8 DevIndex;		/*0x14 */
+	U8 Action;		/*0x15 */
+	U8 IstwiStatus;		/*0x16 */
+	U8 Reserved6;		/*0x17 */
+	U16 TxDataCount;	/*0x18 */
+	U16 RxDataCount;	/*0x1A */
+} MPI2_TOOLBOX_ISTWI_REPLY, *PTR_MPI2_TOOLBOX_ISTWI_REPLY,
+	Mpi2ToolboxIstwiReply_t, *pMpi2ToolboxIstwiReply_t;
+
+/****************************************************************************
+* Toolbox Beacon Tool request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_BEACON_REQUEST {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U8 Reserved5;		/*0x0C */
+	U8 PhysicalPort;	/*0x0D */
+	U8 Reserved6;		/*0x0E */
+	U8 Flags;		/*0x0F */
+} MPI2_TOOLBOX_BEACON_REQUEST, *PTR_MPI2_TOOLBOX_BEACON_REQUEST,
+	Mpi2ToolboxBeaconRequest_t, *pMpi2ToolboxBeaconRequest_t;
+
+/*values for the Flags field */
+#define MPI2_TOOLBOX_FLAGS_BEACONMODE_OFF       (0x00)
+#define MPI2_TOOLBOX_FLAGS_BEACONMODE_ON        (0x01)
+
+/****************************************************************************
+* Toolbox Diagnostic CLI Tool
+****************************************************************************/
+
+#define MPI2_TOOLBOX_DIAG_CLI_CMD_LENGTH    (0x5C)
+
+/*MPI v2.0 Toolbox Diagnostic CLI Tool request message */
+typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U8 SGLFlags;		/*0x0C */
+	U8 Reserved5;		/*0x0D */
+	U16 Reserved6;		/*0x0E */
+	U32 DataLength;		/*0x10 */
+	U8 DiagnosticCliCommand[MPI2_TOOLBOX_DIAG_CLI_CMD_LENGTH];/*0x14 */
+	MPI2_SGE_SIMPLE_UNION SGL;	/*0x70 */
+} MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+	*PTR_MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+	Mpi2ToolboxDiagnosticCliRequest_t,
+	*pMpi2ToolboxDiagnosticCliRequest_t;
+
+/*use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
+
+/*MPI v2.5 Toolbox Diagnostic CLI Tool request message */
+typedef struct _MPI25_TOOLBOX_DIAGNOSTIC_CLI_REQUEST {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U32 Reserved5;		/*0x0C */
+	U32 DataLength;		/*0x10 */
+	U8 DiagnosticCliCommand[MPI2_TOOLBOX_DIAG_CLI_CMD_LENGTH];/*0x14 */
+	MPI25_SGE_IO_UNION SGL;	/*0x70 */
+} MPI25_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+	*PTR_MPI25_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+	Mpi25ToolboxDiagnosticCliRequest_t,
+	*pMpi25ToolboxDiagnosticCliRequest_t;
+
+/*Toolbox Diagnostic CLI Tool reply message */
+typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REPLY {
+	U8 Tool;		/*0x00 */
+	U8 Reserved1;		/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U16 Reserved5;		/*0x0C */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+	U32 ReturnedDataLength;	/*0x14 */
+} MPI2_TOOLBOX_DIAGNOSTIC_CLI_REPLY,
+	*PTR_MPI2_TOOLBOX_DIAG_CLI_REPLY,
+	Mpi2ToolboxDiagnosticCliReply_t,
+	*pMpi2ToolboxDiagnosticCliReply_t;
+
+/*****************************************************************************
+*
+*      Diagnostic Buffer Messages
+*
+*****************************************************************************/
+
+/****************************************************************************
+* Diagnostic Buffer Post request
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_BUFFER_POST_REQUEST {
+	U8 ExtendedType;	/*0x00 */
+	U8 BufferType;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U64 BufferAddress;	/*0x0C */
+	U32 BufferLength;	/*0x14 */
+	U32 Reserved5;		/*0x18 */
+	U32 Reserved6;		/*0x1C */
+	U32 Flags;		/*0x20 */
+	U32 ProductSpecific[23];	/*0x24 */
+} MPI2_DIAG_BUFFER_POST_REQUEST, *PTR_MPI2_DIAG_BUFFER_POST_REQUEST,
+	Mpi2DiagBufferPostRequest_t, *pMpi2DiagBufferPostRequest_t;
+
+/*values for the ExtendedType field */
+#define MPI2_DIAG_EXTENDED_TYPE_UTILIZATION         (0x02)
+
+/*values for the BufferType field */
+#define MPI2_DIAG_BUF_TYPE_TRACE                    (0x00)
+#define MPI2_DIAG_BUF_TYPE_SNAPSHOT                 (0x01)
+#define MPI2_DIAG_BUF_TYPE_EXTENDED                 (0x02)
+/*count of the number of buffer types */
+#define MPI2_DIAG_BUF_TYPE_COUNT                    (0x03)
+
+/*values for the Flags field */
+#define MPI2_DIAG_BUF_FLAG_RELEASE_ON_FULL          (0x00000002)
+#define MPI2_DIAG_BUF_FLAG_IMMEDIATE_RELEASE        (0x00000001)
+
+/****************************************************************************
+* Diagnostic Buffer Post reply
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_BUFFER_POST_REPLY {
+	U8 ExtendedType;	/*0x00 */
+	U8 BufferType;		/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U16 Reserved5;		/*0x0C */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+	U32 TransferLength;	/*0x14 */
+} MPI2_DIAG_BUFFER_POST_REPLY, *PTR_MPI2_DIAG_BUFFER_POST_REPLY,
+	Mpi2DiagBufferPostReply_t, *pMpi2DiagBufferPostReply_t;
+
+/****************************************************************************
+* Diagnostic Release request
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_RELEASE_REQUEST {
+	U8 Reserved1;		/*0x00 */
+	U8 BufferType;		/*0x01 */
+	U8 ChainOffset;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+} MPI2_DIAG_RELEASE_REQUEST, *PTR_MPI2_DIAG_RELEASE_REQUEST,
+	Mpi2DiagReleaseRequest_t, *pMpi2DiagReleaseRequest_t;
+
+/****************************************************************************
+* Diagnostic Buffer Post reply
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_RELEASE_REPLY {
+	U8 Reserved1;		/*0x00 */
+	U8 BufferType;		/*0x01 */
+	U8 MsgLength;		/*0x02 */
+	U8 Function;		/*0x03 */
+	U16 Reserved2;		/*0x04 */
+	U8 Reserved3;		/*0x06 */
+	U8 MsgFlags;		/*0x07 */
+	U8 VP_ID;		/*0x08 */
+	U8 VF_ID;		/*0x09 */
+	U16 Reserved4;		/*0x0A */
+	U16 Reserved5;		/*0x0C */
+	U16 IOCStatus;		/*0x0E */
+	U32 IOCLogInfo;		/*0x10 */
+} MPI2_DIAG_RELEASE_REPLY, *PTR_MPI2_DIAG_RELEASE_REPLY,
+	Mpi2DiagReleaseReply_t, *pMpi2DiagReleaseReply_t;
+
+#endif
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_type.h b/drivers/scsi/mpt3sas/mpi/mpi2_type.h
new file mode 100644
index 0000000..516f959
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_type.h
@@ -0,0 +1,56 @@
+/*
+ *  Copyright (c) 2000-2007 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_type.h
+ *          Title:  MPI basic type definitions
+ *  Creation Date:  August 16, 2006
+ *
+ *    mpi2_type.h Version:  02.00.00
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_TYPE_H
+#define MPI2_TYPE_H
+
+/*******************************************************************************
+ * Define * if it hasn't already been defined. By default
+ * * is defined to be a near pointer. MPI2_POINTER can be defined as
+ * a far pointer by defining * as "far *" before this header file is
+ * included.
+ */
+
+/* the basic types may have already been included by mpi_type.h */
+#ifndef MPI_TYPE_H
+/*****************************************************************************
+*
+*               Basic Types
+*
+*****************************************************************************/
+
+typedef u8 U8;
+typedef __le16 U16;
+typedef __le32 U32;
+typedef __le64 U64 __attribute__ ((aligned(4)));
+
+/*****************************************************************************
+*
+*               Pointer Types
+*
+*****************************************************************************/
+
+typedef U8 *PU8;
+typedef U16 *PU16;
+typedef U32 *PU32;
+typedef U64 *PU64;
+
+#endif
+
+#endif
