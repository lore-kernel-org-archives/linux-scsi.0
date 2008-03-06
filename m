From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [0/21] Remove isa_unchecked_dma and some more GFP_DMAs
	in the mid layer v2
Date: Thu, 06 Mar 2008 16:13:27 -0600
Message-ID: <1204841607.3062.67.camel@localhost.localdomain>
References: <20080306951.147874949@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36853 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698AbYCFWNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:13:33 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk

On Thu, 2008-03-06 at 21:51 +0100, Andi Kleen wrote:
> This is v2 of the patchkit. I believe I addressed all review feedback
> and did some more improvements.

I believe I objected to substituting the single bit unchecked_isa_dma
flag with a u64 sense_mask.  That still seems to be present:

> @@ -649,7 +657,7 @@ struct Scsi_Host {
>         unsigned char n_io_port;
>         unsigned char dma_channel;
>         unsigned int  irq;
> -       
> +       u64 sense_buffer_mask;

I particularly object to this, because it defeats the whole idea of
removing the special casing for ISA devices.  If you look at how you use
this flag in a lot of your code, it's a straightforward substitution:

> @@ -1355,7 +1377,7 @@ static int port_detect(unsigned long por
>  
>         for (i = 0; i < shost->can_queue; i++) {
>                 size_t sz = shost->sg_tablesize *sizeof(struct sg_list);
> -               gfp_t gfp_mask = (shost->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC;
> +               gfp_t gfp_mask = (shost->sense_buffer_mask ? GFP_DMA : 0) | GFP_ATOMIC;

If you're using it as a bit flag, just call it unchecked_isa_dma.  If
you really want it to be a mask, then I think setting up and using the
mask in sdev->sdev_gendev is the way to go.

James


