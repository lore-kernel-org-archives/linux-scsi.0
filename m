From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] qla2xxx: Suppress a kernel complaint in
 qla_init_base_qpair()
Date: Mon, 6 Nov 2017 21:10:20 +0000
Message-ID: <8AFF5B8E-9D72-4DB5-99AC-64DD4E46B666@cavium.com>
References: <20171106195905.5139-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171106195905.5139-1-bart.vanassche@wdc.com>
Content-Language: en-US
Content-ID: <A12E52874B83874E92DA71311CFD3C84@namprd07.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "Tran, Quinn" <Quinn.Tran@cavium.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Nov 6, 2017, at 11:59 AM, Bart Van Assche <bart.vanassche@wdc.com> wro=
te:
>=20
> Avoid that the following is reported while loading the qla2xxx
> kernel module:
>=20
> BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/78=
3
> caller is debug_smp_processor_id+0x17/0x20
> CPU: 7 PID: 783 Comm: modprobe Not tainted 4.14.0-rc8-dbg+ #2
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
> dump_stack+0x8e/0xce
> check_preemption_disabled+0xe3/0xf0
> debug_smp_processor_id+0x17/0x20
> qla2x00_probe_one+0xf43/0x26c0 [qla2xxx]
> pci_device_probe+0xca/0x140
> driver_probe_device+0x2e2/0x440
> __driver_attach+0xa3/0xe0
> bus_for_each_dev+0x5f/0x90
> driver_attach+0x19/0x20
> bus_add_driver+0x1c0/0x260
> driver_register+0x5b/0xd0
> __pci_register_driver+0x63/0x70
> qla2x00_module_init+0x1d6/0x222 [qla2xxx]
> do_one_initcall+0x3c/0x163
> do_init_module+0x55/0x1eb
> load_module+0x20a2/0x2890
> SYSC_finit_module+0xd7/0xf0
> SyS_finit_module+0x9/0x10
> entry_SYSCALL_64_fastpath+0x23/0xc2
>=20
> Fixes: commit 8abfa9e22683 ("scsi: qla2xxx: Add function call to qpair fo=
r door bell")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Quinn Tran <quinn.tran@cavium.com>
> Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
> Cc: <stable@vger.kernel.org>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 3bd956d3bc5d..b514bd5d2ac5 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -388,7 +388,7 @@ static void qla_init_base_qpair(struct scsi_qla_host =
*vha, struct req_que *req,
> 	INIT_LIST_HEAD(&ha->base_qpair->nvme_done_list);
> 	ha->base_qpair->enable_class_2 =3D ql2xenableclass2;
> 	/* init qpair to this cpu. Will adjust at run time. */
> -	qla_cpu_update(rsp->qpair, smp_processor_id());
> +	qla_cpu_update(rsp->qpair, raw_smp_processor_id());
> 	ha->base_qpair->pdev =3D ha->pdev;
>=20
> 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha))
> --=20
> 2.14.3
>=20

Thanks for the patch.=20

Acked-By: Himanshu Madhani <himanshu.madhani@cavium.com>=20

Thanks,
- Himanshu
