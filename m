From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/17] Add ida and idr helper routines.
Date: Tue, 15 Sep 2015 11:38:42 -0700
Message-ID: <1442342322.2177.13.camel@HansenPartnership.com>
References: <cover.1442263512.git.lduncan@suse.com>
	 <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
	 <20150915182755.GA31484@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150915182755.GA31484@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-09-15 at 14:27 -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 15, 2015 at 09:46:01AM -0700, Lee Duncan wrote:
> > +/**
> > + * ida_get_index - allocate a ida index value
> > + * @ida		idr handle
> > + * @lock	spinlock handle protecting this index
> > + * @p_id	pointer to allocated index value
> > + *
> > + * A helper function for safely allocating an index value (id),
> > + * returning a negative errno value on failure, else 0.
> > + */
> > +static inline int ida_get_index(struct ida *ida, spinlock_t *lock, int *p_id)
> > +{
> > +	int error = -ENOMEM;
> > +
> > +	do {
> > +		if (!ida_pre_get(ida, GFP_KERNEL))
> > +			break;
> > +		spin_lock(lock);
> > +		error = ida_get_new(ida, p_id);
> > +		spin_unlock(lock);
> > +	} while (error == -EAGAIN);
> > +
> > +	return error;
> > +}
> 
> Obviously ida allocation doesn't need to be synchronized against
> anything else.  Why not just use ida_simple_get/remove()?

For most of the SCSI stuff, yes.  I'm less sure about the sd numbers.
They go up very high and get hammered a lot during system bring up and
hot plug.  I think having their own lock rather than wrapping everything
around simple_ida_lock makes more sense here just because the system is
heavily contended on getting indexes at bring up.

To continue the thought, why not move simple_ida_lock into struct ida so
we don't have to worry about the contention and can sue ida_simple_...
everywhere?

James
