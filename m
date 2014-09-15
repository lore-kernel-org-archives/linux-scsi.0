From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] scsi: fix regression that accidentally disabled block-based tcq
Date: Mon, 15 Sep 2014 15:39:44 -0400
Message-ID: <x49lhpkr7un.fsf@segfault.boston.devel.redhat.com>
References: <540EC52C.3000804@redhat.com>
	<20140909152730.GA17882@infradead.org> <540FFBF4.9090001@redhat.com>
	<20140910154535.GA5102@infradead.org> <541172E9.8070309@redhat.com>
	<20140911161331.GA24488@infradead.org> <54134E50.6040805@redhat.com>
	<20140912230032.GA21143@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140912230032.GA21143@infradead.org> (Christoph Hellwig's
	message of "Fri, 12 Sep 2014 16:00:32 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-usb <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Please try the fix below, looks like the commit broke TCQ for all drivers 
> using block-level tagging.
>
> ---
> From 865a19b760d2786fe37d3b5c151a4ecea4c0e95e Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 12 Sep 2014 16:00:19 -0700
> Subject: scsi: fix regression that accidentally disabled block-based tcq
>
> The scsi blk-mq support accidentally flipped a conditional, which lead to
> never enabling block based tcq when using the legacy request path.
>
> Fixes: d285203cf647d7c9 scsi: add support for a blk-mq based I/O path.
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/scsi/scsi_tcq.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
> index cdcc90b..e645835 100644
> --- a/include/scsi/scsi_tcq.h
> +++ b/include/scsi/scsi_tcq.h
> @@ -68,7 +68,7 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
>  		return;
>  
>  	if (!shost_use_blk_mq(sdev->host) &&
> -	    blk_queue_tagged(sdev->request_queue))
> +	    !blk_queue_tagged(sdev->request_queue))
>  		blk_queue_init_tags(sdev->request_queue, depth,
>  				    sdev->host->bqt);

Introduced by d285203:

-       if (!blk_queue_tagged(sdev->request_queue))
+       if (!shost_use_blk_mq(sdev->host) &&
+           blk_queue_tagged(sdev->request_queue))

Seems like an obvious fix.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
