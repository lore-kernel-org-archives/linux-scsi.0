From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Thu, 19 Jun 2008 12:23:10 -0600
Message-ID: <20080619182310.GA30833@parisc-linux.org>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080425091122.GA14990-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
Cc: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


This discussion seemed to die off ... did anything ever come of it?

On Fri, Apr 25, 2008 at 03:11:23AM -0600, Matthew Wilcox wrote:
> On Fri, Apr 25, 2008 at 11:15:36AM +0300, Pekka J Enberg wrote:
> > On Fri, 25 Apr 2008, Stefan Richter wrote:
> > > Besides, can't you use the generic async scan facility of the SCSI stack for
> > > your purpose?  If not, can it be extended to make it usable?
> > 
> > So you mean drivers/scsi/scsi_scan.c, right? We probably can and 
> > should so I'll take a look.
> 
> The problem is that USB has one scsi_host per device (rather than, say,
> having one scsi_host and adding new devices to it as they're found on
> the USB bus).
> 
> I'm certainly open to ideas of hooking into the mechanism -- it's just a
> list of completions after all.  Something like this:
> 
> void *scsi_insert_into_scan_list(void)
> {
> 	return scsi_prep_async_scan(NULL);
> }
> 
> void scsi_scan_completed(void *cookie)
> {
> 	struct async_scan_data *data = cookie;
> 	wait_for_completion(&data->prev_finished);
> 	spin_lock(&async_scan_lock);
> 	list_del(&data->list);
> 	if (!list_empty(&scanning_hosts)) {
> 		struct async_scan_data *next = list_entry(scanning_hosts.next,
> 				struct async_scan_data, list);
> 		complete(&next->prev_finished);
> 	}
> 	spin_unlock(&async_scan_lock);
> 
> 	kfree(data);
> }
> 
> Perhaps refactor a little -- everything inside the async_scan_lock would
> be common to scsi_scan_completed() and scsi_finish_async_scan().
> 
> with appropriate checks for shost being NULL in scsi_prep_async_scan:
> 
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1698,7 +1698,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct
>         if (strncmp(scsi_scan_type, "sync", 4) == 0)
>                 return NULL;
>  
> -       if (shost->async_scan) {
> +       if (shost && shost->async_scan) {
>                 printk("%s called twice for host %d", __FUNCTION__,
>                                 shost->host_no);
>                 dump_stack();
> @@ -1708,16 +1708,19 @@ static struct async_scan_data *scsi_prep_async_scan(stru
>         data = kmalloc(sizeof(*data), GFP_KERNEL);
>         if (!data)
>                 goto err;
> -       data->shost = scsi_host_get(shost);
> -       if (!data->shost)
> -               goto err;
>         init_completion(&data->prev_finished);
>  
> -       mutex_lock(&shost->scan_mutex);
> -       spin_lock_irqsave(shost->host_lock, flags);
> -       shost->async_scan = 1;
> -       spin_unlock_irqrestore(shost->host_lock, flags);
> -       mutex_unlock(&shost->scan_mutex);
> +       if (shost) {
> +               data->shost = scsi_host_get(shost);
> +               if (!data->shost)
> +                       goto err;
> +
> +               mutex_lock(&shost->scan_mutex);
> +               spin_lock_irqsave(shost->host_lock, flags);
> +               shost->async_scan = 1;
> +               spin_unlock_irqrestore(shost->host_lock, flags);
> +               mutex_unlock(&shost->scan_mutex);
> +       }
>  
>         spin_lock(&async_scan_lock);
>         if (list_empty(&scanning_hosts))
> 
> Would that work for you?
> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
