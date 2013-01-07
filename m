From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 2/4] block: add runtime pm helpers
Date: Mon, 7 Jan 2013 12:15:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301071214290.1658-100000@iolanthe.rowland.org>
References: <1357461697-4219-3-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1357461697-4219-3-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 6 Jan 2013, Aaron Lu wrote:

> From: Lin Ming <ming.m.lin@intel.com>
> 
> Add runtime pm helper functions:
> 
> void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
>   - Initialization function for drivers to call.
> 
> int blk_pre_runtime_suspend(struct request_queue *q)
>   - If any requests are in the queue, return -EBUSY.
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
>     and call __blk_run_queue.
>     Otherwise set q->rpm_status to RPM_SUSPENDED.
> 
> [aaron.lu@intel.com: do not touch last busy in these helper functions]
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -19,6 +19,7 @@
>  #include <linux/gfp.h>
>  #include <linux/bsg.h>
>  #include <linux/smp.h>
> +#include <linux/pm_runtime.h>

This doesn't belong here.  Clients of the block layer don't need to 
know about pm_runtime.h.  Move this #include to block/blk-core.c.

Alan Stern


