From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/22] libfc: Revisit kref handling
Date: Thu, 4 Aug 2016 12:59:23 +0200
Message-ID: <20160804105923.xlsm67targ7rwhxt@c203.arch.suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbcHDK7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 06:59:25 -0400
Content-Disposition: inline
In-Reply-To: <1470230002-37737-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On Wed, Aug 03, 2016 at 03:13:01PM +0200, Hannes Reinecke wrote:
> The kref handling in fc_rport is a mess. This patch updates
> the kref handling according to the following rules:
> 
> - Take a reference whenever scheduling a workqueue
> - Take a reference whenever an ELS command is send
> - Drop the reference at the end of the workqueue function
> - Drop the reference at the end of handling ELS replies
> - Take a reference when allocating an rport
> - Drop the reference when removing an rport
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/libfc/fc_rport.c | 134 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 103 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> index 93f5961..6a98bb8 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -44,6 +44,17 @@
>   * path this potential over-use of the mutex is acceptable.
>   */
>  
> +/*
> + * RPORT REFERENCE COUNTING
> + *
> + * A rport reference should be taken when:
> + * - a workqueue item is scheduled
> + * - an ELS request is send
> + * The reference should be dropped when:
> + * - the workqueue function has finished
> + * - the ELS response is handled
> + */

Please sync with the rules in the commit message.

> +
>  #include <linux/kernel.h>
>  #include <linux/spinlock.h>
>  #include <linux/interrupt.h>
> @@ -242,6 +253,8 @@ static void fc_rport_state_enter(struct fc_rport_priv *rdata,
>  /**
>   * fc_rport_work() - Handler for remote port events in the rport_event_queue
>   * @work: Handle to the remote port being dequeued
> + *
> + * Reference counting: drops kref on return
>   */
>  static void fc_rport_work(struct work_struct *work)
>  {
> @@ -272,8 +285,10 @@ static void fc_rport_work(struct work_struct *work)
>  		kref_get(&rdata->kref);
>  		mutex_unlock(&rdata->rp_mutex);
>  
> -		if (!rport)
> +		if (!rport) {
> +			FC_RPORT_DBG(rdata, "No rport!\n");

If you're re-sending the series, this and the other added debug statements
might be better suited in '[PATCH 02/22] libfc: additional debugging messages'.

Otherwise

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
