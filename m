From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 04/10] mpt2sas: Revision P MPI Header Update
Date: Tue, 4 Jan 2011 11:35:41 +0530
Message-ID: <20110104060530.GE5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37336 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886Ab1ADGue (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 01:50:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Revision P MPI Header Update:
a) Added enable/disable SATA NCQ operations to SAS IO Unit Control
Request.
b) Modified Host Based Discovery Action Request message format.
c) Removed Device Path bit from IO Unit Page 1 Flags field.
d) Added description of ChainOffset field for Diagnostic Data Upload
Tool.Chaining is not allowed.

Removed mpi2_history.txt file

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
index 8be75e6..a3e6038 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                  scatter/gather formats.
  *  Creation Date:  June 21, 2006
  *
- *  mpi2.h Version:  02.00.16
+ *  mpi2.h Version:  02.00.17
  *
  *  Version History
  *  ---------------
@@ -63,6 +63,7 @@
  *                      function codes, 0xF0 to 0xFF.
  *  05-12-10  02.00.16  Bumped MPI2_HEADER_VERSION_UNIT.
  *                      Added alternative defines for the SGE Direction bit.
+ *  08-11-10  02.00.17  Bumped MPI2_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
  */
 
@@ -88,7 +89,7 @@
 #define MPI2_VERSION_02_00                  (0x0200)
 
 /* versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x10)
+#define MPI2_HEADER_VERSION_UNIT            (0x11)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
index d76a658..f5b9c76 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Configuration messages and pages
  *  Creation Date:  November 10, 2006
  *
- *    mpi2_cnfg.h Version:  02.00.15
+ *    mpi2_cnfg.h Version:  02.00.16
  *
  *  Version History
  *  ---------------
@@ -125,6 +125,8 @@
  *                      define.
  *                      Added MPI2_PHYSDISK0_INCOMPATIBLE_MEDIA_TYPE define.
  *                      Added MPI2_SAS_NEG_LINK_RATE_UNSUPPORTED_PHY define.
+ *  08-11-10  02.00.16  Removed IO Unit Page 1 device path (multi-pathing)
+ *                      defines.
  *  --------------------------------------------------------------------------
  */
 
@@ -745,8 +747,6 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1
 #define MPI2_IOUNITPAGE1_DISABLE_IR                     (0x00000040)
 #define MPI2_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING (0x00000020)
 #define MPI2_IOUNITPAGE1_IR_USE_STATIC_VOLUME_ID        (0x00000004)
-#define MPI2_IOUNITPAGE1_MULTI_PATHING                  (0x00000002)
-#define MPI2_IOUNITPAGE1_SINGLE_PATHING                 (0x00000000)
 
 
 /* IO Unit Page 3 */
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
deleted file mode 100644
index b1e88f2..0000000
--- a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
+++ /dev/null
@@ -1,384 +0,0 @@
- ==============================
- Fusion-MPT MPI 2.0 Header File Change History
- ==============================
-
- Copyright (c) 2000-2010 LSI Corporation.
-
- ---------------------------------------
- Header Set Release Version:    02.00.14
- Header Set Release Date:       10-28-09
- ---------------------------------------
-
- Filename               Current version     Prior version
- ----------             ---------------     -------------
- mpi2.h                 02.00.14            02.00.13
- mpi2_cnfg.h            02.00.13            02.00.12
- mpi2_init.h            02.00.08            02.00.07
- mpi2_ioc.h             02.00.13            02.00.12
- mpi2_raid.h            02.00.04            02.00.04
- mpi2_sas.h             02.00.03            02.00.02
- mpi2_targ.h            02.00.03            02.00.03
- mpi2_tool.h            02.00.04            02.00.04
- mpi2_type.h            02.00.00            02.00.00
- mpi2_ra.h              02.00.00            02.00.00
- mpi2_hbd.h             02.00.00
- mpi2_history.txt       02.00.14            02.00.13
-
-
- *  Date      Version   Description
- *  --------  --------  ------------------------------------------------------
-
-mpi2.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  06-04-07  02.00.01  Bumped MPI2_HEADER_VERSION_UNIT.
- *  06-26-07  02.00.02  Bumped MPI2_HEADER_VERSION_UNIT.
- *  08-31-07  02.00.03  Bumped MPI2_HEADER_VERSION_UNIT.
- *                      Moved ReplyPostHostIndex register to offset 0x6C of the
- *                      MPI2_SYSTEM_INTERFACE_REGS and modified the define for
- *                      MPI2_REPLY_POST_HOST_INDEX_OFFSET.
- *                      Added union of request descriptors.
- *                      Added union of reply descriptors.
- *  10-31-07  02.00.04  Bumped MPI2_HEADER_VERSION_UNIT.
- *                      Added define for MPI2_VERSION_02_00.
- *                      Fixed the size of the FunctionDependent5 field in the
- *                      MPI2_DEFAULT_REPLY structure.
- *  12-18-07  02.00.05  Bumped MPI2_HEADER_VERSION_UNIT.
- *                      Removed the MPI-defined Fault Codes and extended the
- *                      product specific codes up to 0xEFFF.
- *                      Added a sixth key value for the WriteSequence register
- *                      and changed the flush value to 0x0.
- *                      Added message function codes for Diagnostic Buffer Post
- *                      and Diagnsotic Release.
- *                      New IOCStatus define: MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED
- *                      Moved MPI2_VERSION_UNION from mpi2_ioc.h.
- *  02-29-08  02.00.06  Bumped MPI2_HEADER_VERSION_UNIT.
- *  03-03-08  02.00.07  Bumped MPI2_HEADER_VERSION_UNIT.
- *  05-21-08  02.00.08  Bumped MPI2_HEADER_VERSION_UNIT.
- *                      Added #defines for marking a reply descriptor as unused.
- *  06-27-08  02.00.09  Bumped MPI2_HEADER_VERSION_UNIT.
- *  10-02-08  02.00.10  Bumped MPI2_HEADER_VERSION_UNIT.
- *                      Moved LUN field defines from mpi2_init.h.
- *  01-19-09  02.00.11  Bumped MPI2_HEADER_VERSION_UNIT.
- *  05-06-09  02.00.12  Bumped MPI2_HEADER_VERSION_UNIT.
- *                      In all request and reply descriptors, replaced VF_ID
- *                      field with MSIxIndex field.
- *                      Removed DevHandle field from
- *                      MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR and made those
- *                      bytes reserved.
- *                      Added RAID Accelerator functionality.
- *  07-30-09  02.00.13  Bumped MPI2_HEADER_VERSION_UNIT.
- *  10-28-09  02.00.14  Bumped MPI2_HEADER_VERSION_UNIT.
- *                      Added MSI-x index mask and shift for Reply Post Host
- *                      Index register.
- *                      Added function code for Host Based Discovery Action.
- *  --------------------------------------------------------------------------
-
-mpi2_cnfg.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  06-04-07  02.00.01  Added defines for SAS IO Unit Page 2 PhyFlags.
- *                      Added Manufacturing Page 11.
- *                      Added MPI2_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE
- *                      define.
- *  06-26-07  02.00.02  Adding generic structure for product-specific
- *                      Manufacturing pages: MPI2_CONFIG_PAGE_MANUFACTURING_PS.
- *                      Rework of BIOS Page 2 configuration page.
- *                      Fixed MPI2_BIOSPAGE2_BOOT_DEVICE to be a union of the
- *                      forms.
- *                      Added configuration pages IOC Page 8 and Driver
- *                      Persistent Mapping Page 0.
- *  08-31-07  02.00.03  Modified configuration pages dealing with Integrated
- *                      RAID (Manufacturing Page 4, RAID Volume Pages 0 and 1,
- *                      RAID Physical Disk Pages 0 and 1, RAID Configuration
- *                      Page 0).
- *                      Added new value for AccessStatus field of SAS Device
- *                      Page 0 (_SATA_NEEDS_INITIALIZATION).
- *  10-31-07  02.00.04  Added missing SEPDevHandle field to
- *                      MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
- *  12-18-07  02.00.05  Modified IO Unit Page 0 to use 32-bit version fields for
- *                      NVDATA.
- *                      Modified IOC Page 7 to use masks and added field for
- *                      SASBroadcastPrimitiveMasks.
- *                      Added MPI2_CONFIG_PAGE_BIOS_4.
- *                      Added MPI2_CONFIG_PAGE_LOG_0.
- *  02-29-08  02.00.06  Modified various names to make them 32-character unique.
- *                      Added SAS Device IDs.
- *                      Updated Integrated RAID configuration pages including
- *                      Manufacturing Page 4, IOC Page 6, and RAID Configuration
- *                      Page 0.
- *  05-21-08  02.00.07  Added define MPI2_MANPAGE4_MIX_SSD_SAS_SATA.
- *                      Added define MPI2_MANPAGE4_PHYSDISK_128MB_COERCION.
- *                      Fixed define MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING.
- *                      Added missing MaxNumRoutedSasAddresses field to
- *                      MPI2_CONFIG_PAGE_EXPANDER_0.
- *                      Added SAS Port Page 0.
- *                      Modified structure layout for
- *                      MPI2_CONFIG_PAGE_DRIVER_MAPPING_0.
- *  06-27-08  02.00.08  Changed MPI2_CONFIG_PAGE_RD_PDISK_1 to use
- *                      MPI2_RAID_PHYS_DISK1_PATH_MAX to size the array.
- *  10-02-08  02.00.09  Changed MPI2_RAID_PGAD_CONFIGNUM_MASK from 0x0000FFFF
- *                      to 0x000000FF.
- *                      Added two new values for the Physical Disk Coercion Size
- *                      bits in the Flags field of Manufacturing Page 4.
- *                      Added product-specific Manufacturing pages 16 to 31.
- *                      Modified Flags bits for controlling write cache on SATA
- *                      drives in IO Unit Page 1.
- *                      Added new bit to AdditionalControlFlags of SAS IO Unit
- *                      Page 1 to control Invalid Topology Correction.
- *                      Added SupportedPhysDisks field to RAID Volume Page 1 and
- *                      added related defines.
- *                      Added additional defines for RAID Volume Page 0
- *                      VolumeStatusFlags field.
- *                      Modified meaning of RAID Volume Page 0 VolumeSettings
- *                      define for auto-configure of hot-swap drives.
- *                      Added PhysDiskAttributes field (and related defines) to
- *                      RAID Physical Disk Page 0.
- *                      Added MPI2_SAS_PHYINFO_PHY_VACANT define.
- *                      Added three new DiscoveryStatus bits for SAS IO Unit
- *                      Page 0 and SAS Expander Page 0.
- *                      Removed multiplexing information from SAS IO Unit pages.
- *                      Added BootDeviceWaitTime field to SAS IO Unit Page 4.
- *                      Removed Zone Address Resolved bit from PhyInfo and from
- *                      Expander Page 0 Flags field.
- *                      Added two new AccessStatus values to SAS Device Page 0
- *                      for indicating routing problems. Added 3 reserved words
- *                      to this page.
- *  01-19-09  02.00.10  Fixed defines for GPIOVal field of IO Unit Page 3.
- *                      Inserted missing reserved field into structure for IOC
- *                      Page 6.
- *                      Added more pending task bits to RAID Volume Page 0
- *                      VolumeStatusFlags defines.
- *                      Added MPI2_PHYSDISK0_STATUS_FLAG_NOT_CERTIFIED define.
- *                      Added a new DiscoveryStatus bit for SAS IO Unit Page 0
- *                      and SAS Expander Page 0 to flag a downstream initiator
- *                      when in simplified routing mode.
- *                      Removed SATA Init Failure defines for DiscoveryStatus
- *                      fields of SAS IO Unit Page 0 and SAS Expander Page 0.
- *                      Added MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED define.
- *                      Added PortGroups, DmaGroup, and ControlGroup fields to
- *                      SAS Device Page 0.
- *  05-06-09  02.00.11  Added structures and defines for IO Unit Page 5 and IO
- *                      Unit Page 6.
- *                      Added expander reduced functionality data to SAS
- *                      Expander Page 0.
- *                      Added SAS PHY Page 2 and SAS PHY Page 3.
- *  07-30-09  02.00.12  Added IO Unit Page 7.
- *                      Added new device ids.
- *                      Added SAS IO Unit Page 5.
- *                      Added partial and slumber power management capable flags
- *                      to SAS Device Page 0 Flags field.
- *                      Added PhyInfo defines for power condition.
- *                      Added Ethernet configuration pages.
- *  10-28-09  02.00.13  Added MPI2_IOUNITPAGE1_ENABLE_HOST_BASED_DISCOVERY.
- *                      Added SAS PHY Page 4 structure and defines.
- *  --------------------------------------------------------------------------
-
-mpi2_init.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  10-31-07  02.00.01  Fixed name for pMpi2SCSITaskManagementRequest_t.
- *  12-18-07  02.00.02  Modified Task Management Target Reset Method defines.
- *  02-29-08  02.00.03  Added Query Task Set and Query Unit Attention.
- *  03-03-08  02.00.04  Fixed name of struct _MPI2_SCSI_TASK_MANAGE_REPLY.
- *  05-21-08  02.00.05  Fixed typo in name of Mpi2SepRequest_t.
- *  10-02-08  02.00.06  Removed Untagged and No Disconnect values from SCSI IO
- *                      Control field Task Attribute flags.
- *                      Moved LUN field defines to mpi2.h becasue they are
- *                      common to many structures.
- *  05-06-09  02.00.07  Changed task management type of Query Unit Attention to
- *                      Query Asynchronous Event.
- *                      Defined two new bits in the SlotStatus field of the SCSI
- *                      Enclosure Processor Request and Reply.
- *  10-28-09  02.00.08  Added defines for decoding the ResponseInfo bytes for
- *                      both SCSI IO Error Reply and SCSI Task Management Reply.
- *                      Added ResponseInfo field to MPI2_SCSI_TASK_MANAGE_REPLY.
- *                      Added MPI2_SCSITASKMGMT_RSP_TM_OVERLAPPED_TAG define.
- *  --------------------------------------------------------------------------
-
-mpi2_ioc.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  06-04-07  02.00.01  In IOCFacts Reply structure, renamed MaxDevices to
- *                      MaxTargets.
- *                      Added TotalImageSize field to FWDownload Request.
- *                      Added reserved words to FWUpload Request.
- *  06-26-07  02.00.02  Added IR Configuration Change List Event.
- *  08-31-07  02.00.03  Removed SystemReplyQueueDepth field from the IOCInit
- *                      request and replaced it with
- *                      ReplyDescriptorPostQueueDepth and ReplyFreeQueueDepth.
- *                      Replaced the MinReplyQueueDepth field of the IOCFacts
- *                      reply with MaxReplyDescriptorPostQueueDepth.
- *                      Added MPI2_RDPQ_DEPTH_MIN define to specify the minimum
- *                      depth for the Reply Descriptor Post Queue.
- *                      Added SASAddress field to Initiator Device Table
- *                      Overflow Event data.
- *  10-31-07  02.00.04  Added ReasonCode MPI2_EVENT_SAS_INIT_RC_NOT_RESPONDING
- *                      for SAS Initiator Device Status Change Event data.
- *                      Modified Reason Code defines for SAS Topology Change
- *                      List Event data, including adding a bit for PHY Vacant
- *                      status, and adding a mask for the Reason Code.
- *                      Added define for
- *                      MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING.
- *                      Added define for MPI2_EXT_IMAGE_TYPE_MEGARAID.
- *  12-18-07  02.00.05  Added Boot Status defines for the IOCExceptions field of
- *                      the IOCFacts Reply.
- *                      Removed MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER define.
- *                      Moved MPI2_VERSION_UNION to mpi2.h.
- *                      Changed MPI2_EVENT_NOTIFICATION_REQUEST to use masks
- *                      instead of enables, and added SASBroadcastPrimitiveMasks
- *                      field.
- *                      Added Log Entry Added Event and related structure.
- *  02-29-08  02.00.06  Added define MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID.
- *                      Removed define MPI2_IOCFACTS_PROTOCOL_SMP_TARGET.
- *                      Added MaxVolumes and MaxPersistentEntries fields to
- *                      IOCFacts reply.
- *                      Added ProtocalFlags and IOCCapabilities fields to
- *                      MPI2_FW_IMAGE_HEADER.
- *                      Removed MPI2_PORTENABLE_FLAGS_ENABLE_SINGLE_PORT.
- *  03-03-08  02.00.07  Fixed MPI2_FW_IMAGE_HEADER by changing Reserved26 to
- *                      a U16 (from a U32).
- *                      Removed extra 's' from EventMasks name.
- *  06-27-08  02.00.08  Fixed an offset in a comment.
- *  10-02-08  02.00.09  Removed SystemReplyFrameSize from MPI2_IOC_INIT_REQUEST.
- *                      Removed CurReplyFrameSize from MPI2_IOC_FACTS_REPLY and
- *                      renamed MinReplyFrameSize to ReplyFrameSize.
- *                      Added MPI2_IOCFACTS_EXCEPT_IR_FOREIGN_CONFIG_MAX.
- *                      Added two new RAIDOperation values for Integrated RAID
- *                      Operations Status Event data.
- *                      Added four new IR Configuration Change List Event data
- *                      ReasonCode values.
- *                      Added two new ReasonCode defines for SAS Device Status
- *                      Change Event data.
- *                      Added three new DiscoveryStatus bits for the SAS
- *                      Discovery event data.
- *                      Added Multiplexing Status Change bit to the PhyStatus
- *                      field of the SAS Topology Change List event data.
- *                      Removed define for MPI2_INIT_IMAGE_BOOTFLAGS_XMEMCOPY.
- *                      BootFlags are now product-specific.
- *                      Added defines for the indivdual signature bytes
- *                      for MPI2_INIT_IMAGE_FOOTER.
- *  01-19-09  02.00.10  Added MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY define.
- *                      Added MPI2_EVENT_SAS_DISC_DS_DOWNSTREAM_INITIATOR
- *                      define.
- *                      Added MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE
- *                      define.
- *                      Removed MPI2_EVENT_SAS_DISC_DS_SATA_INIT_FAILURE define.
- *  05-06-09  02.00.11  Added MPI2_IOCFACTS_CAPABILITY_RAID_ACCELERATOR define.
- *                      Added MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX define.
- *                      Added two new reason codes for SAS Device Status Change
- *                      Event.
- *                      Added new event: SAS PHY Counter.
- *  07-30-09  02.00.12  Added GPIO Interrupt event define and structure.
- *                      Added MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER define.
- *                      Added new product id family for 2208.
- *  10-28-09  02.00.13  Added HostMSIxVectors field to MPI2_IOC_INIT_REQUEST.
- *                      Added MaxMSIxVectors field to MPI2_IOC_FACTS_REPLY.
- *                      Added MinDevHandle field to MPI2_IOC_FACTS_REPLY.
- *                      Added MPI2_IOCFACTS_CAPABILITY_HOST_BASED_DISCOVERY.
- *                      Added MPI2_EVENT_HOST_BASED_DISCOVERY_PHY define.
- *                      Added MPI2_EVENT_SAS_TOPO_ES_NO_EXPANDER define.
- *                      Added Host Based Discovery Phy Event data.
- *                      Added defines for ProductID Product field
- *                      (MPI2_FW_HEADER_PID_).
- *                      Modified values for SAS ProductID Family
- *                      (MPI2_FW_HEADER_PID_FAMILY_).
- *  --------------------------------------------------------------------------
-
-mpi2_raid.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  08-31-07  02.00.01  Modifications to RAID Action request and reply,
- *                      including the Actions and ActionData.
- *  02-29-08  02.00.02  Added MPI2_RAID_ACTION_ADATA_DISABL_FULL_REBUILD.
- *  05-21-08  02.00.03  Added MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS so that
- *                      the PhysDisk array in MPI2_RAID_VOLUME_CREATION_STRUCT
- *                      can be sized by the build environment.
- *  07-30-09  02.00.04  Added proper define for the Use Default Settings bit of
- *                      VolumeCreationFlags and marked the old one as obsolete.
- *  05-12-10  02.00.05  Added MPI2_RAID_VOL_FLAGS_OP_MDC define.
- *  --------------------------------------------------------------------------
-
-mpi2_sas.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  06-26-07  02.00.01  Added Clear All Persistent Operation to SAS IO Unit
- *                      Control Request.
- *  10-02-08  02.00.02  Added Set IOC Parameter Operation to SAS IO Unit Control
- *                      Request.
- *  10-28-09  02.00.03  Changed the type of SGL in MPI2_SATA_PASSTHROUGH_REQUEST
- *                      to MPI2_SGE_IO_UNION since it supports chained SGLs.
- *  05-12-10  02.00.04  Modified some comments.
- *  --------------------------------------------------------------------------
-
-mpi2_targ.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  08-31-07  02.00.01  Added Command Buffer Data Location Address Space bits to
- *                      BufferPostFlags field of CommandBufferPostBase Request.
- *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
- *  10-02-08  02.00.03  Removed NextCmdBufferOffset from
- *                      MPI2_TARGET_CMD_BUF_POST_BASE_REQUEST.
- *                      Target Status Send Request only takes a single SGE for
- *                      response data.
- *  --------------------------------------------------------------------------
-
-mpi2_tool.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  12-18-07  02.00.01  Added Diagnostic Buffer Post and Diagnostic Release
- *                      structures and defines.
- *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
- *  05-06-09  02.00.03  Added ISTWI Read Write Tool and Diagnostic CLI Tool.
- *  07-30-09  02.00.04  Added ExtendedType field to DiagnosticBufferPost request
- *                      and reply messages.
- *                      Added MPI2_DIAG_BUF_TYPE_EXTENDED.
- *                      Incremented MPI2_DIAG_BUF_TYPE_COUNT.
- *  05-12-10  02.00.05  Added Diagnostic Data Upload tool.
- *  --------------------------------------------------------------------------
-
-mpi2_type.h
- *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
- *  --------------------------------------------------------------------------
-
-mpi2_ra.h
- *  05-06-09  02.00.00  Initial version.
- *  --------------------------------------------------------------------------
-
-mpi2_hbd.h
- *  10-28-09  02.00.00  Initial version.
- *  --------------------------------------------------------------------------
-
-
-mpi2_history.txt         Parts list history
-
-Filename     02.00.14  02.00.13  02.00.12
-----------   --------  --------  --------
-mpi2.h       02.00.14  02.00.13  02.00.12
-mpi2_cnfg.h  02.00.13  02.00.12  02.00.11
-mpi2_init.h  02.00.08  02.00.07  02.00.07
-mpi2_ioc.h   02.00.13  02.00.12  02.00.11
-mpi2_raid.h  02.00.04  02.00.04  02.00.03
-mpi2_sas.h   02.00.03  02.00.02  02.00.02
-mpi2_targ.h  02.00.03  02.00.03  02.00.03
-mpi2_tool.h  02.00.04  02.00.04  02.00.03
-mpi2_type.h  02.00.00  02.00.00  02.00.00
-mpi2_ra.h    02.00.00  02.00.00  02.00.00
-mpi2_hbd.h   02.00.00
-
-Filename     02.00.11  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06
-----------   --------  --------  --------  --------  --------  --------
-mpi2.h       02.00.11  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06
-mpi2_cnfg.h  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06  02.00.06
-mpi2_init.h  02.00.06  02.00.06  02.00.05  02.00.05  02.00.04  02.00.03
-mpi2_ioc.h   02.00.10  02.00.09  02.00.08  02.00.07  02.00.07  02.00.06
-mpi2_raid.h  02.00.03  02.00.03  02.00.03  02.00.03  02.00.02  02.00.02
-mpi2_sas.h   02.00.02  02.00.02  02.00.01  02.00.01  02.00.01  02.00.01
-mpi2_targ.h  02.00.03  02.00.03  02.00.02  02.00.02  02.00.02  02.00.02
-mpi2_tool.h  02.00.02  02.00.02  02.00.02  02.00.02  02.00.02  02.00.02
-mpi2_type.h  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
-
-Filename     02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
-----------   --------  --------  --------  --------  --------  --------
-mpi2.h       02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
-mpi2_cnfg.h  02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
-mpi2_init.h  02.00.02  02.00.01  02.00.00  02.00.00  02.00.00  02.00.00
-mpi2_ioc.h   02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
-mpi2_raid.h  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00  02.00.00
-mpi2_sas.h   02.00.01  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00
-mpi2_targ.h  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00  02.00.00
-mpi2_tool.h  02.00.01  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
-mpi2_type.h  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
-
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_sas.h b/drivers/scsi/mpt2sas/mpi/mpi2_sas.h
index 608f6d6..fdffde1 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_sas.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_sas.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Serial Attached SCSI structures and definitions
  *  Creation Date:  February 9, 2007
  *
- *  mpi2_sas.h Version:  02.00.04
+ *  mpi2_sas.h Version:  02.00.05
  *
  *  Version History
  *  ---------------
@@ -21,6 +21,7 @@
  *  10-28-09  02.00.03  Changed the type of SGL in MPI2_SATA_PASSTHROUGH_REQUEST
  *                      to MPI2_SGE_IO_UNION since it supports chained SGLs.
  *  05-12-10  02.00.04  Modified some comments.
+ *  08-11-10  02.00.05  Added NCQ operations to SAS IO Unit Control.
  *  --------------------------------------------------------------------------
  */
 
@@ -163,7 +164,7 @@ typedef struct _MPI2_SATA_PASSTHROUGH_REQUEST
     U32                     Reserved4;          /* 0x14 */
     U32                     DataLength;         /* 0x18 */
     U8                      CommandFIS[20];     /* 0x1C */
-    MPI2_SGE_IO_UNION       SGL;                /* 0x20 */
+    MPI2_SGE_IO_UNION       SGL;                /* 0x30 */
 } MPI2_SATA_PASSTHROUGH_REQUEST, MPI2_POINTER PTR_MPI2_SATA_PASSTHROUGH_REQUEST,
   Mpi2SataPassthroughRequest_t, MPI2_POINTER pMpi2SataPassthroughRequest_t;
 
@@ -246,6 +247,8 @@ typedef struct _MPI2_SAS_IOUNIT_CONTROL_REQUEST
 #define MPI2_SAS_OP_REMOVE_DEVICE               (0x0D)
 #define MPI2_SAS_OP_LOOKUP_MAPPING              (0x0E)
 #define MPI2_SAS_OP_SET_IOC_PARAMETER           (0x0F)
+#define MPI2_SAS_OP_DEV_ENABLE_NCQ              (0x14)
+#define MPI2_SAS_OP_DEV_DISABLE_NCQ             (0x15)
 #define MPI2_SAS_OP_PRODUCT_SPECIFIC_MIN        (0x80)
 
 /* values for the PrimFlags field */
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
index 5c6e3a6..2a4bced 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
@@ -6,7 +6,7 @@
  *          Title:  MPI diagnostic tool structures and definitions
  *  Creation Date:  March 26, 2007
  *
- *    mpi2_tool.h Version:  02.00.05
+ *    mpi2_tool.h Version:  02.00.06
  *
  *  Version History
  *  ---------------
@@ -23,6 +23,8 @@
  *                      Added MPI2_DIAG_BUF_TYPE_EXTENDED.
  *                      Incremented MPI2_DIAG_BUF_TYPE_COUNT.
  *  05-12-10  02.00.05  Added Diagnostic Data Upload tool.
+ *  08-11-10  02.00.06  Added defines that were missing for Diagnostic Buffer
+ *                      Post Request.
  *  --------------------------------------------------------------------------
  */
 
@@ -354,6 +356,10 @@ typedef struct _MPI2_DIAG_BUFFER_POST_REQUEST
 /* count of the number of buffer types */
 #define MPI2_DIAG_BUF_TYPE_COUNT                    (0x03)
 
+/* values for the Flags field */
+#define MPI2_DIAG_BUF_FLAG_RELEASE_ON_FULL          (0x00000002)
+#define MPI2_DIAG_BUF_FLAG_IMMEDIATE_RELEASE        (0x00000001)
+
 
 /****************************************************************************
 *  Diagnostic Buffer Post reply
