Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2314EC4167B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 23:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEBE2245C
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgLCXIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:08:50 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:41666 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLCXIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 18:08:50 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id A9D442AE1C;
        Thu,  3 Dec 2020 18:08:03 -0500 (EST)
Date:   Fri, 4 Dec 2020 10:08:08 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/NCR5380: Remove in_interrupt() test
In-Reply-To: <20201201170547.d6ff743eeuh6en6s@linutronix.de>
Message-ID: <alpine.LNX.2.23.453.2012040953030.6@nippy.intranet>
References: <58cf6feeaf5dae1ee0c78c1b25c00c73de15b087.1606805196.git.fthain@telegraphics.com.au> <20201201170547.d6ff743eeuh6en6s@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

136046n Tue, 1 Dec 2020, Sebastian Andrzej Siewior wrote:

> On 2020-12-01 17:46:36 [+1100], Finn Thain wrote:
> > The in_interrupt() macro is deprecated. Also, it's usage in 
> > NCR5380_poll_politely2() has long been redundant.
> 
> So you rely on the assumption that interrupts are always disabled. Hmmm.
> You complained about the additional argument and that things may get
> wrong with it.
> Now that I look at it, I realize that hostdata->poll_loops is used for
> the initial poll and the `wait' argument is only used for sleeping. What
> about it gets redefined to 0 if sleeping is not possible and != 0 if
> sleeping is requested. 
> This results in a few callers passing 0 instead of HZ (or so) which 
> should make things more obvious.
> 
> There is however do_abort(, HZ) and abort does internally "wait * 10" so
> it matches the old value.
>  

So the argument being passed is not simply "poll interval" in jiffies but 
"poll interval divided by 10"? That's a suprising API to chose (further 
comments below).

> --------------->8------------------
> 
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> Subject: [PATCH] scsi: NCR5380: Remove in_interrupt() usage.
> 
> NCR5380_poll_politely2() uses in_interrupt() to check if it is safe to
> sleep.
> 
> The usage of in_interrupt() in drivers is phased out and Linus clearly
> requested that code which changes behaviour depending on context should
> either be separated, or the context be explicitly conveyed in an
> argument passed by the caller.
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
> Use 0 in NCR5380_poll_politely2() delay argument if sleeping is not
> possible. Otherwise pass the requested time out in jiffies.
> 
> For the mixed ones, trickle-down context from upper layers.
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> [bigeasy: remove the bool, make decision based on `wait' ]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: <linux-m68k@lists.linux-m68k.org>
> ---
>  drivers/scsi/NCR5380.c   | 74 ++++++++++++++++++++++------------------
>  drivers/scsi/NCR5380.h   |  4 ++-
>  drivers/scsi/g_NCR5380.c | 12 +++----
>  drivers/scsi/mac_scsi.c  | 10 +++---
>  4 files changed, 54 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index d597d7493a627..7b0606d8f529a 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -132,7 +132,7 @@
>  static unsigned int disconnect_mask = ~0;
>  module_param(disconnect_mask, int, 0444);
>  
> -static int do_abort(struct Scsi_Host *);
> +static int do_abort(struct Scsi_Host *, unsigned long);
>  static void do_reset(struct Scsi_Host *);
>  static void bus_reset_cleanup(struct Scsi_Host *);
>  
> @@ -197,7 +197,7 @@ static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
>   * @reg2: Second 5380 register to poll
>   * @bit2: Second bitmask to check
>   * @val2: Second expected value
> - * @wait: Time-out in jiffies
> + * @wait: Sleep time-out in jiffies, 0 if sleeping is not allowed
>   *
>   * Polls the chip in a reasonably efficient manner waiting for an
>   * event to occur. After a short quick poll we begin to yield the CPU
> @@ -223,7 +223,7 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
>  		cpu_relax();
>  	} while (n--);
>  
> -	if (irqs_disabled() || in_interrupt())
> +	if (!wait)
>  		return -ETIMEDOUT;
>  
>  	/* Repeatedly sleep for 1 ms until deadline */
> @@ -486,7 +486,7 @@ static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
>  			break;
>  		case 2:
>  			shost_printk(KERN_ERR, instance, "bus busy, attempting abort\n");
> -			do_abort(instance);
> +			do_abort(instance, HZ);
>  			break;
>  		case 4:
>  			shost_printk(KERN_ERR, instance, "bus busy, attempting reset\n");
> @@ -822,7 +822,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
>  			if (toPIO > 0) {
>  				dsprintk(NDEBUG_DMA, instance,
>  				         "Doing %d byte PIO to 0x%p\n", cnt, *data);
> -				NCR5380_transfer_pio(instance, &p, &cnt, data);
> +				NCR5380_transfer_pio(instance, &p, &cnt, data, 0);
>  				*count -= toPIO - cnt;
>  			}
>  		}
> @@ -1189,7 +1189,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  	if (!hostdata->selecting) {
> -		do_abort(instance);
> +		do_abort(instance, 0);
>  		return false;
>  	}
>  
> @@ -1200,7 +1200,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  	len = 1;
>  	data = tmp;
>  	phase = PHASE_MSGOUT;
> -	NCR5380_transfer_pio(instance, &phase, &len, &data);
> +	NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
>  	if (len) {
>  		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
>  		cmd->result = DID_ERROR << 16;
> @@ -1238,7 +1238,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>   *
>   * Inputs : instance - instance of driver, *phase - pointer to
>   * what phase is expected, *count - pointer to number of
> - * bytes to transfer, **data - pointer to data pointer.
> + * bytes to transfer, **data - pointer to data pointer,
> + * wait - sleep time-out in jiffies, 0 if sleeping is now allowed.
>   *
>   * Returns : -1 when different phase is entered without transferring
>   * maximum number of bytes, 0 if all bytes are transferred or exit
> @@ -1257,7 +1258,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  
>  static int NCR5380_transfer_pio(struct Scsi_Host *instance,
>  				unsigned char *phase, int *count,
> -				unsigned char **data)
> +				unsigned char **data, unsigned long wait)
>  {
>  	struct NCR5380_hostdata *hostdata = shost_priv(instance);
>  	unsigned char p = *phase, tmp;
> @@ -1278,7 +1279,8 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
>  		 * valid
>  		 */
>  
> -		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
> +		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ,
> +					  wait) < 0)
>  			break;
>  
>  		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ asserted\n");
> @@ -1324,7 +1326,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
>  		}
>  
>  		if (NCR5380_poll_politely(hostdata,
> -		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
> +		                          STATUS_REG, SR_REQ, 0, wait * 5) < 0)

Apparently 'wait' has two possible values, 0 or HZ? That seems like 
another unintuitive API... perhaps you might want that if different 
callers had different values for HZ (they don't). Because this API is 
unintuitive, it would invite even more mistakes than just adding the 
'can_sleep' argument and would need more documentation.

Anyway, I think what you were trying to achieve was a timeout value like 
this:

              if (NCR5380_poll_politely(hostdata,
-                                       STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
+                                       STATUS_REG, SR_REQ, 0, 5 * HZ * can_sleep) < 0)

I can see some some merit in this (discussed below).

>  
>  		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n");
> @@ -1399,11 +1401,12 @@ static void do_reset(struct Scsi_Host *instance)
>   * do_abort - abort the currently established nexus by going to
>   * MESSAGE OUT phase and sending an ABORT message.
>   * @instance: relevant scsi host instance
> + * @wait: Sleep time-out in jiffies.
>   *
>   * Returns 0 on success, negative error code on failure.
>   */
>  
> -static int do_abort(struct Scsi_Host *instance)
> +static int do_abort(struct Scsi_Host *instance, unsigned long wait)
>  {
>  	struct NCR5380_hostdata *hostdata = shost_priv(instance);
>  	unsigned char *msgptr, phase, tmp;
> @@ -1423,7 +1426,8 @@ static int do_abort(struct Scsi_Host *instance)
>  	 * the target sees, so we just handshake.
>  	 */
>  
> -	rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, 10 * HZ);
> +	rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ,
> +				   wait * 10);
>  	if (rc < 0)
>  		goto out;
>  
> @@ -1434,7 +1438,8 @@ static int do_abort(struct Scsi_Host *instance)
>  	if (tmp != PHASE_MSGOUT) {
>  		NCR5380_write(INITIATOR_COMMAND_REG,
>  		              ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
> -		rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0, 3 * HZ);
> +		rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0,
> +					   wait * 3);
>  		if (rc < 0)
>  			goto out;
>  		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
> @@ -1444,7 +1449,7 @@ static int do_abort(struct Scsi_Host *instance)
>  	msgptr = &tmp;
>  	len = 1;
>  	phase = PHASE_MSGOUT;
> -	NCR5380_transfer_pio(instance, &phase, &len, &msgptr);
> +	NCR5380_transfer_pio(instance, &phase, &len, &msgptr, wait);
>  	if (len)
>  		rc = -ENXIO;
>  
> @@ -1623,12 +1628,12 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
>  			 */
>  
>  			if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
> -			                          BASR_DRQ, BASR_DRQ, HZ) < 0) {
> +			                          BASR_DRQ, BASR_DRQ, 0) < 0) {
>  				result = -1;
>  				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
>  			}
>  			if (NCR5380_poll_politely(hostdata, STATUS_REG,
> -			                          SR_REQ, 0, HZ) < 0) {
> +			                          SR_REQ, 0, 0) < 0) {
>  				result = -1;
>  				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
>  			}
> @@ -1640,7 +1645,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
>  			 */
>  			if (NCR5380_poll_politely2(hostdata,
>  			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
> -			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ) < 0) {
> +			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, 0) < 0) {
>  				result = -1;
>  				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase timeout\n");
>  			}
> @@ -1737,7 +1742,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  #if (NDEBUG & NDEBUG_NO_DATAOUT)
>  				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n");
>  				sink = 1;
> -				do_abort(instance);
> +				do_abort(instance, 0);
>  				cmd->result = DID_ERROR << 16;
>  				complete_cmd(instance, cmd);
>  				hostdata->connected = NULL;
> @@ -1793,7 +1798,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  							   NCR5380_PIO_CHUNK_SIZE);
>  					len = transfersize;
>  					NCR5380_transfer_pio(instance, &phase, &len,
> -					                     (unsigned char **)&cmd->SCp.ptr);
> +					                     (unsigned char **)&cmd->SCp.ptr,
> +							     0);
>  					cmd->SCp.this_residual -= transfersize - len;
>  				}
>  #ifdef CONFIG_SUN3
> @@ -1804,7 +1810,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  			case PHASE_MSGIN:
>  				len = 1;
>  				data = &tmp;
> -				NCR5380_transfer_pio(instance, &phase, &len, &data);
> +				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
>  				cmd->SCp.Message = tmp;
>  
>  				switch (tmp) {
> @@ -1910,7 +1916,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					len = 2;
>  					data = extended_msg + 1;
>  					phase = PHASE_MSGIN;
> -					NCR5380_transfer_pio(instance, &phase, &len, &data);
> +					NCR5380_transfer_pio(instance, &phase, &len, &data, HZ);
>  					dsprintk(NDEBUG_EXTENDED, instance, "length %d, code 0x%02x\n",
>  					         (int)extended_msg[1],
>  					         (int)extended_msg[2]);
> @@ -1923,7 +1929,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  						data = extended_msg + 3;
>  						phase = PHASE_MSGIN;
>  
> -						NCR5380_transfer_pio(instance, &phase, &len, &data);
> +						NCR5380_transfer_pio(instance, &phase, &len, &data, HZ);
>  						dsprintk(NDEBUG_EXTENDED, instance, "message received, residual %d\n",
>  						         len);
>  
> @@ -1970,7 +1976,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  				len = 1;
>  				data = &msgout;
>  				hostdata->last_message = msgout;
> -				NCR5380_transfer_pio(instance, &phase, &len, &data);
> +				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
>  				if (msgout == ABORT) {
>  					hostdata->connected = NULL;
>  					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
> @@ -1988,12 +1994,12 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  				 * PSEUDO-DMA architecture we should probably
>  				 * use the dma transfer function.
>  				 */
> -				NCR5380_transfer_pio(instance, &phase, &len, &data);
> +				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
>  				break;
>  			case PHASE_STATIN:
>  				len = 1;
>  				data = &tmp;
> -				NCR5380_transfer_pio(instance, &phase, &len, &data);
> +				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
>  				cmd->SCp.Status = tmp;
>  				break;
>  			default:
> @@ -2052,7 +2058,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>  
>  	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
>  	if (NCR5380_poll_politely(hostdata,
> -	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
> +	                          STATUS_REG, SR_SEL, 0, 0) < 0) {
>  		shost_printk(KERN_ERR, instance, "reselect: !SEL timeout\n");
>  		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
>  		return;
> @@ -2064,12 +2070,12 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>  	 */
>  
>  	if (NCR5380_poll_politely(hostdata,
> -	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
> +	                          STATUS_REG, SR_REQ, SR_REQ, 0) < 0) {
>  		if ((NCR5380_read(STATUS_REG) & (SR_BSY | SR_SEL)) == 0)
>  			/* BUS FREE phase */
>  			return;
>  		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
> -		do_abort(instance);
> +		do_abort(instance, 0);
>  		return;
>  	}
>  
> @@ -2085,10 +2091,10 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>  		unsigned char *data = msg;
>  		unsigned char phase = PHASE_MSGIN;
>  
> -		NCR5380_transfer_pio(instance, &phase, &len, &data);
> +		NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
>  
>  		if (len) {
> -			do_abort(instance);
> +			do_abort(instance, 0);
>  			return;
>  		}
>  	}
> @@ -2098,7 +2104,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>  		shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
>  		spi_print_msg(msg);
>  		printk("\n");
> -		do_abort(instance);
> +		do_abort(instance, 0);
>  		return;
>  	}
>  	lun = msg[0] & 0x07;
> @@ -2138,7 +2144,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>  		 * Since we have an established nexus that we can't do anything
>  		 * with, we must abort it.
>  		 */
> -		if (do_abort(instance) == 0)
> +		if (do_abort(instance, 0) == 0)
>  			hostdata->busy[target] &= ~(1 << lun);
>  		return;
>  	}
> @@ -2285,7 +2291,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
>  		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
>  		hostdata->connected = NULL;
>  		hostdata->dma_len = 0;
> -		if (do_abort(instance) < 0) {
> +		if (do_abort(instance, 0) < 0) {
>  			set_host_byte(cmd, DID_ERROR);
>  			complete_cmd(instance, cmd);
>  			result = FAILED;
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 5935fd6d1a058..578983e328d19 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -277,7 +277,9 @@ static const char *NCR5380_info(struct Scsi_Host *instance);
>  static void NCR5380_reselect(struct Scsi_Host *instance);
>  static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
>  static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
> -static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
> +static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase,
> +				int *count, unsigned char **data,
> +				unsigned long wait);
>  static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
>                                    unsigned int, u8, u8,
>                                    unsigned int, u8, u8, unsigned long);
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 29e4cdcade720..2df2f38a9b122 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -529,14 +529,14 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
>  		if (start == len - 128) {
>  			/* Ignore End of DMA interrupt for the final buffer */
>  			if (NCR5380_poll_politely(hostdata, hostdata->c400_ctl_status,
> -			                          CSR_HOST_BUF_NOT_RDY, 0, HZ / 64) < 0)
> +			                          CSR_HOST_BUF_NOT_RDY, 0, 0) < 0)

You've put your finger on a known problem with certain 
NCR5380_poll_politely() call sites. That is, the nominal timeout, HZ / 64, 
is meaningless because it is ignored in atomic context. So you may as well 
specify 0 jiffies at these call sites. (There will be a 1 jiffy timeout 
applied regardless.)

BTW, a jiffy is an unknown quantity here. This driver has tradionally 
assumed that 1 jiffy == 10 ms and this is always true on m68k. That 
assumption is something that we probably need to address as part of the 
timekeeping modernization for m68k.

>  				break;
>  		} else {
>  			if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
>  			                           CSR_HOST_BUF_NOT_RDY, 0,
>  			                           hostdata->c400_ctl_status,
>  			                           CSR_GATED_53C80_IRQ,
> -			                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
> +			                           CSR_GATED_53C80_IRQ, 0) < 0 ||
>  			    NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
>  				break;
>  		}
> @@ -565,7 +565,7 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
>  	if (residual == 0 && NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
>  	                                           BASR_END_DMA_TRANSFER,
>  	                                           BASR_END_DMA_TRANSFER,
> -	                                           HZ / 64) < 0)
> +						   0) < 0)
>  		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout\n",
>  		            __func__);
>  
> @@ -597,7 +597,7 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
>  		                           CSR_HOST_BUF_NOT_RDY, 0,
>  		                           hostdata->c400_ctl_status,
>  		                           CSR_GATED_53C80_IRQ,
> -		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
> +		                           CSR_GATED_53C80_IRQ, 0) < 0 ||
>  		    NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY) {
>  			/* Both 128 B buffers are in use */
>  			if (start >= 128)
> @@ -644,13 +644,13 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
>  	if (residual == 0) {
>  		if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
>  		                          TCR_LAST_BYTE_SENT, TCR_LAST_BYTE_SENT,
> -		                          HZ / 64) < 0)
> +					  0) < 0)
>  			scmd_printk(KERN_ERR, hostdata->connected,
>  			            "%s: Last Byte Sent timeout\n", __func__);
>  
>  		if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
>  		                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
> -		                          HZ / 64) < 0)
> +					  0) < 0)
>  			scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout\n",
>  			            __func__);
>  	}
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index b5dde9d0d0545..5c808fbc6ce2c 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -285,7 +285,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
>  
>  	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
>  	                              BASR_DRQ | BASR_PHASE_MATCH,
> -	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
> +	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
>  		int bytes;
>  
>  		if (macintosh_config->ident == MAC_MODEL_IIFX)
> @@ -304,7 +304,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
>  
>  		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
>  		                           BUS_AND_STATUS_REG, BASR_ACK,
> -		                           BASR_ACK, HZ / 64) < 0)
> +		                           BASR_ACK, 0) < 0)
>  			scmd_printk(KERN_DEBUG, hostdata->connected,
>  			            "%s: !REQ and !ACK\n", __func__);
>  		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
> @@ -344,7 +344,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
>  
>  	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
>  	                              BASR_DRQ | BASR_PHASE_MATCH,
> -	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
> +	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
>  		int bytes;
>  
>  		if (macintosh_config->ident == MAC_MODEL_IIFX)
> @@ -362,7 +362,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
>  			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
>  			                          TCR_LAST_BYTE_SENT,
>  			                          TCR_LAST_BYTE_SENT,
> -			                          HZ / 64) < 0) {
> +			                          0) < 0) {
>  				scmd_printk(KERN_ERR, hostdata->connected,
>  				            "%s: Last Byte Sent timeout\n", __func__);
>  				result = -1;
> @@ -372,7 +372,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
>  
>  		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
>  		                           BUS_AND_STATUS_REG, BASR_ACK,
> -		                           BASR_ACK, HZ / 64) < 0)
> +		                           BASR_ACK, 0) < 0)
>  			scmd_printk(KERN_DEBUG, hostdata->connected,
>  			            "%s: !REQ and !ACK\n", __func__);
>  		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
> 

The style change itself (i.e. replacing irqs_disabled() with a parameter 
to accomplish the same thing) is not worth the churn, IMO.

However, I can see the value in your approach, i.e. passing a zero timeout 
to NCR5380_poll_politely() whenever that argument is unused. And I agree 
that this could then be used to inhibit sleeping, rather than testing 
irqs_disabled().

So if you really don't like irqs_disabled(), perhaps you can just keep the 
better parts of your two attempts, i.e. passing 0 to 
NCR5380_poll_politely() where appropriate and facilitating that by adding 
a new can_sleep parameter to do_abort() and NCR5380_transfer_pio(), as in,

@@ -1253,7 +1254,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 
 static int NCR5380_transfer_pio(struct Scsi_Host *instance,
                                unsigned char *phase, int *count,
-                               unsigned char **data)
+                               unsigned char **data, unsigned int can_sleep)
 {
        struct NCR5380_hostdata *hostdata = shost_priv(instance);
        unsigned char p = *phase, tmp;

@@ -1395,11 +1396,12 @@ static void do_reset(struct Scsi_Host *instance)
  * do_abort - abort the currently established nexus by going to
  * MESSAGE OUT phase and sending an ABORT message.
  * @instance: relevant scsi host instance
+ * @can_sleep: 1 or 0 when sleeping is permitted or not, respectively.
  *
  * Returns 0 on success, negative error code on failure.
  */
 
-static int do_abort(struct Scsi_Host *instance)
+static int do_abort(struct Scsi_Host *instance, unsigned int can_sleep)
 {
        struct NCR5380_hostdata *hostdata = shost_priv(instance);
        unsigned char *msgptr, phase, tmp;

Does that sound like a reasonable compromise?
