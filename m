From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/7] qla2xxx: Remove racy, now-redundant check of
 sess_tearing_down
Date: Mon, 16 Jul 2012 16:10:32 -0700
Message-ID: <1342480232.18004.310.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-7-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51435 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2GPXKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2012 19:10:38 -0400
In-Reply-To: <1342461882-5848-7-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>

On Mon, 2012-07-16 at 11:04 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Now that target_submit_cmd() / target_get_sess_cmd() check
> sess_tearing_down before adding commands to the list, we no longer
> need the check in qlt_do_work().  In fact this check is racy anyway
> (and that race is what inspired the change to add the check of
> sess_tearing_down to the target core).
> 
> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Cc: Arun Easi <arun.easi@qlogic.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |   16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 

Glad to see this one finally go.  ;)

Applied to for-next

> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 87b5a330..5b30132 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2643,19 +2643,9 @@ static void qlt_do_work(struct work_struct *work)
>  	spin_lock_irqsave(&ha->hardware_lock, flags);
>  	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
>  	    atio->u.isp24.fcp_hdr.s_id);
> -	if (sess) {
> -		if (unlikely(sess->se_sess->sess_tearing_down)) {
> -			sess = NULL;
> -			spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -			goto out_term;
> -		} else {
> -			/*
> -			 * Do the extra kref_get() before dropping
> -			 * qla_hw_data->hardware_lock.
> -			 */
> -			kref_get(&sess->se_sess->sess_kref);
> -		}
> -	}
> +	/* Do kref_get() before dropping qla_hw_data->hardware_lock. */
> +	if (sess)
> +		kref_get(&sess->se_sess->sess_kref);
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	if (unlikely(!sess)) {


