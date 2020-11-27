Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58FBC3E8C5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 21:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B69B22210
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 21:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgK0VQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 16:16:13 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:55184 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731143AbgK0VPe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2020 16:15:34 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 8C1C529916;
        Fri, 27 Nov 2020 16:15:05 -0500 (EST)
Date:   Sat, 28 Nov 2020 08:15:03 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 12/14] scsi: NCR5380: Remove in_interrupt().
In-Reply-To: <alpine.LNX.2.23.453.2011271524140.15@nippy.intranet>
Message-ID: <alpine.LNX.2.23.453.2011280802170.6@nippy.intranet>
References: <20201126132952.2287996-1-bigeasy@linutronix.de> <20201126132952.2287996-13-bigeasy@linutronix.de> <alpine.LNX.2.23.453.2011271524140.15@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 27 Nov 2020, Finn Thain wrote:

> 
> On Thu, 26 Nov 2020, Sebastian Andrzej Siewior wrote:
> 
> > From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> > 
> > NCR5380_poll_politely2() uses in_interrupt() to check if it is safe to
> > sleep.
> > 
> > The usage of in_interrupt() in drivers is phased out and Linus clearly
> > requested that code which changes behaviour depending on context should
> > either be separated, or the context be explicitly conveyed in an
> > argument passed by the caller.
> > 
> > Below is a context analysis of NCR5380_poll_politely2() uppermost
> > callers:
> > 
> >   - NCR5380_maybe_reset_bus(), task, invoked during device probe.
> >     -> NCR5380_poll_politely()
> >     -> do_abort()
> > 
> >   - NCR5380_select(), task, but can only sleep in the "release, then
> >     re-acquire" regions of the spinlock held by its caller.
> >     Sleeping invocations (lock released):
> >     -> NCR5380_poll_politely2()
> > 
> >     Atomic invocations (lock acquired):
> >     -> NCR5380_reselect()
> >        -> NCR5380_poll_politely()
> >        -> do_abort()
> >        -> NCR5380_transfer_pio()
> > 
> >   - NCR5380_intr(), interrupt handler
> >     -> NCR5380_dma_complete()
> >        -> NCR5380_transfer_pio()
> > 	  -> NCR5380_poll_politely()
> >     -> NCR5380_reselect() (see above)
> > 
> >   - NCR5380_information_transfer(), task, but can only sleep in the
> >     "release, then re-acquire" regions of the caller-held spinlock.
> >     Sleeping invocations (lock released):
> >       - NCR5380_transfer_pio() -> NCR5380_poll_politely()
> >       - NCR5380_poll_politely()
> > 
> >     Atomic invocations (lock acquired):
> >       - NCR5380_transfer_dma()
> > 	-> NCR5380_dma_recv_setup()
> >            => generic_NCR5380_precv() -> NCR5380_poll_politely()
> > 	   => macscsi_pread() -> NCR5380_poll_politely()
> > 
> > 	-> NCR5380_dma_send_setup()
> >  	   => generic_NCR5380_psend -> NCR5380_poll_politely2()
> > 	   => macscsi_pwrite() -> NCR5380_poll_politely()
> > 
> > 	-> NCR5380_poll_politely2()
> >         -> NCR5380_dma_complete()
> >            -> NCR5380_transfer_pio()
> > 	      -> NCR5380_poll_politely()
> >       - NCR5380_transfer_pio() -> NCR5380_poll_politely
> > 
> >   - NCR5380_reselect(), atomic, always called with hostdata spinlock
> >     held.
> > 
> > If direct callers are purely atomic, or purely task context, change
> > their specifications accordingly and mark them with "Context: " tags.
> > 
> > For the mixed ones, trickle-down context from upper layers.
> > 
> > Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Acked-by: Finn Thain <fthain@telegraphics.com.au>
> 

On second thoughts, have you considered this patch instead?

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d654a6cc4162..739def70cffb 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
 		cpu_relax();
 	} while (n--);
 
-	if (irqs_disabled() || in_interrupt())
+	/* We can't sleep when local irqs are disabled and callers ensure
+	 * that local irqs are disabled whenever we can't sleep.
+	 */
+	if (irqs_disabled())
 		return -ETIMEDOUT;
 
 	/* Repeatedly sleep for 1 ms until deadline */

> > @@ -513,9 +513,11 @@ static void wait_for_53c80_access(struct NCR5380_hostdata *hostdata)
> >   * @dst: buffer to write into
> >   * @len: transfer size
> >   *
> > + * Context: atomic. This implements NCR5380.c NCR5380_dma_recv_setup(),
> > + * which is always called with @hostdata spinlock held.
> > + *
> >   * Perform a pseudo DMA mode receive from a 53C400 or equivalent device.
> >   */
> > -
> >  static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
> >                                          unsigned char *dst, int len)
> >  {
> 
> BTW, if I was doing this, I'd omit all of the many gratuitous whitespace 
> changes and I'd avoid copying so much program logic into the comments 
> where it is redundant -- here I'd have written only "Context: atomic, 
> spinlock held". However, no need to revise. Looks fine otherwise.
> 

Also BTW, the phrase "may sleep" expresses that the caller permits the 
callee to sleep. Whereas, "can sleep" expresses that the callee is put on 
notice by the caller that sleeping is a possibility. And since the caller 
determines the actual true or false value, and the callee determines 
whether sleeping actually takes place, only the former phrase makes sense.
