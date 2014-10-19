From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 08/12] IB/srp: Introduce two new srp_target_port member
 variables
Date: Sun, 19 Oct 2014 19:30:27 +0300
Message-ID: <5443E723.9070200@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E51B.20705@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:54901 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJSQae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 12:30:34 -0400
Received: by mail-la0-f44.google.com with SMTP id hs14so2816024lab.3
        for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 09:30:32 -0700 (PDT)
In-Reply-To: <5433E51B.20705@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/7/2014 4:05 PM, Bart Van Assche wrote:
> Introduce the srp_target_port member variables 'sgid' and 'pkey'.
> Change the type of 'orig_dgid' from __be16[8] into union ib_gid.
> This patch does not change any functionality but makes the
> "Separate target and channel variables" patch easier to verify.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 39 ++++++++++++++++++++++---------------
>   drivers/infiniband/ulp/srp/ib_srp.h |  4 +++-
>   2 files changed, 26 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index a662c29..5685062 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -262,7 +262,7 @@ static int srp_init_qp(struct srp_target_port *target,
>
>   	ret = ib_find_pkey(target->srp_host->srp_dev->dev,
>   			   target->srp_host->port,
> -			   be16_to_cpu(target->path.pkey),
> +			   be16_to_cpu(target->pkey),
>   			   &attr->pkey_index);
>   	if (ret)
>   		goto out;
> @@ -295,6 +295,10 @@ static int srp_new_cm_id(struct srp_target_port *target)
>   	if (target->cm_id)
>   		ib_destroy_cm_id(target->cm_id);
>   	target->cm_id = new_cm_id;
> +	target->path.sgid = target->sgid;
> +	target->path.dgid = target->orig_dgid;
> +	target->path.pkey = target->pkey;
> +	target->path.service_id = target->service_id;
>
>   	return 0;
>   }
> @@ -689,7 +693,7 @@ static int srp_send_req(struct srp_target_port *target)
>   	 */
>   	if (target->io_class == SRP_REV10_IB_IO_CLASS) {
>   		memcpy(req->priv.initiator_port_id,
> -		       &target->path.sgid.global.interface_id, 8);
> +		       &target->sgid.global.interface_id, 8);
>   		memcpy(req->priv.initiator_port_id + 8,
>   		       &target->initiator_ext, 8);
>   		memcpy(req->priv.target_port_id,     &target->ioc_guid, 8);
> @@ -698,7 +702,7 @@ static int srp_send_req(struct srp_target_port *target)
>   		memcpy(req->priv.initiator_port_id,
>   		       &target->initiator_ext, 8);
>   		memcpy(req->priv.initiator_port_id + 8,
> -		       &target->path.sgid.global.interface_id, 8);
> +		       &target->sgid.global.interface_id, 8);
>   		memcpy(req->priv.target_port_id,     &target->id_ext, 8);
>   		memcpy(req->priv.target_port_id + 8, &target->ioc_guid, 8);
>   	}
> @@ -2175,8 +2179,8 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
>   			else
>   				shost_printk(KERN_WARNING, shost, PFX
>   					     "SRP LOGIN from %pI6 to %pI6 REJECTED, reason 0x%08x\n",
> -					     target->path.sgid.raw,
> -					     target->orig_dgid, reason);
> +					     target->sgid.raw,
> +					     target->orig_dgid.raw, reason);
>   		} else
>   			shost_printk(KERN_WARNING, shost,
>   				     "  REJ reason: IB_CM_REJ_CONSUMER_DEFINED,"
> @@ -2464,7 +2468,7 @@ static ssize_t show_pkey(struct device *dev, struct device_attribute *attr,
>   {
>   	struct srp_target_port *target = host_to_target(class_to_shost(dev));
>
> -	return sprintf(buf, "0x%04x\n", be16_to_cpu(target->path.pkey));
> +	return sprintf(buf, "0x%04x\n", be16_to_cpu(target->pkey));
>   }
>
>   static ssize_t show_sgid(struct device *dev, struct device_attribute *attr,
> @@ -2472,7 +2476,7 @@ static ssize_t show_sgid(struct device *dev, struct device_attribute *attr,
>   {
>   	struct srp_target_port *target = host_to_target(class_to_shost(dev));
>
> -	return sprintf(buf, "%pI6\n", target->path.sgid.raw);
> +	return sprintf(buf, "%pI6\n", target->sgid.raw);
>   }
>
>   static ssize_t show_dgid(struct device *dev, struct device_attribute *attr,
> @@ -2488,7 +2492,7 @@ static ssize_t show_orig_dgid(struct device *dev,
>   {
>   	struct srp_target_port *target = host_to_target(class_to_shost(dev));
>
> -	return sprintf(buf, "%pI6\n", target->orig_dgid);
> +	return sprintf(buf, "%pI6\n", target->orig_dgid.raw);
>   }
>
>   static ssize_t show_req_lim(struct device *dev,
> @@ -2826,11 +2830,15 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
>   			}
>
>   			for (i = 0; i < 16; ++i) {
> -				strlcpy(dgid, p + i * 2, 3);
> -				target->path.dgid.raw[i] = simple_strtoul(dgid, NULL, 16);
> +				strlcpy(dgid, p + i * 2, sizeof(dgid));
> +				if (sscanf(dgid, "%hhx",
> +					   &target->orig_dgid.raw[i]) < 1) {
> +					ret = -EINVAL;
> +					kfree(p);
> +					goto out;
> +				}
>   			}
>   			kfree(p);
> -			memcpy(target->orig_dgid, target->path.dgid.raw, 16);
>   			break;
>
>   		case SRP_OPT_PKEY:
> @@ -2838,7 +2846,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
>   				pr_warn("bad P_Key parameter '%s'\n", p);
>   				goto out;
>   			}
> -			target->path.pkey = cpu_to_be16(token);
> +			target->pkey = cpu_to_be16(token);
>   			break;
>
>   		case SRP_OPT_SERVICE_ID:
> @@ -2848,7 +2856,6 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
>   				goto out;
>   			}
>   			target->service_id = cpu_to_be64(simple_strtoull(p, NULL, 16));
> -			target->path.service_id = target->service_id;
>   			kfree(p);
>   			break;
>
> @@ -3058,7 +3065,7 @@ static ssize_t srp_create_target(struct device *dev,
>   	if (ret)
>   		goto err_free_mem;
>
> -	ret = ib_query_gid(ibdev, host->port, 0, &target->path.sgid);
> +	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid);
>   	if (ret)
>   		goto err_free_mem;
>
> @@ -3086,9 +3093,9 @@ static ssize_t srp_create_target(struct device *dev,
>   			     "new target: id_ext %016llx ioc_guid %016llx pkey %04x service_id %016llx sgid %pI6 dgid %pI6\n",
>   			     be64_to_cpu(target->id_ext),
>   			     be64_to_cpu(target->ioc_guid),
> -			     be16_to_cpu(target->path.pkey),
> +			     be16_to_cpu(target->pkey),
>   			     be64_to_cpu(target->service_id),
> -			     target->path.sgid.raw, target->orig_dgid);
> +			     target->sgid.raw, target->orig_dgid.raw);
>   	}
>
>   	ret = count;
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index 00c7c48..8635ab6 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -157,6 +157,7 @@ struct srp_target_port {
>   	 * command processing. Try to keep them packed into cachelines.
>   	 */
>
> +	union ib_gid		sgid;
>   	__be64			id_ext;
>   	__be64			ioc_guid;
>   	__be64			service_id;
> @@ -173,8 +174,9 @@ struct srp_target_port {
>   	int			comp_vector;
>   	int			tl_retry_count;
>
> +	union ib_gid		orig_dgid;
> +	__be16			pkey;
>   	struct ib_sa_path_rec	path;
> -	__be16			orig_dgid[8];
>   	struct ib_sa_query     *path_query;
>   	int			path_query_id;
>
>

Yeh looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
