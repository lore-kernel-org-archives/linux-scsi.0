From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [3/21] Pass gfp to scsi_allocate_command
Date: Sun, 16 Nov 2008 09:29:05 -0600
Message-ID: <1226849345.3556.7.camel@localhost.localdomain>
References: <200811161211.212948789@firstfloor.org>
	 <20081115231103.59DC93E661B@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40512 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbYKPQiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2008 11:38:05 -0500
In-Reply-To: <20081115231103.59DC93E661B@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sun, 2008-11-16 at 00:11 +0100, Andi Kleen wrote:
> -static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
> +static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
>  {
>         struct scsi_host_cmd_pool *pool;
>  
>         mutex_lock(&host_cmd_pool_mutex);
> -       pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
> +       pool = (shost && shost->unchecked_isa_dma) ?
> &scsi_cmd_dma_pool :
>                 &scsi_cmd_pool;

There's a conceptual problem with this:  The API is designed to be used
on host setup (i.e. when allocating a host based command for the driver)
so the scsi_host may not be available (or at least not fully set up)
when this is called.

What about making it take a mask instead?  That should always be known
by the driver.

James


