Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D952CA9EC7
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 02:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BF5B20856
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 02:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8CWdq2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJaCZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 22:25:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39972 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfJaCZw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 22:25:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so4273871wmm.5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2019 19:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ldmtN6O+kJWoRwy+0LGdbzuXTurRAhJNthHgJjr+bX4=;
        b=Y8CWdq2rn8lh8BbMNQqqDSt1t/WOoGmjhwalQKi651PlKEombDrg/xuYy+e+fVHjTY
         KQ19Ruh/RNjFXLcbyGGibOiuGezV1CQymWSftlEZHytunC8Ob078Jy53vGudA6G2yXMn
         qR8lobk5lAnIFBswt4MlSarRlHb/CCHBIHx8b9xfOPLUlNlQ1QNTxsnGd/B8M/ssbLAh
         LYMlw83hYVrK+3ucqDHdi7K+ARZd/I4V/V6ci27EPlMP394JAweBH7Vx5phFiqQju65Q
         4a8PaiDcofJ6JgcBmtgw4ujXJnME17TWAMa8XbmX1hWufNE8IzIRwGsZ4MBQOxYJm2fY
         JdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ldmtN6O+kJWoRwy+0LGdbzuXTurRAhJNthHgJjr+bX4=;
        b=JkazZpJJeJ715uVwlD0Xaj9YveutI3D7o0DbVQESo5gK7zl5U8Drie9TAudrKcKmQa
         EQpx2aMb4E2DudC8jn7MJKwz6P7uQkj1+8S9B1jtDY7c71lRqbEJKd0bwZyIl/jE8WQJ
         SxGO6HD5idhH9qPbZ8m9cqjrNbwaV2AYuQ1szA6Hc16I30joNZg4nWVPDK1/w0fB869r
         ibz1FPEosr/fh5QWdLTISO5OZtb/o8l9sXCWMicAEVgjafebh0mxOEXfOI6LpOywbYyI
         HYz/YHSszCvlztZddYCU+BWMQzhG2RPKMq4hAvJRo6BurElEQf/g/NZDARFeWECtJiIo
         n9LQ==
X-Gm-Message-State: APjAAAU5b5yWgkcQ49p4xpFK+pWbCwZmhxFlE86DtH/jswtjikGcp9I3
        EZl6CzKw0YYLCiC2oJ4K/mGuLzUBmY1C7I0pnGI=
X-Google-Smtp-Source: APXvYqzciy2dXVwXZEvTeN4UZc7LfCMSrKKHyohcyAshvwG755poNPKfeL8Z2bvrugHQ5/3rlljILhL61kqQmmhotqY=
X-Received: by 2002:a1c:e08a:: with SMTP id x132mr2547511wmg.146.1572488748804;
 Wed, 30 Oct 2019 19:25:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191025065855.6309-1-ming.lei@redhat.com>
In-Reply-To: <20191025065855.6309-1-ming.lei@redhat.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Thu, 31 Oct 2019 10:25:37 +0800
Message-ID: <CACVXFVO+bP+LnmKLiGZUia0Mn-o11KCMpFsqQ3URe9dzZqbUPQ@mail.gmail.com>
Subject: Re: [PATCH V5] scsi: core: avoid host-wide host_busy counter for scsi_mq
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Linux SCSI List <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 26, 2019 at 3:25 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> It isn't necessary to check the host depth in scsi_queue_rq() any more
> since it has been respected by blk-mq before calling scsi_queue_rq() via
> getting driver tag.
>
> Lots of LUNs may attach to same host and per-host IOPS may reach millions,
> so we should avoid expensive atomic operations on the host-wide counter in
> the IO path.
>
> This patch implements scsi_host_busy() via blk_mq_tagset_busy_iter()
> with one scsi command state for reading the count of busy IOs for scsi_mq.
>
> It is observed that IOPS is increased by 15% in IO test on scsi_debug (32
> LUNs, 32 submit queues, 1024 can_queue, libaio/dio) in a dual-socket
> system.
>
> V5:
>         - fix document on .can_queue, no code change
>
> V4:
>         - fix one build waring, just a line change in scsi_dev_queue_ready()
>
> V3:
>         - use non-atomic set/clear bit operations as suggested by Bart
>         - kill single field struct for storing count of in-flight requests
>         - add patch to bypass the atomic LUN-wide counter of device_busy
>         for fast SSD device
>
> V2:
>         - introduce SCMD_STATE_INFLIGHT for getting accurate host busy
>         via blk_mq_tagset_busy_iter()
>         - verified that original Jens's report[1] is fixed
>         - verified that SCSI timeout/abort works fine
>
> [1] https://www.spinics.net/lists/linux-scsi/msg122867.html
> [2] V1 & its revert:
>
> d772a65d8a6c Revert "scsi: core: avoid host-wide host_busy counter for scsi_mq"
> 23aa8e69f2c6 Revert "scsi: core: fix scsi_host_queue_ready"
> 265d59aacbce scsi: core: fix scsi_host_queue_ready
> 328728630d9f scsi: core: avoid host-wide host_busy counter for scsi_mq
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c     | 19 ++++++++++++++++-
>  drivers/scsi/scsi.c      |  2 +-
>  drivers/scsi/scsi_lib.c  | 45 ++++++++++++++++++++--------------------
>  drivers/scsi/scsi_priv.h |  2 +-
>  include/scsi/scsi_cmnd.h |  1 +
>  include/scsi/scsi_host.h |  3 +--
>  6 files changed, 44 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 55522b7162d3..1d669e47b692 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -38,6 +38,7 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_transport.h>
> +#include <scsi/scsi_cmnd.h>
>
>  #include "scsi_priv.h"
>  #include "scsi_logging.h"
> @@ -554,13 +555,29 @@ struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
>  }
>  EXPORT_SYMBOL(scsi_host_get);
>
> +static bool scsi_host_check_in_flight(struct request *rq, void *data,
> +                                     bool reserved)
> +{
> +       int *count = data;
> +       struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +
> +       if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
> +               (*count)++;
> +
> +       return true;
> +}
> +
>  /**
>   * scsi_host_busy - Return the host busy counter
>   * @shost:     Pointer to Scsi_Host to inc.
>   **/
>  int scsi_host_busy(struct Scsi_Host *shost)
>  {
> -       return atomic_read(&shost->host_busy);
> +       int cnt = 0;
> +
> +       blk_mq_tagset_busy_iter(&shost->tag_set,
> +                               scsi_host_check_in_flight, &cnt);
> +       return cnt;
>  }
>  EXPORT_SYMBOL(scsi_host_busy);
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1f5b5c8a7f72..ddc4ec6ea2a1 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -186,7 +186,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>         struct scsi_driver *drv;
>         unsigned int good_bytes;
>
> -       scsi_device_unbusy(sdev);
> +       scsi_device_unbusy(sdev, cmd);
>
>         /*
>          * Clear the flags that say that the device/target/host is no longer
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index dc210b9d4896..2563b061f56b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -189,7 +189,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>          * active on the host/device.
>          */
>         if (unbusy)
> -               scsi_device_unbusy(device);
> +               scsi_device_unbusy(device, cmd);
>
>         /*
>          * Requeue this command.  It will go before all other commands
> @@ -321,20 +321,20 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
>  }
>
>  /*
> - * Decrement the host_busy counter and wake up the error handler if necessary.
> - * Avoid as follows that the error handler is not woken up if shost->host_busy
> - * == shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in combination
> - * with an RCU read lock in this function to ensure that this function in its
> - * entirety either finishes before scsi_eh_scmd_add() increases the
> + * Wake up the error handler if necessary. Avoid as follows that the error
> + * handler is not woken up if host in-flight requests number ==
> + * shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in combination
> + * with an RCU read lock in this function to ensure that this function in
> + * its entirety either finishes before scsi_eh_scmd_add() increases the
>   * host_failed counter or that it notices the shost state change made by
>   * scsi_eh_scmd_add().
>   */
> -static void scsi_dec_host_busy(struct Scsi_Host *shost)
> +static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  {
>         unsigned long flags;
>
>         rcu_read_lock();
> -       atomic_dec(&shost->host_busy);
> +       __clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>         if (unlikely(scsi_host_in_recovery(shost))) {
>                 spin_lock_irqsave(shost->host_lock, flags);
>                 if (shost->host_failed || shost->host_eh_scheduled)
> @@ -344,12 +344,12 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost)
>         rcu_read_unlock();
>  }
>
> -void scsi_device_unbusy(struct scsi_device *sdev)
> +void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>  {
>         struct Scsi_Host *shost = sdev->host;
>         struct scsi_target *starget = scsi_target(sdev);
>
> -       scsi_dec_host_busy(shost);
> +       scsi_dec_host_busy(shost, cmd);
>
>         if (starget->can_queue > 0)
>                 atomic_dec(&starget->target_busy);
> @@ -430,9 +430,6 @@ static inline bool scsi_target_is_busy(struct scsi_target *starget)
>
>  static inline bool scsi_host_is_busy(struct Scsi_Host *shost)
>  {
> -       if (shost->can_queue > 0 &&
> -           atomic_read(&shost->host_busy) >= shost->can_queue)
> -               return true;
>         if (atomic_read(&shost->host_blocked) > 0)
>                 return true;
>         if (shost->host_self_blocked)
> @@ -1139,6 +1136,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>         unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
>         unsigned long jiffies_at_alloc;
>         int retries;
> +       bool in_flight;
>
>         if (!blk_rq_is_scsi(rq) && !(flags & SCMD_INITIALIZED)) {
>                 flags |= SCMD_INITIALIZED;
> @@ -1147,6 +1145,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>
>         jiffies_at_alloc = cmd->jiffies_at_alloc;
>         retries = cmd->retries;
> +       in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>         /* zero out the cmd, except for the embedded scsi_request */
>         memset((char *)cmd + sizeof(cmd->req), 0,
>                 sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
> @@ -1158,6 +1157,8 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>         INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
>         cmd->jiffies_at_alloc = jiffies_at_alloc;
>         cmd->retries = retries;
> +       if (in_flight)
> +               __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>
>         scsi_add_cmd_to_list(cmd);
>  }
> @@ -1367,16 +1368,14 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
>   */
>  static inline int scsi_host_queue_ready(struct request_queue *q,
>                                    struct Scsi_Host *shost,
> -                                  struct scsi_device *sdev)
> +                                  struct scsi_device *sdev,
> +                                  struct scsi_cmnd *cmd)
>  {
> -       unsigned int busy;
> -
>         if (scsi_host_in_recovery(shost))
>                 return 0;
>
> -       busy = atomic_inc_return(&shost->host_busy) - 1;
>         if (atomic_read(&shost->host_blocked) > 0) {
> -               if (busy)
> +               if (scsi_host_busy(shost) > 0)
>                         goto starved;
>
>                 /*
> @@ -1390,8 +1389,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>                                      "unblocking host at zero depth\n"));
>         }
>
> -       if (shost->can_queue > 0 && busy >= shost->can_queue)
> -               goto starved;
>         if (shost->host_self_blocked)
>                 goto starved;
>
> @@ -1403,6 +1400,8 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>                 spin_unlock_irq(shost->host_lock);
>         }
>
> +       __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> +
>         return 1;
>
>  starved:
> @@ -1411,7 +1410,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>                 list_add_tail(&sdev->starved_entry, &shost->starved_list);
>         spin_unlock_irq(shost->host_lock);
>  out_dec:
> -       scsi_dec_host_busy(shost);
> +       scsi_dec_host_busy(shost, cmd);
>         return 0;
>  }
>
> @@ -1665,7 +1664,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>         ret = BLK_STS_RESOURCE;
>         if (!scsi_target_queue_ready(shost, sdev))
>                 goto out_put_budget;
> -       if (!scsi_host_queue_ready(q, shost, sdev))
> +       if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>                 goto out_dec_target_busy;
>
>         if (!(req->rq_flags & RQF_DONTPREP)) {
> @@ -1697,7 +1696,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>         return BLK_STS_OK;
>
>  out_dec_host_busy:
> -       scsi_dec_host_busy(shost);
> +       scsi_dec_host_busy(shost, cmd);
>  out_dec_target_busy:
>         if (scsi_target(sdev)->can_queue > 0)
>                 atomic_dec(&scsi_target(sdev)->target_busy);
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index cc2859d76d81..3bff9f7aa684 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -87,7 +87,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
>  extern void scsi_add_cmd_to_list(struct scsi_cmnd *cmd);
>  extern void scsi_del_cmd_from_list(struct scsi_cmnd *cmd);
>  extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
> -extern void scsi_device_unbusy(struct scsi_device *sdev);
> +extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
>  extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
>  extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
>  extern void scsi_run_host_queues(struct Scsi_Host *shost);
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 91bd749a02f7..9c22e85902ec 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -63,6 +63,7 @@ struct scsi_pointer {
>
>  /* for scmd->state */
>  #define SCMD_STATE_COMPLETE    0
> +#define SCMD_STATE_INFLIGHT    1
>
>  struct scsi_cmnd {
>         struct scsi_request req;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 31e0d6ca1eba..d4452d0ea3c7 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -345,7 +345,7 @@ struct scsi_host_template {
>         /*
>          * This determines if we will use a non-interrupt driven
>          * or an interrupt driven scheme.  It is set to the maximum number
> -        * of simultaneous commands a given host adapter will accept.
> +        * of simultaneous commands a single hw queue in HBA will accept.
>          */
>         int can_queue;
>
> @@ -551,7 +551,6 @@ struct Scsi_Host {
>         /* Area to keep a shared tag map */
>         struct blk_mq_tag_set   tag_set;
>
> -       atomic_t host_busy;                /* commands actually active on low-level */
>         atomic_t host_blocked;
>
>         unsigned int host_failed;          /* commands that failed.
> --
> 2.20.1
>

Ping...

Thanks,
Ming Lei
