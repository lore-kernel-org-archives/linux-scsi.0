From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] scsi: exports busy status
	via	bdi_lld_congested
Date: Fri, 19 Sep 2008 11:06:04 -0500
Message-ID: <48D3CDEC.9060407@cs.wisc.edu>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
	<20080919.104922.97297160.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080919.104922.97297160.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, j-nomura@ce.jp.nec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, k-ueda@ct.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

Kiyoshi Ueda wrote:
> This patch change scsi mid layer to export its busy status.
> Not set the busy flag, when scsi can't dispatch I/Os anymore and
> needs to kill I/Os.  Otherwise, request stacking drivers may hold
> requests forever.
> 
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/scsi.c     |    4 ++--
>  drivers/scsi/scsi_lib.c |   23 ++++++++++++++++++++++-
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c
> +++ scsi-misc-2.6/drivers/scsi/scsi_lib.c
> @@ -459,17 +459,30 @@ static void scsi_init_cmd_errh(struct sc
>  
>  void scsi_device_unbusy(struct scsi_device *sdev)
>  {
> +	int host_congested;
>  	struct Scsi_Host *shost = sdev->host;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	shost->host_busy--;
> +	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> +	    shost->host_blocked || shost->host_self_blocked ||
> +	    scsi_host_in_recovery(shost))
> +		host_congested = 1;
> +	else
> +		host_congested = 0;
> +

You might want to check if the starget busy too (scsi-misc has this but 
Jens's tree and linus do not)? The code below that I snipped from 
scsi_request_fn will set the congested bits if scsi_target_queue_ready 
returns 0, so above here you would want to clear it if it not congested 
anymore.

>  	if (unlikely(scsi_host_in_recovery(shost) &&
>  		     (shost->host_failed || shost->host_eh_scheduled)))
>  		scsi_eh_wakeup(shost);
>  	spin_unlock(shost->host_lock);
> +
>  	spin_lock(sdev->request_queue->queue_lock);
>  	sdev->device_busy--;
> +	if (bdi_lld_congested(&sdev->request_queue->backing_dev_info) &&
> +	    !host_congested && sdev->device_busy < sdev->queue_depth &&
> +	    !sdev->device_blocked)
> +		clear_bdi_lld_congested(&sdev->request_queue->backing_dev_info);
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>  }
>  



> @@ -1593,6 +1613,7 @@ static void scsi_request_fn(struct reque
>  	 * later time.
>  	 */
>  	spin_lock_irq(q->queue_lock);
> +	set_bdi_lld_congested(&q->backing_dev_info);
>  	blk_requeue_request(q, req);
>  	sdev->device_busy--;
>  	if(sdev->device_busy == 0)
