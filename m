From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v8 2/4] block: add runtime pm helpers
Date: Wed, 30 Jan 2013 10:54:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301301053210.1709-100000@iolanthe.rowland.org>
References: <1359538494-2936-3-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48258 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753733Ab3A3Pyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 10:54:54 -0500
In-Reply-To: <1359538494-2936-3-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>

On Wed, 30 Jan 2013, Aaron Lu wrote:

> From: Lin Ming <ming.m.lin@intel.com>
> 
> Add runtime pm helper functions:
> 
> void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
>   - Initialization function for drivers to call.
> 
> int blk_pre_runtime_suspend(struct request_queue *q)
>   - If any requests are in the queue, mark last busy and return -EBUSY.
>     Otherwise set q->rpm_status to RPM_SUSPENDING and return 0.
> 
> void blk_post_runtime_suspend(struct request_queue *q, int err)
>   - If the suspend succeeded then set q->rpm_status to RPM_SUSPENDED.
>     Otherwise set it to RPM_ACTIVE.
> 
> void blk_pre_runtime_resume(struct request_queue *q)
>   - Set q->rpm_status to RPM_RESUMING.
> 
> void blk_post_runtime_resume(struct request_queue *q, int err)
>   - If the resume succeeded then set q->rpm_status to RPM_ACTIVE
>     and call __blk_run_queue, then mark last busy and autosuspend.
>     Otherwise set q->rpm_status to RPM_SUSPENDED.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

> +void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
> +{
> +	q->dev = dev;
> +	q->rpm_status = RPM_ACTIVE;
> +	pm_runtime_set_autosuspend_delay(q->dev, -1);
> +	pm_runtime_use_autosuspend(q->dev);
> +	pm_runtime_mark_last_busy(q->dev);
> +	pm_runtime_autosuspend(q->dev);

This last line is no longer needed.  It can't do anything useful, since 
autosuspends are disabled (the delay is -1).

Alan Stern

