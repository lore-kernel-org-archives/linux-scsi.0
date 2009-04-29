From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 05/10] block: convert to pos and nr_sectors accessors
Date: Wed, 29 Apr 2009 19:19:49 +0900
Message-ID: <49F829C5.4080501@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-6-git-send-email-tj@kernel.org> <alpine.LRH.2.00.0904291136160.3531@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.0904291136160.3531@vixen.sonytel.be>
Sender: linux-ide-owner@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Geert Uytterhoeven wrote:
>> diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
>> index b66ad58..d4e6b71 100644
>> --- a/drivers/block/z2ram.c
>> +++ b/drivers/block/z2ram.c
>> @@ -71,12 +71,12 @@ static void do_z2_request(struct request_queue *q)
>>  {
>>  	struct request *req;
>>  	while ((req = elv_next_request(q)) != NULL) {
>> -		unsigned long start = req->sector << 9;
>> -		unsigned long len  = req->current_nr_sectors << 9;
>> +		unsigned long start = blk_rq_pos(req) << 9;
>> +		unsigned long len  = blk_rq_cur_sectors(req) << 9;
>                 ^^^^^^^^^^^^^
> I guess this one can become `unsigned int' now, as:
> 
> static inline unsigned int blk_rq_cur_sectors(struct request *rq)
> {
> 	return blk_rq_cur_bytes(rq) >> 9;
> }
> 
> and blk_rq_cur_bytes(rq) returns `int', so it must fit in an `int' anyway?

Yeap, it should fit.  Given the way len is used there and the previous
usage had the same type promotion there, I think it's better to leave
the unsigned long alone there.

Acked-by added.  Thanks.

-- 
tejun
