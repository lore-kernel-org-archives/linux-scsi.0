From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/19] lpfc: Fix soft lockup in lpfc worker thread during
 LIP testing
Date: Mon, 29 Jan 2018 09:13:12 +0100
Message-ID: <5c35cdcb-d68a-ce54-750f-261dafd2d9f7@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-11-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42273 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbeA2LNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 06:13:51 -0500
In-Reply-To: <20180124224548.9530-11-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> During link bounce testing in a point-to-point topology, the
> host may enter a soft lockup on the lpfc_worker thread:
>     Call Trace:
>      lpfc_work_done+0x1f3/0x1390 [lpfc]
>      lpfc_do_work+0x16f/0x180 [lpfc]
>      kthread+0xc7/0xe0
>      ret_from_fork+0x3f/0x70
> 
> The driver was simultaneously setting a combination of flags
> that caused lpfc_do_work()to effectively spin between slow path
> work and new event data, causing the lockup.
> 
> Ensure in the typical wq completions, that new event data flags
> are set if the slow path flag is running. The slow path will
> eventually reschedule the wq handling.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index b159a5c4e388..9265906d956e 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -696,8 +696,9 @@ lpfc_work_done(struct lpfc_hba *phba)
>  		      phba->hba_flag & HBA_SP_QUEUE_EVT)) {
>  		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
>  			pring->flag |= LPFC_DEFERRED_RING_EVENT;
> -			/* Set the lpfc data pending flag */
> -			set_bit(LPFC_DATA_READY, &phba->data_flags);
> +			/* Preserve legacy behavior. */
> +			if (!(phba->hba_flag & HBA_SP_QUEUE_EVT))
> +				set_bit(LPFC_DATA_READY, &phba->data_flags);
>  		} else {
>  			if (phba->link_state >= LPFC_LINK_UP ||
>  			    phba->link_flag & LS_MDS_LOOPBACK) {
> 
_Actually_ lpfc_do_work() and friends could be replace with a workqueue ...
But anyway.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
