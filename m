From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas : WarpDrive New product SSS6200 support added
Date: Fri, 1 Apr 2011 18:16:28 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157DBB896@inbmail01.lsi.com>
References: <20110203100758.GH23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:50142 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487Ab1DAMpt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 08:45:49 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

Can I have your feedback for this particular patch?

~ Kashyap

> -----Original Message-----
> From: Desai, Kashyap
> Sent: Thursday, March 10, 2011 6:42 PM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
> Subject: RE: [PATCH] mpt2sas : WarpDrive New product SSS6200 support
> added
>
> James,
> Any feedback on this patch submission?  I observe that this patch is
> not following relative depth.
> It has "mpt2sas-phase8.0_wd/mpt2sas_base.c" path, so need to apply
> using -p1 instead of -p4.
>
> Is there any need to resend patch with correct relative depth? Please
> let me know I will resend in that case.
>
> ~ Kashyap
>
>
>
>
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Kashyap, Desai
> > Sent: Thursday, February 03, 2011 3:38 PM
> > To: linux-scsi@vger.kernel.org
> > Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash,
> Sathya
> > Subject: [PATCH] mpt2sas : WarpDrive New product SSS6200 support
> added
> >
> >
> > Introduction
> > This patch has
> > Support for the new solid state device product SSS6200 from LSI and
> > relavent
> > features w.r.t SSS6200.
> >
> > The major feature added in this driver is supporting Direct-I/O to
> the
> > SSS6200 storage.There are some additional changes done to avoid
> > exposing
> > the RAID member disks to the OS and hiding/exposing drives based on
> the
> > OEM Specific Flag in Manufacturing Page10 (this is required to handle
> > specific changes in the SSS6200 firmware).
> >
> > Each and every changes are listed below.
> > 1. Hiding IR related messages.
> > For SSS6200, the driver is modified not to print IR related events.
> > Even if the debugging is enabled the IR related messages will not be
> > displayed.
> > In some places if there is a need to display a message related to IR
> > the
> > string "IR" is replaced with string "DD" and the string "volume" is
> > replaced
> > with "direct drive". But the function names are not changed hence
> there
> > are
> > some places where the reference to volume can be seen if debug level
> is
> > set.
> >
> > 2. Removed RAID transport support
> > In Linux the user can retrieve RAID volume information from the sysfs
> > directory.
> > This support is removed for SSS6200.
> >
> > 3. Direct I/O support.
> > The driver tries to enable direct I/O when a volume is reported to
> the
> > driver
> > by the firmware through IRCC events and the driver does this just
> > before
> > reporting to the OS, hence all the OS issued I/O can go through
> direct
> > path
> > if they can, The first validation is to see whether the manufacturing
> > page10
> > flag is set to expose all drives always. If that is set, the driver
> > will not
> > enable direct I/O and displays the message "DDIO" is disabled
> globally
> > as
> > drives are exposed. The driver checks whether there is more than one
> > volume
> > in the controller, if so the direct I/O will be disabled globally for
> > all
> > volumes in the controller and the message displayed will be "DDIO is
> > disabled
> > globally as number of drives > 1.
> > If retrieving number of PD is failed the driver will not enable
> direct
> > I/O
> > and displays the message Failure in computing number of drives DDIO
> > disabled.
> > If memory allocation for RAIDVolumePage0 is failed, the driver will
> not
> > enable
> > direct I/O and displays the message Memory allocation failure for
> > RVPG0 DDIO disabled.  If retrieving RAIDVolumePage0 is failed the
> > driver will
> > not enable direct I/O and displays the message Failure in retrieving
> > RVPG0 DDIO disabled
> >
> > If the number of PD in a volume is greater than 8, then the direct
> I/O
> > will
> > be disabled.
> > If any of individual drives handle retrieval is failed then the DD-IO
> > will
> > be disabled.
> > If the volume is not RAID0 or if the block size is not 512 then the
> DD-
> > IO will
> > be disabled.
> > If the volume size is greater than 2TB then the DD-IO will be
> disabled.
> > If the driver is not able to find a valid stripe exponent using the
> > configured
> > stripe size then the DD-IO will be disabled
> >
> > When the DD-IO is enabled the driver will check every I/O request
> > issued to
> > the storage and checks whether the request is either
> > READ6/WRITE6/READ10/WRITE10, if it is and if the complete I/O
> transfer
> > is within a stripe size then the I/O is redirected to
> > the drive directly instead of the volume.
> >
> > On completion of every I/O, if the completion is failure means if the
> > reply
> > is address reply with a reply frame associated with it, then the type
> > of I/O
> > will be checked, if the I/O is direct then the I/O will be retried to
> > the volume once.
> >
> > Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> > Reviewed-by: Eric Moore <eric.moore@lsi.com>
> > Reviewed-by: Sathya Prakash <sathya.prakash@lsi.com>
> > ---
> >
> > diff -aurp mpt2sas-phase8.0/mpt2sas_base.c mpt2sas-
> > phase8.0_wd/mpt2sas_base.c
> > --- mpt2sas-phase8.0/mpt2sas_base.c 2011-01-18 11:33:41.384202609
> +0530
> > +++ mpt2sas-phase8.0_wd/mpt2sas_base.c      2011-01-27 20:48:35.080000040
> > +0530
> > @@ -522,7 +522,8 @@ _base_display_event_data(struct MPT2SAS_
> >             desc = "Device Status Change";
> >             break;
> >     case MPI2_EVENT_IR_OPERATION_STATUS:
> > -           desc = "IR Operation Status";
> > +           if (!ioc->hide_ir_msg)
> > +                   desc = "IR Operation Status";
> >             break;
> >     case MPI2_EVENT_SAS_DISCOVERY:
> >     {
> > @@ -553,16 +554,20 @@ _base_display_event_data(struct MPT2SAS_
> >             desc = "SAS Enclosure Device Status Change";
> >             break;
> >     case MPI2_EVENT_IR_VOLUME:
> > -           desc = "IR Volume";
> > +           if (!ioc->hide_ir_msg)
> > +                   desc = "IR Volume";
> >             break;
> >     case MPI2_EVENT_IR_PHYSICAL_DISK:
> > -           desc = "IR Physical Disk";
> > +           if (!ioc->hide_ir_msg)
> > +                   desc = "IR Physical Disk";
> >             break;
> >     case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
> > -           desc = "IR Configuration Change List";
> > +           if (!ioc->hide_ir_msg)
> > +                   desc = "IR Configuration Change List";
> >             break;
> >     case MPI2_EVENT_LOG_ENTRY_ADDED:
> > -           desc = "Log Entry Added";
> > +           if (!ioc->hide_ir_msg)
> > +                   desc = "Log Entry Added";
> >             break;
> >     }
> >
> > @@ -616,7 +621,10 @@ _base_sas_log_info(struct MPT2SAS_ADAPTE
> >             originator_str = "PL";
> >             break;
> >     case 2:
> > -           originator_str = "IR";
> > +           if (!ioc->hide_ir_msg)
> > +                   originator_str = "IR";
> > +           else
> > +                   originator_str = "WarpDrive";
> >             break;
> >     }
> >
> > @@ -1508,6 +1516,7 @@ mpt2sas_base_free_smid(struct MPT2SAS_AD
> >             }
> >             ioc->scsi_lookup[i].cb_idx = 0xFF;
> >             ioc->scsi_lookup[i].scmd = NULL;
> > +           ioc->scsi_lookup[i].direct_io = 0;
> >             list_add_tail(&ioc->scsi_lookup[i].tracker_list,
> >                 &ioc->free_list);
> >             spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> > @@ -1795,10 +1804,12 @@ _base_display_ioc_capabilities(struct MP
> >     printk("), ");
> >     printk("Capabilities=(");
> >
> > -   if (ioc->facts.IOCCapabilities &
> > -       MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID) {
> > -           printk("Raid");
> > -           i++;
> > +   if (!ioc->hide_ir_msg) {
> > +           if (ioc->facts.IOCCapabilities &
> > +               MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID) {
> > +                   printk("Raid");
> > +                   i++;
> > +           }
> >     }
> >
> >     if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR) {
> > @@ -3631,6 +3642,7 @@ _base_make_ioc_operational(struct MPT2SA
> >     u32 reply_address;
> >     u16 smid;
> >     struct _tr_list *delayed_tr, *delayed_tr_next;
> > +   u8 hide_flag;
> >
> >     dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
> >         __func__));
> > @@ -3657,6 +3669,7 @@ _base_make_ioc_operational(struct MPT2SA
> >             ioc->scsi_lookup[i].cb_idx = 0xFF;
> >             ioc->scsi_lookup[i].smid = smid;
> >             ioc->scsi_lookup[i].scmd = NULL;
> > +           ioc->scsi_lookup[i].direct_io = 0;
> >             list_add_tail(&ioc->scsi_lookup[i].tracker_list,
> >                 &ioc->free_list);
> >     }
> > @@ -3717,6 +3730,15 @@ _base_make_ioc_operational(struct MPT2SA
> >     if (sleep_flag == CAN_SLEEP)
> >             _base_static_config_pages(ioc);
> >
> > +   if (ioc->wait_for_port_enable_to_complete && ioc->is_warpdrive) {
> > +           if (ioc->manu_pg10.OEMIdentifier  == 0x80) {
> > +                   hide_flag = (u8) (ioc->manu_pg10.OEMSpecificFlags0 &
> > +                       MFG_PAGE10_HIDE_SSDS_MASK);
> > +                   if (hide_flag != MFG_PAGE10_HIDE_SSDS_MASK)
> > +                           ioc->mfg_pg10_hide_flag = hide_flag;
> > +           }
> > +   }
> > +
> >     if (ioc->wait_for_port_enable_to_complete) {
> >             if (diag_buffer_enable != 0)
> >                     mpt2sas_enable_diag_buffer(ioc, diag_buffer_enable);
> > diff -aurp mpt2sas-phase8.0/mpt2sas_base.h mpt2sas-
> > phase8.0_wd/mpt2sas_base.h
> > --- mpt2sas-phase8.0/mpt2sas_base.h 2011-01-18 11:33:45.711139872
> +0530
> > +++ mpt2sas-phase8.0_wd/mpt2sas_base.h      2011-01-27 20:57:45.016000126
> > +0530
> > @@ -69,11 +69,11 @@
> >  #define MPT2SAS_DRIVER_NAME                "mpt2sas"
> >  #define MPT2SAS_AUTHOR     "LSI Corporation <DL-
> MPTFusionLinux@lsi.com>"
> >  #define MPT2SAS_DESCRIPTION        "LSI MPT Fusion SAS 2.0 Device
> Driver"
> > -#define MPT2SAS_DRIVER_VERSION             "08.100.00.00"
> > +#define MPT2SAS_DRIVER_VERSION             "08.100.00.01"
> >  #define MPT2SAS_MAJOR_VERSION              08
> >  #define MPT2SAS_MINOR_VERSION              100
> >  #define MPT2SAS_BUILD_VERSION              00
> > -#define MPT2SAS_RELEASE_VERSION            00
> > +#define MPT2SAS_RELEASE_VERSION            01
> >
> >  /*
> >   * Set MPT2SAS_SG_DEPTH value based on user input.
> > @@ -169,6 +169,16 @@
> >  #define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
> >
> >  /*
> > + *  WarpDrive Specific Log codes
> > + */
> > +
> > +#define MPT2_WARPDRIVE_LOGENTRY            (0x8002)
> > +#define MPT2_WARPDRIVE_LC_SSDT             (0x41)
> > +#define MPT2_WARPDRIVE_LC_SSDLW            (0x43)
> > +#define MPT2_WARPDRIVE_LC_SSDLF            (0x44)
> > +#define MPT2_WARPDRIVE_LC_BRMF             (0x4D)
> > +
> > +/*
> >   * per target private data
> >   */
> >  #define MPT_TARGET_FLAGS_RAID_COMPONENT    0x01
> > @@ -179,6 +189,7 @@
> >   * struct MPT2SAS_TARGET - starget private hostdata
> >   * @starget: starget object
> >   * @sas_address: target sas address
> > + * @raid_device: raid_device pointer to access volume data
> >   * @handle: device handle
> >   * @num_luns: number luns
> >   * @flags: MPT_TARGET_FLAGS_XXX flags
> > @@ -188,6 +199,7 @@
> >  struct MPT2SAS_TARGET {
> >     struct scsi_target *starget;
> >     u64     sas_address;
> > +   struct _raid_device *raid_device;
> >     u16     handle;
> >     int     num_luns;
> >     u32     flags;
> > @@ -195,6 +207,7 @@ struct MPT2SAS_TARGET {
> >     u8      tm_busy;
> >  };
> >
> > +
> >  /*
> >   * per device private data
> >   */
> > @@ -242,6 +255,12 @@ typedef struct _MPI2_CONFIG_PAGE_MAN_10
> >    MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_10,
> >    Mpi2ManufacturingPage10_t, MPI2_POINTER
> pMpi2ManufacturingPage10_t;
> >
> > +#define MFG_PAGE10_HIDE_SSDS_MASK  (0x00000003)
> > +#define MFG_PAGE10_HIDE_ALL_DISKS  (0x00)
> > +#define MFG_PAGE10_EXPOSE_ALL_DISKS        (0x01)
> > +#define MFG_PAGE10_HIDE_IF_VOL_PRESENT     (0x02)
> > +
> > +
> >  struct MPT2SAS_DEVICE {
> >     struct MPT2SAS_TARGET *sas_target;
> >     unsigned int    lun;
> > @@ -321,6 +340,7 @@ struct _sas_device {
> >   * @sdev: scsi device struct (volumes are single lun)
> >   * @wwid: unique identifier for the volume
> >   * @handle: device handle
> > + * @block_size: Block size of the volume
> >   * @id: target id
> >   * @channel: target channel
> >   * @volume_type: the raid level
> > @@ -328,20 +348,33 @@ struct _sas_device {
> >   * @num_pds: number of hidden raid components
> >   * @responding: used in _scsih_raid_device_mark_responding
> >   * @percent_complete: resync percent complete
> > + * @direct_io_enabled: Whether direct io to PDs are allowed or not
> > + * @stripe_exponent: X where 2powX is the stripe sz in blocks
> > + * @max_lba: Maximum number of LBA in the volume
> > + * @stripe_sz: Stripe Size of the volume
> > + * @device_info: Device info of the volume member disk
> > + * @pd_handle: Array of handles of the physical drives for direct
> I/O
> > in le16
> >   */
> > +#define MPT_MAX_WARPDRIVE_PDS              8
> >  struct _raid_device {
> >     struct list_head list;
> >     struct scsi_target *starget;
> >     struct scsi_device *sdev;
> >     u64     wwid;
> >     u16     handle;
> > +   u16     block_sz;
> >     int     id;
> >     int     channel;
> >     u8      volume_type;
> > -   u32     device_info;
> >     u8      num_pds;
> >     u8      responding;
> >     u8      percent_complete;
> > +   u8      direct_io_enabled;
> > +   u8      stripe_exponent;
> > +   u64     max_lba;
> > +   u32     stripe_sz;
> > +   u32     device_info;
> > +   u16     pd_handle[MPT_MAX_WARPDRIVE_PDS];
> >  };
> >
> >  /**
> > @@ -450,6 +483,7 @@ struct chain_tracker {
> >   * @smid: system message id
> >   * @scmd: scsi request pointer
> >   * @cb_idx: callback index
> > + * @direct_io: To indicate whether I/O is direct (WARPDRIVE)
> >   * @chain_list: list of chains associated to this IO
> >   * @tracker_list: list of free request (ioc->free_list)
> >   */
> > @@ -457,14 +491,14 @@ struct scsiio_tracker {
> >     u16     smid;
> >     struct scsi_cmnd *scmd;
> >     u8      cb_idx;
> > +   u8      direct_io;
> >     struct list_head chain_list;
> >     struct list_head tracker_list;
> >  };
> >
> >  /**
> > - * struct request_tracker - misc mf request tracker
> > + * struct request_tracker - firmware request tracker
> >   * @smid: system message id
> > - * @scmd: scsi request pointer
> >   * @cb_idx: callback index
> >   * @tracker_list: list of free request (ioc->free_list)
> >   */
> > @@ -812,6 +846,11 @@ struct MPT2SAS_ADAPTER {
> >     u32             diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
> >     u32             ring_buffer_offset;
> >     u32             ring_buffer_sz;
> > +   u8              is_warpdrive;
> > +   u8              hide_ir_msg;
> > +   u8              mfg_pg10_hide_flag;
> > +   u8              hide_drives;
> > +
> >  };
> >
> >  typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8
> > msix_index,
> > diff -aurp mpt2sas-phase8.0/mpt2sas_ctl.c mpt2sas-
> > phase8.0_wd/mpt2sas_ctl.c
> > --- mpt2sas-phase8.0/mpt2sas_ctl.c  2011-01-18 11:30:28.453140352
> +0530
> > +++ mpt2sas-phase8.0_wd/mpt2sas_ctl.c       2011-01-27 20:48:35.096000040
> > +0530
> > @@ -1034,7 +1034,10 @@ _ctl_getiocinfo(void __user *arg)
> >         __func__));
> >
> >     memset(&karg, 0 , sizeof(karg));
> > -   karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
> > +   if (ioc->is_warpdrive)
> > +           karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2_SSS6200;
> > +   else
> > +           karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
> >     if (ioc->pfacts)
> >             karg.port_number = ioc->pfacts[0].PortNumber;
> >     pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);
> > diff -aurp mpt2sas-phase8.0/mpt2sas_ctl.h mpt2sas-
> > phase8.0_wd/mpt2sas_ctl.h
> > --- mpt2sas-phase8.0/mpt2sas_ctl.h  2011-01-18 11:30:28.450141059
> +0530
> > +++ mpt2sas-phase8.0_wd/mpt2sas_ctl.h       2011-01-19 12:13:47.568012329
> > +0530
> > @@ -133,6 +133,7 @@ struct mpt2_ioctl_pci_info {
> >  #define MPT2_IOCTL_INTERFACE_FC_IP (0x02)
> >  #define MPT2_IOCTL_INTERFACE_SAS   (0x03)
> >  #define MPT2_IOCTL_INTERFACE_SAS2  (0x04)
> > +#define MPT2_IOCTL_INTERFACE_SAS2_SSS6200  (0x05)
> >  #define MPT2_IOCTL_VERSION_LENGTH  (32)
> >
> >  /**
> > diff -aurp mpt2sas-phase8.0/mpt2sas_scsih.c mpt2sas-
> > phase8.0_wd/mpt2sas_scsih.c
> > --- mpt2sas-phase8.0/mpt2sas_scsih.c        2011-01-18 11:33:43.225202675
> > +0530
> > +++ mpt2sas-phase8.0_wd/mpt2sas_scsih.c     2011-02-03 15:42:45.974149344
> > +0530
> > @@ -233,6 +233,9 @@ static struct pci_device_id scsih_pci_ta
> >             PCI_ANY_ID, PCI_ANY_ID },
> >     { MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2308_3,
> >             PCI_ANY_ID, PCI_ANY_ID },
> > +   /* SSS6200 */
> > +   { MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SSS6200,
> > +           PCI_ANY_ID, PCI_ANY_ID },
> >     {0}     /* Terminating entry */
> >  };
> >  MODULE_DEVICE_TABLE(pci, scsih_pci_table);
> > @@ -1256,6 +1259,7 @@ _scsih_target_alloc(struct scsi_target *
> >                     sas_target_priv_data->handle = raid_device->handle;
> >                     sas_target_priv_data->sas_address = raid_device-
> > >wwid;
> >                     sas_target_priv_data->flags |=
> > MPT_TARGET_FLAGS_VOLUME;
> > +                   sas_target_priv_data->raid_device = raid_device;
> >                     raid_device->starget = starget;
> >             }
> >             spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
> > @@ -1455,7 +1459,10 @@ static int
> >  _scsih_is_raid(struct device *dev)
> >  {
> >     struct scsi_device *sdev = to_scsi_device(dev);
> > +   struct MPT2SAS_ADAPTER *ioc = shost_priv(sdev->host);
> >
> > +   if (ioc->is_warpdrive)
> > +           return 0;
> >     return (sdev->channel == RAID_CHANNEL) ? 1 : 0;
> >  }
> >
> > @@ -1480,7 +1487,7 @@ _scsih_get_resync(struct device *dev)
> >         sdev->channel);
> >     spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
> >
> > -   if (!raid_device)
> > +   if (!raid_device || ioc->is_warpdrive)
> >             goto out;
> >
> >     if (mpt2sas_config_get_raid_volume_pg0(ioc, &mpi_reply, &vol_pg0,
> > @@ -1640,6 +1647,212 @@ _scsih_get_volume_capabilities(struct MP
> >
> >     kfree(vol_pg0);
> >  }
> > +/**
> > + * _scsih_disable_ddio - Disable direct I/O for all the volumes
> > + * @ioc: per adapter object
> > + */
> > +static void
> > +_scsih_disable_ddio(struct MPT2SAS_ADAPTER *ioc)
> > +{
> > +   Mpi2RaidVolPage1_t vol_pg1;
> > +   Mpi2ConfigReply_t mpi_reply;
> > +   struct _raid_device *raid_device;
> > +   u16 handle;
> > +   u16 ioc_status;
> > +
> > +   handle = 0xFFFF;
> > +   while (!(mpt2sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
> > +       &vol_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE,
> > handle))) {
> > +           ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
> > +               MPI2_IOCSTATUS_MASK;
> > +           if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
> > +                   break;
> > +           handle = le16_to_cpu(vol_pg1.DevHandle);
> > +           raid_device = _scsih_raid_device_find_by_handle(ioc,
> > handle);
> > +           if (raid_device)
> > +                   raid_device->direct_io_enabled = 0;
> > +   }
> > +   return;
> > +}
> > +
> > +
> > +/**
> > + * _scsih_get_num_volumes - Get number of volumes in the ioc
> > + * @ioc: per adapter object
> > + */
> > +static u8
> > +_scsih_get_num_volumes(struct MPT2SAS_ADAPTER *ioc)
> > +{
> > +   Mpi2RaidVolPage1_t vol_pg1;
> > +   Mpi2ConfigReply_t mpi_reply;
> > +   u16 handle;
> > +   u8 vol_cnt = 0;
> > +   u16 ioc_status;
> > +
> > +   handle = 0xFFFF;
> > +   while (!(mpt2sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
> > +       &vol_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE,
> > handle))) {
> > +           ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
> > +               MPI2_IOCSTATUS_MASK;
> > +           if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
> > +                   break;
> > +           vol_cnt++;
> > +           handle = le16_to_cpu(vol_pg1.DevHandle);
> > +   }
> > +   return vol_cnt;
> > +}
> > +
> > +
> > +/**
> > + * _scsih_init_warpdrive_properties - Set properties for warpdrive
> > direct I/O.
> > + * @ioc: per adapter object
> > + * @raid_device: the raid_device object
> > + */
> > +static void
> > +_scsih_init_warpdrive_properties(struct MPT2SAS_ADAPTER *ioc,
> > +   struct _raid_device *raid_device)
> > +{
> > +   Mpi2RaidVolPage0_t *vol_pg0;
> > +   Mpi2RaidPhysDiskPage0_t pd_pg0;
> > +   Mpi2ConfigReply_t mpi_reply;
> > +   u16 sz;
> > +   u8 num_pds, count;
> > +   u64 mb = 1024 * 1024;
> > +   u64 tb_2 = 2 * mb * mb;
> > +   u64 capacity;
> > +   u32 stripe_sz;
> > +   u8 i, stripe_exp;
> > +
> > +   if (!ioc->is_warpdrive)
> > +           return;
> > +
> > +   if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS) {
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "globally as drives are exposed\n", ioc->name);
> > +           return;
> > +   }
> > +   if (_scsih_get_num_volumes(ioc) > 1) {
> > +           _scsih_disable_ddio(ioc);
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "globally as number of drives > 1\n", ioc->name);
> > +           return;
> > +   }
> > +   if ((mpt2sas_config_get_number_pds(ioc, raid_device->handle,
> > +       &num_pds)) || !num_pds) {
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "Failure in computing number of drives\n", ioc->name);
> > +           return;
> > +   }
> > +
> > +   sz = offsetof(Mpi2RaidVolPage0_t, PhysDisk) + (num_pds *
> > +       sizeof(Mpi2RaidVol0PhysDisk_t));
> > +   vol_pg0 = kzalloc(sz, GFP_KERNEL);
> > +   if (!vol_pg0) {
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "Memory allocation failure for RVPG0\n", ioc->name);
> > +           return;
> > +   }
> > +
> > +   if ((mpt2sas_config_get_raid_volume_pg0(ioc, &mpi_reply, vol_pg0,
> > +        MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, raid_device->handle,
> > sz))) {
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "Failure in retrieving RVPG0\n", ioc->name);
> > +           kfree(vol_pg0);
> > +           return;
> > +   }
> > +
> > +   /*
> > +    * WARPDRIVE:If number of physical disks in a volume exceeds the
> > max pds
> > +    * assumed for WARPDRIVE, disable direct I/O
> > +    */
> > +   if (num_pds > MPT_MAX_WARPDRIVE_PDS) {
> > +           printk(MPT2SAS_WARN_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "for the drive with handle(0x%04x): num_mem=%d, "
> > +               "max_mem_allowed=%d\n", ioc->name, raid_device->handle,
> > +               num_pds, MPT_MAX_WARPDRIVE_PDS);
> > +           kfree(vol_pg0);
> > +           return;
> > +   }
> > +   for (count = 0; count < num_pds; count++) {
> > +           if (mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
> > +               &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM,
> > +               vol_pg0->PhysDisk[count].PhysDiskNum) ||
> > +               pd_pg0.DevHandle == MPT2SAS_INVALID_DEVICE_HANDLE) {
> > +                   printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is "
> > +                       "disabled for the drive with handle(0x%04x)
> > member"
> > +                       "handle retrieval failed for member number=%d\n",
> > +                       ioc->name, raid_device->handle,
> > +                       vol_pg0->PhysDisk[count].PhysDiskNum);
> > +                   goto out_error;
> > +           }
> > +           raid_device->pd_handle[count] =
> > le16_to_cpu(pd_pg0.DevHandle);
> > +   }
> > +
> > +   /*
> > +    * Assumption for WD: Direct I/O is not supported if the volume
> > is
> > +    * not RAID0, if the stripe size is not 64KB, if the block size
> > is
> > +    * not 512 and if the volume size is >2TB
> > +    */
> > +   if (raid_device->volume_type != MPI2_RAID_VOL_TYPE_RAID0 ||
> > +       le16_to_cpu(vol_pg0->BlockSize) != 512) {
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "for the drive with handle(0x%04x): type=%d, "
> > +               "s_sz=%uK, blk_size=%u\n", ioc->name,
> > +               raid_device->handle, raid_device->volume_type,
> > +               le32_to_cpu(vol_pg0->StripeSize)/2,
> > +               le16_to_cpu(vol_pg0->BlockSize));
> > +           goto out_error;
> > +   }
> > +
> > +   capacity = (u64) le16_to_cpu(vol_pg0->BlockSize) *
> > +       (le64_to_cpu(vol_pg0->MaxLBA) + 1);
> > +
> > +   if (capacity > tb_2) {
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +           "for the drive with handle(0x%04x) since drive sz > 2TB\n",
> > +           ioc->name, raid_device->handle);
> > +           goto out_error;
> > +   }
> > +
> > +   stripe_sz = le32_to_cpu(vol_pg0->StripeSize);
> > +   stripe_exp = 0;
> > +   for (i = 0; i < 32; i++) {
> > +           if (stripe_sz & 1)
> > +                   break;
> > +           stripe_exp++;
> > +           stripe_sz >>= 1;
> > +   }
> > +   if (i == 32) {
> > +           printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled
> > "
> > +               "for the drive with handle(0x%04x) invalid stripe sz
> > %uK\n",
> > +               ioc->name, raid_device->handle,
> > +               le32_to_cpu(vol_pg0->StripeSize)/2);
> > +           goto out_error;
> > +   }
> > +   raid_device->stripe_exponent = stripe_exp;
> > +   raid_device->direct_io_enabled = 1;
> > +
> > +   printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is Enabled for the
> > drive"
> > +       " with handle(0x%04x)\n", ioc->name, raid_device->handle);
> > +   /*
> > +    * WARPDRIVE: Though the following fields are not used for direct
> > IO,
> > +    * stored for future purpose:
> > +    */
> > +   raid_device->max_lba = le64_to_cpu(vol_pg0->MaxLBA);
> > +   raid_device->stripe_sz = le32_to_cpu(vol_pg0->StripeSize);
> > +   raid_device->block_sz = le16_to_cpu(vol_pg0->BlockSize);
> > +
> > +
> > +   kfree(vol_pg0);
> > +   return;
> > +
> > +out_error:
> > +   raid_device->direct_io_enabled = 0;
> > +   for (count = 0; count < num_pds; count++)
> > +           raid_device->pd_handle[count] = 0;
> > +   kfree(vol_pg0);
> > +   return;
> > +}
> >
> >  /**
> >   * _scsih_enable_tlr - setting TLR flags
> > @@ -1710,6 +1923,11 @@ _scsih_slave_configure(struct scsi_devic
> >
> >             _scsih_get_volume_capabilities(ioc, raid_device);
> >
> > +           /*
> > +            * WARPDRIVE: Initialize the required data for Direct IO
> > +            */
> > +           _scsih_init_warpdrive_properties(ioc, raid_device);
> > +
> >             /* RAID Queue Depth Support
> >              * IS volume = underlying qdepth of drive type, either
> >              *    MPT2SAS_SAS_QUEUE_DEPTH or MPT2SAS_SATA_QUEUE_DEPTH
> > @@ -1757,14 +1975,16 @@ _scsih_slave_configure(struct scsi_devic
> >                     break;
> >             }
> >
> > -           sdev_printk(KERN_INFO, sdev, "%s: "
> > -               "handle(0x%04x), wwid(0x%016llx), pd_count(%d),
> > type(%s)\n",
> > -               r_level, raid_device->handle,
> > -               (unsigned long long)raid_device->wwid,
> > -               raid_device->num_pds, ds);
> > +           if (!ioc->hide_ir_msg)
> > +                   sdev_printk(KERN_INFO, sdev, "%s: handle(0x%04x), "
> > +                       "wwid(0x%016llx), pd_count(%d), type(%s)\n",
> > +                       r_level, raid_device->handle,
> > +                       (unsigned long long)raid_device->wwid,
> > +                       raid_device->num_pds, ds);
> >             _scsih_change_queue_depth(sdev, qdepth,
> > SCSI_QDEPTH_DEFAULT);
> >             /* raid transport support */
> > -           _scsih_set_level(sdev, raid_device);
> > +           if (!ioc->is_warpdrive)
> > +                   _scsih_set_level(sdev, raid_device);
> >             return 0;
> >     }
> >
> > @@ -2182,16 +2402,20 @@ _scsih_tm_display_info(struct MPT2SAS_AD
> >     struct MPT2SAS_TARGET *priv_target = starget->hostdata;
> >     struct _sas_device *sas_device = NULL;
> >     unsigned long flags;
> > +   char *device_str = NULL;
> >
> >     if (!priv_target)
> >             return;
> > +   if (ioc->hide_ir_msg)
> > +           device_str = "WarpDrive";
> > +   else
> > +           device_str = "volume";
> >
> >     scsi_print_command(scmd);
> >     if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
> > -           starget_printk(KERN_INFO, starget, "volume handle(0x%04x),
> > "
> > -               "volume wwid(0x%016llx)\n",
> > -               priv_target->handle,
> > -               (unsigned long long)priv_target->sas_address);
> > +           starget_printk(KERN_INFO, starget, "%s handle(0x%04x), "
> > +               "%s wwid(0x%016llx)\n", device_str, priv_target-
> > >handle,
> > +               device_str, (unsigned long long)priv_target-
> > >sas_address);
> >     } else {
> >             spin_lock_irqsave(&ioc->sas_device_lock, flags);
> >             sas_device =
> > mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> > @@ -3130,6 +3354,9 @@ _scsih_check_ir_config_unhide_events(str
> >     a = 0;
> >     b = 0;
> >
> > +   if (ioc->is_warpdrive)
> > +           return;
> > +
> >     /* Volume Resets for Deleted or Removed */
> >     element = (Mpi2EventIrConfigElement_t *)&event_data-
> > >ConfigElement[0];
> >     for (i = 0; i < event_data->NumElements; i++, element++) {
> > @@ -3347,6 +3574,105 @@ _scsih_eedp_error_handling(struct scsi_c
> >  }
> >
> >  /**
> > + * _scsih_scsi_direct_io_get - returns direct io flag
> > + * @ioc: per adapter object
> > + * @smid: system request message index
> > + *
> > + * Returns the smid stored scmd pointer.
> > + */
> > +static inline u8
> > +_scsih_scsi_direct_io_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> > +{
> > +   return ioc->scsi_lookup[smid - 1].direct_io;
> > +}
> > +
> > +/**
> > + * _scsih_scsi_direct_io_set - sets direct io flag
> > + * @ioc: per adapter object
> > + * @smid: system request message index
> > + * @direct_io: Zero or non-zero value to set in the direct_io flag
> > + *
> > + * Returns Nothing.
> > + */
> > +static inline void
> > +_scsih_scsi_direct_io_set(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8
> > direct_io)
> > +{
> > +   ioc->scsi_lookup[smid - 1].direct_io = direct_io;
> > +}
> > +
> > +
> > +/**
> > + * _scsih_setup_direct_io - setup MPI request for WARPDRIVE Direct
> I/O
> > + * @ioc: per adapter object
> > + * @scmd: pointer to scsi command object
> > + * @raid_device: pointer to raid device data structure
> > + * @mpi_request: pointer to the SCSI_IO reqest message frame
> > + * @smid: system request message index
> > + *
> > + * Returns nothing
> > + */
> > +static void
> > +_scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd
> > *scmd,
> > +   struct _raid_device *raid_device, Mpi2SCSIIORequest_t
> > *mpi_request,
> > +   u16 smid)
> > +{
> > +   u32 v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
> > +   u32 stripe_sz, stripe_exp;
> > +   u8 num_pds, *cdb_ptr, *tmp_ptr, *lba_ptr1, *lba_ptr2;
> > +   u8 cdb0 = scmd->cmnd[0];
> > +
> > +   /*
> > +    * Try Direct I/O to RAID memeber disks
> > +    */
> > +   if (cdb0 == READ_16 || cdb0 == READ_10 ||
> > +       cdb0 == WRITE_16 || cdb0 == WRITE_10) {
> > +           cdb_ptr = mpi_request->CDB.CDB32;
> > +
> > +           if ((cdb0 < READ_16) || !(cdb_ptr[2] | cdb_ptr[3] |
> > cdb_ptr[4]
> > +                   | cdb_ptr[5])) {
> > +                   io_size = scsi_bufflen(scmd) >> 9;
> > +                   /* get virtual lba */
> > +                   lba_ptr1 = lba_ptr2 = (cdb0 < READ_16) ? &cdb_ptr[2]
> > :
> > +                       &cdb_ptr[6];
> > +                   tmp_ptr = (u8 *)&v_lba + 3;
> > +                   *tmp_ptr-- = *lba_ptr1++;
> > +                   *tmp_ptr-- = *lba_ptr1++;
> > +                   *tmp_ptr-- = *lba_ptr1++;
> > +                   *tmp_ptr = *lba_ptr1;
> > +
> > +                   if (((u64)v_lba + (u64)io_size - 1) <=
> > +                       (u32)raid_device->max_lba) {
> > +                           stripe_sz = raid_device->stripe_sz;
> > +                           stripe_exp = raid_device->stripe_exponent;
> > +                           stripe_off = v_lba & (stripe_sz - 1);
> > +
> > +                           /* Check whether IO falls within a stripe */
> > +                           if ((stripe_off + io_size) <= stripe_sz) {
> > +                                   num_pds = raid_device->num_pds;
> > +                                   p_lba = v_lba >> stripe_exp;
> > +                                   stripe_unit = p_lba / num_pds;
> > +                                   column = p_lba % num_pds;
> > +                                   p_lba = (stripe_unit << stripe_exp) +
> > +                                       stripe_off;
> > +                                   mpi_request->DevHandle =
> > +                                           cpu_to_le16(raid_device->
> > +                                               pd_handle[column]);
> > +                                   tmp_ptr = (u8 *)&p_lba + 3;
> > +                                   *lba_ptr2++ = *tmp_ptr--;
> > +                                   *lba_ptr2++ = *tmp_ptr--;
> > +                                   *lba_ptr2++ = *tmp_ptr--;
> > +                                   *lba_ptr2 = *tmp_ptr;
> > +                                   /*
> > +                                   * WD: To indicate this I/O is directI/O
> > +                                   */
> > +                                   _scsih_scsi_direct_io_set(ioc, smid, 1);
> > +                           }
> > +                   }
> > +           }
> > +   }
> > +}
> > +
> > +/**
> >   * _scsih_qcmd - main scsi request entry point
> >   * @scmd: pointer to scsi command object
> >   * @done: function pointer to be invoked on completion
> > @@ -3363,6 +3689,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd,
> >     struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
> >     struct MPT2SAS_DEVICE *sas_device_priv_data;
> >     struct MPT2SAS_TARGET *sas_target_priv_data;
> > +   struct _raid_device *raid_device;
> >     Mpi2SCSIIORequest_t *mpi_request;
> >     u32 mpi_control;
> >     u16 smid;
> > @@ -3424,8 +3751,10 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd,
> >
> >     } else
> >             mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
> > -   /* Make sure Device is not raid volume */
> > -   if (!_scsih_is_raid(&scmd->device->sdev_gendev) &&
> > +   /* Make sure Device is not raid volume.
> > +    * We do not expose raid functionality to upper layer for
> > warpdrive.
> > +    */
> > +   if (!ioc->is_warpdrive && _scsih_is_raid(&scmd->device-
> > >sdev_gendev) &&
> >         sas_is_tlr_enabled(scmd->device) && scmd->cmd_len != 32)
> >             mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
> >
> > @@ -3473,9 +3802,14 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd,
> >             }
> >     }
> >
> > +   raid_device = sas_target_priv_data->raid_device;
> > +   if (raid_device && raid_device->direct_io_enabled)
> > +           _scsih_setup_direct_io(ioc, scmd, raid_device, mpi_request,
> > +               smid);
> > +
> >     if (likely(mpi_request->Function ==
> > MPI2_FUNCTION_SCSI_IO_REQUEST))
> >             mpt2sas_base_put_smid_scsi_io(ioc, smid,
> > -               sas_device_priv_data->sas_target->handle);
> > +               le16_to_cpu(mpi_request->DevHandle));
> >     else
> >             mpt2sas_base_put_smid_default(ioc, smid);
> >     return 0;
> > @@ -3540,10 +3874,16 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAP
> >     unsigned long flags;
> >     struct scsi_target *starget = scmd->device->sdev_target;
> >     struct MPT2SAS_TARGET *priv_target = starget->hostdata;
> > +   char *device_str = NULL;
> >
> >     if (!priv_target)
> >             return;
> >
> > +   if (ioc->hide_ir_msg)
> > +           device_str = "WarpDrive";
> > +   else
> > +           device_str = "volume";
> > +
> >     if (log_info == 0x31170000)
> >             return;
> >
> > @@ -3660,8 +4000,8 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAP
> >     scsi_print_command(scmd);
> >
> >     if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
> > -           printk(MPT2SAS_WARN_FMT "\tvolume wwid(0x%016llx)\n", ioc-
> > >name,
> > -               (unsigned long long)priv_target->sas_address);
> > +           printk(MPT2SAS_WARN_FMT "\t%s wwid(0x%016llx)\n", ioc-
> > >name,
> > +               device_str, (unsigned long long)priv_target-
> > >sas_address);
> >     } else {
> >             spin_lock_irqsave(&ioc->sas_device_lock, flags);
> >             sas_device =
> > mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> > @@ -3840,6 +4180,20 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *i
> >             scmd->result = DID_NO_CONNECT << 16;
> >             goto out;
> >     }
> > +   /*
> > +    * WARPDRIVE: If direct_io is set then it is directIO,
> > +    * the failed direct I/O should be redirected to volume
> > +    */
> > +   if (_scsih_scsi_direct_io_get(ioc, smid)) {
> > +           _scsih_scsi_direct_io_set(ioc, smid, 0);
> > +           memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
> > +           mpi_request->DevHandle =
> > +               cpu_to_le16(sas_device_priv_data->sas_target->handle);
> > +           mpt2sas_base_put_smid_scsi_io(ioc, smid,
> > +               sas_device_priv_data->sas_target->handle);
> > +           return 0;
> > +   }
> > +
> >
> >     /* turning off TLR */
> >     scsi_state = mpi_reply->SCSIState;
> > @@ -3848,7 +4202,10 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *i
> >                 le32_to_cpu(mpi_reply->ResponseInfo) & 0xFF;
> >     if (!sas_device_priv_data->tlr_snoop_check) {
> >             sas_device_priv_data->tlr_snoop_check++;
> > -   if (!_scsih_is_raid(&scmd->device->sdev_gendev) &&
> > +   /* Make sure Device is not raid volume.
> > +    * We do not expose raid functionality to upper layer for
> > warpdrive.
> > +    */
> > +   if (!ioc->is_warpdrive && !_scsih_is_raid(&scmd->device-
> > >sdev_gendev) &&
> >             sas_is_tlr_enabled(scmd->device) &&
> >                 response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME) {
> >                     sas_disable_tlr(scmd->device);
> > @@ -4681,8 +5038,10 @@ _scsih_remove_device(struct MPT2SAS_ADAP
> >
> >     _scsih_ublock_io_device(ioc, sas_device_backup.handle);
> >
> > -   mpt2sas_transport_port_remove(ioc, sas_device_backup.sas_address,
> > -       sas_device_backup.sas_address_parent);
> > +   if (!ioc->hide_drives)
> > +           mpt2sas_transport_port_remove(ioc,
> > +               sas_device_backup.sas_address,
> > +               sas_device_backup.sas_address_parent);
> >
> >     printk(MPT2SAS_INFO_FMT "removing handle(0x%04x), sas_addr"
> >         "(0x%016llx)\n", ioc->name, sas_device_backup.handle,
> > @@ -5413,6 +5772,7 @@ _scsih_sas_pd_hide(struct MPT2SAS_ADAPTE
> >         &sas_device->volume_wwid);
> >     set_bit(handle, ioc->pd_handles);
> >     _scsih_reprobe_target(sas_device->starget, 1);
> > +
> >  }
> >
> >  /**
> > @@ -5591,7 +5951,8 @@ _scsih_sas_ir_config_change_event(struct
> >     Mpi2EventDataIrConfigChangeList_t *event_data = fw_event-
> > >event_data;
> >
> >  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> > -   if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> > +   if ((ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> > +       && !ioc->hide_ir_msg)
> >             _scsih_sas_ir_config_change_event_debug(ioc, event_data);
> >
> >  #endif
> > @@ -5614,16 +5975,20 @@ _scsih_sas_ir_config_change_event(struct
> >                                 le16_to_cpu(element->VolDevHandle));
> >                     break;
> >             case MPI2_EVENT_IR_CHANGE_RC_PD_CREATED:
> > -                   _scsih_sas_pd_hide(ioc, element);
> > +                   if (!ioc->is_warpdrive)
> > +                           _scsih_sas_pd_hide(ioc, element);
> >                     break;
> >             case MPI2_EVENT_IR_CHANGE_RC_PD_DELETED:
> > -                   _scsih_sas_pd_expose(ioc, element);
> > +                   if (!ioc->is_warpdrive)
> > +                           _scsih_sas_pd_expose(ioc, element);
> >                     break;
> >             case MPI2_EVENT_IR_CHANGE_RC_HIDE:
> > -                   _scsih_sas_pd_add(ioc, element);
> > +                   if (!ioc->is_warpdrive)
> > +                           _scsih_sas_pd_add(ioc, element);
> >                     break;
> >             case MPI2_EVENT_IR_CHANGE_RC_UNHIDE:
> > -                   _scsih_sas_pd_delete(ioc, element);
> > +                   if (!ioc->is_warpdrive)
> > +                           _scsih_sas_pd_delete(ioc, element);
> >                     break;
> >             }
> >     }
> > @@ -5654,9 +6019,10 @@ _scsih_sas_ir_volume_event(struct MPT2SA
> >
> >     handle = le16_to_cpu(event_data->VolDevHandle);
> >     state = le32_to_cpu(event_data->NewValue);
> > -   dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle(0x%04x), "
> > -       "old(0x%08x), new(0x%08x)\n", ioc->name, __func__,  handle,
> > -       le32_to_cpu(event_data->PreviousValue), state));
> > +   if (!ioc->hide_ir_msg)
> > +           dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s:
> > handle(0x%04x), "
> > +               "old(0x%08x), new(0x%08x)\n", ioc->name, __func__,
> > handle,
> > +               le32_to_cpu(event_data->PreviousValue), state));
> >
> >     switch (state) {
> >     case MPI2_RAID_VOL_STATE_MISSING:
> > @@ -5736,9 +6102,10 @@ _scsih_sas_ir_physical_disk_event(struct
> >     handle = le16_to_cpu(event_data->PhysDiskDevHandle);
> >     state = le32_to_cpu(event_data->NewValue);
> >
> > -   dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle(0x%04x), "
> > -       "old(0x%08x), new(0x%08x)\n", ioc->name, __func__,  handle,
> > -       le32_to_cpu(event_data->PreviousValue), state));
> > +   if (!ioc->hide_ir_msg)
> > +           dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s:
> > handle(0x%04x), "
> > +               "old(0x%08x), new(0x%08x)\n", ioc->name, __func__,
> > handle,
> > +               le32_to_cpu(event_data->PreviousValue), state));
> >
> >     switch (state) {
> >     case MPI2_RAID_PD_STATE_ONLINE:
> > @@ -5747,7 +6114,8 @@ _scsih_sas_ir_physical_disk_event(struct
> >     case MPI2_RAID_PD_STATE_OPTIMAL:
> >     case MPI2_RAID_PD_STATE_HOT_SPARE:
> >
> > -           set_bit(handle, ioc->pd_handles);
> > +           if (!ioc->is_warpdrive)
> > +                   set_bit(handle, ioc->pd_handles);
> >
> >             spin_lock_irqsave(&ioc->sas_device_lock, flags);
> >             sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> > @@ -5851,7 +6219,8 @@ _scsih_sas_ir_operation_status_event(str
> >     u16 handle;
> >
> >  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> > -   if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> > +   if ((ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
> > +       && !ioc->hide_ir_msg)
> >             _scsih_sas_ir_operation_status_event_debug(ioc,
> >                  event_data);
> >  #endif
> > @@ -5910,7 +6279,7 @@ static void
> >  _scsih_mark_responding_sas_device(struct MPT2SAS_ADAPTER *ioc, u64
> > sas_address,
> >      u16 slot, u16 handle)
> >  {
> > -   struct MPT2SAS_TARGET *sas_target_priv_data;
> > +   struct MPT2SAS_TARGET *sas_target_priv_data = NULL;
> >     struct scsi_target *starget;
> >     struct _sas_device *sas_device;
> >     unsigned long flags;
> > @@ -5918,7 +6287,7 @@ _scsih_mark_responding_sas_device(struct
> >     spin_lock_irqsave(&ioc->sas_device_lock, flags);
> >     list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
> >             if (sas_device->sas_address == sas_address &&
> > -               sas_device->slot == slot && sas_device->starget) {
> > +               sas_device->slot == slot) {
> >                     sas_device->responding = 1;
> >                     starget = sas_device->starget;
> >                     if (starget && starget->hostdata) {
> > @@ -5927,13 +6296,15 @@ _scsih_mark_responding_sas_device(struct
> >                             sas_target_priv_data->deleted = 0;
> >                     } else
> >                             sas_target_priv_data = NULL;
> > -                   starget_printk(KERN_INFO, sas_device->starget,
> > -                       "handle(0x%04x), sas_addr(0x%016llx), enclosure "
> > -                       "logical id(0x%016llx), slot(%d)\n", handle,
> > -                       (unsigned long long)sas_device->sas_address,
> > -                       (unsigned long long)
> > -                       sas_device->enclosure_logical_id,
> > -                       sas_device->slot);
> > +                   if (starget)
> > +                           starget_printk(KERN_INFO, starget,
> > +                               "handle(0x%04x), sas_addr(0x%016llx), "
> > +                               "enclosure logical id(0x%016llx), "
> > +                               "slot(%d)\n", handle,
> > +                               (unsigned long long)sas_device-
> > >sas_address,
> > +                               (unsigned long long)
> > +                               sas_device->enclosure_logical_id,
> > +                               sas_device->slot);
> >                     if (sas_device->handle == handle)
> >                             goto out;
> >                     printk(KERN_INFO "\thandle changed
> > from(0x%04x)!!!\n",
> > @@ -6025,6 +6396,12 @@ _scsih_mark_responding_raid_device(struc
> >                     starget_printk(KERN_INFO, raid_device->starget,
> >                         "handle(0x%04x), wwid(0x%016llx)\n", handle,
> >                         (unsigned long long)raid_device->wwid);
> > +                   /*
> > +                    * WARPDRIVE: The handles of the PDs might have
> > changed
> > +                    * across the host reset so re-initialize the
> > +                    * required data for Direct IO
> > +                    */
> > +                   _scsih_init_warpdrive_properties(ioc, raid_device);
> >                     if (raid_device->handle == handle)
> >                             goto out;
> >                     printk(KERN_INFO "\thandle changed
> > from(0x%04x)!!!\n",
> > @@ -6086,18 +6463,20 @@ _scsih_search_responding_raid_devices(st
> >     }
> >
> >     /* refresh the pd_handles */
> > -   phys_disk_num = 0xFF;
> > -   memset(ioc->pd_handles, 0, ioc->pd_handles_sz);
> > -   while (!(mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
> > -       &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_GET_NEXT_PHYSDISKNUM,
> > -       phys_disk_num))) {
> > -           ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
> > -               MPI2_IOCSTATUS_MASK;
> > -           if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
> > -                   break;
> > -           phys_disk_num = pd_pg0.PhysDiskNum;
> > -           handle = le16_to_cpu(pd_pg0.DevHandle);
> > -           set_bit(handle, ioc->pd_handles);
> > +   if (!ioc->is_warpdrive) {
> > +           phys_disk_num = 0xFF;
> > +           memset(ioc->pd_handles, 0, ioc->pd_handles_sz);
> > +           while (!(mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
> > +               &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_GET_NEXT_PHYSDISKNUM,
> > +               phys_disk_num))) {
> > +                   ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
> > +                       MPI2_IOCSTATUS_MASK;
> > +                   if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
> > +                           break;
> > +                   phys_disk_num = pd_pg0.PhysDiskNum;
> > +                   handle = le16_to_cpu(pd_pg0.DevHandle);
> > +                   set_bit(handle, ioc->pd_handles);
> > +           }
> >     }
> >  }
> >
> > @@ -6243,6 +6622,50 @@ _scsih_remove_unresponding_sas_devices(s
> >  }
> >
> >  /**
> > + * _scsih_hide_unhide_sas_devices - add/remove device to/from OS
> > + * @ioc: per adapter object
> > + *
> > + * Return nothing.
> > + */
> > +static void
> > +_scsih_hide_unhide_sas_devices(struct MPT2SAS_ADAPTER *ioc)
> > +{
> > +   struct _sas_device *sas_device, *sas_device_next;
> > +
> > +   if (!ioc->is_warpdrive || ioc->mfg_pg10_hide_flag !=
> > +       MFG_PAGE10_HIDE_IF_VOL_PRESENT)
> > +           return;
> > +
> > +   if (ioc->hide_drives) {
> > +           if (_scsih_get_num_volumes(ioc))
> > +                   return;
> > +           ioc->hide_drives = 0;
> > +           list_for_each_entry_safe(sas_device, sas_device_next,
> > +               &ioc->sas_device_list, list) {
> > +                   if (!mpt2sas_transport_port_add(ioc, sas_device-
> > >handle,
> > +                           sas_device->sas_address_parent)) {
> > +                           _scsih_sas_device_remove(ioc, sas_device);
> > +                   } else if (!sas_device->starget) {
> > +                           mpt2sas_transport_port_remove(ioc,
> > +                               sas_device->sas_address,
> > +                               sas_device->sas_address_parent);
> > +                           _scsih_sas_device_remove(ioc, sas_device);
> > +                   }
> > +           }
> > +   } else {
> > +           if (!_scsih_get_num_volumes(ioc))
> > +                   return;
> > +           ioc->hide_drives = 1;
> > +           list_for_each_entry_safe(sas_device, sas_device_next,
> > +               &ioc->sas_device_list, list) {
> > +                   mpt2sas_transport_port_remove(ioc,
> > +                       sas_device->sas_address,
> > +                       sas_device->sas_address_parent);
> > +           }
> > +   }
> > +}
> > +
> > +/**
> >   * mpt2sas_scsih_reset_handler - reset callback handler (for scsih)
> >   * @ioc: per adapter object
> >   * @reset_phase: phase
> > @@ -6326,6 +6749,7 @@ _firmware_event_work(struct work_struct
> >                     spin_unlock_irqrestore(&ioc-
> > >ioc_reset_in_progress_lock,
> >                         flags);
> >             _scsih_remove_unresponding_sas_devices(ioc);
> > +           _scsih_hide_unhide_sas_devices(ioc);
> >             return;
> >     }
> >
> > @@ -6425,6 +6849,53 @@ mpt2sas_scsih_event_callback(struct MPT2
> >                 (Mpi2EventDataIrVolume_t *)
> >                 mpi_reply->EventData);
> >             break;
> > +   case MPI2_EVENT_LOG_ENTRY_ADDED:
> > +   {
> > +           Mpi2EventDataLogEntryAdded_t *log_entry;
> > +           u32 *log_code;
> > +
> > +           if (!ioc->is_warpdrive)
> > +                   break;
> > +
> > +           log_entry = (Mpi2EventDataLogEntryAdded_t *)
> > +               mpi_reply->EventData;
> > +           log_code = (u32 *)log_entry->LogData;
> > +
> > +           if (le16_to_cpu(log_entry->LogEntryQualifier)
> > +               != MPT2_WARPDRIVE_LOGENTRY)
> > +                   break;
> > +
> > +           switch (le32_to_cpu(*log_code)) {
> > +           case MPT2_WARPDRIVE_LC_SSDT:
> > +                   printk(MPT2SAS_WARN_FMT "WarpDrive Warning: "
> > +                       "IO Throttling has occurred in the WarpDrive "
> > +                       "subsystem. Check WarpDrive documentation for "
> > +                       "additional details.\n", ioc->name);
> > +                   break;
> > +           case MPT2_WARPDRIVE_LC_SSDLW:
> > +                   printk(MPT2SAS_WARN_FMT "WarpDrive Warning: "
> > +                       "Program/Erase Cycles for the WarpDrive subsystem
> > "
> > +                       "in degraded range. Check WarpDrive documentation
> > "
> > +                       "for additional details.\n", ioc->name);
> > +                   break;
> > +           case MPT2_WARPDRIVE_LC_SSDLF:
> > +                   printk(MPT2SAS_ERR_FMT "WarpDrive Fatal Error: "
> > +                       "There are no Program/Erase Cycles for the "
> > +                       "WarpDrive subsystem. The storage device will be
> > "
> > +                       "in read-only mode. Check WarpDrive documentation
> > "
> > +                       "for additional details.\n", ioc->name);
> > +                   break;
> > +           case MPT2_WARPDRIVE_LC_BRMF:
> > +                   printk(MPT2SAS_ERR_FMT "WarpDrive Fatal Error: "
> > +                       "The Backup Rail Monitor has failed on the "
> > +                       "WarpDrive subsystem. Check WarpDrive "
> > +                       "documentation for additional details.\n",
> > +                       ioc->name);
> > +                   break;
> > +           }
> > +
> > +           break;
> > +   }
> >     case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
> >     case MPI2_EVENT_IR_OPERATION_STATUS:
> >     case MPI2_EVENT_SAS_DISCOVERY:
> > @@ -6583,7 +7054,8 @@ _scsih_ir_shutdown(struct MPT2SAS_ADAPTE
> >     mpi_request->Function = MPI2_FUNCTION_RAID_ACTION;
> >     mpi_request->Action = MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED;
> >
> > -   printk(MPT2SAS_INFO_FMT "IR shutdown (sending)\n", ioc->name);
> > +   if (!ioc->hide_ir_msg)
> > +           printk(MPT2SAS_INFO_FMT "IR shutdown (sending)\n", ioc-
> > >name);
> >     init_completion(&ioc->scsih_cmds.done);
> >     mpt2sas_base_put_smid_default(ioc, smid);
> >     wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
> > @@ -6597,10 +7069,11 @@ _scsih_ir_shutdown(struct MPT2SAS_ADAPTE
> >     if (ioc->scsih_cmds.status & MPT2_CMD_REPLY_VALID) {
> >             mpi_reply = ioc->scsih_cmds.reply;
> >
> > -           printk(MPT2SAS_INFO_FMT "IR shutdown (complete): "
> > -               "ioc_status(0x%04x), loginfo(0x%08x)\n",
> > -               ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
> > -               le32_to_cpu(mpi_reply->IOCLogInfo));
> > +           if (!ioc->hide_ir_msg)
> > +                   printk(MPT2SAS_INFO_FMT "IR shutdown (complete): "
> > +                       "ioc_status(0x%04x), loginfo(0x%08x)\n",
> > +                       ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
> > +                       le32_to_cpu(mpi_reply->IOCLogInfo));
> >     }
> >
> >   out:
> > @@ -6759,6 +7232,9 @@ _scsih_probe_boot_devices(struct MPT2SAS
> >             spin_lock_irqsave(&ioc->sas_device_lock, flags);
> >             list_move_tail(&sas_device->list, &ioc->sas_device_list);
> >             spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> > +
> > +           if (ioc->hide_drives)
> > +                   return;
> >             if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
> >                 sas_device->sas_address_parent)) {
> >                     _scsih_sas_device_remove(ioc, sas_device);
> > @@ -6812,6 +7288,9 @@ _scsih_probe_sas(struct MPT2SAS_ADAPTER
> >             list_move_tail(&sas_device->list, &ioc->sas_device_list);
> >             spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> >
> > +           if (ioc->hide_drives)
> > +                   continue;
> > +
> >             if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
> >                 sas_device->sas_address_parent)) {
> >                     _scsih_sas_device_remove(ioc, sas_device);
> > @@ -6882,6 +7361,11 @@ _scsih_probe(struct pci_dev *pdev, const
> >     ioc->id = mpt_ids++;
> >     sprintf(ioc->name, "%s%d", MPT2SAS_DRIVER_NAME, ioc->id);
> >     ioc->pdev = pdev;
> > +   if (id->device == MPI2_MFGPAGE_DEVID_SSS6200) {
> > +           ioc->is_warpdrive = 1;
> > +           ioc->hide_ir_msg = 1;
> > +   } else
> > +           ioc->mfg_pg10_hide_flag = MFG_PAGE10_EXPOSE_ALL_DISKS;
> >     ioc->scsi_io_cb_idx = scsi_io_cb_idx;
> >     ioc->tm_cb_idx = tm_cb_idx;
> >     ioc->ctl_cb_idx = ctl_cb_idx;
> > @@ -6947,6 +7431,20 @@ _scsih_probe(struct pci_dev *pdev, const
> >     }
> >
> >     ioc->wait_for_port_enable_to_complete = 0;
> > +   if (ioc->is_warpdrive) {
> > +           if (ioc->mfg_pg10_hide_flag ==
> > MFG_PAGE10_EXPOSE_ALL_DISKS)
> > +                   ioc->hide_drives = 0;
> > +           else if (ioc->mfg_pg10_hide_flag ==
> > MFG_PAGE10_HIDE_ALL_DISKS)
> > +                   ioc->hide_drives = 1;
> > +           else {
> > +                   if (_scsih_get_num_volumes(ioc))
> > +                           ioc->hide_drives = 1;
> > +                   else
> > +                           ioc->hide_drives = 0;
> > +           }
> > +   } else
> > +           ioc->hide_drives = 0;
> > +
> >     _scsih_probe_devices(ioc);
> >     return 0;
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
