From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] target: Allocate se_luns only when used
Date: Fri, 7 Mar 2014 02:41:14 -0800
Message-ID: <20140307104114.GC14195@infradead.org>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
 <1394144131-31499-6-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1394144131-31499-6-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -	se_tpg->tpg_lun_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
> -			sizeof(struct se_lun), GFP_KERNEL);
> +	se_tpg->tpg_lun_list = kzalloc(TRANSPORT_MAX_LUNS_PER_TPG * sizeof(void*),
> +				       GFP_KERNEL);

Again seems like the pointer array should just be embedded instead of
dynamically allocated.  Also given that it's properly typdef the kcalloc
should have used the type instead of void *.  And it should have been
kcalloc to start with..

> +void core_tpg_free_lun(
> +	struct se_portal_group *tpg,
> +	struct se_lun *lun)
> +{
>  	spin_lock(&tpg->tpg_lun_lock);
> -	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
> +	tpg->tpg_lun_list[lun->unpacked_lun] = NULL;
>  	spin_unlock(&tpg->tpg_lun_lock);
> +
> +	kfree(lun);

I can't see how the synchronization can work without refcounting the lun
structure.  The lock just protectes the assignment, but you free it
right after.  What happens to how jsut dereferenced it under the lock
but then uses it outside (e.g. core_dev_add_initiator_node_lun_acl).
