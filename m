From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] softirq queue is now list_head, eliminate bh_next]
Date: Sat, 08 Mar 2003 12:56:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6A2EBE.5050508@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com ([24.156.85.81])
          by fep04-mail.bloor.is.net.cable.rogers.com
          (InterMail vM.5.01.05.12 201-253-122-126-112-20020820) with ESMTP
          id <20030308175614.LQSG265409.fep04-mail.bloor.is.net.cable.rogers.com@splentec.com>
          for <linux-scsi@vger.kernel.org>; Sat, 8 Mar 2003 12:56:14 -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> On Fri, Mar 07, 2003 at 06:55:42PM -0500, Luben Tuikov wrote:
> 
>>Eliminated is the double loop in scsi_softirq() -- this is
>>better handled in do_softirq() and gives the system a ``breather''.
>>(There are pros and cons for either side and if you guys
>>think that it was better with the double loop, I'll change it and
>>resubmit the patch.)
> 
> 
> I think it is better to have one loop (per your patch) - in breather cases
> when we get multiple interrupts before we can service all of them the
> do_softirq() can wakeup ksoftirqd for us to run on.

Yes, exactly my reasoning, thus the single loop.

>>  static void scsi_softirq(struct softirq_action *h)
>>  {
>>-	int cpu = smp_processor_id();
>>-	struct softscsi_data *queue = &softscsi_data[cpu];
>>+	LIST_HEAD(local_q);
>>
>>-	while (queue->head) {
>>-		Scsi_Cmnd *SCpnt, *SCnext;
>>+	local_irq_disable();
>>+	list_splice_init(&done_q[smp_processor_id()], &local_q);
>>+	local_irq_enable();
>>+
>>+	while (!list_empty(&local_q)) {
> 
> 
> Why not list_for_each_safe rather than a while?

Well, it's just simpler, since each element is, for sure,
deleted in sequence.

IMO, the macro list_for_each_safe() is very helpful (worth) when
there's a conditional (if/etc) which *may* delete the element
of the list, but since we're deleting it for sure, list_empty()
I think is simpler, and it saves as a struct list_head *tmp.

Furthermore list_for_each_*() implies _traversing_ the list in
some way, all the while we're just _consuming_ from the front
of a local list...  Me and my formalisms... :-)

[[I've used both profusely elsewhere, and that particular construct
has become an idiom for me (for its purpose).]]
 
> 
>>+		} /* switch (command disposition) */
>>+	} /* while (local queue is not emtpy) */
>>+} /* end scsi_softirq() */
>>
> 
> 
> You should get rid of the comments after the }'s.

I just simulated what was in the code before so as to stay
as close to the ``median'' as possible.

But ok, I'll delete them and resubmit the patch.

The only comment I put after a closing brace of a function
definition is /* end of fn_name() */ so that one can see
which function ends if its definition (code) is only partly
shown in one's screen.
I hope that's ok with everyone?  If not, flame me now.

Patrick, thanks for your input.

-- 
Luben



