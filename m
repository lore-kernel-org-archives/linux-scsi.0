From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] scsi: fix potential dead lock for host runtime pm
Date: Wed, 2 Nov 2011 10:41:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1111021034190.2217-100000@iolanthe.rowland.org>
References: <1320214900-2112-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1320214900-2112-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2 Nov 2011, Lin Ming wrote:

> In later patch hooks will be added to do ata port runtime pm through scsi layer.
> libata schedules scsi EH to handle suspend, then dead lock happens
> because scsi EH in turn waits for the ongoing suspend, as below.
> 
> <scsi host runtime suspend>
>  scsi_autopm_put_host
>    pm_runtime_put_sync
>      <scsi_host runtime pm status updated to RPM_SUSPENDING>
>      ......
>        <call libata hook to do suspend>
>          <wake up scsi EH to handle suspend>
>          <wait for scsi EH ...>
> 
> <scsi EH wake up>
>  scsi_error_handler
>    <resume scsi host>
>    scsi_autopm_get_host
>      pm_runtime_get_sync
>      .....
>        <sleep to wait for the ongoing scsi host suspend>
> 
> This patch fixes the dead lock by checking if there is ongoing runtime PM request.
> If there is ongoing runtime PM request, scsi_autopm_get_host_noresume is called to
> increase the usage count, but don't resume the host.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/scsi/scsi_error.c |    4 +++-
>  drivers/scsi/scsi_pm.c    |   11 +++++++++++
>  drivers/scsi/scsi_priv.h  |    2 ++
>  3 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a4b9cdb..d35d8f7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1804,7 +1804,9 @@ int scsi_error_handler(void *data)
>  		 * what we need to do to get it up and online again (if we can).
>  		 * If we fail, we end up taking the thing offline.
>  		 */
> -		if (scsi_autopm_get_host(shost) != 0) {
> +		if (scsi_autopm_host_busy(shost))
> +			scsi_autopm_get_host_noresume(shost);
> +		else if (scsi_autopm_get_host(shost) != 0) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
>  				printk(KERN_ERR "Error handler scsi_eh_%d "
>  						"unable to autoresume\n",

Here's what I'm worried about:  Suppose during normal operation, an 
error occurs.  When the command is completed, runtime PM might start to 
suspend the host.  But then the error-handler thread starts up, and 
of course it needs the host to be powered-up in order to recover from 
the error.  The code you're adding could prevent this from working.

What we really need is a way to prevent host from going into runtime
suspend while the error-handler is pending or running.  Do you have any
ideas on how to do this?

> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d82a023a..1be6c5a 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -185,6 +185,17 @@ void scsi_autopm_put_host(struct Scsi_Host *shost)
>  	pm_runtime_put_sync(&shost->shost_gendev);
>  }
>  
> +bool scsi_autopm_host_busy(struct Scsi_Host *shost)
> +{
> +	return (shost->shost_gendev.power.runtime_status == RPM_RESUMING
> +		|| shost->shost_gendev.power.runtime_status == RPM_SUSPENDING);
> +}
> +
> +void scsi_autopm_get_host_noresume(struct Scsi_Host *shost)
> +{
> +	pm_runtime_get_noresume(&shost->shost_gendev);
> +}
> +
>  #else
>  
>  #define scsi_runtime_suspend	NULL
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 2a58895..1750651 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -156,6 +156,8 @@ extern void scsi_autopm_get_target(struct scsi_target *);
>  extern void scsi_autopm_put_target(struct scsi_target *);
>  extern int scsi_autopm_get_host(struct Scsi_Host *);
>  extern void scsi_autopm_put_host(struct Scsi_Host *);
> +extern bool scsi_autopm_host_busy(struct Scsi_Host *shost);
> +extern void scsi_autopm_get_host_noresume(struct Scsi_Host *);
>  #else
>  static inline void scsi_autopm_get_target(struct scsi_target *t) {}
>  static inline void scsi_autopm_put_target(struct scsi_target *t) {}

I bet you didn't try compiling this with CONFIG_PM_RUNTIME turned off.

Alan Stern

