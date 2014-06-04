From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] sd: bad return code of init_sd
Date: Wed, 04 Jun 2014 12:44:11 -0400
Message-ID: <1401900251.26039.47.camel@localhost.localdomain>
References: <1401831265-8547-1-git-send-email-clement.calmels@free.fr>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaFDQoR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2014 12:44:17 -0400
In-Reply-To: <1401831265-8547-1-git-send-email-clement.calmels@free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Cl=E9ment?= Calmels <clement.calmels@free.fr>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 23:34 +0200, Cl=C3=A9ment Calmels wrote:
> In init_sd function, if kmem_cache_create or mempool_create_slab_pool=
s
> calls fail, the error will not be correclty reported because
> class_register previously set the value of err to 0.
>=20
> Signed-off-by: Cl=C3=A9ment Calmels <clement.calmels@free.fr>
> ---
>  drivers/scsi/sd.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e9689d5..7daa2aa 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3205,12 +3205,14 @@ static int __init init_sd(void)
>  					 0, 0, NULL);
>  	if (!sd_cdb_cache) {
>  		printk(KERN_ERR "sd: can't init extended cdb cache\n");
> +		err =3D -ENOMEM;
>  		goto err_out_class;
>  	}
> =20
>  	sd_cdb_pool =3D mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_ca=
che);
>  	if (!sd_cdb_pool) {
>  		printk(KERN_ERR "sd: can't init extended cdb pool\n");
> +		err =3D -ENOMEM;
>  		goto err_out_cache;
>  	}
> =20

I posted this same patch on 2/14/2013.  Thanks for reminding me!

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
