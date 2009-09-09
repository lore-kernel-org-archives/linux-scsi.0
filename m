From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/5] SCSI: Add support for 32-byte CDBs
Date: Wed, 09 Sep 2009 11:28:12 +0300
Message-ID: <4AA7671C.2000308@panasas.com>
References: <1252053394-24886-1-git-send-email-martin.petersen@oracle.com> <1252053394-24886-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:36910 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752792AbZIII2U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 04:28:20 -0400
In-Reply-To: <1252053394-24886-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 09/04/2009 11:36 AM, Martin K. Petersen wrote:
> DIF Type 2 drives require 32-byte commands.  Add a suitable flag to
> struct scsi_device that will cause scsi_setup_fs_cmnd() to allocate a
> bigger command buffer.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c    |   38 +++++++++++++++++++++++++++++++++++++-
>  include/scsi/scsi.h        |    1 +
>  include/scsi/scsi_cmnd.h   |    6 ++++++
>  include/scsi/scsi_device.h |    1 +
>  4 files changed, 45 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 662024d..643769c 100644
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
> @@ -642,6 +645,11 @@ static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
>  
>  	if (scsi_prot_sg_count(cmd))
>  		scsi_free_sgtable(cmd->prot_sdb);
> +
> +	if (cmd->flags & SCSI_CMND_EXT_CDB) {
> +		mempool_free(cmd->cmnd, cdb_pool);
> +		cmd->flags &= ~SCSI_CMND_EXT_CDB;
> +	}
>  }
>  
>  /*
> @@ -1109,7 +1117,19 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
>  	if (unlikely(!cmd))
>  		return BLKPREP_DEFER;
>  
> -	memset(cmd->cmnd, 0, BLK_MAX_CDB);
> +	if (sdev->use_32_for_rw) {
> +		req->cmd = mempool_alloc(cdb_pool, GFP_ATOMIC);
> +
> +		if (unlikely(!req->cmd))

Here we should not hang onto the cmd, because it might be the free-list
command and we'll dead-lock. Better do in this case:

			scsi_put_command(cmd);
			req->special = NULL;

You might want to add a flag to scsi_get_cmd_from_req() and do the allocation
and failure there, where it is more clear what you are doing and why. Also this
way in the future blk_pc_cmnds could use it too, if needed.

> +			return BLKPREP_DEFER;
> +
> +		cmd->cmnd = req->cmd;
> +		cmd->cmd_len = req->cmd_len = SCSI_EXT_CDB_SIZE;
> +		cmd->flags |= SCSI_CMND_EXT_CDB;
> +		memset(cmd->cmnd, 0, cmd->cmd_len);
> +	} else
> +		memset(cmd->cmnd, 0, BLK_MAX_CDB);
> +
>  	return scsi_init_io(cmd, GFP_ATOMIC);
>  }
>  EXPORT_SYMBOL(scsi_setup_fs_cmnd);
> @@ -1745,6 +1765,19 @@ int __init scsi_init_queue(void)
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
> @@ -1771,6 +1804,9 @@ void scsi_exit_queue(void)
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
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 3878d1d..d4a6a80 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -50,6 +50,10 @@ struct scsi_pointer {
>  	volatile int phase;
>  };
>  
> +enum scsi_cmnd_flags {
> +	SCSI_CMND_EXT_CDB = 1 << 0,
> +};
> +
>  struct scsi_cmnd {
>  	struct scsi_device *device;
>  	struct list_head list;  /* scsi_cmnd participates in queue lists */
> @@ -129,6 +133,8 @@ struct scsi_cmnd {
>  	int result;		/* Status code from lower level driver */
>  
>  	unsigned char tag;	/* SCSI-II queued command tag */
> +
> +	enum scsi_cmnd_flags flags;
>  };
>  
>  extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
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

