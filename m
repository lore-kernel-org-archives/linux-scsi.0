From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 06/11] IB/srp: Avoid that I/O hangs due to a cable
 pull during LUN scanning
Date: Thu, 30 Oct 2014 16:28:21 +0200
Message-ID: <54524B05.7020808@dev.mellanox.co.il>
References: <545240AE.6060009@acm.org> <5452416A.1010403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5452416A.1010403-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/30/2014 3:47 PM, Bart Van Assche wrote:
> If a cable is pulled during LUN scanning it can happen that the
> SRP rport and the SCSI host have been created but no LUNs have been
> added to the SCSI host. Since multipathd only sends SCSI commands
> to a SCSI target if one or more SCSI devices are present and since
> there is no keepalive mechanism for IB queue pairs this means that
> after a LUN scan failed and after a reconnect has succeeded no
> data will be sent over the QP and hence that a subsequent cable
> pull will not be detected. Avoid this by not creating an rport or
> SCSI host if a cable is pulled during a SCSI LUN scan.
>
> Note: so far the above behavior has only been observed with the
> kernel module parameter ch_count set to a value >= 2.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 60 +++++++++++++++++++++++++++++++------
>   drivers/infiniband/ulp/srp/ib_srp.h |  1 +
>   2 files changed, 52 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 9608e7a..a662c29 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1111,6 +1111,10 @@ static int srp_rport_reconnect(struct srp_rport *rport)
>   	int i, ret;
>
>   	srp_disconnect_target(target);
> +
> +	if (target->state == SRP_TARGET_SCANNING)
> +		return -ENODEV;
> +
>   	/*
>   	 * Now get a new local CM ID so that we avoid confusing the target in
>   	 * case things are really fouled up. Doing so also ensures that all CM
> @@ -2607,11 +2611,23 @@ static struct scsi_host_template srp_template = {
>   	.shost_attrs			= srp_host_attrs
>   };
>
> +static int srp_sdev_count(struct Scsi_Host *host)
> +{
> +	struct scsi_device *sdev;
> +	int c = 0;
> +
> +	shost_for_each_device(sdev, host)
> +		c++;
> +
> +	return c;
> +}
> +
>   static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
>   {
>   	struct srp_rport_identifiers ids;
>   	struct srp_rport *rport;
>
> +	target->state = SRP_TARGET_SCANNING;
>   	sprintf(target->target_name, "SRP.T10:%016llX",
>   		 (unsigned long long) be64_to_cpu(target->id_ext));
>
> @@ -2634,11 +2650,26 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
>   	list_add_tail(&target->list, &host->target_list);
>   	spin_unlock(&host->target_lock);
>
> -	target->state = SRP_TARGET_LIVE;
> -
>   	scsi_scan_target(&target->scsi_host->shost_gendev,
>   			 0, target->scsi_id, SCAN_WILD_CARD, 0);
>
> +	if (!target->connected || target->qp_in_error) {
> +		shost_printk(KERN_INFO, target->scsi_host,
> +			     PFX "SCSI scan failed - removing SCSI host\n");
> +		srp_queue_remove_work(target);
> +		goto out;
> +	}
> +
> +	pr_debug(PFX "%s: SCSI scan succeeded - detected %d LUNs\n",
> +		 dev_name(&target->scsi_host->shost_gendev),
> +		 srp_sdev_count(target->scsi_host));
> +
> +	spin_lock_irq(&target->lock);
> +	if (target->state == SRP_TARGET_SCANNING)
> +		target->state = SRP_TARGET_LIVE;
> +	spin_unlock_irq(&target->lock);
> +
> +out:
>   	return 0;
>   }
>
> @@ -2982,6 +3013,12 @@ static ssize_t srp_create_target(struct device *dev,
>   	target->tl_retry_count	= 7;
>   	target->queue_size	= SRP_DEFAULT_QUEUE_SIZE;
>
> +	/*
> +	 * Avoid that the SCSI host can be removed by srp_remove_target()
> +	 * before this function returns.
> +	 */
> +	scsi_host_get(target->scsi_host);
> +
>   	mutex_lock(&host->add_target_mutex);
>
>   	ret = srp_parse_options(buf, target);
> @@ -3044,18 +3081,23 @@ static ssize_t srp_create_target(struct device *dev,
>   	if (ret)
>   		goto err_disconnect;
>
> -	shost_printk(KERN_DEBUG, target->scsi_host, PFX
> -		     "new target: id_ext %016llx ioc_guid %016llx pkey %04x service_id %016llx sgid %pI6 dgid %pI6\n",
> -		     be64_to_cpu(target->id_ext),
> -		     be64_to_cpu(target->ioc_guid),
> -		     be16_to_cpu(target->path.pkey),
> -		     be64_to_cpu(target->service_id),
> -		     target->path.sgid.raw, target->path.dgid.raw);
> +	if (target->state != SRP_TARGET_REMOVED) {
> +		shost_printk(KERN_DEBUG, target->scsi_host, PFX
> +			     "new target: id_ext %016llx ioc_guid %016llx pkey %04x service_id %016llx sgid %pI6 dgid %pI6\n",
> +			     be64_to_cpu(target->id_ext),
> +			     be64_to_cpu(target->ioc_guid),
> +			     be16_to_cpu(target->path.pkey),
> +			     be64_to_cpu(target->service_id),
> +			     target->path.sgid.raw, target->orig_dgid);
> +	}
>
>   	ret = count;
>
>   out:
>   	mutex_unlock(&host->add_target_mutex);
> +
> +	scsi_host_put(target->scsi_host);
> +
>   	return ret;
>
>   err_disconnect:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index e46ecb1..00c7c48 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -73,6 +73,7 @@ enum {
>   };
>
>   enum srp_target_state {
> +	SRP_TARGET_SCANNING,
>   	SRP_TARGET_LIVE,
>   	SRP_TARGET_REMOVED,
>   };
>

This looks OK to me.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
