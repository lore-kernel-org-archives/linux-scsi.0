From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: system hung up when offlining CPUs
Date: Mon, 30 Oct 2017 14:38:27 +0530
Message-ID: <817f0d359fca6830ece5b1fcf207ce65@mail.gmail.com>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com>
 <20170809124213.0d9518bb@why.wild-wind.fr.eu.org> <cd524af7-1f20-1956-1e44-92a451053387@gmail.com>
 <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com> <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com> <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com>
 <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com> <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de>
 <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com> <alpine.DEB.2.20.1709131529400.1874@nanos>
 <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com> <alpine.DEB.2.20.1709161212160.2105@nanos>
 <alpine.DEB.2.20.1709161630580.2105@nanos> <78ce7246-c567-3f5f-b168-9bcfc659d4bd@gmail.com>
 <alpine.DEB.2.20.1710032328280.2278@nanos> <alpine.DEB.2.20.1710042208400.2406@nanos>
 <3d93387d-30eb-0434-2216-0e6435c633f8@gmail.com> <857c813c-29cd-6e9f-5cde-52421d4d8429@gmail.com>
 <alpine.DEB.2.20.1710162106400.2037@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1710162106400.2037@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, October 17, 2017 1:57 AM
> To: YASUAKI ISHIMATSU
> Cc: Kashyap Desai; Hannes Reinecke; Marc Zyngier; Christoph Hellwig;
> axboe@kernel.dk; mpe@ellerman.id.au; keith.busch@intel.com;
> peterz@infradead.org; LKML; linux-scsi@vger.kernel.org; Sumit Saxena;
> Shivasharan Srikanteshwara
> Subject: Re: system hung up when offlining CPUs
>
> Yasuaki,
>
> On Mon, 16 Oct 2017, YASUAKI ISHIMATSU wrote:
>
> > Hi Thomas,
> >
> > > Can you please apply the patch below on top of Linus tree and
retest?
> > >
> > > Please send me the outputs I asked you to provide last time in any
> > > case (success or fail).
> >
> > The issue still occurs even if I applied your patch to linux
4.14.0-rc4.
>
> Thanks for testing.
>
> > ---
> > [ ...] INFO: task setroubleshootd:4972 blocked for more than 120
seconds.
> > [ ...]       Not tainted 4.14.0-rc4.thomas.with.irqdebug+ #6
> > [ ...] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this
> message.
> > [ ...] setroubleshootd D    0  4972      1 0x00000080
> > [ ...] Call Trace:
> > [ ...]  __schedule+0x28d/0x890
> > [ ...]  ? release_pages+0x16f/0x3f0
> > [ ...]  schedule+0x36/0x80
> > [ ...]  io_schedule+0x16/0x40
> > [ ...]  wait_on_page_bit+0x107/0x150
> > [ ...]  ? page_cache_tree_insert+0xb0/0xb0 [ ...]
> > truncate_inode_pages_range+0x3dd/0x7d0
> > [ ...]  ? schedule_hrtimeout_range_clock+0xad/0x140
> > [ ...]  ? remove_wait_queue+0x59/0x60
> > [ ...]  ? down_write+0x12/0x40
> > [ ...]  ? unmap_mapping_range+0x75/0x130 [ ...]
> > truncate_pagecache+0x47/0x60 [ ...]  truncate_setsize+0x32/0x40 [ ...]
> > xfs_setattr_size+0x100/0x300 [xfs] [ ...]
> > xfs_vn_setattr_size+0x40/0x90 [xfs] [ ...]  xfs_vn_setattr+0x87/0xa0
> > [xfs] [ ...]  notify_change+0x266/0x440 [ ...]  do_truncate+0x75/0xc0
> > [ ...]  path_openat+0xaba/0x13b0 [ ...]  ?
> > mem_cgroup_commit_charge+0x31/0x130
> > [ ...]  do_filp_open+0x91/0x100
> > [ ...]  ? __alloc_fd+0x46/0x170
> > [ ...]  do_sys_open+0x124/0x210
> > [ ...]  SyS_open+0x1e/0x20
> > [ ...]  do_syscall_64+0x67/0x1b0
> > [ ...]  entry_SYSCALL64_slow_path+0x25/0x25
>
> This is definitely a driver issue. The driver requests an affinity
managed
> interrupt. Affinity managed interrupts are different from non managed
> interrupts in several ways:
>
> Non-Managed interrupts:
>
>  1) At setup time the default interrupt affinity is assigned to each
>     interrupt. The effective affinity is usually a subset of the online
>     CPUs.
>
>  2) User space can modify the affinity of the interrupt
>
>  3) If a CPU in the affinity mask goes offline and there are still
online
>     CPUs in the affinity mask then the effective affinity is moved to a
>     subset of the online CPUs in the affinity mask.
>
>     If the last CPU in the affinity mask of an interrupt goes offline
then
>     the hotplug code breaks the affinity and makes it affine to the
online
>     CPUs. The effective affinity is a subset of the new affinity
setting,
>
> Managed interrupts:
>
>  1) At setup time the interrupts of a multiqueue device are evenly
spread
>     over the possible CPUs. If all CPUs in the affinity mask of a given
>     interrupt are offline at request_irq() time, the interrupt stays
shut
>     down. If the first CPU in the affinity mask comes online later the
>     interrupt is started up.
>
>  2) User space cannot modify the affinity of the interrupt
>
>  3) If a CPU in the affinity mask goes offline and there are still
online
>     CPUs in the affinity mask then the effective affinity is moved a
subset
>     of the online CPUs in the affinity mask. I.e. the same as with
>     Non-Managed interrupts.
>
>     If the last CPU in the affinity mask of a managed interrupt goes
>     offline then the interrupt is shutdown. If the first CPU in the
>     affinity mask becomes online again then the interrupt is started up
>     again.
>
Hi Thomas,
Thanks for the detailed explanation about the behavior of managed
interrupts.
This helped me to understand the issue better. This is first time I am
checking CPU hotplug system,
so my input is very preliminary. Please bear with my understanding and
correct me where required.

This issue is reproducible on our local setup as well, with managed
interrupts.
I have few queries on the requirements for device driver that you have
mentioned.

In managed-interrupts case, interrupts which were affine to the offlined
CPU is not getting migrated
to another available CPU. But the documentation at below link says that
"all interrupts" are migrated
to a new CPU. So not all interrupts are getting migrated to a new CPU
then.
https://www.kernel.org/doc/html/v4.11/core-api/cpu_hotplug.html#the-offlin
e-case
"- All interrupts targeted to this CPU are migrated to a new CPU"


> So this has consequences:
>
>  1) The device driver has to make sure that no requests are targeted at
a
>     queue whose interrupt is affine to offline CPUs and therefor shut
>     down. If the driver ignores that then this queue will not deliver an
>     interrupt simply because that interrupt is shut down.
>
>  2) When the last CPU in the affinity mask of a queue interrupt goes
>     offline the device driver has to make sure, that all outstanding
>     requests in the queue which have not yet delivered their interrupt
are
>     completed. This is required because when the CPU is finally offline
the
>     interrupt is shut down and wont deliver any more interrupts.
>
>     If that does not happen then the not yet completed request will try
to
>     send the completion interrupt which obviously gets not delivered
>     because it is shut down.
>
Once the last CPU in the affinity mask is offlined and a particular IRQ is
shutdown, is there a way
currently for the device driver to get callback to complete all
outstanding requests on that queue?
>From the ftrace that I captured,  below were the various functions being
called once the irq shutdown was initiated.
There were no callbacks being called from the irq core that I could see.

           <...>-16    [001] d..1  9915.744040: irq_shutdown
<-irq_migrate_all_off_this_cpu
					 ^^^^^^^^^^^
           <...>-16    [001] d..1  9915.744040: __irq_disable
<-irq_shutdown
           <...>-16    [001] d..1  9915.744041: mask_irq.part.30
<-__irq_disable
           <...>-16    [001] d..1  9915.744041: pci_msi_mask_irq
<-mask_irq.part.30
           <...>-16    [001] d..1  9915.744041: msi_set_mask_bit
<-pci_msi_mask_irq
           <...>-16    [001] d..1  9915.744042: irq_domain_deactivate_irq
<-irq_shutdown
           <...>-16    [001] d..1  9915.744043:
__irq_domain_deactivate_irq <-irq_domain_deactivate_irq
           <...>-16    [001] d..1  9915.744043: msi_domain_deactivate
<-__irq_domain_deactivate_irq
           <...>-16    [001] d..1  9915.744044: pci_msi_domain_write_msg
<-msi_domain_deactivate
           <...>-16    [001] d..1  9915.744044: __pci_write_msi_msg
<-pci_msi_domain_write_msg
           <...>-16    [001] d..1  9915.744044:
__irq_domain_deactivate_irq <-__irq_domain_deactivate_irq
           <...>-16    [001] d..1  9915.744045:
intel_irq_remapping_deactivate <-__irq_domain_deactivate_irq
           <...>-16    [001] d..1  9915.744045: modify_irte
<-intel_irq_remapping_deactivate
           <...>-16    [001] d..1  9915.744045: _raw_spin_lock_irqsave
<-modify_irte
           <...>-16    [001] d..1  9915.744045: qi_submit_sync
<-modify_irte
           <...>-16    [001] d..1  9915.744046: _raw_spin_lock_irqsave
<-qi_submit_sync
           <...>-16    [001] d..1  9915.744046: _raw_spin_lock
<-qi_submit_sync
           <...>-16    [001] d..1  9915.744047:
_raw_spin_unlock_irqrestore <-qi_submit_sync
           <...>-16    [001] d..1  9915.744047:
_raw_spin_unlock_irqrestore <-modify_irte
           <...>-16    [001] d..1  9915.744047:
__irq_domain_deactivate_irq <-__irq_domain_deactivate_irq

In my knowledge many device drivers in the kernel tree pass
PCI_IRQ_AFFINITY flag to
pci_alloc_irq_vectors and it is widely used feature (not limited to
megaraid_sas driver).
But I could not see any of the drivers working as per the constraints
mentioned.
Can you please point me to any existing driver to understand how above
constraints can
be implemented?

Below is simple grep I ran on drivers passing PCI_IRQ_AFFINITY flag to
pci_alloc_irq_vectors.

# grep -R "PCI_IRQ_AFFINITY" drivers/*
drivers/nvme/host/pci.c:                        PCI_IRQ_ALL_TYPES |
PCI_IRQ_AFFINITY);
drivers/pci/host/vmd.c:                                 PCI_IRQ_MSIX |
PCI_IRQ_AFFINITY);
drivers/pci/msi.c:      if (flags & PCI_IRQ_AFFINITY) {
drivers/scsi/aacraid/comminit.c:
PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
drivers/scsi/be2iscsi/be_main.c:
PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc) < 0) {
drivers/scsi/csiostor/csio_isr.c:                       PCI_IRQ_MSIX |
PCI_IRQ_AFFINITY, &desc);
drivers/scsi/hpsa.c:                            PCI_IRQ_MSIX |
PCI_IRQ_AFFINITY);
drivers/scsi/lpfc/lpfc_init.c:                          vectors,
PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
drivers/scsi/megaraid/megaraid_sas_base.c:                      irq_flags
|= PCI_IRQ_AFFINITY;
drivers/scsi/megaraid/megaraid_sas_base.c:                      irq_flags
|= PCI_IRQ_AFFINITY;
drivers/scsi/mpt3sas/mpt3sas_base.c:            irq_flags |=
PCI_IRQ_AFFINITY;
drivers/scsi/qla2xxx/qla_isr.c:             ha->msix_count, PCI_IRQ_MSIX |
PCI_IRQ_AFFINITY,
drivers/scsi/smartpqi/smartpqi_init.c:                  PCI_IRQ_MSIX |
PCI_IRQ_AFFINITY);
drivers/virtio/virtio_pci_common.c:
(desc ? PCI_IRQ_AFFINITY : 0),

Thanks,
Shivasharan

> It's hard to tell from the debug information which of the constraints
(#1 or #2
> or both) has been violated by the driver (or the device hardware /
> firmware) but the effect that the task which submitted the I/O operation
is
> hung after an offline operation points clearly into that direction.
>
> The irq core code is doing what is expected and I have no clue about
that
> megasas driver/hardware so I have to punt and redirect you to the SCSI
and
> megasas people.
>
> Thanks,
>
> 	tglx
>
>
