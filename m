From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 11/16] iscsi-target: add new offload transport type
Date: Sun, 10 Apr 2016 20:56:44 +0300
Message-ID: <570A93DC.70301@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <dd151d75ec506c844b6ecb11b9d72d7e38492647.1460204441.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <dd151d75ec506c844b6ecb11b9d72d7e38492647.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org


> +static ssize_t lio_target_np_hw_offload_show(struct config_item *item,
> +					     char *page)
> +{
> +	struct iscsi_tpg_np *tpg_np = to_iscsi_tpg_np(item);
> +	struct iscsi_tpg_np *tpg_np_hw_offload;
> +	ssize_t rb;
> +
> +	tpg_np_hw_offload = iscsit_tpg_locate_child_np(tpg_np,
> +						       ISCSI_HW_OFFLOAD);
> +	if (tpg_np_hw_offload)
> +		rb = sprintf(page, "1\n");
> +	else
> +		rb = sprintf(page, "0\n");
> +
> +	return rb;
> +}
> +
> +static ssize_t lio_target_np_hw_offload_store(struct config_item *item,
> +					      const char *page, size_t count)
> +{
> +	struct iscsi_tpg_np *tpg_np = to_iscsi_tpg_np(item);
> +	struct iscsi_np *np;
> +	struct iscsi_portal_group *tpg;
> +	struct iscsi_tpg_np *tpg_np_hw_offload = NULL;
> +	u32 op;
> +	int rc = 0;
> +
> +	rc = kstrtou32(page, 0, &op);
> +	if (rc)
> +		return rc;
> +
> +	if ((op != 1) && (op != 0)) {
> +		pr_err("Illegal value for tpg_enable: %u\n", op);
> +		return -EINVAL;
> +	}
> +
> +	np = tpg_np->tpg_np;
> +	if (!np) {
> +		pr_err("Unable to locate struct iscsi_np from"
> +		       " struct iscsi_tpg_np\n");
> +		return -EINVAL;
> +	}
> +
> +	tpg = tpg_np->tpg;
> +	if (iscsit_get_tpg(tpg) < 0)
> +		return -EINVAL;
> +
> +	if (op) {
> +		tpg_np_hw_offload = iscsit_tpg_add_network_portal(tpg,
> +				&np->np_sockaddr, tpg_np, ISCSI_HW_OFFLOAD);
> +
> +		if (IS_ERR(tpg_np_hw_offload)) {
> +			rc = PTR_ERR(tpg_np_hw_offload);
> +			goto out;
> +		}
> +	} else {
> +		tpg_np_hw_offload = iscsit_tpg_locate_child_np(tpg_np,
> +				ISCSI_HW_OFFLOAD);
> +
> +		if (tpg_np_hw_offload) {
> +			rc = iscsit_tpg_del_network_portal(tpg,
> +							   tpg_np_hw_offload);
> +			if (rc < 0)
> +				goto out;
> +		}
> +	}
> +
> +	iscsit_put_tpg(tpg);
> +	return count;
> +out:
> +	iscsit_put_tpg(tpg);
> +	return rc;
> +}
> +
>   CONFIGFS_ATTR(lio_target_np_, sctp);
>   CONFIGFS_ATTR(lio_target_np_, iser);
> +CONFIGFS_ATTR(lio_target_np_, hw_offload);

I'd be happy to see new transports being added with some
initiative to reduce the code duplication here (pretty please :))
