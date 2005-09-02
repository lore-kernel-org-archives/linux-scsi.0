From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/4] fusion: update LSI headers
Date: Fri, 2 Sep 2005 10:07:50 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C03DF17A7@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4324 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751514AbVIBQIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2005 12:08:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Please apply

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

> 
> Index: scsi-misc-2.6/drivers/message/fusion/lsi/mpi_cnfg.h
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/lsi/mpi_cnfg.h	
> 2005-08-17 12:03:52.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/lsi/mpi_cnfg.h	
> 2005-08-17 12:04:01.000000000 +0200
> @@ -6,7 +6,7 @@
>   *          Title:  MPI Config message, structures, and Pages
>   *  Creation Date:  July 27, 2000
>   *
> - *    mpi_cnfg.h Version:  01.05.08
> + *    mpi_cnfg.h Version:  01.05.09
>   *
>   *  Version History
>   *  ---------------
> @@ -232,6 +232,23 @@
>   *                      New physical mapping mode in SAS IO 
> Unit Page 2.
>   *                      Added CONFIG_PAGE_SAS_ENCLOSURE_0.
>   *                      Added Slot and Enclosure fields to 
> SAS Device Page 0.
> + *  06-24-05  01.05.09  Added EEDP defines to IOC Page 1.
> + *                      Added more RAID type defines to IOC Page 2.
> + *                      Added Port Enable Delay settings to 
> BIOS Page 1.
> + *                      Added Bad Block Table Full define to 
> RAID Volume Page 0.
> + *                      Added Previous State defines to RAID 
> Physical Disk
> + *                      Page 0.
> + *                      Added Max Sata Targets define for 
> DiscoveryStatus field
> + *                      of SAS IO Unit Page 0.
> + *                      Added Device Self Test to Control 
> Flags of SAS IO Unit
> + *                      Page 1.
> + *                      Added Direct Attach Starting Slot 
> Number define for SAS
> + *                      IO Unit Page 2.
> + *                      Added new fields in SAS Device Page 
> 2 for enclosure
> + *                      mapping.
> + *                      Added OwnerDevHandle and Flags field 
> to SAS PHY Page 0.
> + *                      Added IOC GPIO Flags define to SAS 
> Enclosure Page 0.
> + *                      Fixed the value for 
> MPI_SAS_IOUNIT1_CONTROL_DEV_SATA_SUPPORT.
>   *  
> --------------------------------------------------------------
> ------------
>   */
>  
> @@ -477,6 +494,7 @@
>  #define MPI_MANUFACTPAGE_DEVICEID_FC929X            (0x0626)
>  #define MPI_MANUFACTPAGE_DEVICEID_FC939X            (0x0642)
>  #define MPI_MANUFACTPAGE_DEVICEID_FC949X            (0x0640)
> +#define MPI_MANUFACTPAGE_DEVICEID_FC949ES           (0x0646)
>  /* SCSI */
>  #define MPI_MANUFACTPAGE_DEVID_53C1030              (0x0030)
>  #define MPI_MANUFACTPAGE_DEVID_53C1030ZC            (0x0031)
> @@ -769,9 +787,13 @@
>  } CONFIG_PAGE_IOC_1, MPI_POINTER PTR_CONFIG_PAGE_IOC_1,
>    IOCPage1_t, MPI_POINTER pIOCPage1_t;
>  
> -#define MPI_IOCPAGE1_PAGEVERSION                        (0x02)
> +#define MPI_IOCPAGE1_PAGEVERSION                        (0x03)
>  
>  /* defines for the Flags field */
> +#define MPI_IOCPAGE1_EEDP_MODE_MASK                     (0x07000000)
> +#define MPI_IOCPAGE1_EEDP_MODE_OFF                      (0x00000000)
> +#define MPI_IOCPAGE1_EEDP_MODE_T10                      (0x01000000)
> +#define MPI_IOCPAGE1_EEDP_MODE_LSI_1                    (0x02000000)
>  #define MPI_IOCPAGE1_INITIATOR_CONTEXT_REPLY_DISABLE    (0x00000010)
>  #define MPI_IOCPAGE1_REPLY_COALESCING                   (0x00000001)
>  
> @@ -795,6 +817,11 @@
>  #define MPI_RAID_VOL_TYPE_IS                        (0x00)
>  #define MPI_RAID_VOL_TYPE_IME                       (0x01)
>  #define MPI_RAID_VOL_TYPE_IM                        (0x02)
> +#define MPI_RAID_VOL_TYPE_RAID_5                    (0x03)
> +#define MPI_RAID_VOL_TYPE_RAID_6                    (0x04)
> +#define MPI_RAID_VOL_TYPE_RAID_10                   (0x05)
> +#define MPI_RAID_VOL_TYPE_RAID_50                   (0x06)
> +#define MPI_RAID_VOL_TYPE_UNKNOWN                   (0xFF)
>  
>  /* IOC Page 2 Volume Flags values */
>  
> @@ -820,13 +847,17 @@
>  } CONFIG_PAGE_IOC_2, MPI_POINTER PTR_CONFIG_PAGE_IOC_2,
>    IOCPage2_t, MPI_POINTER pIOCPage2_t;
>  
> -#define MPI_IOCPAGE2_PAGEVERSION                        (0x02)
> +#define MPI_IOCPAGE2_PAGEVERSION                        (0x03)
>  
>  /* IOC Page 2 Capabilities flags */
>  
>  #define MPI_IOCPAGE2_CAP_FLAGS_IS_SUPPORT               (0x00000001)
>  #define MPI_IOCPAGE2_CAP_FLAGS_IME_SUPPORT              (0x00000002)
>  #define MPI_IOCPAGE2_CAP_FLAGS_IM_SUPPORT               (0x00000004)
> +#define MPI_IOCPAGE2_CAP_FLAGS_RAID_5_SUPPORT           (0x00000008)
> +#define MPI_IOCPAGE2_CAP_FLAGS_RAID_6_SUPPORT           (0x00000010)
> +#define MPI_IOCPAGE2_CAP_FLAGS_RAID_10_SUPPORT          (0x00000020)
> +#define MPI_IOCPAGE2_CAP_FLAGS_RAID_50_SUPPORT          (0x00000040)
>  #define MPI_IOCPAGE2_CAP_FLAGS_SES_SUPPORT              (0x20000000)
>  #define MPI_IOCPAGE2_CAP_FLAGS_SAFTE_SUPPORT            (0x40000000)
>  #define MPI_IOCPAGE2_CAP_FLAGS_CROSS_CHANNEL_SUPPORT    (0x80000000)
> @@ -945,7 +976,7 @@
>  } CONFIG_PAGE_BIOS_1, MPI_POINTER PTR_CONFIG_PAGE_BIOS_1,
>    BIOSPage1_t, MPI_POINTER pBIOSPage1_t;
>  
> -#define MPI_BIOSPAGE1_PAGEVERSION                       (0x01)
> +#define MPI_BIOSPAGE1_PAGEVERSION                       (0x02)
>  
>  /* values for the BiosOptions field */
>  #define MPI_BIOSPAGE1_OPTIONS_SPI_ENABLE                (0x00000400)
> @@ -954,6 +985,8 @@
>  #define MPI_BIOSPAGE1_OPTIONS_DISABLE_BIOS              (0x00000001)
>  
>  /* values for the IOCSettings field */
> +#define MPI_BIOSPAGE1_IOCSET_MASK_PORT_ENABLE_DELAY     (0x00F00000)
> +#define MPI_BIOSPAGE1_IOCSET_SHIFT_PORT_ENABLE_DELAY    (20)
>  #define MPI_BIOSPAGE1_IOCSET_MASK_BOOT_PREFERENCE       (0x00030000)
>  #define MPI_BIOSPAGE1_IOCSET_ENCLOSURE_SLOT_BOOT        (0x00000000)
>  #define MPI_BIOSPAGE1_IOCSET_SAS_ADDRESS_BOOT           (0x00010000)
> @@ -1167,6 +1200,7 @@
>  #define MPI_BIOSPAGE2_FORM_PCI_SLOT_NUMBER              (0x03)
>  #define MPI_BIOSPAGE2_FORM_FC_WWN                       (0x04)
>  #define MPI_BIOSPAGE2_FORM_SAS_WWN                      (0x05)
> +#define MPI_BIOSPAGE2_FORM_ENCLOSURE_SLOT               (0x06)
>  
>  
>  
> /*************************************************************
> ***************
> @@ -1957,11 +1991,11 @@
>    RaidVol0Status_t, MPI_POINTER pRaidVol0Status_t;
>  
>  /* RAID Volume Page 0 VolumeStatus defines */
> -
>  #define MPI_RAIDVOL0_STATUS_FLAG_ENABLED                (0x01)
>  #define MPI_RAIDVOL0_STATUS_FLAG_QUIESCED               (0x02)
>  #define MPI_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS     (0x04)
>  #define MPI_RAIDVOL0_STATUS_FLAG_VOLUME_INACTIVE        (0x08)
> +#define MPI_RAIDVOL0_STATUS_FLAG_BAD_BLOCK_TABLE_FULL   (0x10)
>  
>  #define MPI_RAIDVOL0_STATUS_STATE_OPTIMAL               (0x00)
>  #define MPI_RAIDVOL0_STATUS_STATE_DEGRADED              (0x01)
> @@ -2025,7 +2059,7 @@
>  } CONFIG_PAGE_RAID_VOL_0, MPI_POINTER PTR_CONFIG_PAGE_RAID_VOL_0,
>    RaidVolumePage0_t, MPI_POINTER pRaidVolumePage0_t;
>  
> -#define MPI_RAIDVOLPAGE0_PAGEVERSION                    (0x04)
> +#define MPI_RAIDVOLPAGE0_PAGEVERSION                    (0x05)
>  
>  /* values for RAID Volume Page 0 InactiveStatus field */
>  #define MPI_RAIDVOLPAGE0_UNKNOWN_INACTIVE               (0x00)
> @@ -2104,6 +2138,8 @@
>  #define MPI_PHYSDISK0_STATUS_FLAG_OUT_OF_SYNC           (0x01)
>  #define MPI_PHYSDISK0_STATUS_FLAG_QUIESCED              (0x02)
>  #define MPI_PHYSDISK0_STATUS_FLAG_INACTIVE_VOLUME       (0x04)
> +#define MPI_PHYSDISK0_STATUS_FLAG_OPTIMAL_PREVIOUS      (0x00)
> +#define MPI_PHYSDISK0_STATUS_FLAG_NOT_OPTIMAL_PREVIOUS  (0x08)
>  
>  #define MPI_PHYSDISK0_STATUS_ONLINE                     (0x00)
>  #define MPI_PHYSDISK0_STATUS_MISSING                    (0x01)
> @@ -2132,7 +2168,7 @@
>  } CONFIG_PAGE_RAID_PHYS_DISK_0, MPI_POINTER 
> PTR_CONFIG_PAGE_RAID_PHYS_DISK_0,
>    RaidPhysDiskPage0_t, MPI_POINTER pRaidPhysDiskPage0_t;
>  
> -#define MPI_RAIDPHYSDISKPAGE0_PAGEVERSION           (0x01)
> +#define MPI_RAIDPHYSDISKPAGE0_PAGEVERSION           (0x02)
>  
>  
>  typedef struct _RAID_PHYS_DISK1_PATH
> @@ -2263,7 +2299,7 @@
>  } CONFIG_PAGE_SAS_IO_UNIT_0, MPI_POINTER 
> PTR_CONFIG_PAGE_SAS_IO_UNIT_0,
>    SasIOUnitPage0_t, MPI_POINTER pSasIOUnitPage0_t;
>  
> -#define MPI_SASIOUNITPAGE0_PAGEVERSION      (0x02)
> +#define MPI_SASIOUNITPAGE0_PAGEVERSION      (0x03)
>  
>  /* values for SAS IO Unit Page 0 PortFlags */
>  #define MPI_SAS_IOUNIT0_PORT_FLAGS_DISCOVERY_IN_PROGRESS    (0x08)
> @@ -2299,6 +2335,7 @@
>  #define MPI_SAS_IOUNIT0_DS_SUBTRACTIVE_LINK                 
> (0x00000200)
>  #define MPI_SAS_IOUNIT0_DS_TABLE_LINK                       
> (0x00000400)
>  #define MPI_SAS_IOUNIT0_DS_UNSUPPORTED_DEVICE               
> (0x00000800)
> +#define MPI_SAS_IOUNIT0_DS_MAX_SATA_TARGETS                 
> (0x00001000)
>  
>  
>  typedef struct _MPI_SAS_IO_UNIT1_PHY_DATA
> @@ -2336,6 +2373,7 @@
>  #define MPI_SASIOUNITPAGE1_PAGEVERSION      (0x04)
>  
>  /* values for SAS IO Unit Page 1 ControlFlags */
> +#define MPI_SAS_IOUNIT1_CONTROL_DEVICE_SELF_TEST        (0x8000)
>  #define MPI_SAS_IOUNIT1_CONTROL_SATA_3_0_MAX            (0x4000)
>  #define MPI_SAS_IOUNIT1_CONTROL_SATA_1_5_MAX            (0x2000)
>  #define MPI_SAS_IOUNIT1_CONTROL_SATA_SW_PRESERVE        (0x1000)
> @@ -2345,9 +2383,8 @@
>  #define MPI_SAS_IOUNIT1_CONTROL_SHIFT_DEV_SUPPORT       (9)
>  #define MPI_SAS_IOUNIT1_CONTROL_DEV_SUPPORT_BOTH        (0x00)
>  #define MPI_SAS_IOUNIT1_CONTROL_DEV_SAS_SUPPORT         (0x01)
> -#define MPI_SAS_IOUNIT1_CONTROL_DEV_SATA_SUPPORT        (0x10)
> +#define MPI_SAS_IOUNIT1_CONTROL_DEV_SATA_SUPPORT        (0x02)
>  
> -#define MPI_SAS_IOUNIT1_CONTROL_AUTO_PORT_SAME_SAS_ADDR (0x0100)
>  #define MPI_SAS_IOUNIT1_CONTROL_SATA_48BIT_LBA_REQUIRED (0x0080)
>  #define MPI_SAS_IOUNIT1_CONTROL_SATA_SMART_REQUIRED     (0x0040)
>  #define MPI_SAS_IOUNIT1_CONTROL_SATA_NCQ_REQUIRED       (0x0020)
> @@ -2390,7 +2427,7 @@
>  } CONFIG_PAGE_SAS_IO_UNIT_2, MPI_POINTER 
> PTR_CONFIG_PAGE_SAS_IO_UNIT_2,
>    SasIOUnitPage2_t, MPI_POINTER pSasIOUnitPage2_t;
>  
> -#define MPI_SASIOUNITPAGE2_PAGEVERSION      (0x03)
> +#define MPI_SASIOUNITPAGE2_PAGEVERSION      (0x04)
>  
>  /* values for SAS IO Unit Page 2 Status field */
>  #define MPI_SAS_IOUNIT2_STATUS_DISABLED_PERSISTENT_MAPPINGS (0x02)
> @@ -2406,6 +2443,7 @@
>  #define MPI_SAS_IOUNIT2_FLAGS_ENCLOSURE_SLOT_PHYS_MAP       (0x02)
>  
>  #define MPI_SAS_IOUNIT2_FLAGS_RESERVE_ID_0_FOR_BOOT         (0x10)
> +#define MPI_SAS_IOUNIT2_FLAGS_DA_STARTING_SLOT              (0x20)
>  
>  
>  typedef struct _CONFIG_PAGE_SAS_IO_UNIT_3
> @@ -2584,11 +2622,19 @@
>  {
>      CONFIG_EXTENDED_PAGE_HEADER         Header;              
>    /* 00h */
>      U64                                 PhysicalIdentifier;  
>    /* 08h */
> -    U32                                 Reserved1;           
>    /* 10h */
> +    U32                                 EnclosureMapping;    
>    /* 10h */
>  } CONFIG_PAGE_SAS_DEVICE_2, MPI_POINTER PTR_CONFIG_PAGE_SAS_DEVICE_2,
>    SasDevicePage2_t, MPI_POINTER pSasDevicePage2_t;
>  
> -#define MPI_SASDEVICE2_PAGEVERSION          (0x00)
> +#define MPI_SASDEVICE2_PAGEVERSION          (0x01)
> +
> +/* defines for SAS Device Page 2 EnclosureMapping field */
> +#define MPI_SASDEVICE2_ENC_MAP_MASK_MISSING_COUNT       (0x0000000F)
> +#define MPI_SASDEVICE2_ENC_MAP_SHIFT_MISSING_COUNT      (0)
> +#define MPI_SASDEVICE2_ENC_MAP_MASK_NUM_SLOTS           (0x000007F0)
> +#define MPI_SASDEVICE2_ENC_MAP_SHIFT_NUM_SLOTS          (4)
> +#define MPI_SASDEVICE2_ENC_MAP_MASK_START_INDEX         (0x001FF800)
> +#define MPI_SASDEVICE2_ENC_MAP_SHIFT_START_INDEX        (11)
>  
>  
>  
> /*************************************************************
> ***************
> @@ -2598,7 +2644,8 @@
>  typedef struct _CONFIG_PAGE_SAS_PHY_0
>  {
>      CONFIG_EXTENDED_PAGE_HEADER         Header;              
>    /* 00h */
> -    U32                                 Reserved1;           
>    /* 08h */
> +    U16                                 OwnerDevHandle;      
>    /* 08h */
> +    U16                                 Reserved1;           
>    /* 0Ah */
>      U64                                 SASAddress;          
>    /* 0Ch */
>      U16                                 AttachedDevHandle;   
>    /* 14h */
>      U8                                  
> AttachedPhyIdentifier;  /* 16h */
> @@ -2607,12 +2654,12 @@
>      U8                                  ProgrammedLinkRate;  
>    /* 20h */
>      U8                                  HwLinkRate;          
>    /* 21h */
>      U8                                  ChangeCount;         
>    /* 22h */
> -    U8                                  Reserved3;           
>    /* 23h */
> +    U8                                  Flags;               
>    /* 23h */
>      U32                                 PhyInfo;             
>    /* 24h */
>  } CONFIG_PAGE_SAS_PHY_0, MPI_POINTER PTR_CONFIG_PAGE_SAS_PHY_0,
>    SasPhyPage0_t, MPI_POINTER pSasPhyPage0_t;
>  
> -#define MPI_SASPHY0_PAGEVERSION             (0x00)
> +#define MPI_SASPHY0_PAGEVERSION             (0x01)
>  
>  /* values for SAS PHY Page 0 ProgrammedLinkRate field */
>  #define MPI_SAS_PHY0_PRATE_MAX_RATE_MASK                     
>    (0xF0)
> @@ -2632,6 +2679,9 @@
>  #define MPI_SAS_PHY0_HWRATE_MIN_RATE_1_5                     
>    (0x08)
>  #define MPI_SAS_PHY0_HWRATE_MIN_RATE_3_0                     
>    (0x09)
>  
> +/* values for SAS PHY Page 0 Flags field */
> +#define MPI_SAS_PHY0_FLAGS_SGPIO_DIRECT_ATTACH_ENC           
>    (0x01)
> +
>  /* values for SAS PHY Page 0 PhyInfo field */
>  #define MPI_SAS_PHY0_PHYINFO_SATA_PORT_ACTIVE                
>    (0x00004000)
>  #define MPI_SAS_PHY0_PHYINFO_SATA_PORT_SELECTOR              
>    (0x00002000)
> @@ -2690,7 +2740,7 @@
>  } CONFIG_PAGE_SAS_ENCLOSURE_0, MPI_POINTER 
> PTR_CONFIG_PAGE_SAS_ENCLOSURE_0,
>    SasEnclosurePage0_t, MPI_POINTER pSasEnclosurePage0_t;
>  
> -#define MPI_SASENCLOSURE0_PAGEVERSION       (0x00)
> +#define MPI_SASENCLOSURE0_PAGEVERSION       (0x01)
>  
>  /* values for SAS Enclosure Page 0 Flags field */
>  #define MPI_SAS_ENCLS0_FLAGS_SEP_BUS_ID_VALID       (0x0020)
> @@ -2702,6 +2752,7 @@
>  #define MPI_SAS_ENCLS0_FLAGS_MNG_IOC_SGPIO          (0x0002)
>  #define MPI_SAS_ENCLS0_FLAGS_MNG_EXP_SGPIO          (0x0003)
>  #define MPI_SAS_ENCLS0_FLAGS_MNG_SES_ENCLOSURE      (0x0004)
> +#define MPI_SAS_ENCLS0_FLAGS_MNG_IOC_GPIO           (0x0005)
>  
>  
>  
> /*************************************************************
> ***************
> Index: scsi-misc-2.6/drivers/message/fusion/lsi/mpi.h
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/lsi/mpi.h	
> 2005-08-17 12:03:52.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/lsi/mpi.h	
> 2005-08-17 12:04:01.000000000 +0200
> @@ -6,7 +6,7 @@
>   *          Title:  MPI Message independent structures and 
> definitions
>   *  Creation Date:  July 27, 2000
>   *
> - *    mpi.h Version:  01.05.07
> + *    mpi.h Version:  01.05.08
>   *
>   *  Version History
>   *  ---------------
> @@ -71,6 +71,9 @@
>   *  03-11-05  01.05.07  Removed function codes for SCSI IO 32 and
>   *                      TargetAssistExtended requests.
>   *                      Removed EEDP IOCStatus codes.
> + *  06-24-05  01.05.08  Added function codes for SCSI IO 32 and
> + *                      TargetAssistExtended requests.
> + *                      Added EEDP IOCStatus codes.
>   *  
> --------------------------------------------------------------
> ------------
>   */
>  
> @@ -101,7 +104,7 @@
>  /* Note: The major versions of 0xe0 through 0xff are reserved */
>  
>  /* versioning for this MPI header set */
> -#define MPI_HEADER_VERSION_UNIT             (0x09)
> +#define MPI_HEADER_VERSION_UNIT             (0x0A)
>  #define MPI_HEADER_VERSION_DEV              (0x00)
>  #define MPI_HEADER_VERSION_UNIT_MASK        (0xFF00)
>  #define MPI_HEADER_VERSION_UNIT_SHIFT       (8)
> @@ -292,10 +295,13 @@
>  #define MPI_FUNCTION_DIAG_BUFFER_POST               (0x1D)
>  #define MPI_FUNCTION_DIAG_RELEASE                   (0x1E)
>  
> +#define MPI_FUNCTION_SCSI_IO_32                     (0x1F)
> +
>  #define MPI_FUNCTION_LAN_SEND                       (0x20)
>  #define MPI_FUNCTION_LAN_RECEIVE                    (0x21)
>  #define MPI_FUNCTION_LAN_RESET                      (0x22)
>  
> +#define MPI_FUNCTION_TARGET_ASSIST_EXTENDED         (0x23)
>  #define MPI_FUNCTION_TARGET_CMD_BUF_BASE_POST       (0x24)
>  #define MPI_FUNCTION_TARGET_CMD_BUF_LIST_POST       (0x25)
>  
> @@ -681,6 +687,15 @@
>  #define MPI_IOCSTATUS_SCSI_EXT_TERMINATED       (0x004C)
>  
>  
> /*************************************************************
> ***************/
> +/*  For use by SCSI Initiator and SCSI Target end-to-end 
> data protection    */
> +/************************************************************
> ****************/
> +
> +#define MPI_IOCSTATUS_EEDP_GUARD_ERROR          (0x004D)
> +#define MPI_IOCSTATUS_EEDP_REF_TAG_ERROR        (0x004E)
> +#define MPI_IOCSTATUS_EEDP_APP_TAG_ERROR        (0x004F)
> +
> +
> +/************************************************************
> ****************/
>  /*  SCSI Target values                                       
>                */
>  
> /*************************************************************
> ***************/
>  
> Index: scsi-misc-2.6/drivers/message/fusion/lsi/mpi_history.txt
> ===================================================================
> --- 
> scsi-misc-2.6.orig/drivers/message/fusion/lsi/mpi_history.txt	
> 2005-08-17 12:03:52.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/lsi/mpi_history.txt	
> 2005-08-17 12:04:01.000000000 +0200
> @@ -6,17 +6,17 @@
>   Copyright (c) 2000-2005 LSI Logic Corporation.
>  
>   ---------------------------------------
> - Header Set Release Version:    01.05.09
> + Header Set Release Version:    01.05.10
>   Header Set Release Date:       03-11-05
>   ---------------------------------------
>  
>   Filename               Current version     Prior version
>   ----------             ---------------     -------------
> - mpi.h                  01.05.07            01.05.06
> - mpi_ioc.h              01.05.08            01.05.07
> - mpi_cnfg.h             01.05.08            01.05.07
> - mpi_init.h             01.05.04            01.05.03
> - mpi_targ.h             01.05.04            01.05.03
> + mpi.h                  01.05.08            01.05.07
> + mpi_ioc.h              01.05.09            01.05.08
> + mpi_cnfg.h             01.05.09            01.05.08
> + mpi_init.h             01.05.05            01.05.04
> + mpi_targ.h             01.05.05            01.05.04
>   mpi_fc.h               01.05.01            01.05.01
>   mpi_lan.h              01.05.01            01.05.01
>   mpi_raid.h             01.05.02            01.05.02
> @@ -24,7 +24,7 @@
>   mpi_inb.h              01.05.01            01.05.01
>   mpi_sas.h              01.05.01            01.05.01
>   mpi_type.h             01.05.01            01.05.01
> - mpi_history.txt        01.05.09            01.05.08
> + mpi_history.txt        01.05.09            01.05.09
>  
>  
>   *  Date      Version   Description
> @@ -88,6 +88,9 @@
>   *  03-11-05  01.05.07  Removed function codes for SCSI IO 32 and
>   *                      TargetAssistExtended requests.
>   *                      Removed EEDP IOCStatus codes.
> + *  06-24-05  01.05.08  Added function codes for SCSI IO 32 and
> + *                      TargetAssistExtended requests.
> + *                      Added EEDP IOCStatus codes.
>   *  
> --------------------------------------------------------------
> ------------
>  
>  mpi_ioc.h
> @@ -159,6 +162,8 @@
>   *                      Reply and IOC Init Request.
>   *  03-11-05  01.05.08  Added family code for 1068E family.
>   *                      Removed IOCFacts Reply EEDP Capability bit.
> + *  06-24-05  01.05.09  Added 5 new IOCFacts Reply 
> IOCCapabilities bits.
> + *                      Added Max SATA Targets to SAS 
> Discovery Error event.
>   *  
> --------------------------------------------------------------
> ------------
>  
>  mpi_cnfg.h
> @@ -380,6 +385,23 @@
>   *                      New physical mapping mode in SAS IO 
> Unit Page 2.
>   *                      Added CONFIG_PAGE_SAS_ENCLOSURE_0.
>   *                      Added Slot and Enclosure fields to 
> SAS Device Page 0.
> + *  06-24-05  01.05.09  Added EEDP defines to IOC Page 1.
> + *                      Added more RAID type defines to IOC Page 2.
> + *                      Added Port Enable Delay settings to 
> BIOS Page 1.
> + *                      Added Bad Block Table Full define to 
> RAID Volume Page 0.
> + *                      Added Previous State defines to RAID 
> Physical Disk
> + *                      Page 0.
> + *                      Added Max Sata Targets define for 
> DiscoveryStatus field
> + *                      of SAS IO Unit Page 0.
> + *                      Added Device Self Test to Control 
> Flags of SAS IO Unit
> + *                      Page 1.
> + *                      Added Direct Attach Starting Slot 
> Number define for SAS
> + *                      IO Unit Page 2.
> + *                      Added new fields in SAS Device Page 
> 2 for enclosure
> + *                      mapping.
> + *                      Added OwnerDevHandle and Flags field 
> to SAS PHY Page 0.
> + *                      Added IOC GPIO Flags define to SAS 
> Enclosure Page 0.
> + *                      Fixed the value for 
> MPI_SAS_IOUNIT1_CONTROL_DEV_SATA_SUPPORT.
>   *  
> --------------------------------------------------------------
> ------------
>  
>  mpi_init.h
> @@ -418,6 +440,8 @@
>   *                      Modified SCSI Enclosure Processor 
> Request and Reply to
>   *                      support Enclosure/Slot addressing 
> rather than WWID
>   *                      addressing.
> + *  06-24-05  01.05.05  Added SCSI IO 32 structures and defines.
> + *                      Added four new defines for SEP SlotStatus.
>   *  
> --------------------------------------------------------------
> ------------
>  
>  mpi_targ.h
> @@ -461,6 +485,7 @@
>   *  10-05-04  01.05.02  
> MSG_TARGET_CMD_BUFFER_POST_BASE_LIST_REPLY added.
>   *  02-22-05  01.05.03  Changed a comment.
>   *  03-11-05  01.05.04  Removed TargetAssistExtended Request.
> + *  06-24-05  01.05.05  Added TargetAssistExtended 
> structures and defines.
>   *  
> --------------------------------------------------------------
> ------------
>  
>  mpi_fc.h
> @@ -571,20 +596,20 @@
>  
>  mpi_history.txt         Parts list history
>  
> -Filename    01.05.09
> -----------  --------
> -mpi.h       01.05.07
> -mpi_ioc.h   01.05.08
> -mpi_cnfg.h  01.05.08
> -mpi_init.h  01.05.04
> -mpi_targ.h  01.05.04
> -mpi_fc.h    01.05.01
> -mpi_lan.h   01.05.01
> -mpi_raid.h  01.05.02
> -mpi_tool.h  01.05.03
> -mpi_inb.h   01.05.01
> -mpi_sas.h   01.05.01
> -mpi_type.h  01.05.01
> +Filename    01.05.10  01.05.09
> +----------  --------  --------
> +mpi.h       01.05.08  01.05.07
> +mpi_ioc.h   01.05.09  01.05.08
> +mpi_cnfg.h  01.05.09  01.05.08
> +mpi_init.h  01.05.05  01.05.04
> +mpi_targ.h  01.05.05  01.05.04
> +mpi_fc.h    01.05.01  01.05.01
> +mpi_lan.h   01.05.01  01.05.01
> +mpi_raid.h  01.05.02  01.05.02
> +mpi_tool.h  01.05.03  01.05.03
> +mpi_inb.h   01.05.01  01.05.01
> +mpi_sas.h   01.05.01  01.05.01
> +mpi_type.h  01.05.01  01.05.01
>  
>  Filename    01.05.08   01.05.07   01.05.06   01.05.05   
> 01.05.04   01.05.03
>  ----------  --------   --------   --------   --------   
> --------   --------
> Index: scsi-misc-2.6/drivers/message/fusion/lsi/mpi_init.h
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/lsi/mpi_init.h	
> 2005-08-17 12:03:52.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/lsi/mpi_init.h	
> 2005-08-17 12:04:01.000000000 +0200
> @@ -6,7 +6,7 @@
>   *          Title:  MPI initiator mode messages and structures
>   *  Creation Date:  June 8, 2000
>   *
> - *    mpi_init.h Version:  01.05.04
> + *    mpi_init.h Version:  01.05.05
>   *
>   *  Version History
>   *  ---------------
> @@ -48,6 +48,8 @@
>   *                      Modified SCSI Enclosure Processor 
> Request and Reply to
>   *                      support Enclosure/Slot addressing 
> rather than WWID
>   *                      addressing.
> + *  06-24-05  01.05.05  Added SCSI IO 32 structures and defines.
> + *                      Added four new defines for SEP SlotStatus.
>   *  
> --------------------------------------------------------------
> ------------
>   */
>  
> @@ -203,6 +205,197 @@
>  
>  
>  
> /*************************************************************
> ***************/
> +/*  SCSI IO 32 messages and associated structures            
>                */
> +/************************************************************
> ****************/
> +
> +typedef struct
> +{
> +    U8                      CDB[20];                    /* 00h */
> +    U32                     PrimaryReferenceTag;        /* 14h */
> +    U16                     PrimaryApplicationTag;      /* 18h */
> +    U16                     PrimaryApplicationTagMask;  /* 1Ah */
> +    U32                     TransferLength;             /* 1Ch */
> +} MPI_SCSI_IO32_CDB_EEDP32, MPI_POINTER PTR_MPI_SCSI_IO32_CDB_EEDP32,
> +  MpiScsiIo32CdbEedp32_t, MPI_POINTER pMpiScsiIo32CdbEedp32_t;
> +
> +typedef struct
> +{
> +    U8                      CDB[16];                    /* 00h */
> +    U32                     DataLength;                 /* 10h */
> +    U32                     PrimaryReferenceTag;        /* 14h */
> +    U16                     PrimaryApplicationTag;      /* 18h */
> +    U16                     PrimaryApplicationTagMask;  /* 1Ah */
> +    U32                     TransferLength;             /* 1Ch */
> +} MPI_SCSI_IO32_CDB_EEDP16, MPI_POINTER PTR_MPI_SCSI_IO32_CDB_EEDP16,
> +  MpiScsiIo32CdbEedp16_t, MPI_POINTER pMpiScsiIo32CdbEedp16_t;
> +
> +typedef union
> +{
> +    U8                       CDB32[32];
> +    MPI_SCSI_IO32_CDB_EEDP32 EEDP32;
> +    MPI_SCSI_IO32_CDB_EEDP16 EEDP16;
> +    SGE_SIMPLE_UNION         SGE;
> +} MPI_SCSI_IO32_CDB_UNION, MPI_POINTER PTR_MPI_SCSI_IO32_CDB_UNION,
> +  MpiScsiIo32Cdb_t, MPI_POINTER pMpiScsiIo32Cdb_t;
> +
> +typedef struct
> +{
> +    U8                      TargetID;           /* 00h */
> +    U8                      Bus;                /* 01h */
> +    U16                     Reserved1;          /* 02h */
> +    U32                     Reserved2;          /* 04h */
> +} MPI_SCSI_IO32_BUS_TARGET_ID_FORM, MPI_POINTER 
> PTR_MPI_SCSI_IO32_BUS_TARGET_ID_FORM,
> +  MpiScsiIo32BusTargetIdForm_t, MPI_POINTER 
> pMpiScsiIo32BusTargetIdForm_t;
> +
> +typedef union
> +{
> +    MPI_SCSI_IO32_BUS_TARGET_ID_FORM    SCSIID;
> +    U64                                 WWID;
> +} MPI_SCSI_IO32_ADDRESS, MPI_POINTER PTR_MPI_SCSI_IO32_ADDRESS,
> +  MpiScsiIo32Address_t, MPI_POINTER pMpiScsiIo32Address_t;
> +
> +typedef struct _MSG_SCSI_IO32_REQUEST
> +{
> +    U8                          Port;                        
>    /* 00h */
> +    U8                          Reserved1;                   
>    /* 01h */
> +    U8                          ChainOffset;                 
>    /* 02h */
> +    U8                          Function;                    
>    /* 03h */
> +    U8                          CDBLength;                   
>    /* 04h */
> +    U8                          SenseBufferLength;           
>    /* 05h */
> +    U8                          Flags;                       
>    /* 06h */
> +    U8                          MsgFlags;                    
>    /* 07h */
> +    U32                         MsgContext;                  
>    /* 08h */
> +    U8                          LUN[8];                      
>    /* 0Ch */
> +    U32                         Control;                     
>    /* 14h */
> +    MPI_SCSI_IO32_CDB_UNION     CDB;                         
>    /* 18h */
> +    U32                         DataLength;                  
>    /* 38h */
> +    U32                         BidirectionalDataLength;     
>    /* 3Ch */
> +    U32                         SecondaryReferenceTag;       
>    /* 40h */
> +    U16                         SecondaryApplicationTag;     
>    /* 44h */
> +    U16                         Reserved2;                   
>    /* 46h */
> +    U16                         EEDPFlags;                   
>    /* 48h */
> +    U16                         
> ApplicationTagTranslationMask;  /* 4Ah */
> +    U32                         EEDPBlockSize;               
>    /* 4Ch */
> +    MPI_SCSI_IO32_ADDRESS       DeviceAddress;               
>    /* 50h */
> +    U8                          SGLOffset0;                  
>    /* 58h */
> +    U8                          SGLOffset1;                  
>    /* 59h */
> +    U8                          SGLOffset2;                  
>    /* 5Ah */
> +    U8                          SGLOffset3;                  
>    /* 5Bh */
> +    U32                         Reserved3;                   
>    /* 5Ch */
> +    U32                         Reserved4;                   
>    /* 60h */
> +    U32                         SenseBufferLowAddr;          
>    /* 64h */
> +    SGE_IO_UNION                SGL;                         
>    /* 68h */
> +} MSG_SCSI_IO32_REQUEST, MPI_POINTER PTR_MSG_SCSI_IO32_REQUEST,
> +  SCSIIO32Request_t, MPI_POINTER pSCSIIO32Request_t;
> +
> +/* SCSI IO 32 MsgFlags bits */
> +#define MPI_SCSIIO32_MSGFLGS_SENSE_WIDTH                (0x01)
> +#define MPI_SCSIIO32_MSGFLGS_SENSE_WIDTH_32             (0x00)
> +#define MPI_SCSIIO32_MSGFLGS_SENSE_WIDTH_64             (0x01)
> +
> +#define MPI_SCSIIO32_MSGFLGS_SENSE_LOCATION             (0x02)
> +#define MPI_SCSIIO32_MSGFLGS_SENSE_LOC_HOST             (0x00)
> +#define MPI_SCSIIO32_MSGFLGS_SENSE_LOC_IOC              (0x02)
> +
> +#define MPI_SCSIIO32_MSGFLGS_CMD_DETERMINES_DATA_DIR    (0x04)
> +#define MPI_SCSIIO32_MSGFLGS_SGL_OFFSETS_CHAINS         (0x08)
> +#define MPI_SCSIIO32_MSGFLGS_MULTICAST                  (0x10)
> +#define MPI_SCSIIO32_MSGFLGS_BIDIRECTIONAL              (0x20)
> +#define MPI_SCSIIO32_MSGFLGS_LARGE_CDB                  (0x40)
> +
> +/* SCSI IO 32 Flags bits */
> +#define MPI_SCSIIO32_FLAGS_FORM_MASK                    (0x03)
> +#define MPI_SCSIIO32_FLAGS_FORM_SCSIID                  (0x00)
> +#define MPI_SCSIIO32_FLAGS_FORM_WWID                    (0x01)
> +
> +/* SCSI IO 32 LUN fields */
> +#define MPI_SCSIIO32_LUN_FIRST_LEVEL_ADDRESSING     (0x0000FFFF)
> +#define MPI_SCSIIO32_LUN_SECOND_LEVEL_ADDRESSING    (0xFFFF0000)
> +#define MPI_SCSIIO32_LUN_THIRD_LEVEL_ADDRESSING     (0x0000FFFF)
> +#define MPI_SCSIIO32_LUN_FOURTH_LEVEL_ADDRESSING    (0xFFFF0000)
> +#define MPI_SCSIIO32_LUN_LEVEL_1_WORD               (0xFF00)
> +#define MPI_SCSIIO32_LUN_LEVEL_1_DWORD              (0x0000FF00)
> +
> +/* SCSI IO 32 Control bits */
> +#define MPI_SCSIIO32_CONTROL_DATADIRECTION_MASK     (0x03000000)
> +#define MPI_SCSIIO32_CONTROL_NODATATRANSFER         (0x00000000)
> +#define MPI_SCSIIO32_CONTROL_WRITE                  (0x01000000)
> +#define MPI_SCSIIO32_CONTROL_READ                   (0x02000000)
> +#define MPI_SCSIIO32_CONTROL_BIDIRECTIONAL          (0x03000000)
> +
> +#define MPI_SCSIIO32_CONTROL_ADDCDBLEN_MASK         (0xFC000000)
> +#define MPI_SCSIIO32_CONTROL_ADDCDBLEN_SHIFT        (26)
> +
> +#define MPI_SCSIIO32_CONTROL_TASKATTRIBUTE_MASK     (0x00000700)
> +#define MPI_SCSIIO32_CONTROL_SIMPLEQ                (0x00000000)
> +#define MPI_SCSIIO32_CONTROL_HEADOFQ                (0x00000100)
> +#define MPI_SCSIIO32_CONTROL_ORDEREDQ               (0x00000200)
> +#define MPI_SCSIIO32_CONTROL_ACAQ                   (0x00000400)
> +#define MPI_SCSIIO32_CONTROL_UNTAGGED               (0x00000500)
> +#define MPI_SCSIIO32_CONTROL_NO_DISCONNECT          (0x00000700)
> +
> +#define MPI_SCSIIO32_CONTROL_TASKMANAGE_MASK        (0x00FF0000)
> +#define MPI_SCSIIO32_CONTROL_OBSOLETE               (0x00800000)
> +#define MPI_SCSIIO32_CONTROL_CLEAR_ACA_RSV          (0x00400000)
> +#define MPI_SCSIIO32_CONTROL_TARGET_RESET           (0x00200000)
> +#define MPI_SCSIIO32_CONTROL_LUN_RESET_RSV          (0x00100000)
> +#define MPI_SCSIIO32_CONTROL_RESERVED               (0x00080000)
> +#define MPI_SCSIIO32_CONTROL_CLR_TASK_SET_RSV       (0x00040000)
> +#define MPI_SCSIIO32_CONTROL_ABORT_TASK_SET         (0x00020000)
> +#define MPI_SCSIIO32_CONTROL_RESERVED2              (0x00010000)
> +
> +/* SCSI IO 32 EEDPFlags */
> +#define MPI_SCSIIO32_EEDPFLAGS_MASK_OP              (0x0007)
> +#define MPI_SCSIIO32_EEDPFLAGS_NOOP_OP              (0x0000)
> +#define MPI_SCSIIO32_EEDPFLAGS_CHK_OP               (0x0001)
> +#define MPI_SCSIIO32_EEDPFLAGS_STRIP_OP             (0x0002)
> +#define MPI_SCSIIO32_EEDPFLAGS_CHKRM_OP             (0x0003)
> +#define MPI_SCSIIO32_EEDPFLAGS_INSERT_OP            (0x0004)
> +#define MPI_SCSIIO32_EEDPFLAGS_REPLACE_OP           (0x0006)
> +#define MPI_SCSIIO32_EEDPFLAGS_CHKREGEN_OP          (0x0007)
> +
> +#define MPI_SCSIIO32_EEDPFLAGS_PASS_REF_TAG         (0x0008)
> +#define MPI_SCSIIO32_EEDPFLAGS_8_9THS_MODE          (0x0010)
> +
> +#define MPI_SCSIIO32_EEDPFLAGS_T10_CHK_MASK         (0x0700)
> +#define MPI_SCSIIO32_EEDPFLAGS_T10_CHK_GUARD        (0x0100)
> +#define MPI_SCSIIO32_EEDPFLAGS_T10_CHK_REFTAG       (0x0200)
> +#define MPI_SCSIIO32_EEDPFLAGS_T10_CHK_LBATAG       (0x0400)
> +#define MPI_SCSIIO32_EEDPFLAGS_T10_CHK_SHIFT        (8)
> +
> +#define MPI_SCSIIO32_EEDPFLAGS_INC_SEC_APPTAG       (0x1000)
> +#define MPI_SCSIIO32_EEDPFLAGS_INC_PRI_APPTAG       (0x2000)
> +#define MPI_SCSIIO32_EEDPFLAGS_INC_SEC_REFTAG       (0x4000)
> +#define MPI_SCSIIO32_EEDPFLAGS_INC_PRI_REFTAG       (0x8000)
> +
> +
> +/* SCSIIO32 IO reply structure */
> +typedef struct _MSG_SCSIIO32_IO_REPLY
> +{
> +    U8                      Port;                       /* 00h */
> +    U8                      Reserved1;                  /* 01h */
> +    U8                      MsgLength;                  /* 02h */
> +    U8                      Function;                   /* 03h */
> +    U8                      CDBLength;                  /* 04h */
> +    U8                      SenseBufferLength;          /* 05h */
> +    U8                      Flags;                      /* 06h */
> +    U8                      MsgFlags;                   /* 07h */
> +    U32                     MsgContext;                 /* 08h */
> +    U8                      SCSIStatus;                 /* 0Ch */
> +    U8                      SCSIState;                  /* 0Dh */
> +    U16                     IOCStatus;                  /* 0Eh */
> +    U32                     IOCLogInfo;                 /* 10h */
> +    U32                     TransferCount;              /* 14h */
> +    U32                     SenseCount;                 /* 18h */
> +    U32                     ResponseInfo;               /* 1Ch */
> +    U16                     TaskTag;                    /* 20h */
> +    U16                     Reserved2;                  /* 22h */
> +    U32                     BidirectionalTransferCount; /* 24h */
> +} MSG_SCSIIO32_IO_REPLY, MPI_POINTER PTR_MSG_SCSIIO32_IO_REPLY,
> +  SCSIIO32Reply_t, MPI_POINTER pSCSIIO32Reply_t;
> +
> +
> +/************************************************************
> ****************/
>  /*  SCSI Task Management messages                            
>                */
>  
> /*************************************************************
> ***************/
>  
> @@ -310,10 +503,14 @@
>  #define MPI_SEP_REQ_SLOTSTATUS_UNCONFIGURED             (0x00000080)
>  #define MPI_SEP_REQ_SLOTSTATUS_HOT_SPARE                (0x00000100)
>  #define MPI_SEP_REQ_SLOTSTATUS_REBUILD_STOPPED          (0x00000200)
> +#define MPI_SEP_REQ_SLOTSTATUS_REQ_CONSISTENCY_CHECK    (0x00001000)
> +#define MPI_SEP_REQ_SLOTSTATUS_DISABLE                  (0x00002000)
> +#define MPI_SEP_REQ_SLOTSTATUS_REQ_RESERVED_DEVICE      (0x00004000)
>  #define MPI_SEP_REQ_SLOTSTATUS_IDENTIFY_REQUEST         (0x00020000)
>  #define MPI_SEP_REQ_SLOTSTATUS_REQUEST_REMOVE           (0x00040000)
>  #define MPI_SEP_REQ_SLOTSTATUS_REQUEST_INSERT           (0x00080000)
>  #define MPI_SEP_REQ_SLOTSTATUS_DO_NOT_MOVE              (0x00400000)
> +#define MPI_SEP_REQ_SLOTSTATUS_ACTIVE                   (0x00800000)
>  #define MPI_SEP_REQ_SLOTSTATUS_B_ENABLE_BYPASS          (0x04000000)
>  #define MPI_SEP_REQ_SLOTSTATUS_A_ENABLE_BYPASS          (0x08000000)
>  #define MPI_SEP_REQ_SLOTSTATUS_DEV_OFF                  (0x10000000)
> @@ -352,11 +549,15 @@
>  #define MPI_SEP_REPLY_SLOTSTATUS_UNCONFIGURED           (0x00000080)
>  #define MPI_SEP_REPLY_SLOTSTATUS_HOT_SPARE              (0x00000100)
>  #define MPI_SEP_REPLY_SLOTSTATUS_REBUILD_STOPPED        (0x00000200)
> +#define MPI_SEP_REPLY_SLOTSTATUS_CONSISTENCY_CHECK      (0x00001000)
> +#define MPI_SEP_REPLY_SLOTSTATUS_DISABLE                (0x00002000)
> +#define MPI_SEP_REPLY_SLOTSTATUS_RESERVED_DEVICE        (0x00004000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_REPORT                 (0x00010000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_IDENTIFY_REQUEST       (0x00020000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_REMOVE_READY           (0x00040000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_INSERT_READY           (0x00080000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_DO_NOT_REMOVE          (0x00400000)
> +#define MPI_SEP_REPLY_SLOTSTATUS_ACTIVE                 (0x00800000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_B_BYPASS_ENABLED       (0x01000000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_A_BYPASS_ENABLED       (0x02000000)
>  #define MPI_SEP_REPLY_SLOTSTATUS_B_ENABLE_BYPASS        (0x04000000)
> Index: scsi-misc-2.6/drivers/message/fusion/lsi/mpi_ioc.h
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/lsi/mpi_ioc.h	
> 2005-08-17 12:03:52.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/lsi/mpi_ioc.h	
> 2005-08-17 12:04:01.000000000 +0200
> @@ -6,7 +6,7 @@
>   *          Title:  MPI IOC, Port, Event, FW Download, and 
> FW Upload messages
>   *  Creation Date:  August 11, 2000
>   *
> - *    mpi_ioc.h Version:  01.05.08
> + *    mpi_ioc.h Version:  01.05.09
>   *
>   *  Version History
>   *  ---------------
> @@ -81,6 +81,8 @@
>   *                      Reply and IOC Init Request.
>   *  03-11-05  01.05.08  Added family code for 1068E family.
>   *                      Removed IOCFacts Reply EEDP Capability bit.
> + *  06-24-05  01.05.09  Added 5 new IOCFacts Reply 
> IOCCapabilities bits.
> + *                      Added Max SATA Targets to SAS 
> Discovery Error event.
>   *  
> --------------------------------------------------------------
> ------------
>   */
>  
> @@ -261,7 +263,11 @@
>  #define MPI_IOCFACTS_CAPABILITY_DIAG_TRACE_BUFFER       (0x00000008)
>  #define MPI_IOCFACTS_CAPABILITY_SNAPSHOT_BUFFER         (0x00000010)
>  #define MPI_IOCFACTS_CAPABILITY_EXTENDED_BUFFER         (0x00000020)
> -
> +#define MPI_IOCFACTS_CAPABILITY_EEDP                    (0x00000040)
> +#define MPI_IOCFACTS_CAPABILITY_BIDIRECTIONAL           (0x00000080)
> +#define MPI_IOCFACTS_CAPABILITY_MULTICAST               (0x00000100)
> +#define MPI_IOCFACTS_CAPABILITY_SCSIIO32                (0x00000200)
> +#define MPI_IOCFACTS_CAPABILITY_NO_SCSIIO16             (0x00000400)
>  
>  
>  
> /*************************************************************
> ****************
> @@ -677,6 +683,7 @@
>  #define MPI_EVENT_DSCVRY_ERR_DS_MULTPL_SUBTRACTIVE          
> (0x00000200)
>  #define MPI_EVENT_DSCVRY_ERR_DS_TABLE_TO_TABLE              
> (0x00000400)
>  #define MPI_EVENT_DSCVRY_ERR_DS_MULTPL_PATHS                
> (0x00000800)
> +#define MPI_EVENT_DSCVRY_ERR_DS_MAX_SATA_TARGETS            
> (0x00001000)
>  
>  
>  
> /*************************************************************
> ****************
> Index: scsi-misc-2.6/drivers/message/fusion/lsi/mpi_targ.h
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/lsi/mpi_targ.h	
> 2005-08-17 12:03:52.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/lsi/mpi_targ.h	
> 2005-08-17 12:04:01.000000000 +0200
> @@ -6,7 +6,7 @@
>   *          Title:  MPI Target mode messages and structures
>   *  Creation Date:  June 22, 2000
>   *
> - *    mpi_targ.h Version:  01.05.04
> + *    mpi_targ.h Version:  01.05.05
>   *
>   *  Version History
>   *  ---------------
> @@ -53,6 +53,7 @@
>   *  10-05-04  01.05.02  
> MSG_TARGET_CMD_BUFFER_POST_BASE_LIST_REPLY added.
>   *  02-22-05  01.05.03  Changed a comment.
>   *  03-11-05  01.05.04  Removed TargetAssistExtended Request.
> + *  06-24-05  01.05.05  Added TargetAssistExtended 
> structures and defines.
>   *  
> --------------------------------------------------------------
> ------------
>   */
>  
> @@ -371,6 +372,77 @@
>  
>  
>  
> /*************************************************************
> ***************/
> +/* Target Assist Extended Request                            
>                */
> +/************************************************************
> ****************/
> +
> +typedef struct _MSG_TARGET_ASSIST_EXT_REQUEST
> +{
> +    U8                      StatusCode;                     /* 00h */
> +    U8                      TargetAssistFlags;              /* 01h */
> +    U8                      ChainOffset;                    /* 02h */
> +    U8                      Function;                       /* 03h */
> +    U16                     QueueTag;                       /* 04h */
> +    U8                      Reserved1;                      /* 06h */
> +    U8                      MsgFlags;                       /* 07h */
> +    U32                     MsgContext;                     /* 08h */
> +    U32                     ReplyWord;                      /* 0Ch */
> +    U8                      LUN[8];                         /* 10h */
> +    U32                     RelativeOffset;                 /* 18h */
> +    U32                     Reserved2;                      /* 1Ch */
> +    U32                     Reserved3;                      /* 20h */
> +    U32                     PrimaryReferenceTag;            /* 24h */
> +    U16                     PrimaryApplicationTag;          /* 28h */
> +    U16                     PrimaryApplicationTagMask;      /* 2Ah */
> +    U32                     Reserved4;                      /* 2Ch */
> +    U32                     DataLength;                     /* 30h */
> +    U32                     BidirectionalDataLength;        /* 34h */
> +    U32                     SecondaryReferenceTag;          /* 38h */
> +    U16                     SecondaryApplicationTag;        /* 3Ch */
> +    U16                     Reserved5;                      /* 3Eh */
> +    U16                     EEDPFlags;                      /* 40h */
> +    U16                     ApplicationTagTranslationMask;  /* 42h */
> +    U32                     EEDPBlockSize;                  /* 44h */
> +    U8                      SGLOffset0;                     /* 48h */
> +    U8                      SGLOffset1;                     /* 49h */
> +    U8                      SGLOffset2;                     /* 4Ah */
> +    U8                      SGLOffset3;                     /* 4Bh */
> +    U32                     Reserved6;                      /* 4Ch */
> +    SGE_IO_UNION            SGL[1];                         /* 50h */
> +} MSG_TARGET_ASSIST_EXT_REQUEST, MPI_POINTER 
> PTR_MSG_TARGET_ASSIST_EXT_REQUEST,
> +  TargetAssistExtRequest_t, MPI_POINTER pTargetAssistExtRequest_t;
> +
> +/* see the defines after MSG_TARGET_ASSIST_REQUEST for 
> TargetAssistFlags */
> +
> +/* defines for the MsgFlags field */
> +#define TARGET_ASSIST_EXT_MSGFLAGS_BIDIRECTIONAL        (0x20)
> +#define TARGET_ASSIST_EXT_MSGFLAGS_MULTICAST            (0x10)
> +#define TARGET_ASSIST_EXT_MSGFLAGS_SGL_OFFSET_CHAINS    (0x08)
> +
> +/* defines for the EEDPFlags field */
> +#define TARGET_ASSIST_EXT_EEDP_MASK_OP          (0x0007)
> +#define TARGET_ASSIST_EXT_EEDP_NOOP_OP          (0x0000)
> +#define TARGET_ASSIST_EXT_EEDP_CHK_OP           (0x0001)
> +#define TARGET_ASSIST_EXT_EEDP_STRIP_OP         (0x0002)
> +#define TARGET_ASSIST_EXT_EEDP_CHKRM_OP         (0x0003)
> +#define TARGET_ASSIST_EXT_EEDP_INSERT_OP        (0x0004)
> +#define TARGET_ASSIST_EXT_EEDP_REPLACE_OP       (0x0006)
> +#define TARGET_ASSIST_EXT_EEDP_CHKREGEN_OP      (0x0007)
> +
> +#define TARGET_ASSIST_EXT_EEDP_PASS_REF_TAG     (0x0008)
> +
> +#define TARGET_ASSIST_EXT_EEDP_T10_CHK_MASK     (0x0700)
> +#define TARGET_ASSIST_EXT_EEDP_T10_CHK_GUARD    (0x0100)
> +#define TARGET_ASSIST_EXT_EEDP_T10_CHK_APPTAG   (0x0200)
> +#define TARGET_ASSIST_EXT_EEDP_T10_CHK_REFTAG   (0x0400)
> +#define TARGET_ASSIST_EXT_EEDP_T10_CHK_SHIFT    (8)
> +
> +#define TARGET_ASSIST_EXT_EEDP_INC_SEC_APPTAG   (0x1000)
> +#define TARGET_ASSIST_EXT_EEDP_INC_PRI_APPTAG   (0x2000)
> +#define TARGET_ASSIST_EXT_EEDP_INC_SEC_REFTAG   (0x4000)
> +#define TARGET_ASSIST_EXT_EEDP_INC_PRI_REFTAG   (0x8000)
> +
> +
> +/************************************************************
> ****************/
>  /* Target Status Send Request                                
>                */
>  
> /*************************************************************
> ***************/
>  
> 
