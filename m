From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/9] percpu-refcount: introduce percpu_ref_is_dead()
Date: Sat, 2 Sep 2017 00:05:20 +0800
Message-ID: <20170901160519.GB20709@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-2-ming.lei@redhat.com>
 <20170901135915.GD1599492@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751945AbdIAQFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Sep 2017 12:05:38 -0400
Content-Disposition: inline
In-Reply-To: <20170901135915.GD1599492@devbig577.frc2.facebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Oleksandr Natalenko <oleksandr@natalenko.name>

On Fri, Sep 01, 2017 at 06:59:15AM -0700, Tejun Heo wrote:
> Hello, Ming.
> 
> > +/**
> > + * percpu_ref_is_dead - test whether a percpu refcount is killed
> > + * @ref: percpu_ref to test
> > + *
> > + * Returns %true if @ref is dead
> > + *
> > + * This function is safe to call as long as @ref is between init and exit.
> > + */
> > +static inline bool percpu_ref_is_dead(struct percpu_ref *ref)
> > +{
> > +	unsigned long __percpu *percpu_count;
> > +
> > +	if (__ref_is_percpu(ref, &percpu_count))
> > +		return false;
> > +	return ref->percpu_count_ptr & __PERCPU_REF_DEAD;
> > +}
> 
> Can you please explain why percpu_ref_is_dying() isn't enough for your
> use case?

Hi Tejun,

You are right, looks percpu_ref_is_dying() is enough,
percpu_ref_get_many() works fine no matter the ref is dying or not.

Thanks!

-- 
Ming
