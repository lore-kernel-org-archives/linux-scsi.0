From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v2 09/13] mpt3sas: scan and add nvme device after
 controller reset
Date: Thu, 3 Aug 2017 15:49:00 +0530
Message-ID: <CAK=zhgrBK185dKN0eyhy2R3aKtNN6x=H4Qb5U__fyJ6kgBE6+w@mail.gmail.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1500038560-11231-10-git-send-email-suganath-prabu.subramani@broadcom.com> <641b252a-8330-268b-9008-09b81dd07129@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <641b252a-8330-268b-9008-09b81dd07129@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 3, 2017 at 12:10 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 07/14/2017 03:22 PM, Suganath Prabu S wrote:
>> After Controller reset, Scan and add nvme device back to the topology.
>>
>> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
>> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  194 +++++++++++++++++++++++++++=
++++++-
>>  1 files changed, 190 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas=
/mpt3sas_scsih.c
>> index c5a131f..e3e803c 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -4869,6 +4869,7 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, =
struct scsi_cmnd *scmd,
>>       char *desc_scsi_state =3D ioc->tmp_string;
>>       u32 log_info =3D le32_to_cpu(mpi_reply->IOCLogInfo);
>>       struct _sas_device *sas_device =3D NULL;
>> +     struct _pcie_device *pcie_device =3D NULL;
>>       struct scsi_target *starget =3D scmd->device->sdev_target;
>>       struct MPT3SAS_TARGET *priv_target =3D starget->hostdata;
>>       char *device_str =3D NULL;
>> @@ -5001,6 +5002,28 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc,=
 struct scsi_cmnd *scmd,
>>       if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
>>               pr_warn(MPT3SAS_FMT "\t%s wwid(0x%016llx)\n", ioc->name,
>>                   device_str, (unsigned long long)priv_target->sas_addre=
ss);
>> +     } else if (priv_target->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
>> +             pcie_device =3D mpt3sas_get_pdev_from_target(ioc, priv_tar=
get);
>> +             if (pcie_device) {
>> +                     pr_info(MPT3SAS_FMT "\twwid(0x%016llx), port(%d)\n=
",
>> +                         ioc->name,
>> +                         (unsigned long long)pcie_device->wwid,
>> +                         pcie_device->port_num);
>> +                     if (pcie_device->enclosure_handle !=3D 0)
>> +                             pr_info(MPT3SAS_FMT
>> +                                 "\tenclosure logical id(0x%016llx), "
>> +                                 "slot(%d)\n", ioc->name,
>> +                                 (unsigned long long)
>> +                                 pcie_device->enclosure_logical_id,
>> +                                 pcie_device->slot);
>> +                     if (pcie_device->connector_name[0])
>> +                             pr_info(MPT3SAS_FMT
>> +                                 "\tenclosure level(0x%04x),"
>> +                                 "connector name( %s)\n",
>> +                                 ioc->name, pcie_device->enclosure_leve=
l,
>> +                                 pcie_device->connector_name);
>> +                     pcie_device_put(pcie_device);
>> +             }
>>       } else {
>>               sas_device =3D mpt3sas_get_sdev_from_target(ioc, priv_targ=
et);
>>               if (sas_device) {
>> @@ -5047,11 +5070,10 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc=
, struct scsi_cmnd *scmd,
>>               struct sense_info data;
>>               _scsih_normalize_sense(scmd->sense_buffer, &data);
>>               pr_warn(MPT3SAS_FMT
>> -                     "\t[sense_key,asc,ascq]: [0x%02x,0x%02x,0x%02x], c=
ount(%d)\n",
>> -                     ioc->name, data.skey,
>> -                 data.asc, data.ascq, le32_to_cpu(mpi_reply->SenseCount=
));
>> +               "\t[sense_key,asc,ascq]: [0x%02x,0x%02x,0x%02x], count(%=
d)\n",
>> +               ioc->name, data.skey,
>> +               data.asc, data.ascq, le32_to_cpu(mpi_reply->SenseCount))=
;
>>       }
>> -
>>       if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) {
>>               response_info =3D le32_to_cpu(mpi_reply->ResponseInfo);
>>               response_bytes =3D (u8 *)&response_info;
>> @@ -8512,6 +8534,130 @@ _scsih_search_responding_sas_devices(struct MPT3=
SAS_ADAPTER *ioc)
>>  }
>>
>>  /**
>> + * _scsih_mark_responding_pcie_device - mark a pcie_device as respondin=
g
>> + * @ioc: per adapter object
>> + * @pcie_device_pg0: PCIe Device page 0
>> + *
>> + * After host reset, find out whether devices are still responding.
>> + * Used in _scsih_remove_unresponding_devices.
>> + *
>> + * Return nothing.
>> + */
>> +static void
>> +_scsih_mark_responding_pcie_device(struct MPT3SAS_ADAPTER *ioc,
>> +     Mpi26PCIeDevicePage0_t *pcie_device_pg0)
>> +{
>> +     struct MPT3SAS_TARGET *sas_target_priv_data =3D NULL;
>> +     struct scsi_target *starget;
>> +     struct _pcie_device *pcie_device;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&ioc->pcie_device_lock, flags);
>> +     list_for_each_entry(pcie_device, &ioc->pcie_device_list, list) {
>> +             if ((pcie_device->wwid =3D=3D pcie_device_pg0->WWID) &&
>> +                 (pcie_device->slot =3D=3D pcie_device_pg0->Slot)) {
>> +                     pcie_device->responding =3D 1;
>> +                     starget =3D pcie_device->starget;
>> +                     if (starget && starget->hostdata) {
>> +                             sas_target_priv_data =3D starget->hostdata=
;
>> +                             sas_target_priv_data->tm_busy =3D 0;
>> +                             sas_target_priv_data->deleted =3D 0;
>> +                     } else
>> +                             sas_target_priv_data =3D NULL;
>> +                     if (starget) {
>> +                             starget_printk(KERN_INFO, starget,
>> +                                 "handle(0x%04x), wwid(0x%016llx) ",
>> +                                 pcie_device->handle,
>> +                                 (unsigned long long)pcie_device->wwid)=
;
>> +                             if (pcie_device->enclosure_handle !=3D 0)
>> +                                     starget_printk(KERN_INFO, starget,
>> +                                         "enclosure logical id(0x%016ll=
x), "
>> +                                         "slot(%d)\n",
>> +                                         (unsigned long long)
>> +                                         pcie_device->enclosure_logical=
_id,
>> +                                         pcie_device->slot);
>> +                     }
>> +
>> +                     if (((le32_to_cpu(pcie_device_pg0->Flags)) &
>> +                         MPI26_PCIEDEV0_FLAGS_ENCL_LEVEL_VALID) &&
>> +                         (ioc->hba_mpi_version_belonged !=3D MPI2_VERSI=
ON)) {
>> +                             pcie_device->enclosure_level =3D
>> +                                 pcie_device_pg0->EnclosureLevel;
>> +                             memcpy(&pcie_device->connector_name[0],
>> +                                 &pcie_device_pg0->ConnectorName[0], 4)=
;
>> +                     } else {
>> +                             pcie_device->enclosure_level =3D 0;
>> +                             pcie_device->connector_name[0] =3D '\0';
>> +                     }
>> +
>> +                     if (pcie_device->handle =3D=3D pcie_device_pg0->De=
vHandle)
>> +                             goto out;
>> +                     pr_info(KERN_INFO "\thandle changed from(0x%04x)!!=
!\n",
>> +                         pcie_device->handle);
>> +                     pcie_device->handle =3D pcie_device_pg0->DevHandle=
;
>> +                     if (sas_target_priv_data)
>> +                             sas_target_priv_data->handle =3D
>> +                                 pcie_device_pg0->DevHandle;
>> +                     goto out;
>> +             }
>> +     }
>> +
>> + out:
>> +     spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
>> +}
>> +
>> +/**
>> + * _scsih_search_responding_pcie_devices -
>> + * @ioc: per adapter object
>> + *
>> + * After host reset, find out whether devices are still responding.
>> + * If not remove.
>> + *
>> + * Return nothing.
>> + */
>> +static void
>> +_scsih_search_responding_pcie_devices(struct MPT3SAS_ADAPTER *ioc)
>> +{
>> +     Mpi26PCIeDevicePage0_t pcie_device_pg0;
>> +     Mpi2ConfigReply_t mpi_reply;
>> +     u16 ioc_status;
>> +     u16 handle;
>> +     u32 device_info;
>> +
>> +     pr_info(MPT3SAS_FMT "search for end-devices: start\n", ioc->name);
>> +
>> +     if (list_empty(&ioc->pcie_device_list))
>> +             goto out;
>> +
>> +     handle =3D 0xFFFF;
>> +     while (!(mpt3sas_config_get_pcie_device_pg0(ioc, &mpi_reply,
>> +             &pcie_device_pg0, MPI26_PCIE_DEVICE_PGAD_FORM_GET_NEXT_HAN=
DLE,
>> +             handle))) {
>> +             ioc_status =3D le16_to_cpu(mpi_reply.IOCStatus) &
>> +                 MPI2_IOCSTATUS_MASK;
>> +             if (ioc_status !=3D MPI2_IOCSTATUS_SUCCESS) {
>> +                     pr_info(MPT3SAS_FMT "\tbreak from %s: "
>> +                         "ioc_status(0x%04x), loginfo(0x%08x)\n", ioc->=
name,
>> +                         __func__, ioc_status,
>> +                         le32_to_cpu(mpi_reply.IOCLogInfo));
>> +                     break;
>> +             }
>> +             handle =3D le16_to_cpu(pcie_device_pg0.DevHandle);
>> +             device_info =3D le32_to_cpu(pcie_device_pg0.DeviceInfo);
>> +             if (!(_scsih_is_nvme_device(device_info)))
>> +                     continue;
>> +             pcie_device_pg0.WWID =3D le64_to_cpu(pcie_device_pg0.WWID)=
,
>> +             pcie_device_pg0.Slot =3D le16_to_cpu(pcie_device_pg0.Slot)=
;
>> +             pcie_device_pg0.Flags =3D le32_to_cpu(pcie_device_pg0.Flag=
s);
>> +             pcie_device_pg0.DevHandle =3D handle;
>> +             _scsih_mark_responding_pcie_device(ioc, &pcie_device_pg0);
>> +     }
>> +out:
>> +     pr_info(MPT3SAS_FMT "search for PCIe end-devices: complete\n",
>> +         ioc->name);
>> +}
>> +
>> +/**
>>   * _scsih_mark_responding_raid_device - mark a raid_device as respondin=
g
>>   * @ioc: per adapter object
>>   * @wwid: world wide identifier for raid volume
>> @@ -8863,6 +9009,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS=
_ADAPTER *ioc)
>>  {
>>       Mpi2ExpanderPage0_t expander_pg0;
>>       Mpi2SasDevicePage0_t sas_device_pg0;
>> +     Mpi26PCIeDevicePage0_t pcie_device_pg0;
>>       Mpi2RaidVolPage1_t volume_pg1;
>>       Mpi2RaidVolPage0_t volume_pg0;
>>       Mpi2RaidPhysDiskPage0_t pd_pg0;
>> @@ -8873,6 +9020,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS=
_ADAPTER *ioc)
>>       u16 handle, parent_handle;
>>       u64 sas_address;
>>       struct _sas_device *sas_device;
>> +     struct _pcie_device *pcie_device;
>>       struct _sas_node *expander_device;
>>       static struct _raid_device *raid_device;
>>       u8 retry_count;
>> @@ -9098,7 +9246,44 @@ _scsih_scan_for_devices_after_reset(struct MPT3SA=
S_ADAPTER *ioc)
>>       }
>>       pr_info(MPT3SAS_FMT "\tscan devices: end devices complete\n",
>>           ioc->name);
>> +     pr_info(MPT3SAS_FMT "\tscan devices: pcie end devices start\n",
>> +         ioc->name);
>>
>> +     /* pcie devices */
>> +     handle =3D 0xFFFF;
>> +     while (!(mpt3sas_config_get_pcie_device_pg0(ioc, &mpi_reply,
>> +             &pcie_device_pg0, MPI26_PCIE_DEVICE_PGAD_FORM_GET_NEXT_HAN=
DLE,
>> +             handle))) {
>> +             ioc_status =3D le16_to_cpu(mpi_reply.IOCStatus)
>> +                             & MPI2_IOCSTATUS_MASK;
>> +             if (ioc_status !=3D MPI2_IOCSTATUS_SUCCESS) {
>> +                     pr_info(MPT3SAS_FMT "\tbreak from pcie end device"
>> +                             " scan: ioc_status(0x%04x), loginfo(0x%08x=
)\n",
>> +                             ioc->name, ioc_status,
>> +                             le32_to_cpu(mpi_reply.IOCLogInfo));
>> +                     break;
>> +             }
>> +             handle =3D le16_to_cpu(pcie_device_pg0.DevHandle);
>> +             if (!(_scsih_is_nvme_device(
>> +                     le32_to_cpu(pcie_device_pg0.DeviceInfo))))
>> +                     continue;
>> +             pcie_device =3D mpt3sas_get_pdev_by_wwid(ioc,
>> +                             le64_to_cpu(pcie_device_pg0.WWID));
>> +             if (pcie_device) {
>> +                     pcie_device_put(pcie_device);
>> +                     continue;
>> +             }
>> +             retry_count =3D 0;
>> +             parent_handle =3D le16_to_cpu(pcie_device_pg0.ParentDevHan=
dle);
>> +             _scsih_pcie_add_device(ioc, handle);
>> +
>> +             pr_info(MPT3SAS_FMT "\tAFTER adding pcie end device: "
>> +                     "handle (0x%04x), wwid(0x%016llx)\n", ioc->name,
>> +                     handle,
>> +                     (unsigned long long) le64_to_cpu(pcie_device_pg0.W=
WID));
>> +     }
>> +     pr_info(MPT3SAS_FMT "\tpcie devices: pcie end devices complete\n",
>> +             ioc->name);
>>       pr_info(MPT3SAS_FMT "scan devices: complete\n", ioc->name);
>>  }
>>  /**
>> @@ -9148,6 +9333,7 @@ mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER=
 *ioc, int reset_phase)
>>                   !ioc->sas_hba.num_phys)) {
>>                       _scsih_prep_device_scan(ioc);
>>                       _scsih_search_responding_sas_devices(ioc);
>> +                     _scsih_search_responding_pcie_devices(ioc);
>>                       _scsih_search_responding_raid_devices(ioc);
>>                       _scsih_search_responding_expanders(ioc);
>>                       _scsih_error_recovery_delete_devices(ioc);
>>
> Again; when using 'scan_start()/scan_finished()' callbacks this will
> probably look a bit differently...

During controller reset, mpt3sas driver won't call scsi_scan_host()
API. Our driver internally determines whether drives (which are
attached to the HBA before HBA reset) are still responding or not. If
the drives are not responding (e.g. if someone pulls out the drive
during HBA reset) then it will un-register the UN-responding drive
from the SML after the HBA reset operation.

Thanks,
Sreekanth

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
