From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 19 Jan 2017 10:18:33 +0100
Message-ID: <20170119091833.GM5054@linux-x5ow.site>
References: <20170117162752.GE6067@linux-x5ow.site>
 <6df6bf6a-7cd3-1700-2b0a-e140325ebf47@grimberg.me>
 <20170118135156.GG3514@linux-x5ow.site>
 <e3438024-e0f2-db96-5122-4508863be603@grimberg.me>
 <20170118145816.GI3514@linux-x5ow.site>
 <c7eabe1c-5dcd-9859-2b41-9683f68a0534@grimberg.me>
 <20170118151643.GJ3514@linux-x5ow.site>
 <aaf5c35f-7e81-fa44-d467-53b574debdd4@suse.de>
 <97a3f3d3-3619-871d-55f3-75449b0c34cf@grimberg.me>
 <dfb4890a-57c0-c070-1d38-ee72bfd85506@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dfb4890a-57c0-c070-1d38-ee72bfd85506@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2017 at 10:23:28AM +0200, Sagi Grimberg wrote:
> Christoph suggest to me once that we can take a hybrid
> approach where we consume a small amount of completions (say 4)
> right away from the interrupt handler and if we have more
> we schedule irq-poll to reap the rest. But back then it
> didn't work better which is not aligned with my observations
> that we consume only 1 completion per interrupt...
> 
> I can give it another go... What do people think about it?

This could be good.

What's also possible (see answer to my previous mail) is measuring the time it
takes for a completion to arrive and if the average time is lower than the
context switch time just busy loop insted of waiting for the IRQ to arrive. If
it is higher we can always schedule a timer to hit _before_ the IRQ will
likely arrive and start polling. Is this something that sounds reasonable to
you guys as well?

	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
