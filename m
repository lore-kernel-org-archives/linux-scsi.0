From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: RE: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Mon, 24 Jun 2013 15:48:41 +0200
Message-ID: <51C84E39.80806@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44634 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3FXNss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 09:48:48 -0400
Received: by mail-bk0-f46.google.com with SMTP id na10so4190887bkb.33
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2013 06:48:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>, David Dillow <dillowda@ornl.gov>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

> I'm not sure it's possible to avoid such a race without introducing
> a new mutex. How about something like the (untested) SCSI core patch
> below, and invoking scsi_block_eh() and scsi_unblock_eh() around any
> reconnect activity not initiated from the SCSI EH thread ?
> 
> [PATCH] Add scsi_block_eh() and scsi_unblock_eh()
> 
Hi Bart,

The description doesn't match the code at all, do you mean try to
serialize the reconnect activity with this new block_eh_mutex?

Cheers,
Jack
> ---
>  drivers/scsi/hosts.c      |    1 +
>  drivers/scsi/scsi_error.c |   10 ++++++++++
>  include/scsi/scsi_host.h  |    1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 17e2ccb..0df3ec8 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -360,6 +360,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>         init_waitqueue_head(&shost->host_wait);
> 
>         mutex_init(&shost->scan_mutex);
> +       mutex_init(&shost->block_eh_mutex);
> 
>         /*
>          * subtract one because we increment first then return, but we need to
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ab16930..566daaa 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -551,6 +551,10 @@ static int scsi_begin_eh(struct Scsi_Host *host)
>  {
>         int res;
> 
> +       res = mutex_lock_interruptible(&host->block_eh_mutex);
> +       if (res)
> +               goto out;
> +
>         spin_lock_irq(host->host_lock);
>         switch (host->shost_state) {
>         case SHOST_DEL:
> @@ -565,6 +569,10 @@ static int scsi_begin_eh(struct Scsi_Host *host)
>         }
>         spin_unlock_irq(host->host_lock);
> 
> +       if (res)
> +               mutex_unlock(&host->block_eh_mutex);
> +
> +out:
>         return res;
>  }
> 
> @@ -579,6 +587,8 @@ static void scsi_end_eh(struct Scsi_Host *host)
>         if (host->eh_active == 0)
>                 wake_up(&host->host_wait);
>         spin_unlock_irq(host->host_lock);
> +
> +       mutex_unlock(&host->block_eh_mutex);
>  }
> 
>  /**
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 9785e51..d7ce065 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -573,6 +573,7 @@ struct Scsi_Host {
>         spinlock_t              *host_lock;
> 
>         struct mutex            scan_mutex;/* serialize scanning activity */
> +       struct mutex            block_eh_mutex; /* block ML LLD EH calls */
> 
>         struct list_head        eh_cmd_q;
>         struct task_struct    * ehandler;  /* Error recovery thread. */

