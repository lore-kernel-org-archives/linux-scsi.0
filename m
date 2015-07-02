From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH]  libiscsi: Fix host busy blocking during connection teardown
Date: Thu, 02 Jul 2015 15:16:05 -0500
Message-ID: <55959C05.1070101@cs.wisc.edu>
References: <1435108318-13625-1-git-send-email-sony.john@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48727 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbbGBUQS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jul 2015 16:16:18 -0400
In-Reply-To: <1435108318-13625-1-git-send-email-sony.john@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john@avagotech.com>, linux-scsi@vger.kernel.org, minhduc.tran@avagotech.com, jayamohan.kallickal@avagotech.com
Cc: John Soni Jose <sony.john@aavagotech.com>

On 6/23/15, 8:11 PM, John Soni Jose wrote:
>   Issue:
>   In case of hw iscsi offload, an host can have N-number of active
>   connections. There can be IO's running on some connections which
>   make host->host_busy always TRUE. Now if logout from a connection
>   is tried then the code gets into an infinite loop as host->host_busy
>   is always TRUE.
>
>   iscsi_conn_teardown(....)
>   {
>     .........
>      /*
>       * Block until all in-progress commands for this connection
>       * time out or fail.
>       */
>       for (;;) {
>        spin_lock_irqsave(session->host->host_lock, flags);
>        if (!atomic_read(&session->host->host_busy)) { /* OK for ERL == 0 */
> 	      spin_unlock_irqrestore(session->host->host_lock, flags);
>                break;
>        }
>       spin_unlock_irqrestore(session->host->host_lock, flags);
>       msleep_interruptible(500);
>       iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
>                   "host_busy %d host_failed %d\n",
> 	          atomic_read(&session->host->host_busy),
> 	          session->host->host_failed);
>
> 	................
> 	...............
>       }
>    }
>    This is not an issue with software-iscsi/iser as each cxn is a separate
>    host.
>
>   Fix:
>   Acquiring eh_mutex in iscsi_conn_teardown() before setting
>   session->state = ISCSI_STATE_TERMINATE.
>
> Signed-off-by: John Soni Jose <sony.john@aavagotech.com>
> ---
>   drivers/scsi/libiscsi.c | 25 ++-----------------------
>   1 file changed, 2 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 8053f24..98d9bb6 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2941,10 +2941,10 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>   {
>   	struct iscsi_conn *conn = cls_conn->dd_data;
>   	struct iscsi_session *session = conn->session;
> -	unsigned long flags;
>
>   	del_timer_sync(&conn->transport_timer);
>
> +	mutex_lock(&session->eh_mutex);
>   	spin_lock_bh(&session->frwd_lock);
>   	conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
>   	if (session->leadconn == conn) {
> @@ -2956,28 +2956,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>   	}
>   	spin_unlock_bh(&session->frwd_lock);
>
> -	/*
> -	 * Block until all in-progress commands for this connection
> -	 * time out or fail.
> -	 */
> -	for (;;) {
> -		spin_lock_irqsave(session->host->host_lock, flags);
> -		if (!atomic_read(&session->host->host_busy)) { /* OK for ERL == 0 */
> -			spin_unlock_irqrestore(session->host->host_lock, flags);
> -			break;
> -		}
> -		spin_unlock_irqrestore(session->host->host_lock, flags);
> -		msleep_interruptible(500);
> -		iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
> -				  "host_busy %d host_failed %d\n",
> -				  atomic_read(&session->host->host_busy),
> -				  session->host->host_failed);
> -		/*
> -		 * force eh_abort() to unblock
> -		 */
> -		wake_up(&conn->ehwait);
> -	}
> -
>   	/* flush queued up work because we free the connection below */
>   	iscsi_suspend_tx(conn);
>
> @@ -2994,6 +2972,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>   	if (session->leadconn == conn)
>   		session->leadconn = NULL;
>   	spin_unlock_bh(&session->frwd_lock);
> +	mutex_unlock(&session->eh_mutex);
>
>   	iscsi_destroy_conn(cls_conn);
>   }

It looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

