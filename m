From: David Dillow <dave@thedillows.org>
Subject: Re: [RFC 7/8] IB/srp: stop sharing the host lock with SCSI
Date: Mon, 27 Dec 2010 12:49:25 -0500
Message-ID: <1293472165.2896.34.camel@obelisk.thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	 <1293139893-11678-8-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:49754 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab0L0Rt3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2010 12:49:29 -0500
In-Reply-To: <1293139893-11678-8-git-send-email-dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

On Thu, 2010-12-23 at 16:31 -0500, David Dillow wrote:
> We don't need protection against the SCSI stack, so use our own lock to
> allow parallel progress on separate CPUs.

> @@ -1126,7 +1125,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>  		return 0;
>  	}
>  
> -	spin_lock_irqsave(shost->host_lock, flags);
> +	spin_lock_irqsave(&target->lock, flags);
>  	/* This goes away once the scsi_eh routines stop testing it. */
>  	scsi_cmd_get_serial(shost, scmnd);
>  	iu = __srp_get_tx_iu(target, SRP_IU_CMD);

This one may be a bit problematic -- I need to look at the required
locking to avoid a race with the serial number. Of course, there's an
easy fix -- if this patch lands after the patches to remove the serial
number check from the error handler, then there's no reason to get a
serial number in the initiator.

