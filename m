From: Tejun Heo <htejun@gmail.com>
Subject: Re: Boot failure with block/for-next
Date: Wed, 22 Dec 2010 18:53:19 +0100
Message-ID: <20101222175319.GA1787@htj.dyndns.org>
References: <1293038823.3019.89.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1293038823.3019.89.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Wed, Dec 22, 2010 at 11:27:03AM -0600, James Bottomley wrote:
> Trying to test out the SCSI post merge tree, I've found it won't boot on
> my SCSI test system.  The reason is a failure to read the partition
> table of the root disc.  It just gives
> 
> sda: unable to read partition table
> 
> The other four discs in the system seem to read their partition tables
> OK.

That's really weird.

> The obvious candidate is the partition code rework in block/for-next.
> Simply reverting 
> 
> commit d2bf1b6723ed0eab378363649d15b7893bf14e91
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Dec 8 20:57:36 2010 +0100
> 
>     block: move register_disk() and del_gendisk() to block/genhd.c
>  
> Doesn't fix the boot failure, so it's obviously something deeper.

Can you please apply the following patch and see what the kernel says?

Thanks.

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index bdf8d3c..dd0b0f3 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -186,6 +186,8 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 			/* We have hit an I/O error which we don't report now.
 		 	* But record it, and let the others do their job.
 		 	*/
+			printk(KERN_WARNING "XXX %s: check_part %pf failed with %d\n",
+			       state->name, check_part[i-1], res);
 			err = res;
 			res = 0;
 		}
@@ -197,8 +199,11 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 		free_page((unsigned long)state->pp_buf);
 		return state;
 	}
-	if (state->access_beyond_eod)
+	if (state->access_beyond_eod) {
+		printk(KERN_WARNING "XXX %s: access_beyond_eod, err=-ENOSPC\n",
+		       state->name);
 		err = -ENOSPC;
+	}
 	if (err)
 	/* The partition is unrecognized. So report I/O errors if there were any */
 		res = err;
diff --git a/fs/partitions/check.h b/fs/partitions/check.h
index d68bf4d..f836fb2 100644
--- a/fs/partitions/check.h
+++ b/fs/partitions/check.h
@@ -26,6 +26,8 @@ static inline void *read_part_sector(struct parsed_partitions *state,
 				     sector_t n, Sector *p)
 {
 	if (n >= get_capacity(state->bdev->bd_disk)) {
+		printk(KERN_WARNING "XXX %s: setting access_beyond_eod for sector %llu\n",
+		       state->name, (unsigned long long)n);
 		state->access_beyond_eod = true;
 		return NULL;
 	}
