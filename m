From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/10] block: drop request->hard_* and *nr_sectors
Date: Mon, 04 May 2009 14:06:29 +0900
Message-ID: <49FE77D5.9040909@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-8-git-send-email-tj@kernel.org> <49F9ABAE.60405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49F9ABAE.60405@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com
List-Id: linux-scsi@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
>> @@ -1926,8 +1892,25 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
>>  		bio_iovec(bio)->bv_len -= nr_bytes;
>>  	}
>>  
>> -	blk_recalc_rq_sectors(req, total_bytes >> 9);
>> +	req->data_len -= total_bytes;
>> +	req->buffer = bio_data(req->bio);
>> +
>> +	/* update sector only for requests with clear definition of sector */
>> +	if (blk_fs_request(req) || blk_discard_rq(req))
>> +		req->sector += total_bytes >> 9;
>> +
>> +	/*
>> +	 * If total number of sectors is less than the first segment
>> +	 * size, something has gone terribly wrong.
>> +	 */
>> +	if (blk_rq_bytes(req) < blk_rq_cur_bytes(req)) {
>> +		printk(KERN_ERR "blk: request botched\n");
>> +		req->data_len = blk_rq_cur_bytes(req);
>> +	}
> 
> What happens in the last bio/segment?

Can you please elaborate a bit?  Nothing really changes for the last
bio/segment.

> Is it not allowed with block_pc commands that blk_rq_bytes(req) (was
> data_len) be smaller then sum_bytes(bio-chain)?

Well, before, it wasn't well defined.  For PC requests w/o bio, any
completion was full completion which isn't exactly data_len being
allowed to be shorter than actual data length but more like data_len
being completely ignored.  If a PC request has bio, the request should
be completed with full bio data length.  After recent changes, all PC
requests use bio and thus should fully complete the PC requests and
this patch doesn't change anything about that.

> Also I never understood the drain is it not appended to the last
> bio? I thought it is costumery in the Kernel to allow mapping longer
> then actual length?

drain is implemented in slightly hacky way.  All that's guaranteed is
extra room in the mapped sgl.  bio never sees it.

> Maybe you would want blk_rq_cur_bytes(req) to return the minimum of
> the two, and let bio's be longer then bytes requested. (ie. reverse
> above logic)

No, blk_rq_bytes() == sum of bio_rq_cur_bytes() of all bios in the
request and must NEVER be shorter than bio_rq_cur_bytes() by
definition.

Thanks.

-- 
tejun
