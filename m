From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 09 Aug 2013 09:52:19 -0600
Message-ID: <52051033.8050605@kernel.dk>
References: <1374296162.7397.1098.camel@haakon3.risingtidesystems.com> <20130722150359.GA16564@dhcp-26-207.brq.redhat.com> <1374527436.7397.1145.camel@haakon3.risingtidesystems.com> <20130725101641.GB31994@dhcp-26-207.brq.redhat.com> <1374790082.7397.1411.camel@haakon3.risingtidesystems.com> <20130726020928.GL29296@kernel.dk> <1374873276.7397.1512.camel@haakon3.risingtidesystems.com> <20130729114653.GB20951@mtj.dyndns.org> <20130809082335.GA25306@dhcp-26-207.brq.redhat.com> <5204FBA6.6040001@kernel.dk> <20130809150744.GB25306@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41400 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab3HIPxo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2013 11:53:44 -0400
In-Reply-To: <20130809150744.GB25306@dhcp-26-207.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 08/09/2013 09:07 AM, Alexander Gordeev wrote:
> On Fri, Aug 09, 2013 at 08:24:38AM -0600, Jens Axboe wrote:
>> On 08/09/2013 02:23 AM, Alexander Gordeev wrote:
>>> +	ap->qc_tags = blk_mq_init_tags(ATA_MAX_QUEUE, 1, NUMA_NO_NODE);
>>> +	if (!ap->qc_tags) {
>>> +		kfree(ap);
>>> +		return NULL;
>>> +	}
>>
>> This should be blk_mq_init_tags(ATA_MAX_QUEUE - 1, 1, ...) since the
>> total depth is normal_tags + reserved_tags.
> 
> Aha.. If blk_mq_init_tags() should be like this then?
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index dcbc2a4..b131a48 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -468,10 +468,9 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
>  	 * Rest of the tags start at the queue list
>  	 */
>  	tags->nr_free = 0;
> -	while (nr_tags - tags->nr_reserved) {
> +	while (nr_tags--) {
>  		tags->freelist[tags->nr_free] = tags->nr_free +
>  							tags->nr_reserved;
> -		nr_tags--;
>  		tags->nr_free++;
>  	}

I misremembered, just checked the code. I think I used to have it like I
described, but changed it since I thought it would be more logical to
pass in full depth, and then what part of that is reserved. Looking at
the current code, your patch looks correct as-is.

-- 
Jens Axboe

