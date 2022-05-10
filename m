Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F9FC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 11:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbiEJLYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 07:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240912AbiEJLY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 07:24:29 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB8A1BDDBF;
        Tue, 10 May 2022 04:20:25 -0700 (PDT)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KyFqc0SLRz6GD99;
        Tue, 10 May 2022 19:17:00 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 10 May 2022 13:20:23 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 10 May 2022 12:20:20 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <linux-block@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [RFC PATCH 0/2] sbitmap: NUMA node spreading
Date:   Tue, 10 May 2022 19:14:32 +0800
Message-ID: <1652181274-136198-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens, guys,

I am sending this as an RFC to see if there is any future in it or ideas
on how to make better. I also need to improve some items (as mentioned in
2/2 commit message) and test a lot more.

The general idea is that we change from allocating a single array of
sbitmap words to allocating an sub-array per NUMA node. And then each CPU
in that node is hinted to use that sub-array

Initial performance looks decent.

Some figures:
System: 4-nodes (with memory on all nodes), 128 CPUs

null blk config block:
20 devs, submit_queues=NR_CPUS, shared_tags, shared_tag_bitmap,
hw_queue_depth=256

fio config:
bs=4096, iodepth=128, numjobs=10, cpus_allowed_policy=split, rw=read,
ioscheduler=none

Before:
7130K

After:
7630K

So a +7% IOPS gain.

Any comments welcome, thanks!.

Based on v5.18-rc6.

John Garry (2):
  sbitmap: Make sbitmap.map a double pointer
  sbitmap: Spread sbitmap word allocation over NUMA nodes

 include/linux/sbitmap.h | 16 +++++---
 lib/sbitmap.c           | 83 +++++++++++++++++++++++++++++++++--------
 2 files changed, 79 insertions(+), 20 deletions(-)

-- 
2.26.2

