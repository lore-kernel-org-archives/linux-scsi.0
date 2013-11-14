From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: PATCH: st.c: Fix blk_get_queue usage
Date: Thu, 14 Nov 2013 16:50:10 -0500
Message-ID: <20131114165010.1ed9d21f@jlaw-desktop.mno.stratus.com>
References: <61eb00$4bjf3p@dgate20u.abg.fsc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o141.mxlogic.net ([208.65.144.64]:40740 "EHLO
	p01c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3KNVuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 16:50:18 -0500
In-Reply-To: <61eb00$4bjf3p@dgate20u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 14 Nov 2013 20:22:40 +0100
Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:

> On 14.11.2013, at 20.05, Kai M??kisara (Kolumbus) <kai.makisara@kolumbus.fi> wrote:
> 
> > 
> > On 14.11.2013, at 16.48, Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:
> > 
> > > Hi,
> > > 
> > > in st_probe(), st.c I stumbled across what I'd call a minor problem.
> > > 
> > > So I'd like to suggest the following patch.
> > > 
> > > Best Regards,
> > > Bodo
> > > 
> > > P.S.: Please CC me, I'm not on the list.
> > > 
> > > ---------------------------------------------------------------------
> > > 
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
> > 
> > With this patch, blk_get_queue() is not called with the correct argument.
> > Maybe change the call to blk_get_queue(SDp->request_queue) ?
> > 
> > > 	if (blk_get_queue(disk->queue))
> 
> Yes, thank you. You are obviously right. Below is the revised patch.
> Sorry for the mistake.
> 
> Bodo
> 
> > > 		goto out_put_disk;
> > > +	disk->queue = SDp->request_queue;
> > > 	tpnt->driver = &st_template;
> > > 
> > > 	tpnt->device = SDp--
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > ;
> > 
> > Thanks,
> > Kai
> > 
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
> Revised patch due to a hint from Kai Makisara.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> 
> ---
> 
> --- a/drivers/scsi/st.c	2013-11-14 14:10:40.000000000 +0100
> +++ b/drivers/scsi/st.c	2013-11-14 14:10:57.000000000 +0100
> @@ -4107,11 +4107,11 @@
>  	kref_init(&tpnt->kref);
>  	tpnt->disk = disk;
>  	disk->private_data = &tpnt->driver;
> -	disk->queue = SDp->request_queue;
>  	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
>  	 * take queue reference that release_disk() expects. */
> -	if (blk_get_queue(disk->queue))
> +	if (blk_get_queue(SDp->request_queue))
>  		goto out_put_disk;
> +	disk->queue = SDp->request_queue;
>  	tpnt->driver = &st_template;
>  
>  	tpnt->device = SDp;
> ??{.n?+???????+%??lzwm??b??????r??zX??
?(??????}?????z?&j:+v???????zZ+??+zf???h???~????i???z?
?w?????????&?)??f

Hi Bodo,

Minor nit, wasn't blk_get_queue modified to return false on failure?

09ac46c42946 "block: misc updates to blk_get_queue()"

Just curious what tree this patch was tested against.

Thanks,

-- Joe
