From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] FC transport & lpfc : Avoid device offline cases by stalling aborts until device unblocked
Date: Mon, 6 Feb 2006 11:11:01 -0800 (PST)
Message-ID: <20060206191101.77227.qmail@web31809.mail.mud.yahoo.com>
References: <43E77970.1030500@emulex.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:20336 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932157AbWBFTLB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 14:11:01 -0500
In-Reply-To: <43E77970.1030500@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

--- James Smart <James.Smart@Emulex.Com> wrote:
> The attached patch creates a FC transport service routine, which can
> be specified in the LLDD's scsi_host_template. This allows the transport
> to intercept io timeouts, check the state of rport, and if blocked,
> request the midlayer to reschedule the timeout. This patch also patches
> the lpfc driver to make use of this interface.

Yes, this is the intended purpose of this interface.

> What we are trying to avoid is to have the abort handler kick in while the
> rport is blocked. The rport is blocked because we have lost connectivity.
> As we have no connectivity, the LLDD either fails it (most common) or busy
> stalls (yech!) until rport state is resolved.  If the abort is failed, the
> error handler escalates, and eventually attempts to send a TUR to the
> device, which fails as we have no connectivity. As the TUR fails, the device
> gets taken offline, requiring manual interaction to restore use.

Is it possible that you add dev_loss_tmo to the scsi_dev timeout?
Say scsi_dev->timeout = dev_loss_tmo + X seconds?

This would mean that SCSI Core's command timer would fire X seconds _after_
the transport event, and presumably you've dealt with this issue
X seconds before (when the transport event fired).

> The original suggestion was from James Bottomley:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113682123403609&w=2
> based on the thread started by Michael Reed:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113477788309880&w=2
> 
> Please note:
>    This does not resolve the cases where the error handlers are engaged when
>    the rport is blocked.

Indeed, it doesn't.

>    The need of the transport conflicted with the initial eh_timed_out design,
>    which limited the rescheduling of the timeout to the number of retries
>    allowed on the command plus 1.  In the case of the FC transport, we already

Initially, returning EH_RESET_TIMER, did just what you want: reset the timer,
no questions asked.

>    have the dev_loss_tmo running to guarantee that this will not be an
>    infinite stall, so penalizing the i/o (especially be incrementing the retry
>    count) should be avoided.

So you can prove that it is bounded in time.  But this is very good!

So if you defined eh_strategy_handler() (in conjunction with setting the device
timeout to X seconds + dev_loss_tmo) you'll end up in your own eh_strategy_handler()
IFF the rport timeout fired and nothing could be done, then the SCSI Command
timeout fired (X seconds after) and nothing could be done, and you ended up
in your eh_strategy_handler().

Note: Defining eh_timed_out() doesn't imply that you should define
eh_strategy_handler(), but the opposite is not true.

>    Also, as Christoph just recently removed the eh_timed_out use in the
>    megaraid driver - he eliminated the only other (in-kernel) user of this
>    interface. Perhaps we should consider changing the design and realign
>    the EH_RESET_TIMER functionality to what EH_TRANSPORT_BLOCKED does.
>    Thoughts ?

Well, it only makes sense to return to the original meaning of EH_RESET_HANDLER,
i.e. that SCSI Core should just reset the timer and no questions asked.

Since, of course, EH_TRANSPORT_BLOCKED,
  1. Is equivalent to EH_RESET_TIMER, but circumvents SCSI Core's command retry
     attempts (as the diff patch shows below).
  2. Has no meaning to a timer timeout handler, i.e. what you really want is
     EH_RESET_TIMER.

So, since you need it, I'd say removing command retry counting in SCSI Core
for EH_RESET_TIMER can be removed to suit your needs.

> + *  EH_TRANSPORT_BLOCKED;
> + *    The transport is reporting that the device is in a "blocked"
> + *    state wherein it cannot be contacted (typically due to a temporary
> + *    loss of connectivity). The transport ensures that this is not an
> + *    infinite condition. The timeout is rescheduled until the transport
> + *    state changes.

Indeed, and as shown in your patch below this is just EH_RESET_TIMER sans
the retry counting.

> @@ -173,6 +192,8 @@ void scsi_times_out(struct scsi_cmnd *sc
>   			 * with allowed == 0 */
>   			if (scmd->retries++ > scmd->allowed)
>   				break;
> +			/* FALL THRU */
> +		case EH_TRANSPORT_BLOCKED:
>   			scsi_add_timer(scmd, scmd->timeout_per_command,
>   				       scsi_times_out);
>   			return;

Submit a patch which removes the retries counting from EH_RESET_TIMER
and let's see what happens.

    Luben

