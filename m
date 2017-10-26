From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: qla2xxx: New kernel warning
Date: Thu, 26 Oct 2017 03:44:15 +0000
Message-ID: <E869300F-935C-4B7F-A818-29BB34D6DBFE@cavium.com>
References: <1508462017.6933.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0061.outbound.protection.outlook.com ([104.47.42.61]:43376
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751973AbdJZDoS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 23:44:18 -0400
In-Reply-To: <1508462017.6933.3.camel@wdc.com>
Content-Language: en-US
Content-ID: <4C549FA7FF4F084490E5BE74984A569A@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,=20

> On Oct 19, 2017, at 6:13 PM, Bart Van Assche <bart.vanassche@wdc.com> wro=
te:
>=20
> Hello Himanshu,
>=20
> If I load the qla2xxx driver (git://git.kernel.org/pub/scm/linux/kernel/g=
it/mkp/scsi.git,
> 4.15/scsi-queue) then a new kernel warning appears. This did not happen w=
ith kernel v4.13.
> Can you have a look?
>=20
> qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 10.00.00.=
02-k.
> qla2xxx [0000:00:09.0]-001d: : Found an ISP2432 irq 10 iobase 0xffffc9000=
022d000.
> BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/10=
40
> caller is debug_smp_processor_id+0x17/0x20
> CPU: 7 PID: 1040 Comm: modprobe Not tainted 4.13.0-dbg+ #2
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
> dump_stack+0x86/0xcf
> check_preemption_disabled+0xe3/0xf0
> debug_smp_processor_id+0x17/0x20
> qla2x00_probe_one+0xfc8/0x28b0 [qla2xxx]
> ? trace_hardirqs_on_caller+0xf4/0x190
> ? trace_hardirqs_on+0xd/0x10
> ? _raw_spin_unlock_irqrestore+0x45/0x70
> pci_device_probe+0xca/0x140
> driver_probe_device+0x2c5/0x430
> __driver_attach+0xde/0xe0
> ? driver_probe_device+0x430/0x430
> bus_for_each_dev+0x5d/0x90
> driver_attach+0x19/0x20
> bus_add_driver+0x169/0x260
> driver_register+0x5b/0xd0
> __pci_register_driver+0x63/0x70
> qla2x00_module_init+0x1d6/0x222 [qla2xxx]
> ? 0xffffffffa0491000
> do_one_initcall+0x3e/0x16c
> ? kmem_cache_alloc+0xfa/0x160
> do_init_module+0x55/0x1eb
> load_module+0x22f5/0x2b30
> ? kernel_read+0x41/0x60
> SYSC_finit_module+0xbc/0xf0
> ? SYSC_finit_module+0xbc/0xf0
> SyS_finit_module+0x9/0x10
> entry_SYSCALL_64_fastpath+0x23/0xc2
>=20
> (gdb) list *(qla2x00_probe_one+0xfc8)
> 0x9738 is in qla2x00_probe_one (drivers/scsi/qla2xxx/qla_os.c:400).
> 395             ha->base_qpair->msix =3D &ha->msix_entries[QLA_MSIX_RSP_Q=
];
> 396             INIT_LIST_HEAD(&ha->base_qpair->hints_list);
> 397             INIT_LIST_HEAD(&ha->base_qpair->nvme_done_list);
> 398             ha->base_qpair->enable_class_2 =3D ql2xenableclass2;
> 399             /* init qpair to this cpu. Will adjust at run time. */
> 400             qla_cpu_update(rsp->qpair, smp_processor_id());
> 401             ha->base_qpair->pdev =3D ha->pdev;
> 402
> 403             if (IS_QLA27XX(ha) || IS_QLA83XX(ha))
> 404                     ha->base_qpair->reqq_start_iocbs =3D qla_83xx_sta=
rt_iocbs;
>=20
> Thanks,
>=20
> Bart.

I am back at work today. I will take a look shortly.

Thanks,
- Himanshu
