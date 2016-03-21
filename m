From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] mpt3sas: Don't overreach ioc->reply_post[] during initialization
Date: Mon, 21 Mar 2016 09:25:41 +0100
Message-ID: <2254143.89zXHNL1JB@c203>
References: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbcCUIZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 04:25:45 -0400
In-Reply-To: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Freitag, 18. M=E4rz 2016 12:45:42 CET Calvin Owens wrote:
> In _base_make_ioc_operational(), we walk ioc->reply_queue_list and pu=
ll
> a pointer out of successive elements of ioc->reply_post[] for each en=
try
> in that list if RDPQ is enabled.
>=20
> Since the code pulls the pointer for the next iteration at the bottom=
 of
> the loop, it triggers the a KASAN dump on the final iteration:
>=20
>     BUG: KASAN: slab-out-of-bounds in
> _base_make_ioc_operational+0x47b7/0x47e0 [mpt3sas] at addr ffff880754=
816ab0
> Read of size 8 by task modprobe/305
>     <snip>
>     Call Trace:
>      [<ffffffff81dfc591>] dump_stack+0x4d/0x6c
>      [<ffffffff814c9689>] print_trailer+0xf9/0x150
>      [<ffffffff814ceda4>] object_err+0x34/0x40
>      [<ffffffff814d1231>] kasan_report_error+0x221/0x530
>      [<ffffffff814d1673>] __asan_report_load8_noabort+0x43/0x50
>      [<ffffffffa0043637>] _base_make_ioc_operational+0x47b7/0x47e0 [m=
pt3sas]
> [<ffffffffa0049a51>] mpt3sas_base_attach+0x1991/0x2120 [mpt3sas]
> [<ffffffffa0053c93>] _scsih_probe+0xeb3/0x16b0 [mpt3sas]
>      [<ffffffff81ebd047>] local_pci_probe+0xc7/0x170
>      [<ffffffff81ebf2cf>] pci_device_probe+0x20f/0x290
>      [<ffffffff820d50cd>] really_probe+0x17d/0x600
>      [<ffffffff820d56a3>] __driver_attach+0x153/0x190
>      [<ffffffff820cffac>] bus_for_each_dev+0x11c/0x1a0
>      [<ffffffff820d421d>] driver_attach+0x3d/0x50
>      [<ffffffff820d378a>] bus_add_driver+0x44a/0x5f0
>      [<ffffffff820d666c>] driver_register+0x18c/0x3b0
>      [<ffffffff81ebcb76>] __pci_register_driver+0x156/0x200
>      [<ffffffffa00c8135>] _mpt3sas_init+0x135/0x1000 [mpt3sas]
>      [<ffffffff81000423>] do_one_initcall+0x113/0x2b0
>      [<ffffffff813caa5a>] do_init_module+0x1d0/0x4d8
>      [<ffffffff81273909>] load_module+0x6729/0x8dc0
>      [<ffffffff81276123>] SYSC_init_module+0x183/0x1a0
>      [<ffffffff8127625e>] SyS_init_module+0xe/0x10
>      [<ffffffff828fe7d7>] entry_SYSCALL_64_fastpath+0x12/0x6a
>=20
> Fix this by pulling the value at the beginning of the loop.
>=20
> Signed-off-by: Calvin Owens <calvinowens@fb.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
