Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91109C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 03:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66CBF61244
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 03:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhDODsL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 23:48:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229450AbhDODrg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 23:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618458433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9jSqb33EY7thr7Yt+IK/cqge4xS3D0pNsyJNE3RFO1Q=;
        b=YBQhIRBQvJInW9CIwK5bseXZ0/fGx/ShYgCsQF11C3i17PzMHCrKYQwP1eW9r1f14mOM1M
        wPNRrYt+8FMzRz21CajDnRruB13Fb37WhwofzeZ+TRe0cMvhUauYCHTTsycSxVR5NpnJ6Y
        x21m1F6SnLQx4c3DVZdckNgWirtbqc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-96Iz6CuLOiCubReTARI_ww-1; Wed, 14 Apr 2021 23:47:09 -0400
X-MC-Unique: 96Iz6CuLOiCubReTARI_ww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 406BE801F98;
        Thu, 15 Apr 2021 03:47:08 +0000 (UTC)
Received: from T590 (ovpn-12-113.pek2.redhat.com [10.72.12.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C67666087C;
        Thu, 15 Apr 2021 03:47:04 +0000 (UTC)
Date:   Thu, 15 Apr 2021 11:46:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YHe3M62agQET6o6O@T590>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
 <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 14, 2021 at 01:06:25PM +0100, John Garry wrote:
> On 14/04/2021 12:12, Ming Lei wrote:
> > On Wed, Apr 14, 2021 at 04:12:22PM +0530, Kashyap Desai wrote:
> > > > Hi Ming,
> > > > 
> > > > > It is reported inside RH that CPU utilization is increased ~20% when
> > > > > running simple FIO test inside VM which disk is built on image stored
> > > > > on XFS/megaraid_sas.
> > > > > 
> > > > > When I try to investigate by reproducing the issue via scsi_debug, I
> > > > > found IO hang when running randread IO(8k, direct IO, libaio) on
> > > > > scsi_debug disk created by the following command:
> > > > > 
> > > > > 	modprobe scsi_debug host_max_queue=128
> > > > submit_queues=$NR_CPUS
> > > > > virtual_gb=256
> > > > > 
> > > > So I can recreate this hang for using mq-deadline IO sched for scsi debug,
> > > > in
> > > > that fio does not exit. I'm using v5.12-rc7.
> > > I can also recreate this issue using mq-deadline. Using <none>, there is no
> > > IO hang issue.
> > > Also if I run script to change scheduler periodically (none, mq-deadline),
> > > sysfs entry hangs.
> > > 
> > > Here is call trace-
> > > Call Trace:
> > > [ 1229.879862]  __schedule+0x29d/0x7a0
> > > [ 1229.879871]  schedule+0x3c/0xa0
> > > [ 1229.879875]  blk_mq_freeze_queue_wait+0x62/0x90
> > > [ 1229.879880]  ? finish_wait+0x80/0x80
> > > [ 1229.879884]  elevator_switch+0x12/0x40
> > > [ 1229.879888]  elv_iosched_store+0x79/0x120
> > > [ 1229.879892]  ? kernfs_fop_write_iter+0xc7/0x1b0
> > > [ 1229.879897]  queue_attr_store+0x42/0x70
> > > [ 1229.879901]  kernfs_fop_write_iter+0x11f/0x1b0
> > > [ 1229.879905]  new_sync_write+0x11f/0x1b0
> > > [ 1229.879912]  vfs_write+0x184/0x250
> > > [ 1229.879915]  ksys_write+0x59/0xd0
> > > [ 1229.879917]  do_syscall_64+0x33/0x40
> > > [ 1229.879922]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > 
> > > 
> > > I tried both - 5.12.0-rc1 and 5.11.0-rc2+ and there is a same behavior.
> > > Let me also check  megaraid_sas and see if anything generic or this is a
> > > special case of scsi_debug.
> > As I mentioned, it could be one generic issue wrt. SCHED_RESTART.
> > shared tags might have to restart all hctx since all share same tags.
> 
> I tested on hisi_sas v2 hw (which now sets host_tagset), and can reproduce.
> Seems to be combination of mq-deadline and fio rw=randread settings required
> to reproduce from limited experiments.
> 
> Incidentally, about the mq-deadline vs none IO scheduler on the same host, I
> get this with 6x SAS SSD:
> 
> rw=read
> 		CPU util			IOPs
> mq-deadline	usr=26.80%, sys=52.78%		650K
> none		usr=22.99%, sys=74.10%		475K
> 
> rw=randread
> 		CPU util			IOPs
> mq-deadline	usr=21.72%, sys=44.18%,		423K
> none		usr=23.15%, sys=74.01%		450K

Today I re-run the scsi_debug test on two server hardwares(32cores, dual
numa nodes), and the CPU utilization issue can be reproduced, follow
the test result:

1) randread test on ibm-x3850x6[*] with deadline

              |IOPS    | FIO CPU util 
------------------------------------------------
hosttags      | 94k    | usr=1.13%, sys=14.75%
------------------------------------------------
non hosttags  | 124k   | usr=1.12%, sys=10.65%,


2) randread test on ibm-x3850x6[*] with none
              |IOPS    | FIO CPU util 
------------------------------------------------
hosttags      | 120k   | usr=0.89%, sys=6.55%
------------------------------------------------
non hosttags  | 121k   | usr=1.07%, sys=7.35%
------------------------------------------------

 *:
 	- that is the machine Yanhui reported VM cpu utilization increased by 20% 
	- kernel: latest linus tree(v5.12-rc7, commit: 7f75285ca57)
	- also run same test on another 32cores machine, IOPS drop isn't
	  observed, but CPU utilization is increased obviously

3) test script
#/bin/bash

run_fio() {
	RTIME=$1
	JOBS=$2
	DEVS=$3
	BS=$4

	QD=64
	BATCH=16

	fio --bs=$BS --ioengine=libaio \
		--iodepth=$QD \
	    --iodepth_batch_submit=$BATCH \
		--iodepth_batch_complete_min=$BATCH \
		--filename=$DEVS \
		--direct=1 --runtime=$RTIME --numjobs=$JOBS --rw=randread \
		--name=test --group_reporting
}

SCHED=$1

NRQS=`getconf _NPROCESSORS_ONLN`

rmmod scsi_debug
modprobe scsi_debug host_max_queue=128 submit_queues=$NRQS virtual_gb=256
sleep 2
DEV=`lsscsi | grep scsi_debug | awk '{print $6}'`
echo $SCHED > /sys/block/`basename $DEV`/queue/scheduler
echo 128 > /sys/block/`basename $DEV`/device/queue_depth
run_fio 20 16 $DEV 8K


rmmod scsi_debug
modprobe scsi_debug max_queue=128 submit_queues=1 virtual_gb=256
sleep 2
DEV=`lsscsi | grep scsi_debug | awk '{print $6}'`
echo $SCHED > /sys/block/`basename $DEV`/queue/scheduler
echo 128 > /sys/block/`basename $DEV`/device/queue_depth
run_fio 20 16 $DEV 8k



Thanks,
Ming

