From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 08/10] block: cleanup rq->data_len usages
Date: Sun, 03 May 2009 16:51:32 +0300
Message-ID: <49FDA164.3030806@panasas.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>	 <1240996428-10159-9-git-send-email-tj@kernel.org>	 <49F9AC04.9060403@panasas.com> <1241105757.3320.1.camel@mulgrave.int.hansenpartnership.com> <49FCF423.7040609@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49FCF423.7040609@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 05/03/2009 04:32 AM, Tejun Heo wrote:
> James Bottomley wrote:
>> On Thu, 2009-04-30 at 16:47 +0300, Boaz Harrosh wrote:
>>>> @@ -966,7 +965,7 @@ static int scsi_init_sgtable(struct request
>>> *req, struct scsi_data_buffer *sdb,
>>>>       BUG_ON(count > sdb->table.nents);
>>>>       sdb->table.nents = count;
>>>>       if (blk_pc_request(req))
>>>> -             sdb->length = req->data_len;
>>>> +             sdb->length = blk_rq_bytes(req);
>>>>       else
>>>>               sdb->length = blk_rq_sectors(req) << 9;
>>> Is this true. I thought they must be the same now. I was actually
>>> anticipating this if() removed.
>> Me too ... there's one of these in scsi_lib.c as well.
> 
> Not until the next patch.  It's probably safe for scsi to make the
> switch here but I wanted to do the transition in two logical steps -
> 1. make all users use accessors in the defined manner without
> affecting anything else 2. knowing #1 is true for all low level
> drivers, unify implementation inside block layer.  I had a following
> patch which tried to do sweep conversion of all llds (which is
> guaranteed to be safe after #2 has happened) but it looked like more
> trouble than worth and seems like best left to each subsystem, so
> please go ahead and clean up subsystems on top of this patchset.  :-)
> 
>> The difference comes because filesystem requests are always in sectors,
>> but BLOCK_PC requests are always in bytes .... we should be able to wrap
>> the accessors so they do the correct conversions.
> 
> After this series is applied, blk_rq_bytes() >> 9 == blk_rq_sectors()
> is guaranteed (note that blk_rq_sectors() << 9 might not equal
> blk_rq_bytes() if the data transfer length isn't multiple of 512), so
> the above if can be removed.  I just didn't want to make the
> conversion (probably safe for scsi) before the actual unification.
> 
> Thanks.
> 

OK, NP. But in this case please note on the side all the places you think
might be suspect for blk_rq_bytes()/blk_rq_sectors() cosolidation and post the
list. Because it is now that you are going over the code and it is now that you
touch exactly all these places. 

You could even put a "TODO:" comments on all these places in this patch. So to draw
later patches that audit and remove the TODO:.

(Or in trivial places like above that are safe even before these patches, just
 convert them silently, in the sense of least traffic)

But sure I will see what I can help and send patches for. Tell me when you
think this is stable enough for me to add patches on top of.

Thanks
Boaz
