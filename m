From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/17] Add ida and idr helper routines.
Date: Tue, 15 Sep 2015 14:27:55 -0400
Message-ID: <20150915182755.GA31484@htj.duckdns.org>
References: <cover.1442263512.git.lduncan@suse.com>
 <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Sep 15, 2015 at 09:46:01AM -0700, Lee Duncan wrote:
> +/**
> + * ida_get_index - allocate a ida index value
> + * @ida		idr handle
> + * @lock	spinlock handle protecting this index
> + * @p_id	pointer to allocated index value
> + *
> + * A helper function for safely allocating an index value (id),
> + * returning a negative errno value on failure, else 0.
> + */
> +static inline int ida_get_index(struct ida *ida, spinlock_t *lock, int *p_id)
> +{
> +	int error = -ENOMEM;
> +
> +	do {
> +		if (!ida_pre_get(ida, GFP_KERNEL))
> +			break;
> +		spin_lock(lock);
> +		error = ida_get_new(ida, p_id);
> +		spin_unlock(lock);
> +	} while (error == -EAGAIN);
> +
> +	return error;
> +}

Obviously ida allocation doesn't need to be synchronized against
anything else.  Why not just use ida_simple_get/remove()?

Thanks.

-- 
tejun
