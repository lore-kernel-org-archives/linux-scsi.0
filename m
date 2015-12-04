From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 2/3] block: Add badblock management for gendisks
Date: Fri, 04 Dec 2015 15:33:38 -0800
Message-ID: <1449272018.27077.29.camel@HansenPartnership.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-3-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448477013-9174-3-git-send-email-vishal.l.verma@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-25 at 11:43 -0700, Vishal Verma wrote:
> NVDIMM devices, which can behave more like DRAM rather than block
> devices, may develop bad cache lines, or 'poison'. A block device
> exposed by the pmem driver can then consume poison via a read (or
> write), and cause a machine check. On platforms without machine
> check recovery features, this would mean a crash.
> 
> The block device maintaining a runtime list of all known sectors that
> have poison can directly avoid this, and also provide a path forward
> to enable proper handling/recovery for DAX faults on such a device.
> 
> Use the new badblock management interfaces to add a badblocks list to
> gendisks.
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  block/genhd.c         | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/genhd.h |  6 ++++
>  2 files changed, 87 insertions(+)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 0c706f3..84fd65c 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -20,6 +20,7 @@
>  #include <linux/idr.h>
>  #include <linux/log2.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/badblocks.h>
>  
>  #include "blk.h"
>  
> @@ -505,6 +506,20 @@ static int exact_lock(dev_t devt, void *data)
>  	return 0;
>  }
>  
> +static void disk_alloc_badblocks(struct gendisk *disk)
> +{
> +	disk->bb = kzalloc(sizeof(*(disk->bb)), GFP_KERNEL);
> +	if (!disk->bb) {
> +		pr_warn("%s: failed to allocate space for badblocks\n",
> +			disk->disk_name);
> +		return;
> +	}
> +
> +	if (badblocks_init(disk->bb, 1))
> +		pr_warn("%s: failed to initialize badblocks\n",
> +			disk->disk_name);
> +}
> +
>  static void register_disk(struct gendisk *disk)
>  {
>  	struct device *ddev = disk_to_dev(disk);
> @@ -609,6 +624,7 @@ void add_disk(struct gendisk *disk)
>  	disk->first_minor = MINOR(devt);
>  
>  	disk_alloc_events(disk);
> +	disk_alloc_badblocks(disk);

Why unconditionally do this?  No-one currently uses the interface, but
every disk will now pay the price of an additional structure plus a page
for no benefit.  You should probably either export the initializer for
those who want to use it or, perhaps even better, make it lazily
allocated the first time anyone tries to set a bad block.

If you come up with a really good reason for allocating it
unconditionally, then it should probably be an embedded structure in the
gendisk.

James


