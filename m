From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/10] mpt3sas: implement _dechain_st()
Date: Tue, 7 Feb 2017 14:15:51 +0100
Message-ID: <20170207131551.GC19247@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40560 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754870AbdBGNQO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 08:16:14 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>

On Tue, Jan 31, 2017 at 10:25:53AM +0100, Hannes Reinecke wrote:
> Split off _dechain_st() as separate function.
> No functional change.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 09d0008..120b317 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2365,6 +2365,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>  	return smid;
>  }
>  
> +static void
> +_dechain_st(struct MPT3SAS_ADAPTER *ioc, struct scsiio_tracker *st)
> +{
> +	struct chain_tracker *chain_req;
> +
> +	while (!list_empty(&st->chain_list)) {
> +		chain_req = list_first_entry(&st->chain_list,
> +					     struct chain_tracker,
> +					     tracker_list);
> +		list_move(&chain_req->tracker_list, &ioc->free_chain_list);
> +	}

Why not just use list_splice_init?
