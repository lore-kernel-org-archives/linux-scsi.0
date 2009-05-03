From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] block: cleanup rq->data_len usages
Date: Sun, 03 May 2009 10:36:57 +0900
Message-ID: <49FCF539.2060408@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-9-git-send-email-tj@kernel.org> <49F9AC04.9060403@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbZECBia (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 May 2009 21:38:30 -0400
In-Reply-To: <49F9AC04.9060403@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, "Darrick J. Wong" <djwong@us.ibm.com>

Hello, Boaz.

Boaz Harrosh wrote:
>>  	/* The req and req->next_rq have not been completed */
>> -	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
>> +	BUG_ON(blk_end_bidi_request(req, 0, blk_rq_bytes(req),
>> +				    blk_rq_bytes(req->next_rq)));
>>  
> 
> Just blk_end_request_all() actually. If you let blk_end_request_all
> also do bidi

I wrote in the other reply but I don't want to make any other change
than converting direct accesses to accessors in this patch, so that we
can _know_ this patch is safe.  Patches in this series are already all
over the place.  But, yeah, cleaning this up would be great.  Care to
send a patch?

>>  	scsi_release_buffers(cmd);
>>  
> 
> and then it can be in-lined into caller, where blk_pc_request(req)
> just do blk_end_request_all regardless (and only the residual
> setting is conditional)
> 
> I'll send a patch to scsi_lib later once this settles a bit.

Ah.. cool.  :-)

>> @@ -966,7 +965,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>>  	BUG_ON(count > sdb->table.nents);
>>  	sdb->table.nents = count;
>>  	if (blk_pc_request(req))
>> -		sdb->length = req->data_len;
>> +		sdb->length = blk_rq_bytes(req);
>>  	else
>>  		sdb->length = blk_rq_sectors(req) << 9;
> 
> Is this true. I thought they must be the same now. I was actually
> anticipating this if() removed.

Replied in the other reply.

>>  	/* FIXME: should be include in osd_sense_info */
>>  	if (in_resid)
>> -		*in_resid = or->in.req ? or->in.req->data_len : 0;
>> +		*in_resid = or->in.req ? blk_rq_bytes(or->in.req) : 0;
> 
> +		*in_resid = or->in.req ? or->in.req->resid_len : 0;
> 
>>  
>>  	if (out_resid)
>> -		*out_resid = or->out.req ? or->out.req->data_len : 0;
>> +		*out_resid = or->out.req ? blk_rq_bytes(or->out.req) : 0;
> 
> +		*out_resid = or->out.req ? or->out.req->resid_len : 0;
> 
>>  
>>  	return ret;
>>  }
> 
> OK This segment is wrong. It should be moved to the residual count patch
> (PATCH 3/10) the assignment into *in_resid/*out_resid should shourly triggered
> a warning ;-)

Ah... thanks a lot for spotting it.  Will fix.

Thanks.

-- 
tejun
