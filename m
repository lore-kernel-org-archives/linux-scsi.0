From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH 1/2] libiscsi: Fix locking in __iscsi_conn_send_pdu
Date: Mon, 17 Oct 2016 08:48:56 -0700
Message-ID: <20161017154856.ovxll6s3b447diuc@straylight.hirudinean.org>
References: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1476340729-8569-2-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933824AbcJQPs6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 11:48:58 -0400
Content-Disposition: inline
In-Reply-To: <1476340729-8569-2-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: lduncan@suse.com, linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 12:08:48PM +0530, Jitendra Bhivare wrote:
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

Thanks for going back and verifying that irqsave wasn't needed here, I
was concerned about adding more interrupt disabled sections outside of
the error handling paths.

Reviewed-by: Chris Leech <cleech@redhat.com>

