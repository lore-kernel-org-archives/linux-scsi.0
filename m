From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v2 08/13] mpt3sas: Set NVMe device queue depth as 128
Date: Thu, 3 Aug 2017 15:22:42 +0530
Message-ID: <CAK=zhgqi=EagQca3KFDeBLk3YocYaRfpSeSH2zuGpBm6_VpfWg@mail.gmail.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1500038560-11231-9-git-send-email-suganath-prabu.subramani@broadcom.com> <cde9c298-0dfc-5d23-a81b-31d50d599524@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36978 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdHCJwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2017 05:52:43 -0400
Received: by mail-pg0-f50.google.com with SMTP id y129so4339128pgy.4
        for <linux-scsi@vger.kernel.org>; Thu, 03 Aug 2017 02:52:43 -0700 (PDT)
In-Reply-To: <cde9c298-0dfc-5d23-a81b-31d50d599524@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-nvme@lists.infradead.org

On Thu, Aug 3, 2017 at 12:09 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 07/14/2017 03:22 PM, Suganath Prabu S wrote:
>> Sets nvme device queue depth, name and displays device capabilities
>>
>> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
>> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.h  |    2 +-
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |   40 +++++++++++++++++++++++++++=
+++++++
>>  2 files changed, 41 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/=
mpt3sas_base.h
>> index 0a8187e..b7855c8 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
>> @@ -115,7 +115,7 @@
>>
>>  #define MPT3SAS_RAID_MAX_SECTORS     8192
>>  #define MPT3SAS_HOST_PAGE_SIZE_4K    12
>> -
>> +#define MPT3SAS_NVME_QUEUE_DEPTH     128
>>  #define MPT_NAME_LENGTH                      32      /* generic length =
of strings */
>>  #define MPT_STRING_LENGTH            64
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas=
/mpt3sas_scsih.c
>> index 1dd9674..c5a131f 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -2290,6 +2290,7 @@ scsih_slave_configure(struct scsi_device *sdev)
>>       struct MPT3SAS_DEVICE *sas_device_priv_data;
>>       struct MPT3SAS_TARGET *sas_target_priv_data;
>>       struct _sas_device *sas_device;
>> +     struct _pcie_device *pcie_device;
>>       struct _raid_device *raid_device;
>>       unsigned long flags;
>>       int qdepth;
>> @@ -2420,6 +2421,45 @@ scsih_slave_configure(struct scsi_device *sdev)
>>               }
>>       }
>>
>> +     /* PCIe handling */
>> +     if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
>> +             spin_lock_irqsave(&ioc->pcie_device_lock, flags);
>> +             pcie_device =3D __mpt3sas_get_pdev_by_wwid(ioc,
>> +                             sas_device_priv_data->sas_target->sas_addr=
ess);
>> +             if (!pcie_device) {
>> +                     spin_unlock_irqrestore(&ioc->pcie_device_lock, fla=
gs);
>> +                     dfailprintk(ioc, pr_warn(MPT3SAS_FMT
>> +                             "failure at %s:%d/%s()!\n", ioc->name, __F=
ILE__,
>> +                             __LINE__, __func__));
>> +                     return 1;
>> +             }
>> +
>> +             /*TODO-right Queue Depth?*/
>> +             qdepth =3D MPT3SAS_NVME_QUEUE_DEPTH;
>> +             ds =3D "NVMe";
>> +             /*TODO-Add device name when defined*/
>> +             sdev_printk(KERN_INFO, sdev,
>> +                     "%s: handle(0x%04x), wwid(0x%016llx), port(%d)\n",
>> +                     ds, handle, (unsigned long long)pcie_device->wwid,
>> +                     pcie_device->port_num);
>> +             if (pcie_device->enclosure_handle !=3D 0)
>> +                     sdev_printk(KERN_INFO, sdev,
>> +                     "%s: enclosure logical id(0x%016llx), slot(%d)\n",
>> +                     ds,
>> +                     (unsigned long long)pcie_device->enclosure_logical=
_id,
>> +                     pcie_device->slot);
>> +             if (pcie_device->connector_name[0] !=3D '\0')
>> +                     sdev_printk(KERN_INFO, sdev,
>> +                             "%s: enclosure level(0x%04x),"
>> +                             "connector name( %s)\n", ds,
>> +                             pcie_device->enclosure_level,
>> +                             pcie_device->connector_name);
>> +             pcie_device_put(pcie_device);
>> +             spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
>> +             scsih_change_queue_depth(sdev, qdepth);
>> +             return 0;
>> +     }
>> +
>>       spin_lock_irqsave(&ioc->sas_device_lock, flags);
>>       sas_device =3D __mpt3sas_get_sdev_by_addr(ioc,
>>          sas_device_priv_data->sas_target->sas_address);
>>
> Well; what are these TODOs doing here?
> If you know things are not correct, why not doing them correctly?
> If you cannot do them correctly, why?

Hannes,

These TODOs comments are added during initial development phase. We
will remove these TODO comments.

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
