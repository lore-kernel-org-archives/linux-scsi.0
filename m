From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [5/21] Remove unchecked_isa in BusLogic
Date: Sun, 16 Nov 2008 10:46:16 -0500
Message-ID: <1226850376.3556.9.camel@localhost.localdomain>
References: <200811161211.212948789@firstfloor.org>
	 <20081115231105.63B2F3E6619@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40526 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412AbYKPQir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2008 11:38:47 -0500
In-Reply-To: <20081115231105.63B2F3E6619@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sun, 2008-11-16 at 00:11 +0100, Andi Kleen wrote:
> +static struct Scsi_Host *buslogic_host_alloc(gfp_t gfp)
> +{
> +       struct BusLogic_HostAdapter *board;
> +       struct Scsi_Host *shost;
> +
> +
> +       shost = scsi_host_alloc(&Bus_Logic_template, sizeof(struct host_ptr));
> +       if (!shost)
> +               return NULL;
> +
> +       board = dma_alloc_coherent(NULL, sizeof(struct BusLogic_HostAdapter),
> +                                       &bl_shost_dma(shost), GFP_KERNEL);
> +       if (!board) {
> +               scsi_host_put(shost);
> +               return NULL;
> +       }

What makes you think that BusLogic_HostAdapter has to be in coherent
memory?  You can tell from your own patch that nothing ever uses its DMA
address, so the card never actually DMAs data to or from this area.

James


