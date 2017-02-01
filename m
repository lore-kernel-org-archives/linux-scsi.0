From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi, block: fix duplicate bdi name registration
 crashes
Date: Wed, 1 Feb 2017 20:35:20 +0000
Message-ID: <1485981306.2560.11.camel@sandisk.com>
References: <148597749824.11392.9598040130844203664.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <148597749824.11392.9598040130844203664.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <DE381330E952BC4C868D1D99EBA28E88@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "osandov@osandov.com" <osandov@osandov.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "jack@suse.cz" <jack@suse.cz>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-02-01 at 11:32 -0800, Dan Williams wrote:
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 76f39754e7b0..27e7e12c0c2d 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -167,6 +167,22 @@ struct blk_integrity {
>  };
> =20
>  #endif	/* CONFIG_BLK_DEV_INTEGRITY */
> +struct disk_devt {
> +	atomic_t count;
> +	void (*release)(struct disk_devt *disk_devt);
> +};
> +
> +static inline void put_disk_devt(struct disk_devt *disk_devt)
> +{
> +	if (disk_devt && atomic_dec_and_test(&disk_devt->count))
> +		disk_devt->release(disk_devt);
> +}
> +
> +static inline void get_disk_devt(struct disk_devt *disk_devt)
> +{
> +	if (disk_devt)
> +		atomic_inc(&disk_devt->count);
> +}

The <linux/genhd.h> header file is included directly or indirectly in a
huge number of source files. Since neither get_disk_devt() nor
put_disk_devt() are called from the I/O path, please move these functions
from=A0<linux/genhd.h> into block/genhd.c to keep the compilation time of
the kernel as short as possible.

Thanks,

Bart.=
