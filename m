From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 11/11] mpt3sas: register reserved commands
Date: Fri, 17 Feb 2017 13:38:59 +0100
Message-ID: <20170217123859.GB23739@lst.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de> <1487319790-97340-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42437 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933741AbdBQMjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 07:39:02 -0500
Content-Disposition: inline
In-Reply-To: <1487319790-97340-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Feb 17, 2017 at 09:23:10AM +0100, Hannes Reinecke wrote:
> The mpt3sas driver requires a reserved command space to handle
> SCSI passthrough commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index e9470a3..97189ad 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2360,6 +2360,8 @@ struct scsiio_tracker *
>  	} else {
>  		u32 unique_tag = blk_mq_unique_tag(scmd->request);
>  		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
> +
> +		WARN_ON(tag < ioc->shost->reserved_cmds);
>  		request = scsi_cmd_priv(scmd);
>  		smid = tag + 1;
>  	}
> @@ -3521,7 +3523,8 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
>  	/* set the scsi host can_queue depth
>  	 * with some internal commands that could be outstanding
>  	 */
> -	ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
> +	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;
> +	ioc->shost->can_queue = ioc->scsiio_depth - ioc->shost->reserved_cmds;

You're never allocating a reserved request.  Just remove the number of
reserved cmds from can_queue and you can use them on your own.

So I don't think you'll actually need to use reserved request here,
but instead you should set up can_queue properly earlier in the series.
