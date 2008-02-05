From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [SCSI] fix BUG when sum(scatterlist) > bufflen
Date: Tue, 05 Feb 2008 14:32:09 -0600
Message-ID: <47A8C7C9.8050906@cs.wisc.edu>
References: <47A8826A.4040401@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53299 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998AbYBEUcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 15:32:19 -0500
In-Reply-To: <47A8826A.4040401@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Douglas Gilbert <dougg@torque.net>

Tony Battersby wrote:
> When sending a SCSI command to a tape drive via the SCSI Generic (sg)
> driver, if the command has a data transfer length more than
> scatter_elem_sz (32 KB default) and not a multiple of 512, then I either
> hit BUG_ON(!valid_dma_direction(direction)) in dma_unmap_sg() or else
> the command never completes (depending on the LLDD).
> 
> When constructing scatterlists, the sg driver rounds up the scatterlist
> element sizes to be a multiple of 512.  This can result in
> sum(scatterlist lengths) > bufflen.  In this case, scsi_req_map_sg()
> incorrectly sets bio->bi_size to sum(scatterlist lengths) rather than to
> bufflen.  When the command completes, req_bio_endio() detects that
> bio->bi_size != 0, and so it doesn't call bio_endio().  This causes the
> command to be resubmitted, resulting in BUG_ON or the command never
> completing.
> 
> This patch makes scsi_req_map_sg() set bio->bi_size to bufflen rather
> than to sum(scatterlist lengths), which fixes the problem.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> --- linux-2.6.24-git14/drivers/scsi/scsi_lib.c.orig	2008-02-05 09:33:05.000000000 -0500
> +++ linux-2.6.24-git14/drivers/scsi/scsi_lib.c	2008-02-05 09:33:10.000000000 -0500
> @@ -301,7 +301,6 @@ static int scsi_req_map_sg(struct reques
>  		page = sg_page(sg);
>  		off = sg->offset;
>  		len = sg->length;
> - 		data_len += len;
>  

Thanks for finding this. I am not sure what happened. That line got 
deleted in this commit when we fixed this problem:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=bd441deaf341c524b28fd72831ebf6fef88f1c41

but was added back here:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=c6132da1704be252ee6c923f47501083d835c238

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
