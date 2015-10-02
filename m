From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/5] block: mtip32xx: simplify ida usage
Date: Fri, 02 Oct 2015 12:16:04 +0200
Message-ID: <mqdlhbl7ezf.fsf@c203.arch.suse.de>
References: <cover.1443723136.git.lduncan@suse.com>
	<cover.1443723136.git.lduncan@suse.com>
	<64f964663b1a35ff2352dc3cea76baaae03a2d13.1443723136.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <64f964663b1a35ff2352dc3cea76baaae03a2d13.1443723136.git.lduncan@suse.com>
	(Lee Duncan's message of "Thu, 1 Oct 2015 11:59:08 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Lee Duncan <lduncan@suse.com> writes:

> Simplify ida index allocation and removal by
> using the ida_simple_* helper functions
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/block/mtip32xx/mtip32xx.c | 26 ++++++--------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32=
xx/mtip32xx.c
> index 4a2ef09e6704..e62d170b0641 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -118,7 +118,6 @@ static struct dentry *dfs_device_status;
> =20
>  static u32 cpu_use[NR_CPUS];
> =20
> -static DEFINE_SPINLOCK(rssd_index_lock);
>  static DEFINE_IDA(rssd_index_ida);
> =20
>  static int mtip_block_initialize(struct driver_data *dd);
> @@ -3821,17 +3820,10 @@ static int mtip_block_initialize(struct drive=
r_data *dd)
>  	}
> =20
>  	/* Generate the disk name, implemented same as in sd.c */
> -	do {
> -		if (!ida_pre_get(&rssd_index_ida, GFP_KERNEL))
> -			goto ida_get_error;
> -
> -		spin_lock(&rssd_index_lock);
> -		rv =3D ida_get_new(&rssd_index_ida, &index);
> -		spin_unlock(&rssd_index_lock);
> -	} while (rv =3D=3D -EAGAIN);
> -
> -	if (rv)
> +	rv =3D ida_simple_get(&rssd_index_ida, 0, 0, GFP_KERNEL);
> +	if (rv < 0)
>  		goto ida_get_error;
> +	index =3D rv;
> =20
>  	rv =3D rssd_disk_name_format("rssd",
>  				index,
> @@ -3981,9 +3973,7 @@ init_hw_cmds_error:
>  block_queue_alloc_init_error:
>  	mtip_hw_debugfs_exit(dd);
>  disk_index_error:
> -	spin_lock(&rssd_index_lock);
> -	ida_remove(&rssd_index_ida, index);
> -	spin_unlock(&rssd_index_lock);
> +	ida_simple_remove(&rssd_index_ida, index);
> =20
>  ida_get_error:
>  	put_disk(dd->disk);
> @@ -4051,9 +4041,7 @@ static int mtip_block_remove(struct driver_data=
 *dd)
>  	}
>  	dd->disk  =3D NULL;
> =20
> -	spin_lock(&rssd_index_lock);
> -	ida_remove(&rssd_index_ida, dd->index);
> -	spin_unlock(&rssd_index_lock);
> +	ida_simple_remove(&rssd_index_ida, dd->index);
> =20
>  	/* De-initialize the protocol layer. */
>  	mtip_hw_exit(dd);
> @@ -4092,9 +4080,7 @@ static int mtip_block_shutdown(struct driver_da=
ta *dd)
>  		dd->queue =3D NULL;
>  	}
> =20
> -	spin_lock(&rssd_index_lock);
> -	ida_remove(&rssd_index_ida, dd->index);
> -	spin_unlock(&rssd_index_lock);
> +	ida_simple_remove(&rssd_index_ida, dd->index);
>  	return 0;
>  }

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
