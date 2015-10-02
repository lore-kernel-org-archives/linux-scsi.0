From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/5] base: soc: siplify ida usage
Date: Fri, 02 Oct 2015 12:16:19 +0200
Message-ID: <mqdfv1t7ez0.fsf@c203.arch.suse.de>
References: <cover.1443723136.git.lduncan@suse.com>
	<cover.1443723136.git.lduncan@suse.com>
	<bdf9231610686622d6a422e3c9dd8a615535afeb.1443723136.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bdf9231610686622d6a422e3c9dd8a615535afeb.1443723136.git.lduncan@suse.com>
	(Lee Duncan's message of "Thu, 1 Oct 2015 11:59:09 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

Lee Duncan <lduncan@suse.com> writes:

> Simplify ida index allocation and removal by
> using the ida_simple_* helper functions
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/base/soc.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/base/soc.c b/drivers/base/soc.c
> index 39fca01c8fa1..75b98aad6faf 100644
> --- a/drivers/base/soc.c
> +++ b/drivers/base/soc.c
> @@ -16,7 +16,6 @@
>  #include <linux/err.h>
> =20
>  static DEFINE_IDA(soc_ida);
> -static DEFINE_SPINLOCK(soc_lock);
> =20
>  static ssize_t soc_info_get(struct device *dev,
>  			    struct device_attribute *attr,
> @@ -122,20 +121,10 @@ struct soc_device *soc_device_register(struct s=
oc_device_attribute *soc_dev_attr
>  	}
> =20
>  	/* Fetch a unique (reclaimable) SOC ID. */
> -	do {
> -		if (!ida_pre_get(&soc_ida, GFP_KERNEL)) {
> -			ret =3D -ENOMEM;
> -			goto out2;
> -		}
> -
> -		spin_lock(&soc_lock);
> -		ret =3D ida_get_new(&soc_ida, &soc_dev->soc_dev_num);
> -		spin_unlock(&soc_lock);
> -
> -	} while (ret =3D=3D -EAGAIN);
> -
> -	if (ret)
> +	ret =3D ida_simple_get(&soc_ida, 0, 0, GFP_KERNEL);
> +	if (ret < 0)
>  		goto out2;
> +	soc_dev->soc_dev_num =3D ret;
> =20
>  	soc_dev->attr =3D soc_dev_attr;
>  	soc_dev->dev.bus =3D &soc_bus_type;
> @@ -151,7 +140,7 @@ struct soc_device *soc_device_register(struct soc=
_device_attribute *soc_dev_attr
>  	return soc_dev;
> =20
>  out3:
> -	ida_remove(&soc_ida, soc_dev->soc_dev_num);
> +	ida_simple_remove(&soc_ida, soc_dev->soc_dev_num);
>  out2:
>  	kfree(soc_dev);
>  out1:
> @@ -161,7 +150,7 @@ out1:
>  /* Ensure soc_dev->attr is freed prior to calling soc_device_unregis=
ter. */
>  void soc_device_unregister(struct soc_device *soc_dev)
>  {
> -	ida_remove(&soc_ida, soc_dev->soc_dev_num);
> +	ida_simple_remove(&soc_ida, soc_dev->soc_dev_num);
> =20
>  	device_unregister(&soc_dev->dev);
>  }

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
