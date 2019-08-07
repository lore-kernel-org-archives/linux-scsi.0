From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/2] scsi: core: fix missing .cleanup_rq for
 SCSI hosts without request batching
Date: Thu, 8 Aug 2019 07:32:29 +0800
Message-ID: <CACVXFVM0tFj8CmcHON04_KjxR=QErCbUx0abJgG2W9OBb7akZA@mail.gmail.com>
References: <20190807144948.28265-1-maier@linux.ibm.com>
	<20190807144948.28265-2-maier@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190807144948.28265-2-maier@linux.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>, linux-s390 <linux-s390@vger.kernel.org>, Benjamin Block <bblock@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 7, 2019 at 10:55 PM Steffen Maier <maier@linux.ibm.com> wrote:
>
> This was missing from scsi_mq_ops_no_commit of linux-next commit
> 8930a6c20791 ("scsi: core: add support for request batching")
> from Martin's scsi/5.4/scsi-queue or James' scsi/misc.
>
> See also linux-next commit b7e9e1fb7a92 ("scsi: implement .cleanup_rq
> callback") from block/for-next.
>
> Signed-off-by: Steffen Maier <maier@linux.ibm.com>
> Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ae03d3e2600f..90c257622bb0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1834,6 +1834,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
>         .init_request   = scsi_mq_init_request,
>         .exit_request   = scsi_mq_exit_request,
>         .initialize_rq_fn = scsi_initialize_rq,
> +       .cleanup_rq     = scsi_cleanup_rq,
>         .busy           = scsi_mq_lld_busy,
>         .map_queues     = scsi_map_queues,
>  };

This one is a cross-tree thing, either scsi/5.4/scsi-queue needs to
pull for-5.4/block, or
do it after both land linus tree.

Thanks,
Ming Lei
