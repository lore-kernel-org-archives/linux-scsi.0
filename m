From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] SCSI: sd: simplify ida usage
Date: Fri, 02 Oct 2015 12:15:04 +0200
Message-ID: <mqd4mi98tlj.fsf@c203.arch.suse.de>
References: <cover.1443723136.git.lduncan@suse.com>
	<cover.1443723136.git.lduncan@suse.com>
	<c832f76821c18fa953ff539b6e852bfd2cdc24b8.1443723136.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c832f76821c18fa953ff539b6e852bfd2cdc24b8.1443723136.git.lduncan@suse.com>
	(Lee Duncan's message of "Thu, 1 Oct 2015 11:59:05 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Lee Duncan <lduncan@suse.com> writes:

> Simplify ida index allocation and removal by
> using the ida_simple_* helper functions.
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/sd.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3b2fcb4fada0..3d77ac8f0d4c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -118,7 +118,6 @@ static void scsi_disk_release(struct device *cdev=
);
>  static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense=
_hdr *);
>  static void sd_print_result(const struct scsi_disk *, const char *, =
int);
> =20
> -static DEFINE_SPINLOCK(sd_index_lock);
>  static DEFINE_IDA(sd_index_ida);
> =20
>  /* This semaphore is used to mediate the 0->1 reference get in the
> @@ -2948,19 +2947,12 @@ static int sd_probe(struct device *dev)
>  	if (!gd)
>  		goto out_free;
> =20
> -	do {
> -		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
> -			goto out_put;
> -
> -		spin_lock(&sd_index_lock);
> -		error =3D ida_get_new(&sd_index_ida, &index);
> -		spin_unlock(&sd_index_lock);
> -	} while (error =3D=3D -EAGAIN);
> -
> -	if (error) {
> +	error =3D ida_simple_get(&sd_index_ida, 0, 0, GFP_KERNEL);
> +	if (error < 0) {
>  		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
>  		goto out_put;
>  	}
> +	index =3D error;
> =20
>  	error =3D sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME=
_LEN);
>  	if (error) {
> @@ -3001,9 +2993,7 @@ static int sd_probe(struct device *dev)
>  	return 0;
> =20
>   out_free_index:
> -	spin_lock(&sd_index_lock);
> -	ida_remove(&sd_index_ida, index);
> -	spin_unlock(&sd_index_lock);
> +	ida_simple_remove(&sd_index_ida, index);
>   out_put:
>  	put_disk(gd);
>   out_free:
> @@ -3064,9 +3054,7 @@ static void scsi_disk_release(struct device *de=
v)
>  	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
>  	struct gendisk *disk =3D sdkp->disk;
>  =09
> -	spin_lock(&sd_index_lock);
> -	ida_remove(&sd_index_ida, sdkp->index);
> -	spin_unlock(&sd_index_lock);
> +	ida_simple_remove(&sd_index_ida, sdkp->index);
> =20
>  	blk_integrity_unregister(disk);
>  	disk->private_data =3D NULL;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
