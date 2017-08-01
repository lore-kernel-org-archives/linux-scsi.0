From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] st: fix blk_get_queue usage
Date: Tue, 01 Aug 2017 12:03:25 -0400
Message-ID: <1501603405.4120.35.camel@localhost.localdomain>
References: <1501591374-11229-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751778AbdHAQD1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Aug 2017 12:03:27 -0400
In-Reply-To: <1501591374-11229-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>, Hannes Reinecke <hare@suse.com>

On Tue, 2017-08-01 at 14:42 +0200, Hannes Reinecke wrote:
> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> 
> If blk_queue_get() in st_probe fails, disk->queue must not
> be set to SDp->request_queue, as that would result in
> put_disk() dropping a not taken reference.
> 
> Thus, disk->queue should be set only after a successful
> blk_queue_get().
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/st.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 1ea34d6..f1bcaf6 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4300,11 +4300,11 @@ static int st_probe(struct device *dev)
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

Fixes: 2b5bebccd282 ("st: Take additional queue ref in st_probe")
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
