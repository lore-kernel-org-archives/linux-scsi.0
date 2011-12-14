From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] [SCSI] sd: fix runtime status check in sd_shutdown
Date: Wed, 14 Dec 2011 11:49:57 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1112141146230.1707-100000@iolanthe.rowland.org>
References: <1323832681-7177-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323832681-7177-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 14 Dec 2011, Lin Ming wrote:

> Commit af8db15 disabled device's runtime PM during shutdown.
> So sd's runtime status can't be checked with pm_runtime_suspended(dev)
> any more.
> 
> Fix it by checking runtime status with pm_runtime_status_suspended(dev).
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/scsi/sd.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7b3f807..284b087 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2742,7 +2742,12 @@ static void sd_shutdown(struct device *dev)
>  	if (!sdkp)
>  		return;         /* this can happen */
>  
> -	if (pm_runtime_suspended(dev))
> +	/*
> +	 * Check runtime status with pm_runtime_status_suspended(dev)
> +	 * instead of pm_runtime_suspended(dev),
> +	 * because device_shutdown() has disabled the device's runtime PM.
> +	 */
> +	if (pm_runtime_status_suspended(dev))
>  		goto exit;
>  
>  	if (sdkp->WCE) {

This is no longer needed.  See commit
fe6b91f47080eb17d21cbf2a39311877d57f6938 (PM / Driver core: leave
runtime PM enabled during system shutdown).

Alan Stern
