From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH  2/2] qla2xxx: fix rwlock recursion
Date: Thu, 15 Oct 2015 09:50:03 +0200
Message-ID: <561F5AAB.7090706@suse.de>
References: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com> <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbbJOHuE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Oct 2015 03:50:04 -0400
In-Reply-To: <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, hch@lst.de
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 10/14/2015 05:57 PM, Himanshu Madhani wrote:
> This patch fixes rwlock recursion introduced for ISP82XX by
> commit 8dfa4b5a ("qla2xxx: Fix sparse annotations")
>=20
> Original patch fixes other sparse warnings which did not cause
> any regression. So instead of reverting complete patch, this patch
> will revert only part which caused recursion.
>=20
> stack track has following signature
>=20
> kernel:BUG: rwlock recursion on CPU#2, insmod/39333, ffff8803e998cb28
> kernel: ffffffff8181d7de ffff88040f2af8a8 ffffffff810a8047 ffff8803e9=
98cb28
> kernel: ffff8803e998cb40 ffff88040f2af8c8 ffffffff810a833a 0000000000=
000086
> kernel: Call Trace:
> kernel: [<ffffffff812bce44>] dump_stack+0x48/0x64
> kernel: [<ffffffff810a8047>] rwlock_bug+0x67/0x70
> kernel: [<ffffffff810a833a>] do_raw_write_lock+0x8a/0xa0
> kernel: [<ffffffff815f3033>] _raw_write_lock_irqsave+0x63/0x80
> kernel: [<ffffffffa08087c8>] ? qla82xx_rd_32+0xe8/0x140 [qla2xxx]
> kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
> kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
> kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
> kernel: [<ffffffffa0808aa4>] ? qla82xx_disable_intrs+0x34/0x80 [qla2x=
xx]
> kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx=
]
> kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
> kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420 [=
qla2xxx]
> kernel: [<ffffffffa08087c8>] ? qla82xx_rd_32+0xe8/0x140 [qla2xxx]
> kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
> kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
> kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
> kernel: [<ffffffffa0808aa4>] ? qla82xx_disable_intrs+0x34/0x80 [qla2x=
xx]
> kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx=
]
> kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
> kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420 [=
qla2xxx]
> kernel: [<ffffffffa07c964e>] qla2x00_probe_one+0xefe/0x2130 [qla2xxx]
> kernel: [<ffffffff813ee31c>] ? __pm_runtime_resume+0x6c/0x90
> kernel: [<ffffffff8130052c>] local_pci_probe+0x4c/0xa0
> kernel: [<ffffffff81300603>] pci_call_probe+0x83/0xa0
> kernel: [<ffffffff813008cf>] pci_device_probe+0x7f/0xb0
> kernel: [<ffffffff813e2e83>] really_probe+0x133/0x390
> kernel: [<ffffffff813e3139>] driver_probe_device+0x59/0xd0
> kernel: [<ffffffff813e3251>] __driver_attach+0xa1/0xb0
> kernel: [<ffffffff813e31b0>] ? driver_probe_device+0xd0/0xd0
> kernel: [<ffffffff813e0cdd>] bus_for_each_dev+0x8d/0xb0
> kernel: [<ffffffff813e28ee>] driver_attach+0x1e/0x20
> kernel: [<ffffffff813e2252>] bus_add_driver+0x1d2/0x290
> kernel: [<ffffffff813e3970>] driver_register+0x60/0xe0
> kernel: [<ffffffff813009e4>] __pci_register_driver+0x64/0x70
> kernel: [<ffffffffa04bc1cb>] qla2x00_module_init+0x1cb/0x21b [qla2xxx=
]
> kernel: [<ffffffffa04bc000>] ? 0xffffffffa04bc000
> kernel: [<ffffffff8100027d>] do_one_initcall+0xad/0x1c0
> kernel: [<ffffffff810e2859>] do_init_module+0x69/0x210
> kernel: [<ffffffff810e4e5c>] load_module+0x5cc/0x750
> kernel: [<ffffffff810e1980>] ? mod_sysfs_teardown+0x140/0x140
> kernel: [<ffffffff812c9565>] ? copy_user_enhanced_fast_string+0x5/0x1=
0
> kernel: [<ffffffff810e12f0>] ? module_sect_show+0x30/0x30
> kernel: [<ffffffff810e1a8d>] ? copy_module_from_user+0x8d/0xf0
> kernel: [<ffffffff810e5162>] SyS_init_module+0x92/0xc0
> kernel: [<ffffffff815f37d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
>=20
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_nx.c |   58 ++++++++++++++++++++-----------=
---------
>  1 files changed, 29 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla=
_nx.c
> index eb0cc54..96f9b39 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -347,31 +347,33 @@ char *qdev_state(uint32_t dev_state)
>  }
> =20
>  /*
> - * In: 'off_in' is offset from CRB space in 128M pci map
> - * Out: 'off_out' is 2M pci map addr
> + * In: 'off' is offset from CRB space in 128M pci map
> + * Out: 'off' is 2M pci map addr
>   * side effect: lock crb window
>   */
>  static void
> -qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
> -			     void __iomem **off_out)
> +qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
>  {
>  	u32 win_read;
>  	scsi_qla_host_t *vha =3D pci_get_drvdata(ha->pdev);
> =20
> -	ha->crb_win =3D CRB_HI(off_in);
> -	writel(ha->crb_win, CRB_WINDOW_2M + ha->nx_pcibase);
> +	ha->crb_win =3D CRB_HI(*off);
> +	writel(ha->crb_win,
> +	    (void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase));
> =20
>  	/* Read back value to make sure write has gone through before tryin=
g
>  	 * to use it.
>  	 */
> -	win_read =3D RD_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase);
> +	win_read =3D RD_REG_DWORD((void __iomem *)
> +	    (CRB_WINDOW_2M + ha->nx_pcibase));
>  	if (win_read !=3D ha->crb_win) {
>  		ql_dbg(ql_dbg_p3p, vha, 0xb000,
>  		    "%s: Written crbwin (0x%x) "
>  		    "!=3D Read crbwin (0x%x), off=3D0x%lx.\n",
> -		    __func__, ha->crb_win, win_read, off_in);
> +		    __func__, ha->crb_win, win_read, *off);
>  	}
> -	*off_out =3D (off_in & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase=
;
> +	*off =3D (*off & MASK(16)) + CRB_INDIRECT_2M +
> +	    (unsigned long)ha->nx_pcibase;
>  }
> =20
Weelll ... I'm not a hardware designer, but this looks dodgy as
hell. You are increasing the offset every time you call this
function. Let's better hope no-one would be stupid enough to call
this function twice ...

Can't you make them idempotent, ie that multiple calls to this
function return the same 'off' number?
That would certainly decrease the likelyhood of an error ...

At the very least add some warning in the function description.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
