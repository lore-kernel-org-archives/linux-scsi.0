From: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>
Subject: Re: [PATCH 1/4] block: add zone open, close and finish support
Date: Mon, 24 Jun 2019 12:36:56 +0200
Message-ID: <2a60eeed-8b7e-13ac-78ed-04ed44e13bca@lightnvm.io>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-2-mb@lightnvm.io>
 <BYAPR04MB5816F7C8CA5B915DEEAF22D2E7E60@BYAPR04MB5816.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BYAPR04MB5816F7C8CA5B915DEEAF22D2E7E60@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 6/22/19 2:51 AM, Damien Le Moal wrote:
> Matias,
> 
> Some comments inline below.
> 
> On 2019/06/21 22:07, Matias Bjørling wrote:
>> From: Ajay Joshi <ajay.joshi@wdc.com>
>>
>> Zoned block devices allows one to control zone transitions by using
>> explicit commands. The available transitions are:
>>
>>    * Open zone: Transition a zone to open state.
>>    * Close zone: Transition a zone to closed state.
>>    * Finish zone: Transition a zone to full state.
>>
>> Allow kernel to issue these transitions by introducing
>> blkdev_zones_mgmt_op() and add three new request opcodes:
>>
>>    * REQ_IO_ZONE_OPEN, REQ_IO_ZONE_CLOSE, and REQ_OP_ZONE_FINISH
>>
>> Allow user-space to issue the transitions through the following ioctls:
>>
>>    * BLKOPENZONE, BLKCLOSEZONE, and BLKFINISHZONE.
>>
>> Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
>> Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
>> Signed-off-by: Matias Bjørling <matias.bjorling@wdc.com>
>> ---
>>   block/blk-core.c              |  3 ++
>>   block/blk-zoned.c             | 51 ++++++++++++++++++++++---------
>>   block/ioctl.c                 |  5 ++-
>>   include/linux/blk_types.h     | 27 +++++++++++++++--
>>   include/linux/blkdev.h        | 57 ++++++++++++++++++++++++++++++-----
>>   include/uapi/linux/blkzoned.h | 17 +++++++++--
>>   6 files changed, 133 insertions(+), 27 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 8340f69670d8..c0f0dbad548d 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -897,6 +897,9 @@ generic_make_request_checks(struct bio *bio)
>>   			goto not_supported;
>>   		break;
>>   	case REQ_OP_ZONE_RESET:
>> +	case REQ_OP_ZONE_OPEN:
>> +	case REQ_OP_ZONE_CLOSE:
>> +	case REQ_OP_ZONE_FINISH:
>>   		if (!blk_queue_is_zoned(q))
>>   			goto not_supported;
>>   		break;
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index ae7e91bd0618..d0c933593b93 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -201,20 +201,22 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>>   EXPORT_SYMBOL_GPL(blkdev_report_zones);
>>   
>>   /**
>> - * blkdev_reset_zones - Reset zones write pointer
>> + * blkdev_zones_mgmt_op - Perform the specified operation on the zone(s)
>>    * @bdev:	Target block device
>> - * @sector:	Start sector of the first zone to reset
>> - * @nr_sectors:	Number of sectors, at least the length of one zone
>> + * @op:		Operation to be performed on the zone(s)
>> + * @sector:	Start sector of the first zone to operate on
>> + * @nr_sectors:	Number of sectors, at least the length of one zone and
>> + *              must be zone size aligned.
>>    * @gfp_mask:	Memory allocation flags (for bio_alloc)
>>    *
>>    * Description:
>> - *    Reset the write pointer of the zones contained in the range
>> + *    Perform the specified operation contained in the range
> 	Perform the specified operation over the sector range
>>    *    @sector..@sector+@nr_sectors. Specifying the entire disk sector range
>>    *    is valid, but the specified range should not contain conventional zones.
>>    */
>> -int blkdev_reset_zones(struct block_device *bdev,
>> -		       sector_t sector, sector_t nr_sectors,
>> -		       gfp_t gfp_mask)
>> +int blkdev_zones_mgmt_op(struct block_device *bdev, enum req_opf op,
>> +			 sector_t sector, sector_t nr_sectors,
>> +			 gfp_t gfp_mask)
>>   {
>>   	struct request_queue *q = bdev_get_queue(bdev);
>>   	sector_t zone_sectors;
>> @@ -226,6 +228,9 @@ int blkdev_reset_zones(struct block_device *bdev,
>>   	if (!blk_queue_is_zoned(q))
>>   		return -EOPNOTSUPP;
>>   
>> +	if (!op_is_zone_mgmt_op(op))
>> +		return -EOPNOTSUPP;
> 
> EINVAL may be better here.
> 
>> +
>>   	if (bdev_read_only(bdev))
>>   		return -EPERM;
>>   
>> @@ -248,7 +253,7 @@ int blkdev_reset_zones(struct block_device *bdev,
>>   		bio = blk_next_bio(bio, 0, gfp_mask);
>>   		bio->bi_iter.bi_sector = sector;
>>   		bio_set_dev(bio, bdev);
>> -		bio_set_op_attrs(bio, REQ_OP_ZONE_RESET, 0);
>> +		bio_set_op_attrs(bio, op, 0);
>>   
>>   		sector += zone_sectors;
>>   
>> @@ -264,7 +269,7 @@ int blkdev_reset_zones(struct block_device *bdev,
>>   
>>   	return ret;
>>   }
>> -EXPORT_SYMBOL_GPL(blkdev_reset_zones);
>> +EXPORT_SYMBOL_GPL(blkdev_zones_mgmt_op);
>>   
>>   /*
>>    * BLKREPORTZONE ioctl processing.
>> @@ -329,15 +334,16 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
>>   }
>>   
>>   /*
>> - * BLKRESETZONE ioctl processing.
>> + * Zone operation (open, close, finish or reset) ioctl processing.
>>    * Called from blkdev_ioctl.
>>    */
>> -int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
>> -			     unsigned int cmd, unsigned long arg)
>> +int blkdev_zones_mgmt_op_ioctl(struct block_device *bdev, fmode_t mode,
>> +				unsigned int cmd, unsigned long arg)
>>   {
>>   	void __user *argp = (void __user *)arg;
>>   	struct request_queue *q;
>>   	struct blk_zone_range zrange;
>> +	enum req_opf op;
>>   
>>   	if (!argp)
>>   		return -EINVAL;
>> @@ -358,8 +364,25 @@ int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
>>   	if (copy_from_user(&zrange, argp, sizeof(struct blk_zone_range)))
>>   		return -EFAULT;
>>   
>> -	return blkdev_reset_zones(bdev, zrange.sector, zrange.nr_sectors,
>> -				  GFP_KERNEL);
>> +	switch (cmd) {
>> +	case BLKRESETZONE:
>> +		op = REQ_OP_ZONE_RESET;
>> +		break;
>> +	case BLKOPENZONE:
>> +		op = REQ_OP_ZONE_OPEN;
>> +		break;
>> +	case BLKCLOSEZONE:
>> +		op = REQ_OP_ZONE_CLOSE;
>> +		break;
>> +	case BLKFINISHZONE:
>> +		op = REQ_OP_ZONE_FINISH;
>> +		break;
>> +	default:
>> +		return -ENOTTY;
>> +	}
>> +
>> +	return blkdev_zones_mgmt_op(bdev, op, zrange.sector, zrange.nr_sectors,
>> +				    GFP_KERNEL);
>>   }
>>   
>>   static inline unsigned long *blk_alloc_zone_bitmap(int node,
>> diff --git a/block/ioctl.c b/block/ioctl.c
>> index 15a0eb80ada9..df7fe54db158 100644
>> --- a/block/ioctl.c
>> +++ b/block/ioctl.c
>> @@ -532,7 +532,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>>   	case BLKREPORTZONE:
>>   		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
>>   	case BLKRESETZONE:
>> -		return blkdev_reset_zones_ioctl(bdev, mode, cmd, arg);
>> +	case BLKOPENZONE:
>> +	case BLKCLOSEZONE:
>> +	case BLKFINISHZONE:
>> +		return blkdev_zones_mgmt_op_ioctl(bdev, mode, cmd, arg);
>>   	case BLKGETZONESZ:
>>   		return put_uint(arg, bdev_zone_sectors(bdev));
>>   	case BLKGETNRZONES:
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 95202f80676c..067ef9242275 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -284,13 +284,20 @@ enum req_opf {
>>   	REQ_OP_DISCARD		= 3,
>>   	/* securely erase sectors */
>>   	REQ_OP_SECURE_ERASE	= 5,
>> -	/* reset a zone write pointer */
>> -	REQ_OP_ZONE_RESET	= 6,
>>   	/* write the same sector many times */
>>   	REQ_OP_WRITE_SAME	= 7,
>>   	/* write the zero filled sector many times */
>>   	REQ_OP_WRITE_ZEROES	= 9,
>>   
>> +	/* reset a zone write pointer */
>> +	REQ_OP_ZONE_RESET	= 16,
>> +	/* Open zone(s) */
>> +	REQ_OP_ZONE_OPEN	= 17,
>> +	/* Close zone(s) */
>> +	REQ_OP_ZONE_CLOSE	= 18,
>> +	/* Finish zone(s) */
>> +	REQ_OP_ZONE_FINISH	= 19,
>> +
>>   	/* SCSI passthrough using struct scsi_request */
>>   	REQ_OP_SCSI_IN		= 32,
>>   	REQ_OP_SCSI_OUT		= 33,
>> @@ -375,6 +382,22 @@ static inline void bio_set_op_attrs(struct bio *bio, unsigned op,
>>   	bio->bi_opf = op | op_flags;
>>   }
>>   
>> +/*
>> + * Check if the op is zoned operation.
>        Check if op is a zone management operation.
>> + */
>> +static inline bool op_is_zone_mgmt_op(enum req_opf op)
> 
> Similarly to "op_is_write" pattern, "op_is_zone_mgmt" may be a better name.
> 
>> +{
>> +	switch (op) {
>> +	case REQ_OP_ZONE_RESET:
>> +	case REQ_OP_ZONE_OPEN:
>> +	case REQ_OP_ZONE_CLOSE:
>> +	case REQ_OP_ZONE_FINISH:
>> +		return true;
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>>   static inline bool op_is_write(unsigned int op)
>>   {
>>   	return (op & 1);
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 592669bcc536..943084f9dc9c 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -348,14 +348,15 @@ extern unsigned int blkdev_nr_zones(struct block_device *bdev);
>>   extern int blkdev_report_zones(struct block_device *bdev,
>>   			       sector_t sector, struct blk_zone *zones,
>>   			       unsigned int *nr_zones, gfp_t gfp_mask);
>> -extern int blkdev_reset_zones(struct block_device *bdev, sector_t sectors,
>> -			      sector_t nr_sectors, gfp_t gfp_mask);
>>   extern int blk_revalidate_disk_zones(struct gendisk *disk);
>>   
>>   extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
>>   				     unsigned int cmd, unsigned long arg);
>> -extern int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
>> -				    unsigned int cmd, unsigned long arg);
>> +extern int blkdev_zones_mgmt_op_ioctl(struct block_device *bdev, fmode_t mode,
>> +					unsigned int cmd, unsigned long arg);
>> +extern int blkdev_zones_mgmt_op(struct block_device *bdev, enum req_opf op,
>> +				sector_t sector, sector_t nr_sectors,
>> +				gfp_t gfp_mask);
> 
> To keep the grouping of declarations, may be declare this one where
> blkdev_reset_zones() was ?
> 
>>   
>>   #else /* CONFIG_BLK_DEV_ZONED */
>>   
>> @@ -376,15 +377,57 @@ static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
>>   	return -ENOTTY;
>>   }
>>   
>> -static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
>> -					   fmode_t mode, unsigned int cmd,
>> -					   unsigned long arg)
>> +static inline int blkdev_zones_mgmt_op_ioctl(struct block_device *bdev,
>> +					     fmode_t mode, unsigned int cmd,
>> +					     unsigned long arg)
>> +{
>> +	return -ENOTTY;
>> +}
>> +
>> +static inline int blkdev_zones_mgmt_op(struct block_device *bdev,
>> +				       enum req_opf op,
>> +				       sector_t sector, sector_t nr_sectors,
>> +				       gfp_t gfp_mask)
>>   {
>>   	return -ENOTTY;
> 
> That should be -ENOTSUPP. This is not an ioctl. The ioctl call is above this one.
> 
>>   }
>>   
>>   #endif /* CONFIG_BLK_DEV_ZONED */
>>   
>> +static inline int blkdev_reset_zones(struct block_device *bdev,
>> +				     sector_t sector, sector_t nr_sectors,
>> +				     gfp_t gfp_mask)
>> +{
>> +	return blkdev_zones_mgmt_op(bdev, REQ_OP_ZONE_RESET,
>> +				    sector, nr_sectors, gfp_mask);
>> +}
>> +
>> +static inline int blkdev_open_zones(struct block_device *bdev,
>> +				    sector_t sector, sector_t nr_sectors,
>> +				    gfp_t gfp_mask)
>> +{
>> +	return blkdev_zones_mgmt_op(bdev, REQ_OP_ZONE_OPEN,
>> +				    sector, nr_sectors, gfp_mask);
>> +}
>> +
>> +static inline int blkdev_close_zones(struct block_device *bdev,
>> +				     sector_t sector, sector_t nr_sectors,
>> +				     gfp_t gfp_mask)
>> +{
>> +	return blkdev_zones_mgmt_op(bdev, REQ_OP_ZONE_CLOSE,
>> +				    sector, nr_sectors,
>> +				    gfp_mask);
>> +}
>> +
>> +static inline int blkdev_finish_zones(struct block_device *bdev,
>> +				      sector_t sector, sector_t nr_sectors,
>> +				      gfp_t gfp_mask)
>> +{
>> +	return blkdev_zones_mgmt_op(bdev, REQ_OP_ZONE_FINISH,
>> +				    sector, nr_sectors,
>> +				    gfp_mask);
>> +}
>> +
>>   struct request_queue {
>>   	/*
>>   	 * Together with queue_head for cacheline sharing
>> diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
>> index 498eec813494..701e0692b8d3 100644
>> --- a/include/uapi/linux/blkzoned.h
>> +++ b/include/uapi/linux/blkzoned.h
>> @@ -120,9 +120,11 @@ struct blk_zone_report {
>>   };
>>   
>>   /**
>> - * struct blk_zone_range - BLKRESETZONE ioctl request
>> - * @sector: starting sector of the first zone to issue reset write pointer
>> - * @nr_sectors: Total number of sectors of 1 or more zones to reset
>> + * struct blk_zone_range - BLKRESETZONE/BLKOPENZONE/
>> + *			   BLKCLOSEZONE/BLKFINISHZONE ioctl
>> + *			   request
>> + * @sector: starting sector of the first zone to operate on
>> + * @nr_sectors: Total number of sectors of all zones to operate on
>>    */
>>   struct blk_zone_range {
>>   	__u64		sector;
>> @@ -139,10 +141,19 @@ struct blk_zone_range {
>>    *                sector range. The sector range must be zone aligned.
>>    * @BLKGETZONESZ: Get the device zone size in number of 512 B sectors.
>>    * @BLKGETNRZONES: Get the total number of zones of the device.
>> + * @BLKOPENZONE: Open the zones in the specified sector range. The
>> + *               sector range must be zone aligned.
>> + * @BLKCLOSEZONE: Close the zones in the specified sector range. The
>> + *                sector range must be zone aligned.
>> + * @BLKFINISHZONE: Finish the zones in the specified sector range. The
>> + *                 sector range must be zone aligned.
>>    */
>>   #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
>>   #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
>>   #define BLKGETZONESZ	_IOR(0x12, 132, __u32)
>>   #define BLKGETNRZONES	_IOR(0x12, 133, __u32)
>> +#define BLKOPENZONE	_IOW(0x12, 134, struct blk_zone_range)
>> +#define BLKCLOSEZONE	_IOW(0x12, 135, struct blk_zone_range)
>> +#define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
>>   
>>   #endif /* _UAPI_BLKZONED_H */
>>
> 
> 

Thanks Damien.

I was wondering if we should, instead of introducing three new ioctls, 
make a v2 of the zone mgmt API?

Something like the following data structure being passed from user-space:

struct blk_zone_mgmt {
	__u8		opcode;
	__u8 		resv[3];
	__u32		flags;
	__u64		sector;
	__u64		nr_sectors;
	__u64		resv1; /* to make room if we where do pass a data 			 
data pointer through this API */
};

-Matias
