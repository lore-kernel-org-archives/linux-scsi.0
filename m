From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH] libiscsi: Fix host busy blocking during connection teardown
Date: Wed, 8 Jul 2015 13:08:15 -0700
Message-ID: <CAHNqLyWX003vOp8CCXZ9kbLBzRX9WSRz=c-okF54A=f4uByADA@mail.gmail.com>
References: <1435108318-13625-1-git-send-email-sony.john@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38650 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144AbbGHUIQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 16:08:16 -0400
Received: by igrv9 with SMTP id v9so176563020igr.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2015 13:08:16 -0700 (PDT)
In-Reply-To: <1435108318-13625-1-git-send-email-sony.john@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: John Soni Jose <sony.john@avagotech.com>, minhduc.tran@avagotech.com, jayamohan.kallickal@avagotech.com

On Tue, Jun 23, 2015 at 6:11 PM, John Soni Jose <sony.john@avagotech.com> wrote:
>
>  Issue:
>  In case of hw iscsi offload, an host can have N-number of active
>  connections. There can be IO's running on some connections which
>  make host->host_busy always TRUE. Now if logout from a connection
>  is tried then the code gets into an infinite loop as host->host_busy
>  is always TRUE.
>
>  iscsi_conn_teardown(....)
>  {
>    .........
>     /*
>      * Block until all in-progress commands for this connection
>      * time out or fail.
>      */
>      for (;;) {
>       spin_lock_irqsave(session->host->host_lock, flags);
>       if (!atomic_read(&session->host->host_busy)) { /* OK for ERL == 0 */
>               spin_unlock_irqrestore(session->host->host_lock, flags);
>               break;
>       }
>      spin_unlock_irqrestore(session->host->host_lock, flags);
>      msleep_interruptible(500);
>      iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
>                  "host_busy %d host_failed %d\n",
>                   atomic_read(&session->host->host_busy),
>                   session->host->host_failed);
>
>         ................
>         ...............
>      }
>   }
>   This is not an issue with software-iscsi/iser as each cxn is a separate
>   host.
>
>  Fix:
>  Acquiring eh_mutex in iscsi_conn_teardown() before setting
>  session->state = ISCSI_STATE_TERMINATE.
>
> Signed-off-by: John Soni Jose <sony.john@aavagotech.com>
> ---
>  drivers/scsi/libiscsi.c | 25 ++-----------------------
>  1 file changed, 2 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 8053f24..98d9bb6 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2941,10 +2941,10 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  {
>         struct iscsi_conn *conn = cls_conn->dd_data;
>         struct iscsi_session *session = conn->session;
> -       unsigned long flags;
>
>         del_timer_sync(&conn->transport_timer);
>
> +       mutex_lock(&session->eh_mutex);
>         spin_lock_bh(&session->frwd_lock);
>         conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
>         if (session->leadconn == conn) {
> @@ -2956,28 +2956,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>         }
>         spin_unlock_bh(&session->frwd_lock);
>
> -       /*
> -        * Block until all in-progress commands for this connection
> -        * time out or fail.
> -        */
> -       for (;;) {
> -               spin_lock_irqsave(session->host->host_lock, flags);
> -               if (!atomic_read(&session->host->host_busy)) { /* OK for ERL == 0 */
> -                       spin_unlock_irqrestore(session->host->host_lock, flags);
> -                       break;
> -               }
> -               spin_unlock_irqrestore(session->host->host_lock, flags);
> -               msleep_interruptible(500);
> -               iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
> -                                 "host_busy %d host_failed %d\n",
> -                                 atomic_read(&session->host->host_busy),
> -                                 session->host->host_failed);
> -               /*
> -                * force eh_abort() to unblock
> -                */
> -               wake_up(&conn->ehwait);
> -       }
> -
>         /* flush queued up work because we free the connection below */
>         iscsi_suspend_tx(conn);
>
> @@ -2994,6 +2972,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>         if (session->leadconn == conn)
>                 session->leadconn = NULL;
>         spin_unlock_bh(&session->frwd_lock);
> +       mutex_unlock(&session->eh_mutex);
>
>         iscsi_destroy_conn(cls_conn);
>  }
> --


Looks good to me, solid reasoning on why host_busy is the wrong thing to check.

Reviewed-by: Chris Leech <cleech@redhat.com>
