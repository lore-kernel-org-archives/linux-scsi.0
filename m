From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 01/20] [SCSI] mpt3sas: Added Combined Reply Queue feature
 to extend up-to 96 MSIX vector support
Date: Fri, 12 Jun 2015 16:46:40 +0530
Message-ID: <CAK=zhgqDYpNQvUVmjMDxhVrGWBw6zzidewPg3fe1cUSdpRnjqw@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-2-git-send-email-Sreekanth.Reddy@avagotech.com>
	<20150612110915.GB2812@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38831 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbbFLLQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2015 07:16:41 -0400
Received: by wibdq8 with SMTP id dq8so14177440wib.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 04:16:40 -0700 (PDT)
In-Reply-To: <20150612110915.GB2812@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Thanks Johannes, we will take care of this point in our current
on-development mpt2sas/mpt3sas merging activity.


Thanks,
Sreekanth

On Fri, Jun 12, 2015 at 4:39 PM, Johannes Thumshirn <jthumshirn@suse.de=
> wrote:
> On Fri, Jun 12, 2015 at 03:12:13PM +0530, Sreekanth Reddy wrote:
>> In this patch, increased the number of MSIX vector support for SAS3 =
C0 HBAs to up-to 96.
>>
>> Following are changes that are done in this patch
>> 1. Support this feature only for SAS3 C0 cards and also only when re=
ply post free queue count is greater than 8.
>> 2. Instead of using single ReplyPostHostIndex system interface, here=
 12 ReplyPostHostIndex system interfaces are used. reply post free queu=
es numbered from 0 to 7 use the first ReplyPostHostIndex system interfa=
ce to update its corresponding ReplyPostHostIndex values, reply post fr=
ee queues numbered from 8 to 15 will use the second ReplyPostHostIndex =
system interface and so on. These 12 ReplyPostHostIndex system interfac=
es address are saved in the array replyPostRegisterIndex[].
>> 3. Update the ReplyPostHostIndex value of corresponding reply post f=
ree queue in the (its msix_index/8)th entry of replyPostRegisterIndex[]=
 array after processing the reply post descriptor.
>>
>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 70 ++++++++++++++++++++++++++=
+++++++----
>>  drivers/scsi/mpt3sas/mpt3sas_base.h |  7 +++-
>>  2 files changed, 69 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3=
sas/mpt3sas_base.c
>> index 14a781b..c13a365 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -83,7 +83,7 @@ static int msix_disable =3D -1;
>>  module_param(msix_disable, int, 0);
>>  MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (de=
fault=3D0)");
>>
>> -static int max_msix_vectors =3D 8;
>> +static int max_msix_vectors =3D -1;
>>  module_param(max_msix_vectors, int, 0);
>>  MODULE_PARM_DESC(max_msix_vectors,
>>       " max msix vectors - (default=3D8)");
>
> When changing the default value, please also update the description r=
eflecting
> this change.
>
>> @@ -1009,8 +1009,15 @@ _base_interrupt(int irq, void *bus_id)
>>       }
>>
>>       wmb();
>> -     writel(reply_q->reply_post_host_index | (msix_index <<
>> -         MPI2_RPHI_MSIX_INDEX_SHIFT), &ioc->chip->ReplyPostHostInde=
x);
>> +     if (ioc->msix96_vector) {
>> +             writel(reply_q->reply_post_host_index | ((msix_index  =
& 7) <<
>> +                     MPI2_RPHI_MSIX_INDEX_SHIFT),
>> +                             ioc->replyPostRegisterIndex[msix_index=
/8]);
>> +     } else {
>> +             writel(reply_q->reply_post_host_index | (msix_index <<
>> +                     MPI2_RPHI_MSIX_INDEX_SHIFT),
>> +                             &ioc->chip->ReplyPostHostIndex);
>> +     }
>>       atomic_dec(&reply_q->busy);
>>       return IRQ_HANDLED;
>>  }
>> @@ -1560,8 +1567,6 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER=
 *ioc)
>>
>>       pci_read_config_word(ioc->pdev, base + 2, &message_control);
>>       ioc->msix_vector_count =3D (message_control & 0x3FF) + 1;
>> -     if (ioc->msix_vector_count > 8)
>> -             ioc->msix_vector_count =3D 8;
>>       dinitprintk(ioc, pr_info(MPT3SAS_FMT
>>               "msix is supported, vector_count(%d)\n",
>>               ioc->name, ioc->msix_vector_count));
>> @@ -1880,6 +1885,31 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADA=
PTER *ioc)
>>       if (r)
>>               goto out_fail;
>>
>> +     /* Use the Combined reply queue feature only for SAS3 C0 HBAs =
and
>> +      * also only when reply queue count is greater than 8
>> +      */
>> +     if (ioc->msix96_vector && ioc->reply_queue_count > 8) {
>> +             /* If this is an 96 vector supported device,
>> +             set up ReplyPostIndex addresses */
>> +             ioc->replyPostRegisterIndex =3D kcalloc(12,
>> +                     sizeof(resource_size_t *), GFP_KERNEL);
>> +             if (!ioc->replyPostRegisterIndex) {
>> +                     dfailprintk(ioc, printk(MPT3SAS_FMT
>> +                     "allocation for reply Post Register Index fail=
ed!!!\n",
>> +                                                                ioc=
->name));
>> +                     r =3D -ENOMEM;
>> +                     goto out_fail;
>> +             }
>> +
>> +             for (i =3D 0; i < 12; i++) {
>> +                     ioc->replyPostRegisterIndex[i] =3D (resource_s=
ize_t *)
>> +                             ((u8 *)&ioc->chip->Doorbell +
>> +                             MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET=
 +
>> +                             (i * 0x10));
>> +             }
>> +     } else
>> +             ioc->msix96_vector =3D 0;
>> +
>>       list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
>>               pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
>>                   reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X e=
nabled" :
>> @@ -1901,6 +1931,8 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAP=
TER *ioc)
>>       pci_release_selected_regions(ioc->pdev, ioc->bars);
>>       pci_disable_pcie_error_reporting(pdev);
>>       pci_disable_device(pdev);
>> +     if (ioc->msix96_vector)
>> +             kfree(ioc->replyPostRegisterIndex);
>>       return r;
>>  }
>>
>> @@ -4522,8 +4554,16 @@ _base_make_ioc_operational(struct MPT3SAS_ADA=
PTER *ioc, int sleep_flag)
>>
>>       /* initialize reply post host index */
>>       list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
>> -             writel(reply_q->msix_index << MPI2_RPHI_MSIX_INDEX_SHI=
=46T,
>> -                 &ioc->chip->ReplyPostHostIndex);
>> +             if (ioc->msix96_vector) {
>> +                     writel((reply_q->msix_index & 7)<<
>> +                        MPI2_RPHI_MSIX_INDEX_SHIFT,
>> +                        ioc->replyPostRegisterIndex[reply_q->msix_i=
ndex/8]);
>> +             } else {
>> +                     writel(reply_q->msix_index <<
>> +                             MPI2_RPHI_MSIX_INDEX_SHIFT,
>> +                                     &ioc->chip->ReplyPostHostIndex=
);
>> +             }
>> +
>>               if (!_base_is_controller_msix_enabled(ioc))
>>                       goto skip_init_reply_post_host_index;
>>       }
>> @@ -4577,6 +4617,9 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADA=
PTER *ioc)
>>       _base_free_irq(ioc);
>>       _base_disable_msix(ioc);
>>
>> +     if (ioc->msix96_vector)
>> +             kfree(ioc->replyPostRegisterIndex);
>> +
>>       if (ioc->chip_phys && ioc->chip)
>>               iounmap(ioc->chip);
>>       ioc->chip_phys =3D 0;
>> @@ -4600,6 +4643,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *io=
c)
>>  {
>>       int r, i;
>>       int cpu_id, last_cpu_id =3D 0;
>> +     u8 revision;
>>
>>       dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
>>           __func__));
>> @@ -4618,6 +4662,18 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *i=
oc)
>>               r =3D -ENOMEM;
>>               goto out_free_resources;
>>       }
>> +     /* Check whether the controller revision is C0 or above.
>> +         C0 and above revision controllers support 96 vectors */
>> +     revision =3D ioc->pdev->revision;
>> +
>> +     if ((ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3004 ||
>> +          ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3008 ||
>> +          ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_1 ||
>> +          ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_2 ||
>> +          ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_5 ||
>> +          ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_6) &=
&
>> +          (revision >=3D 0x02))
>> +             ioc->msix96_vector =3D 1;
>>
>>       ioc->rdpq_array_enable_assigned =3D 0;
>>       ioc->dma_mask =3D 0;
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3=
sas/mpt3sas_base.h
>> index afa8816..6b8d8f1 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
>> @@ -728,7 +728,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struc=
t MPT3SAS_ADAPTER *ioc);
>>   *                           is assigned only ones
>>   * @reply_queue_count: number of reply queue's
>>   * @reply_queue_list: link list contaning the reply queue info
>> - * @reply_post_host_index: head index in the pool where FW complete=
s IO
>> + * @msix96_vector: 96 MSI-X vector support
>> + * @replyPostRegisterIndex: index of next position in Reply Desc Po=
st Queue
>>   * @delayed_tr_list: target reset link list
>>   * @delayed_tr_volume_list: volume target reset link list
>>   * @@temp_sensors_count: flag to carry the number of temperature se=
nsors
>> @@ -937,6 +938,10 @@ struct MPT3SAS_ADAPTER {
>>       u8              reply_queue_count;
>>       struct list_head reply_queue_list;
>>
>> +     u8              msix96_vector;
>> +     /* reply post register index */
>> +     resource_size_t **replyPostRegisterIndex;
>> +
>
> I know there are many uses of mixed-case varibles in this driver and =
changing
> them when they're already in makes no sense, but maybe you could cons=
ider
> getting rid of them in your mpt2sas/mpt3sas merge, as it is not reall=
y a
> commonly seen pattern in the linux kernel.
>
>>       struct list_head delayed_tr_list;
>>       struct list_head delayed_tr_volume_list;
>>       u8              temp_sensors_count;
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
