From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] scsi_data_buffer
Date: Thu, 08 Nov 2007 11:24:36 +0200
Message-ID: <4732D5D4.9030109@panasas.com>
References: <4730ACAA.2060007@panasas.com>	<4730B034.6050309@panasas.com> <20071108121435S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa3.bezeqint.net ([192.115.104.17]:59472 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbXKHJYq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 04:24:46 -0500
In-Reply-To: <20071108121435S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com

On Thu, Nov 08 2007 at 5:14 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Tue, 06 Nov 2007 20:19:32 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
<snip>
> 
> Hmm, checkpatch.pl complains reasonably:
> 
> ./scripts/checkpatch.pl ~/Mail/kernel/scsi/28815
> ERROR: use tabs not spaces
> #177: FILE: drivers/scsi/scsi_error.c:629:
> +^I^I                                       scmd->sdb.length);$
> 
> ERROR: use tabs not spaces
> #237: FILE: drivers/scsi/scsi_lib.c:741:
> +                                       unsigned short sg_count, gfp_t gfp_mask)$
> 
> WARNING: no space between function name and open parenthesis '('
> #487: FILE: drivers/scsi/sr.c:377:
> +               scsi_for_each_sg (SCpnt, sg, sg_count, i)
> 
> ERROR: "foo* bar" should be "foo *bar"
> #563: FILE: include/scsi/scsi_cmnd.h:20:
> +       struct scatterlist* sglist;
> 
> total: 3 errors, 1 warnings, 482 lines checked
I think that checkpatch is wrong in two accounts.
1. Tabs are used for "Indents" not "align-to-the-right".
   All above have 0 indent and are right aligned for
   readability.
2. check patch should be fixed that if a macro is followed
   by a "{" it means a control block and not a function-call/
   macro-expansion, and a space is recommended.
   (Like: for, if, while ...)

  But I don't mind. I'll change all in a fixing patch.
> 
> 
<snip>

>> @@ -821,24 +820,24 @@ enomem:
>>  
>>  		mempool_free(prev, sgp->pool);
>>  	}
>> -	return NULL;
>> +	return -1;
> 
> I think that -ENOMEM is better. The other functions in scsi_lib.c
> (even static functions) use proper error values.
> 
> 
will fix, thanks.

<snip>
>> -	/*
>> -	 * If sg table allocation fails, requeue request later.
>> -	 */
>> -	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
>> -	if (unlikely(!cmd->request_buffer)) {
>> +	if (scsi_alloc_sgtable(sdb, req->nr_phys_segments, gfp_mask)) {
> 
> IIRC, preferable style is:
> 
> 	ret = scsi_alloc_sgtable(sdb, req->nr_phys_segments, gfp_mask);
> 	if (ret) {
> 
> 
It is more readable I agree, but I did not want to allocate one more
stack variable just for the if(), since I am returning a BLKPREP_DEFER
any way. I am not using ret for anything else.

>>  		scsi_unprep_request(req);
>>  		return BLKPREP_DEFER;
>>  	}
>>  
>>  	req->buffer = NULL;
>>  	if (blk_pc_request(req))
>> -		cmd->request_bufflen = req->data_len;
>> +		sdb->length = req->data_len;
>>  	else
>> -		cmd->request_bufflen = req->nr_sectors << 9;
>> +		sdb->length = req->nr_sectors << 9;
>>  
>>  	/* 
>>  	 * Next, walk the list, and fill in the addresses and sizes of
>>  	 * each segment.
>>  	 */
>> -	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
>> -	if (likely(count <= cmd->use_sg)) {
>> -		cmd->use_sg = count;
>> +	count = blk_rq_map_sg(req->q, req, sdb->sglist);
>> +	if (likely(count <= sdb->sg_count)) {
>> +		sdb->sg_count = count;
>>  		return BLKPREP_OK;
>>  	}
>>  
>>  	printk(KERN_ERR "Incorrect number of segments after building list\n");
>> -	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
>> +	printk(KERN_ERR "counted %d, received %d\n", count, sdb->sg_count);
>>  	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
>>  			req->current_nr_sectors);
>>  
>> @@ -1199,9 +1182,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>>  		BUG_ON(req->data_len);
>>  		BUG_ON(req->data);
>>  
>> -		cmd->request_bufflen = 0;
>> -		cmd->request_buffer = NULL;
>> -		cmd->use_sg = 0;
>> +		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
>>  		req->buffer = NULL;
>>  	}
>>  

>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 18343a6..28cf6fe 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -448,9 +448,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>>  	} else if (rq_data_dir(rq) == READ) {
>>  		SCpnt->cmnd[0] = READ_6;
>>  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
>> -	} else {
>> -		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
>> -		goto out;
> 
> This should go to the bidi patch?
> 
>>  	}
>>  
This is just a dead code cleanup. It is got nothing to do with bidi or scsi_data_buffer
for that matter. It could be in it's own patch, but surly it will not go into the bidi
patch. I will submit a new patch just for that code. Independent of these.
(I was hoping to save the extra effort)

>>  	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
>> @@ -510,7 +507,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>>  		SCpnt->cmnd[4] = (unsigned char) this_count;
>>  		SCpnt->cmnd[5] = 0;
>>  	}
>> -	SCpnt->request_bufflen = this_count * sdp->sector_size;
>> +	SCpnt->sdb.length = this_count * sdp->sector_size;
>>  
>>  	/*
>>  	 * We shouldn't disconnect in the middle of a sector, so with a dumb
>> @@ -910,7 +907,7 @@ static struct block_device_operations sd_fops = {
>>  static int sd_done(struct scsi_cmnd *SCpnt)
>>  {
>>  	int result = SCpnt->result;
>> - 	unsigned int xfer_size = SCpnt->request_bufflen;
>> +	unsigned int xfer_size = scsi_bufflen(SCpnt);
>>   	unsigned int good_bytes = result ? 0 : xfer_size;
>>   	u64 start_lba = SCpnt->request->sector;
>>   	u64 bad_lba;
>> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
>> index 7702681..6d3bf41 100644
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>> @@ -226,7 +226,7 @@ out:
>>  static int sr_done(struct scsi_cmnd *SCpnt)
>>  {
>>  	int result = SCpnt->result;
>> -	int this_count = SCpnt->request_bufflen;
>> +	int this_count = scsi_bufflen(SCpnt);
>>  	int good_bytes = (result == 0 ? this_count : 0);
>>  	int block_sectors = 0;
>>  	long error_sector;
>> @@ -368,23 +368,21 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
>>  	} else if (rq_data_dir(rq) == READ) {
>>  		SCpnt->cmnd[0] = READ_10;
>>  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
>> -	} else {
>> -		blk_dump_rq_flags(rq, "Unknown sr command");
>> -		goto out;
> 
> Ditto.
> 
Ditto

> 
>>  	}
>>  
>>  	{
>> -		struct scatterlist *sg = SCpnt->request_buffer;
>> -		int i, size = 0;
>> -		for (i = 0; i < SCpnt->use_sg; i++)
>> -			size += sg[i].length;
>> +		struct scatterlist *sg;
>> +		int i, size = 0, sg_count = scsi_sg_count(SCpnt);
>> +
>> +		scsi_for_each_sg (SCpnt, sg, sg_count, i)
>> +			size += sg->length;
>>  
>> -		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
>> +		if (size != scsi_bufflen(SCpnt)) {
>>  			scmd_printk(KERN_ERR, SCpnt,
>>  				"mismatch count %d, bytes %d\n",
>> -				size, SCpnt->request_bufflen);
>> -			if (SCpnt->request_bufflen > size)
>> -				SCpnt->request_bufflen = size;
>> +				size, scsi_bufflen(SCpnt));
>> +			if (scsi_bufflen(SCpnt) > size)
>> +				SCpnt->sdb.length = size;
>>  		}
>>  	}
>>  
>> @@ -392,12 +390,12 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
>>  	 * request doesn't start on hw block boundary, add scatter pads
>>  	 */
>>  	if (((unsigned int)rq->sector % (s_size >> 9)) ||
>> -	    (SCpnt->request_bufflen % s_size)) {
>> +	    (scsi_bufflen(SCpnt) % s_size)) {
>>  		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
>>  		goto out;
>>  	}
>>  
>> -	this_count = (SCpnt->request_bufflen >> 9) / (s_size >> 9);
>> +	this_count = (scsi_bufflen(SCpnt) >> 9) / (s_size >> 9);
>>  
>>  
>>  	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
>> @@ -411,7 +409,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
>>  
>>  	if (this_count > 0xffff) {
>>  		this_count = 0xffff;
>> -		SCpnt->request_bufflen = this_count * s_size;
>> +		SCpnt->sdb.length = this_count * s_size;
>>  	}
>>  
>>  	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
>> diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
>> index 178e8c2..2d9a32b 100644
>> --- a/drivers/usb/storage/isd200.c
>> +++ b/drivers/usb/storage/isd200.c
>> @@ -415,14 +415,14 @@ static void isd200_set_srb(struct isd200_info *info,
>>  		sg_init_one(&info->sg, buff, bufflen);
>>  
>>  	srb->sc_data_direction = dir;
>> -	srb->request_buffer = buff ? &info->sg : NULL;
>> -	srb->request_bufflen = bufflen;
>> -	srb->use_sg = buff ? 1 : 0;
>> +	srb->sdb.sglist = buff ? &info->sg : NULL;
>> +	srb->sdb.length = bufflen;
>> +	srb->sdb.sg_count = buff ? 1 : 0;
>>  }
>>  
>>  static void isd200_srb_set_bufflen(struct scsi_cmnd *srb, unsigned bufflen)
>>  {
>> -	srb->request_bufflen = bufflen;
>> +	srb->sdb.length = bufflen;
>>  }
>>  
>>  
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index a7be605..4e3cf43 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -12,6 +12,13 @@ struct scatterlist;
>>  struct Scsi_Host;
>>  struct scsi_device;
>>  
>> +struct scsi_data_buffer {
>> +	unsigned length;
>> +	int resid;
>> +	unsigned short sg_count;
>> +	unsigned short alloc_sg_count;
> 
> sg_count and alloc_sg_count are a bit lengthy?
> 
> My suggestion is using nr_* like the block layer (nr_sg and
> nr_alloc_sg ?).

will not! sg_count is the name you gave to the accessor and it
must be the same. alloc_sg_count is a private member that must only
be used by scsi_lib.c. If the long name is a discouragement of use
than that much better.

> 
> 
>> +	struct scatterlist* sglist;
>> +};
>>  
>>  /* embedded in scsi_cmnd */
>>  struct scsi_pointer {
>> @@ -62,15 +69,10 @@ struct scsi_cmnd {
>>  	/* These elements define the operation we are about to perform */
>>  #define MAX_COMMAND_SIZE	16
>>  	unsigned char cmnd[MAX_COMMAND_SIZE];
>> -	unsigned request_bufflen;	/* Actual request size */
>>  
>>  	struct timer_list eh_timeout;	/* Used to time out the command. */
>> -	void *request_buffer;		/* Actual requested buffer */
>>  
>>  	/* These elements define the operation we ultimately want to perform */
>> -	unsigned short use_sg;	/* Number of pieces of scatter-gather */
>> -	unsigned short __use_sg;
>> -
>>  	unsigned underflow;	/* Return error if less than
>>  				   this amount is transferred */
>>  
<snip>

Will send two new patches.

Boaz
