From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH][BUG] Incorrect SCSI transfer length computation from
 odd sized scsi_execute_async() transfers.
Date: Wed, 11 Jul 2007 20:19:54 -0500
Message-ID: <469581BA.4010009@cs.wisc.edu>
References: <46957820.9090008@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37164 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbXGLBUD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 21:20:03 -0400
In-Reply-To: <46957820.9090008@greshamstorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jli@greshamstorage.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux Scsi <linux-scsi@vger.kernel.org>, Linux Kernel List <linux-kernel@vger.kernel.org>

Jeremy Linton wrote:
> Any function which use scsi_execute_async() and transfers "odd" sized 
> data that doesn't align correctly with the segment sizes may have its 
> transfer length padded out to the closest segment size.
> 
> For writes, this results in unnecessary data being transfered to the 
> SCSI target. For reads, it affects the residual data length being 
> returned to the application since the residual length will be based on 
> the padded transfer size rather than the actual request size.
> 
> The easiest way to see this is by trying to read using the SG_IO ioctl a 
> large (>32k) buffer size from a tape device that only has a few bytes of 
> data stored for the current block. The resulting resid will generally be 
> incorrect.
> 
> I've fixed this simply by changing scsi_req_map_sg() so that it places 
> the requested transfer length in rq->data_len rather than the sum of all 
> the sg segments.
> 
> This patch applies against scsi_lib.c in 2.6.22.
> 
> Signed-off-by: Jeremy Linton <jli@greshamstorage.com>
> 
> 
> --- linux-2.6.22/drivers/scsi/scsi_lib.c.orig   2007-07-11 
> 19:07:06.000000000 -0500
> +++ linux-2.6.22/drivers/scsi/scsi_lib.c        2007-07-11 
> 18:43:36.000000000 -0500
> @@ -350,7 +350,7 @@ static int scsi_req_map_sg(struct reques
>         }
> 
>         rq->buffer = rq->data = NULL;
> -       rq->data_len = data_len;
> +       rq->data_len = bufflen;
>         return 0;
> 

I think you needed some other bits in there. See this patch 
http://marc.info/?l=linux-scsi&m=117392208211297&w=2

I tried just setting the bufflen first, and that still had problems. 
Could you try the patch here

http://marc.info/?l=linux-scsi&m=117392208211297&w=2
