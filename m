From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC][PATCH] 2.5 hosts.c and scsi_host list cleanup
Date: Wed, 4 Sep 2002 22:43:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020905054342.GB1386@beaverton.ibm.com>
References: <20020904204310.GA3588@beaverton.ibm.com> <20020905000158.A14644@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020905000158.A14644@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph,
	Thanks for the feedback see comments below.

Christoph Hellwig [hch@infradead.org] wrote:
> On Wed, Sep 04, 2002 at 01:43:10PM -0700, Mike Anderson wrote:
> Any chance you could include it in the mail the next time?  Makes
> readin and annotating a lot easier..

Yes I will next time. I am always uneasy in-lining the patch when I
approach the 56k size.

> 
> 
> +	sh = scsi_shost_hn_get(hostnum);
> +	
> +	if (sh == NULL) /* This really shouldn't ever happen. */
> 
> The additional space between the two statements looks very strange

Ok I removed the space.

> 
> -	while(host != NULL && host->host_no != host_no)
> -		host = host->next;
> +	host = scsi_shost_hn_get(host_no);
>  
>  	if(host == NULL)
> 
> Dito.

Done

> 
>   *  Updated to reflect the new initialization scheme for the higher 
>   *  level of scsi drivers (sd/sr/st)
>   *  September 17, 2000 Torben Mathiasen <tmm@image.dk>
> + *
> + *  Modified:
> + *  	Restructured scsi_host lists and associated functions.
> + *  		Mike Anderson (andmike@us.ibm.com)
> 
> Maybe you could follow the changelog style already present in the file?

Done

> 
>   */
>  
>  
> -/*
> -static const char RCSid[] = "$Header: /vger/u4/cvs/linux/drivers/scsi/hosts.c,v 1.20 1996/12/12 19:18:32 davem Exp $";
> -*/
> 
> Good to see this die!
> 
> -Scsi_Host_Template * scsi_hosts;
> +	list_for_each_safe(lh, lh_sf, &scsi_shost_list) {
> +		shost = list_entry(lh, struct Scsi_Host, sh_list);
> +		if (shost->hostt == shost_tp) {
> +			spin_unlock(&scsi_shost_list_lock);
> +			(void)callback(shost);
> +			spin_lock(&scsi_shost_list_lock);
> 
> The void cast isn't needed.

Done

> 
> +		devfs_unregister (sdev->de);
> +		put_device(&sdev->sdev_driverfs_dev);
> 
> Maybe make the coding style a little more consistent?  Yes, compared to the
> old code you did a _really_ _really_ good job, but please take it to the end..

Done
I took another pass through the file looking for anymore.

> 
> +	for (sdev = shost->host_queue; sdev;
> +	     sdev = shost->host_queue) {
> 
> I wonder whether this wouldn't better be a do { } while loop.
> 

Yes it might, but scsi device is next on the cleanup list so list
iteration will be changing. Though there is an increase in overhead the
device model functions that do ref counting and call a function for each
element in the list seem to be the cleanest solution.

> 
> +		scsi_release_commandblocks(sdev);
> +
> +		blk_cleanup_queue(&sdev->request_queue);
> +		/* Next free up the Scsi_Device structures for this host */
> +		shost->host_queue = sdev->next;
> +		if (sdev->inquiry)
> +			kfree(sdev->inquiry);
> +		kfree((char *) sdev);
> 
> No need to cast.

Done

> 
> +	/* Remove the instance of the individual hosts */
> +	pcount = registered_shosts;
> +	if (shost->hostt->release)
> +		(*shost->hostt->release) (shost);
> +	else {
> +		/* This is the default case for the release function.
> +		 * It should do the right thing for most correctly
> +		 * written host adapters.
> +		 */
> +		if (shost->irq)
> +			free_irq(shost->irq, NULL);
> +		if (shost->dma_channel != 0xff)
> +			free_dma(shost->dma_channel);
> +		if (shost->io_port && shost->n_io_port)
> +			release_region(shost->io_port, shost->n_io_port);
> 
> This code shouldn't be in generic code (again not your fault).  Move it to
> a generic_scsi_host_release() function or so to nicely separate it out.
> 

OK I will look at wrapping this.

> +	kfree((char *) shost);
> 
> See above.

Done

> 
> +
> +	len = strlen(name);
> +	shost_name = (Scsi_Host_Name *) kmalloc(sizeof(Scsi_Host_Name),
> +						GFP_KERNEL);
> 
> Cast isn't really needed again.
> 
> 

Removed cast but added sizeof(*shost_name) style.

> +	shost = (struct Scsi_Host *)kmalloc(sizeof(struct Scsi_Host) +
> +					    xtr_bytes,
> +					    (shost_tp->unchecked_isa_dma
> +					     && xtr_bytes ?  GFP_DMA : 0)
> +					    | GFP_KERNEL);
> 
> This is ugly as hell.  (Yes, I know it was in the old code).  What about
> the following?
> 
> 	gfp_mask = GFP_KERNEL;
> 	if (shost_tp->unchecked_isa_dma && xtr_bytes)
> 		gfp_mask |= __GFP_DMA;
> 
> 	shost = kmalloc(sizeof(struct Scsi_Host) + xtr_bytes, gfp_mask);
> 
> 

This does look better, Done

> 
> +	if(!shost) {
> 
> small coding style oddities again..

Done.

> 
> +	if (!blk_nohighio)
> +	shost->highmem_io = shost_tp->highmem_io;
> 
> Umm..

Yes when I saw this I thought it was odd to have a setup value exported
from the block layer and only checked all the way down here. I was going
to talk to Jens and possibly make a separate patch to have this moved
into blk_queue_bounce_limit.

> 
> 
> +
> +	/*
> +	 * detect should do its own locking
> +	 * FIXME present is now set is scsi_register which breaks manual
> +	 * registration code below.
> +	 */
> +	(void) shost_tp->detect(shost_tp);
> 
> No need for the cast again.

Done

> 
> +			/*
> +			 * The low-level driver failed to register a driver.
> +			 * We can do this now.
> +			 */
> +			if(scsi_register(shost_tp, 0)==NULL)
> +			{
> 
> Consistency.

Done

> 
> +	(void) shost_tp_for_each_shost(shost_tp, shost_chk_and_release);
> 
> Again.
> 
Done

> +void __init scsi_shost_hn_init(char *shost_hn)
> +{
> +	char *temp = shost_hn;
> +
> +	while (temp) {
> +		while (*temp && (*temp != ':') && (*temp != ','))
> +		    temp++;
> +		if (!*temp)
> +		    temp = NULL;
> +		else
> +		    *temp++ = 0;
> 
> Indentation consistency.

Done


-Mike
-- 
Michael Anderson
andmike@us.ibm.com

