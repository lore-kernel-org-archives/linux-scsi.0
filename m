From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] ipr: Wait for aborted command responses
Date: Fri, 31 Oct 2014 08:45:56 -0500
Message-ID: <54539294.7010209@linux.vnet.ibm.com>
References: <201410302227.s9UMRAix027807@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201410302227.s9UMRAix027807@d01av02.pok.ibm.com>
Sender: stable-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Adding Wendy...

On 10/30/2014 05:27 PM, Brian King wrote:
> Fixes a race condition in abort handling that was injected
> when multiple interrupt support was added. When only a single
> interrupt is present, the adapter guarantees it will send
> responses for aborted commands prior to the response for the
> abort command itself. With multiple interrupts, these responses
> generally come back on different interrupts, so we need to
> ensure the abort thread waits until the aborted command is
> complete so we don't perform a double completion. This race
> condition was being hit frequently in environments which
> were triggering command timeouts, which was resulting in
> a double completion causing a kernel oops.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ipr.h |    1 
>  2 files changed, 93 insertions(+)
> 
> diff -puN drivers/scsi/ipr.c~ipr_eh_wait drivers/scsi/ipr.c
> --- scsi-queue/drivers/scsi/ipr.c~ipr_eh_wait	2014-10-30 17:15:37.302753120 -0500
> +++ scsi-queue-bjking1/drivers/scsi/ipr.c	2014-10-30 17:15:37.311753039 -0500
> @@ -683,6 +683,7 @@ static void ipr_init_ipr_cmnd(struct ipr
>  	ipr_reinit_ipr_cmnd(ipr_cmd);
>  	ipr_cmd->u.scratch = 0;
>  	ipr_cmd->sibling = NULL;
> +	ipr_cmd->eh_comp = NULL;
>  	ipr_cmd->fast_done = fast_done;
>  	init_timer(&ipr_cmd->timer);
>  }
> @@ -848,6 +849,8 @@ static void ipr_scsi_eh_done(struct ipr_
> 
>  	scsi_dma_unmap(ipr_cmd->scsi_cmd);
>  	scsi_cmd->scsi_done(scsi_cmd);
> +	if (ipr_cmd->eh_comp)
> +		complete(ipr_cmd->eh_comp);
>  	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  }
> 
> @@ -4854,6 +4857,84 @@ static int ipr_slave_alloc(struct scsi_d
>  	return rc;
>  }
> 
> +/**
> + * ipr_match_lun - Match function for specified LUN
> + * @ipr_cmd:	ipr command struct
> + * @device:		device to match (sdev)
> + *
> + * Returns:
> + *	1 if command matches sdev / 0 if command does not match sdev
> + **/
> +static int ipr_match_lun(struct ipr_cmnd *ipr_cmd, void *device)
> +{
> +	if (ipr_cmd->scsi_cmd && ipr_cmd->scsi_cmd->device == device)
> +		return 1;
> +	return 0;
> +}
> +
> +/**
> + * ipr_wait_for_ops - Wait for matching commands to complete
> + * @ipr_cmd:	ipr command struct
> + * @device:		device to match (sdev)
> + * @match:		match function to use
> + *
> + * Returns:
> + *	SUCCESS / FAILED
> + **/
> +static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
> +			    int (*match)(struct ipr_cmnd *, void *))
> +{
> +	struct ipr_cmnd *ipr_cmd;
> +	int wait;
> +	unsigned long flags;
> +	struct ipr_hrr_queue *hrrq;
> +	signed long timeout = IPR_ABORT_TASK_TIMEOUT;
> +	DECLARE_COMPLETION_ONSTACK(comp);
> +
> +	ENTER;
> +	do {
> +		wait = 0;
> +
> +		for_each_hrrq(hrrq, ioa_cfg) {
> +			spin_lock_irqsave(hrrq->lock, flags);
> +			list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
> +				if (match(ipr_cmd, device)) {
> +					ipr_cmd->eh_comp = &comp;
> +					wait++;
> +				}
> +			}
> +			spin_unlock_irqrestore(hrrq->lock, flags);
> +		}
> +
> +		if (wait) {
> +			timeout = wait_for_completion_timeout(&comp, timeout);
> +
> +			if (!timeout) {
> +				wait = 0;
> +
> +				for_each_hrrq(hrrq, ioa_cfg) {
> +					spin_lock_irqsave(hrrq->lock, flags);
> +					list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
> +						if (match(ipr_cmd, device)) {
> +							ipr_cmd->eh_comp = NULL;
> +							wait++;
> +						}
> +					}
> +					spin_unlock_irqrestore(hrrq->lock, flags);
> +				}
> +
> +				if (wait)
> +					dev_err(&ioa_cfg->pdev->dev, "Timed out waiting for aborted commands\n");
> +				LEAVE;
> +				return wait ? FAILED : SUCCESS;
> +			}
> +		}
> +	} while (wait);
> +
> +	LEAVE;
> +	return SUCCESS;
> +}
> +
>  static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg;
> @@ -5073,11 +5154,17 @@ static int __ipr_eh_dev_reset(struct scs
>  static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
>  {
>  	int rc;
> +	struct ipr_ioa_cfg *ioa_cfg;
> +
> +	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
> 
>  	spin_lock_irq(cmd->device->host->host_lock);
>  	rc = __ipr_eh_dev_reset(cmd);
>  	spin_unlock_irq(cmd->device->host->host_lock);
> 
> +	if (rc == SUCCESS)
> +		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
> +
>  	return rc;
>  }
> 
> @@ -5255,13 +5342,18 @@ static int ipr_eh_abort(struct scsi_cmnd
>  {
>  	unsigned long flags;
>  	int rc;
> +	struct ipr_ioa_cfg *ioa_cfg;
> 
>  	ENTER;
> 
> +	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
> +
>  	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
>  	rc = ipr_cancel_op(scsi_cmd);
>  	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
> 
> +	if (rc == SUCCESS)
> +		rc = ipr_wait_for_ops(ioa_cfg, scsi_cmd->device, ipr_match_lun);
>  	LEAVE;
>  	return rc;
>  }
> diff -puN drivers/scsi/ipr.h~ipr_eh_wait drivers/scsi/ipr.h
> --- scsi-queue/drivers/scsi/ipr.h~ipr_eh_wait	2014-10-30 17:15:37.305753093 -0500
> +++ scsi-queue-bjking1/drivers/scsi/ipr.h	2014-10-30 17:15:37.315753003 -0500
> @@ -1608,6 +1608,7 @@ struct ipr_cmnd {
>  		struct scsi_device *sdev;
>  	} u;
> 
> +	struct completion *eh_comp;
>  	struct ipr_hrr_queue *hrrq;
>  	struct ipr_ioa_cfg *ioa_cfg;
>  };
> _
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
