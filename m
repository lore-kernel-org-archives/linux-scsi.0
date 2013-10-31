From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Date: Thu, 31 Oct 2013 08:56:53 -0700
Message-ID: <20131031155653.GA16944@infradead.org>
References: <52718713.7050906@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52718713.7050906@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, vaughan <vaughan.cao@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> +	struct semaphore or_sem;  /* protect co-incident opens and releases */

Seems like this should be a mutex.

> sfds_list_empty(Sg_device *sdp)
>  {
>  	unsigned long flags;
>  	int ret;
>  
> +	spin_lock_irqsave(&sdp->sfd_lock, flags);
> +	ret = list_empty(&sdp->sfds);
> +	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
>  	return ret;

Protecting just a list_empty check with a local will give you racy
results.  Seems like you should take the look over the check and the
resulting action that modifies the list.  That'd also mean replacing the
wait_event* calls with open coded prepare_wait / finish_wait loops.

> +	down(&sdp->or_sem);
> +	alone = sfds_list_empty(sdp);
> +	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
> +		retval = -EPERM; /* Don't allow O_EXCL with read only access */
> +		goto error_out;
> +	}

Seems like the pure flags check should move to the beginning of the
function before taking any locks.
