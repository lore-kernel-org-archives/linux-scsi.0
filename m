From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 07/12] IB/srp: Avoid that I/O hangs due to a cable
 pull during LUN scanning
Date: Sun, 19 Oct 2014 19:27:27 +0300
Message-ID: <5443E66F.7050901@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E504.1070306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54557 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaJSQ1e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 12:27:34 -0400
Received: by mail-lb0-f170.google.com with SMTP id u10so2768474lbd.29
        for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 09:27:32 -0700 (PDT)
In-Reply-To: <5433E504.1070306@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/7/2014 4:05 PM, Bart Van Assche wrote:
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
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
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

Is this really an SRP specific routine?
Can you move it to a more natural location?

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

So my impression is that by conditioning target->qp_in_error you are
relying on the fact that SRP eh was invoked here (RC error), what if
scsi eh was invoked prior to that? did you test this path?

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

