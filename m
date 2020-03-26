Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A2DC2D0E7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 05:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A4D320772
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 05:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYebTwTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgCZFYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 01:24:53 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45857 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCZFYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 01:24:53 -0400
Received: by mail-lj1-f196.google.com with SMTP id t17so5050647ljc.12;
        Wed, 25 Mar 2020 22:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4hbK2sRM/2qMEKEHr0VWPHZaJTVVsh6dWgl4zgMyPS0=;
        b=kYebTwTSauykNnNwPDIaR0e714W4pjqSWUVoYl/taMGLuW8PJqu4mQILu2jdcVdAFu
         tu6XQleXoMcB2KY+Q3sOGT08pGSr/EwgaNAQD6hwC52+Z2cgQofwKeILQvMOxs6/IlHt
         CVFSX+P2rjyxsTebqgxwqBLlQ3jHJmekEG7PPnUU0oO0NDC/5yuP2fgoYJcCrlyo9tGM
         30HgWZfnywzyRTyGtYNlq7AfQrvutsBUQC5tTRuBJuiv2PB/1GKlg0fOGzM7+c4WqeSy
         cn+OGctE0eCoNSKkDRe0L2+BKFQdlbTZkdb80bCovw3lTXulCEk6ejeG1uIMHV5/AaWR
         xNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4hbK2sRM/2qMEKEHr0VWPHZaJTVVsh6dWgl4zgMyPS0=;
        b=aejgWiPmQ32eBy8VZ1Jlgjty2Hviv4P1w02CWzOdOIVTUpsxTcKQgY+fZj9hYvsJoS
         y/+sj6lP2Rl74w51JAUoXRwTQNMx3HFhdKOxevC883+N1VcSgzudprm/FWvBXYvm6JKN
         GLXj7K801W93Udf4Jk588KLsqs8sHStBK98Wd9C9D+NEqAS9adnbUZCH/6YWOh8CPt1W
         edEA/9C+DwKNSLNvK/P/rQwhdAhKAtKp1GIN/++crTykO6Og/2+gVxps4MamsiGbJK0g
         JRdqNKBOoKLkDOArxDpwWBVK/P1fryjPRzkt2+PYmSMN+wnyNUTj/XSjeor9lxpIeEnt
         5e5g==
X-Gm-Message-State: AGi0PuaZXhVE1R3nKb+NlncqJxBoYDvr7QIZ797IaYnhzLjUVmfkXA6H
        agIk3Rso/nTj6G9s8BMrhS7ZzUBEUancJ+tH7iI=
X-Google-Smtp-Source: APiQypIQ5SmKAhPmnjecjvJJ+j5FWIBWG9xir1DQ52pJQ0B/2Ro+U/3nSyLENlT561UgtzUE0EfcRjzAAOjQpBfAnxE=
X-Received: by 2002:a2e:9a52:: with SMTP id k18mr3852346ljj.242.1585200288942;
 Wed, 25 Mar 2020 22:24:48 -0700 (PDT)
MIME-Version: 1.0
From:   Kyungtae Kim <kt0755@gmail.com>
Date:   Thu, 26 Mar 2020 01:24:37 -0400
Message-ID: <CAEAjamtSvxgNYqjN1NPrgM=NmcTUKoQdq+y1+Pf-8JJWH6Airg@mail.gmail.com>
Subject: memory leak in scsi_init_io
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     Dave Tian <dave.jing.tian@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We report a bug (in linux-5.5.13) found by FuzzUSB (a modified version
of syzkaller)

A memory buffer (i.e., struct scatterlist) is allocated, and not freed properly.
(not sure about the point where the allocated memory region is leaking.)

==================================================================
BUG: memory leak
unreferenced object 0xffff88805b337280 (size 256):
  comm "syz-executor.6", pid 5934, jiffies 4295016561 (age 16.340s)
  hex dump (first 32 bytes):
    00 46 5f 01 00 ea ff ff 00 00 00 00 00 10 00 00  .F_.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000006305194b>] kmemleak_alloc_recursive
2/./include/linux/kmemleak.h:43 [inline]
    [<000000006305194b>] slab_post_alloc_hook 2/mm/slab.h:586 [inline]
    [<000000006305194b>] slab_alloc_node 2/mm/slub.c:2767 [inline]
    [<000000006305194b>] slab_alloc 2/mm/slub.c:2775 [inline]
    [<000000006305194b>] kmem_cache_alloc+0x165/0x340 2/mm/slub.c:2780
    [<000000003f20764c>] mempool_alloc_slab+0x44/0x70 2/mm/mempool.c:513
    [<00000000561f62bb>] mempool_alloc+0x145/0x370 2/mm/mempool.c:393
    [<00000000322111ed>] sg_pool_alloc+0xe6/0x1a0 2/lib/sg_pool.c:67
    [<00000000b72ca391>] __sg_alloc_table+0xb0/0x370 2/lib/scatterlist.c:302
    [<00000000c61ae208>] sg_alloc_table_chained+0x6c/0x1c0 2/lib/sg_pool.c:132
    [<00000000cd52be39>] scsi_init_sgtable
2/drivers/scsi/scsi_lib.c:990 [inline]
    [<00000000cd52be39>] scsi_init_io+0x10e/0x340 2/drivers/scsi/scsi_lib.c:1025
    [<000000004dccec43>] sd_setup_read_write_cmnd
2/drivers/scsi/sd.c:1174 [inline]
    [<000000004dccec43>] sd_init_command+0xbdc/0x3400 2/drivers/scsi/sd.c:1290
    [<00000000644825df>] scsi_setup_fs_cmnd
2/drivers/scsi/scsi_lib.c:1211 [inline]
    [<00000000644825df>] scsi_setup_cmnd 2/drivers/scsi/scsi_lib.c:1229 [inline]
    [<00000000644825df>] scsi_mq_prep_fn 2/drivers/scsi/scsi_lib.c:1603 [inline]
    [<00000000644825df>] scsi_queue_rq+0xf18/0x2a30
2/drivers/scsi/scsi_lib.c:1671
    [<00000000d4c4c1c8>] blk_mq_dispatch_rq_list+0xa6e/0x1870
2/block/blk-mq.c:1238
    [<00000000e1d472b3>] blk_mq_do_dispatch_sched+0x198/0x3f0
2/block/blk-mq-sched.c:115
    [<000000002542d635>] blk_mq_sched_dispatch_requests+0x39a/0x600
2/block/blk-mq-sched.c:211
    [<000000000ffcbd69>] __blk_mq_run_hw_queue+0x12b/0x250 2/block/blk-mq.c:1368
    [<000000001cbeb84f>] __blk_mq_delay_run_hw_queue+0x467/0x4f0
2/block/blk-mq.c:1436
    [<000000003a7eefb7>] blk_mq_run_hw_queue+0x178/0x320 2/block/blk-mq.c:1473
    [<00000000bf63d47b>] blk_mq_get_tag+0x583/0xa00 2/block/blk-mq-tag.c:139
==================================================================
