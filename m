Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A57C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 23:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiB0XTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 18:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiB0XTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 18:19:05 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E62020F53;
        Sun, 27 Feb 2022 15:18:27 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id 139so9940690pge.1;
        Sun, 27 Feb 2022 15:18:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0Ph/ZT2aWktwffC/2ax75T6epHj/LQx3vML/3EhsTbg=;
        b=MTVqiM5AjFCh35O+0awPqOC+tK9pxts7QxSUYC22s5Qj+jdBG5AysEsZ74E9PZ1bmU
         3D00gyHF7aLxtC64XXYKq2f0Z2BVRD/1NYZuw6fP+eiXNsUGKjbaAM5wYNUpVI+0ImZ/
         acpzJdHF9tIvX/8zoi+vbIzABHzOWQEKmJQ741/mN504OZLPFERupdHb/0EJSeRzAbwC
         eIt9YERRpe7QnbB/ZMH2/CzNLlW2pueXRF1lic66jplET5O930gZ+uxrOWnp5CzJlwLb
         jm/rToV8PSxcGRE+EFAq3FCKnbXvno8tJzfxdgDmBvhBGabeoFluYQcSoYcuZj3dPDgG
         OjdQ==
X-Gm-Message-State: AOAM531sVsIb5AJzuOMm9ri3j/hcmrCDVBlgUj/+CSopnKlYh870fD+J
        qjtn2j+dCppEy3/WfXS1ubibL6seWuYnSQ==
X-Google-Smtp-Source: ABdhPJykDXMXmg3Vn7UzfSjTt07+WmJm2wMMkwtiCmirVxZ4yYZxKCM7MKFklSGGCMn8i6Phbhpmpg==
X-Received: by 2002:a63:9d8c:0:b0:378:4b73:5b3b with SMTP id i134-20020a639d8c000000b003784b735b3bmr9675714pgd.564.1646003906694;
        Sun, 27 Feb 2022 15:18:26 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 63-20020a630942000000b00372a99c1821sm8287895pgj.21.2022.02.27.15.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 15:18:25 -0800 (PST)
Message-ID: <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org>
Date:   Sun, 27 Feb 2022 15:18:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: move more work to disk_release v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220227172144.508118-1-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220227172144.508118-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/22 09:21, Christoph Hellwig wrote:
> Hi all,
> 
> this series resurrects and forward ports ports larger parts of the
> "block: don't drain file system I/O on del_gendisk" series from Ming,
> but does not remove the draining in del_gendisk, but instead the one
> in the sd driver, which always was a bit ad-hoc.  As part of that sd
> and sr are switched to use the new ->free_disk method to avoid having
> to clear disk->private_data and the way to lookup the SCSI ULP is
> cleaned up as well.
> 
> Git branch:
> 
>      git://git.infradead.org/users/hch/block.git freeze-5.18

Hi Christoph,

Thanks for the quick respin. If I run blktests as follows:

$ use_siw=1 ./check -q

then the first report I hit with this branch is a deadlock report in
nvmet_rdma_free_queue(). That issue has already been reported - see also
https://lore.kernel.org/linux-nvme/CAHj4cs93BfTRgWF6PbuZcfq6AARHgYC2g=RQ-7Jgcf1-6h+2SQ@mail.gmail.com/

The second issue I run into with this branch is as follows
(also for nvmeof-mp/002):

==================================================================
BUG: KASAN: null-ptr-deref in __blk_account_io_start+0x28/0xa0
Read of size 8 at addr 0000000000000008 by task kworker/0:1H/159

CPU: 0 PID: 159 Comm: kworker/0:1H Not tainted 5.17.0-rc2-dbg+ #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
Workqueue: kblockd blk_mq_requeue_work
Call Trace:
  <TASK>
  show_stack+0x52/0x58
  ? __blk_account_io_start+0x28/0xa0
  dump_stack_lvl+0x5b/0x82
  kasan_report.cold+0x64/0xdb
  ? __blk_account_io_start+0x28/0xa0
  __asan_load8+0x69/0x90
  __blk_account_io_start+0x28/0xa0
  blk_insert_cloned_request+0x107/0x3b0
  map_request+0x260/0x3c0 [dm_mod]
  ? dm_requeue_original_request+0x1a0/0x1a0 [dm_mod]
  ? blk_add_timer+0xc3/0x110
  dm_mq_queue_rq+0x207/0x400 [dm_mod]
  ? kasan_set_track+0x25/0x30
  ? kasan_set_free_info+0x24/0x40
  ? map_request+0x3c0/0x3c0 [dm_mod]
  ? nvmet_rdma_release_rsp+0xb3/0x3f0 [nvmet_rdma]
  ? nvmet_rdma_send_done+0x4a/0x70 [nvmet_rdma]
  ? __ib_process_cq+0x11b/0x3c0 [ib_core]
  ? ib_cq_poll_work+0x37/0xb0 [ib_core]
  ? process_one_work+0x594/0xad0
  ? worker_thread+0x2de/0x6b0
  ? kthread+0x15f/0x190
  ? ret_from_fork+0x1f/0x30
  blk_mq_dispatch_rq_list+0x344/0xc00
  ? blk_mq_mark_tag_wait+0x470/0x470
  ? rcu_read_lock_sched_held+0x16/0x80
  __blk_mq_sched_dispatch_requests+0x19b/0x280
  ? blk_mq_do_dispatch_ctx+0x3f0/0x3f0
  ? rcu_read_lock_sched_held+0x16/0x80
  blk_mq_sched_dispatch_requests+0x8a/0xc0
  __blk_mq_run_hw_queue+0x99/0x220
  __blk_mq_delay_run_hw_queue+0x372/0x3a0
  ? blk_mq_run_hw_queue+0xd7/0x2b0
  ? rcu_read_lock_sched_held+0x16/0x80
  blk_mq_run_hw_queue+0x1d6/0x2b0
  blk_mq_run_hw_queues+0xa0/0x1e0
  blk_mq_requeue_work+0x2e4/0x330
  ? blk_mq_try_issue_directly+0x60/0x60
  ? lock_acquire+0x76/0x1a0
  process_one_work+0x594/0xad0
  ? pwq_dec_nr_in_flight+0x120/0x120
  ? do_raw_spin_lock+0x115/0x1b0
  ? lock_acquire+0x76/0x1a0
  worker_thread+0x2de/0x6b0
  ? trace_hardirqs_on+0x2b/0x120
  ? process_one_work+0xad0/0xad0
  kthread+0x15f/0x190
  ? kthread_complete_and_exit+0x30/0x30
  ret_from_fork+0x1f/0x30
  </TASK>
==================================================================
