From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 04/11] IB/srp: keep processing commands during host removal
Date: Mon, 26 Nov 2012 10:43:36 +0100
Message-ID: <50B339C8.2000104@acm.org>
References: <cover.1353903448.git.dillowda@ornl.gov> <8715294a23dded5879b3a327c470d9b6a39ddbc4.1353903448.git.dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8715294a23dded5879b3a327c470d9b6a39ddbc4.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/26/12 05:44, David Dillow wrote:
> From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> 
> Some SCSI upper layer drivers, e.g. sd, issue SCSI commands from
> inside scsi_remove_host() (see also the sd_shutdown() call in
> sd_remove()). Make sure that these commands have a chance to reach
> the SCSI device.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> [ adapted to new state tracking ]
> Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c |   11 ++++++-----
>   1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 2951e1c..f7d7e6a 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1328,12 +1328,13 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   	int len;
>   
>   	if (unlikely(target->state)) {
> -		if (!srp_is_removed(target))
> +		/*
> +		 * Only requeue commands if we cannot send them to the target.
> +		 * We'll let commands through during shutdown so that caches
> +		 * get flushed, etc.
> +		 */
> +		if (srp_is_disconnected(target) || srp_in_error(target))
>   			goto err;
> -
> -		scmnd->result = DID_BAD_TARGET << 16;
> -		scmnd->scsi_done(scmnd);
> -		return 0;
>   	}
>   
>   	spin_lock_irqsave(&target->lock, flags);

Hi Dave,

After I posted the patch on which the above patch has been based I
realized that it can be simplified. Since the patch called "Eliminate
state SRP_TARGET_CONNECTING" blocks the SCSI host as long as the RDMA
RC connection is being reconnected srp_queuecommand() won't be invoked
during the "disconnected" or "error" state. How about adding the patch
below just after the patch that eliminates the state
SRP_TARGET_CONNECTING ?

Bart.

 
[PATCH] ib_srp: Keep processing commands during host removal

Some SCSI upper layer drivers, e.g. sd, issue SCSI commands from
inside scsi_remove_host(). See also the sd_shutdown() call in
sd_remove(). Make sure that these commands have a chance to reach
the SCSI device.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 39723e7..03b9fa0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1324,13 +1324,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED) {
-		scmnd->result = DID_BAD_TARGET << 16;
-		scmnd->scsi_done(scmnd);
-		return 0;
-	}
-
 	spin_lock_irqsave(&target->lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
 	if (!iu)
-- 
1.7.10.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
