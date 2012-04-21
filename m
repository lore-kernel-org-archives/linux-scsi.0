From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 10/12] scsi: fix eh wakeup (scsi_schedule_eh vs
 scsi_restart_operations)
Date: Sat, 21 Apr 2012 13:22:29 +0100
Message-ID: <1335010949.3081.8.camel@dabdike.lan>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	 <20120413233742.8025.99073.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48430 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab2DUMWf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Apr 2012 08:22:35 -0400
In-Reply-To: <20120413233742.8025.99073.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Tom Jackson <thomas.p.jackson@intel.com>, linux-scsi@vger.kernel.org

On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
> Rapid ata hotplug on a libsas controller results in cases where libsas
> is waiting indefinitely on eh to perform an ata probe.
> 
> A race exists between scsi_schedule_eh() and scsi_restart_operations()
> in the case when scsi_restart_operations() issues i/o to other devices
> in the sas domain.  When this happens the host state transitions from
> SHOST_RECOVERY (set by scsi_schedule_eh) back to SHOST_RUNNING and
> ->host_busy is non-zero so we put the eh thread to sleep even though
> ->host_eh_scheduled is active.
> 
> Before putting the error handler to sleep we need to check if the
> host_state needs to return to SHOST_RECOVERY for another trip through
> eh.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
> Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/scsi_error.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 2cfcbff..0945d47 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1687,6 +1687,20 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
>  	 * requests are started.
>  	 */
>  	scsi_run_host_queues(shost);
> +
> +	/*
> +	 * if eh is active and host_eh_scheduled is pending we need to re-run
> +	 * recovery.  we do this check after scsi_run_host_queues() to allow
> +	 * everything pent up since the last eh run a chance to make forward
> +	 * progress before we sync again.  Either we'll immediately re-run
> +	 * recovery or scsi_device_unbusy() will wake us again when these
> +	 * pending commands complete.
> +	 */
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	if (shost->host_eh_scheduled)
> +		if (scsi_host_set_state(shost, SHOST_RECOVERY))
> +			WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
> +	spin_unlock_irqrestore(shost->host_lock, flags);

This doesn't really look to be the way to fix the race, because we'll
start up the host again before closing it down.  Isn't the correct way
to put

if (shost->host_eh_scheduled)
	continue;

into the scsi_error_handler() loop just *before*
scsi_restart_operations()?

James


