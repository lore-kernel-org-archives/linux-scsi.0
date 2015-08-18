From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [patch] scsi: aic94xx: set an error code on failure
Date: Tue, 18 Aug 2015 11:58:12 +0200
Message-ID: <mqdy4h83oln.fsf@c203.arch.suse.de>
References: <20150818092029.GD3965@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150818092029.GD3965@mwanda> (Dan Carpenter's message of "Tue,
	18 Aug 2015 12:20:29 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dan Williams <dan.j.williams@intel.com>, Venkatesh Srinivas <venkateshs@google.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> We recently did some cleanup here and now the static checkers notice
> that there is a missing error code when ioremap() fails.  Let's set i=
t
> to -ENOMEM.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94=
xx/aic94xx_init.c
> index 140cb8e..f6c336b 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -104,6 +104,7 @@ static int asd_map_memio(struct asd_ha_struct *as=
d_ha)
>  		if (!io_handle->addr) {
>  			asd_printk("couldn't map MBAR%d of %s\n", i=3D=3D0?0:1,
>  				   pci_name(asd_ha->pcidev));
> +			err =3D -ENOMEM;
>  			goto Err_unreq;
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
