From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] qla2xxx: Avoid triggering undefined behavior in
 qla2x00_mbx_completion()
Date: Fri, 26 Jan 2018 17:17:27 +0000
Message-ID: <3F013BB9-0B01-42BA-8EE1-04F73E869892@cavium.com>
References: <20180125162429.7962-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0081.outbound.protection.outlook.com ([104.47.32.81]:21504
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbeAZRR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jan 2018 12:17:29 -0500
In-Reply-To: <20180125162429.7962-1-bart.vanassche@wdc.com>
Content-Language: en-US
Content-ID: <F4021A9E46DE1A4D9EC4B1035844CB48@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Jan 25, 2018, at 8:24 AM, Bart Van Assche <bart.vanassche@wdc.com> wro=
te:
>=20
> A left shift must shift less than the bit width of the left argument.
> Avoid triggering undefined behavior if ha->mbx_count =3D=3D 32.
>=20
> This patch avoids that UBSAN reports the following complaint:
>=20
> UBSAN: Undefined behaviour in drivers/scsi/qla2xxx/qla_isr.c:275:14
> shift exponent 32 is too large for 32-bit type 'int'
> Call Trace:
> dump_stack+0x4e/0x6c
> ubsan_epilogue+0xd/0x3b
> __ubsan_handle_shift_out_of_bounds+0x112/0x14c
> qla2x00_mbx_completion+0x1c5/0x25d [qla2xxx]
> qla2300_intr_handler+0x1ea/0x3bb [qla2xxx]
> qla2x00_mailbox_command+0x77b/0x139a [qla2xxx]
> qla2x00_mbx_reg_test+0x83/0x114 [qla2xxx]
> qla2x00_chip_diag+0x354/0x45f [qla2xxx]
> qla2x00_initialize_adapter+0x2c2/0xa4e [qla2xxx]
> qla2x00_probe_one+0x1681/0x392e [qla2xxx]
> pci_device_probe+0x10b/0x1f1
> driver_probe_device+0x21f/0x3a4
> __driver_attach+0xa9/0xe1
> bus_for_each_dev+0x6e/0xb5
> driver_attach+0x22/0x3c
> bus_add_driver+0x1d1/0x2ae
> driver_register+0x78/0x130
> __pci_register_driver+0x75/0xa8
> qla2x00_module_init+0x21b/0x267 [qla2xxx]
> do_one_initcall+0x5a/0x1e2
> do_init_module+0x9d/0x285
> load_module+0x20db/0x38e3
> SYSC_finit_module+0xa8/0xbc
> SyS_finit_module+0x9/0xb
> do_syscall_64+0x77/0x271
> entry_SYSCALL64_slow_path+0x25/0x25
>=20
> Reported-by: Meelis Roos <mroos@linux.ee>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 16c43bd9bb83..79f538448364 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -272,7 +272,8 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t=
 mb0)
> 	struct device_reg_2xxx __iomem *reg =3D &ha->iobase->isp;
>=20
> 	/* Read all mbox registers? */
> -	mboxes =3D (1 << ha->mbx_count) - 1;
> +	WARN_ON_ONCE(ha->mbx_count > 32);
> +	mboxes =3D (1ULL << ha->mbx_count) - 1;
> 	if (!ha->mcp)
> 		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERROR.\n");
> 	else
> @@ -2884,7 +2885,8 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16=
_t mb0)
> 	struct device_reg_24xx __iomem *reg =3D &ha->iobase->isp24;
>=20
> 	/* Read all mbox registers? */
> -	mboxes =3D (1 << ha->mbx_count) - 1;
> +	WARN_ON_ONCE(ha->mbx_count > 32);
> +	mboxes =3D (1ULL << ha->mbx_count) - 1;
> 	if (!ha->mcp)
> 		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERROR.\n");
> 	else
> --=20
> 2.16.0
>=20

Thanks for the formal patch.

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
