From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] softirq queue is now list_head, eliminate bh_next
Date: Fri, 7 Mar 2003 17:43:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030307174324.A3372@beaverton.ibm.com>
References: <3E69317E.8030403@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E69317E.8030403@splentec.com>; from luben@splentec.com on Fri, Mar 07, 2003 at 06:55:42PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

Hi Luben -

On Fri, Mar 07, 2003 at 06:55:42PM -0500, Luben Tuikov wrote:
> Eliminated is the double loop in scsi_softirq() -- this is
> better handled in do_softirq() and gives the system a ``breather''.
> (There are pros and cons for either side and if you guys
> think that it was better with the double loop, I'll change it and
> resubmit the patch.)

I think it is better to have one loop (per your patch) - in breather cases
when we get multiple interrupts before we can service all of them the
do_softirq() can wakeup ksoftirqd for us to run on.

>   static void scsi_softirq(struct softirq_action *h)
>   {
> -	int cpu = smp_processor_id();
> -	struct softscsi_data *queue = &softscsi_data[cpu];
> +	LIST_HEAD(local_q);
> 
> -	while (queue->head) {
> -		Scsi_Cmnd *SCpnt, *SCnext;
> +	local_irq_disable();
> +	list_splice_init(&done_q[smp_processor_id()], &local_q);
> +	local_irq_enable();
> +
> +	while (!list_empty(&local_q)) {

Why not list_for_each_safe rather than a while?

> +		} /* switch (command disposition) */
> +	} /* while (local queue is not emtpy) */
> +} /* end scsi_softirq() */
> 

You should get rid of the comments after the }'s.

-- Patrick Mansfield
