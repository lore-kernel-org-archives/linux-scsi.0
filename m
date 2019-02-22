From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi: sd: block: Fix regressions in read-only block
 device handling
Date: Fri, 22 Feb 2019 06:29:57 -0800
Message-ID: <20190222142957.GA17324@infradead.org>
References: <yq1d0nxuf73.fsf@oracle.com>
 <20190213025717.20057-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190213025717.20057-1-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>, Oleksii Kurochko <olkuroch@cisco.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 12, 2019 at 09:57:17PM -0500, Martin K. Petersen wrote:
> Some devices come online in write protected state and switch to
> read-write once they are ready to process I/O requests. These devices
> broke with commit 20bd1d026aac ("scsi: sd: Keep disk read-only when
> re-reading partition") because we had no way to distinguish between a
> user decision to set a block_device read-only and the actual hardware
> device being write-protected.
> 
> Because partitions are dropped and recreated on revalidate we are
> unable to persist any user-provided policy in hd_struct. Introduce a
> bitmap in struct gendisk to track the user configuration. This bitmap
> is updated when BLKROSET is called on a given disk or partition.
> 
> A helper function, get_user_ro(), is provided to determine whether the
> ioctl has forced read-only state for a given block device. This helper
> is used by set_disk_ro() and add_partition() to ensure that both
> existing and newly created partitions will get the correct state.
> 
>  - If BLKROSET sets a whole disk device read-only, all partitions will
>    now end up in a read-only state.
> 
>  - If BLKROSET sets a given partition read-only, that partition will
>    remain read-only post revalidate.
> 
>  - Otherwise both the whole disk device and any partitions will
>    reflect the write protect state of the underlying device.
> 
> Cc: Jeremy Cline <jeremy@jcline.org>
> Cc: Oleksii Kurochko <olkuroch@cisco.com>
> Cc: stable@vger.kernel.org # v4.16+
> Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
> Fixes: 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading partition")
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> v2:
> 	- Track user read-only state in a bitmap
> 
> 	- Work around the regression that caused us to drop user
> 	  preferences on revalidate
> ---
>  block/genhd.c             | 22 +++++++++++++++++-----
>  block/ioctl.c             |  4 ++++
>  block/partition-generic.c |  2 +-
>  drivers/scsi/sd.c         |  4 +---
>  include/linux/genhd.h     |  2 ++
>  5 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 1dd8fd6613b8..34667eb1d3cc 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1544,19 +1544,31 @@ void set_device_ro(struct block_device *bdev, int flag)
>  
>  EXPORT_SYMBOL(set_device_ro);
>  
> +bool get_user_ro(struct gendisk *disk, unsigned int partno)
> +{
> +	/* Is the user read-only bit set for the whole disk device? */
> +	if (test_bit(0, disk->user_ro_bitmap))
> +		return true;
> +
> +	/* Is the user read-only bit set for this particular partition? */
> +	if (test_bit(partno, disk->user_ro_bitmap))
> +		return true;
> +
> +	return false;
> +}
> +EXPORT_SYMBOL(get_user_ro);

No need to export this function.

> +	p->policy = get_user_ro(disk, partno) ?: get_disk_ro(disk);

Can we avoid the obsfucating non-standard (GNU extension) use of ?: here?
Just use a local variable and a good old if.
