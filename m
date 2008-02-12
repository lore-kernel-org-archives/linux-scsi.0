From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] iscsi iser: remove DMA restrictions
Date: Tue, 12 Feb 2008 15:10:45 -0600
Message-ID: <1202850645.3137.132.camel@localhost.localdomain>
References: <20080212205252.GB13643@osc.edu>
	 <20080212205403.GC13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59506 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759990AbYBLVKu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 16:10:50 -0500
In-Reply-To: <20080212205403.GC13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-02-12 at 15:54 -0500, Pete Wyckoff wrote:
> iscsi_iser does not have any hardware DMA restrictions.  Add a
> slave_configure function to remove any DMA alignment restriction,
> allowing the use of direct IO from arbitrary offsets within a page.
> Also disable page bouncing; iser has no restrictions on which pages it
> can address.
> 
> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index be1b9fb..1b272a6 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -543,6 +543,13 @@ iscsi_iser_ep_disconnect(__u64 ep_handle)
>  	iser_conn_terminate(ib_conn);
>  }
>  
> +static int iscsi_iser_slave_configure(struct scsi_device *sdev)
> +{
> +	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);

You really don't want to do this.  That signals to the block layer that
we have an iommu, although it's practically the same thing as a 64 bit
DMA mask ... but I'd just leave it to the DMA mask to set this up
correctly.  Anything else is asking for a subtle bug to turn up years
from now when something causes the mask and the limit to be mismatched.

James


