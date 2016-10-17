From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] libiscsi: Fix locking in __iscsi_conn_send_pdu
Date: Mon, 17 Oct 2016 09:19:34 +0200
Message-ID: <8aeb7728-c5f2-e9d4-0879-a9431189045a@suse.de>
References: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1476340729-8569-2-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45103 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756546AbcJQHTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 03:19:36 -0400
In-Reply-To: <1476340729-8569-2-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 10/13/2016 08:38 AM, Jitendra Bhivare wrote:
> The code at free_task label in __iscsi_conn_send_pdu can get executed
> from blk_timeout_work which takes queue_lock using spin_lock_irq.
> back_lock taken with spin_unlock_bh will cause WARN_ON_ONCE.
> The code gets executed either with bottom half or IRQ disabled hence
> using spin_lock/spin_unlock for back_lock is safe.
> 
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/libiscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index c051694..f9b6fba 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -791,9 +791,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  
>  free_task:
>  	/* regular RX path uses back_lock */
> -	spin_lock_bh(&session->back_lock);
> +	spin_lock(&session->back_lock);
>  	__iscsi_put_task(task);
> -	spin_unlock_bh(&session->back_lock);
> +	spin_unlock(&session->back_lock);
>  	return NULL;
>  }
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
