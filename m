From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Tue, 5 Dec 2017 09:15:37 +0800
Message-ID: <20171205011536.GC8365@ming.t460p>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
 <20171205003809.1705-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752731AbdLEBPx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 20:15:53 -0500
Content-Disposition: inline
In-Reply-To: <20171205003809.1705-2-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On Mon, Dec 04, 2017 at 04:38:08PM -0800, Bart Van Assche wrote:
> Since the next patch will make it possible that scsi_show_rq() gets
> called before the CDB pointer is changed into a non-NULL value,
> only show the CDB if the CDB pointer is not NULL. Additionally,
> show the request timeout and SCSI command flags. This patch also
> fixes a bug that was reported by Ming Lei. See also Ming Lei,
> scsi_debugfs: fix crash in scsi_show_rq(), linux-scsi, 7 November
> 2017 (https://marc.info/?l=linux-block&m=151006655317188).

Please cook a patch for fixing the crash issue only, since we need
to backport the fix to stable kernel.

> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>

Please Cc: <stable@vger.kernel.org>

> ---
>  drivers/scsi/scsi_debugfs.c | 47 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> index 01f08c03f2c1..37ed6bb8e6ec 100644
> --- a/drivers/scsi/scsi_debugfs.c
> +++ b/drivers/scsi/scsi_debugfs.c
> @@ -4,13 +4,50 @@
>  #include <scsi/scsi_dbg.h>
>  #include "scsi_debugfs.h"
>  
> +#define SCSI_CMD_FLAG_NAME(name) [ilog2(SCMD_##name)] = #name
> +static const char *const scsi_cmd_flags[] = {
> +	SCSI_CMD_FLAG_NAME(TAGGED),
> +	SCSI_CMD_FLAG_NAME(UNCHECKED_ISA_DMA),
> +	SCSI_CMD_FLAG_NAME(ZONE_WRITE_LOCK),
> +	SCSI_CMD_FLAG_NAME(INITIALIZED),
> +};
> +#undef SCSI_CMD_FLAG_NAME
> +
> +static int scsi_flags_show(struct seq_file *m, const unsigned long flags,
> +			   const char *const *flag_name, int flag_name_count)
> +{
> +	bool sep = false;
> +	int i;
> +
> +	for (i = 0; i < sizeof(flags) * BITS_PER_BYTE; i++) {
> +		if (!(flags & BIT(i)))
> +			continue;
> +		if (sep)
> +			seq_puts(m, "|");
> +		sep = true;
> +		if (i < flag_name_count && flag_name[i])
> +			seq_puts(m, flag_name[i]);
> +		else
> +			seq_printf(m, "%d", i);
> +	}
> +	return 0;
> +}
> +
>  void scsi_show_rq(struct seq_file *m, struct request *rq)
>  {
>  	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
> -	int msecs = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
> -	char buf[80];
> +	int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
> +	int timeout_ms = jiffies_to_msecs(rq->timeout);
> +	const u8 *const cdb = READ_ONCE(cmd->cmnd);
> +	char buf[80] = "(?)";
>  
> -	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> -	seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s ago", buf,
> -		   cmd->retries, msecs / 1000, msecs % 1000);
> +	if (cdb)
> +		__scsi_format_command(buf, sizeof(buf), cdb, cmd->cmd_len);
> +	seq_printf(m, ", .cmd=%s, .retries=%d, .result = %#x, .flags=", buf,
> +		   cmd->retries, cmd->result);
> +	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
> +			ARRAY_SIZE(scsi_cmd_flags));
> +	seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
> +		   timeout_ms / 1000, timeout_ms % 1000,
> +		   alloc_ms / 1000, alloc_ms % 1000);
>  }
> -- 
> 2.15.0
> 

-- 
Ming
