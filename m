From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Mon, 31 Jan 2005 09:36:29 -0800
Message-ID: <20050131173629.GA29928@us.ibm.com>
References: <0B1E13B586976742A7599D71A6AC733C02F326@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:2471 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261286AbVAaRhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 12:37:17 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0VHbH7F004825
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 12:37:17 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0VHbHEF170630
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 12:37:17 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0VHbGKN021867
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 12:37:17 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F326@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: andrew.vasquez@qlogic.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, Jan 31, 2005 at 11:56:02AM -0500, James.Smart@Emulex.Com wrote:
> > On Sat, 2005-01-29 at 11:34 -0800, Patrick Mansfield wrote:

> > > 
> > > Why not just set scmd->retries to zero in scsi_requeue_command()?
> > > 
> > 
> > This is exactly what I was thinking would be a fairly straight-forward
> > approach at solving the problem...
> 
> This is ultimately a hack, and raises the potential for the retries value
> to perpetually be rezero'd.  The better solution is the use the block
> primitives available to avoid the i/o being issued at all if the transport
> can't handle it.

No, it does not change the potential to retry forever, someone still has
to requeue the IO again outside of the NEEDS_RETRY/scsi_retry_command case
for that to happen.

We only check retries in scsi_decide_disposition (well not counting error
handling), and if we hit the limit, return SUCCESS. The change is that we
reset retries to zero if the command is *not* retried via
NEEDS_RETRY/scsi_retry_command.

It would be even clearer to zero retries in scsi_decide_disposition.

For NOT_READY, we would be better off always using the
scsi_requeue_command path ever: get rid of the check in scsi_check_sense,
as it will be requeued via scsi_io_completion code. This would have to
happen even if delaying retries to NOT_READY devices.

But yes, it is better to stop IO if the transport can't handle it, and
would likely avoid the problem (if we only got NOT_READY's and never
returned DID_BUS_BUSY). 

But it is still a bug to not reset retries.

Maybe I need to hack scsi_debug to demonstrate the problem ...

-- Patrick Mansfield
