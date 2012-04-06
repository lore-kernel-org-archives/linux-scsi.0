From: Alex Shi <lkml.alex@gmail.com>
Subject: Re: [PATCH] scsi/mpt2sas: fix unsafe preempt setting for ioc
Date: Fri, 6 Apr 2012 19:54:38 +0800
Message-ID: <CAGjg+kHjUcYEnszBE4RdbeU52Nao0jJa56JXk180aONMbn-JBA@mail.gmail.com>
References: <1332742810-5116-1-git-send-email-alex.shi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55663 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2DFLyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 07:54:39 -0400
In-Reply-To: <1332742810-5116-1-git-send-email-alex.shi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Shi <alex.shi@intel.com>
Cc: JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Without the following patch, the driver will have many complain after
smp_processor_id debug enabled.

So would you like consider to pick this patch or find a better way to
remove them?

Call Trace:^M
 [<ffffffff81325f77>] debug_smp_processor_id+0xe7/0x100^M
 [<ffffffffa0016324>] mpt2sas_base_put_smid_default+0x34/0x70 [mpt2sas]=
^M
 [<ffffffffa0016472>] _base_event_notification+0x112/0x240 [mpt2sas]^M
 [<ffffffffa0016a11>] _base_make_ioc_operational+0x471/0x1240 [mpt2sas]=
^M
 [<ffffffff810b9963>] ? lockdep_init_map+0xa3/0x560^M
 [<ffffffff810be4fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0^M
 [<ffffffff810b8588>] ? debug_mutex_init+0x38/0x50^M
 [<ffffffffa00193c7>] mpt2sas_base_attach+0x1237/0x1630 [mpt2sas]^M
 [<ffffffffa001ecf8>] _scsih_probe+0x408/0x620 [mpt2sas]^M
 [<ffffffff8133c64c>] local_pci_probe+0x5c/0xd0^M
 [<ffffffff8133df41>] pci_device_probe+0x101/0x120^M
 [<ffffffff814190dc>] driver_probe_device+0x9c/0x300^M
 [<ffffffff814193eb>] __driver_attach+0xab/0xb0^M
 [<ffffffff81419340>] ? driver_probe_device+0x300/0x300^M
 [<ffffffff8141747e>] bus_for_each_dev+0x5e/0x90^M
 [<ffffffff81418cee>] driver_attach+0x1e/0x20^M
 [<ffffffff814188e0>] bus_add_driver+0x1c0/0x2b0^M

On Mon, Mar 26, 2012 at 2:20 PM, Alex Shi <alex.shi@intel.com> wrote:
> commit 911ae943 add a new function:
> +_base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =A0 =A0 =A0 return ioc->cpu_msix_table[smp_processor_id()];
> +}
> Here smp_processor_id() need be used in preempt safe condition. but
> caller did not give this assurance. So fix this in caller.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
> =A0drivers/scsi/mpt2sas/mpt2sas_base.c | =A0 =A06 ++++++
> =A01 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2s=
as/mpt2sas_base.c
> index a78036f..55a368e 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1803,6 +1803,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_AD=
APTER *ioc, u16 smid, u16 handle)
> =A0 =A0 =A0 =A0u64 *request =3D (u64 *)&descriptor;
>
>
> + =A0 =A0 =A0 preempt_disable();
> =A0 =A0 =A0 =A0descriptor.SCSIIO.RequestFlags =3D MPI2_REQ_DESCRIPT_F=
LAGS_SCSI_IO;
> =A0 =A0 =A0 =A0descriptor.SCSIIO.MSIxIndex =3D =A0_base_get_msix_inde=
x(ioc);
> =A0 =A0 =A0 =A0descriptor.SCSIIO.SMID =3D cpu_to_le16(smid);
> @@ -1810,6 +1811,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_AD=
APTER *ioc, u16 smid, u16 handle)
> =A0 =A0 =A0 =A0descriptor.SCSIIO.LMID =3D 0;
> =A0 =A0 =A0 =A0_base_writeq(*request, &ioc->chip->RequestDescriptorPo=
stLow,
> =A0 =A0 =A0 =A0 =A0 =A0&ioc->scsi_lookup_lock);
> + =A0 =A0 =A0 preempt_enable();
> =A0}
>
>
> @@ -1849,6 +1851,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_AD=
APTER *ioc, u16 smid)
> =A0 =A0 =A0 =A0Mpi2RequestDescriptorUnion_t descriptor;
> =A0 =A0 =A0 =A0u64 *request =3D (u64 *)&descriptor;
>
> + =A0 =A0 =A0 preempt_disable();
> =A0 =A0 =A0 =A0descriptor.Default.RequestFlags =3D MPI2_REQ_DESCRIPT_=
=46LAGS_DEFAULT_TYPE;
> =A0 =A0 =A0 =A0descriptor.Default.MSIxIndex =3D =A0_base_get_msix_ind=
ex(ioc);
> =A0 =A0 =A0 =A0descriptor.Default.SMID =3D cpu_to_le16(smid);
> @@ -1856,6 +1859,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_AD=
APTER *ioc, u16 smid)
> =A0 =A0 =A0 =A0descriptor.Default.DescriptorTypeDependent =3D 0;
> =A0 =A0 =A0 =A0_base_writeq(*request, &ioc->chip->RequestDescriptorPo=
stLow,
> =A0 =A0 =A0 =A0 =A0 =A0&ioc->scsi_lookup_lock);
> + =A0 =A0 =A0 preempt_enable();
> =A0}
>
> =A0/**
> @@ -1873,6 +1877,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2=
SAS_ADAPTER *ioc, u16 smid,
> =A0 =A0 =A0 =A0Mpi2RequestDescriptorUnion_t descriptor;
> =A0 =A0 =A0 =A0u64 *request =3D (u64 *)&descriptor;
>
> + =A0 =A0 =A0 preempt_disable();
> =A0 =A0 =A0 =A0descriptor.SCSITarget.RequestFlags =3D
> =A0 =A0 =A0 =A0 =A0 =A0MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET;
> =A0 =A0 =A0 =A0descriptor.SCSITarget.MSIxIndex =3D =A0_base_get_msix_=
index(ioc);
> @@ -1881,6 +1886,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2=
SAS_ADAPTER *ioc, u16 smid,
> =A0 =A0 =A0 =A0descriptor.SCSITarget.IoIndex =3D cpu_to_le16(io_index=
);
> =A0 =A0 =A0 =A0_base_writeq(*request, &ioc->chip->RequestDescriptorPo=
stLow,
> =A0 =A0 =A0 =A0 =A0 =A0&ioc->scsi_lookup_lock);
> + =A0 =A0 =A0 preempt_enable();
> =A0}
>
> =A0/**
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
