Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AED6C4361A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 04:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCFFB22E01
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 04:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgLEE2j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 23:28:39 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40920 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLEE2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 23:28:39 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 3177D2B6DE;
        Fri,  4 Dec 2020 23:27:55 -0500 (EST)
Date:   Sat, 5 Dec 2020 15:28:02 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: NCR5380: Remove context check
In-Reply-To: <20201204153248.198159-1-a.darwish@linutronix.de>
Message-ID: <alpine.LNX.2.23.453.2012051512300.6@nippy.intranet>
References: <58cf6feeaf5dae1ee0c78c1b25c00c73de15b087.1606805196.git.fthain@telegraphics.com.au> <20201204153248.198159-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Fri, 4 Dec 2020, Ahmed S. Darwish wrote:

> NCR5380_poll_politely2() uses in_interrupt() and irqs_disabled() to
> check if it is safe to sleep.
> 
> Such usage in drivers is phased out and Linus clearly requested that
> code which changes behaviour depending on context should either be
> separated, or the context be explicitly conveyed in an argument passed
> by the caller.
> 
> Below is a context analysis of NCR5380_poll_politely2() uppermost
> callers:
> 
>   - NCR5380_maybe_reset_bus(), task, invoked during device probe.
>     -> NCR5380_poll_politely()
>     -> do_abort()
> 
>   - NCR5380_select(), task, but can only sleep in the "release, then
>     re-acquire" regions of the spinlock held by its caller.
>     Sleeping invocations (lock released):
>     -> NCR5380_poll_politely2()
> 
>     Atomic invocations (lock acquired):
>     -> NCR5380_reselect()
>        -> NCR5380_poll_politely()
>        -> do_abort()
>        -> NCR5380_transfer_pio()
> 
>   - NCR5380_intr(), interrupt handler
>     -> NCR5380_dma_complete()
>        -> NCR5380_transfer_pio()
> 	  -> NCR5380_poll_politely()
>     -> NCR5380_reselect() (see above)
> 
>   - NCR5380_information_transfer(), task, but can only sleep in the
>     "release, then re-acquire" regions of the caller-held spinlock.
>     Sleeping invocations (lock released):
>       - NCR5380_transfer_pio() -> NCR5380_poll_politely()
>       - NCR5380_poll_politely()
> 
>     Atomic invocations (lock acquired):
>       - NCR5380_transfer_dma()
> 	-> NCR5380_dma_recv_setup()
>            => generic_NCR5380_precv() -> NCR5380_poll_politely()
> 	   => macscsi_pread() -> NCR5380_poll_politely()
> 
> 	-> NCR5380_dma_send_setup()
>  	   => generic_NCR5380_psend -> NCR5380_poll_politely2()
> 	   => macscsi_pwrite() -> NCR5380_poll_politely()
> 
> 	-> NCR5380_poll_politely2()
>         -> NCR5380_dma_complete()
>            -> NCR5380_transfer_pio()
> 	      -> NCR5380_poll_politely()
>       - NCR5380_transfer_pio() -> NCR5380_poll_politely
> 
>   - NCR5380_reselect(), atomic, always called with hostdata spinlock
>     held.
> 
> Since NCR5380_poll_politely2() already takes a "wait" argument in
> jiffies, use it to determine if the function can sleep. Modify atomic
> callers, which passed an unused wait value in terms of HZ, to pass zero.
> 
> Suggested-by: Finn Thain <fthain@telegraphics.com.au>
> Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: <linux-m68k@lists.linux-m68k.org>
> ---
>  drivers/scsi/NCR5380.c   | 77 ++++++++++++++++++++++------------------
>  drivers/scsi/NCR5380.h   |  3 +-
>  drivers/scsi/g_NCR5380.c | 12 +++----
>  drivers/scsi/mac_scsi.c  | 10 +++---
>  4 files changed, 55 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index d654a6cc4162..60200f61592e 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -132,7 +132,7 @@
>  static unsigned int disconnect_mask = ~0;
>  module_param(disconnect_mask, int, 0444);
>  
> -static int do_abort(struct Scsi_Host *);
> +static int do_abort(struct Scsi_Host *, unsigned int);
>  static void do_reset(struct Scsi_Host *);
>  static void bus_reset_cleanup(struct Scsi_Host *);
>  
> @@ -197,7 +197,7 @@ static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
>   * @reg2: Second 5380 register to poll
>   * @bit2: Second bitmask to check
>   * @val2: Second expected value
> - * @wait: Time-out in jiffies
> + * @wait: Time-out in jiffies, 0 if sleeping is not allowed
>   *
>   * Polls the chip in a reasonably efficient manner waiting for an
>   * event to occur. After a short quick poll we begin to yield the CPU
> @@ -213,7 +213,7 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
>                                    unsigned long wait)
>  {
>  	unsigned long n = hostdata->poll_loops;
> -	unsigned long deadline = jiffies + wait;
> +	unsigned long deadline;
>  
>  	do {
>  		if ((NCR5380_read(reg1) & bit1) == val1)
> @@ -223,10 +223,11 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
>  		cpu_relax();
>  	} while (n--);
>  
> -	if (irqs_disabled() || in_interrupt())
> +	if (!wait)
>  		return -ETIMEDOUT;
>  
>  	/* Repeatedly sleep for 1 ms until deadline */
> +	deadline = jiffies + wait;
>  	while (time_is_after_jiffies(deadline)) {
>  		schedule_timeout_uninterruptible(1);
>  		if ((NCR5380_read(reg1) & bit1) == val1)

The deadline assignment shouldn't be moved. That's a behavioural change 
and doesn't fit under the stated aim of this patch. Also, it isn't 
actually a desirable change: the argument to this function is the overall 
wait time, not just the sleep limit.

The rest looks ok.
