From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/1mpt fusion:C] Code cleanup patch
Date: Thu, 16 Apr 2009 14:07:25 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410F4D1C3@inbmail01.lsi.com>
References: <20090415111007.GA14284@lsi.com>
 <da824cf30904152351v3895f4bcu945900a41a14f577@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:40186 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZDPIix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 04:38:53 -0400
In-Reply-To: <da824cf30904152351v3895f4bcu945900a41a14f577@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Grant,

=46or your comment #1, Print is just extra debug print.
I am agreeing with your concern. I will revert back that particular pri=
nt, since it is duplicate information.

=46or your comment #2, Black space will be removed in next patch set.

=46or your comment #3, it is just code readability purpose. I would lik=
e to keep that piece of code, since the new way is more readable. I can=
 revert back that particular piece of code, if it is strongly recommend=
ed.


Thanks,
Kashyap


-----Original Message-----
=46rom: Grant Grundler [mailto:grundler@google.com]=20
Sent: Thursday, April 16, 2009 12:22 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; James.Bottomley@hansenpartnership.com; =
Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 1/1mpt fusion:C] Code cleanup patch

On Wed, Apr 15, 2009 at 4:10 AM, Kashyap, Desai <kashyap.desai@lsi.com>=
 wrote:
> Main goal to submit this patch is code cleaup.
> 1. Better driver debug prints and code indentation.

A few silly nits about the new printk's, etc.


=2E..
> @@ -1596,6 +1600,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> =A0 =A0 =A0 =A0u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 revision;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0r =3D -ENODEV;
> =A0 =A0 =A0 =A0struct pci_dev *pdev;
> + =A0 =A0 =A0 struct sysinfo s;
>
> =A0 =A0 =A0 =A0pdev =3D ioc->pcidev;
> =A0 =A0 =A0 =A0ioc->bars =3D pci_select_bars(pdev, IORESOURCE_MEM);
> @@ -1647,6 +1652,11 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 si_meminfo(&s);
> + =A0 =A0 =A0 printk(MYIOC_s_INFO_FMT "%s BIT PCI BUS DMA ADDRESSING =
SUPPORTED, "
> + =A0 =A0 =A0 =A0 =A0"total memory =3D %ld kB\n",
> + =A0 =A0 =A0 =A0 =A0ioc->name, ioc->dma_mask =3D=3D DMA_64BIT_MASK ?=
 "64" : "32",
> + =A0 =A0 =A0 =A0 =A0convert_to_kb(s.totalram));

1) Is printing one line for dma_mask really necessary?
Maybe consolidate this onto another line of output. Boot output is
already too verbose.

2) Isn't the "total Ram" printed elsewhere at boot time?
  Will this get printed once for each MPT Adapter in the system?

Lastly, it's not the total RAM that matters, it depends on *where*
in the physical address space that RAM is located. I'm sure there
are better ways to get that than by a device driver printing it.

We have lots of systems with 4G of RAM and some major chunk
of that is above 4GB addresss. I forget if it's 1GB or 2GB on
x86 systems.  That is to give more MMIO address space to
PCI devices that want to live below 4GB phys address and
possibly use by IOMMUs (I don't know that for x86 - it was
the case for HP IA64 systems).


> @@ -1768,7 +1779,7 @@ mpt_attach(struct pci_dev *pdev, const struct p=
ci_device_id *id)
> =A0 =A0 =A0 =A0ioc->reply_sz =3D MPT_REPLY_FRAME_SIZE;
>
> =A0 =A0 =A0 =A0ioc->pcidev =3D pdev;
> - =A0 =A0 =A0 spin_lock_init(&ioc->initializing_hba_lock);
> +
>
> =A0 =A0 =A0 =A0spin_lock_init(&ioc->taskmgmt_lock);
> =A0 =A0 =A0 =A0mutex_init(&ioc->internal_cmds.mutex);


Extra blank line needed? Could probably be dropped.

> @@ -1789,6 +1800,7 @@ mpt_attach(struct pci_dev *pdev, const struct p=
ci_device_id *id)
> =A0 =A0 =A0 =A0ioc->mfcnt =3D 0;
> =A0#endif
>
> + =A0 =A0 =A0 ioc->sh =3D NULL;
> =A0 =A0 =A0 =A0ioc->cached_fw =3D NULL;
>
> =A0 =A0 =A0 =A0/* Initilize SCSI Config Data structure
> @@ -1805,9 +1817,8 @@ mpt_attach(struct pci_dev *pdev, const struct p=
ci_device_id *id)
>
> =A0 =A0 =A0 =A0/* Initialize workqueue */
> =A0 =A0 =A0 =A0INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_re=
set_work);
> - =A0 =A0 =A0 spin_lock_init(&ioc->fault_reset_work_lock);
>
> - =A0 =A0 =A0 snprintf(ioc->reset_work_q_name, sizeof(ioc->reset_work=
_q_name),
> + =A0 =A0 =A0 snprintf(ioc->reset_work_q_name, MPT_KOBJ_NAME_LEN,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "mpt_poll_%d", ioc->id);
> =A0 =A0 =A0 =A0ioc->reset_work_q =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_singlethread_workqueue(ioc->res=
et_work_q_name);
> @@ -1882,11 +1893,14 @@ mpt_attach(struct pci_dev *pdev, const struct=
 pci_device_id *id)
> =A0 =A0 =A0 =A0case MPI_MANUFACTPAGE_DEVID_SAS1064:
> =A0 =A0 =A0 =A0case MPI_MANUFACTPAGE_DEVID_SAS1068:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ioc->errata_flag_1064 =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc->bus_type =3D SAS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;

Why not Just let it fall through to the next case?
Did someone have problems reading that code?

>
> =A0 =A0 =A0 =A0case MPI_MANUFACTPAGE_DEVID_SAS1064E:
> =A0 =A0 =A0 =A0case MPI_MANUFACTPAGE_DEVID_SAS1068E:
> =A0 =A0 =A0 =A0case MPI_MANUFACTPAGE_DEVID_SAS1078:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ioc->bus_type =3D SAS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0}
>
>

thanks,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
