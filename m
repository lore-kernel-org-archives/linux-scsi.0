From: Erez Zilber <erezz@Voltaire.COM>
Subject: Re: [PATCH 2/3] iscsi iser: increase max_sectors
Date: Mon, 05 May 2008 16:36:42 +0300
Message-ID: <481F0D6A.9050301@Voltaire.COM>
References: <20080212205252.GB13643@osc.edu> <20080212205420.GD13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:53239 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754090AbYEENf5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 09:35:57 -0400
In-Reply-To: <20080212205420.GD13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>, Roland Dreier <rolandd@cisco.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

Pete Wyckoff wrote:
> iser has no limit on max sectors.  This lets iscsi iser support
> large pass through commands just like iscsi TCP.
>
> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 1b272a6..78f3242 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -557,7 +557,7 @@ static struct scsi_host_template iscsi_iser_sht = {
>  	.change_queue_depth	= iscsi_change_queue_depth,
>  	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
>  	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
> -	.max_sectors		= 1024,
> +	.max_sectors		= 0xffff,
>   

This could be problematic because, AFAIK, some HCAs (memfree, I think)
don't support FMRs of more than 2MB. Roland, am I right?
