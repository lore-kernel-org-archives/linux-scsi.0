From: =?iso-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: PATCH: st.c: Fix blk_get_queue usage
Date: Thu, 14 Nov 2013 21:05:26 +0200
Message-ID: <A3521958-CFD9-4EE6-96CF-C3143801C42E@kolumbus.fi>
References: <d6437a$53lu6d@dgate10u.abg.fsc.net>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs14.mail.saunalahti.fi ([62.142.117.201]:36932 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3KNTL4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 14:11:56 -0500
In-Reply-To: <d6437a$53lu6d@dgate10u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: linux-scsi@vger.kernel.org


On 14.11.2013, at 16.48, Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:

> Hi,
> 
> in st_probe(), st.c I stumbled across what I'd call a minor problem.
> 
> So I'd like to suggest the following patch.
> 
> Best Regards,
> Bodo
> 
> P.S.: Please CC me, I'm not on the list.
> 
> ---------------------------------------------------------------------
> 
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

With this patch, blk_get_queue() is not called with the correct argument.
Maybe change the call to blk_get_queue(SDp->request_queue) ?

> 	if (blk_get_queue(disk->queue))
> 		goto out_put_disk;
> +	disk->queue = SDp->request_queue;
> 	tpnt->driver = &st_template;
> 
> 	tpnt->device = SDp--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ;

Thanks,
Kai

