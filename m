From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/5] SCSI: Add support for 32-byte CDBs
Date: Wed, 26 Aug 2009 15:16:31 +0300
Message-ID: <4A95279F.5090105@panasas.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com> <1251267481-24135-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:35495
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932158AbZHZMQc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 08:16:32 -0400
In-Reply-To: <1251267481-24135-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, Ihab.Hamadi@emulex.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On 08/26/2009 09:17 AM, Martin K. Petersen wrote:
> DIF Type 2 drives require 32-byte commands.  Add a suitable flag to
> struct scsi_device that will cause scsi_setup_fs_cmnd() to allocate a
> bigger command buffer.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c    |   36 +++++++++++++++++++++++++++++++++++-
>  include/scsi/scsi.h        |    1 +
>  include/scsi/scsi_device.h |    1 +
>  3 files changed, 37 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 662024d..fc752b5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -67,6 +67,9 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
>  
>  struct kmem_cache *scsi_sdb_cache;
>  
> +struct kmem_cache *cdb_cache;
> +mempool_t *cdb_pool;
> +
>  static void scsi_run_queue(struct request_queue *q);
>  
>  /*
> @@ -642,6 +645,10 @@ static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
>  
>  	if (scsi_prot_sg_count(cmd))
>  		scsi_free_sgtable(cmd->prot_sdb);
> +
> +	if (cmd->cmd_len == SCSI_EXT_CDB_SIZE)
> +		mempool_free(cmd->cmnd, cdb_pool);
> +

This will not work. The cmd->cmnd might happen to be form an upper
layer through bsg or blk_execute_xxx and might just be SCSI_EXT_CDB_SIZE.

We could say to maybe:
	if (cmd->cmnd != cmd->req->cmd)

which means scsi allocated the buffer and not use the block supplied one
but that might be dangerous and will need a fat comment that states that
scsi drivers must use the scsi_cmnd pointer and not the request's.
Alternatively you could:

	if ((cmd->cmd_len == SCSI_EXT_CDB_SIZE) && blk_fs_request(cmnd->req))

since variable length can only come BLOCK_PC currently. But this will need to change
again later when ULDs might want to issue other commands that are SCSI_EXT_CDB_SIZE
in the future, which again might be dangerous.

or use an extra flag. You could use the first "fat comment" option above, all the drivers
I know do only use the scsi_cmnd->cmnd pointer.

>  }
>  
>  /*
> @@ -1109,7 +1116,18 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
>  	if (unlikely(!cmd))
>  		return BLKPREP_DEFER;
>  
> -	memset(cmd->cmnd, 0, BLK_MAX_CDB);
> +	if (sdev->use_32_for_rw) {
> +		req->cmd = mempool_alloc(cdb_pool, GFP_ATOMIC);
> +

James could we get that live-lock problem we had when not
atomically allocating the scsi_cmnd, (when sense was separated
out)

> +		if (unlikely(!req->cmd))
> +			return BLKPREP_DEFER;
> +
> +		cmd->cmnd = req->cmd;
> +		cmd->cmd_len = req->cmd_len = SCSI_EXT_CDB_SIZE;
> +		memset(cmd->cmnd, 0, cmd->cmd_len);
> +	} else
> +		memset(cmd->cmnd, 0, BLK_MAX_CDB);
> +
>  	return scsi_init_io(cmd, GFP_ATOMIC);
>  }
>  EXPORT_SYMBOL(scsi_setup_fs_cmnd);
> @@ -1745,6 +1763,19 @@ int __init scsi_init_queue(void)
>  		}
>  	}
>  
> +	cdb_cache = kmem_cache_create("scsi_cdb_32", SCSI_EXT_CDB_SIZE,
> +				      0, 0, NULL);
> +	if (!cdb_cache) {
> +		printk(KERN_ERR "SCSI: can't init scsi cdb cache\n");
> +		goto cleanup_sdb;
> +	}
> +
> +	cdb_pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE, cdb_cache);
> +	if (!cdb_pool) {
> +		printk(KERN_ERR "SCSI: can't init scsi cdb pool\n");
> +		goto cleanup_sdb;
> +	}
> +
>  	return 0;
>  
>  cleanup_sdb:
> @@ -1771,6 +1802,9 @@ void scsi_exit_queue(void)
>  		mempool_destroy(sgp->pool);
>  		kmem_cache_destroy(sgp->slab);
>  	}
> +
> +	mempool_destroy(cdb_pool);
> +	kmem_cache_destroy(cdb_cache);
>  }
>  
>  /**
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 084478e..a7ae10a 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -138,6 +138,7 @@ struct scsi_cmnd;
>   *	SCSI command lengths
>   */
>  
> +#define SCSI_EXT_CDB_SIZE 32
>  #define SCSI_MAX_VARLEN_CDB_SIZE 260
>  
>  /* defined in T10 SCSI Primary Commands-2 (SPC2) */
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 3f566af..de2966b 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -129,6 +129,7 @@ struct scsi_device {
>  				 * this device */
>  	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
>  				     * because we did a bus reset. */
> +	unsigned use_32_for_rw:1; /* use 32-byte read / write (DIF Type 2) */
>  	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
>  	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
>  	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */


Boaz
