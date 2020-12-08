Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FE0C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 00:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5327523A04
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 00:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgLHANC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:13:02 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50078 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbgLHANC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 19:13:02 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 353102A907;
        Mon,  7 Dec 2020 19:12:20 -0500 (EST)
Date:   Tue, 8 Dec 2020 11:12:28 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: NCR5380: Remove context check
In-Reply-To: <20201206075157.19067-1-a.darwish@linutronix.de>
Message-ID: <alpine.LNX.2.23.453.2012081104380.27@nippy.intranet>
References: <alpine.LNX.2.23.453.2012051512300.6@nippy.intranet> <20201206075157.19067-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 6 Dec 2020, Ahmed S. Darwish wrote:

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

Acked-by: Finn Thain <fthain@telegraphics.com.au>
