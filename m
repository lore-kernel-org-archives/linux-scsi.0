From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] blk-mq: Revert multiple recent patches
Date: Tue, 7 Nov 2017 10:29:39 +0800
Message-ID: <20171107022938.GE15090@ming.t460p>
References: <20171107010731.5099-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107010731.5099-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 06, 2017 at 05:07:31PM -0800, Bart Van Assche wrote:
> Since we are close to the merge window and since it is too late for
> reworking patches and algorithms that have turned out to be flawed,
> revert multiple recent patches. Revert patch "blk-mq: don't handle
> TAG_SHARED in restart" and all patches that conflict with the revert
> of that patch because that patch is based on an incorrect assumption,
> namely that the SCSI starved list can be used as a replacement for
> the blk-mq queue restarting mechanism. Revert patch "scsi: implement
> .get_budget and .put_budget for blk-mq" because it triggers an
> infinite loop on my test setup ("scsi 9:0:0:0: rejecting I/O to dead
> device" + RCU lockup complaint in blk_mq_sched_dispatch_requests()).

The loop can be fixed by 

	88022d7201e9 blk-mq: don't handle failure in .get_budget


-- 
Ming
