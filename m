From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
Date: Wed, 11 Apr 2012 11:43:42 +0300
Message-ID: <20120411084342.GA9250@redhat.com>
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: axboe@kernel.dk, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, asamymuthupa@micron.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, James.Bottomley@HansenPartnership.com, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 10, 2012 at 03:28:05PM +0800, Ren Mingxin wrote:
> The current virtio block's naming algorithm just supports 18278
> (26^3 + 26^2 + 26) disks. If there are mass of virtio blocks,
> there will be disks with the same name.
> 
> Based on commit 3e1a7ff8a0a7b948f2684930166954f9e8e776fe, I add
> function "virtblk_name_format()" for virtio block to support mass
> of disks naming.
> 
> Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>

Applied, thanks everyone.

> ---
>  drivers/block/virtio_blk.c |   38 ++++++++++++++++++++++++++------------
>  1 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index c4a60ba..86516c8 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -374,6 +374,31 @@ static int init_vq(struct virtio_blk *vblk)
>  	return err;
>  }
>  
> +static int virtblk_name_format(char *prefix, int index, char *buf, int buflen)
> +{
> +	const int base = 'z' - 'a' + 1;
> +	char *begin = buf + strlen(prefix);
> +	char *begin = buf + strlen(prefix);
> +	char *end = buf + buflen;
> +	char *p;
> +	int unit;
> +
> +	p = end - 1;
> +	*p = '\0';
> +	unit = base;
> +	do {
> +		if (p == begin)
> +			return -EINVAL;
> +		*--p = 'a' + (index % unit);
> +		index = (index / unit) - 1;
> +	} while (index >= 0);
> +
> +	memmove(begin, p, end - p);
> +	memcpy(buf, prefix, strlen(prefix));
> +
> +	return 0;
> +}
> +
>  static int __devinit virtblk_probe(struct virtio_device *vdev)
>  {
>  	struct virtio_blk *vblk;
> @@ -442,18 +467,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
>  
>  	q->queuedata = vblk;
>  
> -	if (index < 26) {
> -		sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
> -	} else if (index < (26 + 1) * 26) {
> -		sprintf(vblk->disk->disk_name, "vd%c%c",
> -			'a' + index / 26 - 1, 'a' + index % 26);
> -	} else {
> -		const unsigned int m1 = (index / 26 - 1) / 26 - 1;
> -		const unsigned int m2 = (index / 26 - 1) % 26;
> -		const unsigned int m3 =  index % 26;
> -		sprintf(vblk->disk->disk_name, "vd%c%c%c",
> -			'a' + m1, 'a' + m2, 'a' + m3);
> -	}
> +	virtblk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
>  
>  	vblk->disk->major = major;
>  	vblk->disk->first_minor = index_to_minor(index);
> -- 
> 1.7.1
