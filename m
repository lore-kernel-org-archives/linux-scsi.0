From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 2/3] block: add queue runtime pm callback
Date: Tue, 15 May 2012 10:37:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205151036510.1796-100000@iolanthe.rowland.org>
References: <1337071697-30920-3-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45560 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758249Ab2EOOhr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 10:37:47 -0400
In-Reply-To: <1337071697-30920-3-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 15 May 2012, Lin Ming wrote:

> Add ->runtime_pm callback and ->pm_status to request queue.
> As an example, implement a simple queue runtime_pm callback
> in sd driver.

> +static int sd_runtime_pm_fn(struct request_queue *q, pm_message_t mesg)
> +{
> +	struct scsi_device *sdp = q->queuedata;
> +
> +	if (mesg.event == PM_EVENT_SUSPEND) {
> +		q->pm_status = RPM_SUSPENDING;
> +		pm_runtime_put(&sdp->sdev_gendev);
> +	}
> +	else if (mesg.event == PM_EVENT_RESUME) {
> +		q->pm_status = RPM_RESUMING;
> +		pm_runtime_get(&sdp->sdev_gendev);
> +	}

Don't use pm_message_t arguments for runtime PM.  Implement separate 
routines for suspend and resume.

Alan Stern

