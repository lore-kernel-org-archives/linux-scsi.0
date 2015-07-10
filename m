From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Destroy st_index_idr on module exit
Date: Fri, 10 Jul 2015 08:40:08 +0200
Message-ID: <559F68C8.4050400@suse.de>
References: <1436369041-31156-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbbGJGkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jul 2015 02:40:10 -0400
In-Reply-To: <1436369041-31156-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, =?windows-1252?Q?Kai_M=E4k?= =?windows-1252?Q?isara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/08/2015 05:24 PM, Johannes Thumshirn wrote:
> Destroy st_index_idr on module exit, reclaiming the allocated memory.
>=20
> This was detected by the following semantic patch (written by Luis Ro=
driguez
> <mcgrof@suse.com>)
> <SmPL>
> @ defines_module_init @
> declarer name module_init, module_exit;
> declarer name DEFINE_IDR;
> identifier init;
> @@
>=20
> module_init(init);
>=20
> @ defines_module_exit @
> identifier exit;
> @@
>=20
> module_exit(exit);
>=20
> @ declares_idr depends on defines_module_init && defines_module_exit =
@
> identifier idr;
> @@
>=20
> DEFINE_IDR(idr);
>=20
> @ on_exit_calls_destroy depends on declares_idr && defines_module_exi=
t @
> identifier declares_idr.idr, defines_module_exit.exit;
> @@
>=20
> exit(void)
> {
>  ...
>  idr_destroy(&idr);
>  ...
> }
>=20
> @ missing_module_idr_destroy depends on declares_idr && defines_modul=
e_exit && !on_exit_calls_destroy @
> identifier declares_idr.idr, defines_module_exit.exit;
> @@
>=20
> exit(void)
> {
>  ...
>  +idr_destroy(&idr);
> }
> </SmPL>
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/st.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 3f25b8f..79ac024 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4427,6 +4427,7 @@ static void __exit exit_st(void)
>  	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
>  				 ST_MAX_TAPE_ENTRIES);
>  	class_unregister(&st_sysfs_class);
> +	idr_destroy(&st_index_idr);
>  	printk(KERN_INFO "st: Unloaded.\n");
>  }
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
