From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/3] megaraid_sas: return -ENOMEM when create DMA pool
 for cmd frames failed
Date: Tue, 27 Oct 2015 11:17:06 +0100
Message-ID: <1445941026.16404.35.camel@suse.de>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
	 <1445934375-17784-4-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445934375-17784-4-git-send-email-wangweidong1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Weidong Wang <wangweidong1@huawei.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-27 at 16:26 +0800, Weidong Wang wrote:
> when create DMA pool for cmd frames failed, we should return -ENOMEM,
> instead of 0.
> In some case in:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0megasas_init_adapter_fusion()
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0-->megasas_alloc_cmds()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-->megasas_create_frame_poo=
l
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0create DM=
A pool failed,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0--> megasas_free_cmds=
() [1]
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0-->megasas_alloc_cmds_fusion()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed, then goto fail_allo=
c_cmds.
> =C2=A0=C2=A0=C2=A0=C2=A0-->megasas_free_cmds() [2]
>=20
> we will call megasas_free_cmds twice, [1] will kfree cmd_list,
> [2] will use cmd_list.it will cause a problem:
>=20
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000000
> pgd =3D ffffffc000f70000
> [00000000] *pgd=3D0000001fbf893003, *pud=3D0000001fbf893003,
> *pmd=3D0000001fbf894003, *pte=3D006000006d000707
> Internal error: Oops: 96000005 [#1] SMP
> =C2=A0Modules linked in:
> =C2=A0CPU: 18 PID: 1 Comm: swapper/0 Not tainted
> =C2=A0task: ffffffdfb9290000 ti: ffffffdfb923c000 task.ti:
> ffffffdfb923c000
> =C2=A0PC is at megasas_free_cmds+0x30/0x70
> =C2=A0LR is at megasas_free_cmds+0x24/0x70
>=20
> =C2=A0...
>=20
> =C2=A0Call trace:
> =C2=A0[<ffffffc0005b779c>] megasas_free_cmds+0x30/0x70
> =C2=A0[<ffffffc0005bca74>] megasas_init_adapter_fusion+0x2f4/0x4d8
> =C2=A0[<ffffffc0005b926c>] megasas_init_fw+0x2dc/0x760
> =C2=A0[<ffffffc0005b9ab0>] megasas_probe_one+0x3c0/0xcd8
> =C2=A0[<ffffffc0004a5abc>] local_pci_probe+0x4c/0xb4
> =C2=A0[<ffffffc0004a5c40>] pci_device_probe+0x11c/0x14c
> =C2=A0[<ffffffc00053a5e4>] driver_probe_device+0x1ec/0x430
> =C2=A0[<ffffffc00053a92c>] __driver_attach+0xa8/0xb0
> =C2=A0[<ffffffc000538178>] bus_for_each_dev+0x74/0xc8
> =C2=A0 [<ffffffc000539e88>] driver_attach+0x28/0x34
> =C2=A0[<ffffffc000539a18>] bus_add_driver+0x16c/0x248
> =C2=A0[<ffffffc00053b234>] driver_register+0x6c/0x138
> =C2=A0[<ffffffc0004a5350>] __pci_register_driver+0x5c/0x6c
> =C2=A0[<ffffffc000ce3868>] megasas_init+0xc0/0x1a8
> =C2=A0[<ffffffc000082a58>] do_one_initcall+0xe8/0x1ec
> =C2=A0[<ffffffc000ca7be8>] kernel_init_freeable+0x1c8/0x284
> =C2=A0[<ffffffc0008d90b8>] kernel_init+0x1c/0xe4
>=20
> Signed-off-by: Weidong Wang <wangweidong1@huawei.com>
> ---
> =C2=A0drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 2287aa1..8215218 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3746,8 +3746,9 @@ int megasas_alloc_cmds(struct megasas_instance
> *instance)
> =C2=A0	=C2=A0* Create a frame pool and assign one frame to each cmd
> =C2=A0	=C2=A0*/
> =C2=A0	if (megasas_create_frame_pool(instance)) {
> -		dev_dbg(&instance->pdev->dev, "Error creating frame
> DMA pool\n");
> +		dev_err(&instance->pdev->dev, "Error creating frame
> DMA pool\n");
> =C2=A0		megasas_free_cmds(instance);
> +		return -ENOMEM;
> =C2=A0	}
> =C2=A0
> =C2=A0	return 0;

I think this is needed for stable as well.

Other than that,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Thanks,
	Johannes
