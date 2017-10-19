From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sd: Micro-optimize READ / WRITE CDB encoding
Date: Thu, 19 Oct 2017 02:57:54 -0400
Message-ID: <63fc0a91-f95b-d558-f26d-4ba308c942ed@interlog.com>
References: <20171017210352.19580-1-bart.vanassche@wdc.com>
 <cb08e66f-c5a4-6eab-2306-8bcb3aeffb3b@interlog.com>
 <1508280078.3457.20.camel@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------0AE9B7B8EDA7EA6D261E5F64"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:45042 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751005AbdJSG6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Oct 2017 02:58:03 -0400
In-Reply-To: <1508280078.3457.20.camel@wdc.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

This is a multi-part message in MIME format.
--------------0AE9B7B8EDA7EA6D261E5F64
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2017-10-17 06:41 PM, Bart Van Assche wrote:
> On Tue, 2017-10-17 at 18:17 -0400, Douglas Gilbert wrote:
>> On 2017-10-17 05:03 PM, Bart Van Assche wrote:
>>> @@ -1025,7 +1025,6 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>>>    	struct gendisk *disk = rq->rq_disk;
>>>    	struct scsi_disk *sdkp = scsi_disk(disk);
>>>    	sector_t block = blk_rq_pos(rq);
>>
>> s/block/lba/		# use the well understood SCSI abbreviation
> 
> Since blk_rq_pos() returns the offset in units of 512 bytes, how about renaming
> 'block' into 'sector' and using the name 'lba' for the number obtained after the
> shift operation?
> 
>>
>>> -	sector_t threshold;
>>>    	unsigned int this_count = blk_rq_sectors(rq);
>>>    	unsigned int dif, dix;
>>>    	bool zoned_write = sd_is_zoned(sdkp) && rq_data_dir(rq) == WRITE;
>>> @@ -1071,20 +1070,22 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>>>    		goto out;
>>>    	}
>>>    
>>> -	/*
>>> -	 * Some SD card readers can't handle multi-sector accesses which touch
>>> -	 * the last one or two hardware sectors.  Split accesses as needed.
>>> -	 */
>>> -	threshold = get_capacity(disk) - SD_LAST_BUGGY_SECTORS *
>>> -		(sdp->sector_size / 512);
>>> +	if (unlikely(sdp->last_sector_bug)) {
>>> +		sector_t threshold;
>>
>> s/threshold/threshold_lba/	# a bit long but more precise
> 
> A similar comment applies here - shouldn't this be called 'threshold_sector'?
> 
>>>    		}
>>>    	}
>>>    	if (rq_data_dir(rq) == WRITE) {
>>> @@ -1173,56 +1157,26 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>>>    		SCpnt->cmnd[7] = 0x18;
>>>    		SCpnt->cmnd[9] = (rq_data_dir(rq) == READ) ? READ_32 : WRITE_32;
>>
>> Perhaps rq_data_dir(rq) could be placed in a local variable
> 
> I will keep that for a separate patch.

Bart,
Below is a rewrite of that function taking on board your ideas
and adding some of mine. It is inline in this post (but lines
are wrapped) and it is attached. It compiles.

The variable names are a little more descriptive (except
"last_lba" should be "first_lba_beyond_access") and more
state is cached in local variables (e.g. is_write).

Doug Gilbert


static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
{
         struct request *rq = SCpnt->request;
         struct scsi_device *sdp = SCpnt->device;
         struct gendisk *disk = rq->rq_disk;
         struct scsi_disk *sdkp = scsi_disk(disk);
         unsigned int num_blks = blk_rq_sectors(rq);
         unsigned int dif, dix;
         unsigned int sect_sz;
         sector_t lba = blk_rq_pos(rq);
         sector_t threshold;
         sector_t lu_capacity = get_capacity(disk);
         sector_t last_lba = lba + num_blks;
         bool is_write = (rq_data_dir(rq) == WRITE);
         bool zoned_write = sd_is_zoned(sdkp) && is_write;
         int ret;
         unsigned char protect;

         if (zoned_write) {
                 ret = sd_zbc_write_lock_zone(SCpnt);
                 if (ret != BLKPREP_OK)
                         return ret;
         }

         ret = scsi_init_io(SCpnt);
         if (ret != BLKPREP_OK)
                 goto out;
         SCpnt = rq->special;

         /* from here on until we're complete, any goto out
          * is used for a killable error condition */
         ret = BLKPREP_KILL;

         SCSI_LOG_HLQUEUE(1,
                 scmd_printk(KERN_INFO, SCpnt,
                         "%s: lba=%llu, count=%d\n",
                         __func__, (unsigned long long)lba, num_blks));

         if (likely(sdp && scsi_device_online(sdp) &&
                    (last_lba <= lu_capacity)))
                 ; /* ok: have device, its online and access fits on medium */
         else {
                 SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
                                                 "Finishing %u sectors\n",
                                                 num_blks));
                 SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
                                                 "Retry with 0x%p\n", SCpnt));
                 goto out;
         }
         sect_sz = sdp->sector_size;

         if (unlikely(sdp->changed)) {
                 /*
                  * quietly refuse to do anything to a changed disc until
                  * the changed bit has been reset
                  */
                 /* printk("SCSI disk has been changed or is not present. 
Prohibiting further I/O.\n"); */
                 goto out;
         }

         /*
          * Some SD card readers can't handle multi-sector accesses which touch
          * the last one or two hardware sectors.  Split accesses as needed.
          */
         if (unlikely(sdp->last_sector_bug)) {
                 threshold = lu_capacity -
                             (SD_LAST_BUGGY_SECTORS * (sect_sz / 512));

                 if (unlikely(last_lba > threshold))
                         num_blks = (lba < threshold) ? (threshold - lba) :
                                                 (sect_sz / 512);
                         /* If LBA less than threshold the access up to the
                          * threshold but not beyond; otherwise access only
                          * a single hardware sector. */
         }

         SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "lba=%llu\n",
                                         (unsigned long long)num_blks));

         /*
          * If we have a 1K hardware sectorsize, prevent access to single
          * 512 byte sectors.  In theory we could handle this - in fact
          * the scsi cdrom driver must be able to handle this because
          * we typically use 1K blocksizes, and cdroms typically have
          * 2K hardware sectorsizes.  Of course, things are simpler
          * with the cdrom, since it is read-only.  For performance
          * reasons, the filesystems should be able to handle this
          * and not force the scsi disk driver to use bounce buffers
          * for this.
          */
         if (sect_sz != 512) {
                 if ((lba | num_blks) & (sect_sz / 512 - 1)) {
                         scmd_printk(KERN_ERR, SCpnt,
                                     "Bad lba requested: lba = %llu, sector 
count = %u, sector size = %u bytes\n",
                                     lba + 0ULL, num_blks, sect_sz);
                         goto out;
                 } else {
                         int shift = ilog2(sect_sz / 512);

                         lba >>= shift;
                         num_blks >>= shift;
                 }
         }

         if (is_write) {
                 if (blk_integrity_rq(rq))
                         sd_dif_prepare(SCpnt);

         } else if (rq_data_dir(rq) != READ) {
                 scmd_printk(KERN_ERR, SCpnt, "Unknown command %d\n", req_op(rq));
                 goto out;
         }

         SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
                                         "%s %d/%u 512 byte blocks.\n",
                                         is_write ?  "writing" : "reading",
                                         num_blks, blk_rq_sectors(rq)));

         dix = scsi_prot_sg_count(SCpnt);
         dif = scsi_host_dif_capable(SCpnt->device->host, sdkp->protection_type);

         if (dif || dix)
                 protect = sd_setup_protect_cmnd(SCpnt, dix, dif);
         else
                 protect = 0;

         if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
                 SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);

                 if (unlikely(SCpnt->cmnd == NULL)) {
                         ret = BLKPREP_DEFER;
                         goto out;
                 }

                 SCpnt->cmd_len = SD_EXT_CDB_SIZE;
                 memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
                 SCpnt->cmnd[0] = VARIABLE_LENGTH_CMD;
                 SCpnt->cmnd[7] = 0x18;
                 SCpnt->cmnd[9] = is_write ? WRITE_32 : READ_32;
                 SCpnt->cmnd[10] = protect;
                 if (unlikely(rq->cmd_flags & REQ_FUA))
                         SCpnt->cmnd[10] |= 0x8;
                 put_unaligned_be64(lba, SCpnt->cmnd + 12);

                 /* Expected initial LB reference tag: lower 4 bytes of LBA */
                 put_unaligned_be32(lba, SCpnt->cmnd + 20);
                 /* Leave Expected LB application tag and LB application tag 
mask zeroed */

                 /* Transfer length */
                 put_unaligned_be32(num_blks, SCpnt->cmnd + 28);
         } else if (sdp->use_16_for_rw || unlikely(num_blks > 0xffff)) {
                 SCpnt->cmnd[0] = is_write ? WRITE_16 : READ_16;
                 SCpnt->cmnd[1] = protect;
                 if (unlikely(rq->cmd_flags & REQ_FUA))
                         SCpnt->cmnd[1] |= 0x8;
                 put_unaligned_be64(lba, SCpnt->cmnd + 2);
                 put_unaligned_be32(num_blks, SCpnt->cmnd + 10);
                 SCpnt->cmnd[14] = 0;
                 SCpnt->cmnd[15] = 0;
         } else if (SCpnt->device->use_10_for_rw || (num_blks > 0xff) ||
                    (lba > 0x1fffff) || scsi_device_protection(SCpnt->device)) {
                 SCpnt->cmnd[0] = is_write ? WRITE_10 : READ_10;
                 SCpnt->cmnd[1] = protect;
                 if (unlikely(rq->cmd_flags & REQ_FUA))
                         SCpnt->cmnd[1] |= 0x8;
                 put_unaligned_be32(lba, SCpnt->cmnd + 2);
                 SCpnt->cmnd[6] = 0;
                 put_unaligned_be16(num_blks, SCpnt->cmnd + 7);
                 SCpnt->cmnd[9] = 0;
         } else {
                 if (unlikely(rq->cmd_flags & REQ_FUA)) {
                         /*
                          * This happens only if this drive failed
                          * 10byte rw command with ILLEGAL_REQUEST
                          * during operation and thus turned off
                          * use_10_for_rw.
                          */
                         scmd_printk(KERN_ERR, SCpnt,
                                     "FUA write on READ/WRITE(6) drive\n");
                         goto out;
                 }
                 /* rely on lba <= 0x1fffff */
                 put_unaligned_be32(lba, SCpnt->cmnd + 0);
                 SCpnt->cmnd[0] = is_write ? WRITE_6 : READ_6;
                 SCpnt->cmnd[4] = (unsigned char) num_blks;
                 SCpnt->cmnd[5] = 0;
         }
         SCpnt->sdb.length = num_blks * sect_sz;

         /*
          * We shouldn't disconnect in the middle of a sector, so with a dumb
          * host adapter, it's safe to assume that we can at least transfer
          * this many bytes between each connect / disconnect.
          */
         SCpnt->transfersize = sect_sz;
         SCpnt->underflow = num_blks << 9;
         SCpnt->allowed = SD_MAX_RETRIES;

         /*
          * This indicates that the command is ready from our end to be
          * queued.
          */
         ret = BLKPREP_OK;
  out:
         if (zoned_write && ret != BLKPREP_OK)
                 sd_zbc_write_unlock_zone(SCpnt);

         return ret;
}

--------------0AE9B7B8EDA7EA6D261E5F64
Content-Type: text/x-csrc;
 name="sd_setup_rw_cmd.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sd_setup_rw_cmd.c"


static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
{
	struct request *rq = SCpnt->request;
	struct scsi_device *sdp = SCpnt->device;
	struct gendisk *disk = rq->rq_disk;
	struct scsi_disk *sdkp = scsi_disk(disk);
	unsigned int num_blks = blk_rq_sectors(rq);
	unsigned int dif, dix;
	unsigned int sect_sz;
	sector_t lba = blk_rq_pos(rq);
	sector_t threshold;
	sector_t lu_capacity = get_capacity(disk);
	sector_t last_lba = lba + num_blks;
	bool is_write = (rq_data_dir(rq) == WRITE);
	bool zoned_write = sd_is_zoned(sdkp) && is_write;
	int ret;
	unsigned char protect;

	if (zoned_write) {
		ret = sd_zbc_write_lock_zone(SCpnt);
		if (ret != BLKPREP_OK)
			return ret;
	}

	ret = scsi_init_io(SCpnt);
	if (ret != BLKPREP_OK)
		goto out;
	SCpnt = rq->special;

	/* from here on until we're complete, any goto out
	 * is used for a killable error condition */
	ret = BLKPREP_KILL;

	SCSI_LOG_HLQUEUE(1,
		scmd_printk(KERN_INFO, SCpnt,
			"%s: lba=%llu, count=%d\n",
			__func__, (unsigned long long)lba, num_blks));

	if (likely(sdp && scsi_device_online(sdp) &&
		   (last_lba <= lu_capacity)))
       		; /* ok: have device, its online and access fits on medium */
	else {
		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
						"Finishing %u sectors\n",
						num_blks));
		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
						"Retry with 0x%p\n", SCpnt));
		goto out;
	}
	sect_sz = sdp->sector_size;

	if (unlikely(sdp->changed)) {
		/*
		 * quietly refuse to do anything to a changed disc until 
		 * the changed bit has been reset
		 */
		/* printk("SCSI disk has been changed or is not present. Prohibiting further I/O.\n"); */
		goto out;
	}

	/*
	 * Some SD card readers can't handle multi-sector accesses which touch
	 * the last one or two hardware sectors.  Split accesses as needed.
	 */
	if (unlikely(sdp->last_sector_bug)) {
		threshold = lu_capacity -
			    (SD_LAST_BUGGY_SECTORS * (sect_sz / 512));

		if (unlikely(last_lba > threshold))
			num_blks = (lba < threshold) ? (threshold - lba) :
						(sect_sz / 512);
			/* If LBA less than threshold the access up to the
			 * threshold but not beyond; otherwise access only
			 * a single hardware sector. */
	}

	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "lba=%llu\n",
					(unsigned long long)num_blks));

	/*
	 * If we have a 1K hardware sectorsize, prevent access to single
	 * 512 byte sectors.  In theory we could handle this - in fact
	 * the scsi cdrom driver must be able to handle this because
	 * we typically use 1K blocksizes, and cdroms typically have
	 * 2K hardware sectorsizes.  Of course, things are simpler
	 * with the cdrom, since it is read-only.  For performance
	 * reasons, the filesystems should be able to handle this
	 * and not force the scsi disk driver to use bounce buffers
	 * for this.
	 */
	if (sect_sz != 512) {
		if ((lba | num_blks) & (sect_sz / 512 - 1)) {
			scmd_printk(KERN_ERR, SCpnt,
				    "Bad lba requested: lba = %llu, sector count = %u, sector size = %u bytes\n",
				    lba + 0ULL, num_blks, sect_sz);
			goto out;
		} else {
			int shift = ilog2(sect_sz / 512);

			lba >>= shift;
			num_blks >>= shift;
		}
	}

	if (is_write) {
		if (blk_integrity_rq(rq))
			sd_dif_prepare(SCpnt);

	} else if (rq_data_dir(rq) != READ) {
		scmd_printk(KERN_ERR, SCpnt, "Unknown command %d\n", req_op(rq));
		goto out;
	}

	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
					"%s %d/%u 512 byte blocks.\n",
					is_write ?  "writing" : "reading",
				       	num_blks, blk_rq_sectors(rq)));

	dix = scsi_prot_sg_count(SCpnt);
	dif = scsi_host_dif_capable(SCpnt->device->host, sdkp->protection_type);

	if (dif || dix)
		protect = sd_setup_protect_cmnd(SCpnt, dix, dif);
	else
		protect = 0;

	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);

		if (unlikely(SCpnt->cmnd == NULL)) {
			ret = BLKPREP_DEFER;
			goto out;
		}

		SCpnt->cmd_len = SD_EXT_CDB_SIZE;
		memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
		SCpnt->cmnd[0] = VARIABLE_LENGTH_CMD;
		SCpnt->cmnd[7] = 0x18;
		SCpnt->cmnd[9] = is_write ? WRITE_32 : READ_32;
		SCpnt->cmnd[10] = protect;
		if (unlikely(rq->cmd_flags & REQ_FUA))
			SCpnt->cmnd[10] |= 0x8;
		put_unaligned_be64(lba, SCpnt->cmnd + 12);

		/* Expected initial LB reference tag: lower 4 bytes of LBA */
		put_unaligned_be32(lba, SCpnt->cmnd + 20);
		/* Leave Expected LB application tag and LB application tag mask zeroed */

		/* Transfer length */
		put_unaligned_be32(num_blks, SCpnt->cmnd + 28);
	} else if (sdp->use_16_for_rw || unlikely(num_blks > 0xffff)) {
		SCpnt->cmnd[0] = is_write ? WRITE_16 : READ_16;
		SCpnt->cmnd[1] = protect;
	        if (unlikely(rq->cmd_flags & REQ_FUA))
			SCpnt->cmnd[1] |= 0x8;
		put_unaligned_be64(lba, SCpnt->cmnd + 2);
		put_unaligned_be32(num_blks, SCpnt->cmnd + 10);
		SCpnt->cmnd[14] = 0;
	       	SCpnt->cmnd[15] = 0;
	} else if (SCpnt->device->use_10_for_rw || (num_blks > 0xff) ||
	       	   (lba > 0x1fffff) || scsi_device_protection(SCpnt->device)) {
		SCpnt->cmnd[0] = is_write ? WRITE_10 : READ_10;
		SCpnt->cmnd[1] = protect;
	        if (unlikely(rq->cmd_flags & REQ_FUA))
			SCpnt->cmnd[1] |= 0x8;
		put_unaligned_be32(lba, SCpnt->cmnd + 2);
		SCpnt->cmnd[6] = 0;
		put_unaligned_be16(num_blks, SCpnt->cmnd + 7);
		SCpnt->cmnd[9] = 0;
	} else {
		if (unlikely(rq->cmd_flags & REQ_FUA)) {
			/*
			 * This happens only if this drive failed
			 * 10byte rw command with ILLEGAL_REQUEST
			 * during operation and thus turned off
			 * use_10_for_rw.
			 */
			scmd_printk(KERN_ERR, SCpnt,
				    "FUA write on READ/WRITE(6) drive\n");
			goto out;
		}
		/* rely on lba <= 0x1fffff */
		put_unaligned_be32(lba, SCpnt->cmnd + 0);
		SCpnt->cmnd[0] = is_write ? WRITE_6 : READ_6;
		SCpnt->cmnd[4] = (unsigned char) num_blks;
		SCpnt->cmnd[5] = 0;
	}
	SCpnt->sdb.length = num_blks * sect_sz;

	/*
	 * We shouldn't disconnect in the middle of a sector, so with a dumb
	 * host adapter, it's safe to assume that we can at least transfer
	 * this many bytes between each connect / disconnect.
	 */
	SCpnt->transfersize = sect_sz;
	SCpnt->underflow = num_blks << 9;
	SCpnt->allowed = SD_MAX_RETRIES;

	/*
	 * This indicates that the command is ready from our end to be
	 * queued.
	 */
	ret = BLKPREP_OK;
 out:
	if (zoned_write && ret != BLKPREP_OK)
		sd_zbc_write_unlock_zone(SCpnt);

	return ret;
}


--------------0AE9B7B8EDA7EA6D261E5F64--
