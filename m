From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] iscsi iser: increase max_sectors
Date: Mon, 05 May 2008 12:49:24 -0500
Message-ID: <481F48A4.3060701@cs.wisc.edu>
References: <20080212205252.GB13643@osc.edu> <20080212205420.GD13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33160 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbYEERtl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 13:49:41 -0400
In-Reply-To: <20080212205420.GD13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

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
>  	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
>  	.eh_abort_handler       = iscsi_eh_abort,
>  	.eh_device_reset_handler= iscsi_eh_device_reset,

Do we need to modify sg_tablesize and the related preallocations to take 
advantage of this? iser sets the sg_tablesize to ISCSI_ISER_SG_TABLESIZE 
and disables clustering, scsi-ml/block will only send commands up to 
ISCSI_ISER_SG_TABLESIZE * PAGE_SIZE.
