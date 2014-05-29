From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2, repost] hpsa: remove unneeded loop
Date: Thu, 29 May 2014 17:21:36 +0200
Message-ID: <53875080.7080600@redhat.com>
References: <53873DEB.1080504@redhat.com> <20140529145128.GO6970@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339AbaE2PWp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2014 11:22:45 -0400
In-Reply-To: <20140529145128.GO6970@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On 05/29/2014 04:51 PM, scameron@beardog.cce.hp.com wrote:
> On Thu, May 29, 2014 at 04:02:19PM +0200, Tomas Henzl wrote:
>> Originally this was first patch in a series, but while the  other patches
>> were accepted, this one was forgotten.
>> The code below is adapted for the latest sources.
>>
>> The cmd_pool_bits is protected everywhere with a spinlock,
>> we don't need the test_and_set_bit, set_bit is enough and the loop
>> can be removed too.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>> ---
>>  drivers/scsi/hpsa.c | 15 ++++++---------
>>  1 file changed, 6 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 9a6e4a2..c8267f3 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -4680,15 +4680,12 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
>>  	unsigned long flags;
>>  
>>  	spin_lock_irqsave(&h->lock, flags);
>> -	do {
>> -		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
>> -		if (i == h->nr_cmds) {
>> -			spin_unlock_irqrestore(&h->lock, flags);
>> -			return NULL;
>> -		}
>> -	} while (test_and_set_bit
>> -		 (i & (BITS_PER_LONG - 1),
>> -		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
>> +	i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
>> +	if (i == h->nr_cmds) {
>> +		spin_unlock_irqrestore(&h->lock, flags);
>> +		return NULL;
>> +	}
>> +	set_bit(i & (BITS_PER_LONG - 1), h->cmd_pool_bits + (i / BITS_PER_LONG));
>>  	spin_unlock_irqrestore(&h->lock, flags);
>>  
>>  	c = h->cmd_pool + i;
>> -- 
>> 1.8.3.1
>>
> I don't quite remember, but I think it was forgotten because I became
> more interested in removing all the locks from the main i/o path of hpsa
> for performance reasons (I have had a rather large patch series in the
> works for quite a while now to do that, maybe it will be ready for 3.17,
> we'll see.) So this looks ok, but if things go according to plan it won't
> be relevant for very long.

We have discussed it quite long ago - http://www.spinics.net/lists/linux-scsi/msg67782.html
the conclusion was "I think we should go with your patch as is -- leave the spin lock,
but get rid of the unnecessary loop." That's why I've reposted it.

This patch it's just a smallish simplification and maybe performace impovement, (again very small),
so when there is something being prepared which rewrites the function anyway we can skip it,
I'll leave the decision on you.

tomash


>
> -- steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

