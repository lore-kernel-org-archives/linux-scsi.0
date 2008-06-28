From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 04 of 10] scsi: Support devices with protection
	information (DIF)
Date: Sat, 28 Jun 2008 10:07:38 -0500
Message-ID: <1214665658.3658.18.camel@localhost.localdomain>
References: <2fd66ca994dbf1ed6d14.1214407363@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58284 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYF1PHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jun 2008 11:07:42 -0400
In-Reply-To: <2fd66ca994dbf1ed6d14.1214407363@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-06-25 at 11:22 -0400, Martin K. Petersen wrote:
> - Add support for an extra scatter-gather list containing protection
>    information.
> 
>  - Remember devices with protection information turned on in INQUIRY.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 4 files changed, 62 insertions(+)
> drivers/scsi/scsi_lib.c    |   38 ++++++++++++++++++++++++++++++++++++++
> drivers/scsi/scsi_scan.c   |    3 +++
> include/scsi/scsi_cmnd.h   |   20 ++++++++++++++++++++
> include/scsi/scsi_device.h |    1 +
> 
> 
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -778,6 +778,11 @@ void scsi_release_buffers(struct scsi_cm
>  		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
>  		cmd->request->next_rq->special = NULL;
>  	}
> +
> +	if (scsi_prot_sg_count(cmd)) {
> +		scsi_free_sgtable(cmd->prot_sdb);
> +		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
> +	}
>  }
>  EXPORT_SYMBOL(scsi_release_buffers);
>  
> @@ -1031,6 +1036,32 @@ static int scsi_init_sgtable(struct requ
>  	return BLKPREP_OK;
>  }
>  
> +static int scsi_protect_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> +{
> +	struct request *req;
> +	struct scsi_data_buffer *pdb;
> +	int ivecs, count;
> +
> +	req = cmd->request;
> +
> +	pdb = kmem_cache_zalloc(scsi_sdb_cache, gfp_mask);
> +	if (unlikely(pdb == NULL))
> +		return BLKPREP_DEFER;

I'm afraid you can't do it like this because it will violate our forward
progress guarantees.  If this is the last spare command required for
writeout, you need to guarantee either this allocation will succeed, or
we can proceed without the DIF data.

I know you copied it from the bidirectional stuff, but they don't need
forward progress guarantees; something in the mainline does because we
could get into a vmwriteout failure case even for a DIF protected
device.

> +
> +	ivecs = blk_rq_count_integrity_sg(req);
> +
> +	if (unlikely(scsi_alloc_sgtable(pdb, ivecs, gfp_mask)))
> +		return BLKPREP_DEFER;
> +
> +	count = blk_rq_map_integrity_sg(req, pdb->table.sgl);
> +	BUG_ON(unlikely(count > ivecs));
> +
> +	cmd->prot_sdb = pdb;
> +	cmd->prot_sdb->table.nents = count;
> +
> +	return BLKPREP_OK;
> +}
> +
>  /*
>   * Function:    scsi_init_io()
>   *
> @@ -1060,6 +1091,13 @@ int scsi_init_io(struct scsi_cmnd *cmd, 
>  		error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
>  								    GFP_ATOMIC);
>  		if (error)
> +			goto err_exit;
> +	}
> +
> +	if (blk_integrity_rq(cmd->request)) {
> +		error = scsi_protect_io(cmd, gfp_mask);
> +
> +		if (error != BLKPREP_OK)
>  			goto err_exit;
>  	}
>  
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -882,6 +882,9 @@ static int scsi_add_lun(struct scsi_devi
>  
>  	if (*bflags & BLIST_USE_10_BYTE_MS)
>  		sdev->use_10_for_ms = 1;
> +
> +	if (inq_result[5] & 0x1)
> +		sdev->protection = 1;

Is there a reason to have a separate flag here and not just do something
like the usual in scsi_device.h:

static inline int scsi_device_protection(struct scsi_device *sdev)
{
	return sdev->inquiry[5] & (1<<0);
}

James


