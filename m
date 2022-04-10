Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA47C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 13:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239303AbiDJNSK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 09:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239272AbiDJNSJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 09:18:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B080D289B2
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 06:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649596555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wnrVly64j/Xx7KmxFeDKah9xOMlzmMm+oTy0AqUmLD4=;
        b=RQ33jl3y8rvK4Re5nBv10fTKVHKLiVJaI+dnVwCyHgnwyj4SDK7tGq0U/spSD9AXSPSDHb
        mCk9zbdr+S20sWfdQpke2wvR0buEpwrvY+2fowJ2iRYudapj8o/mo/Hw3NeDIITsgdwvny
        nA9qzrpRleDVX8fO/USbClGH2Z2Zf3I=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-QWwnOCWiMnaQ4LgHxvvKiQ-1; Sun, 10 Apr 2022 09:15:54 -0400
X-MC-Unique: QWwnOCWiMnaQ4LgHxvvKiQ-1
Received: by mail-pj1-f71.google.com with SMTP id r15-20020a17090a4dcf00b001cb7ea0b0bdso1239256pjl.1
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 06:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wnrVly64j/Xx7KmxFeDKah9xOMlzmMm+oTy0AqUmLD4=;
        b=Cl/dJ2/Q5DHtoo5NcsD1O5M/dFDncz1nflcy7BfdoGy3nFvpApprOudHlu2gGEil89
         v72wdubkEH8gtSA8TM4XyBhjO5aG6NrLqa6v/wBo9zmakOu9gkAp640cBFl2oC9khGOM
         M6XEVmtBJ50B4A/AI2rY+I04pb2WWbsewT+xdGSgmbUpSrbc2YflngUcuXU5m0wwUIwN
         qY8aFhWJcWT4ZxcPvA1zasfEUnxm5Z/UZeMGqJlkVmP+10XNrnoJ8rWEca24SVNQUM+d
         suPxAYlC3KvOUbMQKGpsGD5G9AKhGxQrDqjOFg5nUIQ/OA2THNX17ckn2mLRNFeqoJ/j
         PmmA==
X-Gm-Message-State: AOAM5325A9ICewO7dmc9/2wIqvsjrLMUzCvkJm4fZHTbLwVZOjCPuagh
        kHWDBPRdq+noV2U0jWnPjZodZ8SEWis62+ZIo7NNOCew2H+EzOAtTva/7qbLpIk0kZhiFh5TCfW
        //t5RL6QW+3DtCWJ2IxhC1g4tWtcPZcNBArt7Iw==
X-Received: by 2002:a17:902:da86:b0:154:522b:342d with SMTP id j6-20020a170902da8600b00154522b342dmr28116299plx.46.1649596552675;
        Sun, 10 Apr 2022 06:15:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqzw2WXluLRad8W6iKjxmX7QvkmNxWv4YnOIaw1AonYL/PTl5vorQJ8Vy0qNLR3vsXkHedCC+kA4SVp+bLsRk=
X-Received: by 2002:a17:902:da86:b0:154:522b:342d with SMTP id
 j6-20020a170902da8600b00154522b342dmr28116277plx.46.1649596552369; Sun, 10
 Apr 2022 06:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220409043704.28573-1-bvanassche@acm.org>
In-Reply-To: <20220409043704.28573-1-bvanassche@acm.org>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Sun, 10 Apr 2022 21:15:40 +0800
Message-ID: <CAHj4cs8CRK==3+ssCSLWrC-1-jtp+=QAoaopN97GgFs5bWcbow@mail.gmail.com>
Subject: Re: [PATCH] Revert "scsi: scsi_debug: Address races following module load"
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Confirmed the blktests srp/ issue was fixed with this revert:

Tested-by: Yi Zhang <yi.zhang@redhat.com>

On Sat, Apr 9, 2022 at 12:37 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Revert the patch mentioned in the subject since it blocks I/O after
> module unload has started while this is a legitimate use case. For e.g.
> blktests test case srp/001 that patch causes a command timeout to be
> triggered for the following call stack:
>
> __schedule+0x4c3/0xd20
> schedule+0x82/0x110
> schedule_timeout+0x122/0x200
> io_schedule_timeout+0x7b/0xc0
> __wait_for_common+0x2bc/0x380
> wait_for_completion_io_timeout+0x1d/0x20
> blk_execute_rq+0x1db/0x200
> __scsi_execute+0x1fb/0x310
> sd_sync_cache+0x155/0x2c0 [sd_mod]
> sd_shutdown+0xbb/0x190 [sd_mod]
> sd_remove+0x5b/0x80 [sd_mod]
> device_remove+0x9a/0xb0
> device_release_driver_internal+0x2c5/0x360
> device_release_driver+0x12/0x20
> bus_remove_device+0x1aa/0x270
> device_del+0x2d4/0x640
> __scsi_remove_device+0x168/0x1a0
> scsi_forget_host+0xa8/0xb0
> scsi_remove_host+0x9b/0x150
> sdebug_driver_remove+0x3d/0x140 [scsi_debug]
> device_remove+0x6f/0xb0
> device_release_driver_internal+0x2c5/0x360
> device_release_driver+0x12/0x20
> bus_remove_device+0x1aa/0x270
> device_del+0x2d4/0x640
> device_unregister+0x18/0x70
> sdebug_do_remove_host+0x138/0x180 [scsi_debug]
> scsi_debug_exit+0x45/0xd5 [scsi_debug]
> __do_sys_delete_module.constprop.0+0x210/0x320
> __x64_sys_delete_module+0x1f/0x30
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Yi Zhang <yi.zhang@redhat.com>
> Cc: Bob Pearson <rpearsonhpe@gmail.com>
> Fixes: 2aad3cd85370 ("scsi: scsi_debug: Address races following module load"; )
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_debug.c | 197 ++++++++++----------------------------
>  1 file changed, 51 insertions(+), 146 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c607755cce00..db6f4b96606c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -32,7 +32,6 @@
>  #include <linux/blkdev.h>
>  #include <linux/crc-t10dif.h>
>  #include <linux/spinlock.h>
> -#include <linux/mutex.h>
>  #include <linux/interrupt.h>
>  #include <linux/atomic.h>
>  #include <linux/hrtimer.h>
> @@ -732,9 +731,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>             {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>  };
>
> -static atomic_t sdebug_num_hosts;
> -static DEFINE_MUTEX(add_host_mutex);
> -
> +static int sdebug_num_hosts;
>  static int sdebug_add_host = DEF_NUM_HOST;  /* in sysfs this is relative */
>  static int sdebug_ato = DEF_ATO;
>  static int sdebug_cdb_len = DEF_CDB_LEN;
> @@ -781,7 +778,6 @@ static int sdebug_uuid_ctl = DEF_UUID_CTL;
>  static bool sdebug_random = DEF_RANDOM;
>  static bool sdebug_per_host_store = DEF_PER_HOST_STORE;
>  static bool sdebug_removable = DEF_REMOVABLE;
> -static bool sdebug_deflect_incoming;
>  static bool sdebug_clustering;
>  static bool sdebug_host_lock = DEF_HOST_LOCK;
>  static bool sdebug_strict = DEF_STRICT;
> @@ -5122,10 +5118,6 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
>                        sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
>         if (sdp->host->max_cmd_len != SDEBUG_MAX_CMD_LEN)
>                 sdp->host->max_cmd_len = SDEBUG_MAX_CMD_LEN;
> -       if (smp_load_acquire(&sdebug_deflect_incoming)) {
> -               pr_info("Exit early due to deflect_incoming\n");
> -               return 1;
> -       }
>         if (devip == NULL) {
>                 devip = find_build_dev_info(sdp);
>                 if (devip == NULL)
> @@ -5211,7 +5203,7 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
>  }
>
>  /* Deletes (stops) timers or work queues of all queued commands */
> -static void stop_all_queued(bool done_with_no_conn)
> +static void stop_all_queued(void)
>  {
>         unsigned long iflags;
>         int j, k;
> @@ -5220,15 +5212,13 @@ static void stop_all_queued(bool done_with_no_conn)
>         struct sdebug_queued_cmd *sqcp;
>         struct sdebug_dev_info *devip;
>         struct sdebug_defer *sd_dp;
> -       struct scsi_cmnd *scp;
>
>         for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
>                 spin_lock_irqsave(&sqp->qc_lock, iflags);
>                 for (k = 0; k < SDEBUG_CANQUEUE; ++k) {
>                         if (test_bit(k, sqp->in_use_bm)) {
>                                 sqcp = &sqp->qc_arr[k];
> -                               scp = sqcp->a_cmnd;
> -                               if (!scp)
> +                               if (sqcp->a_cmnd == NULL)
>                                         continue;
>                                 devip = (struct sdebug_dev_info *)
>                                         sqcp->a_cmnd->device->hostdata;
> @@ -5243,10 +5233,6 @@ static void stop_all_queued(bool done_with_no_conn)
>                                         l_defer_t = SDEB_DEFER_NONE;
>                                 spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>                                 stop_qc_helper(sd_dp, l_defer_t);
> -                               if (done_with_no_conn && l_defer_t != SDEB_DEFER_NONE) {
> -                                       scp->result = DID_NO_CONNECT << 16;
> -                                       scsi_done(scp);
> -                               }
>                                 clear_bit(k, sqp->in_use_bm);
>                                 spin_lock_irqsave(&sqp->qc_lock, iflags);
>                         }
> @@ -5389,7 +5375,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>                 }
>         }
>         spin_unlock(&sdebug_host_list_lock);
> -       stop_all_queued(false);
> +       stop_all_queued();
>         if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
>                 sdev_printk(KERN_INFO, SCpnt->device,
>                             "%s: %d device(s) found\n", __func__, k);
> @@ -5449,50 +5435,13 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
>         }
>  }
>
> -static void sdeb_block_all_queues(void)
> -{
> -       int j;
> -       struct sdebug_queue *sqp;
> -
> -       for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp)
> -               atomic_set(&sqp->blocked, (int)true);
> -}
> -
> -static void sdeb_unblock_all_queues(void)
> +static void block_unblock_all_queues(bool block)
>  {
>         int j;
>         struct sdebug_queue *sqp;
>
>         for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp)
> -               atomic_set(&sqp->blocked, (int)false);
> -}
> -
> -static void
> -sdeb_add_n_hosts(int num_hosts)
> -{
> -       if (num_hosts < 1)
> -               return;
> -       do {
> -               bool found;
> -               unsigned long idx;
> -               struct sdeb_store_info *sip;
> -               bool want_phs = (sdebug_fake_rw == 0) && sdebug_per_host_store;
> -
> -               found = false;
> -               if (want_phs) {
> -                       xa_for_each_marked(per_store_ap, idx, sip, SDEB_XA_NOT_IN_USE) {
> -                               sdeb_most_recent_idx = (int)idx;
> -                               found = true;
> -                               break;
> -                       }
> -                       if (found)      /* re-use case */
> -                               sdebug_add_host_helper((int)idx);
> -                       else
> -                               sdebug_do_add_host(true /* make new store */);
> -               } else {
> -                       sdebug_do_add_host(false);
> -               }
> -       } while (--num_hosts);
> +               atomic_set(&sqp->blocked, (int)block);
>  }
>
>  /* Adjust (by rounding down) the sdebug_cmnd_count so abs(every_nth)-1
> @@ -5505,10 +5454,10 @@ static void tweak_cmnd_count(void)
>         modulo = abs(sdebug_every_nth);
>         if (modulo < 2)
>                 return;
> -       sdeb_block_all_queues();
> +       block_unblock_all_queues(true);
>         count = atomic_read(&sdebug_cmnd_count);
>         atomic_set(&sdebug_cmnd_count, (count / modulo) * modulo);
> -       sdeb_unblock_all_queues();
> +       block_unblock_all_queues(false);
>  }
>
>  static void clear_queue_stats(void)
> @@ -5526,15 +5475,6 @@ static bool inject_on_this_cmd(void)
>         return (atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) == 0;
>  }
>
> -static int process_deflect_incoming(struct scsi_cmnd *scp)
> -{
> -       u8 opcode = scp->cmnd[0];
> -
> -       if (opcode == SYNCHRONIZE_CACHE || opcode == SYNCHRONIZE_CACHE_16)
> -               return 0;
> -       return DID_NO_CONNECT << 16;
> -}
> -
>  #define INCLUSIVE_TIMING_MAX_NS 1000000                /* 1 millisecond */
>
>  /* Complete the processing of the thread that queued a SCSI command to this
> @@ -5544,7 +5484,8 @@ static int process_deflect_incoming(struct scsi_cmnd *scp)
>   */
>  static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>                          int scsi_result,
> -                        int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *),
> +                        int (*pfp)(struct scsi_cmnd *,
> +                                   struct sdebug_dev_info *),
>                          int delta_jiff, int ndelay)
>  {
>         bool new_sd_dp;
> @@ -5565,27 +5506,13 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>         }
>         sdp = cmnd->device;
>
> -       if (delta_jiff == 0) {
> -               sqp = get_queue(cmnd);
> -               if (atomic_read(&sqp->blocked)) {
> -                       if (smp_load_acquire(&sdebug_deflect_incoming))
> -                               return process_deflect_incoming(cmnd);
> -                       else
> -                               return SCSI_MLQUEUE_HOST_BUSY;
> -               }
> +       if (delta_jiff == 0)
>                 goto respond_in_thread;
> -       }
>
>         sqp = get_queue(cmnd);
>         spin_lock_irqsave(&sqp->qc_lock, iflags);
>         if (unlikely(atomic_read(&sqp->blocked))) {
>                 spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> -               if (smp_load_acquire(&sdebug_deflect_incoming)) {
> -                       scsi_result = process_deflect_incoming(cmnd);
> -                       goto respond_in_thread;
> -               }
> -               if (sdebug_verbose)
> -                       pr_info("blocked --> SCSI_MLQUEUE_HOST_BUSY\n");
>                 return SCSI_MLQUEUE_HOST_BUSY;
>         }
>         num_in_q = atomic_read(&devip->num_in_q);
> @@ -5774,12 +5701,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>  respond_in_thread:     /* call back to mid-layer using invocation thread */
>         cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
>         cmnd->result &= ~SDEG_RES_IMMED_MASK;
> -       if (cmnd->result == 0 && scsi_result != 0) {
> +       if (cmnd->result == 0 && scsi_result != 0)
>                 cmnd->result = scsi_result;
> -               if (sdebug_verbose)
> -                       pr_info("respond_in_thread: tag=0x%x, scp->result=0x%x\n",
> -                               blk_mq_unique_tag(scsi_cmd_to_rq(cmnd)), scsi_result);
> -       }
>         scsi_done(cmnd);
>         return 0;
>  }
> @@ -6064,7 +5987,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
>                         int j, k;
>                         struct sdebug_queue *sqp;
>
> -                       sdeb_block_all_queues();
> +                       block_unblock_all_queues(true);
>                         for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
>                              ++j, ++sqp) {
>                                 k = find_first_bit(sqp->in_use_bm,
> @@ -6078,7 +6001,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
>                                 sdebug_jdelay = jdelay;
>                                 sdebug_ndelay = 0;
>                         }
> -                       sdeb_unblock_all_queues();
> +                       block_unblock_all_queues(false);
>                 }
>                 return res;
>         }
> @@ -6104,7 +6027,7 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
>                         int j, k;
>                         struct sdebug_queue *sqp;
>
> -                       sdeb_block_all_queues();
> +                       block_unblock_all_queues(true);
>                         for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
>                              ++j, ++sqp) {
>                                 k = find_first_bit(sqp->in_use_bm,
> @@ -6119,7 +6042,7 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
>                                 sdebug_jdelay = ndelay  ? JDELAY_OVERRIDDEN
>                                                         : DEF_JDELAY;
>                         }
> -                       sdeb_unblock_all_queues();
> +                       block_unblock_all_queues(false);
>                 }
>                 return res;
>         }
> @@ -6433,7 +6356,7 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
>         if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
>             (n <= SDEBUG_CANQUEUE) &&
>             (sdebug_host_max_queue == 0)) {
> -               sdeb_block_all_queues();
> +               block_unblock_all_queues(true);
>                 k = 0;
>                 for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
>                      ++j, ++sqp) {
> @@ -6448,7 +6371,7 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
>                         atomic_set(&retired_max_queue, k + 1);
>                 else
>                         atomic_set(&retired_max_queue, 0);
> -               sdeb_unblock_all_queues();
> +               block_unblock_all_queues(false);
>                 return count;
>         }
>         return -EINVAL;
> @@ -6537,48 +6460,43 @@ static DRIVER_ATTR_RW(virtual_gb);
>  static ssize_t add_host_show(struct device_driver *ddp, char *buf)
>  {
>         /* absolute number of hosts currently active is what is shown */
> -       return scnprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&sdebug_num_hosts));
> +       return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_num_hosts);
>  }
>
> -/*
> - * Accept positive and negative values. Hex values (only positive) may be prefixed by '0x'.
> - * To remove all hosts use a large negative number (e.g. -9999). The value 0 does nothing.
> - * Returns -EBUSY if another add_host sysfs invocation is active.
> - */
>  static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
>                               size_t count)
>  {
> +       bool found;
> +       unsigned long idx;
> +       struct sdeb_store_info *sip;
> +       bool want_phs = (sdebug_fake_rw == 0) && sdebug_per_host_store;
>         int delta_hosts;
>
> -       if (count == 0 || kstrtoint(buf, 0, &delta_hosts))
> +       if (sscanf(buf, "%d", &delta_hosts) != 1)
>                 return -EINVAL;
> -       if (sdebug_verbose)
> -               pr_info("prior num_hosts=%d, num_to_add=%d\n",
> -                       atomic_read(&sdebug_num_hosts), delta_hosts);
> -       if (delta_hosts == 0)
> -               return count;
> -       if (mutex_trylock(&add_host_mutex) == 0)
> -               return -EBUSY;
>         if (delta_hosts > 0) {
> -               sdeb_add_n_hosts(delta_hosts);
> -       } else if (delta_hosts < 0) {
> -               smp_store_release(&sdebug_deflect_incoming, true);
> -               sdeb_block_all_queues();
> -               if (delta_hosts >= atomic_read(&sdebug_num_hosts))
> -                       stop_all_queued(true);
>                 do {
> -                       if (atomic_read(&sdebug_num_hosts) < 1) {
> -                               free_all_queued();
> -                               break;
> +                       found = false;
> +                       if (want_phs) {
> +                               xa_for_each_marked(per_store_ap, idx, sip,
> +                                                  SDEB_XA_NOT_IN_USE) {
> +                                       sdeb_most_recent_idx = (int)idx;
> +                                       found = true;
> +                                       break;
> +                               }
> +                               if (found)      /* re-use case */
> +                                       sdebug_add_host_helper((int)idx);
> +                               else
> +                                       sdebug_do_add_host(true);
> +                       } else {
> +                               sdebug_do_add_host(false);
>                         }
> +               } while (--delta_hosts);
> +       } else if (delta_hosts < 0) {
> +               do {
>                         sdebug_do_remove_host(false);
>                 } while (++delta_hosts);
> -               sdeb_unblock_all_queues();
> -               smp_store_release(&sdebug_deflect_incoming, false);
>         }
> -       mutex_unlock(&add_host_mutex);
> -       if (sdebug_verbose)
> -               pr_info("post num_hosts=%d\n", atomic_read(&sdebug_num_hosts));
>         return count;
>  }
>  static DRIVER_ATTR_RW(add_host);
> @@ -7089,10 +7007,6 @@ static int __init scsi_debug_init(void)
>         sdebug_add_host = 0;
>
>         for (k = 0; k < hosts_to_add; k++) {
> -               if (smp_load_acquire(&sdebug_deflect_incoming)) {
> -                       pr_info("exit early as sdebug_deflect_incoming is set\n");
> -                       return 0;
> -               }
>                 if (want_store && k == 0) {
>                         ret = sdebug_add_host_helper(idx);
>                         if (ret < 0) {
> @@ -7110,12 +7024,8 @@ static int __init scsi_debug_init(void)
>                 }
>         }
>         if (sdebug_verbose)
> -               pr_info("built %d host(s)\n", atomic_read(&sdebug_num_hosts));
> +               pr_info("built %d host(s)\n", sdebug_num_hosts);
>
> -       /*
> -        * Even though all the hosts have been established, due to async device (LU) scanning
> -        * by the scsi mid-level, there may still be devices (LUs) being set up.
> -        */
>         return 0;
>
>  bus_unreg:
> @@ -7131,17 +7041,12 @@ static int __init scsi_debug_init(void)
>
>  static void __exit scsi_debug_exit(void)
>  {
> -       int k;
> +       int k = sdebug_num_hosts;
>
> -       /* Possible race with LUs still being set up; stop them asap */
> -       sdeb_block_all_queues();
> -       smp_store_release(&sdebug_deflect_incoming, true);
> -       stop_all_queued(false);
> -       for (k = 0; atomic_read(&sdebug_num_hosts) > 0; k++)
> +       stop_all_queued();
> +       for (; k; k--)
>                 sdebug_do_remove_host(true);
>         free_all_queued();
> -       if (sdebug_verbose)
> -               pr_info("removed %d hosts\n", k);
>         driver_unregister(&sdebug_driverfs_driver);
>         bus_unregister(&pseudo_lld_bus);
>         root_device_unregister(pseudo_primary);
> @@ -7311,13 +7216,13 @@ static int sdebug_add_host_helper(int per_host_idx)
>         sdbg_host->dev.bus = &pseudo_lld_bus;
>         sdbg_host->dev.parent = pseudo_primary;
>         sdbg_host->dev.release = &sdebug_release_adapter;
> -       dev_set_name(&sdbg_host->dev, "adapter%d", atomic_read(&sdebug_num_hosts));
> +       dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
>
>         error = device_register(&sdbg_host->dev);
>         if (error)
>                 goto clean;
>
> -       atomic_inc(&sdebug_num_hosts);
> +       ++sdebug_num_hosts;
>         return 0;
>
>  clean:
> @@ -7381,7 +7286,7 @@ static void sdebug_do_remove_host(bool the_end)
>                 return;
>
>         device_unregister(&sdbg_host->dev);
> -       atomic_dec(&sdebug_num_hosts);
> +       --sdebug_num_hosts;
>  }
>
>  static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
> @@ -7389,10 +7294,10 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
>         int num_in_q = 0;
>         struct sdebug_dev_info *devip;
>
> -       sdeb_block_all_queues();
> +       block_unblock_all_queues(true);
>         devip = (struct sdebug_dev_info *)sdev->hostdata;
>         if (NULL == devip) {
> -               sdeb_unblock_all_queues();
> +               block_unblock_all_queues(false);
>                 return  -ENODEV;
>         }
>         num_in_q = atomic_read(&devip->num_in_q);
> @@ -7411,7 +7316,7 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
>                 sdev_printk(KERN_INFO, sdev, "%s: qdepth=%d, num_in_q=%d\n",
>                             __func__, qdepth, num_in_q);
>         }
> -       sdeb_unblock_all_queues();
> +       block_unblock_all_queues(false);
>         return sdev->queue_depth;
>  }
>
>


-- 
Best Regards,
  Yi Zhang

