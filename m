From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 1/1mpt fusion:C] Code cleanup patch
Date: Wed, 15 Apr 2009 23:51:32 -0700
Message-ID: <da824cf30904152351v3895f4bcu945900a41a14f577@mail.gmail.com>
References: <20090415111007.GA14284@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:45820 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbZDPGvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 02:51:37 -0400
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id n3G6pYJU001414
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 07:51:34 +0100
Received: from yx-out-1718.google.com (yxn6.prod.google.com [10.190.4.70])
	by spaceape7.eur.corp.google.com with ESMTP id n3G6pWCq027347
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 23:51:33 -0700
Received: by yx-out-1718.google.com with SMTP id 6so197663yxn.34
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 23:51:32 -0700 (PDT)
In-Reply-To: <20090415111007.GA14284@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Wed, Apr 15, 2009 at 4:10 AM, Kashyap, Desai <kashyap.desai@lsi.com>=
 wrote:
> Main goal to submit this patch is code cleaup.
> 1. Better driver debug prints and code indentation.

A few silly nits about the new printk's, etc.


=2E..
> @@ -1596,6 +1600,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 revision;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0r =3D -ENODEV;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pci_dev *pdev;
> + =C2=A0 =C2=A0 =C2=A0 struct sysinfo s;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0pdev =3D ioc->pcidev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->bars =3D pci_select_bars(pdev, IORESO=
URCE_MEM);
> @@ -1647,6 +1652,11 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> + =C2=A0 =C2=A0 =C2=A0 si_meminfo(&s);
> + =C2=A0 =C2=A0 =C2=A0 printk(MYIOC_s_INFO_FMT "%s BIT PCI BUS DMA AD=
DRESSING SUPPORTED, "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"total memory =3D %ld kB\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->name, ioc->dma_mask =3D=3D D=
MA_64BIT_MASK ? "64" : "32",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0convert_to_kb(s.totalram));

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
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->reply_sz =3D MPT_REPLY_FRAME_SIZE;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->pcidev =3D pdev;
> - =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&ioc->initializing_hba_lock);
> +
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&ioc->taskmgmt_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_init(&ioc->internal_cmds.mutex);


Extra blank line needed? Could probably be dropped.

> @@ -1789,6 +1800,7 @@ mpt_attach(struct pci_dev *pdev, const struct p=
ci_device_id *id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->mfcnt =3D 0;
> =C2=A0#endif
>
> + =C2=A0 =C2=A0 =C2=A0 ioc->sh =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->cached_fw =3D NULL;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Initilize SCSI Config Data structure
> @@ -1805,9 +1817,8 @@ mpt_attach(struct pci_dev *pdev, const struct p=
ci_device_id *id)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Initialize workqueue */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_DELAYED_WORK(&ioc->fault_reset_work, =
mpt_fault_reset_work);
> - =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&ioc->fault_reset_work_lock);
>
> - =C2=A0 =C2=A0 =C2=A0 snprintf(ioc->reset_work_q_name, sizeof(ioc->r=
eset_work_q_name),
> + =C2=A0 =C2=A0 =C2=A0 snprintf(ioc->reset_work_q_name, MPT_KOBJ_NAME=
_LEN,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "mpt_poll_%d"=
, ioc->id);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->reset_work_q =3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0create_singlet=
hread_workqueue(ioc->reset_work_q_name);
> @@ -1882,11 +1893,14 @@ mpt_attach(struct pci_dev *pdev, const struct=
 pci_device_id *id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1064:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1068:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->errata_fl=
ag_1064 =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->bus_type =3D =
SAS;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;

Why not Just let it fall through to the next case?
Did someone have problems reading that code?

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1064E:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1068E:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case MPI_MANUFACTPAGE_DEVID_SAS1078:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->bus_type =
=3D SAS;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
>

thanks,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
