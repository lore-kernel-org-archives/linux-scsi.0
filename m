From: Hannes Reinecke <hare@suse.de>
Subject: Re: 2.6.24-rc4-mm1: hostbyte=0x01 driverbyte=0x00 (now bisected)
Date: Thu, 06 Dec 2007 08:52:29 +0100
Message-ID: <4757AA3D.4060003@suse.de>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205234154.GA4041@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090007040606070705060206"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbXLFHwb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Dec 2007 02:52:31 -0500
In-Reply-To: <20071205234154.GA4041@martell.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090007040606070705060206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Alexey Dobriyan wrote:
>>  git-scsi-misc.patch
> 
> Apologies for not looking into the problem earlier. See
> http://marc.info/?t=119628022300005&r=1&w=2
> "2.6.24-rc3-mm2: Result: hostbyte=0x01 driverbyte=0x00\nend_request: I/O error"
> for previous installment.
> 
> I've bisected it to the following patch in git-scsi-misc branch.
> Revert on top of 2.6.24-rc4-mm1 also helps.
> 
> commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Nov 6 09:23:40 2007 +0100
> 
>     [SCSI] Do not requeue requests if REQ_FAILFAST is set
>     
>     Any requests with the REQ_FAILFAST flag set should not be requeued
>     to the requeust queue, but rather terminated directly.
>     Otherwise the multipath failover will stall until the command
>     timeout triggers.
>     
>     Signed-off-by: Hannes Reinecke <hare@suse.de>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0f44bdb..0da0dd0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1286,6 +1286,11 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
>  			 */
>  			if (!(req->cmd_flags & REQ_PREEMPT))
>  				ret = BLKPREP_DEFER;
> +			/*
> +			 * Return failfast requests immediately
> +			 */
> +			if (req->cmd_flags & REQ_FAILFAST)
> +				ret = BLKPREP_KILL;
>  			break;
>  		default:
>  			/*
> @@ -1414,6 +1419,17 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>  	return 1;
>  }
>  
> +static void __scsi_kill_request(struct request *req)
> +{
> +	struct scsi_cmnd *cmd = req->special;
> +	struct scsi_device *sdev = cmd->device;
> +
> +	cmd->result = DID_NO_CONNECT << 16;
> +	atomic_inc(&cmd->device->iorequest_cnt);
> +	sdev->device_busy--;
> +	__scsi_done(cmd);
> +}
> +
>  /*
>   * Kill a request for a dead device
>   */
> @@ -1527,8 +1543,16 @@ static void scsi_request_fn(struct request_queue *q)
>  		 * accept it.
>  		 */
>  		req = elv_next_request(q);
> -		if (!req || !scsi_dev_queue_ready(q, sdev))
> +		if (!req)
> +			break;
> +
> +		if (!scsi_dev_queue_ready(q, sdev)) {
> +			if (req->cmd_flags & REQ_FAILFAST) {
> +				scsi_kill_request(req, q);
> +				continue;
> +			}
>  			break;
> +		}
>  
>  		if (unlikely(!scsi_device_online(sdev))) {
>  			sdev_printk(KERN_ERR, sdev,
> @@ -1609,8 +1633,12 @@ static void scsi_request_fn(struct request_queue *q)
>  	 * later time.
>  	 */
>  	spin_lock_irq(q->queue_lock);
> -	blk_requeue_request(q, req);
> -	sdev->device_busy--;
> +	if (unlikely(req->cmd_flags & REQ_FAILFAST))
> +		__scsi_kill_request(req);
> +	else {
> +		blk_requeue_request(q, req);
> +		sdev->device_busy--;
> +	}
>  	if(sdev->device_busy == 0)
>  		blk_plug_device(q);
>   out:
Yeah, sorry. That patch was bad. Please use the attached one instead.
Andrew, can you replace them?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------090007040606070705060206
Content-Type: text/plain;
 name="tmp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tmp"

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 13e7e09..9ec1566 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1284,13 +1284,15 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			/*
 			 * If the devices is blocked we defer normal commands.
 			 */
-			if (!(req->cmd_flags & REQ_PREEMPT))
-				ret = BLKPREP_DEFER;
-			/*
-			 * Return failfast requests immediately
-			 */
-			if (req->cmd_flags & REQ_FAILFAST)
-				ret = BLKPREP_KILL;
+			if (!(req->cmd_flags & REQ_PREEMPT)) {
+				/*
+				 * Return failfast requests immediately
+				 */
+				if (req->cmd_flags & REQ_FAILFAST)
+					ret = BLKPREP_KILL;
+				else
+					ret = BLKPREP_DEFER;
+			}
 			break;
 		default:
 			/*

--------------090007040606070705060206--
