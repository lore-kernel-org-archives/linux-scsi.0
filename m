From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 03/12] IB/srp: Remove an extraneous scsi_host_put() from
 an error path
Date: Thu, 30 Apr 2015 12:44:42 +0300
Message-ID: <5541F98A.1080206@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EE80.6070505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38165 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbbD3Jor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 05:44:47 -0400
Received: by wiun10 with SMTP id n10so11062800wiu.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2015 02:44:46 -0700 (PDT)
In-Reply-To: <5541EE80.6070505@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/30/2015 11:57 AM, Bart Van Assche wrote:
> Fix a scsi_get_host() / scsi_host_put() imbalance in the error
> path of srp_create_target(). See also patch "IB/srp: Avoid that
> I/O hangs due to a cable pull during LUN scanning" (commit ID
> 34aa654ecb8e).
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
> Cc: <stable@vger.kernel.org> #v3.19
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 918814c..5ce6cfd 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3172,11 +3172,11 @@ static ssize_t srp_create_target(struct device *dev,
>
>   	ret = srp_parse_options(buf, target);
>   	if (ret)
> -		goto err;
> +		goto out;
>
>   	ret = scsi_init_shared_tag_map(target_host, target_host->can_queue);
>   	if (ret)
> -		goto err;
> +		goto out;
>
>   	target->req_ring_size = target->queue_size - SRP_TSK_MGMT_SQ_SIZE;
>
> @@ -3187,7 +3187,7 @@ static ssize_t srp_create_target(struct device *dev,
>   			     be64_to_cpu(target->ioc_guid),
>   			     be64_to_cpu(target->initiator_ext));
>   		ret = -EEXIST;
> -		goto err;
> +		goto out;
>   	}
>
>   	if (!srp_dev->has_fmr && !srp_dev->has_fr && !target->allow_ext_sg &&
> @@ -3208,7 +3208,7 @@ static ssize_t srp_create_target(struct device *dev,
>   	spin_lock_init(&target->lock);
>   	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid);
>   	if (ret)
> -		goto err;
> +		goto out;
>
>   	ret = -ENOMEM;
>   	target->ch_count = max_t(unsigned, num_online_nodes(),
> @@ -3219,7 +3219,7 @@ static ssize_t srp_create_target(struct device *dev,
>   	target->ch = kcalloc(target->ch_count, sizeof(*target->ch),
>   			     GFP_KERNEL);
>   	if (!target->ch)
> -		goto err;
> +		goto out;
>
>   	node_idx = 0;
>   	for_each_online_node(node) {
> @@ -3315,9 +3315,6 @@ err_disconnect:
>   	}
>
>   	kfree(target->ch);
> -
> -err:
> -	scsi_host_put(target_host);
>   	goto out;
>   }
>
>

Looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
