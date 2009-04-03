From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Fri, 03 Apr 2009 05:38:41 -0400
Message-ID: <49D5D921.6080904@garzik.org>
References: <20090402015455.GA14087@havoc.gtf.org> <49D4AF12.40708@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49D4AF12.40708@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: open-osd mailing-list <osd-dev@open-osd.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> I have taken that to my heart and will submit patches for that, next week.
> Including a complimentary patch to this driver. These changes are only
> intended for 2.6.31 though.

Consolidation of common code should occur after osdblk is in one of: 
open-osd.git, scsi-misc.git, or linux-2.6.git.

That way, the code movement can be consolidated into a single changeset, 
touching exofs, osdblk and libosd all at the same time...
	-exofs code
	-osdblk code
	+libosd code


> I also want to add a small utility that can manage objects, create, size,
> remove, and mount as a complimentary wrapper for this driver is "osdblk"
> a good name for such utility?

osdblk intentionally maintains -zero- metadata on its own.  Therefore, 
this utility you propose can be completely generic.  You could call it 
"osdobjutil", because it need not be tied to the osdblk driver.

The osdblk driver needs the following from the utility:

- create object of specified size

- delete object

and optionally:
- resize object to new size

There is no need for a mount operation, because this is handled through 
class_osdblk_add()


>> +static int osdblk_get_obj_size(struct osdblk_device *osdev, u64 *size_out)
>> +{
>> +	struct osd_request *or;
>> +	struct osd_attr attr;
>> +	int ret;
>> +
>> +	osd_make_credential(osdev->obj_cred, &osdev->obj);
>> +
> 
> -	osd_make_credential(osdev->obj_cred, &osdev->obj);
> see below

fixed


>> +static void osdblk_osd_complete(struct osd_request *or, void *private)
>> +{
>> +	struct osdblk_request *orq = private;
>> +	struct osd_sense_info osi;
>> +	int ret = osd_req_decode_sense(or, &osi);
>> +
>> +	if (ret)
>> +		ret = -EIO;
>> +
>> +	osd_end_request(or);
>> +	osdblk_end_request(orq->osdev, orq, ret);
> 
> should be reversed, very bad things will happen otherwise
> 
> +	osdblk_end_request(orq->osdev, orq, ret);
> +	osd_end_request(or);

Perhaps you are confusing two different 'struct request' in use?

	- struct request, passed to osdblk for execution
	- struct request, used by libosd to pass commands

The object lifetime of the struct request stored in 'orq' is longer than 
the lifetime of the osd_request:

	1) block layer passes 'rq' to osdblk
	2) osdblk creates new 'or', passes 'or' to libosd
	3) libosd calls osdblk completion function
	4) osdblk completes 'or'
	5) osdblk completes 'rq'

As you can see, the object lifetime of 'or' is entirely within 'rq'.


>> +		orq = &osdev->req[rq_idx];
>> +		orq->tag = rq_idx;
>> +		orq->rq = rq;
>> +		orq->bio = bio;
>> +		orq->osdev = osdev;
>> +
>> +		blkdev_dequeue_request(rq);
>> +
>> +		osd_make_credential(orq->cred, &osdev->obj);
> 
> -		osd_make_credential(orq->cred, &osdev->obj);
> 
> Don't do this here do it once on mount. The creds, once we define
> the credential-manager protocol will have to be acquired at the begging.
> (See below)
> 
> At much later stage, the credential-manager API will be able to callback
> credentials and clients will need to reacquire them, or on credentials error
> returns from I/O.

fixed


>> +
>> +		or = osd_start_request(osdev->osd, GFP_NOIO);
>> +		if (!or) {
>> +			blk_requeue_request(q, rq);
>> +			bio_put(bio);
>> +			break;
>> +		}
>> +
>> +		if (do_write)
>> +			osd_req_write(or, &osdev->obj, bio,
>> +				      rq->sector * 512ULL);
>> +		else
>> +			osd_req_read(or, &osdev->obj, bio,
>> +				     rq->sector * 512ULL);
>> +
>> +		if (osd_async_op(or, osdblk_osd_complete, orq, orq->cred)) {
>> +			/* FIXME: leak OSD request 'or' ? */
> 
> yes a leak
> 
>> +			blk_requeue_request(q, rq);
> 	
> +			or->request = NULL;

already fixed, long before writing this email :)


>> +			bio_put(bio);
>> +		}
>> +	}
>> +}
>> +
>> +static void osdblk_free_disk(struct osdblk_device *osdev)
>> +{
>> +	struct gendisk *disk = osdev->disk;
>> +
>> +	if (!disk)
>> +		return;
>> +
>> +	if (disk->flags & GENHD_FL_UP)
>> +		del_gendisk(disk);
>> +	if (disk->queue)
>> +		blk_cleanup_queue(disk->queue);
>> +	put_disk(disk);
>> +}
>> +
>> +static int osdblk_init_disk(struct osdblk_device *osdev)
>> +{
>> +	struct gendisk *disk;
>> +	struct request_queue *q;
>> +	int rc;
>> +	u64 obj_size = 0;
>> +
> 
> +	osd_make_credential(osdev->obj_cred, &osdev->obj);
> 
> Later, when credential-manager is used, this will get expensive and sleepy
> possibly going on the network and back.

fixed


>> +	if (idx == OSDBLK_MAX_DEVS) {
>> +		rc = -ENOSPC;
>> +		goto err_out;
>> +	}
>> +
>> +	if (sscanf(buf, "%lu %lu %s", &osdev->part_id, &osdev->obj_id,
> 
> -	if (sscanf(buf, "%lu %lu %s", &osdev->part_id, &osdev->obj_id,
> +	if (sscanf(buf, "%llu %llu %s", &osdev->obj.partition, &osdev->obj.id,
> 
>> +		   osdev->osd_path) != 3) {
>> +		rc = -EINVAL;
>> +		goto err_out_slot;
>> +	}
>> +
>> +	osdev->obj.partition = osdev->part_id;
>> +	osdev->obj.id = osdev->obj_id;
> 
> -	osdev->obj.partition = osdev->part_id;
> -	osdev->obj.id = osdev->obj_id;
> 
> osdev->obj_id, and osdev->part_id can be removed.

done


> What can I say, great stuff.
> 
> OSD is a very clean API, that makes whole subsystems look trivial.

I appreciate it, thanks for the review.

	Jeff



