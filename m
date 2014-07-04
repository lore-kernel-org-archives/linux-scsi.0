From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] scsi: remove various exports that were only used
 by scsi_tgt
Date: Fri, 04 Jul 2014 11:47:06 +0200
Message-ID: <53B6781A.8030703@redhat.com>
References: <1397557614-21243-1-git-send-email-hch@lst.de> <1397557614-21243-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47485 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaGDJrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 05:47:15 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so12744780wiv.9
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jul 2014 02:47:13 -0700 (PDT)
In-Reply-To: <1397557614-21243-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

Il 15/04/2014 12:26, Christoph Hellwig ha scritto:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c      |   10 +++-------
>  drivers/scsi/scsi_lib.c  |   10 ++++------
>  include/scsi/scsi_cmnd.h |    5 -----
>  include/scsi/scsi_host.h |    2 --
>  4 files changed, 7 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe..c499172 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -235,7 +235,8 @@ fail:
>   * Description: allocate a struct scsi_cmd from host's slab, recycling from the
>   *              host's free_list if necessary.
>   */
> -struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
> +static struct scsi_cmnd *
> +__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  {
>  	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);
>
> @@ -265,7 +266,6 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>
>  	return cmd;
>  }
> -EXPORT_SYMBOL_GPL(__scsi_get_command);
>
>  /**
>   * scsi_get_command - Allocate and setup a scsi command block
> @@ -291,14 +291,13 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
>  	cmd->jiffies_at_alloc = jiffies;
>  	return cmd;
>  }
> -EXPORT_SYMBOL(scsi_get_command);
>
>  /**
>   * __scsi_put_command - Free a struct scsi_cmnd
>   * @shost: dev->host
>   * @cmd: Command to free
>   */
> -void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> +static void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  {
>  	unsigned long flags;
>
> @@ -314,7 +313,6 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  	if (likely(cmd != NULL))
>  		scsi_host_free_command(shost, cmd);
>  }
> -EXPORT_SYMBOL(__scsi_put_command);
>
>  /**
>   * scsi_put_command - Free a scsi command block
> @@ -338,7 +336,6 @@ void scsi_put_command(struct scsi_cmnd *cmd)
>
>  	__scsi_put_command(cmd->device->host, cmd);
>  }
> -EXPORT_SYMBOL(scsi_put_command);
>
>  static struct scsi_host_cmd_pool *
>  scsi_find_host_cmd_pool(struct Scsi_Host *shost)
> @@ -801,7 +798,6 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  	}
>  	scsi_io_completion(cmd, good_bytes);
>  }
> -EXPORT_SYMBOL(scsi_finish_command);
>
>  /**
>   * scsi_adjust_queue_depth - Let low level drivers change a device's queue depth
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7fa54fe..609cd61 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -511,6 +511,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
>  		scsi_run_queue(sdev->request_queue);
>  }
>
> +static void scsi_release_buffers(struct scsi_cmnd *cmd);
>  static void __scsi_release_buffers(struct scsi_cmnd *, int);
>
>  /*
> @@ -661,11 +662,10 @@ static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
>   *		the scatter-gather table, and potentially any bounce
>   *		buffers.
>   */
> -void scsi_release_buffers(struct scsi_cmnd *cmd)
> +static void scsi_release_buffers(struct scsi_cmnd *cmd)
>  {
>  	__scsi_release_buffers(cmd, 1);
>  }
> -EXPORT_SYMBOL(scsi_release_buffers);
>
>  /**
>   * __scsi_error_from_host_byte - translate SCSI error code into errno
> @@ -1042,7 +1042,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>   *		BLKPREP_DEFER if the failure is retryable
>   *		BLKPREP_KILL if the failure is fatal
>   */
> -int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> +static int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  {
>  	struct scsi_device *sdev = cmd->device;
>  	struct request *rq = cmd->request;
> @@ -1095,7 +1095,6 @@ err_exit:
>  	put_device(&sdev->sdev_gendev);
>  	return error;
>  }
> -EXPORT_SYMBOL(scsi_init_io);
>
>  static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
>  		struct request *req)
> @@ -1649,7 +1648,7 @@ out_delay:
>  		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>  }
>
> -u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
> +static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
>  {
>  	struct device *host_dev;
>  	u64 bounce_limit = 0xffffffff;
> @@ -1669,7 +1668,6 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
>
>  	return bounce_limit;
>  }
> -EXPORT_SYMBOL(scsi_calculate_bounce_limit);
>
>  struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>  					 request_fn_proc *request_fn)
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index dd7c998..a8f3faf 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -140,18 +140,13 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
>  }
>
>  extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
> -extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
>  extern void scsi_put_command(struct scsi_cmnd *);
> -extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *);
>  extern void scsi_finish_command(struct scsi_cmnd *cmd);
>
>  extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
>  				 size_t *offset, size_t *len);
>  extern void scsi_kunmap_atomic_sg(void *virt);
>
> -extern int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask);
> -extern void scsi_release_buffers(struct scsi_cmnd *cmd);
> -
>  extern int scsi_dma_map(struct scsi_cmnd *cmd);
>  extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
>
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 28336c6..4c38c16 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -795,8 +795,6 @@ extern struct Scsi_Host *scsi_host_lookup(unsigned short);
>  extern const char *scsi_host_state_name(enum scsi_host_state);
>  extern void scsi_cmd_get_serial(struct Scsi_Host *, struct scsi_cmnd *);
>
> -extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
> -
>  static inline int __must_check scsi_add_host(struct Scsi_Host *host,
>  					     struct device *dev)
>  {
>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
