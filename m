From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI error handling -- one error blocks the whole SCSI host
Date: Sun, 26 May 2013 15:44:02 -0700
Message-ID: <1369608242.1904.7.camel@dabdike>
References: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46814 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326Ab3EZWoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 May 2013 18:44:05 -0400
In-Reply-To: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>


On Thu, 2013-05-23 at 11:14 -0700, Roland Dreier wrote:
> At LSF this year, we had a discussion about error handling and in
> particular the problem that SCSI midlayer error handling waits for the
> entire SCSI host (HBA) to quiesce before it starts to abort commands
> etc.
> 
> James made the suggestion that FC should handle things the way SAS
> does, because SAS has a strategy handler that does things the right
> way.  However, now that I finally sit down and look at the code, I
> don't see how this is the case.  It seems inherent in the way that
> scsi_eh_scmd_add() and the thread in scsi_error_handler() work (in
> particular the strategy handler can't even be called until host_failed
> == host_busy; we don't bump host_failed without SHOST_RECOVERY set,
> which stops queueing commands to any devices attached to the whole
> HBA).
> 
> James, am I understanding your suggestion properly?  If so can you
> explain what you meant about the libsas code -- I see that it has its
> own strategy handler but as I said before we've already stopped every
> device attached to the HBA before we ever get there.

It is, but I checked: Apparently it's not implemented in the sas
transport class.  The original discussion when libsas was constructed,
as I remember it, was about using the scsi timeout handler to implement
a running abort.  The idea is fairly simple: you use the first fire of
eh_timed_out to trigger the abort (or LUN reset) while simultaneously
returning BLK_EH_RESET_TIMER.  If the timer fires again and the abort
hasn't returned, you escalate, otherwise you resend the command when the
abort returns.  This allows you to handle single command failures (up to
LUN reset) without stopping the host.  Obviously, if you have to
escalate to device reset, then you need to start the eh thread.

James


