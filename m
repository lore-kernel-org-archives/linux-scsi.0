From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: PATCH: st.c: Fix blk_get_queue usage
Date: Fri, 15 Nov 2013 11:59:12 -0500
Message-ID: <20131115115912.2199af4f@jlaw-desktop.mno.stratus.com>
References: <61eb00$4bn226@dgate20u.abg.fsc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:36546 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3KOQ7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2013 11:59:54 -0500
In-Reply-To: <61eb00$4bn226@dgate20u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: kai.makisara@kolumbus.fi, linux-scsi@vger.kernel.org

On Fri, 15 Nov 2013 12:23:06 +0100
Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:

> On 14.11.2013, at 22.50, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> 
> > On Thu, 14 Nov 2013 20:22:40 +0100
> > Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:
> > 
> > > On 14.11.2013, at 20.05, Kai M??kisara (Kolumbus) <kai.makisara@kolumbus.fi> wrote:
> > > 
> > > > 
> > > > On 14.11.2013, at 16.48, Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:
> > > > 
> 
> < snip >
>  
> > > > 
> > > > With this patch, blk_get_queue() is not called with the correct argument.
> > > > Maybe change the call to blk_get_queue(SDp->request_queue) ?
> > > > 
> > > > > 	if (blk_get_queue(disk->queue))
> > > 
> > > Yes, thank you. You are obviously right. Below is the revised patch.
> > > Sorry for the mistake.
> > > 
> > > Bodo
> > > 
> > > > > 		goto out_put_disk;
> > > > > +	disk->queue = SDp->request_queue;
> > > > > 	tpnt->driver = &st_template;
> > > > > 
> > > > > 	tpnt->device = SDp--
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > ;
> > > > 
> > > > Thanks,
> > > > Kai
> > > > 
> > > 
> > > From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> > > Date: Thu, 14 Nov 2013 14:35:00 +0100
> > > Subject: [PATCH] sg: fix blk_get_queue usage
> > > 
> > > If blk_queue_get() in st_probe fails, disk->queue must not
> > > be set to SDp->request_queue, as that would result in
> > > put_disk() dropping a not taken reference.
> > > 
> > > Thus, disk->queue should be set only after a successful
> > > blk_queue_get().
> > > Revised patch due to a hint from Kai Makisara.
> > > 
> > > Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> > > 
> > > ---
> > > 
> > > --- a/drivers/scsi/st.c	2013-11-14 14:10:40.000000000 +0100
> > > +++ b/drivers/scsi/st.c	2013-11-14 14:10:57.000000000 +0100
> > > @@ -4107,11 +4107,11 @@
> > >  	kref_init(&tpnt->kref);
> > >  	tpnt->disk = disk;
> > >  	disk->private_data = &tpnt->driver;
> > > -	disk->queue = SDp->request_queue;
> > >  	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
> > >  	 * take queue reference that release_disk() expects. */
> > > -	if (blk_get_queue(disk->queue))
> > > +	if (blk_get_queue(SDp->request_queue))
> > >  		goto out_put_disk;
> > > +	disk->queue = SDp->request_queue;
> > >  	tpnt->driver = &st_template;
> > >  
> > >  	tpnt->device = SDp;
> > >  ??{.n?+???????+%??lzwm??b??????r??zX??  ?(?? ????}?????z?&j:+v???????zZ+??+zf???h???~????i???z? ?w?????????&?)?? f
> > 
> > Hi Bodo,
> > 
> > Minor nit, wasn't blk_get_queue modified to return false on failure?
> > 
> > 09ac46c42946 "block: misc updates to blk_get_queue()"
> > 
> > Just curious what tree this patch was tested against.
> > 
> > Thanks,
> > 
> > -- Joe
> > 
> 
> Hi Joe,
> 
> we are intensively using SuSE SLES11 (currently kernel 3.0.80-xxxxx). At the moment
> I'm not involved with mainline.
> 
> The patch resulted from the hunt for another problem and was accepted by SuSE. They
> told me that this would be relevant for mainline also. So I posted it but didn't
> check mainline for changes :-(
> 
> Thus, here is the third revision of the patch that now is suited for mainline.
> Sorry for the noise.
> 
> Thank you.
> 
> Bodo
> 
> -------------------------------
> 
> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Date: Thu, 14 Nov 2013 14:35:00 +0100
> Subject: [PATCH] sg: fix blk_get_queue usage
> 
> If blk_queue_get() in st_probe fails, disk->queue must not
> be set to SDp->request_queue, as that would result in
> put_disk() dropping a not taken reference.
> 
> Thus, disk->queue should be set only after a successful
> blk_queue_get().
> 
> 2nd revised patch due to hints from Kai Makisara and Joe Lawrence.
> 
> Now this should be suited for mainline.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> 
> ---
> 
> --- a/drivers/scsi/st.c	2013-11-15 11:58:39.000000000 +0100
> +++ b/drivers/scsi/st.c	2013-11-15 11:59:10.000000000 +0100
> @@ -4111,11 +4111,11 @@ static int st_probe(struct device *dev)
>  	kref_init(&tpnt->kref);
>  	tpnt->disk = disk;
>  	disk->private_data = &tpnt->driver;
> -	disk->queue = SDp->request_queue;
>  	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
>  	 * take queue reference that release_disk() expects. */
> -	if (!blk_get_queue(disk->queue))
> +	if (!blk_get_queue(SDp->request_queue))
>  		goto out_put_disk;
> +	disk->queue = SDp->request_queue;
>  	tpnt->driver = &st_template;
>  
>  	tpnt->device = SDp;
> 
> ?????
?&?~?&???+-??????w???????m?b??lr????^n?r???z???h?????&??
?G???h?(???????j"???m??????z??????f???h???~?m?

Hi Bodo,

Thanks for updated patch.

I just noticed an error in the original comment as well: "release_disk"
should have been "disk_release".  No wonder cscope had problems finding
that function.

Thanks,

-- Joe
