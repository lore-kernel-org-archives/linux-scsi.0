Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1F6C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 11:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C27364E32
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 11:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBJLLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 06:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhBJLJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 06:09:01 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D514C0613D6
        for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2021 03:08:21 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id u20so1187792qku.7
        for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2021 03:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fRVN7euUZ/Jf1VRBsVZHcgST9crWFa4Ythwnk6uC+Bk=;
        b=X7hgzDhrx4jBj01JZjrRleknlAM97hpGbs0BhH11GR3/YQb1B7xrpG5WdSoCkZWEBY
         /LLE3keOo0o5wtl6fp/2kEtc5Cpjft9ShYLIrmGOwXKimeOdiF1j7B2hciDDlGx/RIAb
         7/qkgJZ5HFtudSJ35pq/Hcme3Ot3Vj77Fgsi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fRVN7euUZ/Jf1VRBsVZHcgST9crWFa4Ythwnk6uC+Bk=;
        b=Pt4xzM0oR5x8QVnfPTUHNmgwhYpBPBAeDi+z/e9Nf0NRhfPSYpDfuip39aBR8B8BCM
         +XISFHaAgdfX8/3QcTdx0kloilbxwI/f6fSatcdBxGpeqokb9PeGcZ3J2EKKIlJa11gY
         uDKY3kx+rO6rW2zkgXLYa2+cLiM4g2fiASHLSyTrGgARXzh1Z2Q6h5mGYDNgB1IPRTIn
         i7ajrrMPSlooCwWdjE8uiJWvSvpyUGWT6TXO/d7b107g0CbSJGmnnKYKA1/HhY1lkBWj
         mLU/k8kwdWjBirDwlZwY5A8O6sgU8ycFhi/Mmv3lSrUul506wx9gHMvlApoqE654F9wE
         9LvQ==
X-Gm-Message-State: AOAM533DOw/wGM81VMOcIg0dStdN/pX28O9xV0LEVWaHHXTymM63vnVH
        iX5PNb9orSqHE9LeCqJ99fpoG6gbO0wMdTvzjWGqwA==
X-Google-Smtp-Source: ABdhPJy3LHSYd9A+skyID1Ck/PEBQJIekKLxRB2c7BqfaUrk6/vLaja1yOmsnNcrz9/tiOcPd8SejXiyEXHwqx+j79o=
X-Received: by 2002:a37:aa96:: with SMTP id t144mr2772007qke.127.1612955300154;
 Wed, 10 Feb 2021 03:08:20 -0800 (PST)
MIME-Version: 1.0
References: <20210209225624.108341-1-dgilbert@interlog.com>
In-Reply-To: <20210209225624.108341-1-dgilbert@interlog.com>
From:   Kashyap Desai <kashyap.desai@broadcom.com>
Date:   Wed, 10 Feb 2021 08:38:39 +0530
Message-ID: <CAHsXFKEhiwHmMmJ00eeA1ikP3wdiJP2xggsuO0Qc9H1ogNXnVQ@mail.gmail.com>
Subject: Re: [PATCH v3] scsi_debug: add new defer_type for mq_poll
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bb926505baf96b2a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000bb926505baf96b2a
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 10, 2021 at 4:26 AM Douglas Gilbert <dgilbert@interlog.com> wrote:
>
> Add a new sdeb_defer_type enumeration: SDEB_DEFER_POLL for requests
> that have REQ_HIPRI set in cmd_flags field. It is expected that
> these requests will be polled via the mq_poll entry point which
> is driven by calls to blk_poll() in the block layer. Therefore
> timer events are not 'wired up' in the normal fashion.
>
> There are still cases with short delays (e.g. < 10 microseconds)
> where by the time the command response processing occurs, the delay
> is already exceeded in which case the code calls scsi_done()
> directly. In such cases there is no window for mq_poll() to be
> called.
>
> Add 'mq_polls' counter that increments on each scsi_done() called
> via the mq_poll entry point. Can be used to show (with 'cat
> /proc/scsi/scsi_debug/<host_id>') that blk_poll() is causing
> completions rather than some other mechanism.
>
>
> This patch is against the 5.12/scsi-staging branch which includes
>    a98d6bdf181eb71bf4686666eaf47c642a061642
>    scsi_debug : iouring iopoll support
> which it alters. So this patch is a fix of that patch.
>
> Changes since version 2 [sent 20210206 to linux-scsi list]
>   - the sdebug_blk_mq_poll() callback didn't cope with the
>     uncommon case where sqcp->sd_dp is NULL. Fix.

Hi Doug, I tried this patch on top of below iouring patch series -
"[v3,1/4] add io_uring with IOPOLL support in scsi layer"

After applying patch, I am seeing an IO hang issue - I see
io_wqe_worker goes into a tight loop.

18210 root      20   0 1316348   3552   2376 R  99.1   0.0   0:24.09
fio                                       18303 root      20   0
0      0      0 D  78.8   0.0   0:01.75 io_wqe_worker-0
           18219 root      20   0       0      0      0 R  71.7   0.0
 0:06.59 io_wqe_worker-0


I used below command -
insmod drivers/scsi/scsi_debug.ko dev_size_mb=1024 sector_size=512
add_host=24 per_host_store=1 ndelay=10000 host_max_queue=32
submit_queues=76 num_parts=1 poll_queues=8

and here is my fio script -
[global]
ioengine=io_uring
hipri=1
direct=1
runtime=30s
rw=randread
norandommap
bs=4k
iodepth=64

[seqprecon]
filename=/dev/sdd
[seqprecon]
filename=/dev/sde
[seqprecon]
filename=/dev/sdf


I will ask Martin to pick all the patches from "[v3,1/4] add io_uring
with IOPOLL support in the scsi layer" except scsi_debug. We can work
on scsi_debug and send standalone patch.

Kashyap




>
> Changes since version 1 [sent 20210201 to linux-scsi list]
>   - harden SDEB_DEFER_POLL which broke under testing
>   - add mq_polls counter for debug output
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 141 +++++++++++++++++++++++++-------------
>  1 file changed, 94 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 746eec521f79..b9ec3a47fbf1 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -322,17 +322,19 @@ struct sdeb_store_info {
>         container_of(d, struct sdebug_host_info, dev)
>
>  enum sdeb_defer_type {SDEB_DEFER_NONE = 0, SDEB_DEFER_HRT = 1,
> -                     SDEB_DEFER_WQ = 2};
> +                     SDEB_DEFER_WQ = 2, SDEB_DEFER_POLL = 3};
>
>  struct sdebug_defer {
>         struct hrtimer hrt;
>         struct execute_work ew;
> +       ktime_t cmpl_ts;/* time since boot to complete this cmd */
>         int sqa_idx;    /* index of sdebug_queue array */
>         int qc_idx;     /* index of sdebug_queued_cmd array within sqa_idx */
>         int hc_idx;     /* hostwide tag index */
>         int issuing_cpu;
>         bool init_hrt;
>         bool init_wq;
> +       bool init_poll;
>         bool aborted;   /* true when blk_abort_request() already called */
>         enum sdeb_defer_type defer_t;
>  };
> @@ -357,6 +359,7 @@ static atomic_t sdebug_completions;  /* count of deferred completions */
>  static atomic_t sdebug_miss_cpus;    /* submission + completion cpus differ */
>  static atomic_t sdebug_a_tsf;       /* 'almost task set full' counter */
>  static atomic_t sdeb_inject_pending;
> +static atomic_t sdeb_mq_poll_count;  /* bumped when mq_poll returns > 0 */
>
>  struct opcode_info_t {
>         u8 num_attached;        /* 0 if this is it (i.e. a leaf); use 0xff */
> @@ -4730,7 +4733,6 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
>         struct scsi_cmnd *scp;
>         struct sdebug_dev_info *devip;
>
> -       sd_dp->defer_t = SDEB_DEFER_NONE;
>         if (unlikely(aborted))
>                 sd_dp->aborted = false;
>         qc_idx = sd_dp->qc_idx;
> @@ -4745,6 +4747,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
>                 return;
>         }
>         spin_lock_irqsave(&sqp->qc_lock, iflags);
> +       sd_dp->defer_t = SDEB_DEFER_NONE;
>         sqcp = &sqp->qc_arr[qc_idx];
>         scp = sqcp->a_cmnd;
>         if (unlikely(scp == NULL)) {
> @@ -5517,40 +5520,66 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>                                 kt -= d;
>                         }
>                 }
> -               if (!sd_dp->init_hrt) {
> -                       sd_dp->init_hrt = true;
> -                       sqcp->sd_dp = sd_dp;
> -                       hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
> -                                    HRTIMER_MODE_REL_PINNED);
> -                       sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
> -                       sd_dp->sqa_idx = sqp - sdebug_q_arr;
> -                       sd_dp->qc_idx = k;
> +               sd_dp->cmpl_ts = ktime_add(ns_to_ktime(ns_from_boot), kt);
> +               if (cmnd->request->cmd_flags & REQ_HIPRI) {
> +                       spin_lock_irqsave(&sqp->qc_lock, iflags);
> +                       if (!sd_dp->init_poll) {
> +                               sd_dp->init_poll = true;
> +                               sqcp->sd_dp = sd_dp;
> +                               sd_dp->sqa_idx = sqp - sdebug_q_arr;
> +                               sd_dp->qc_idx = k;
> +                       }
> +                       sd_dp->defer_t = SDEB_DEFER_POLL;
> +                       spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +               } else {
> +                       if (!sd_dp->init_hrt) {
> +                               sd_dp->init_hrt = true;
> +                               sqcp->sd_dp = sd_dp;
> +                               hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
> +                                            HRTIMER_MODE_REL_PINNED);
> +                               sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
> +                               sd_dp->sqa_idx = sqp - sdebug_q_arr;
> +                               sd_dp->qc_idx = k;
> +                       }
> +                       sd_dp->defer_t = SDEB_DEFER_HRT;
> +                       /* schedule the invocation of scsi_done() for a later time */
> +                       hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
>                 }
>                 if (sdebug_statistics)
>                         sd_dp->issuing_cpu = raw_smp_processor_id();
> -               sd_dp->defer_t = SDEB_DEFER_HRT;
> -               /* schedule the invocation of scsi_done() for a later time */
> -               hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
>         } else {        /* jdelay < 0, use work queue */
> -               if (!sd_dp->init_wq) {
> -                       sd_dp->init_wq = true;
> -                       sqcp->sd_dp = sd_dp;
> -                       sd_dp->sqa_idx = sqp - sdebug_q_arr;
> -                       sd_dp->qc_idx = k;
> -                       INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
> -               }
> -               if (sdebug_statistics)
> -                       sd_dp->issuing_cpu = raw_smp_processor_id();
> -               sd_dp->defer_t = SDEB_DEFER_WQ;
>                 if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
>                              atomic_read(&sdeb_inject_pending)))
>                         sd_dp->aborted = true;
> -               schedule_work(&sd_dp->ew.work);
> -               if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
> -                            atomic_read(&sdeb_inject_pending))) {
> +               sd_dp->cmpl_ts = ns_to_ktime(ns_from_boot);
> +               if (cmnd->request->cmd_flags & REQ_HIPRI) {
> +                       spin_lock_irqsave(&sqp->qc_lock, iflags);
> +                       if (!sd_dp->init_poll) {
> +                               sd_dp->init_poll = true;
> +                               sqcp->sd_dp = sd_dp;
> +                               sd_dp->sqa_idx = sqp - sdebug_q_arr;
> +                               sd_dp->qc_idx = k;
> +                       }
> +                       sd_dp->defer_t = SDEB_DEFER_POLL;
> +                       spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +               } else {
> +                       if (!sd_dp->init_wq) {
> +                               sd_dp->init_wq = true;
> +                               sqcp->sd_dp = sd_dp;
> +                               sd_dp->sqa_idx = sqp - sdebug_q_arr;
> +                               sd_dp->qc_idx = k;
> +                               INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
> +                       }
> +                       sd_dp->defer_t = SDEB_DEFER_WQ;
> +                       schedule_work(&sd_dp->ew.work);
> +               }
> +               if (sdebug_statistics)
> +                       sd_dp->issuing_cpu = raw_smp_processor_id();
> +               if (unlikely(sd_dp->aborted)) {
>                         sdev_printk(KERN_INFO, sdp, "abort request tag %d\n", cmnd->request->tag);
>                         blk_abort_request(cmnd->request);
>                         atomic_set(&sdeb_inject_pending, 0);
> +                       sd_dp->aborted = false;
>                 }
>         }
>         if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) && scsi_result == device_qfull_result))
> @@ -5779,11 +5808,12 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
>                    dix_reads, dix_writes, dif_errors);
>         seq_printf(m, "usec_in_jiffy=%lu, statistics=%d\n", TICK_NSEC / 1000,
>                    sdebug_statistics);
> -       seq_printf(m, "cmnd_count=%d, completions=%d, %s=%d, a_tsf=%d\n",
> +       seq_printf(m, "cmnd_count=%d, completions=%d, %s=%d, a_tsf=%d, mq_polls=%d\n",
>                    atomic_read(&sdebug_cmnd_count),
>                    atomic_read(&sdebug_completions),
>                    "miss_cpus", atomic_read(&sdebug_miss_cpus),
> -                  atomic_read(&sdebug_a_tsf));
> +                  atomic_read(&sdebug_a_tsf),
> +                  atomic_read(&sdeb_mq_poll_count));
>
>         seq_printf(m, "submit_queues=%d\n", submit_queues);
>         for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
> @@ -7246,52 +7276,68 @@ static int sdebug_map_queues(struct Scsi_Host *shost)
>
>  static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>  {
> -       int qc_idx;
> -       int retiring = 0;
> +       bool first;
> +       bool retiring = false;
> +       int num_entries = 0;
> +       unsigned int qc_idx = 0;
>         unsigned long iflags;
> +       ktime_t kt_from_boot = ktime_get_boottime();
>         struct sdebug_queue *sqp;
>         struct sdebug_queued_cmd *sqcp;
>         struct scsi_cmnd *scp;
>         struct sdebug_dev_info *devip;
> -       int num_entries = 0;
> +       struct sdebug_defer *sd_dp;
>
>         sqp = sdebug_q_arr + queue_num;
> +       spin_lock_irqsave(&sqp->qc_lock, iflags);
>
> -       do {
> -               spin_lock_irqsave(&sqp->qc_lock, iflags);
> -               qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
> -               if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
> -                       goto out;
> +       for (first = true; first || qc_idx + 1 < sdebug_max_queue; )   {
> +               if (first) {
> +                       qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
> +                       first = false;
> +               } else {
> +                       qc_idx = find_next_bit(sqp->in_use_bm, sdebug_max_queue, qc_idx + 1);
> +               }
> +               if (unlikely(qc_idx >= sdebug_max_queue))
> +                       break;
>
>                 sqcp = &sqp->qc_arr[qc_idx];
> +               sd_dp = sqcp->sd_dp;
> +               if (unlikely(!sd_dp))
> +                       continue;
>                 scp = sqcp->a_cmnd;
>                 if (unlikely(scp == NULL)) {
> -                       pr_err("scp is NULL, queue_num=%d, qc_idx=%d from %s\n",
> +                       pr_err("scp is NULL, queue_num=%d, qc_idx=%u from %s\n",
>                                queue_num, qc_idx, __func__);
> -                       goto out;
> +                       break;
>                 }
> +               if (sd_dp->defer_t == SDEB_DEFER_POLL) {
> +                       if (kt_from_boot < sd_dp->cmpl_ts)
> +                               continue;
> +
> +               } else          /* ignoring non REQ_HIPRI requests */
> +                       continue;
>                 devip = (struct sdebug_dev_info *)scp->device->hostdata;
>                 if (likely(devip))
>                         atomic_dec(&devip->num_in_q);
>                 else
>                         pr_err("devip=NULL from %s\n", __func__);
>                 if (unlikely(atomic_read(&retired_max_queue) > 0))
> -                       retiring = 1;
> +                       retiring = true;
>
>                 sqcp->a_cmnd = NULL;
>                 if (unlikely(!test_and_clear_bit(qc_idx, sqp->in_use_bm))) {
> -                       pr_err("Unexpected completion sqp %p queue_num=%d qc_idx=%d from %s\n",
> +                       pr_err("Unexpected completion sqp %p queue_num=%d qc_idx=%u from %s\n",
>                                 sqp, queue_num, qc_idx, __func__);
> -                       goto out;
> +                       break;
>                 }
> -
>                 if (unlikely(retiring)) {       /* user has reduced max_queue */
>                         int k, retval;
>
>                         retval = atomic_read(&retired_max_queue);
>                         if (qc_idx >= retval) {
>                                 pr_err("index %d too large\n", retval);
> -                               goto out;
> +                               break;
>                         }
>                         k = find_last_bit(sqp->in_use_bm, retval);
>                         if ((k < sdebug_max_queue) || (k == retval))
> @@ -7299,17 +7345,18 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>                         else
>                                 atomic_set(&retired_max_queue, k + 1);
>                 }
> +               sd_dp->defer_t = SDEB_DEFER_NONE;
>                 spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>                 scp->scsi_done(scp); /* callback to mid level */
> +               spin_lock_irqsave(&sqp->qc_lock, iflags);
>                 num_entries++;
> -       } while (1);
> -
> -out:
> +       }
>         spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +       if (num_entries > 0)
> +               atomic_add(num_entries, &sdeb_mq_poll_count);
>         return num_entries;
>  }
>
> -
>  static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>                                    struct scsi_cmnd *scp)
>  {
> --
> 2.25.1
>

--000000000000bb926505baf96b2a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQRQYJKoZIhvcNAQcCoIIQNjCCEDICAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2aMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFRzCCBC+gAwIBAgIMNJ2hfsaqieGgTtOzMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE0MTE0
NTE2WhcNMjIwOTE1MTE0NTE2WjCBkDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRYwFAYDVQQDEw1LYXNo
eWFwIERlc2FpMSkwJwYJKoZIhvcNAQkBFhprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALcJrXmVmbWEd4eX2uEKGBI6v43LPHKbbncKqMGH
Dez52MTfr4QkOZYWM4Rqv8j6vb8LPlUc9k0CEnC9Yaj9ZzDOcR+gHfoZ3F1JXSVRWdguz25MiB6a
bU8odXAymhaig9sNJLxiWid3RORmG/w1Nceflo/72Cwttt0ytDTKdF987/aVGqMIxg3NnXM/cn+T
0wUiccp8WINUie4nuR9pzv5RKGqAzNYyo8krQ2URk+3fGm1cPRoFEVAkwrCs/FOs6LfggC2CC4LB
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgLdztnvmV
KzQTWUukmqGrACOGYJfawBFniymFZh81IRUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjEwMTEwODIwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJi9rq+s4sRa9H0NmghmGAMsGU8i
qeVCBw8QCK+AXIgSvTvEMGrdwJzUgUzoRYj4h6blKyUSZFMH8PaIttRXvIPnQSjB3ZDst34e4JkA
X5JneLxFI0rlLUmTReR+gJ7fB9eZacRSS6FsHbncg1B7dLqeyW96rK6YPufkA3q4bP7qrBRsRS1N
KG/Emr/D87oJcF3PEVcrw7/vpqawNFixvK4DEP+LK5NpZfSr7XwW6qi7navLkQIoPuqbZ6pKIkx0
rb133Q+7ZaRKLy2rrmc/BAlVXIrTY6eg2Fu4OZDAX0w+3Vkrp2uoiTrE2TchOx4dbSmX2EVNh+Yt
w26qaQTiBzg=
--000000000000bb926505baf96b2a--
