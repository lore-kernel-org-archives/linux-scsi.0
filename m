From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper
 function
Date: Wed, 13 Jan 2016 00:09:26 -0800
Message-ID: <1452672566.27508.44.camel@haakon3.risingtidesystems.com>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com>
	 <1452458668-11034-2-git-send-email-nab@daterainc.com>
	 <20160112151119.GD2058@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160112151119.GD2058@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-01-12 at 16:11 +0100, Christoph Hellwig wrote:
> > +struct se_session *
> > +target_alloc_session(struct se_portal_group *tpg,
> > +		     unsigned int tag_num, unsigned int tag_size,
> > +		     enum target_prot_op prot_op,
> > +		     const char *initiatorname, void *private,
> > +		     int (*callback)(struct se_portal_group *,
> > +				     struct se_session *, void *))
> > +{
> 
> I'd much rather have the fabrics drivers call transport_alloc_session_tags
> directly from the callback than growing even more arguments here.
> 

What's the point..?

Only vhost-scsi currently needs to allocate extra resources for
se_session percpu-ida tag pre-allocation.

The rest of the consumers can just use this common code.

> > +	struct se_session *sess;
> > +
> > +	if (tag_num != 0 && !tag_size) {
> > +		pr_err("target_alloc_session called with percpu-ida tag_num:"
> > +		       " %u, but zero tag_size\n", tag_num);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +	if (!tag_num && tag_size) {
> > +		pr_err("target_alloc_session called with percpu-ida tag_size:"
> > +		       " %u, but zero tag_num\n", tag_size);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> 
> These checks should be in transport_alloc_session_tags.
> 

Done.
