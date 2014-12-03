From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fc: FCP_PTA_SIMPLE is 0
Date: Wed, 3 Dec 2014 01:31:07 -0800
Message-ID: <20141203093107.GB17698@infradead.org>
References: <1416927010-6036-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCJbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 04:31:08 -0500
Content-Disposition: inline
In-Reply-To: <1416927010-6036-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Ewan D. Milne" <emilne@redhat.com>

Any chance to get reviews for these two patches?

On Tue, Nov 25, 2014 at 03:50:09PM +0100, Christoph Hellwig wrote:
> Not need to have an if/else to either assign FCP_PTA_SIMPLE or 0
> to a variable.
> 
> Btw, it seems we really should factor generating a fcp cmnd from
> a scsi_cmnd into a common helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c   | 6 +-----
>  drivers/scsi/csiostor/csio_scsi.c | 5 +----
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 4b56858..9ecca85 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1737,11 +1737,7 @@ void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
>  	fcp_cmnd->fc_pri_ta = 0;
>  	fcp_cmnd->fc_tm_flags = io_req->mp_req.tm_flags;
>  	fcp_cmnd->fc_flags = io_req->io_req_flags;
> -
> -	if (sc_cmd->flags & SCMD_TAGGED)
> -		fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
> -	else
> -		fcp_cmnd->fc_pri_ta = 0;
> +	fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
>  }
>  
>  static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 4d0b6ce..6bd36c3 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -172,10 +172,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr)
>  		fcp_cmnd->fc_cmdref = 0;
>  
>  		memcpy(fcp_cmnd->fc_cdb, scmnd->cmnd, 16);
> -		if (scmnd->flags & SCMD_TAGGED)
> -			fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
> -		else
> -			fcp_cmnd->fc_pri_ta = 0;
> +		fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
>  		fcp_cmnd->fc_dl = cpu_to_be32(scsi_bufflen(scmnd));
>  
>  		if (req->nsge)
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
