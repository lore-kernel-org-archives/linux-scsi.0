From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 1/2] libiscsi: Fix locking in __iscsi_conn_send_pdu
Date: Wed, 26 Oct 2016 18:27:18 -0700
Message-ID: <a6027d47-53f1-4b3a-796c-c75ad5ed241a@suse.com>
References: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1476340729-8569-2-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753809AbcJ0B2w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 21:28:52 -0400
In-Reply-To: <1476340729-8569-2-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org

On 10/12/2016 11:38 PM, Jitendra Bhivare wrote:
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

Reviewed-by: Lee Duncan <lduncan@suse.com>
