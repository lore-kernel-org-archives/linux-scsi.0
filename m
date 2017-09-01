From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/9] percpu-refcount: introduce percpu_ref_is_dead()
Date: Fri, 1 Sep 2017 06:59:15 -0700
Message-ID: <20170901135915.GD1599492@devbig577.frc2.facebook.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170831172728.15817-2-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Oleksandr Natalenko <oleksandr@natalenko.name>
List-Id: linux-scsi@vger.kernel.org

Hello, Ming.

> +/**
> + * percpu_ref_is_dead - test whether a percpu refcount is killed
> + * @ref: percpu_ref to test
> + *
> + * Returns %true if @ref is dead
> + *
> + * This function is safe to call as long as @ref is between init and exit.
> + */
> +static inline bool percpu_ref_is_dead(struct percpu_ref *ref)
> +{
> +	unsigned long __percpu *percpu_count;
> +
> +	if (__ref_is_percpu(ref, &percpu_count))
> +		return false;
> +	return ref->percpu_count_ptr & __PERCPU_REF_DEAD;
> +}

Can you please explain why percpu_ref_is_dying() isn't enough for your
use case?

Thanks.

-- 
tejun
