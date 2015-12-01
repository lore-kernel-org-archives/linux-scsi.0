From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 3/3] md: convert to use the generic badblocks code
Date: Tue, 1 Dec 2015 10:55:18 -0800
Message-ID: <20151201185518.GA13926@kernel.org>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
 <1448477013-9174-4-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448477013-9174-4-git-send-email-vishal.l.verma@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 25, 2015 at 11:43:33AM -0700, Vishal Verma wrote:
> Retain badblocks as part of rdev, but use the accessor functions from
> include/linux/badblocks for all manipulation.
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/md/md.c | 507 +++-----------------------------------------------------
>  drivers/md/md.h |  40 +----
>  2 files changed, 23 insertions(+), 524 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c702de1..63eab20 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -34,6 +34,7 @@
>  
>  #include <linux/kthread.h>
>  #include <linux/blkdev.h>
> +#include <linux/badblocks.h>
>  #include <linux/sysctl.h>
>  #include <linux/seq_file.h>
>  #include <linux/fs.h>
> @@ -707,8 +708,7 @@ void md_rdev_clear(struct md_rdev *rdev)
>  		put_page(rdev->bb_page);
>  		rdev->bb_page = NULL;
>  	}
> -	kfree(rdev->badblocks.page);
> -	rdev->badblocks.page = NULL;
> +	badblocks_free(&rdev->badblocks);
>  }

why does rdev have extra badblocks? the gendisk already had one.
