From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: block: add a error_count field to struct request
Date: Tue, 18 Apr 2017 22:57:11 +0000
Message-ID: <1492556229.2689.22.camel@sandisk.com>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
         <20170418155229.5977-18-hch@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-18-hch@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <4A66DC7A41DFBF4D9D91C8BBC6B31A83@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-18 at 08:52 -0700, Christoph Hellwig wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> This is for the legacy floppy and ataflop drivers that currently abuse
> ->errors for this purpose.  It's stashed away in a union to not grow
> the struct size, the other fields are either used by modern drivers
> for different purposes or the I/O scheduler before queing the I/O
> to drivers.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blkdev.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5986e1250d7d..e618164462e8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -175,6 +175,7 @@ struct request {
>  		struct rb_node rb_node;	/* sort/lookup */
>  		struct bio_vec special_vec;
>  		void *completion_data;
> +		int error_count; /* for legacy drivers, don't use */
>  	};
> =20
>  	/*

Hello Christoph,

Both blk-mq and the traditional block layer support a .cmd_size field to
make the block layer core allocate driver-specific data at the end of struc=
t
request. Could that mechanism have been used for the error_count field?

Thanks,

Bart.=
