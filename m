From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 04/20] [SCSI] mpt3sas: Remove redundancy code while
 freeing the controller resources.
Date: Fri, 12 Jun 2015 17:48:56 +0530
Message-ID: <CAK=zhgoUDDgmC8iDOqCkONNm-u4B3sNWYLRXJNTgXfqWs9nbPw@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-5-git-send-email-Sreekanth.Reddy@avagotech.com>
	<20150612112826.GC2812@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150612112826.GC2812@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 4:58 PM, Johannes Thumshirn <jthumshirn@suse.de=
> wrote:
> On Fri, Jun 12, 2015 at 03:12:16PM +0530, Sreekanth Reddy wrote:
>> Removed the redundancy code while freeing the controller resources.
>>
>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++-----=
-----------
>>  1 file changed, 32 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3=
sas/mpt3sas_base.c
>> index ce57320..32b86bf 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -1798,6 +1798,36 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc=
)
>>  }
>>
>>  /**
>> + * mpt3sas_base_unmap_resources - free controller resources
>> + * @ioc: per adapter object
>> + */
>> +void
>> +mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
>> +{
>> +     struct pci_dev *pdev =3D ioc->pdev;
>> +
>> +     dexitprintk(ioc, printk(MPT3SAS_FMT "%s\n",
>> +             ioc->name, __func__));
>> +
>> +     _base_free_irq(ioc);
>> +     _base_disable_msix(ioc);
>> +
>> +     if (ioc->msix96_vector)
>> +             kfree(ioc->replyPostRegisterIndex);
>
> kfree() already checks for zero or a NULL pointer.

Sorry Johannes, I didn't get you. If I understand this correctly, you
are suggesting to check for NULL pointer before calling kree() API as
shown below,

if (ioc->msix96_vector && (ioc->replyPostRegisterIndex !=3D NULL))
        kfree(ioc->replyPostRegisterIndex);

>
>> +
>> +     if (ioc->chip_phys) {
>> +             iounmap(ioc->chip);
>> +             ioc->chip_phys =3D 0;
>> +     }
>> +
>> +     if (pci_is_enabled(pdev)) {
>> +             pci_release_selected_regions(ioc->pdev, ioc->bars);
>> +             pci_disable_pcie_error_reporting(pdev);
>> +             pci_disable_device(pdev);
>> +     }
>> +}
>> +
>> +/**
>>   * mpt3sas_base_map_resources - map in controller resources (io/irq=
/memap)
>>   * @ioc: per adapter object
>>   *
>> @@ -1925,14 +1955,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADA=
PTER *ioc)
>>       return 0;
>>
>>   out_fail:
>> -     if (ioc->chip_phys)
>> -             iounmap(ioc->chip);
>> -     ioc->chip_phys =3D 0;
>> -     pci_release_selected_regions(ioc->pdev, ioc->bars);
>> -     pci_disable_pcie_error_reporting(pdev);
>> -     pci_disable_device(pdev);
>> -     if (ioc->msix96_vector)
>> -             kfree(ioc->replyPostRegisterIndex);
>> +     mpt3sas_base_unmap_resources(ioc);
>>       return r;
>>  }
>>
>> @@ -4667,8 +4690,6 @@ _base_make_ioc_operational(struct MPT3SAS_ADAP=
TER *ioc, int sleep_flag)
>>  void
>>  mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
>>  {
>> -     struct pci_dev *pdev =3D ioc->pdev;
>> -
>>       dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
>>           __func__));
>>
>> @@ -4679,21 +4700,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_AD=
APTER *ioc)
>>               ioc->shost_recovery =3D 0;
>>       }
>>
>> -     _base_free_irq(ioc);
>> -     _base_disable_msix(ioc);
>> -
>> -     if (ioc->msix96_vector)
>> -             kfree(ioc->replyPostRegisterIndex);
>> -
>> -     if (ioc->chip_phys && ioc->chip)
>> -             iounmap(ioc->chip);
>> -     ioc->chip_phys =3D 0;
>> -
>> -     if (pci_is_enabled(pdev)) {
>> -             pci_release_selected_regions(ioc->pdev, ioc->bars);
>> -             pci_disable_pcie_error_reporting(pdev);
>> -             pci_disable_device(pdev);
>> -     }
>> +     mpt3sas_base_unmap_resources(ioc);
>>       return;
>>  }
>>
>> --
>> 2.0.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Johannes Thumshirn                                       Storage
> jthumshirn@suse.de                             +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)



--=20

Regards,
Sreekanth
