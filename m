From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 3/4] scsi: Avoid that .queuecommand() gets called for
 a quiesced SCSI device
Date: Thu, 11 Jan 2018 10:23:51 +0800
Message-ID: <20180111022341.GA7290@ming.t460p>
References: <20180110181817.25166-1-bart.vanassche@wdc.com>
 <20180110181817.25166-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110181817.25166-4-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 10, 2018 at 10:18:16AM -0800, Bart Van Assche wrote:
> Several SCSI transport and LLD drivers surround code that does not
> tolerate concurrent calls of .queuecommand() with scsi_target_block() /
> scsi_target_unblock(). These last two functions use
> blk_mq_quiesce_queue() / blk_mq_unquiesce_queue() for scsi-mq request
> queues to prevent concurrent .queuecommand() calls. However, that is

Actually blk_mq_quiesce_queue() is supposed to disable and drain dispatch,
not for prevent concurrent .queuecommand() calls.

> not sufficient to prevent .queuecommand() calls from scsi_send_eh_cmnd().

Given it is error handling, do we need to prevent the .queuecommand() call
in scsi_send_eh_cmnd()? Could you share us what the actual issue
observed is from user view?

> Hence surround the .queuecommand() call from the SCSI error handler with
> blk_start_wait_if_quiesced() / blk_finish_wait_if_quiesced().
> 
> Note: converting the .queuecommand() call in scsi_send_eh_cmnd() into
> code that calls blk_get_request(), e.g. scsi_execute_req(), is not an
> option since scsi_send_eh_cmnd() can be called if all requests are
> allocated and if no requests will make progress without aborting any
> of these requests.

If we need to prevent the .queuecommand() in scsi_send_eh_cmnd(), what
do you think of the approach by requeuing the EH command via
scsi_mq_requeue_cmd()/scsi_requeue_cmd()? And the EH request will be
dispatched finally when the queue becomes unquiesced or the STOPPED
is cleared.

-- 
Ming
