From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] lpfc: Destroy lpfc_hba_index IDR on module exit
Date: Fri, 10 Jul 2015 08:39:03 +0200
Message-ID: <559F6887.4020008@suse.de>
References: <1436368797-30934-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436368797-30934-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/08/2015 05:19 PM, Johannes Thumshirn wrote:
> Destroy lpfc_hba_index IDR on module exit, reclaiming the allocated m=
emory.
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
>  drivers/scsi/lpfc/lpfc_init.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index f962118..4bedb06 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11477,6 +11477,7 @@ lpfc_exit(void)
>  		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
>  	}
>  	kfree(lpfc_used_cpu);
> +	idr_destroy(&lpfc_hba_index);
>  }
> =20
>  module_init(lpfc_init);
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
