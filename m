From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper
	function
Date: Tue, 12 Jan 2016 16:11:19 +0100
Message-ID: <20160112151119.GD2058@lst.de>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com> <1452458668-11034-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452458668-11034-2-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> +struct se_session *
> +target_alloc_session(struct se_portal_group *tpg,
> +		     unsigned int tag_num, unsigned int tag_size,
> +		     enum target_prot_op prot_op,
> +		     const char *initiatorname, void *private,
> +		     int (*callback)(struct se_portal_group *,
> +				     struct se_session *, void *))
> +{

I'd much rather have the fabrics drivers call transport_alloc_session_tags
directly from the callback than growing even more arguments here.

> +	struct se_session *sess;
> +
> +	if (tag_num != 0 && !tag_size) {
> +		pr_err("target_alloc_session called with percpu-ida tag_num:"
> +		       " %u, but zero tag_size\n", tag_num);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	if (!tag_num && tag_size) {
> +		pr_err("target_alloc_session called with percpu-ida tag_size:"
> +		       " %u, but zero tag_num\n", tag_size);
> +		return ERR_PTR(-EINVAL);
> +	}

These checks should be in transport_alloc_session_tags.
