From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 1/3] scsi: Fix a scsi_show_rq() NULL pointer
 dereference
Date: Fri, 8 Dec 2017 09:45:29 +0800
Message-ID: <20171208014528.GD21488@ming.t460p>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
 <20171206005753.28734-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171206005753.28734-2-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 04:57:51PM -0800, Bart Van Assche wrote:
> Avoid that scsi_show_rq() triggers a NULL pointer dereference if
> called after sd_uninit_command(). Swap the NULL pointer assignment
> and the mempool_free() call in sd_uninit_command() to make it less
> likely that scsi_show_rq() triggers a use-after-free. Note: even
> with these changes scsi_show_rq() can trigger a use-after-free but
> that's a lesser evil than e.g. suppressing debug information for
> T10-PI commands completely. This patch fixes the following oops:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: scsi_format_opcode_name+0x1a/0x1c0
> CPU: 1 PID: 1881 Comm: cat Not tainted 4.14.0-rc2.blk_mq_io_hang+ #516
> Call Trace:
>  __scsi_format_command+0x27/0xc0
>  scsi_show_rq+0x5c/0xc0
>  __blk_mq_debugfs_rq_show+0x116/0x130
>  blk_mq_debugfs_rq_show+0xe/0x10
>  seq_read+0xfe/0x3b0
>  full_proxy_read+0x54/0x90
>  __vfs_read+0x37/0x160
>  vfs_read+0x96/0x130
>  SyS_read+0x55/0xc0
>  entry_SYSCALL_64_fastpath+0x1a/0xa5
> 
> Fixes: 0eebd005dd07 ("scsi: Implement blk_mq_ops.show_rq()")
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/scsi_debugfs.c | 6 ++++--
>  drivers/scsi/sd.c           | 4 +++-
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> index 01f08c03f2c1..c3765d29fd3f 100644
> --- a/drivers/scsi/scsi_debugfs.c
> +++ b/drivers/scsi/scsi_debugfs.c
> @@ -8,9 +8,11 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
>  {
>  	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
>  	int msecs = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
> -	char buf[80];
> +	const u8 *const cdb = READ_ONCE(cmd->cmnd);
> +	char buf[80] = "(?)";
>  
> -	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> +	if (cdb)
> +		__scsi_format_command(buf, sizeof(buf), cdb, cmd->cmd_len);
>  	seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s ago", buf,
>  		   cmd->retries, msecs / 1000, msecs % 1000);
>  }

As I explained in [1], the use-after-free is inevitable no matter if
clearing 'SCpnt->cmnd' before mempool_free() in sd_uninit_command() or not,
so we need to comment the fact that cdb may point to garbage data, and this
function(especially __scsi_format_command() has to survive that, so that
people won't be surprised when kasan complains use-after-free, and guys will
be careful when they try to change the code in future.

Once this comment is added, with or without clearing 'SCpnt->cmnd' before
mempool_free(), I am fine with this patch.

[1] https://marc.info/?l=linux-block&m=151252302112512&w=2

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d175c5c5ccf8..d841743b2107 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1284,6 +1284,7 @@ static int sd_init_command(struct scsi_cmnd *cmd)
>  static void sd_uninit_command(struct scsi_cmnd *SCpnt)
>  {
>  	struct request *rq = SCpnt->request;
> +	u8 *cmnd;
>  
>  	if (SCpnt->flags & SCMD_ZONE_WRITE_LOCK)
>  		sd_zbc_write_unlock_zone(SCpnt);
> @@ -1292,9 +1293,10 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
>  		__free_page(rq->special_vec.bv_page);
>  
>  	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
> -		mempool_free(SCpnt->cmnd, sd_cdb_pool);
> +		cmnd = SCpnt->cmnd;
>  		SCpnt->cmnd = NULL;
>  		SCpnt->cmd_len = 0;
> +		mempool_free(cmnd, sd_cdb_pool);
>  	}
>  }
>  
> -- 
> 2.15.0
> 

-- 
Ming
