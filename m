From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [RFC 2/2] dual scan thread bug fix
Date: Fri, 3 Jan 2014 10:58:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401031047150.15237-100000@netrider.rowland.org>
References: <1388709533.2399.34.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388709533.2399.34.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2 Jan 2014, James Bottomley wrote:

> In the highly unusual case where two threads are running concurrently through
> the scanning code scanning the same target, we run into the situation where
> one may allocate the target while the other is still using it.  In this case,
> because the reap checks for STARGET_CREATED and kills the target without
> reference counting, the second thread will do the wrong thing on reap.
> 
> Fix this by reference counting even creates and doing the STARGET_CREATED
> check in the final put.

I'm still concerned about one thing.  The previous patch does this in
scsi_alloc_target():

>   found:
> -	found_target->reap_ref++;
> +	if (!kref_get_unless_zero(&found_target->reap_ref))
> +		/*
> +		 * release routine already fired.  Target is dead, but
> +		 * STARGET_DEL may not yet be set (set in the release
> +		 * routine), so set here as well, just in case
> +		 */
> +		found_target->state = STARGET_DEL;
>  	spin_unlock_irqrestore(shost->host_lock, flags);

As a result, the two comments in this patch aren't right:

> @@ -384,9 +385,15 @@ static void scsi_target_reap_ref_release(struct kref *kref)
>  	struct scsi_target *starget
>  		= container_of(kref, struct scsi_target, reap_ref);
>  
> -	transport_remove_device(&starget->dev);
> -	device_del(&starget->dev);
> -	starget->state = STARGET_DEL;
> +	/*
> +	 * if we get here and the target is still in the CREATED state that
> +	 * means it was allocated but never made visible (because a scan
> +	 * turned up no LUNs), so don't call device_del() on it.
> +	 */
> +	if (starget->state == STARGET_RUNNING) {
> +		transport_remove_device(&starget->dev);
> +		device_del(&starget->dev);
> +	}

Here the state could already be STARGET_DEL, even though the target is
still visible.

Also, it's a little odd that the comment talks about CREATED but the 
code really checks for RUNNING.  They should be consistent.

> @@ -506,11 +513,13 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>   */
>  void scsi_target_reap(struct scsi_target *starget)
>  {
> +	/*
> +	 * serious problem if this triggers: STARGET_DEL is only set in the
> +	 * kref release routine, so we're doing another final put on an
> +	 * already released kref
> +	 */
>  	BUG_ON(starget->state == STARGET_DEL);

Here the code is okay but the comment is wrong: STARGET_DEL is set in 
_two_ places (but neither of them runs until reap_ref has reached 0).

Would it be better in scsi_alloc_target() to behave as though the state 
were STARGET_DEL without actually setting it?

Alan Stern


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
