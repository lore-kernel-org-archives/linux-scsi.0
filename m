From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Thu, 30 Apr 2015 12:32:04 +0300
Message-ID: <5541F694.8060303@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EE4A.30803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541EE4A.30803-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 4/30/2015 11:56 AM, Bart Van Assche wrote:
> Introduce the helper function srp_wait_for_queuecommand().
> Move the definition of scsi_request_fn_active(). This patch
> does not change any functionality. A second call to
> scsi_wait_for_queuecommand() will be introduced in the next
> patch.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v3.13
> ---
>   drivers/scsi/scsi_transport_srp.c | 52 ++++++++++++++++++++++-----------------
>   1 file changed, 29 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index ae45bd9..6ce1c48 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -396,6 +396,34 @@ static void srp_reconnect_work(struct work_struct *work)
>   	}
>   }
>
> +/**
> + * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
> + * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
> + */
> +static int scsi_request_fn_active(struct Scsi_Host *shost)
> +{
> +	struct scsi_device *sdev;
> +	struct request_queue *q;
> +	int request_fn_active = 0;
> +
> +	shost_for_each_device(sdev, shost) {
> +		q = sdev->request_queue;
> +
> +		spin_lock_irq(q->queue_lock);
> +		request_fn_active += q->request_fn_active;
> +		spin_unlock_irq(q->queue_lock);
> +	}
> +
> +	return request_fn_active;
> +}
> +
> +/* Wait until ongoing shost->hostt->queuecommand() calls have finished. */
> +static void srp_wait_for_queuecommand(struct Scsi_Host *shost)
> +{
> +	while (scsi_request_fn_active(shost))
> +		msleep(20);
> +}
> +
>   static void __rport_fail_io_fast(struct srp_rport *rport)
>   {
>   	struct Scsi_Host *shost = rport_to_shost(rport);
> @@ -504,27 +532,6 @@ void srp_start_tl_fail_timers(struct srp_rport *rport)
>   EXPORT_SYMBOL(srp_start_tl_fail_timers);
>
>   /**
> - * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
> - * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
> - */
> -static int scsi_request_fn_active(struct Scsi_Host *shost)
> -{
> -	struct scsi_device *sdev;
> -	struct request_queue *q;
> -	int request_fn_active = 0;
> -
> -	shost_for_each_device(sdev, shost) {
> -		q = sdev->request_queue;
> -
> -		spin_lock_irq(q->queue_lock);
> -		request_fn_active += q->request_fn_active;
> -		spin_unlock_irq(q->queue_lock);
> -	}
> -
> -	return request_fn_active;
> -}
> -
> -/**
>    * srp_reconnect_rport() - reconnect to an SRP target port
>    * @rport: SRP target port.
>    *
> @@ -559,8 +566,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
>   	if (res)
>   		goto out;
>   	scsi_target_block(&shost->shost_gendev);
> -	while (scsi_request_fn_active(shost))
> -		msleep(20);
> +	srp_wait_for_queuecommand(shost);
>   	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
>   	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
>   		 dev_name(&shost->shost_gendev), rport->state, res);
>

Looks good.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
