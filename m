From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 1/1mpt fusion:C] Code cleanup patch
Date: Thu, 16 Apr 2009 14:44:06 -0700
Message-ID: <da824cf30904161444j40d35efw97af418603204c14@mail.gmail.com>
References: <20090415111007.GA14284@lsi.com>
	 <da824cf30904152351v3895f4bcu945900a41a14f577@mail.gmail.com>
	 <0D1E8821739E724A86F4D16902CE275C1410F4D1C3@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:53977 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZDPVoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 17:44:13 -0400
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id n3GLi94E032504
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 22:44:09 +0100
Received: from wf-out-1314.google.com (wfa28.prod.google.com [10.142.1.28])
	by zps37.corp.google.com with ESMTP id n3GLi7Gv011172
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 14:44:08 -0700
Received: by wf-out-1314.google.com with SMTP id 28so602519wfa.6
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 14:44:07 -0700 (PDT)
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410F4D1C3@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Thu, Apr 16, 2009 at 1:37 AM, Desai, Kashyap <Kashyap.Desai@lsi.com>=
 wrote:
> Grant,
>
> For your comment #1, Print is just extra debug print.
> I am agreeing with your concern. I will revert back that particular p=
rint, since it is duplicate information.
>
> For your comment #2, Black space will be removed in next patch set.

thanks - sounds good (for #1 and 2)

>
> For your comment #3, it is just code readability purpose. I would lik=
e to keep that piece of code, since the new way is more readable. I can=
 revert back that particular piece of code, if it is strongly recommend=
ed.

No - either way is fine coding wise.

I just wanted to know if there was a specific incident.
Generally, unless there is cause, I don't like to touch code.
"I clearly like it better this way" is sufficient "cause" for me.

thanks,
grant
>
>
> Thanks,
> Kashyap
>
>
> -----Original Message-----
> From: Grant Grundler [mailto:grundler@google.com]
> Sent: Thursday, April 16, 2009 12:22 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; James.Bottomley@hansenpartnership.com=
; Moore, Eric; Prakash, Sathya
> Subject: Re: [PATCH 1/1mpt fusion:C] Code cleanup patch
>
> On Wed, Apr 15, 2009 at 4:10 AM, Kashyap, Desai <kashyap.desai@lsi.co=
m> wrote:
>> Main goal to submit this patch is code cleaup.
>> 1. Better driver debug prints and code indentation.
>
> A few silly nits about the new printk's, etc.
>
>
> ...
>> @@ -1596,6 +1600,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 revision;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0r =3D -ENODEV;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pci_dev *pdev;
>> + =C2=A0 =C2=A0 =C2=A0 struct sysinfo s;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0pdev =3D ioc->pcidev;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->bars =3D pci_select_bars(pdev, IORES=
OURCE_MEM);
>> @@ -1647,6 +1652,11 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> + =C2=A0 =C2=A0 =C2=A0 si_meminfo(&s);
>> + =C2=A0 =C2=A0 =C2=A0 printk(MYIOC_s_INFO_FMT "%s BIT PCI BUS DMA A=
DDRESSING SUPPORTED, "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"total memory =3D %ld kB\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->name, ioc->dma_mask =3D=3D =
DMA_64BIT_MASK ? "64" : "32",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0convert_to_kb(s.totalram));
>
> 1) Is printing one line for dma_mask really necessary?
> Maybe consolidate this onto another line of output. Boot output is
> already too verbose.
>
> 2) Isn't the "total Ram" printed elsewhere at boot time?
> =C2=A0Will this get printed once for each MPT Adapter in the system?
>
> Lastly, it's not the total RAM that matters, it depends on *where*
> in the physical address space that RAM is located. I'm sure there
> are better ways to get that than by a device driver printing it.
>
> We have lots of systems with 4G of RAM and some major chunk
> of that is above 4GB addresss. I forget if it's 1GB or 2GB on
> x86 systems. =C2=A0That is to give more MMIO address space to
> PCI devices that want to live below 4GB phys address and
> possibly use by IOMMUs (I don't know that for x86 - it was
> the case for HP IA64 systems).
>
>
>> @@ -1768,7 +1779,7 @@ mpt_attach(struct pci_dev *pdev, const struct =
pci_device_id *id)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->reply_sz =3D MPT_REPLY_FRAME_SIZE;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->pcidev =3D pdev;
>> - =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&ioc->initializing_hba_lock);
>> +
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&ioc->taskmgmt_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_init(&ioc->internal_cmds.mutex);
>
>
> Extra blank line needed? Could probably be dropped.
>
>> @@ -1789,6 +1800,7 @@ mpt_attach(struct pci_dev *pdev, const struct =
pci_device_id *id)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->mfcnt =3D 0;
>> =C2=A0#endif
>>
>> + =C2=A0 =C2=A0 =C2=A0 ioc->sh =3D NULL;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->cached_fw =3D NULL;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Initilize SCSI Config Data structure
>> @@ -1805,9 +1817,8 @@ mpt_attach(struct pci_dev *pdev, const struct =
pci_device_id *id)
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Initialize workqueue */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_DELAYED_WORK(&ioc->fault_reset_work,=
 mpt_fault_reset_work);
>> - =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&ioc->fault_reset_work_lock);
>>
>> - =C2=A0 =C2=A0 =C2=A0 snprintf(ioc->reset_work_q_name, sizeof(ioc->=
reset_work_q_name),
>> + =C2=A0 =C2=A0 =C2=A0 snprintf(ioc->reset_work_q_name, MPT_KOBJ_NAM=
E_LEN,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "mpt_poll_%d=
", ioc->id);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->reset_work_q =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0create_single=
thread_workqueue(ioc->reset_work_q_name);
>> @@ -1882,11 +1893,14 @@ mpt_attach(struct pci_dev *pdev, const struc=
t pci_device_id *id)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1064:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1068:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->errata_f=
lag_1064 =3D 1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->bus_type =3D=
 SAS;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>
> Why not Just let it fall through to the next case?
> Did someone have problems reading that code?
>
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1064E:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1068E:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1078:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->bus_type=
 =3D SAS;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>>
>
> thanks,
> grant
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
