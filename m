From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 1/3] hpsa: remove unneeded loop
Date: Thu, 1 Aug 2013 09:21:23 -0500
Message-ID: <20130801142123.GA24664@beardog.cce.hp.com>
References: <51FA5E7A.9050000@redhat.com> <20130801133951.GX24664@beardog.cce.hp.com> <51FA6B20.2090005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15103 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab3HAOVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Aug 2013 10:21:24 -0400
Content-Disposition: inline
In-Reply-To: <51FA6B20.2090005@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Thu, Aug 01, 2013 at 04:05:20PM +0200, Tomas Henzl wrote:
> On 08/01/2013 03:39 PM, scameron@beardog.cce.hp.com wrote:
> > On Thu, Aug 01, 2013 at 03:11:22PM +0200, Tomas Henzl wrote:
> >> From: Tomas Henzl <thenzl@redhat.com>
> >>
> >> The cmd_pool_bits is protected everywhere with a spinlock, 
> >> we don't need the test_and_set_bit, set_bit is enough and the loop
> >> can be removed too.
> >>
> >> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> >> ---
> >>  drivers/scsi/hpsa.c | 15 ++++++---------
> >>  1 file changed, 6 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> >> index 796482b..d7df01e 100644
> >> --- a/drivers/scsi/hpsa.c
> >> +++ b/drivers/scsi/hpsa.c
> >> @@ -2662,15 +2662,12 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
> >>  	unsigned long flags;
> >>  
> >>  	spin_lock_irqsave(&h->lock, flags);
> >> -	do {
> >> -		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> >> -		if (i == h->nr_cmds) {
> >> -			spin_unlock_irqrestore(&h->lock, flags);
> >> -			return NULL;
> >> -		}
> >> -	} while (test_and_set_bit
> >> -		 (i & (BITS_PER_LONG - 1),
> >> -		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
> >> +	i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> >> +	if (i == h->nr_cmds) {
> >> +		spin_unlock_irqrestore(&h->lock, flags);
> >> +		return NULL;
> >> +	}
> >> +	set_bit(i & (BITS_PER_LONG - 1), h->cmd_pool_bits + (i / BITS_PER_LONG));
> >>  	h->nr_allocs++;
> >>  	spin_unlock_irqrestore(&h->lock, flags);
> >>  
> >> -- 
> >> 1.8.3.1
> >>
> > Would it be better instead to just not use the spinlock for protecting
> > cmd_pool_bits?  I have thought about doing this for awhile, but haven't
> > gotten around to it.
> >
> > I think the while loop is safe without the spin lock.  And then it is
> > not needed in cmd_free either.
> 
> I was evaluating the same idea for a while too, a loop and inside just the test_and_set_bit,
> maybe even a stored value to start with a likely empty bit from last time to tune it a bit.
> But I know almost nothing about the use pattern, so I decided for the least invasive change
> to the existing code, to not make it worse.

Only reason I haven't done it is I'm loathe to make such a change to the main i/o
path without testing it like crazy before unleashing it, and it's never been a 
convenient time to slide such a change in around here and get proper testing
done (and there are other rather large changes brewing).

However, we have been using a similar scheme with the SCSI over PCIe driver,
here: https://github.com/HPSmartStorage/scsi-over-pcie/blob/master/block/sop.c
in alloc_request() around line 1476 without problems, and nvme-core.c contains
similar code in alloc_cmdid(), so I am confident it's sound in principle.
I would want to beat on it though, in case it ends up exposing a firmware bug
or something (not that I think it will, but you never know.)

-- steve


 
> 
> 
> >
> > -- steve
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
