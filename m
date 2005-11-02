From: "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [PATCH/RFC v2] IB: Add SCSI RDMA Protocol (SRP) initiator
Date: Thu, 3 Nov 2005 00:03:58 +0200
Message-ID: <20051102220358.GA27132@mellanox.co.il>
References: <52r79y91jz.fsf_-_@cisco.com>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [194.90.237.34] ([194.90.237.34]:53219 "EHLO
	mtlex01.yok.mtl.com") by vger.kernel.org with ESMTP id S965293AbVKBWBF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Nov 2005 17:01:05 -0500
Content-Disposition: inline
In-Reply-To: <52r79y91jz.fsf_-_@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rolandd@cisco.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, openib-general@openib.org

Hello, Roland!
Quoting Roland Dreier <rolandd@cisco.com>:
> +static int srp_init_qp(struct srp_target_port *target,
> +		       struct ib_qp *qp)
> +{
> +	struct ib_qp_attr *attr;
> +	int ret;
> +
> +	attr = kmalloc(sizeof *attr, GFP_KERNEL);
> +	if (!attr)
> +		return -ENOMEM;
> +
> +	ret = ib_find_cached_pkey(target->srp_host->dev,
> +				  target->srp_host->port,
> +				  be16_to_cpu(target->path.pkey),
> +				  &attr->pkey_index);
> +	if (ret)
> +		return ret;
> +
> +	attr->qp_state        = IB_QPS_INIT;
> +	attr->qp_access_flags = (IB_ACCESS_REMOTE_READ |
> +				    IB_ACCESS_REMOTE_WRITE);
> +	attr->port_num        = target->srp_host->port;
> +
> +	return ib_modify_qp(qp, attr,
> +			    IB_QP_STATE		|
> +			    IB_QP_PKEY_INDEX	|
> +			    IB_QP_ACCESS_FLAGS	|
> +			    IB_QP_PORT);
> +}

This seems to leak sizeof *attr bytes if ib_find_cached_pkey
returns an error.

-- 
MST
