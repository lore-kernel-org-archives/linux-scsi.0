From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 20/30] blk_end_request: changing xsysace
	(take 4)
Date: Wed, 12 Dec 2007 11:09:12 +0200
Message-ID: <475FA538.7000609@panasas.com>
References: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Kiyoshi Ueda wrote:
> This patch converts xsysace to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
> 
> xsysace is a little bit different from "normal" drivers.
> xsysace driver has a state machine in it.
> It calls end_that_request_first() and end_that_request_last()
> from different states. (ACE_FSM_STATE_REQ_TRANSFER and
> ACE_FSM_STATE_REQ_COMPLETE, respectively.)
> 
> However, those states are consecutive and without any interruption
> inbetween.
> So we can just follow the standard conversion rule (b) mentioned in
> the patch subject "[PATCH 01/30] blk_end_request: add new request
> completion interface".
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  drivers/block/xsysace.c |    5 +----
>  1 files changed, 1 insertion(+), 4 deletions(-)
> 
> Index: 2.6.24-rc4/drivers/block/xsysace.c
> ===================================================================
> --- 2.6.24-rc4.orig/drivers/block/xsysace.c
> +++ 2.6.24-rc4/drivers/block/xsysace.c
> @@ -703,7 +703,7 @@ static void ace_fsm_dostate(struct ace_d
>  
>  		/* bio finished; is there another one? */
>  		i = ace->req->current_nr_sectors;
> -		if (end_that_request_first(ace->req, 1, i)) {
> +		if (__blk_end_request(ace->req, 0, i)) {
end_that_request_first() took sectors __blk_end_request() now takes
bytes

>  			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
>  			 *      ace->req->hard_nr_sectors,
>  			 *      ace->req->current_nr_sectors);
> @@ -718,9 +718,6 @@ static void ace_fsm_dostate(struct ace_d
>  		break;
>  
>  	case ACE_FSM_STATE_REQ_COMPLETE:
> -		/* Complete the block request */
> -		blkdev_dequeue_request(ace->req);
> -		end_that_request_last(ace->req, 1);
>  		ace->req = NULL;
>  
>  		/* Finished request; go to idle state */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Boaz
