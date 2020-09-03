Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF7DC433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 19:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1BC2137B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 19:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgICT3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:29:04 -0400
Received: from smtp.infotech.no ([82.134.31.41]:54426 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgICT3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Sep 2020 15:29:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 210B620418E;
        Thu,  3 Sep 2020 21:28:59 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bsyRkBUWlmm6; Thu,  3 Sep 2020 21:28:51 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 2B35620417A;
        Thu,  3 Sep 2020 21:28:47 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        ming.lei@redhat.com, bvanassche@acm.org, paolo.valente@linaro.org,
        hare@suse.de, hch@lst.de
Cc:     sumit.saxena@broadcom.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, megaraidlinux.pdl@broadcom.com,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <18bdfa01-9e08-60b1-3eb8-cb395d639935@interlog.com>
Date:   Thu, 3 Sep 2020 15:28:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-19 11:20 a.m., John Garry wrote:
> Hi all,
> 
> Here is v8 of the patchset.
> 
> In this version of the series, we keep the shared sbitmap for driver tags,
> and introduce changes to fix up the tag budgeting across request queues.
> We also have a change to count requests per-hctx for when an elevator is
> enabled, as an optimisation. I also dropped the debugfs changes - more on
> that below.
> 
> Some performance figures:
> 
> Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are included,
> but it is not always an appropriate scheduler to use.
> 
> Tag depth 		4000 (default)			260**
> 
> Baseline (v5.9-rc1):
> none sched:		2094K IOPS			513K
> mq-deadline sched:	2145K IOPS			1336K
> 
> Final, host_tagset=0 in LLDD *, ***:
> none sched:		2120K IOPS			550K
> mq-deadline sched:	2121K IOPS			1309K
> 
> Final ***:
> none sched:		2132K IOPS			1185			
> mq-deadline sched:	2145K IOPS			2097	
> 
> * this is relevant as this is the performance in supporting but not
>    enabling the feature
> ** depth=260 is relevant as some point where we are regularly waiting for
>     tags to be available. Figures were are a bit unstable here.
> *** Included "[PATCH V4] scsi: core: only re-run queue in
>      scsi_end_request() if device queue is busy"
> 
> A copy of the patches can be found here:
> https://github.com/hisilicon/kernel-dev/tree/private-topic-blk-mq-shared-tags-v8
> 
> The hpsa patch depends on:
> https://lore.kernel.org/linux-scsi/20200430131904.5847-1-hare@suse.de/
> 
> And the smartpqi patch is not to be accepted.
> 
> Comments (and testing) welcome, thanks!

I tested this v8 patchset on MKP's 5.10/scsi-queue branch together with
my rewritten sg driver on my laptop and a Ryzen 5 3600 machine. Since I
don't have same hardware, I use the scsi_debug driver as the target:

    modprobe scsi_debug dev_size_mb=1024 sector_size=512 add_host=7 
per_host_store=1 ndelay=1000 random=1 submit_queues=12

My test is a script which runs these three commands many times with
differing parameters:

sg_mrq_dd iflag=random bs=512 of=/dev/sg8 thr=64 time=2
time to transfer data was 0.312705 secs, 3433.72 MB/sec
2097152+0 records in
2097152+0 records out

sg_mrq_dd bpt=256 thr=64 mrq=36 time=2 if=/dev/sg8 bs=512 of=/dev/sg9
time to transfer data was 0.212090 secs, 5062.67 MB/sec
2097152+0 records in
2097152+0 records out

sg_mrq_dd --verify if=/dev/sg8 of=/dev/sg9 bs=512 bpt=256 thr=64 mrq=36 time=2
Doing verify/cmp rather than copy
time to transfer data was 0.184563 secs, 5817.75 MB/sec
2097152+0 records in
2097152+0 records verified

The above is the output from last section of the my script run on the Ryzen 5.

So the three steps are:
    1) produce random data on /dev/sg8
    2) copy /dev/sg8 to /dev/sg9
    3) verify /dev/sg8 and /dev/sg9 are the same.

The latter step is done with a sequence of READ(/dev/sg8) and
VERIFY(BYTCHK=1 on /dev/sg9). The "mrq" stands for multiple requests (in
one invocation; the bsg driver did that before its write(2) command was
removed.
The SCSI devices on the Ryzen 5 machine are:

# lsscsi -gs
[2:0:0:0]  disk    IBM-207x HUSMM8020ASS20   J4B6  /dev/sda   /dev/sg0   200GB
[2:0:1:0]  disk    SEAGATE  ST200FM0073      0007  /dev/sdb   /dev/sg1   200GB
[2:0:2:0]  enclosu Areca Te ARC-802801.37.69 0137  -          /dev/sg2       -
[3:0:0:0]  disk    Linux    scsi_debug       0190  /dev/sdc   /dev/sg3  1.07GB
[4:0:0:0]  disk    Linux    scsi_debug       0190  /dev/sdd   /dev/sg4  1.07GB
[5:0:0:0]  disk    Linux    scsi_debug       0190  /dev/sde   /dev/sg5  1.07GB
[6:0:0:0]  disk    Linux    scsi_debug       0190  /dev/sdf   /dev/sg6  1.07GB
[7:0:0:0]  disk    Linux    scsi_debug       0190  /dev/sdg   /dev/sg7  1.07GB
[8:0:0:0]  disk    Linux    scsi_debug       0190  /dev/sdh   /dev/sg8  1.07GB
[9:0:0:0]  disk    Linux    scsi_debug       0190  /dev/sdi   /dev/sg9  1.07GB
[N:0:1:1]  disk    WDC WDS250G2B0C-00PXH0__1       /dev/nvme0n1  -      250GB

My script took 17m12 and the highest throughput (on a copy) was 7.5 GB/sec.
Then I reloaded the scsi_debug module, this time with an additional
'host_max_queue=128' parameter. The script run time was 5 seconds shorter
and the maximum throughput was around 7.6 GB/sec. [Average throughput is
around 4 GB/sec.]

For comparison:

# time liburing/examples/io_uring-cp /dev/sdh /dev/sdi
real	0m1.542s
user	0m0.004s
sys	0m1.027s

Umm, that's less then 1 GB/sec. In its defence io_uring-cp is an
extremely simple, single threaded, proof-of-concept copy program,
at least compared to sg_mrq_dd . As used by the sg_mrq_dd the
rewritten sg driver bypasses moving 1 GB to and from the _user_
space while doing the above copy and verify steps.

So:

Tested-by: Douglas Gilbert <dgilbert@interlog.com>

> Differences to v7:
> - Add null_blk and scsi_debug support
> - Drop debugfs tags patch - it's too difficult to be the same between
> hostwide and non-hostwide, as discussed:
> https://lore.kernel.org/linux-scsi/1591810159-240929-1-git-send-email-john.garry@huawei.com/T/#mb3eb462d8be40273718505989abd12f8228c15fd
> And from commit 6bf0eb550452 ("sbitmap: Consider cleared bits in
> sbitmap_bitmap_show()"), I guess not many used this anyway...
> - Add elevator per-hctx request count for optimisation
> - Break up "blk-mq: rename blk_mq_update_tag_set_depth()" into 2x patches
> - Pass flags for avoid per-hq queue tags init/free for hostwide tags
> - Add Don's reviewed-tag and tested-by tags to appropiate patches
> 	- (@Don, please let me know if issue with how I did this)
> - Add "scsi: core: Show nr_hw_queues in sysfs"
> - Rework megaraid SAS patch to have module param (Kashyap)
> - rebase
> 
> V7 is here for more info:
> https://lore.kernel.org/linux-scsi/1591810159-240929-1-git-send-email-john.garry@huawei.com/T/#t
> 
> Hannes Reinecke (5):
>    blk-mq: Rename blk_mq_update_tag_set_depth()
>    blk-mq: Free tags in blk_mq_init_tags() upon error
>    scsi: Add host and host template flag 'host_tagset'
>    hpsa: enable host_tagset and switch to MQ
>    smartpqi: enable host tagset
> 
> John Garry (10):
>    blk-mq: Pass flags for tag init/free
>    blk-mq: Use pointers for blk_mq_tags bitmap tags
>    blk-mq: Facilitate a shared sbitmap per tagset
>    blk-mq: Relocate hctx_may_queue()
>    blk-mq: Record nr_active_requests per queue for when using shared
>      sbitmap
>    blk-mq: Record active_queues_shared_sbitmap per tag_set for when using
>      shared sbitmap
>    null_blk: Support shared tag bitmap
>    scsi: core: Show nr_hw_queues in sysfs
>    scsi: hisi_sas: Switch v3 hw to MQ
>    scsi: scsi_debug: Support host tagset
> 
> Kashyap Desai (2):
>    blk-mq, elevator: Count requests per hctx to improve performance
>    scsi: megaraid_sas: Added support for shared host tagset for
>      cpuhotplug
> 
> Ming Lei (1):
>    blk-mq: Rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED
> 
>   block/bfq-iosched.c                         |   9 +-
>   block/blk-core.c                            |   2 +
>   block/blk-mq-debugfs.c                      |  10 +-
>   block/blk-mq-sched.c                        |  13 +-
>   block/blk-mq-tag.c                          | 149 ++++++++++++++------
>   block/blk-mq-tag.h                          |  56 +++-----
>   block/blk-mq.c                              |  81 +++++++----
>   block/blk-mq.h                              |  76 +++++++++-
>   block/kyber-iosched.c                       |   4 +-
>   block/mq-deadline.c                         |   6 +
>   drivers/block/null_blk_main.c               |   6 +
>   drivers/block/rnbd/rnbd-clt.c               |   2 +-
>   drivers/scsi/hisi_sas/hisi_sas.h            |   3 +-
>   drivers/scsi/hisi_sas/hisi_sas_main.c       |  36 ++---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  87 +++++-------
>   drivers/scsi/hosts.c                        |   1 +
>   drivers/scsi/hpsa.c                         |  44 +-----
>   drivers/scsi/hpsa.h                         |   1 -
>   drivers/scsi/megaraid/megaraid_sas_base.c   |  39 +++++
>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  29 ++--
>   drivers/scsi/scsi_debug.c                   |  28 ++--
>   drivers/scsi/scsi_lib.c                     |   2 +
>   drivers/scsi/scsi_sysfs.c                   |  11 ++
>   drivers/scsi/smartpqi/smartpqi_init.c       |  45 ++++--
>   include/linux/blk-mq.h                      |  13 +-
>   include/linux/blkdev.h                      |   3 +
>   include/scsi/scsi_host.h                    |   9 +-
>   27 files changed, 484 insertions(+), 281 deletions(-)
> 

